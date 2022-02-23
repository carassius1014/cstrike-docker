.PHONY: format
format:
	git ls-files "*.nix" | xargs nixfmt

build:
	docker build -t hlds .

create:
	docker create \
		--name hlds \
		-p 27015:27015/udp \
		-p 27015:27015 \
		-v ${CSTRIKE_DIR}/gfx:/hlds/cstrike/gfx \
		-v ${CSTRIKE_DIR}/maps:/hlds/cstrike/maps \
		-v ${CSTRIKE_DIR}/models:/hlds/cstrike/models \
		-v ${CSTRIKE_DIR}/overviews:/hlds/cstrike/overviews \
		-v ${CZERO_DIR}/gfx:/hlds/czero/gfx \
		-v ${CZERO_DIR}/maps:/hlds/czero/maps \
		-v ${CZERO_DIR}/models:/hlds/czero/models \
		-v ${CZERO_DIR}/overviews:/hlds/czero/overviews \
		-v ${CZERO_DIR}/sound:/hlds/czero/sound \
		-v ${CZERO_DIR}/sprites:/hlds/czero/sprites \
		-v ${MAP}:/hlds/czero/start_map.txt \
		-v ${MAPCYCLE_TXT}:/hlds/czero/mapcycle.txt \
		-v ${SERVER_CFG}:/hlds/czero/server.cfg \
		hlds:latest &

start:
	docker start hlds

stop:
	docker stop hlds

cleanup:
	docker system prune
