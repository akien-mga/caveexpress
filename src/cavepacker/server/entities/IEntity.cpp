#include "IEntity.h"
#include "cavepacker/server/map/Map.h"
#include "engine/common/SpriteDefinition.h"
#include "engine/common/ConfigManager.h"

uint32_t IEntity::GLOBAL_ENTITY_NUM = 0;

IEntity::IEntity (const EntityType &type, Map& map, int col, int row) :
		_id(GLOBAL_ENTITY_NUM++), _type(type), _time(0), _map(map), _col(col), _row(row), _angle(0.0f)
{
	setSpriteID("");
}

IEntity::~IEntity ()
{
}

SpriteDefPtr IEntity::getSpriteDef () const
{
	const std::string& spriteName = SpriteDefinition::get().getSpriteName(_type, Animation::NONE);
	const SpriteDefPtr& def = SpriteDefinition::get().getSpriteDefinition(spriteName);
	return def;
}

float IEntity::getAngle () const
{
	return _angle;
}

bool IEntity::setPos (int col, int row)
{
	if (!_map.isFree(col, row))
		return false;
	if (_col != 0 && _row != 0) {
		const int x = col - _col;
		const int y = row - _row;
		if (x > 0) {
			_angle = 0.0;
		} else if (x < 0) {
			_angle = M_PI;
		} else if (y > 0) {
			_angle = M_PI_2;
		} else if (y < 0) {
			_angle = -M_PI_2;
		}
		info(LOG_SERVER, String::format("x: %i, y: %i", x, y));
	}
	_col = col;
	_row = row;
	_map.updateEntity(0, *this);
	return true;
}

void IEntity::update (uint32_t deltaTime)
{
	_time += deltaTime;
	for (EntityObservers::iterator i = _observers.begin(); i != _observers.end(); ++i) {
		(*i)->onUpdate(this);
	}
}

void IEntity::remove ()
{
}

void IEntity::onSpawn ()
{
}

std::string IEntity::toString () const
{
	std::stringstream s;
	s << *this;
	return s.str();
}

void IEntity::print (std::ostream &stream, int level) const
{
	stream << "IEntity[id: " << _id << ", type:" << _type.name;
	stream <<  ", col: " << _col << ", row: " << _row;
	stream << "]";
}
