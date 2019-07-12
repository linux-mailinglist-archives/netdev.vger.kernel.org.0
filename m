Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC60666CD
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 08:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGLGMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 02:12:07 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:50043 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbfGLGME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 02:12:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=41;SR=0;TI=SMTPD_---0TWfvuzR_1562911823;
Received: from localhost(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TWfvuzR_1562911823)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Jul 2019 14:10:24 +0800
From:   Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Alex Shi <alex.shi@linux.alibaba.com>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-tegra@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, xen-devel@lists.xenproject.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-scsi@vger.kernel.org, dc395x@twibble.org,
        esc.storagedev@microsemi.com, megaraidlinux.pdl@broadcom.com,
        osst-users@lists.sourceforge.net, linux-watchdog@vger.kernel.org
Subject: [RFC PATCH] Docs: move more driver,device related docs into drivers dir follows kernel source
Date:   Fri, 12 Jul 2019 14:10:02 +0800
Message-Id: <20190712061002.154235-1-alex.shi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.856.g8858448bb
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Could I have a proposal to move the following driver/devices dirs which
under Documentation/ into Documentation/drivers/, follows kernel source

acpi backlight  bus cpu-freq  device-mapper  driver-model gpio  hid
ide leds md memory  mmc nfc nvmem pcmcia scsi sound  watchdog
auxdisplay  blockdev   cdrom  crypto driver-api fpga  gpu
i2c  infiniband  lightnvm  media  misc  mtd  nvdimm  PCI  apidio
serial  usb

More docs and dirs could move into this dir later, that could make
Documenation dir much more clear, and don't cause trouble to find them.

If it's acceptable, we could do docs pointer redirect further.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: linux-pci@vger.kernel.org 
Cc: linux-doc@vger.kernel.org 
Cc: linux-kernel@vger.kernel.org 
Cc: linuxppc-dev@lists.ozlabs.org 
Cc: drbd-dev@lists.linbit.com 
Cc: linux-block@vger.kernel.org 
Cc: nbd@other.debian.org 
Cc: linux-ide@vger.kernel.org 
Cc: linux-pm@vger.kernel.org 
Cc: linux-crypto@vger.kernel.org 
Cc: keyrings@vger.kernel.org 
Cc: linux-wireless@vger.kernel.org 
Cc: linux-media@vger.kernel.org 
Cc: dri-devel@lists.freedesktop.org 
Cc: linaro-mm-sig@lists.linaro.org 
Cc: dmaengine@vger.kernel.org 
Cc: linux-edac@vger.kernel.org 
Cc: linux-fpga@vger.kernel.org 
Cc: linux-iio@vger.kernel.org 
Cc: linux-gpio@vger.kernel.org 
Cc: netdev@vger.kernel.org 
Cc: linux-s390@vger.kernel.org 
Cc: alsa-devel@alsa-project.org 
Cc: linux-usb@vger.kernel.org 
Cc: devel@driverdev.osuosl.org 
Cc: linux-arm-kernel@lists.infradead.org 
Cc: linux-amlogic@lists.infradead.org 
Cc: linux-tegra@vger.kernel.org 
Cc: intel-gfx@lists.freedesktop.org 
Cc: xen-devel@lists.xenproject.org 
Cc: linux-input@vger.kernel.org 
Cc: linux-i2c@vger.kernel.org 
Cc: linux-rdma@vger.kernel.org 
Cc: linux-leds@vger.kernel.org 
Cc: linux-scsi@vger.kernel.org 
Cc: dc395x@twibble.org 
Cc: esc.storagedev@microsemi.com 
Cc: megaraidlinux.pdl@broadcom.com 
Cc: osst-users@lists.sourceforge.net 
Cc: linux-watchdog@vger.kernel.org 
---
 Documentation/{ => drivers}/PCI/MSI-HOWTO.txt                     | 0
 Documentation/{ => drivers}/PCI/PCIEBUS-HOWTO.txt                 | 0
 Documentation/{ => drivers}/PCI/acpi-info.txt                     | 0
 .../{ => drivers}/PCI/endpoint/function/binding/pci-test.txt      | 0
 Documentation/{ => drivers}/PCI/endpoint/pci-endpoint-cfs.txt     | 0
 Documentation/{ => drivers}/PCI/endpoint/pci-endpoint.txt         | 0
 Documentation/{ => drivers}/PCI/endpoint/pci-test-function.txt    | 0
 Documentation/{ => drivers}/PCI/endpoint/pci-test-howto.txt       | 0
 Documentation/{ => drivers}/PCI/pci-error-recovery.txt            | 0
 Documentation/{ => drivers}/PCI/pci-iov-howto.txt                 | 0
 Documentation/{ => drivers}/PCI/pci.txt                           | 0
 Documentation/{ => drivers}/PCI/pcieaer-howto.txt                 | 0
 Documentation/{ => drivers}/acpi/dsd/leds.txt                     | 0
 Documentation/{ => drivers}/auxdisplay/cfag12864b                 | 0
 Documentation/{ => drivers}/auxdisplay/ks0108                     | 0
 Documentation/{ => drivers}/auxdisplay/lcd-panel-cgram.txt        | 0
 Documentation/{ => drivers}/backlight/lp855x-driver.txt           | 0
 .../{ => drivers}/blockdev/drbd/DRBD-8.3-data-packets.svg         | 0
 Documentation/{ => drivers}/blockdev/drbd/DRBD-data-packets.svg   | 0
 Documentation/{ => drivers}/blockdev/drbd/README.txt              | 0
 Documentation/{ => drivers}/blockdev/drbd/conn-states-8.dot       | 0
 Documentation/{ => drivers}/blockdev/drbd/data-structure-v9.txt   | 0
 Documentation/{ => drivers}/blockdev/drbd/disk-states-8.dot       | 0
 .../blockdev/drbd/drbd-connection-state-overview.dot              | 0
 Documentation/{ => drivers}/blockdev/drbd/node-states-8.dot       | 0
 Documentation/{ => drivers}/blockdev/floppy.txt                   | 0
 Documentation/{ => drivers}/blockdev/nbd.txt                      | 0
 Documentation/{ => drivers}/blockdev/paride.txt                   | 0
 Documentation/{ => drivers}/blockdev/ramdisk.txt                  | 0
 Documentation/{ => drivers}/blockdev/zram.txt                     | 0
 Documentation/{bus-devices => drivers/bus}/ti-gpmc.txt            | 0
 Documentation/{ => drivers}/cdrom/cdrom-standard.rst              | 0
 Documentation/{ => drivers}/cdrom/ide-cd.rst                      | 0
 Documentation/{ => drivers}/cdrom/index.rst                       | 0
 Documentation/{ => drivers}/cdrom/packet-writing.rst              | 0
 Documentation/{ => drivers}/cpu-freq/amd-powernow.txt             | 0
 Documentation/{ => drivers}/cpu-freq/core.txt                     | 0
 Documentation/{ => drivers}/cpu-freq/cpu-drivers.txt              | 0
 Documentation/{ => drivers}/cpu-freq/cpufreq-nforce2.txt          | 0
 Documentation/{ => drivers}/cpu-freq/cpufreq-stats.txt            | 0
 Documentation/{ => drivers}/cpu-freq/index.txt                    | 0
 Documentation/{ => drivers}/cpu-freq/pcc-cpufreq.txt              | 0
 Documentation/{ => drivers}/crypto/api-aead.rst                   | 0
 Documentation/{ => drivers}/crypto/api-akcipher.rst               | 0
 Documentation/{ => drivers}/crypto/api-digest.rst                 | 0
 Documentation/{ => drivers}/crypto/api-intro.txt                  | 0
 Documentation/{ => drivers}/crypto/api-kpp.rst                    | 0
 Documentation/{ => drivers}/crypto/api-rng.rst                    | 0
 Documentation/{ => drivers}/crypto/api-samples.rst                | 0
 Documentation/{ => drivers}/crypto/api-skcipher.rst               | 0
 Documentation/{ => drivers}/crypto/api.rst                        | 0
 Documentation/{ => drivers}/crypto/architecture.rst               | 0
 Documentation/{ => drivers}/crypto/asymmetric-keys.txt            | 0
 Documentation/{ => drivers}/crypto/async-tx-api.txt               | 0
 Documentation/{ => drivers}/crypto/conf.py                        | 0
 Documentation/{ => drivers}/crypto/crypto_engine.rst              | 0
 Documentation/{ => drivers}/crypto/descore-readme.txt             | 0
 Documentation/{ => drivers}/crypto/devel-algos.rst                | 0
 Documentation/{ => drivers}/crypto/index.rst                      | 0
 Documentation/{ => drivers}/crypto/intro.rst                      | 0
 Documentation/{ => drivers}/crypto/userspace-if.rst               | 0
 Documentation/{ => drivers}/device-mapper/cache-policies.rst      | 0
 Documentation/{ => drivers}/device-mapper/cache.rst               | 0
 Documentation/{ => drivers}/device-mapper/delay.rst               | 0
 Documentation/{ => drivers}/device-mapper/dm-crypt.rst            | 0
 Documentation/{ => drivers}/device-mapper/dm-dust.txt             | 0
 Documentation/{ => drivers}/device-mapper/dm-flakey.rst           | 0
 Documentation/{ => drivers}/device-mapper/dm-init.rst             | 0
 Documentation/{ => drivers}/device-mapper/dm-integrity.rst        | 0
 Documentation/{ => drivers}/device-mapper/dm-io.rst               | 0
 Documentation/{ => drivers}/device-mapper/dm-log.rst              | 0
 Documentation/{ => drivers}/device-mapper/dm-queue-length.rst     | 0
 Documentation/{ => drivers}/device-mapper/dm-raid.rst             | 0
 Documentation/{ => drivers}/device-mapper/dm-service-time.rst     | 0
 Documentation/{ => drivers}/device-mapper/dm-uevent.rst           | 0
 Documentation/{ => drivers}/device-mapper/dm-zoned.rst            | 0
 Documentation/{ => drivers}/device-mapper/era.rst                 | 0
 Documentation/{ => drivers}/device-mapper/index.rst               | 0
 Documentation/{ => drivers}/device-mapper/kcopyd.rst              | 0
 Documentation/{ => drivers}/device-mapper/linear.rst              | 0
 Documentation/{ => drivers}/device-mapper/log-writes.rst          | 0
 Documentation/{ => drivers}/device-mapper/persistent-data.rst     | 0
 Documentation/{ => drivers}/device-mapper/snapshot.rst            | 0
 Documentation/{ => drivers}/device-mapper/statistics.rst          | 0
 Documentation/{ => drivers}/device-mapper/striped.rst             | 0
 Documentation/{ => drivers}/device-mapper/switch.rst              | 0
 Documentation/{ => drivers}/device-mapper/thin-provisioning.rst   | 0
 Documentation/{ => drivers}/device-mapper/unstriped.rst           | 0
 Documentation/{ => drivers}/device-mapper/verity.rst              | 0
 Documentation/{ => drivers}/device-mapper/writecache.rst          | 0
 Documentation/{ => drivers}/device-mapper/zero.rst                | 0
 Documentation/{ => drivers}/driver-api/80211/cfg80211.rst         | 0
 Documentation/{ => drivers}/driver-api/80211/conf.py              | 0
 Documentation/{ => drivers}/driver-api/80211/index.rst            | 0
 Documentation/{ => drivers}/driver-api/80211/introduction.rst     | 0
 .../{ => drivers}/driver-api/80211/mac80211-advanced.rst          | 0
 Documentation/{ => drivers}/driver-api/80211/mac80211.rst         | 0
 Documentation/{ => drivers}/driver-api/acpi/index.rst             | 0
 Documentation/{ => drivers}/driver-api/acpi/linuxized-acpica.rst  | 0
 Documentation/{ => drivers}/driver-api/acpi/scan_handlers.rst     | 0
 Documentation/{ => drivers}/driver-api/basics.rst                 | 0
 Documentation/{ => drivers}/driver-api/clk.rst                    | 0
 Documentation/{ => drivers}/driver-api/component.rst              | 0
 Documentation/{ => drivers}/driver-api/conf.py                    | 0
 Documentation/{ => drivers}/driver-api/device-io.rst              | 0
 Documentation/{ => drivers}/driver-api/device_connection.rst      | 0
 Documentation/{ => drivers}/driver-api/device_link.rst            | 0
 Documentation/{ => drivers}/driver-api/dma-buf.rst                | 0
 Documentation/{ => drivers}/driver-api/dmaengine/client.rst       | 0
 Documentation/{ => drivers}/driver-api/dmaengine/dmatest.rst      | 0
 Documentation/{ => drivers}/driver-api/dmaengine/index.rst        | 0
 Documentation/{ => drivers}/driver-api/dmaengine/provider.rst     | 0
 Documentation/{ => drivers}/driver-api/dmaengine/pxa_dma.rst      | 0
 Documentation/{ => drivers}/driver-api/edac.rst                   | 0
 Documentation/{ => drivers}/driver-api/firewire.rst               | 0
 Documentation/{ => drivers}/driver-api/firmware/built-in-fw.rst   | 0
 Documentation/{ => drivers}/driver-api/firmware/core.rst          | 0
 .../{ => drivers}/driver-api/firmware/direct-fs-lookup.rst        | 0
 .../{ => drivers}/driver-api/firmware/fallback-mechanisms.rst     | 0
 .../{ => drivers}/driver-api/firmware/firmware_cache.rst          | 0
 .../{ => drivers}/driver-api/firmware/fw_search_path.rst          | 0
 Documentation/{ => drivers}/driver-api/firmware/index.rst         | 0
 Documentation/{ => drivers}/driver-api/firmware/introduction.rst  | 0
 Documentation/{ => drivers}/driver-api/firmware/lookup-order.rst  | 0
 .../{ => drivers}/driver-api/firmware/other_interfaces.rst        | 0
 .../{ => drivers}/driver-api/firmware/request_firmware.rst        | 0
 Documentation/{ => drivers}/driver-api/fpga/fpga-bridge.rst       | 0
 Documentation/{ => drivers}/driver-api/fpga/fpga-mgr.rst          | 0
 Documentation/{ => drivers}/driver-api/fpga/fpga-programming.rst  | 0
 Documentation/{ => drivers}/driver-api/fpga/fpga-region.rst       | 0
 Documentation/{ => drivers}/driver-api/fpga/index.rst             | 0
 Documentation/{ => drivers}/driver-api/fpga/intro.rst             | 0
 Documentation/{ => drivers}/driver-api/frame-buffer.rst           | 0
 Documentation/{ => drivers}/driver-api/generic-counter.rst        | 0
 Documentation/{ => drivers}/driver-api/gpio/board.rst             | 0
 Documentation/{ => drivers}/driver-api/gpio/consumer.rst          | 0
 Documentation/{ => drivers}/driver-api/gpio/driver.rst            | 0
 Documentation/{ => drivers}/driver-api/gpio/drivers-on-gpio.rst   | 0
 Documentation/{ => drivers}/driver-api/gpio/index.rst             | 0
 Documentation/{ => drivers}/driver-api/gpio/intro.rst             | 0
 Documentation/{ => drivers}/driver-api/gpio/legacy.rst            | 0
 Documentation/{ => drivers}/driver-api/hsi.rst                    | 0
 Documentation/{ => drivers}/driver-api/i2c.rst                    | 0
 Documentation/{ => drivers}/driver-api/i3c/device-driver-api.rst  | 0
 Documentation/{ => drivers}/driver-api/i3c/index.rst              | 0
 Documentation/{ => drivers}/driver-api/i3c/master-driver-api.rst  | 0
 Documentation/{ => drivers}/driver-api/i3c/protocol.rst           | 0
 Documentation/{ => drivers}/driver-api/iio/buffers.rst            | 0
 Documentation/{ => drivers}/driver-api/iio/core.rst               | 0
 Documentation/{ => drivers}/driver-api/iio/hw-consumer.rst        | 0
 Documentation/{ => drivers}/driver-api/iio/index.rst              | 0
 Documentation/{ => drivers}/driver-api/iio/intro.rst              | 0
 Documentation/{ => drivers}/driver-api/iio/triggered-buffers.rst  | 0
 Documentation/{ => drivers}/driver-api/iio/triggers.rst           | 0
 Documentation/{ => drivers}/driver-api/index.rst                  | 0
 Documentation/{ => drivers}/driver-api/infrastructure.rst         | 0
 Documentation/{ => drivers}/driver-api/input.rst                  | 0
 Documentation/{ => drivers}/driver-api/libata.rst                 | 0
 Documentation/{ => drivers}/driver-api/message-based.rst          | 0
 Documentation/{ => drivers}/driver-api/misc_devices.rst           | 0
 Documentation/{ => drivers}/driver-api/miscellaneous.rst          | 0
 Documentation/{ => drivers}/driver-api/mtdnand.rst                | 0
 Documentation/{ => drivers}/driver-api/pci/index.rst              | 0
 Documentation/{ => drivers}/driver-api/pci/p2pdma.rst             | 0
 Documentation/{ => drivers}/driver-api/pci/pci.rst                | 0
 Documentation/{ => drivers}/driver-api/pinctl.rst                 | 0
 Documentation/{ => drivers}/driver-api/pm/conf.py                 | 0
 Documentation/{ => drivers}/driver-api/pm/cpuidle.rst             | 0
 Documentation/{ => drivers}/driver-api/pm/devices.rst             | 0
 Documentation/{ => drivers}/driver-api/pm/index.rst               | 0
 Documentation/{ => drivers}/driver-api/pm/notifiers.rst           | 0
 Documentation/{ => drivers}/driver-api/pm/types.rst               | 0
 Documentation/{ => drivers}/driver-api/pps.rst                    | 0
 Documentation/{ => drivers}/driver-api/ptp.rst                    | 0
 Documentation/{ => drivers}/driver-api/rapidio.rst                | 0
 Documentation/{ => drivers}/driver-api/regulator.rst              | 0
 Documentation/{ => drivers}/driver-api/s390-drivers.rst           | 0
 Documentation/{ => drivers}/driver-api/scsi.rst                   | 0
 Documentation/{ => drivers}/driver-api/slimbus.rst                | 0
 Documentation/{ => drivers}/driver-api/sound.rst                  | 0
 .../{ => drivers}/driver-api/soundwire/error_handling.rst         | 0
 Documentation/{ => drivers}/driver-api/soundwire/index.rst        | 0
 Documentation/{ => drivers}/driver-api/soundwire/locking.rst      | 0
 Documentation/{ => drivers}/driver-api/soundwire/stream.rst       | 0
 Documentation/{ => drivers}/driver-api/soundwire/summary.rst      | 0
 Documentation/{ => drivers}/driver-api/spi.rst                    | 0
 Documentation/{ => drivers}/driver-api/target.rst                 | 0
 Documentation/{ => drivers}/driver-api/uio-howto.rst              | 0
 Documentation/{ => drivers}/driver-api/usb/URB.rst                | 0
 Documentation/{ => drivers}/driver-api/usb/anchors.rst            | 0
 Documentation/{ => drivers}/driver-api/usb/bulk-streams.rst       | 0
 Documentation/{ => drivers}/driver-api/usb/callbacks.rst          | 0
 Documentation/{ => drivers}/driver-api/usb/dma.rst                | 0
 Documentation/{ => drivers}/driver-api/usb/dwc3.rst               | 0
 Documentation/{ => drivers}/driver-api/usb/error-codes.rst        | 0
 Documentation/{ => drivers}/driver-api/usb/gadget.rst             | 0
 Documentation/{ => drivers}/driver-api/usb/hotplug.rst            | 0
 Documentation/{ => drivers}/driver-api/usb/index.rst              | 0
 Documentation/{ => drivers}/driver-api/usb/persist.rst            | 0
 Documentation/{ => drivers}/driver-api/usb/power-management.rst   | 0
 Documentation/{ => drivers}/driver-api/usb/typec.rst              | 0
 Documentation/{ => drivers}/driver-api/usb/typec_bus.rst          | 0
 Documentation/{ => drivers}/driver-api/usb/usb.rst                | 0
 Documentation/{ => drivers}/driver-api/usb/usb3-debug-port.rst    | 0
 .../{ => drivers}/driver-api/usb/writing_musb_glue_layer.rst      | 0
 Documentation/{ => drivers}/driver-api/usb/writing_usb_driver.rst | 0
 Documentation/{ => drivers}/driver-api/vme.rst                    | 0
 Documentation/{ => drivers}/driver-api/w1.rst                     | 0
 Documentation/{ => drivers}/driver-model/binding.txt              | 0
 Documentation/{ => drivers}/driver-model/bus.txt                  | 0
 Documentation/{ => drivers}/driver-model/class.txt                | 0
 Documentation/{ => drivers}/driver-model/design-patterns.txt      | 0
 Documentation/{ => drivers}/driver-model/device.txt               | 0
 Documentation/{ => drivers}/driver-model/devres.txt               | 0
 Documentation/{ => drivers}/driver-model/driver.txt               | 0
 Documentation/{ => drivers}/driver-model/overview.txt             | 0
 Documentation/{ => drivers}/driver-model/platform.txt             | 0
 Documentation/{ => drivers}/driver-model/porting.txt              | 0
 Documentation/{ => drivers}/fpga/dfl.rst                          | 0
 Documentation/{ => drivers}/fpga/index.rst                        | 0
 Documentation/{ => drivers}/gpio/index.rst                        | 0
 Documentation/{ => drivers}/gpio/sysfs.rst                        | 0
 Documentation/{ => drivers}/gpu/afbc.rst                          | 0
 Documentation/{ => drivers}/gpu/amdgpu-dc.rst                     | 0
 Documentation/{ => drivers}/gpu/amdgpu.rst                        | 0
 Documentation/{ => drivers}/gpu/bridge/dw-hdmi.rst                | 0
 Documentation/{ => drivers}/gpu/conf.py                           | 0
 Documentation/{ => drivers}/gpu/dp-mst/topology-figure-1.dot      | 0
 Documentation/{ => drivers}/gpu/dp-mst/topology-figure-2.dot      | 0
 Documentation/{ => drivers}/gpu/dp-mst/topology-figure-3.dot      | 0
 Documentation/{ => drivers}/gpu/drivers.rst                       | 0
 Documentation/{ => drivers}/gpu/drm-client.rst                    | 0
 Documentation/{ => drivers}/gpu/drm-internals.rst                 | 0
 Documentation/{ => drivers}/gpu/drm-kms-helpers.rst               | 0
 Documentation/{ => drivers}/gpu/drm-kms.rst                       | 0
 Documentation/{ => drivers}/gpu/drm-mm.rst                        | 0
 Documentation/{ => drivers}/gpu/drm-uapi.rst                      | 0
 Documentation/{ => drivers}/gpu/i915.rst                          | 0
 Documentation/{ => drivers}/gpu/index.rst                         | 0
 Documentation/{ => drivers}/gpu/introduction.rst                  | 0
 Documentation/{ => drivers}/gpu/kms-properties.csv                | 0
 Documentation/{ => drivers}/gpu/komeda-kms.rst                    | 0
 Documentation/{ => drivers}/gpu/meson.rst                         | 0
 Documentation/{ => drivers}/gpu/msm-crash-dump.rst                | 0
 Documentation/{ => drivers}/gpu/pl111.rst                         | 0
 Documentation/{ => drivers}/gpu/tegra.rst                         | 0
 Documentation/{ => drivers}/gpu/tinydrm.rst                       | 0
 Documentation/{ => drivers}/gpu/todo.rst                          | 0
 Documentation/{ => drivers}/gpu/tve200.rst                        | 0
 Documentation/{ => drivers}/gpu/v3d.rst                           | 0
 Documentation/{ => drivers}/gpu/vc4.rst                           | 0
 Documentation/{ => drivers}/gpu/vga-switcheroo.rst                | 0
 Documentation/{ => drivers}/gpu/vgaarbiter.rst                    | 0
 Documentation/{ => drivers}/gpu/vkms.rst                          | 0
 Documentation/{ => drivers}/gpu/xen-front.rst                     | 0
 Documentation/{ => drivers}/hid/hid-alps.txt                      | 0
 Documentation/{ => drivers}/hid/hid-sensor.txt                    | 0
 Documentation/{ => drivers}/hid/hid-transport.txt                 | 0
 Documentation/{ => drivers}/hid/hiddev.txt                        | 0
 Documentation/{ => drivers}/hid/hidraw.txt                        | 0
 Documentation/{ => drivers}/hid/intel-ish-hid.txt                 | 0
 Documentation/{ => drivers}/hid/uhid.txt                          | 0
 Documentation/{ => drivers}/i2c/DMA-considerations                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-ali1535                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-ali1563                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-ali15x3                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-amd-mp2                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-amd756                 | 0
 Documentation/{ => drivers}/i2c/busses/i2c-amd8111                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-diolan-u2c             | 0
 Documentation/{ => drivers}/i2c/busses/i2c-i801                   | 0
 Documentation/{ => drivers}/i2c/busses/i2c-ismt                   | 0
 Documentation/{ => drivers}/i2c/busses/i2c-mlxcpld                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-nforce2                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-nvidia-gpu             | 0
 Documentation/{ => drivers}/i2c/busses/i2c-ocores                 | 0
 Documentation/{ => drivers}/i2c/busses/i2c-parport                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-parport-light          | 0
 Documentation/{ => drivers}/i2c/busses/i2c-pca-isa                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-piix4                  | 0
 Documentation/{ => drivers}/i2c/busses/i2c-sis5595                | 0
 Documentation/{ => drivers}/i2c/busses/i2c-sis630                 | 0
 Documentation/{ => drivers}/i2c/busses/i2c-sis96x                 | 0
 Documentation/{ => drivers}/i2c/busses/i2c-taos-evm               | 0
 Documentation/{ => drivers}/i2c/busses/i2c-via                    | 0
 Documentation/{ => drivers}/i2c/busses/i2c-viapro                 | 0
 Documentation/{ => drivers}/i2c/busses/scx200_acb                 | 0
 Documentation/{ => drivers}/i2c/dev-interface                     | 0
 Documentation/{ => drivers}/i2c/fault-codes                       | 0
 Documentation/{ => drivers}/i2c/functionality                     | 0
 Documentation/{ => drivers}/i2c/gpio-fault-injection              | 0
 Documentation/{ => drivers}/i2c/i2c-protocol                      | 0
 Documentation/{ => drivers}/i2c/i2c-stub                          | 0
 Documentation/{ => drivers}/i2c/i2c-topology                      | 0
 Documentation/{ => drivers}/i2c/instantiating-devices             | 0
 Documentation/{ => drivers}/i2c/muxes/i2c-mux-gpio                | 0
 Documentation/{ => drivers}/i2c/old-module-parameters             | 0
 Documentation/{ => drivers}/i2c/slave-eeprom-backend              | 0
 Documentation/{ => drivers}/i2c/slave-interface                   | 0
 Documentation/{ => drivers}/i2c/smbus-protocol                    | 0
 Documentation/{ => drivers}/i2c/summary                           | 0
 Documentation/{ => drivers}/i2c/ten-bit-addresses                 | 0
 Documentation/{ => drivers}/i2c/upgrading-clients                 | 0
 Documentation/{ => drivers}/i2c/writing-clients                   | 0
 Documentation/{ => drivers}/ide/ChangeLog.ide-cd.1994-2004        | 0
 Documentation/{ => drivers}/ide/ChangeLog.ide-floppy.1996-2002    | 0
 Documentation/{ => drivers}/ide/ChangeLog.ide-tape.1995-2002      | 0
 Documentation/{ => drivers}/ide/changelogs.rst                    | 0
 Documentation/{ => drivers}/ide/ide-tape.rst                      | 0
 Documentation/{ => drivers}/ide/ide.rst                           | 0
 Documentation/{ => drivers}/ide/index.rst                         | 0
 Documentation/{ => drivers}/ide/warm-plug-howto.rst               | 0
 Documentation/{ => drivers}/infiniband/core_locking.txt           | 0
 Documentation/{ => drivers}/infiniband/ipoib.txt                  | 0
 Documentation/{ => drivers}/infiniband/opa_vnic.txt               | 0
 Documentation/{ => drivers}/infiniband/sysfs.txt                  | 0
 Documentation/{ => drivers}/infiniband/tag_matching.txt           | 0
 Documentation/{ => drivers}/infiniband/user_mad.txt               | 0
 Documentation/{ => drivers}/infiniband/user_verbs.txt             | 0
 Documentation/{ => drivers}/leds/index.rst                        | 0
 Documentation/{ => drivers}/leds/leds-blinkm.rst                  | 0
 Documentation/{ => drivers}/leds/leds-class-flash.rst             | 0
 Documentation/{ => drivers}/leds/leds-class.rst                   | 0
 Documentation/{ => drivers}/leds/leds-lm3556.rst                  | 0
 Documentation/{ => drivers}/leds/leds-lp3944.rst                  | 0
 Documentation/{ => drivers}/leds/leds-lp5521.rst                  | 0
 Documentation/{ => drivers}/leds/leds-lp5523.rst                  | 0
 Documentation/{ => drivers}/leds/leds-lp5562.rst                  | 0
 Documentation/{ => drivers}/leds/leds-lp55xx.rst                  | 0
 Documentation/{ => drivers}/leds/leds-mlxcpld.rst                 | 0
 Documentation/{ => drivers}/leds/ledtrig-oneshot.rst              | 0
 Documentation/{ => drivers}/leds/ledtrig-transient.rst            | 0
 Documentation/{ => drivers}/leds/ledtrig-usbport.rst              | 0
 Documentation/{ => drivers}/leds/uleds.rst                        | 0
 Documentation/{ => drivers}/lightnvm/pblk.txt                     | 0
 Documentation/{ => drivers}/md/md-cluster.txt                     | 0
 Documentation/{ => drivers}/md/raid5-cache.txt                    | 0
 Documentation/{ => drivers}/md/raid5-ppl.txt                      | 0
 Documentation/{ => drivers}/media/.gitignore                      | 0
 Documentation/{ => drivers}/media/Makefile                        | 0
 Documentation/{ => drivers}/media/audio.h.rst.exceptions          | 0
 Documentation/{ => drivers}/media/ca.h.rst.exceptions             | 0
 Documentation/{ => drivers}/media/cec-drivers/index.rst           | 0
 Documentation/{ => drivers}/media/cec-drivers/pulse8-cec.rst      | 0
 Documentation/{ => drivers}/media/cec.h.rst.exceptions            | 0
 Documentation/{ => drivers}/media/conf.py                         | 0
 Documentation/{ => drivers}/media/conf_nitpick.py                 | 0
 Documentation/{ => drivers}/media/dmx.h.rst.exceptions            | 0
 Documentation/{ => drivers}/media/dvb-drivers/avermedia.rst       | 0
 Documentation/{ => drivers}/media/dvb-drivers/bt8xx.rst           | 0
 Documentation/{ => drivers}/media/dvb-drivers/cards.rst           | 0
 Documentation/{ => drivers}/media/dvb-drivers/ci.rst              | 0
 Documentation/{ => drivers}/media/dvb-drivers/contributors.rst    | 0
 Documentation/{ => drivers}/media/dvb-drivers/dvb-usb.rst         | 0
 Documentation/{ => drivers}/media/dvb-drivers/faq.rst             | 0
 Documentation/{ => drivers}/media/dvb-drivers/frontends.rst       | 0
 Documentation/{ => drivers}/media/dvb-drivers/index.rst           | 0
 Documentation/{ => drivers}/media/dvb-drivers/intro.rst           | 0
 Documentation/{ => drivers}/media/dvb-drivers/lmedm04.rst         | 0
 Documentation/{ => drivers}/media/dvb-drivers/opera-firmware.rst  | 0
 Documentation/{ => drivers}/media/dvb-drivers/technisat.rst       | 0
 Documentation/{ => drivers}/media/dvb-drivers/ttusb-dec.rst       | 0
 Documentation/{ => drivers}/media/dvb-drivers/udev.rst            | 0
 Documentation/{ => drivers}/media/frontend.h.rst.exceptions       | 0
 Documentation/{ => drivers}/media/index.rst                       | 0
 Documentation/{ => drivers}/media/intro.rst                       | 0
 Documentation/{ => drivers}/media/kapi/cec-core.rst               | 0
 Documentation/{ => drivers}/media/kapi/csi2.rst                   | 0
 Documentation/{ => drivers}/media/kapi/dtv-ca.rst                 | 0
 Documentation/{ => drivers}/media/kapi/dtv-common.rst             | 0
 Documentation/{ => drivers}/media/kapi/dtv-core.rst               | 0
 Documentation/{ => drivers}/media/kapi/dtv-demux.rst              | 0
 Documentation/{ => drivers}/media/kapi/dtv-frontend.rst           | 0
 Documentation/{ => drivers}/media/kapi/dtv-net.rst                | 0
 Documentation/{ => drivers}/media/kapi/mc-core.rst                | 0
 Documentation/{ => drivers}/media/kapi/rc-core.rst                | 0
 Documentation/{ => drivers}/media/kapi/v4l2-async.rst             | 0
 Documentation/{ => drivers}/media/kapi/v4l2-clocks.rst            | 0
 Documentation/{ => drivers}/media/kapi/v4l2-common.rst            | 0
 Documentation/{ => drivers}/media/kapi/v4l2-controls.rst          | 0
 Documentation/{ => drivers}/media/kapi/v4l2-core.rst              | 0
 Documentation/{ => drivers}/media/kapi/v4l2-dev.rst               | 0
 Documentation/{ => drivers}/media/kapi/v4l2-device.rst            | 0
 Documentation/{ => drivers}/media/kapi/v4l2-dv-timings.rst        | 0
 Documentation/{ => drivers}/media/kapi/v4l2-event.rst             | 0
 Documentation/{ => drivers}/media/kapi/v4l2-fh.rst                | 0
 Documentation/{ => drivers}/media/kapi/v4l2-flash-led-class.rst   | 0
 Documentation/{ => drivers}/media/kapi/v4l2-fwnode.rst            | 0
 Documentation/{ => drivers}/media/kapi/v4l2-intro.rst             | 0
 Documentation/{ => drivers}/media/kapi/v4l2-mc.rst                | 0
 Documentation/{ => drivers}/media/kapi/v4l2-mediabus.rst          | 0
 Documentation/{ => drivers}/media/kapi/v4l2-mem2mem.rst           | 0
 Documentation/{ => drivers}/media/kapi/v4l2-rect.rst              | 0
 Documentation/{ => drivers}/media/kapi/v4l2-subdev.rst            | 0
 Documentation/{ => drivers}/media/kapi/v4l2-tuner.rst             | 0
 Documentation/{ => drivers}/media/kapi/v4l2-tveeprom.rst          | 0
 Documentation/{ => drivers}/media/kapi/v4l2-videobuf.rst          | 0
 Documentation/{ => drivers}/media/kapi/v4l2-videobuf2.rst         | 0
 Documentation/{ => drivers}/media/lirc.h.rst.exceptions           | 0
 Documentation/{ => drivers}/media/media.h.rst.exceptions          | 0
 Documentation/{ => drivers}/media/media_kapi.rst                  | 0
 Documentation/{ => drivers}/media/media_uapi.rst                  | 0
 Documentation/{ => drivers}/media/net.h.rst.exceptions            | 0
 Documentation/{ => drivers}/media/typical_media_device.svg        | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-api.rst            | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-func-close.rst     | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-func-ioctl.rst     | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-func-open.rst      | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-func-poll.rst      | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-funcs.rst          | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-header.rst         | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-intro.rst          | 0
 .../{ => drivers}/media/uapi/cec/cec-ioc-adap-g-caps.rst          | 0
 .../{ => drivers}/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst     | 0
 .../{ => drivers}/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst     | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-ioc-dqevent.rst    | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-ioc-g-mode.rst     | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-ioc-receive.rst    | 0
 Documentation/{ => drivers}/media/uapi/cec/cec-pin-error-inj.rst  | 0
 .../media/uapi/dvb/audio-bilingual-channel-select.rst             | 0
 .../{ => drivers}/media/uapi/dvb/audio-channel-select.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-clear-buffer.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-continue.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-fclose.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-fopen.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-fwrite.rst       | 0
 .../{ => drivers}/media/uapi/dvb/audio-get-capabilities.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-get-status.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-pause.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-play.rst         | 0
 .../{ => drivers}/media/uapi/dvb/audio-select-source.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-set-av-sync.rst  | 0
 .../{ => drivers}/media/uapi/dvb/audio-set-bypass-mode.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-set-id.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-set-mixer.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-set-mute.rst     | 0
 .../{ => drivers}/media/uapi/dvb/audio-set-streamtype.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio-stop.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio.rst              | 0
 Documentation/{ => drivers}/media/uapi/dvb/audio_data_types.rst   | 0
 .../{ => drivers}/media/uapi/dvb/audio_function_calls.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-fclose.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-fopen.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-get-cap.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-get-descr-info.rst  | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-get-msg.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-get-slot-info.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-reset.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-send-msg.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca-set-descr.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca.rst                 | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca_data_types.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/ca_function_calls.rst  | 0
 Documentation/{ => drivers}/media/uapi/dvb/demux.rst              | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-add-pid.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-expbuf.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-fclose.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-fopen.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-fread.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-fwrite.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-get-pes-pids.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-get-stc.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-mmap.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-munmap.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-qbuf.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-querybuf.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-remove-pid.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-reqbufs.rst        | 0
 .../{ => drivers}/media/uapi/dvb/dmx-set-buffer-size.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-set-filter.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-set-pes-filter.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-start.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx-stop.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx_fcalls.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/dmx_types.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/dvb-fe-read-status.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/dvb-frontend-event.rst | 0
 .../{ => drivers}/media/uapi/dvb/dvb-frontend-parameters.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/dvbapi.rst             | 0
 Documentation/{ => drivers}/media/uapi/dvb/dvbproperty.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/dvbstb.svg             | 0
 Documentation/{ => drivers}/media/uapi/dvb/examples.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-bandwidth-t.rst     | 0
 .../{ => drivers}/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst   | 0
 .../{ => drivers}/media/uapi/dvb/fe-diseqc-reset-overload.rst     | 0
 .../{ => drivers}/media/uapi/dvb/fe-diseqc-send-burst.rst         | 0
 .../{ => drivers}/media/uapi/dvb/fe-diseqc-send-master-cmd.rst    | 0
 .../media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst             | 0
 .../{ => drivers}/media/uapi/dvb/fe-enable-high-lnb-voltage.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-get-event.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-get-frontend.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-get-info.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-get-property.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-read-ber.rst        | 0
 .../{ => drivers}/media/uapi/dvb/fe-read-signal-strength.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-read-snr.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-read-status.rst     | 0
 .../{ => drivers}/media/uapi/dvb/fe-read-uncorrected-blocks.rst   | 0
 .../{ => drivers}/media/uapi/dvb/fe-set-frontend-tune-mode.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-set-frontend.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-set-tone.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-set-voltage.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/fe-type-t.rst          | 0
 .../{ => drivers}/media/uapi/dvb/fe_property_parameters.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/frontend-header.rst    | 0
 .../media/uapi/dvb/frontend-property-cable-systems.rst            | 0
 .../media/uapi/dvb/frontend-property-satellite-systems.rst        | 0
 .../media/uapi/dvb/frontend-property-terrestrial-systems.rst      | 0
 .../{ => drivers}/media/uapi/dvb/frontend-stat-properties.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/frontend.rst           | 0
 Documentation/{ => drivers}/media/uapi/dvb/frontend_f_close.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/frontend_f_open.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/frontend_fcalls.rst    | 0
 .../{ => drivers}/media/uapi/dvb/frontend_legacy_api.rst          | 0
 .../{ => drivers}/media/uapi/dvb/frontend_legacy_dvbv3_api.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/headers.rst            | 0
 Documentation/{ => drivers}/media/uapi/dvb/intro.rst              | 0
 Documentation/{ => drivers}/media/uapi/dvb/legacy_dvb_apis.rst    | 0
 Documentation/{ => drivers}/media/uapi/dvb/net-add-if.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/net-get-if.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/net-remove-if.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/net-types.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/net.rst                | 0
 .../{ => drivers}/media/uapi/dvb/query-dvb-frontend-info.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-clear-buffer.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-command.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-continue.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-fast-forward.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-fclose.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-fopen.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-freeze.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-fwrite.rst       | 0
 .../{ => drivers}/media/uapi/dvb/video-get-capabilities.rst       | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-get-event.rst    | 0
 .../{ => drivers}/media/uapi/dvb/video-get-frame-count.rst        | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-get-pts.rst      | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-get-size.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-get-status.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-play.rst         | 0
 .../{ => drivers}/media/uapi/dvb/video-select-source.rst          | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-set-blank.rst    | 0
 .../{ => drivers}/media/uapi/dvb/video-set-display-format.rst     | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-set-format.rst   | 0
 .../{ => drivers}/media/uapi/dvb/video-set-streamtype.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-slowmotion.rst   | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-stillpicture.rst | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-stop.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/video-try-command.rst  | 0
 Documentation/{ => drivers}/media/uapi/dvb/video.rst              | 0
 .../{ => drivers}/media/uapi/dvb/video_function_calls.rst         | 0
 Documentation/{ => drivers}/media/uapi/dvb/video_types.rst        | 0
 Documentation/{ => drivers}/media/uapi/fdl-appendix.rst           | 0
 Documentation/{ => drivers}/media/uapi/gen-errors.rst             | 0
 .../{ => drivers}/media/uapi/mediactl/media-controller-intro.rst  | 0
 .../{ => drivers}/media/uapi/mediactl/media-controller-model.rst  | 0
 .../{ => drivers}/media/uapi/mediactl/media-controller.rst        | 0
 .../{ => drivers}/media/uapi/mediactl/media-func-close.rst        | 0
 .../{ => drivers}/media/uapi/mediactl/media-func-ioctl.rst        | 0
 .../{ => drivers}/media/uapi/mediactl/media-func-open.rst         | 0
 Documentation/{ => drivers}/media/uapi/mediactl/media-funcs.rst   | 0
 Documentation/{ => drivers}/media/uapi/mediactl/media-header.rst  | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-device-info.rst   | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-enum-entities.rst | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-enum-links.rst    | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-g-topology.rst    | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-request-alloc.rst | 0
 .../{ => drivers}/media/uapi/mediactl/media-ioc-setup-link.rst    | 0
 .../{ => drivers}/media/uapi/mediactl/media-request-ioc-queue.rst | 0
 .../media/uapi/mediactl/media-request-ioc-reinit.rst              | 0
 Documentation/{ => drivers}/media/uapi/mediactl/media-types.rst   | 0
 Documentation/{ => drivers}/media/uapi/mediactl/request-api.rst   | 0
 .../{ => drivers}/media/uapi/mediactl/request-func-close.rst      | 0
 .../{ => drivers}/media/uapi/mediactl/request-func-ioctl.rst      | 0
 .../{ => drivers}/media/uapi/mediactl/request-func-poll.rst       | 0
 Documentation/{ => drivers}/media/uapi/rc/keytable.c.rst          | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-dev-intro.rst      | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-dev.rst            | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-func.rst           | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-get-features.rst   | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-get-rec-mode.rst   | 0
 .../{ => drivers}/media/uapi/rc/lirc-get-rec-resolution.rst       | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-get-send-mode.rst  | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-get-timeout.rst    | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-header.rst         | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-read.rst           | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-measure-carrier-mode.rst | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-rec-carrier-range.rst    | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-rec-carrier.rst          | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-rec-timeout-reports.rst  | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-rec-timeout.rst          | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-send-carrier.rst         | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-send-duty-cycle.rst      | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-transmitter-mask.rst     | 0
 .../{ => drivers}/media/uapi/rc/lirc-set-wideband-receiver.rst    | 0
 Documentation/{ => drivers}/media/uapi/rc/lirc-write.rst          | 0
 Documentation/{ => drivers}/media/uapi/rc/rc-intro.rst            | 0
 Documentation/{ => drivers}/media/uapi/rc/rc-sysfs-nodes.rst      | 0
 Documentation/{ => drivers}/media/uapi/rc/rc-table-change.rst     | 0
 Documentation/{ => drivers}/media/uapi/rc/rc-tables.rst           | 0
 Documentation/{ => drivers}/media/uapi/rc/remote_controllers.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/app-pri.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/async.rst              | 0
 Documentation/{ => drivers}/media/uapi/v4l/audio.rst              | 0
 Documentation/{ => drivers}/media/uapi/v4l/bayer.svg              | 0
 Documentation/{ => drivers}/media/uapi/v4l/biblio.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/buffer.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/capture-example.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/capture.c.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/colorspaces-defs.rst   | 0
 .../{ => drivers}/media/uapi/v4l/colorspaces-details.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/colorspaces.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/common-defs.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/common.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/compat.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/constraints.svg        | 0
 Documentation/{ => drivers}/media/uapi/v4l/control.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/crop.rst               | 0
 Documentation/{ => drivers}/media/uapi/v4l/crop.svg               | 0
 Documentation/{ => drivers}/media/uapi/v4l/depth-formats.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-capture.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-event.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-mem2mem.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-meta.rst           | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-osd.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-output.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-overlay.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-radio.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-raw-vbi.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-rds.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-sdr.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-sliced-vbi.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-subdev.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/dev-touch.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/devices.rst            | 0
 Documentation/{ => drivers}/media/uapi/v4l/diff-v4l.rst           | 0
 Documentation/{ => drivers}/media/uapi/v4l/dmabuf.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/dv-timings.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-camera.rst   | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-codec.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-detect.rst   | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-dv.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-flash.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-fm-rx.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-fm-tx.rst    | 0
 .../{ => drivers}/media/uapi/v4l/ext-ctrls-image-process.rst      | 0
 .../{ => drivers}/media/uapi/v4l/ext-ctrls-image-source.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-jpeg.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-rf-tuner.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/extended-controls.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/field-order.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/fieldseq_bt.svg        | 0
 Documentation/{ => drivers}/media/uapi/v4l/fieldseq_tb.svg        | 0
 Documentation/{ => drivers}/media/uapi/v4l/format.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-close.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-ioctl.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-mmap.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-munmap.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-open.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-poll.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-read.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-select.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/func-write.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/hist-v4l2.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/hsv-formats.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/io.rst                 | 0
 .../{ => drivers}/media/uapi/v4l/libv4l-introduction.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/libv4l.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/meta-formats.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/mmap.rst               | 0
 Documentation/{ => drivers}/media/uapi/v4l/nv12mt.svg             | 0
 Documentation/{ => drivers}/media/uapi/v4l/nv12mt_example.svg     | 0
 Documentation/{ => drivers}/media/uapi/v4l/open.rst               | 0
 Documentation/{ => drivers}/media/uapi/v4l/pipeline.dot           | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-cnf4.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-compressed.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-grey.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-indexed.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-intro.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-inzi.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-m420.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-d4xx.rst   | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-uvc.rst    | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst         | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12m.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12mt.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv16.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv16m.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv24.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-hsv.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-rgb.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-yuv.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-reserved.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-rgb.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cs08.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cs14le.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cu08.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cu16le.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu16be.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu18be.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu20be.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-ru12le.rst  | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-srggb10-ipu3.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10.rst     | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-srggb10alaw8.rst          | 0
 .../{ => drivers}/media/uapi/v4l/pixfmt-srggb10dpcm8.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10p.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb12.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb12p.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb14p.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb16.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb8.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-td08.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-td16.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-tu08.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-tu16.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-uv8.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-uyvy.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-v4l2-mplane.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-v4l2.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-vyuy.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10b.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10p.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y12.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y12i.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y16-be.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y16.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y41p.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y8i.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv410.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv411p.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv420.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv420m.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv422m.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv422p.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv444m.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuyv.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yvyu.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt-z16.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/pixfmt.rst             | 0
 Documentation/{ => drivers}/media/uapi/v4l/planar-apis.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/querycap.rst           | 0
 Documentation/{ => drivers}/media/uapi/v4l/rw.rst                 | 0
 Documentation/{ => drivers}/media/uapi/v4l/sdr-formats.rst        | 0
 .../{ => drivers}/media/uapi/v4l/selection-api-configuration.rst  | 0
 .../{ => drivers}/media/uapi/v4l/selection-api-examples.rst       | 0
 .../{ => drivers}/media/uapi/v4l/selection-api-intro.rst          | 0
 .../{ => drivers}/media/uapi/v4l/selection-api-targets.rst        | 0
 .../{ => drivers}/media/uapi/v4l/selection-api-vs-crop-api.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/selection-api.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/selection.svg          | 0
 Documentation/{ => drivers}/media/uapi/v4l/selections-common.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/standard.rst           | 0
 Documentation/{ => drivers}/media/uapi/v4l/streaming-par.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/subdev-formats.rst     | 0
 .../{ => drivers}/media/uapi/v4l/subdev-image-processing-crop.svg | 0
 .../{ => drivers}/media/uapi/v4l/subdev-image-processing-full.svg | 0
 .../uapi/v4l/subdev-image-processing-scaling-multi-source.svg     | 0
 Documentation/{ => drivers}/media/uapi/v4l/tch-formats.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/tuner.rst              | 0
 Documentation/{ => drivers}/media/uapi/v4l/user-func.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/userp.rst              | 0
 .../{ => drivers}/media/uapi/v4l/v4l2-selection-flags.rst         | 0
 .../{ => drivers}/media/uapi/v4l/v4l2-selection-targets.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/v4l2.rst               | 0
 Documentation/{ => drivers}/media/uapi/v4l/v4l2grab-example.rst   | 0
 Documentation/{ => drivers}/media/uapi/v4l/v4l2grab.c.rst         | 0
 Documentation/{ => drivers}/media/uapi/v4l/vbi_525.svg            | 0
 Documentation/{ => drivers}/media/uapi/v4l/vbi_625.svg            | 0
 Documentation/{ => drivers}/media/uapi/v4l/vbi_hsync.svg          | 0
 Documentation/{ => drivers}/media/uapi/v4l/video.rst              | 0
 Documentation/{ => drivers}/media/uapi/v4l/videodev.rst           | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-create-bufs.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-cropcap.rst     | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-dbg-g-chip-info.rst       | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-dbg-g-register.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-decoder-cmd.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-dqevent.rst     | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-dv-timings-cap.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-encoder-cmd.rst | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-enum-dv-timings.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-fmt.rst    | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-enum-frameintervals.rst   | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-enum-framesizes.rst       | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-enum-freq-bands.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumaudio.rst   | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-enumaudioout.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-enuminput.rst   | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumoutput.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumstd.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-expbuf.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-audio.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-audioout.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-crop.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-ctrl.rst      | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-g-dv-timings.rst          | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-edid.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-enc-index.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-ext-ctrls.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-fbuf.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-fmt.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-frequency.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-input.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-jpegcomp.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-modulator.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-output.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-parm.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-priority.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-selection.rst | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-std.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-tuner.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-log-status.rst  | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-overlay.rst     | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-prepare-buf.rst | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-qbuf.rst        | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-query-dv-timings.rst      | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-querybuf.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-querycap.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-queryctrl.rst   | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-querystd.rst    | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-reqbufs.rst     | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-s-hw-freq-seek.rst        | 0
 Documentation/{ => drivers}/media/uapi/v4l/vidioc-streamon.rst    | 0
 .../media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst          | 0
 .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst              | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-subdev-g-crop.rst         | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-subdev-g-fmt.rst          | 0
 .../media/uapi/v4l/vidioc-subdev-g-frame-interval.rst             | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-subdev-g-selection.rst    | 0
 .../{ => drivers}/media/uapi/v4l/vidioc-subscribe-event.rst       | 0
 Documentation/{ => drivers}/media/uapi/v4l/yuv-formats.rst        | 0
 Documentation/{ => drivers}/media/v4l-drivers/au0828-cardlist.rst | 0
 Documentation/{ => drivers}/media/v4l-drivers/bttv-cardlist.rst   | 0
 Documentation/{ => drivers}/media/v4l-drivers/bttv.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/cafe_ccic.rst       | 0
 Documentation/{ => drivers}/media/v4l-drivers/cardlist.rst        | 0
 Documentation/{ => drivers}/media/v4l-drivers/cpia2.rst           | 0
 Documentation/{ => drivers}/media/v4l-drivers/cx18.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/cx2341x.rst         | 0
 .../{ => drivers}/media/v4l-drivers/cx23885-cardlist.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/cx88-cardlist.rst   | 0
 Documentation/{ => drivers}/media/v4l-drivers/cx88.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/davinci-vpbe.rst    | 0
 Documentation/{ => drivers}/media/v4l-drivers/em28xx-cardlist.rst | 0
 Documentation/{ => drivers}/media/v4l-drivers/fimc.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/fourcc.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/gspca-cardlist.rst  | 0
 Documentation/{ => drivers}/media/v4l-drivers/imx.rst             | 0
 Documentation/{ => drivers}/media/v4l-drivers/imx7.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/index.rst           | 0
 Documentation/{ => drivers}/media/v4l-drivers/ipu3.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/ivtv-cardlist.rst   | 0
 Documentation/{ => drivers}/media/v4l-drivers/ivtv.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/max2175.rst         | 0
 Documentation/{ => drivers}/media/v4l-drivers/meye.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/omap3isp.rst        | 0
 Documentation/{ => drivers}/media/v4l-drivers/omap4_camera.rst    | 0
 Documentation/{ => drivers}/media/v4l-drivers/philips.rst         | 0
 Documentation/{ => drivers}/media/v4l-drivers/pvrusb2.rst         | 0
 Documentation/{ => drivers}/media/v4l-drivers/pxa_camera.rst      | 0
 Documentation/{ => drivers}/media/v4l-drivers/qcom_camss.rst      | 0
 .../{ => drivers}/media/v4l-drivers/qcom_camss_8x96_graph.dot     | 0
 .../{ => drivers}/media/v4l-drivers/qcom_camss_graph.dot          | 0
 Documentation/{ => drivers}/media/v4l-drivers/radiotrack.rst      | 0
 Documentation/{ => drivers}/media/v4l-drivers/rcar-fdp1.rst       | 0
 .../{ => drivers}/media/v4l-drivers/saa7134-cardlist.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/saa7134.rst         | 0
 .../{ => drivers}/media/v4l-drivers/saa7164-cardlist.rst          | 0
 .../{ => drivers}/media/v4l-drivers/sh_mobile_ceu_camera.rst      | 0
 Documentation/{ => drivers}/media/v4l-drivers/si470x.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/si4713.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/si476x.rst          | 0
 Documentation/{ => drivers}/media/v4l-drivers/soc-camera.rst      | 0
 Documentation/{ => drivers}/media/v4l-drivers/tm6000-cardlist.rst | 0
 Documentation/{ => drivers}/media/v4l-drivers/tuner-cardlist.rst  | 0
 Documentation/{ => drivers}/media/v4l-drivers/tuners.rst          | 0
 .../{ => drivers}/media/v4l-drivers/usbvision-cardlist.rst        | 0
 Documentation/{ => drivers}/media/v4l-drivers/uvcvideo.rst        | 0
 Documentation/{ => drivers}/media/v4l-drivers/v4l-with-ir.rst     | 0
 Documentation/{ => drivers}/media/v4l-drivers/vimc.dot            | 0
 Documentation/{ => drivers}/media/v4l-drivers/vimc.rst            | 0
 Documentation/{ => drivers}/media/v4l-drivers/vivid.rst           | 0
 Documentation/{ => drivers}/media/v4l-drivers/zr364xx.rst         | 0
 Documentation/{ => drivers}/media/video.h.rst.exceptions          | 0
 Documentation/{ => drivers}/media/videodev2.h.rst.exceptions      | 0
 Documentation/{memory-devices => drivers/memory}/ti-emif.txt      | 0
 Documentation/{misc-devices => drivers/misc}/ad525x_dpot.txt      | 0
 Documentation/{misc-devices => drivers/misc}/apds990x.txt         | 0
 Documentation/{misc-devices => drivers/misc}/bh1770glc.txt        | 0
 Documentation/{misc-devices => drivers/misc}/c2port.txt           | 0
 Documentation/{misc-devices => drivers/misc}/eeprom               | 0
 Documentation/{misc-devices => drivers/misc}/ibmvmc.rst           | 0
 Documentation/{misc-devices => drivers/misc}/ics932s401           | 0
 Documentation/{misc-devices => drivers/misc}/index.rst            | 0
 Documentation/{misc-devices => drivers/misc}/isl29003             | 0
 Documentation/{misc-devices => drivers/misc}/lis3lv02d            | 0
 Documentation/{misc-devices => drivers/misc}/max6875              | 0
 .../{misc-devices => drivers/misc}/mei/mei-client-bus.txt         | 0
 Documentation/{misc-devices => drivers/misc}/mei/mei.txt          | 0
 .../{misc-devices => drivers/misc}/pci-endpoint-test.txt          | 0
 .../{misc-devices => drivers/misc}/spear-pcie-gadget.txt          | 0
 Documentation/{ => drivers}/mmc/mmc-async-req.txt                 | 0
 Documentation/{ => drivers}/mmc/mmc-dev-attrs.txt                 | 0
 Documentation/{ => drivers}/mmc/mmc-dev-parts.txt                 | 0
 Documentation/{ => drivers}/mmc/mmc-tools.txt                     | 0
 Documentation/{ => drivers}/mtd/intel-spi.txt                     | 0
 Documentation/{ => drivers}/mtd/nand_ecc.txt                      | 0
 Documentation/{ => drivers}/mtd/spi-nor.txt                       | 0
 Documentation/{ => drivers}/nfc/nfc-hci.txt                       | 0
 Documentation/{ => drivers}/nfc/nfc-pn544.txt                     | 0
 Documentation/{ => drivers}/nvdimm/btt.txt                        | 0
 Documentation/{ => drivers}/nvdimm/nvdimm.txt                     | 0
 Documentation/{ => drivers}/nvdimm/security.txt                   | 0
 Documentation/{ => drivers}/nvmem/nvmem.txt                       | 0
 Documentation/{ => drivers}/pcmcia/devicetable.rst                | 0
 Documentation/{ => drivers}/pcmcia/driver-changes.rst             | 0
 Documentation/{ => drivers}/pcmcia/driver.rst                     | 0
 Documentation/{ => drivers}/pcmcia/index.rst                      | 0
 Documentation/{ => drivers}/pcmcia/locking.rst                    | 0
 Documentation/{ => drivers}/rapidio/mport_cdev.txt                | 0
 Documentation/{ => drivers}/rapidio/rapidio.txt                   | 0
 Documentation/{ => drivers}/rapidio/rio_cm.txt                    | 0
 Documentation/{ => drivers}/rapidio/sysfs.txt                     | 0
 Documentation/{ => drivers}/rapidio/tsi721.txt                    | 0
 Documentation/{ => drivers}/scsi/53c700.txt                       | 0
 Documentation/{ => drivers}/scsi/BusLogic.txt                     | 0
 Documentation/{ => drivers}/scsi/ChangeLog.arcmsr                 | 0
 Documentation/{ => drivers}/scsi/ChangeLog.ips                    | 0
 Documentation/{ => drivers}/scsi/ChangeLog.lpfc                   | 0
 Documentation/{ => drivers}/scsi/ChangeLog.megaraid               | 0
 Documentation/{ => drivers}/scsi/ChangeLog.megaraid_sas           | 0
 Documentation/{ => drivers}/scsi/ChangeLog.ncr53c8xx              | 0
 Documentation/{ => drivers}/scsi/ChangeLog.sym53c8xx              | 0
 Documentation/{ => drivers}/scsi/ChangeLog.sym53c8xx_2            | 0
 Documentation/{ => drivers}/scsi/FlashPoint.txt                   | 0
 Documentation/{ => drivers}/scsi/LICENSE.FlashPoint               | 0
 Documentation/{ => drivers}/scsi/LICENSE.qla2xxx                  | 0
 Documentation/{ => drivers}/scsi/LICENSE.qla4xxx                  | 0
 Documentation/{ => drivers}/scsi/NinjaSCSI.txt                    | 0
 Documentation/{ => drivers}/scsi/aacraid.txt                      | 0
 Documentation/{ => drivers}/scsi/advansys.txt                     | 0
 Documentation/{ => drivers}/scsi/aha152x.txt                      | 0
 Documentation/{ => drivers}/scsi/aic79xx.txt                      | 0
 Documentation/{ => drivers}/scsi/aic7xxx.txt                      | 0
 Documentation/{ => drivers}/scsi/arcmsr_spec.txt                  | 0
 Documentation/{ => drivers}/scsi/bfa.txt                          | 0
 Documentation/{ => drivers}/scsi/bnx2fc.txt                       | 0
 Documentation/{ => drivers}/scsi/cxgb3i.txt                       | 0
 Documentation/{ => drivers}/scsi/dc395x.txt                       | 0
 Documentation/{ => drivers}/scsi/dpti.txt                         | 0
 Documentation/{ => drivers}/scsi/g_NCR5380.txt                    | 0
 Documentation/{ => drivers}/scsi/hpsa.txt                         | 0
 Documentation/{ => drivers}/scsi/hptiop.txt                       | 0
 Documentation/{ => drivers}/scsi/libsas.txt                       | 0
 Documentation/{ => drivers}/scsi/link_power_management_policy.txt | 0
 Documentation/{ => drivers}/scsi/lpfc.txt                         | 0
 Documentation/{ => drivers}/scsi/megaraid.txt                     | 0
 Documentation/{ => drivers}/scsi/ncr53c8xx.txt                    | 0
 Documentation/{ => drivers}/scsi/osst.txt                         | 0
 Documentation/{ => drivers}/scsi/ppa.txt                          | 0
 Documentation/{ => drivers}/scsi/qlogicfas.txt                    | 0
 Documentation/{ => drivers}/scsi/scsi-changer.txt                 | 0
 Documentation/{ => drivers}/scsi/scsi-generic.txt                 | 0
 Documentation/{ => drivers}/scsi/scsi-parameters.txt              | 0
 Documentation/{ => drivers}/scsi/scsi.txt                         | 0
 Documentation/{ => drivers}/scsi/scsi_eh.txt                      | 0
 Documentation/{ => drivers}/scsi/scsi_fc_transport.txt            | 0
 Documentation/{ => drivers}/scsi/scsi_mid_low_api.txt             | 0
 Documentation/{ => drivers}/scsi/scsi_transport_srp/Makefile      | 0
 .../{ => drivers}/scsi/scsi_transport_srp/rport_state_diagram.dot | 0
 Documentation/{ => drivers}/scsi/sd-parameters.txt                | 0
 Documentation/{ => drivers}/scsi/smartpqi.txt                     | 0
 Documentation/{ => drivers}/scsi/st.txt                           | 0
 Documentation/{ => drivers}/scsi/sym53c500_cs.txt                 | 0
 Documentation/{ => drivers}/scsi/sym53c8xx_2.txt                  | 0
 Documentation/{ => drivers}/scsi/tcm_qla2xxx.txt                  | 0
 Documentation/{ => drivers}/scsi/ufs.txt                          | 0
 Documentation/{ => drivers}/scsi/wd719x.txt                       | 0
 Documentation/{ => drivers}/serial/cyclades_z.rst                 | 0
 Documentation/{ => drivers}/serial/driver.rst                     | 0
 Documentation/{ => drivers}/serial/index.rst                      | 0
 Documentation/{ => drivers}/serial/moxa-smartio.rst               | 0
 Documentation/{ => drivers}/serial/n_gsm.rst                      | 0
 Documentation/{ => drivers}/serial/rocket.rst                     | 0
 Documentation/{ => drivers}/serial/serial-iso7816.rst             | 0
 Documentation/{ => drivers}/serial/serial-rs485.rst               | 0
 Documentation/{ => drivers}/serial/tty.rst                        | 0
 Documentation/{ => drivers}/sound/alsa-configuration.rst          | 0
 Documentation/{ => drivers}/sound/cards/audigy-mixer.rst          | 0
 Documentation/{ => drivers}/sound/cards/audiophile-usb.rst        | 0
 Documentation/{ => drivers}/sound/cards/bt87x.rst                 | 0
 Documentation/{ => drivers}/sound/cards/cmipci.rst                | 0
 Documentation/{ => drivers}/sound/cards/emu10k1-jack.rst          | 0
 Documentation/{ => drivers}/sound/cards/hdspm.rst                 | 0
 Documentation/{ => drivers}/sound/cards/img-spdif-in.rst          | 0
 Documentation/{ => drivers}/sound/cards/index.rst                 | 0
 Documentation/{ => drivers}/sound/cards/joystick.rst              | 0
 Documentation/{ => drivers}/sound/cards/maya44.rst                | 0
 Documentation/{ => drivers}/sound/cards/mixart.rst                | 0
 Documentation/{ => drivers}/sound/cards/multisound.sh             | 0
 Documentation/{ => drivers}/sound/cards/sb-live-mixer.rst         | 0
 Documentation/{ => drivers}/sound/cards/serial-u16550.rst         | 0
 Documentation/{ => drivers}/sound/cards/via82xx-mixer.rst         | 0
 Documentation/{ => drivers}/sound/conf.py                         | 0
 Documentation/{ => drivers}/sound/designs/channel-mapping-api.rst | 0
 Documentation/{ => drivers}/sound/designs/compress-offload.rst    | 0
 Documentation/{ => drivers}/sound/designs/control-names.rst       | 0
 Documentation/{ => drivers}/sound/designs/index.rst               | 0
 Documentation/{ => drivers}/sound/designs/jack-controls.rst       | 0
 Documentation/{ => drivers}/sound/designs/oss-emulation.rst       | 0
 Documentation/{ => drivers}/sound/designs/powersave.rst           | 0
 Documentation/{ => drivers}/sound/designs/procfile.rst            | 0
 Documentation/{ => drivers}/sound/designs/seq-oss.rst             | 0
 Documentation/{ => drivers}/sound/designs/timestamping.rst        | 0
 Documentation/{ => drivers}/sound/designs/tracepoints.rst         | 0
 Documentation/{ => drivers}/sound/hd-audio/controls.rst           | 0
 Documentation/{ => drivers}/sound/hd-audio/dp-mst.rst             | 0
 Documentation/{ => drivers}/sound/hd-audio/index.rst              | 0
 Documentation/{ => drivers}/sound/hd-audio/models.rst             | 0
 Documentation/{ => drivers}/sound/hd-audio/notes.rst              | 0
 Documentation/{ => drivers}/sound/index.rst                       | 0
 Documentation/{ => drivers}/sound/kernel-api/alsa-driver-api.rst  | 0
 Documentation/{ => drivers}/sound/kernel-api/index.rst            | 0
 .../{ => drivers}/sound/kernel-api/writing-an-alsa-driver.rst     | 0
 Documentation/{ => drivers}/sound/soc/clocking.rst                | 0
 Documentation/{ => drivers}/sound/soc/codec-to-codec.rst          | 0
 Documentation/{ => drivers}/sound/soc/codec.rst                   | 0
 Documentation/{ => drivers}/sound/soc/dai.rst                     | 0
 Documentation/{ => drivers}/sound/soc/dapm.rst                    | 0
 Documentation/{ => drivers}/sound/soc/dpcm.rst                    | 0
 Documentation/{ => drivers}/sound/soc/index.rst                   | 0
 Documentation/{ => drivers}/sound/soc/jack.rst                    | 0
 Documentation/{ => drivers}/sound/soc/machine.rst                 | 0
 Documentation/{ => drivers}/sound/soc/overview.rst                | 0
 Documentation/{ => drivers}/sound/soc/platform.rst                | 0
 Documentation/{ => drivers}/sound/soc/pops-clicks.rst             | 0
 Documentation/{ => drivers}/usb/CREDITS                           | 0
 Documentation/{ => drivers}/usb/WUSB-Design-overview.txt          | 0
 Documentation/{ => drivers}/usb/acm.txt                           | 0
 Documentation/{ => drivers}/usb/authorization.txt                 | 0
 Documentation/{ => drivers}/usb/chipidea.txt                      | 0
 Documentation/{ => drivers}/usb/dwc3.txt                          | 0
 Documentation/{ => drivers}/usb/ehci.txt                          | 0
 Documentation/{ => drivers}/usb/functionfs.txt                    | 0
 Documentation/{ => drivers}/usb/gadget-testing.txt                | 0
 Documentation/{ => drivers}/usb/gadget_configfs.txt               | 0
 Documentation/{ => drivers}/usb/gadget_hid.txt                    | 0
 Documentation/{ => drivers}/usb/gadget_multi.txt                  | 0
 Documentation/{ => drivers}/usb/gadget_printer.txt                | 0
 Documentation/{ => drivers}/usb/gadget_serial.txt                 | 0
 Documentation/{ => drivers}/usb/iuu_phoenix.txt                   | 0
 Documentation/{ => drivers}/usb/linux-cdc-acm.inf                 | 0
 Documentation/{ => drivers}/usb/linux.inf                         | 0
 Documentation/{ => drivers}/usb/mass-storage.txt                  | 0
 Documentation/{ => drivers}/usb/misc_usbsevseg.txt                | 0
 Documentation/{ => drivers}/usb/mtouchusb.txt                     | 0
 Documentation/{ => drivers}/usb/ohci.txt                          | 0
 Documentation/{ => drivers}/usb/rio.txt                           | 0
 Documentation/{ => drivers}/usb/usb-help.txt                      | 0
 Documentation/{ => drivers}/usb/usb-serial.txt                    | 0
 Documentation/{ => drivers}/usb/usbdevfs-drop-permissions.c       | 0
 Documentation/{ => drivers}/usb/usbip_protocol.txt                | 0
 Documentation/{ => drivers}/usb/usbmon.txt                        | 0
 Documentation/{ => drivers}/usb/wusb-cbaf                         | 0
 .../{ => drivers}/watchdog/convert_drivers_to_kernel_api.rst      | 0
 Documentation/{ => drivers}/watchdog/hpwdt.rst                    | 0
 Documentation/{ => drivers}/watchdog/index.rst                    | 0
 Documentation/{ => drivers}/watchdog/mlx-wdt.rst                  | 0
 Documentation/{ => drivers}/watchdog/pcwd-watchdog.rst            | 0
 Documentation/{ => drivers}/watchdog/watchdog-api.rst             | 0
 Documentation/{ => drivers}/watchdog/watchdog-kernel-api.rst      | 0
 Documentation/{ => drivers}/watchdog/watchdog-parameters.rst      | 0
 Documentation/{ => drivers}/watchdog/watchdog-pm.rst              | 0
 Documentation/{ => drivers}/watchdog/wdt.rst                      | 0
 1079 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{ => drivers}/PCI/MSI-HOWTO.txt (100%)
 rename Documentation/{ => drivers}/PCI/PCIEBUS-HOWTO.txt (100%)
 rename Documentation/{ => drivers}/PCI/acpi-info.txt (100%)
 rename Documentation/{ => drivers}/PCI/endpoint/function/binding/pci-test.txt (100%)
 rename Documentation/{ => drivers}/PCI/endpoint/pci-endpoint-cfs.txt (100%)
 rename Documentation/{ => drivers}/PCI/endpoint/pci-endpoint.txt (100%)
 rename Documentation/{ => drivers}/PCI/endpoint/pci-test-function.txt (100%)
 rename Documentation/{ => drivers}/PCI/endpoint/pci-test-howto.txt (100%)
 rename Documentation/{ => drivers}/PCI/pci-error-recovery.txt (100%)
 rename Documentation/{ => drivers}/PCI/pci-iov-howto.txt (100%)
 rename Documentation/{ => drivers}/PCI/pci.txt (100%)
 rename Documentation/{ => drivers}/PCI/pcieaer-howto.txt (100%)
 rename Documentation/{ => drivers}/acpi/dsd/leds.txt (100%)
 rename Documentation/{ => drivers}/auxdisplay/cfag12864b (100%)
 rename Documentation/{ => drivers}/auxdisplay/ks0108 (100%)
 rename Documentation/{ => drivers}/auxdisplay/lcd-panel-cgram.txt (100%)
 rename Documentation/{ => drivers}/backlight/lp855x-driver.txt (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/DRBD-8.3-data-packets.svg (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/DRBD-data-packets.svg (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/README.txt (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/conn-states-8.dot (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/data-structure-v9.txt (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/disk-states-8.dot (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/drbd-connection-state-overview.dot (100%)
 rename Documentation/{ => drivers}/blockdev/drbd/node-states-8.dot (100%)
 rename Documentation/{ => drivers}/blockdev/floppy.txt (100%)
 rename Documentation/{ => drivers}/blockdev/nbd.txt (100%)
 rename Documentation/{ => drivers}/blockdev/paride.txt (100%)
 rename Documentation/{ => drivers}/blockdev/ramdisk.txt (100%)
 rename Documentation/{ => drivers}/blockdev/zram.txt (100%)
 rename Documentation/{bus-devices => drivers/bus}/ti-gpmc.txt (100%)
 rename Documentation/{ => drivers}/cdrom/cdrom-standard.rst (100%)
 rename Documentation/{ => drivers}/cdrom/ide-cd.rst (100%)
 rename Documentation/{ => drivers}/cdrom/index.rst (100%)
 rename Documentation/{ => drivers}/cdrom/packet-writing.rst (100%)
 rename Documentation/{ => drivers}/cpu-freq/amd-powernow.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/core.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/cpu-drivers.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/cpufreq-nforce2.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/cpufreq-stats.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/index.txt (100%)
 rename Documentation/{ => drivers}/cpu-freq/pcc-cpufreq.txt (100%)
 rename Documentation/{ => drivers}/crypto/api-aead.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-akcipher.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-digest.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-intro.txt (100%)
 rename Documentation/{ => drivers}/crypto/api-kpp.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-rng.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-samples.rst (100%)
 rename Documentation/{ => drivers}/crypto/api-skcipher.rst (100%)
 rename Documentation/{ => drivers}/crypto/api.rst (100%)
 rename Documentation/{ => drivers}/crypto/architecture.rst (100%)
 rename Documentation/{ => drivers}/crypto/asymmetric-keys.txt (100%)
 rename Documentation/{ => drivers}/crypto/async-tx-api.txt (100%)
 rename Documentation/{ => drivers}/crypto/conf.py (100%)
 rename Documentation/{ => drivers}/crypto/crypto_engine.rst (100%)
 rename Documentation/{ => drivers}/crypto/descore-readme.txt (100%)
 rename Documentation/{ => drivers}/crypto/devel-algos.rst (100%)
 rename Documentation/{ => drivers}/crypto/index.rst (100%)
 rename Documentation/{ => drivers}/crypto/intro.rst (100%)
 rename Documentation/{ => drivers}/crypto/userspace-if.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/cache-policies.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/cache.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/delay.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-crypt.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-dust.txt (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-flakey.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-init.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-integrity.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-io.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-log.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-queue-length.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-raid.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-service-time.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-uevent.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/dm-zoned.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/era.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/index.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/kcopyd.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/linear.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/log-writes.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/persistent-data.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/snapshot.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/statistics.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/striped.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/switch.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/thin-provisioning.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/unstriped.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/verity.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/writecache.rst (100%)
 rename Documentation/{ => drivers}/device-mapper/zero.rst (100%)
 rename Documentation/{ => drivers}/driver-api/80211/cfg80211.rst (100%)
 rename Documentation/{ => drivers}/driver-api/80211/conf.py (100%)
 rename Documentation/{ => drivers}/driver-api/80211/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/80211/introduction.rst (100%)
 rename Documentation/{ => drivers}/driver-api/80211/mac80211-advanced.rst (100%)
 rename Documentation/{ => drivers}/driver-api/80211/mac80211.rst (100%)
 rename Documentation/{ => drivers}/driver-api/acpi/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/acpi/linuxized-acpica.rst (100%)
 rename Documentation/{ => drivers}/driver-api/acpi/scan_handlers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/basics.rst (100%)
 rename Documentation/{ => drivers}/driver-api/clk.rst (100%)
 rename Documentation/{ => drivers}/driver-api/component.rst (100%)
 rename Documentation/{ => drivers}/driver-api/conf.py (100%)
 rename Documentation/{ => drivers}/driver-api/device-io.rst (100%)
 rename Documentation/{ => drivers}/driver-api/device_connection.rst (100%)
 rename Documentation/{ => drivers}/driver-api/device_link.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dma-buf.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dmaengine/client.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dmaengine/dmatest.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dmaengine/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dmaengine/provider.rst (100%)
 rename Documentation/{ => drivers}/driver-api/dmaengine/pxa_dma.rst (100%)
 rename Documentation/{ => drivers}/driver-api/edac.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firewire.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/built-in-fw.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/core.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/direct-fs-lookup.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/fallback-mechanisms.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/firmware_cache.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/fw_search_path.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/introduction.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/lookup-order.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/other_interfaces.rst (100%)
 rename Documentation/{ => drivers}/driver-api/firmware/request_firmware.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/fpga-bridge.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/fpga-mgr.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/fpga-programming.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/fpga-region.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/fpga/intro.rst (100%)
 rename Documentation/{ => drivers}/driver-api/frame-buffer.rst (100%)
 rename Documentation/{ => drivers}/driver-api/generic-counter.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/board.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/consumer.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/driver.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/drivers-on-gpio.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/intro.rst (100%)
 rename Documentation/{ => drivers}/driver-api/gpio/legacy.rst (100%)
 rename Documentation/{ => drivers}/driver-api/hsi.rst (100%)
 rename Documentation/{ => drivers}/driver-api/i2c.rst (100%)
 rename Documentation/{ => drivers}/driver-api/i3c/device-driver-api.rst (100%)
 rename Documentation/{ => drivers}/driver-api/i3c/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/i3c/master-driver-api.rst (100%)
 rename Documentation/{ => drivers}/driver-api/i3c/protocol.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/buffers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/core.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/hw-consumer.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/intro.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/triggered-buffers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/iio/triggers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/infrastructure.rst (100%)
 rename Documentation/{ => drivers}/driver-api/input.rst (100%)
 rename Documentation/{ => drivers}/driver-api/libata.rst (100%)
 rename Documentation/{ => drivers}/driver-api/message-based.rst (100%)
 rename Documentation/{ => drivers}/driver-api/misc_devices.rst (100%)
 rename Documentation/{ => drivers}/driver-api/miscellaneous.rst (100%)
 rename Documentation/{ => drivers}/driver-api/mtdnand.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pci/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pci/p2pdma.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pci/pci.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pinctl.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pm/conf.py (100%)
 rename Documentation/{ => drivers}/driver-api/pm/cpuidle.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pm/devices.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pm/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pm/notifiers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pm/types.rst (100%)
 rename Documentation/{ => drivers}/driver-api/pps.rst (100%)
 rename Documentation/{ => drivers}/driver-api/ptp.rst (100%)
 rename Documentation/{ => drivers}/driver-api/rapidio.rst (100%)
 rename Documentation/{ => drivers}/driver-api/regulator.rst (100%)
 rename Documentation/{ => drivers}/driver-api/s390-drivers.rst (100%)
 rename Documentation/{ => drivers}/driver-api/scsi.rst (100%)
 rename Documentation/{ => drivers}/driver-api/slimbus.rst (100%)
 rename Documentation/{ => drivers}/driver-api/sound.rst (100%)
 rename Documentation/{ => drivers}/driver-api/soundwire/error_handling.rst (100%)
 rename Documentation/{ => drivers}/driver-api/soundwire/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/soundwire/locking.rst (100%)
 rename Documentation/{ => drivers}/driver-api/soundwire/stream.rst (100%)
 rename Documentation/{ => drivers}/driver-api/soundwire/summary.rst (100%)
 rename Documentation/{ => drivers}/driver-api/spi.rst (100%)
 rename Documentation/{ => drivers}/driver-api/target.rst (100%)
 rename Documentation/{ => drivers}/driver-api/uio-howto.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/URB.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/anchors.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/bulk-streams.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/callbacks.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/dma.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/dwc3.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/error-codes.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/gadget.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/hotplug.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/index.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/persist.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/power-management.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/typec.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/typec_bus.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/usb.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/usb3-debug-port.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/writing_musb_glue_layer.rst (100%)
 rename Documentation/{ => drivers}/driver-api/usb/writing_usb_driver.rst (100%)
 rename Documentation/{ => drivers}/driver-api/vme.rst (100%)
 rename Documentation/{ => drivers}/driver-api/w1.rst (100%)
 rename Documentation/{ => drivers}/driver-model/binding.txt (100%)
 rename Documentation/{ => drivers}/driver-model/bus.txt (100%)
 rename Documentation/{ => drivers}/driver-model/class.txt (100%)
 rename Documentation/{ => drivers}/driver-model/design-patterns.txt (100%)
 rename Documentation/{ => drivers}/driver-model/device.txt (100%)
 rename Documentation/{ => drivers}/driver-model/devres.txt (100%)
 rename Documentation/{ => drivers}/driver-model/driver.txt (100%)
 rename Documentation/{ => drivers}/driver-model/overview.txt (100%)
 rename Documentation/{ => drivers}/driver-model/platform.txt (100%)
 rename Documentation/{ => drivers}/driver-model/porting.txt (100%)
 rename Documentation/{ => drivers}/fpga/dfl.rst (100%)
 rename Documentation/{ => drivers}/fpga/index.rst (100%)
 rename Documentation/{ => drivers}/gpio/index.rst (100%)
 rename Documentation/{ => drivers}/gpio/sysfs.rst (100%)
 rename Documentation/{ => drivers}/gpu/afbc.rst (100%)
 rename Documentation/{ => drivers}/gpu/amdgpu-dc.rst (100%)
 rename Documentation/{ => drivers}/gpu/amdgpu.rst (100%)
 rename Documentation/{ => drivers}/gpu/bridge/dw-hdmi.rst (100%)
 rename Documentation/{ => drivers}/gpu/conf.py (100%)
 rename Documentation/{ => drivers}/gpu/dp-mst/topology-figure-1.dot (100%)
 rename Documentation/{ => drivers}/gpu/dp-mst/topology-figure-2.dot (100%)
 rename Documentation/{ => drivers}/gpu/dp-mst/topology-figure-3.dot (100%)
 rename Documentation/{ => drivers}/gpu/drivers.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-client.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-internals.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-kms-helpers.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-kms.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-mm.rst (100%)
 rename Documentation/{ => drivers}/gpu/drm-uapi.rst (100%)
 rename Documentation/{ => drivers}/gpu/i915.rst (100%)
 rename Documentation/{ => drivers}/gpu/index.rst (100%)
 rename Documentation/{ => drivers}/gpu/introduction.rst (100%)
 rename Documentation/{ => drivers}/gpu/kms-properties.csv (100%)
 rename Documentation/{ => drivers}/gpu/komeda-kms.rst (100%)
 rename Documentation/{ => drivers}/gpu/meson.rst (100%)
 rename Documentation/{ => drivers}/gpu/msm-crash-dump.rst (100%)
 rename Documentation/{ => drivers}/gpu/pl111.rst (100%)
 rename Documentation/{ => drivers}/gpu/tegra.rst (100%)
 rename Documentation/{ => drivers}/gpu/tinydrm.rst (100%)
 rename Documentation/{ => drivers}/gpu/todo.rst (100%)
 rename Documentation/{ => drivers}/gpu/tve200.rst (100%)
 rename Documentation/{ => drivers}/gpu/v3d.rst (100%)
 rename Documentation/{ => drivers}/gpu/vc4.rst (100%)
 rename Documentation/{ => drivers}/gpu/vga-switcheroo.rst (100%)
 rename Documentation/{ => drivers}/gpu/vgaarbiter.rst (100%)
 rename Documentation/{ => drivers}/gpu/vkms.rst (100%)
 rename Documentation/{ => drivers}/gpu/xen-front.rst (100%)
 rename Documentation/{ => drivers}/hid/hid-alps.txt (100%)
 rename Documentation/{ => drivers}/hid/hid-sensor.txt (100%)
 rename Documentation/{ => drivers}/hid/hid-transport.txt (100%)
 rename Documentation/{ => drivers}/hid/hiddev.txt (100%)
 rename Documentation/{ => drivers}/hid/hidraw.txt (100%)
 rename Documentation/{ => drivers}/hid/intel-ish-hid.txt (100%)
 rename Documentation/{ => drivers}/hid/uhid.txt (100%)
 rename Documentation/{ => drivers}/i2c/DMA-considerations (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-ali1535 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-ali1563 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-ali15x3 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-amd-mp2 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-amd756 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-amd8111 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-diolan-u2c (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-i801 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-ismt (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-mlxcpld (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-nforce2 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-nvidia-gpu (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-ocores (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-parport (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-parport-light (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-pca-isa (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-piix4 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-sis5595 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-sis630 (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-sis96x (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-taos-evm (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-via (100%)
 rename Documentation/{ => drivers}/i2c/busses/i2c-viapro (100%)
 rename Documentation/{ => drivers}/i2c/busses/scx200_acb (100%)
 rename Documentation/{ => drivers}/i2c/dev-interface (100%)
 rename Documentation/{ => drivers}/i2c/fault-codes (100%)
 rename Documentation/{ => drivers}/i2c/functionality (100%)
 rename Documentation/{ => drivers}/i2c/gpio-fault-injection (100%)
 rename Documentation/{ => drivers}/i2c/i2c-protocol (100%)
 rename Documentation/{ => drivers}/i2c/i2c-stub (100%)
 rename Documentation/{ => drivers}/i2c/i2c-topology (100%)
 rename Documentation/{ => drivers}/i2c/instantiating-devices (100%)
 rename Documentation/{ => drivers}/i2c/muxes/i2c-mux-gpio (100%)
 rename Documentation/{ => drivers}/i2c/old-module-parameters (100%)
 rename Documentation/{ => drivers}/i2c/slave-eeprom-backend (100%)
 rename Documentation/{ => drivers}/i2c/slave-interface (100%)
 rename Documentation/{ => drivers}/i2c/smbus-protocol (100%)
 rename Documentation/{ => drivers}/i2c/summary (100%)
 rename Documentation/{ => drivers}/i2c/ten-bit-addresses (100%)
 rename Documentation/{ => drivers}/i2c/upgrading-clients (100%)
 rename Documentation/{ => drivers}/i2c/writing-clients (100%)
 rename Documentation/{ => drivers}/ide/ChangeLog.ide-cd.1994-2004 (100%)
 rename Documentation/{ => drivers}/ide/ChangeLog.ide-floppy.1996-2002 (100%)
 rename Documentation/{ => drivers}/ide/ChangeLog.ide-tape.1995-2002 (100%)
 rename Documentation/{ => drivers}/ide/changelogs.rst (100%)
 rename Documentation/{ => drivers}/ide/ide-tape.rst (100%)
 rename Documentation/{ => drivers}/ide/ide.rst (100%)
 rename Documentation/{ => drivers}/ide/index.rst (100%)
 rename Documentation/{ => drivers}/ide/warm-plug-howto.rst (100%)
 rename Documentation/{ => drivers}/infiniband/core_locking.txt (100%)
 rename Documentation/{ => drivers}/infiniband/ipoib.txt (100%)
 rename Documentation/{ => drivers}/infiniband/opa_vnic.txt (100%)
 rename Documentation/{ => drivers}/infiniband/sysfs.txt (100%)
 rename Documentation/{ => drivers}/infiniband/tag_matching.txt (100%)
 rename Documentation/{ => drivers}/infiniband/user_mad.txt (100%)
 rename Documentation/{ => drivers}/infiniband/user_verbs.txt (100%)
 rename Documentation/{ => drivers}/leds/index.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-blinkm.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-class-flash.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-class.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lm3556.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lp3944.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lp5521.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lp5523.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lp5562.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-lp55xx.rst (100%)
 rename Documentation/{ => drivers}/leds/leds-mlxcpld.rst (100%)
 rename Documentation/{ => drivers}/leds/ledtrig-oneshot.rst (100%)
 rename Documentation/{ => drivers}/leds/ledtrig-transient.rst (100%)
 rename Documentation/{ => drivers}/leds/ledtrig-usbport.rst (100%)
 rename Documentation/{ => drivers}/leds/uleds.rst (100%)
 rename Documentation/{ => drivers}/lightnvm/pblk.txt (100%)
 rename Documentation/{ => drivers}/md/md-cluster.txt (100%)
 rename Documentation/{ => drivers}/md/raid5-cache.txt (100%)
 rename Documentation/{ => drivers}/md/raid5-ppl.txt (100%)
 rename Documentation/{ => drivers}/media/.gitignore (100%)
 rename Documentation/{ => drivers}/media/Makefile (100%)
 rename Documentation/{ => drivers}/media/audio.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/ca.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/cec-drivers/index.rst (100%)
 rename Documentation/{ => drivers}/media/cec-drivers/pulse8-cec.rst (100%)
 rename Documentation/{ => drivers}/media/cec.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/conf.py (100%)
 rename Documentation/{ => drivers}/media/conf_nitpick.py (100%)
 rename Documentation/{ => drivers}/media/dmx.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/avermedia.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/bt8xx.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/cards.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/ci.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/contributors.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/dvb-usb.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/faq.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/frontends.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/index.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/intro.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/lmedm04.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/opera-firmware.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/technisat.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/ttusb-dec.rst (100%)
 rename Documentation/{ => drivers}/media/dvb-drivers/udev.rst (100%)
 rename Documentation/{ => drivers}/media/frontend.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/index.rst (100%)
 rename Documentation/{ => drivers}/media/intro.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/cec-core.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/csi2.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-ca.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-common.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-core.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-demux.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-frontend.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/dtv-net.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/mc-core.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/rc-core.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-async.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-clocks.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-common.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-controls.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-core.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-dev.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-device.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-dv-timings.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-event.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-fh.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-flash-led-class.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-fwnode.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-intro.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-mc.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-mediabus.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-mem2mem.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-rect.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-subdev.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-tuner.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-tveeprom.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-videobuf.rst (100%)
 rename Documentation/{ => drivers}/media/kapi/v4l2-videobuf2.rst (100%)
 rename Documentation/{ => drivers}/media/lirc.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/media.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/media_kapi.rst (100%)
 rename Documentation/{ => drivers}/media/media_uapi.rst (100%)
 rename Documentation/{ => drivers}/media/net.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/typical_media_device.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-func-close.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-func-ioctl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-func-open.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-func-poll.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-funcs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-header.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-adap-g-caps.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-dqevent.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-g-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-ioc-receive.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/cec/cec-pin-error-inj.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-bilingual-channel-select.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-channel-select.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-clear-buffer.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-continue.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-fclose.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-fopen.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-fwrite.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-get-capabilities.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-get-status.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-pause.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-play.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-select-source.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-av-sync.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-bypass-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-id.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-mixer.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-mute.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-set-streamtype.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio-stop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio_data_types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/audio_function_calls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-fclose.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-fopen.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-get-cap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-get-descr-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-get-msg.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-get-slot-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-reset.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-send-msg.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca-set-descr.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca_data_types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/ca_function_calls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/demux.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-add-pid.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-expbuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-fclose.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-fopen.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-fread.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-fwrite.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-get-pes-pids.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-get-stc.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-mmap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-munmap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-qbuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-querybuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-remove-pid.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-reqbufs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-set-buffer-size.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-set-filter.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-set-pes-filter.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-start.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx-stop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx_fcalls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dmx_types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvb-fe-read-status.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvb-frontend-event.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvb-frontend-parameters.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvbapi.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvbproperty.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/dvbstb.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/examples.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-bandwidth-t.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-diseqc-reset-overload.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-diseqc-send-burst.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-diseqc-send-master-cmd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-enable-high-lnb-voltage.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-get-event.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-get-frontend.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-get-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-get-property.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-read-ber.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-read-signal-strength.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-read-snr.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-read-status.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-read-uncorrected-blocks.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-set-frontend-tune-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-set-frontend.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-set-tone.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-set-voltage.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe-type-t.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/fe_property_parameters.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend-header.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend-property-cable-systems.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend-property-satellite-systems.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend-property-terrestrial-systems.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend-stat-properties.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend_f_close.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend_f_open.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend_fcalls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend_legacy_api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/frontend_legacy_dvbv3_api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/headers.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/legacy_dvb_apis.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/net-add-if.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/net-get-if.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/net-remove-if.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/net-types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/net.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/query-dvb-frontend-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-clear-buffer.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-command.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-continue.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-fast-forward.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-fclose.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-fopen.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-freeze.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-fwrite.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-capabilities.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-event.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-frame-count.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-pts.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-size.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-get-status.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-play.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-select-source.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-set-blank.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-set-display-format.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-set-format.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-set-streamtype.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-slowmotion.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-stillpicture.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-stop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video-try-command.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video_function_calls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/dvb/video_types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/fdl-appendix.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/gen-errors.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-controller-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-controller-model.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-controller.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-func-close.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-func-ioctl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-func-open.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-funcs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-header.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-device-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-enum-entities.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-enum-links.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-g-topology.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-request-alloc.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-ioc-setup-link.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-request-ioc-queue.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-request-ioc-reinit.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/media-types.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/request-api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/request-func-close.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/request-func-ioctl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/mediactl/request-func-poll.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/keytable.c.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-dev-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-dev.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-func.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-get-features.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-get-rec-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-get-rec-resolution.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-get-send-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-get-timeout.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-header.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-read.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-measure-carrier-mode.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-rec-carrier-range.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-rec-carrier.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-rec-timeout-reports.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-rec-timeout.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-send-carrier.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-send-duty-cycle.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-transmitter-mask.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-set-wideband-receiver.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/lirc-write.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/rc-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/rc-sysfs-nodes.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/rc-table-change.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/rc-tables.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/rc/remote_controllers.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/app-pri.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/async.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/audio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/bayer.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/biblio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/buffer.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/capture-example.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/capture.c.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/colorspaces-defs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/colorspaces-details.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/colorspaces.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/common-defs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/common.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/compat.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/constraints.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/control.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/crop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/crop.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/depth-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-capture.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-event.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-mem2mem.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-meta.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-osd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-output.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-overlay.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-radio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-raw-vbi.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-rds.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-sdr.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-sliced-vbi.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-subdev.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dev-touch.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/devices.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/diff-v4l.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dmabuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/dv-timings.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-camera.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-codec.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-detect.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-dv.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-flash.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-fm-rx.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-fm-tx.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-image-process.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-image-source.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-jpeg.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/ext-ctrls-rf-tuner.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/extended-controls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/field-order.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/fieldseq_bt.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/fieldseq_tb.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/format.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-close.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-ioctl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-mmap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-munmap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-open.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-poll.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-read.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-select.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/func-write.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/hist-v4l2.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/hsv-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/io.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/libv4l-introduction.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/libv4l.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/meta-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/mmap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/nv12mt.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/nv12mt_example.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/open.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pipeline.dot (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-cnf4.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-compressed.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-grey.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-indexed.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-inzi.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-m420.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-d4xx.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-uvc.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12m.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv12mt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv16m.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-nv24.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-hsv.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-rgb.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-packed-yuv.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-reserved.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-rgb.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cs08.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cs14le.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cu08.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-cu16le.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu16be.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu18be.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-pcu20be.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-sdr-ru12le.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10-ipu3.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10alaw8.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10dpcm8.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb10p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb12.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb12p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb14p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-srggb8.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-td08.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-td16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-tu08.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-tch-tu16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-uv8.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-uyvy.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-v4l2-mplane.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-v4l2.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-vyuy.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10b.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y10p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y12.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y12i.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y16-be.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y41p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-y8i.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv410.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv411p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv420.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv420m.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv422m.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv422p.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuv444m.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yuyv.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-yvyu.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt-z16.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/pixfmt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/planar-apis.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/querycap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/rw.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/sdr-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api-configuration.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api-examples.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api-intro.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api-targets.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api-vs-crop-api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection-api.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selection.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/selections-common.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/standard.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/streaming-par.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/subdev-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/subdev-image-processing-crop.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/subdev-image-processing-full.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/subdev-image-processing-scaling-multi-source.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/tch-formats.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/tuner.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/user-func.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/userp.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/v4l2-selection-flags.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/v4l2-selection-targets.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/v4l2.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/v4l2grab-example.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/v4l2grab.c.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vbi_525.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vbi_625.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vbi_hsync.svg (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/video.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/videodev.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-create-bufs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-cropcap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-dbg-g-chip-info.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-dbg-g-register.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-decoder-cmd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-dqevent.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-dv-timings-cap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-encoder-cmd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-dv-timings.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-fmt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-frameintervals.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-framesizes.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enum-freq-bands.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumaudio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumaudioout.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enuminput.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumoutput.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-enumstd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-expbuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-audio.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-audioout.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-crop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-ctrl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-dv-timings.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-edid.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-enc-index.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-ext-ctrls.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-fbuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-fmt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-frequency.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-input.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-jpegcomp.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-modulator.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-output.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-parm.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-priority.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-selection.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-std.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-g-tuner.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-log-status.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-overlay.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-prepare-buf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-qbuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-query-dv-timings.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-querybuf.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-querycap.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-queryctrl.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-querystd.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-reqbufs.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-s-hw-freq-seek.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-streamon.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-g-crop.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-g-fmt.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subdev-g-selection.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/vidioc-subscribe-event.rst (100%)
 rename Documentation/{ => drivers}/media/uapi/v4l/yuv-formats.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/au0828-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/bttv-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/bttv.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cafe_ccic.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cpia2.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cx18.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cx2341x.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cx23885-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cx88-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/cx88.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/davinci-vpbe.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/em28xx-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/fimc.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/fourcc.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/gspca-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/imx.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/imx7.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/index.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/ipu3.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/ivtv-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/ivtv.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/max2175.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/meye.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/omap3isp.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/omap4_camera.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/philips.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/pvrusb2.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/pxa_camera.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/qcom_camss.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/qcom_camss_8x96_graph.dot (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/qcom_camss_graph.dot (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/radiotrack.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/rcar-fdp1.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/saa7134-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/saa7134.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/saa7164-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/sh_mobile_ceu_camera.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/si470x.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/si4713.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/si476x.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/soc-camera.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/tm6000-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/tuner-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/tuners.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/usbvision-cardlist.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/uvcvideo.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/v4l-with-ir.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/vimc.dot (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/vimc.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/vivid.rst (100%)
 rename Documentation/{ => drivers}/media/v4l-drivers/zr364xx.rst (100%)
 rename Documentation/{ => drivers}/media/video.h.rst.exceptions (100%)
 rename Documentation/{ => drivers}/media/videodev2.h.rst.exceptions (100%)
 rename Documentation/{memory-devices => drivers/memory}/ti-emif.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/ad525x_dpot.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/apds990x.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/bh1770glc.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/c2port.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/eeprom (100%)
 rename Documentation/{misc-devices => drivers/misc}/ibmvmc.rst (100%)
 rename Documentation/{misc-devices => drivers/misc}/ics932s401 (100%)
 rename Documentation/{misc-devices => drivers/misc}/index.rst (100%)
 rename Documentation/{misc-devices => drivers/misc}/isl29003 (100%)
 rename Documentation/{misc-devices => drivers/misc}/lis3lv02d (100%)
 rename Documentation/{misc-devices => drivers/misc}/max6875 (100%)
 rename Documentation/{misc-devices => drivers/misc}/mei/mei-client-bus.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/mei/mei.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/pci-endpoint-test.txt (100%)
 rename Documentation/{misc-devices => drivers/misc}/spear-pcie-gadget.txt (100%)
 rename Documentation/{ => drivers}/mmc/mmc-async-req.txt (100%)
 rename Documentation/{ => drivers}/mmc/mmc-dev-attrs.txt (100%)
 rename Documentation/{ => drivers}/mmc/mmc-dev-parts.txt (100%)
 rename Documentation/{ => drivers}/mmc/mmc-tools.txt (100%)
 rename Documentation/{ => drivers}/mtd/intel-spi.txt (100%)
 rename Documentation/{ => drivers}/mtd/nand_ecc.txt (100%)
 rename Documentation/{ => drivers}/mtd/spi-nor.txt (100%)
 rename Documentation/{ => drivers}/nfc/nfc-hci.txt (100%)
 rename Documentation/{ => drivers}/nfc/nfc-pn544.txt (100%)
 rename Documentation/{ => drivers}/nvdimm/btt.txt (100%)
 rename Documentation/{ => drivers}/nvdimm/nvdimm.txt (100%)
 rename Documentation/{ => drivers}/nvdimm/security.txt (100%)
 rename Documentation/{ => drivers}/nvmem/nvmem.txt (100%)
 rename Documentation/{ => drivers}/pcmcia/devicetable.rst (100%)
 rename Documentation/{ => drivers}/pcmcia/driver-changes.rst (100%)
 rename Documentation/{ => drivers}/pcmcia/driver.rst (100%)
 rename Documentation/{ => drivers}/pcmcia/index.rst (100%)
 rename Documentation/{ => drivers}/pcmcia/locking.rst (100%)
 rename Documentation/{ => drivers}/rapidio/mport_cdev.txt (100%)
 rename Documentation/{ => drivers}/rapidio/rapidio.txt (100%)
 rename Documentation/{ => drivers}/rapidio/rio_cm.txt (100%)
 rename Documentation/{ => drivers}/rapidio/sysfs.txt (100%)
 rename Documentation/{ => drivers}/rapidio/tsi721.txt (100%)
 rename Documentation/{ => drivers}/scsi/53c700.txt (100%)
 rename Documentation/{ => drivers}/scsi/BusLogic.txt (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.arcmsr (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.ips (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.lpfc (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.megaraid (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.megaraid_sas (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.ncr53c8xx (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.sym53c8xx (100%)
 rename Documentation/{ => drivers}/scsi/ChangeLog.sym53c8xx_2 (100%)
 rename Documentation/{ => drivers}/scsi/FlashPoint.txt (100%)
 rename Documentation/{ => drivers}/scsi/LICENSE.FlashPoint (100%)
 rename Documentation/{ => drivers}/scsi/LICENSE.qla2xxx (100%)
 rename Documentation/{ => drivers}/scsi/LICENSE.qla4xxx (100%)
 rename Documentation/{ => drivers}/scsi/NinjaSCSI.txt (100%)
 rename Documentation/{ => drivers}/scsi/aacraid.txt (100%)
 rename Documentation/{ => drivers}/scsi/advansys.txt (100%)
 rename Documentation/{ => drivers}/scsi/aha152x.txt (100%)
 rename Documentation/{ => drivers}/scsi/aic79xx.txt (100%)
 rename Documentation/{ => drivers}/scsi/aic7xxx.txt (100%)
 rename Documentation/{ => drivers}/scsi/arcmsr_spec.txt (100%)
 rename Documentation/{ => drivers}/scsi/bfa.txt (100%)
 rename Documentation/{ => drivers}/scsi/bnx2fc.txt (100%)
 rename Documentation/{ => drivers}/scsi/cxgb3i.txt (100%)
 rename Documentation/{ => drivers}/scsi/dc395x.txt (100%)
 rename Documentation/{ => drivers}/scsi/dpti.txt (100%)
 rename Documentation/{ => drivers}/scsi/g_NCR5380.txt (100%)
 rename Documentation/{ => drivers}/scsi/hpsa.txt (100%)
 rename Documentation/{ => drivers}/scsi/hptiop.txt (100%)
 rename Documentation/{ => drivers}/scsi/libsas.txt (100%)
 rename Documentation/{ => drivers}/scsi/link_power_management_policy.txt (100%)
 rename Documentation/{ => drivers}/scsi/lpfc.txt (100%)
 rename Documentation/{ => drivers}/scsi/megaraid.txt (100%)
 rename Documentation/{ => drivers}/scsi/ncr53c8xx.txt (100%)
 rename Documentation/{ => drivers}/scsi/osst.txt (100%)
 rename Documentation/{ => drivers}/scsi/ppa.txt (100%)
 rename Documentation/{ => drivers}/scsi/qlogicfas.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi-changer.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi-generic.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi-parameters.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi_eh.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi_fc_transport.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi_mid_low_api.txt (100%)
 rename Documentation/{ => drivers}/scsi/scsi_transport_srp/Makefile (100%)
 rename Documentation/{ => drivers}/scsi/scsi_transport_srp/rport_state_diagram.dot (100%)
 rename Documentation/{ => drivers}/scsi/sd-parameters.txt (100%)
 rename Documentation/{ => drivers}/scsi/smartpqi.txt (100%)
 rename Documentation/{ => drivers}/scsi/st.txt (100%)
 rename Documentation/{ => drivers}/scsi/sym53c500_cs.txt (100%)
 rename Documentation/{ => drivers}/scsi/sym53c8xx_2.txt (100%)
 rename Documentation/{ => drivers}/scsi/tcm_qla2xxx.txt (100%)
 rename Documentation/{ => drivers}/scsi/ufs.txt (100%)
 rename Documentation/{ => drivers}/scsi/wd719x.txt (100%)
 rename Documentation/{ => drivers}/serial/cyclades_z.rst (100%)
 rename Documentation/{ => drivers}/serial/driver.rst (100%)
 rename Documentation/{ => drivers}/serial/index.rst (100%)
 rename Documentation/{ => drivers}/serial/moxa-smartio.rst (100%)
 rename Documentation/{ => drivers}/serial/n_gsm.rst (100%)
 rename Documentation/{ => drivers}/serial/rocket.rst (100%)
 rename Documentation/{ => drivers}/serial/serial-iso7816.rst (100%)
 rename Documentation/{ => drivers}/serial/serial-rs485.rst (100%)
 rename Documentation/{ => drivers}/serial/tty.rst (100%)
 rename Documentation/{ => drivers}/sound/alsa-configuration.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/audigy-mixer.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/audiophile-usb.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/bt87x.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/cmipci.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/emu10k1-jack.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/hdspm.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/img-spdif-in.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/index.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/joystick.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/maya44.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/mixart.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/multisound.sh (100%)
 rename Documentation/{ => drivers}/sound/cards/sb-live-mixer.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/serial-u16550.rst (100%)
 rename Documentation/{ => drivers}/sound/cards/via82xx-mixer.rst (100%)
 rename Documentation/{ => drivers}/sound/conf.py (100%)
 rename Documentation/{ => drivers}/sound/designs/channel-mapping-api.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/compress-offload.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/control-names.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/index.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/jack-controls.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/oss-emulation.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/powersave.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/procfile.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/seq-oss.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/timestamping.rst (100%)
 rename Documentation/{ => drivers}/sound/designs/tracepoints.rst (100%)
 rename Documentation/{ => drivers}/sound/hd-audio/controls.rst (100%)
 rename Documentation/{ => drivers}/sound/hd-audio/dp-mst.rst (100%)
 rename Documentation/{ => drivers}/sound/hd-audio/index.rst (100%)
 rename Documentation/{ => drivers}/sound/hd-audio/models.rst (100%)
 rename Documentation/{ => drivers}/sound/hd-audio/notes.rst (100%)
 rename Documentation/{ => drivers}/sound/index.rst (100%)
 rename Documentation/{ => drivers}/sound/kernel-api/alsa-driver-api.rst (100%)
 rename Documentation/{ => drivers}/sound/kernel-api/index.rst (100%)
 rename Documentation/{ => drivers}/sound/kernel-api/writing-an-alsa-driver.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/clocking.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/codec-to-codec.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/codec.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/dai.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/dapm.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/dpcm.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/index.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/jack.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/machine.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/overview.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/platform.rst (100%)
 rename Documentation/{ => drivers}/sound/soc/pops-clicks.rst (100%)
 rename Documentation/{ => drivers}/usb/CREDITS (100%)
 rename Documentation/{ => drivers}/usb/WUSB-Design-overview.txt (100%)
 rename Documentation/{ => drivers}/usb/acm.txt (100%)
 rename Documentation/{ => drivers}/usb/authorization.txt (100%)
 rename Documentation/{ => drivers}/usb/chipidea.txt (100%)
 rename Documentation/{ => drivers}/usb/dwc3.txt (100%)
 rename Documentation/{ => drivers}/usb/ehci.txt (100%)
 rename Documentation/{ => drivers}/usb/functionfs.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget-testing.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget_configfs.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget_hid.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget_multi.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget_printer.txt (100%)
 rename Documentation/{ => drivers}/usb/gadget_serial.txt (100%)
 rename Documentation/{ => drivers}/usb/iuu_phoenix.txt (100%)
 rename Documentation/{ => drivers}/usb/linux-cdc-acm.inf (100%)
 rename Documentation/{ => drivers}/usb/linux.inf (100%)
 rename Documentation/{ => drivers}/usb/mass-storage.txt (100%)
 rename Documentation/{ => drivers}/usb/misc_usbsevseg.txt (100%)
 rename Documentation/{ => drivers}/usb/mtouchusb.txt (100%)
 rename Documentation/{ => drivers}/usb/ohci.txt (100%)
 rename Documentation/{ => drivers}/usb/rio.txt (100%)
 rename Documentation/{ => drivers}/usb/usb-help.txt (100%)
 rename Documentation/{ => drivers}/usb/usb-serial.txt (100%)
 rename Documentation/{ => drivers}/usb/usbdevfs-drop-permissions.c (100%)
 rename Documentation/{ => drivers}/usb/usbip_protocol.txt (100%)
 rename Documentation/{ => drivers}/usb/usbmon.txt (100%)
 rename Documentation/{ => drivers}/usb/wusb-cbaf (100%)
 rename Documentation/{ => drivers}/watchdog/convert_drivers_to_kernel_api.rst (100%)
 rename Documentation/{ => drivers}/watchdog/hpwdt.rst (100%)
 rename Documentation/{ => drivers}/watchdog/index.rst (100%)
 rename Documentation/{ => drivers}/watchdog/mlx-wdt.rst (100%)
 rename Documentation/{ => drivers}/watchdog/pcwd-watchdog.rst (100%)
 rename Documentation/{ => drivers}/watchdog/watchdog-api.rst (100%)
 rename Documentation/{ => drivers}/watchdog/watchdog-kernel-api.rst (100%)
 rename Documentation/{ => drivers}/watchdog/watchdog-parameters.rst (100%)
 rename Documentation/{ => drivers}/watchdog/watchdog-pm.rst (100%)
 rename Documentation/{ => drivers}/watchdog/wdt.rst (100%)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/drivers/PCI/MSI-HOWTO.txt
similarity index 100%
rename from Documentation/PCI/MSI-HOWTO.txt
rename to Documentation/drivers/PCI/MSI-HOWTO.txt
diff --git a/Documentation/PCI/PCIEBUS-HOWTO.txt b/Documentation/drivers/PCI/PCIEBUS-HOWTO.txt
similarity index 100%
rename from Documentation/PCI/PCIEBUS-HOWTO.txt
rename to Documentation/drivers/PCI/PCIEBUS-HOWTO.txt
diff --git a/Documentation/PCI/acpi-info.txt b/Documentation/drivers/PCI/acpi-info.txt
similarity index 100%
rename from Documentation/PCI/acpi-info.txt
rename to Documentation/drivers/PCI/acpi-info.txt
diff --git a/Documentation/PCI/endpoint/function/binding/pci-test.txt b/Documentation/drivers/PCI/endpoint/function/binding/pci-test.txt
similarity index 100%
rename from Documentation/PCI/endpoint/function/binding/pci-test.txt
rename to Documentation/drivers/PCI/endpoint/function/binding/pci-test.txt
diff --git a/Documentation/PCI/endpoint/pci-endpoint-cfs.txt b/Documentation/drivers/PCI/endpoint/pci-endpoint-cfs.txt
similarity index 100%
rename from Documentation/PCI/endpoint/pci-endpoint-cfs.txt
rename to Documentation/drivers/PCI/endpoint/pci-endpoint-cfs.txt
diff --git a/Documentation/PCI/endpoint/pci-endpoint.txt b/Documentation/drivers/PCI/endpoint/pci-endpoint.txt
similarity index 100%
rename from Documentation/PCI/endpoint/pci-endpoint.txt
rename to Documentation/drivers/PCI/endpoint/pci-endpoint.txt
diff --git a/Documentation/PCI/endpoint/pci-test-function.txt b/Documentation/drivers/PCI/endpoint/pci-test-function.txt
similarity index 100%
rename from Documentation/PCI/endpoint/pci-test-function.txt
rename to Documentation/drivers/PCI/endpoint/pci-test-function.txt
diff --git a/Documentation/PCI/endpoint/pci-test-howto.txt b/Documentation/drivers/PCI/endpoint/pci-test-howto.txt
similarity index 100%
rename from Documentation/PCI/endpoint/pci-test-howto.txt
rename to Documentation/drivers/PCI/endpoint/pci-test-howto.txt
diff --git a/Documentation/PCI/pci-error-recovery.txt b/Documentation/drivers/PCI/pci-error-recovery.txt
similarity index 100%
rename from Documentation/PCI/pci-error-recovery.txt
rename to Documentation/drivers/PCI/pci-error-recovery.txt
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/drivers/PCI/pci-iov-howto.txt
similarity index 100%
rename from Documentation/PCI/pci-iov-howto.txt
rename to Documentation/drivers/PCI/pci-iov-howto.txt
diff --git a/Documentation/PCI/pci.txt b/Documentation/drivers/PCI/pci.txt
similarity index 100%
rename from Documentation/PCI/pci.txt
rename to Documentation/drivers/PCI/pci.txt
diff --git a/Documentation/PCI/pcieaer-howto.txt b/Documentation/drivers/PCI/pcieaer-howto.txt
similarity index 100%
rename from Documentation/PCI/pcieaer-howto.txt
rename to Documentation/drivers/PCI/pcieaer-howto.txt
diff --git a/Documentation/acpi/dsd/leds.txt b/Documentation/drivers/acpi/dsd/leds.txt
similarity index 100%
rename from Documentation/acpi/dsd/leds.txt
rename to Documentation/drivers/acpi/dsd/leds.txt
diff --git a/Documentation/auxdisplay/cfag12864b b/Documentation/drivers/auxdisplay/cfag12864b
similarity index 100%
rename from Documentation/auxdisplay/cfag12864b
rename to Documentation/drivers/auxdisplay/cfag12864b
diff --git a/Documentation/auxdisplay/ks0108 b/Documentation/drivers/auxdisplay/ks0108
similarity index 100%
rename from Documentation/auxdisplay/ks0108
rename to Documentation/drivers/auxdisplay/ks0108
diff --git a/Documentation/auxdisplay/lcd-panel-cgram.txt b/Documentation/drivers/auxdisplay/lcd-panel-cgram.txt
similarity index 100%
rename from Documentation/auxdisplay/lcd-panel-cgram.txt
rename to Documentation/drivers/auxdisplay/lcd-panel-cgram.txt
diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/drivers/backlight/lp855x-driver.txt
similarity index 100%
rename from Documentation/backlight/lp855x-driver.txt
rename to Documentation/drivers/backlight/lp855x-driver.txt
diff --git a/Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg b/Documentation/drivers/blockdev/drbd/DRBD-8.3-data-packets.svg
similarity index 100%
rename from Documentation/blockdev/drbd/DRBD-8.3-data-packets.svg
rename to Documentation/drivers/blockdev/drbd/DRBD-8.3-data-packets.svg
diff --git a/Documentation/blockdev/drbd/DRBD-data-packets.svg b/Documentation/drivers/blockdev/drbd/DRBD-data-packets.svg
similarity index 100%
rename from Documentation/blockdev/drbd/DRBD-data-packets.svg
rename to Documentation/drivers/blockdev/drbd/DRBD-data-packets.svg
diff --git a/Documentation/blockdev/drbd/README.txt b/Documentation/drivers/blockdev/drbd/README.txt
similarity index 100%
rename from Documentation/blockdev/drbd/README.txt
rename to Documentation/drivers/blockdev/drbd/README.txt
diff --git a/Documentation/blockdev/drbd/conn-states-8.dot b/Documentation/drivers/blockdev/drbd/conn-states-8.dot
similarity index 100%
rename from Documentation/blockdev/drbd/conn-states-8.dot
rename to Documentation/drivers/blockdev/drbd/conn-states-8.dot
diff --git a/Documentation/blockdev/drbd/data-structure-v9.txt b/Documentation/drivers/blockdev/drbd/data-structure-v9.txt
similarity index 100%
rename from Documentation/blockdev/drbd/data-structure-v9.txt
rename to Documentation/drivers/blockdev/drbd/data-structure-v9.txt
diff --git a/Documentation/blockdev/drbd/disk-states-8.dot b/Documentation/drivers/blockdev/drbd/disk-states-8.dot
similarity index 100%
rename from Documentation/blockdev/drbd/disk-states-8.dot
rename to Documentation/drivers/blockdev/drbd/disk-states-8.dot
diff --git a/Documentation/blockdev/drbd/drbd-connection-state-overview.dot b/Documentation/drivers/blockdev/drbd/drbd-connection-state-overview.dot
similarity index 100%
rename from Documentation/blockdev/drbd/drbd-connection-state-overview.dot
rename to Documentation/drivers/blockdev/drbd/drbd-connection-state-overview.dot
diff --git a/Documentation/blockdev/drbd/node-states-8.dot b/Documentation/drivers/blockdev/drbd/node-states-8.dot
similarity index 100%
rename from Documentation/blockdev/drbd/node-states-8.dot
rename to Documentation/drivers/blockdev/drbd/node-states-8.dot
diff --git a/Documentation/blockdev/floppy.txt b/Documentation/drivers/blockdev/floppy.txt
similarity index 100%
rename from Documentation/blockdev/floppy.txt
rename to Documentation/drivers/blockdev/floppy.txt
diff --git a/Documentation/blockdev/nbd.txt b/Documentation/drivers/blockdev/nbd.txt
similarity index 100%
rename from Documentation/blockdev/nbd.txt
rename to Documentation/drivers/blockdev/nbd.txt
diff --git a/Documentation/blockdev/paride.txt b/Documentation/drivers/blockdev/paride.txt
similarity index 100%
rename from Documentation/blockdev/paride.txt
rename to Documentation/drivers/blockdev/paride.txt
diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/drivers/blockdev/ramdisk.txt
similarity index 100%
rename from Documentation/blockdev/ramdisk.txt
rename to Documentation/drivers/blockdev/ramdisk.txt
diff --git a/Documentation/blockdev/zram.txt b/Documentation/drivers/blockdev/zram.txt
similarity index 100%
rename from Documentation/blockdev/zram.txt
rename to Documentation/drivers/blockdev/zram.txt
diff --git a/Documentation/bus-devices/ti-gpmc.txt b/Documentation/drivers/bus/ti-gpmc.txt
similarity index 100%
rename from Documentation/bus-devices/ti-gpmc.txt
rename to Documentation/drivers/bus/ti-gpmc.txt
diff --git a/Documentation/cdrom/cdrom-standard.rst b/Documentation/drivers/cdrom/cdrom-standard.rst
similarity index 100%
rename from Documentation/cdrom/cdrom-standard.rst
rename to Documentation/drivers/cdrom/cdrom-standard.rst
diff --git a/Documentation/cdrom/ide-cd.rst b/Documentation/drivers/cdrom/ide-cd.rst
similarity index 100%
rename from Documentation/cdrom/ide-cd.rst
rename to Documentation/drivers/cdrom/ide-cd.rst
diff --git a/Documentation/cdrom/index.rst b/Documentation/drivers/cdrom/index.rst
similarity index 100%
rename from Documentation/cdrom/index.rst
rename to Documentation/drivers/cdrom/index.rst
diff --git a/Documentation/cdrom/packet-writing.rst b/Documentation/drivers/cdrom/packet-writing.rst
similarity index 100%
rename from Documentation/cdrom/packet-writing.rst
rename to Documentation/drivers/cdrom/packet-writing.rst
diff --git a/Documentation/cpu-freq/amd-powernow.txt b/Documentation/drivers/cpu-freq/amd-powernow.txt
similarity index 100%
rename from Documentation/cpu-freq/amd-powernow.txt
rename to Documentation/drivers/cpu-freq/amd-powernow.txt
diff --git a/Documentation/cpu-freq/core.txt b/Documentation/drivers/cpu-freq/core.txt
similarity index 100%
rename from Documentation/cpu-freq/core.txt
rename to Documentation/drivers/cpu-freq/core.txt
diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/drivers/cpu-freq/cpu-drivers.txt
similarity index 100%
rename from Documentation/cpu-freq/cpu-drivers.txt
rename to Documentation/drivers/cpu-freq/cpu-drivers.txt
diff --git a/Documentation/cpu-freq/cpufreq-nforce2.txt b/Documentation/drivers/cpu-freq/cpufreq-nforce2.txt
similarity index 100%
rename from Documentation/cpu-freq/cpufreq-nforce2.txt
rename to Documentation/drivers/cpu-freq/cpufreq-nforce2.txt
diff --git a/Documentation/cpu-freq/cpufreq-stats.txt b/Documentation/drivers/cpu-freq/cpufreq-stats.txt
similarity index 100%
rename from Documentation/cpu-freq/cpufreq-stats.txt
rename to Documentation/drivers/cpu-freq/cpufreq-stats.txt
diff --git a/Documentation/cpu-freq/index.txt b/Documentation/drivers/cpu-freq/index.txt
similarity index 100%
rename from Documentation/cpu-freq/index.txt
rename to Documentation/drivers/cpu-freq/index.txt
diff --git a/Documentation/cpu-freq/pcc-cpufreq.txt b/Documentation/drivers/cpu-freq/pcc-cpufreq.txt
similarity index 100%
rename from Documentation/cpu-freq/pcc-cpufreq.txt
rename to Documentation/drivers/cpu-freq/pcc-cpufreq.txt
diff --git a/Documentation/crypto/api-aead.rst b/Documentation/drivers/crypto/api-aead.rst
similarity index 100%
rename from Documentation/crypto/api-aead.rst
rename to Documentation/drivers/crypto/api-aead.rst
diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/drivers/crypto/api-akcipher.rst
similarity index 100%
rename from Documentation/crypto/api-akcipher.rst
rename to Documentation/drivers/crypto/api-akcipher.rst
diff --git a/Documentation/crypto/api-digest.rst b/Documentation/drivers/crypto/api-digest.rst
similarity index 100%
rename from Documentation/crypto/api-digest.rst
rename to Documentation/drivers/crypto/api-digest.rst
diff --git a/Documentation/crypto/api-intro.txt b/Documentation/drivers/crypto/api-intro.txt
similarity index 100%
rename from Documentation/crypto/api-intro.txt
rename to Documentation/drivers/crypto/api-intro.txt
diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/drivers/crypto/api-kpp.rst
similarity index 100%
rename from Documentation/crypto/api-kpp.rst
rename to Documentation/drivers/crypto/api-kpp.rst
diff --git a/Documentation/crypto/api-rng.rst b/Documentation/drivers/crypto/api-rng.rst
similarity index 100%
rename from Documentation/crypto/api-rng.rst
rename to Documentation/drivers/crypto/api-rng.rst
diff --git a/Documentation/crypto/api-samples.rst b/Documentation/drivers/crypto/api-samples.rst
similarity index 100%
rename from Documentation/crypto/api-samples.rst
rename to Documentation/drivers/crypto/api-samples.rst
diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/drivers/crypto/api-skcipher.rst
similarity index 100%
rename from Documentation/crypto/api-skcipher.rst
rename to Documentation/drivers/crypto/api-skcipher.rst
diff --git a/Documentation/crypto/api.rst b/Documentation/drivers/crypto/api.rst
similarity index 100%
rename from Documentation/crypto/api.rst
rename to Documentation/drivers/crypto/api.rst
diff --git a/Documentation/crypto/architecture.rst b/Documentation/drivers/crypto/architecture.rst
similarity index 100%
rename from Documentation/crypto/architecture.rst
rename to Documentation/drivers/crypto/architecture.rst
diff --git a/Documentation/crypto/asymmetric-keys.txt b/Documentation/drivers/crypto/asymmetric-keys.txt
similarity index 100%
rename from Documentation/crypto/asymmetric-keys.txt
rename to Documentation/drivers/crypto/asymmetric-keys.txt
diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/drivers/crypto/async-tx-api.txt
similarity index 100%
rename from Documentation/crypto/async-tx-api.txt
rename to Documentation/drivers/crypto/async-tx-api.txt
diff --git a/Documentation/crypto/conf.py b/Documentation/drivers/crypto/conf.py
similarity index 100%
rename from Documentation/crypto/conf.py
rename to Documentation/drivers/crypto/conf.py
diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/drivers/crypto/crypto_engine.rst
similarity index 100%
rename from Documentation/crypto/crypto_engine.rst
rename to Documentation/drivers/crypto/crypto_engine.rst
diff --git a/Documentation/crypto/descore-readme.txt b/Documentation/drivers/crypto/descore-readme.txt
similarity index 100%
rename from Documentation/crypto/descore-readme.txt
rename to Documentation/drivers/crypto/descore-readme.txt
diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/drivers/crypto/devel-algos.rst
similarity index 100%
rename from Documentation/crypto/devel-algos.rst
rename to Documentation/drivers/crypto/devel-algos.rst
diff --git a/Documentation/crypto/index.rst b/Documentation/drivers/crypto/index.rst
similarity index 100%
rename from Documentation/crypto/index.rst
rename to Documentation/drivers/crypto/index.rst
diff --git a/Documentation/crypto/intro.rst b/Documentation/drivers/crypto/intro.rst
similarity index 100%
rename from Documentation/crypto/intro.rst
rename to Documentation/drivers/crypto/intro.rst
diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/drivers/crypto/userspace-if.rst
similarity index 100%
rename from Documentation/crypto/userspace-if.rst
rename to Documentation/drivers/crypto/userspace-if.rst
diff --git a/Documentation/device-mapper/cache-policies.rst b/Documentation/drivers/device-mapper/cache-policies.rst
similarity index 100%
rename from Documentation/device-mapper/cache-policies.rst
rename to Documentation/drivers/device-mapper/cache-policies.rst
diff --git a/Documentation/device-mapper/cache.rst b/Documentation/drivers/device-mapper/cache.rst
similarity index 100%
rename from Documentation/device-mapper/cache.rst
rename to Documentation/drivers/device-mapper/cache.rst
diff --git a/Documentation/device-mapper/delay.rst b/Documentation/drivers/device-mapper/delay.rst
similarity index 100%
rename from Documentation/device-mapper/delay.rst
rename to Documentation/drivers/device-mapper/delay.rst
diff --git a/Documentation/device-mapper/dm-crypt.rst b/Documentation/drivers/device-mapper/dm-crypt.rst
similarity index 100%
rename from Documentation/device-mapper/dm-crypt.rst
rename to Documentation/drivers/device-mapper/dm-crypt.rst
diff --git a/Documentation/device-mapper/dm-dust.txt b/Documentation/drivers/device-mapper/dm-dust.txt
similarity index 100%
rename from Documentation/device-mapper/dm-dust.txt
rename to Documentation/drivers/device-mapper/dm-dust.txt
diff --git a/Documentation/device-mapper/dm-flakey.rst b/Documentation/drivers/device-mapper/dm-flakey.rst
similarity index 100%
rename from Documentation/device-mapper/dm-flakey.rst
rename to Documentation/drivers/device-mapper/dm-flakey.rst
diff --git a/Documentation/device-mapper/dm-init.rst b/Documentation/drivers/device-mapper/dm-init.rst
similarity index 100%
rename from Documentation/device-mapper/dm-init.rst
rename to Documentation/drivers/device-mapper/dm-init.rst
diff --git a/Documentation/device-mapper/dm-integrity.rst b/Documentation/drivers/device-mapper/dm-integrity.rst
similarity index 100%
rename from Documentation/device-mapper/dm-integrity.rst
rename to Documentation/drivers/device-mapper/dm-integrity.rst
diff --git a/Documentation/device-mapper/dm-io.rst b/Documentation/drivers/device-mapper/dm-io.rst
similarity index 100%
rename from Documentation/device-mapper/dm-io.rst
rename to Documentation/drivers/device-mapper/dm-io.rst
diff --git a/Documentation/device-mapper/dm-log.rst b/Documentation/drivers/device-mapper/dm-log.rst
similarity index 100%
rename from Documentation/device-mapper/dm-log.rst
rename to Documentation/drivers/device-mapper/dm-log.rst
diff --git a/Documentation/device-mapper/dm-queue-length.rst b/Documentation/drivers/device-mapper/dm-queue-length.rst
similarity index 100%
rename from Documentation/device-mapper/dm-queue-length.rst
rename to Documentation/drivers/device-mapper/dm-queue-length.rst
diff --git a/Documentation/device-mapper/dm-raid.rst b/Documentation/drivers/device-mapper/dm-raid.rst
similarity index 100%
rename from Documentation/device-mapper/dm-raid.rst
rename to Documentation/drivers/device-mapper/dm-raid.rst
diff --git a/Documentation/device-mapper/dm-service-time.rst b/Documentation/drivers/device-mapper/dm-service-time.rst
similarity index 100%
rename from Documentation/device-mapper/dm-service-time.rst
rename to Documentation/drivers/device-mapper/dm-service-time.rst
diff --git a/Documentation/device-mapper/dm-uevent.rst b/Documentation/drivers/device-mapper/dm-uevent.rst
similarity index 100%
rename from Documentation/device-mapper/dm-uevent.rst
rename to Documentation/drivers/device-mapper/dm-uevent.rst
diff --git a/Documentation/device-mapper/dm-zoned.rst b/Documentation/drivers/device-mapper/dm-zoned.rst
similarity index 100%
rename from Documentation/device-mapper/dm-zoned.rst
rename to Documentation/drivers/device-mapper/dm-zoned.rst
diff --git a/Documentation/device-mapper/era.rst b/Documentation/drivers/device-mapper/era.rst
similarity index 100%
rename from Documentation/device-mapper/era.rst
rename to Documentation/drivers/device-mapper/era.rst
diff --git a/Documentation/device-mapper/index.rst b/Documentation/drivers/device-mapper/index.rst
similarity index 100%
rename from Documentation/device-mapper/index.rst
rename to Documentation/drivers/device-mapper/index.rst
diff --git a/Documentation/device-mapper/kcopyd.rst b/Documentation/drivers/device-mapper/kcopyd.rst
similarity index 100%
rename from Documentation/device-mapper/kcopyd.rst
rename to Documentation/drivers/device-mapper/kcopyd.rst
diff --git a/Documentation/device-mapper/linear.rst b/Documentation/drivers/device-mapper/linear.rst
similarity index 100%
rename from Documentation/device-mapper/linear.rst
rename to Documentation/drivers/device-mapper/linear.rst
diff --git a/Documentation/device-mapper/log-writes.rst b/Documentation/drivers/device-mapper/log-writes.rst
similarity index 100%
rename from Documentation/device-mapper/log-writes.rst
rename to Documentation/drivers/device-mapper/log-writes.rst
diff --git a/Documentation/device-mapper/persistent-data.rst b/Documentation/drivers/device-mapper/persistent-data.rst
similarity index 100%
rename from Documentation/device-mapper/persistent-data.rst
rename to Documentation/drivers/device-mapper/persistent-data.rst
diff --git a/Documentation/device-mapper/snapshot.rst b/Documentation/drivers/device-mapper/snapshot.rst
similarity index 100%
rename from Documentation/device-mapper/snapshot.rst
rename to Documentation/drivers/device-mapper/snapshot.rst
diff --git a/Documentation/device-mapper/statistics.rst b/Documentation/drivers/device-mapper/statistics.rst
similarity index 100%
rename from Documentation/device-mapper/statistics.rst
rename to Documentation/drivers/device-mapper/statistics.rst
diff --git a/Documentation/device-mapper/striped.rst b/Documentation/drivers/device-mapper/striped.rst
similarity index 100%
rename from Documentation/device-mapper/striped.rst
rename to Documentation/drivers/device-mapper/striped.rst
diff --git a/Documentation/device-mapper/switch.rst b/Documentation/drivers/device-mapper/switch.rst
similarity index 100%
rename from Documentation/device-mapper/switch.rst
rename to Documentation/drivers/device-mapper/switch.rst
diff --git a/Documentation/device-mapper/thin-provisioning.rst b/Documentation/drivers/device-mapper/thin-provisioning.rst
similarity index 100%
rename from Documentation/device-mapper/thin-provisioning.rst
rename to Documentation/drivers/device-mapper/thin-provisioning.rst
diff --git a/Documentation/device-mapper/unstriped.rst b/Documentation/drivers/device-mapper/unstriped.rst
similarity index 100%
rename from Documentation/device-mapper/unstriped.rst
rename to Documentation/drivers/device-mapper/unstriped.rst
diff --git a/Documentation/device-mapper/verity.rst b/Documentation/drivers/device-mapper/verity.rst
similarity index 100%
rename from Documentation/device-mapper/verity.rst
rename to Documentation/drivers/device-mapper/verity.rst
diff --git a/Documentation/device-mapper/writecache.rst b/Documentation/drivers/device-mapper/writecache.rst
similarity index 100%
rename from Documentation/device-mapper/writecache.rst
rename to Documentation/drivers/device-mapper/writecache.rst
diff --git a/Documentation/device-mapper/zero.rst b/Documentation/drivers/device-mapper/zero.rst
similarity index 100%
rename from Documentation/device-mapper/zero.rst
rename to Documentation/drivers/device-mapper/zero.rst
diff --git a/Documentation/driver-api/80211/cfg80211.rst b/Documentation/drivers/driver-api/80211/cfg80211.rst
similarity index 100%
rename from Documentation/driver-api/80211/cfg80211.rst
rename to Documentation/drivers/driver-api/80211/cfg80211.rst
diff --git a/Documentation/driver-api/80211/conf.py b/Documentation/drivers/driver-api/80211/conf.py
similarity index 100%
rename from Documentation/driver-api/80211/conf.py
rename to Documentation/drivers/driver-api/80211/conf.py
diff --git a/Documentation/driver-api/80211/index.rst b/Documentation/drivers/driver-api/80211/index.rst
similarity index 100%
rename from Documentation/driver-api/80211/index.rst
rename to Documentation/drivers/driver-api/80211/index.rst
diff --git a/Documentation/driver-api/80211/introduction.rst b/Documentation/drivers/driver-api/80211/introduction.rst
similarity index 100%
rename from Documentation/driver-api/80211/introduction.rst
rename to Documentation/drivers/driver-api/80211/introduction.rst
diff --git a/Documentation/driver-api/80211/mac80211-advanced.rst b/Documentation/drivers/driver-api/80211/mac80211-advanced.rst
similarity index 100%
rename from Documentation/driver-api/80211/mac80211-advanced.rst
rename to Documentation/drivers/driver-api/80211/mac80211-advanced.rst
diff --git a/Documentation/driver-api/80211/mac80211.rst b/Documentation/drivers/driver-api/80211/mac80211.rst
similarity index 100%
rename from Documentation/driver-api/80211/mac80211.rst
rename to Documentation/drivers/driver-api/80211/mac80211.rst
diff --git a/Documentation/driver-api/acpi/index.rst b/Documentation/drivers/driver-api/acpi/index.rst
similarity index 100%
rename from Documentation/driver-api/acpi/index.rst
rename to Documentation/drivers/driver-api/acpi/index.rst
diff --git a/Documentation/driver-api/acpi/linuxized-acpica.rst b/Documentation/drivers/driver-api/acpi/linuxized-acpica.rst
similarity index 100%
rename from Documentation/driver-api/acpi/linuxized-acpica.rst
rename to Documentation/drivers/driver-api/acpi/linuxized-acpica.rst
diff --git a/Documentation/driver-api/acpi/scan_handlers.rst b/Documentation/drivers/driver-api/acpi/scan_handlers.rst
similarity index 100%
rename from Documentation/driver-api/acpi/scan_handlers.rst
rename to Documentation/drivers/driver-api/acpi/scan_handlers.rst
diff --git a/Documentation/driver-api/basics.rst b/Documentation/drivers/driver-api/basics.rst
similarity index 100%
rename from Documentation/driver-api/basics.rst
rename to Documentation/drivers/driver-api/basics.rst
diff --git a/Documentation/driver-api/clk.rst b/Documentation/drivers/driver-api/clk.rst
similarity index 100%
rename from Documentation/driver-api/clk.rst
rename to Documentation/drivers/driver-api/clk.rst
diff --git a/Documentation/driver-api/component.rst b/Documentation/drivers/driver-api/component.rst
similarity index 100%
rename from Documentation/driver-api/component.rst
rename to Documentation/drivers/driver-api/component.rst
diff --git a/Documentation/driver-api/conf.py b/Documentation/drivers/driver-api/conf.py
similarity index 100%
rename from Documentation/driver-api/conf.py
rename to Documentation/drivers/driver-api/conf.py
diff --git a/Documentation/driver-api/device-io.rst b/Documentation/drivers/driver-api/device-io.rst
similarity index 100%
rename from Documentation/driver-api/device-io.rst
rename to Documentation/drivers/driver-api/device-io.rst
diff --git a/Documentation/driver-api/device_connection.rst b/Documentation/drivers/driver-api/device_connection.rst
similarity index 100%
rename from Documentation/driver-api/device_connection.rst
rename to Documentation/drivers/driver-api/device_connection.rst
diff --git a/Documentation/driver-api/device_link.rst b/Documentation/drivers/driver-api/device_link.rst
similarity index 100%
rename from Documentation/driver-api/device_link.rst
rename to Documentation/drivers/driver-api/device_link.rst
diff --git a/Documentation/driver-api/dma-buf.rst b/Documentation/drivers/driver-api/dma-buf.rst
similarity index 100%
rename from Documentation/driver-api/dma-buf.rst
rename to Documentation/drivers/driver-api/dma-buf.rst
diff --git a/Documentation/driver-api/dmaengine/client.rst b/Documentation/drivers/driver-api/dmaengine/client.rst
similarity index 100%
rename from Documentation/driver-api/dmaengine/client.rst
rename to Documentation/drivers/driver-api/dmaengine/client.rst
diff --git a/Documentation/driver-api/dmaengine/dmatest.rst b/Documentation/drivers/driver-api/dmaengine/dmatest.rst
similarity index 100%
rename from Documentation/driver-api/dmaengine/dmatest.rst
rename to Documentation/drivers/driver-api/dmaengine/dmatest.rst
diff --git a/Documentation/driver-api/dmaengine/index.rst b/Documentation/drivers/driver-api/dmaengine/index.rst
similarity index 100%
rename from Documentation/driver-api/dmaengine/index.rst
rename to Documentation/drivers/driver-api/dmaengine/index.rst
diff --git a/Documentation/driver-api/dmaengine/provider.rst b/Documentation/drivers/driver-api/dmaengine/provider.rst
similarity index 100%
rename from Documentation/driver-api/dmaengine/provider.rst
rename to Documentation/drivers/driver-api/dmaengine/provider.rst
diff --git a/Documentation/driver-api/dmaengine/pxa_dma.rst b/Documentation/drivers/driver-api/dmaengine/pxa_dma.rst
similarity index 100%
rename from Documentation/driver-api/dmaengine/pxa_dma.rst
rename to Documentation/drivers/driver-api/dmaengine/pxa_dma.rst
diff --git a/Documentation/driver-api/edac.rst b/Documentation/drivers/driver-api/edac.rst
similarity index 100%
rename from Documentation/driver-api/edac.rst
rename to Documentation/drivers/driver-api/edac.rst
diff --git a/Documentation/driver-api/firewire.rst b/Documentation/drivers/driver-api/firewire.rst
similarity index 100%
rename from Documentation/driver-api/firewire.rst
rename to Documentation/drivers/driver-api/firewire.rst
diff --git a/Documentation/driver-api/firmware/built-in-fw.rst b/Documentation/drivers/driver-api/firmware/built-in-fw.rst
similarity index 100%
rename from Documentation/driver-api/firmware/built-in-fw.rst
rename to Documentation/drivers/driver-api/firmware/built-in-fw.rst
diff --git a/Documentation/driver-api/firmware/core.rst b/Documentation/drivers/driver-api/firmware/core.rst
similarity index 100%
rename from Documentation/driver-api/firmware/core.rst
rename to Documentation/drivers/driver-api/firmware/core.rst
diff --git a/Documentation/driver-api/firmware/direct-fs-lookup.rst b/Documentation/drivers/driver-api/firmware/direct-fs-lookup.rst
similarity index 100%
rename from Documentation/driver-api/firmware/direct-fs-lookup.rst
rename to Documentation/drivers/driver-api/firmware/direct-fs-lookup.rst
diff --git a/Documentation/driver-api/firmware/fallback-mechanisms.rst b/Documentation/drivers/driver-api/firmware/fallback-mechanisms.rst
similarity index 100%
rename from Documentation/driver-api/firmware/fallback-mechanisms.rst
rename to Documentation/drivers/driver-api/firmware/fallback-mechanisms.rst
diff --git a/Documentation/driver-api/firmware/firmware_cache.rst b/Documentation/drivers/driver-api/firmware/firmware_cache.rst
similarity index 100%
rename from Documentation/driver-api/firmware/firmware_cache.rst
rename to Documentation/drivers/driver-api/firmware/firmware_cache.rst
diff --git a/Documentation/driver-api/firmware/fw_search_path.rst b/Documentation/drivers/driver-api/firmware/fw_search_path.rst
similarity index 100%
rename from Documentation/driver-api/firmware/fw_search_path.rst
rename to Documentation/drivers/driver-api/firmware/fw_search_path.rst
diff --git a/Documentation/driver-api/firmware/index.rst b/Documentation/drivers/driver-api/firmware/index.rst
similarity index 100%
rename from Documentation/driver-api/firmware/index.rst
rename to Documentation/drivers/driver-api/firmware/index.rst
diff --git a/Documentation/driver-api/firmware/introduction.rst b/Documentation/drivers/driver-api/firmware/introduction.rst
similarity index 100%
rename from Documentation/driver-api/firmware/introduction.rst
rename to Documentation/drivers/driver-api/firmware/introduction.rst
diff --git a/Documentation/driver-api/firmware/lookup-order.rst b/Documentation/drivers/driver-api/firmware/lookup-order.rst
similarity index 100%
rename from Documentation/driver-api/firmware/lookup-order.rst
rename to Documentation/drivers/driver-api/firmware/lookup-order.rst
diff --git a/Documentation/driver-api/firmware/other_interfaces.rst b/Documentation/drivers/driver-api/firmware/other_interfaces.rst
similarity index 100%
rename from Documentation/driver-api/firmware/other_interfaces.rst
rename to Documentation/drivers/driver-api/firmware/other_interfaces.rst
diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/drivers/driver-api/firmware/request_firmware.rst
similarity index 100%
rename from Documentation/driver-api/firmware/request_firmware.rst
rename to Documentation/drivers/driver-api/firmware/request_firmware.rst
diff --git a/Documentation/driver-api/fpga/fpga-bridge.rst b/Documentation/drivers/driver-api/fpga/fpga-bridge.rst
similarity index 100%
rename from Documentation/driver-api/fpga/fpga-bridge.rst
rename to Documentation/drivers/driver-api/fpga/fpga-bridge.rst
diff --git a/Documentation/driver-api/fpga/fpga-mgr.rst b/Documentation/drivers/driver-api/fpga/fpga-mgr.rst
similarity index 100%
rename from Documentation/driver-api/fpga/fpga-mgr.rst
rename to Documentation/drivers/driver-api/fpga/fpga-mgr.rst
diff --git a/Documentation/driver-api/fpga/fpga-programming.rst b/Documentation/drivers/driver-api/fpga/fpga-programming.rst
similarity index 100%
rename from Documentation/driver-api/fpga/fpga-programming.rst
rename to Documentation/drivers/driver-api/fpga/fpga-programming.rst
diff --git a/Documentation/driver-api/fpga/fpga-region.rst b/Documentation/drivers/driver-api/fpga/fpga-region.rst
similarity index 100%
rename from Documentation/driver-api/fpga/fpga-region.rst
rename to Documentation/drivers/driver-api/fpga/fpga-region.rst
diff --git a/Documentation/driver-api/fpga/index.rst b/Documentation/drivers/driver-api/fpga/index.rst
similarity index 100%
rename from Documentation/driver-api/fpga/index.rst
rename to Documentation/drivers/driver-api/fpga/index.rst
diff --git a/Documentation/driver-api/fpga/intro.rst b/Documentation/drivers/driver-api/fpga/intro.rst
similarity index 100%
rename from Documentation/driver-api/fpga/intro.rst
rename to Documentation/drivers/driver-api/fpga/intro.rst
diff --git a/Documentation/driver-api/frame-buffer.rst b/Documentation/drivers/driver-api/frame-buffer.rst
similarity index 100%
rename from Documentation/driver-api/frame-buffer.rst
rename to Documentation/drivers/driver-api/frame-buffer.rst
diff --git a/Documentation/driver-api/generic-counter.rst b/Documentation/drivers/driver-api/generic-counter.rst
similarity index 100%
rename from Documentation/driver-api/generic-counter.rst
rename to Documentation/drivers/driver-api/generic-counter.rst
diff --git a/Documentation/driver-api/gpio/board.rst b/Documentation/drivers/driver-api/gpio/board.rst
similarity index 100%
rename from Documentation/driver-api/gpio/board.rst
rename to Documentation/drivers/driver-api/gpio/board.rst
diff --git a/Documentation/driver-api/gpio/consumer.rst b/Documentation/drivers/driver-api/gpio/consumer.rst
similarity index 100%
rename from Documentation/driver-api/gpio/consumer.rst
rename to Documentation/drivers/driver-api/gpio/consumer.rst
diff --git a/Documentation/driver-api/gpio/driver.rst b/Documentation/drivers/driver-api/gpio/driver.rst
similarity index 100%
rename from Documentation/driver-api/gpio/driver.rst
rename to Documentation/drivers/driver-api/gpio/driver.rst
diff --git a/Documentation/driver-api/gpio/drivers-on-gpio.rst b/Documentation/drivers/driver-api/gpio/drivers-on-gpio.rst
similarity index 100%
rename from Documentation/driver-api/gpio/drivers-on-gpio.rst
rename to Documentation/drivers/driver-api/gpio/drivers-on-gpio.rst
diff --git a/Documentation/driver-api/gpio/index.rst b/Documentation/drivers/driver-api/gpio/index.rst
similarity index 100%
rename from Documentation/driver-api/gpio/index.rst
rename to Documentation/drivers/driver-api/gpio/index.rst
diff --git a/Documentation/driver-api/gpio/intro.rst b/Documentation/drivers/driver-api/gpio/intro.rst
similarity index 100%
rename from Documentation/driver-api/gpio/intro.rst
rename to Documentation/drivers/driver-api/gpio/intro.rst
diff --git a/Documentation/driver-api/gpio/legacy.rst b/Documentation/drivers/driver-api/gpio/legacy.rst
similarity index 100%
rename from Documentation/driver-api/gpio/legacy.rst
rename to Documentation/drivers/driver-api/gpio/legacy.rst
diff --git a/Documentation/driver-api/hsi.rst b/Documentation/drivers/driver-api/hsi.rst
similarity index 100%
rename from Documentation/driver-api/hsi.rst
rename to Documentation/drivers/driver-api/hsi.rst
diff --git a/Documentation/driver-api/i2c.rst b/Documentation/drivers/driver-api/i2c.rst
similarity index 100%
rename from Documentation/driver-api/i2c.rst
rename to Documentation/drivers/driver-api/i2c.rst
diff --git a/Documentation/driver-api/i3c/device-driver-api.rst b/Documentation/drivers/driver-api/i3c/device-driver-api.rst
similarity index 100%
rename from Documentation/driver-api/i3c/device-driver-api.rst
rename to Documentation/drivers/driver-api/i3c/device-driver-api.rst
diff --git a/Documentation/driver-api/i3c/index.rst b/Documentation/drivers/driver-api/i3c/index.rst
similarity index 100%
rename from Documentation/driver-api/i3c/index.rst
rename to Documentation/drivers/driver-api/i3c/index.rst
diff --git a/Documentation/driver-api/i3c/master-driver-api.rst b/Documentation/drivers/driver-api/i3c/master-driver-api.rst
similarity index 100%
rename from Documentation/driver-api/i3c/master-driver-api.rst
rename to Documentation/drivers/driver-api/i3c/master-driver-api.rst
diff --git a/Documentation/driver-api/i3c/protocol.rst b/Documentation/drivers/driver-api/i3c/protocol.rst
similarity index 100%
rename from Documentation/driver-api/i3c/protocol.rst
rename to Documentation/drivers/driver-api/i3c/protocol.rst
diff --git a/Documentation/driver-api/iio/buffers.rst b/Documentation/drivers/driver-api/iio/buffers.rst
similarity index 100%
rename from Documentation/driver-api/iio/buffers.rst
rename to Documentation/drivers/driver-api/iio/buffers.rst
diff --git a/Documentation/driver-api/iio/core.rst b/Documentation/drivers/driver-api/iio/core.rst
similarity index 100%
rename from Documentation/driver-api/iio/core.rst
rename to Documentation/drivers/driver-api/iio/core.rst
diff --git a/Documentation/driver-api/iio/hw-consumer.rst b/Documentation/drivers/driver-api/iio/hw-consumer.rst
similarity index 100%
rename from Documentation/driver-api/iio/hw-consumer.rst
rename to Documentation/drivers/driver-api/iio/hw-consumer.rst
diff --git a/Documentation/driver-api/iio/index.rst b/Documentation/drivers/driver-api/iio/index.rst
similarity index 100%
rename from Documentation/driver-api/iio/index.rst
rename to Documentation/drivers/driver-api/iio/index.rst
diff --git a/Documentation/driver-api/iio/intro.rst b/Documentation/drivers/driver-api/iio/intro.rst
similarity index 100%
rename from Documentation/driver-api/iio/intro.rst
rename to Documentation/drivers/driver-api/iio/intro.rst
diff --git a/Documentation/driver-api/iio/triggered-buffers.rst b/Documentation/drivers/driver-api/iio/triggered-buffers.rst
similarity index 100%
rename from Documentation/driver-api/iio/triggered-buffers.rst
rename to Documentation/drivers/driver-api/iio/triggered-buffers.rst
diff --git a/Documentation/driver-api/iio/triggers.rst b/Documentation/drivers/driver-api/iio/triggers.rst
similarity index 100%
rename from Documentation/driver-api/iio/triggers.rst
rename to Documentation/drivers/driver-api/iio/triggers.rst
diff --git a/Documentation/driver-api/index.rst b/Documentation/drivers/driver-api/index.rst
similarity index 100%
rename from Documentation/driver-api/index.rst
rename to Documentation/drivers/driver-api/index.rst
diff --git a/Documentation/driver-api/infrastructure.rst b/Documentation/drivers/driver-api/infrastructure.rst
similarity index 100%
rename from Documentation/driver-api/infrastructure.rst
rename to Documentation/drivers/driver-api/infrastructure.rst
diff --git a/Documentation/driver-api/input.rst b/Documentation/drivers/driver-api/input.rst
similarity index 100%
rename from Documentation/driver-api/input.rst
rename to Documentation/drivers/driver-api/input.rst
diff --git a/Documentation/driver-api/libata.rst b/Documentation/drivers/driver-api/libata.rst
similarity index 100%
rename from Documentation/driver-api/libata.rst
rename to Documentation/drivers/driver-api/libata.rst
diff --git a/Documentation/driver-api/message-based.rst b/Documentation/drivers/driver-api/message-based.rst
similarity index 100%
rename from Documentation/driver-api/message-based.rst
rename to Documentation/drivers/driver-api/message-based.rst
diff --git a/Documentation/driver-api/misc_devices.rst b/Documentation/drivers/driver-api/misc_devices.rst
similarity index 100%
rename from Documentation/driver-api/misc_devices.rst
rename to Documentation/drivers/driver-api/misc_devices.rst
diff --git a/Documentation/driver-api/miscellaneous.rst b/Documentation/drivers/driver-api/miscellaneous.rst
similarity index 100%
rename from Documentation/driver-api/miscellaneous.rst
rename to Documentation/drivers/driver-api/miscellaneous.rst
diff --git a/Documentation/driver-api/mtdnand.rst b/Documentation/drivers/driver-api/mtdnand.rst
similarity index 100%
rename from Documentation/driver-api/mtdnand.rst
rename to Documentation/drivers/driver-api/mtdnand.rst
diff --git a/Documentation/driver-api/pci/index.rst b/Documentation/drivers/driver-api/pci/index.rst
similarity index 100%
rename from Documentation/driver-api/pci/index.rst
rename to Documentation/drivers/driver-api/pci/index.rst
diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/drivers/driver-api/pci/p2pdma.rst
similarity index 100%
rename from Documentation/driver-api/pci/p2pdma.rst
rename to Documentation/drivers/driver-api/pci/p2pdma.rst
diff --git a/Documentation/driver-api/pci/pci.rst b/Documentation/drivers/driver-api/pci/pci.rst
similarity index 100%
rename from Documentation/driver-api/pci/pci.rst
rename to Documentation/drivers/driver-api/pci/pci.rst
diff --git a/Documentation/driver-api/pinctl.rst b/Documentation/drivers/driver-api/pinctl.rst
similarity index 100%
rename from Documentation/driver-api/pinctl.rst
rename to Documentation/drivers/driver-api/pinctl.rst
diff --git a/Documentation/driver-api/pm/conf.py b/Documentation/drivers/driver-api/pm/conf.py
similarity index 100%
rename from Documentation/driver-api/pm/conf.py
rename to Documentation/drivers/driver-api/pm/conf.py
diff --git a/Documentation/driver-api/pm/cpuidle.rst b/Documentation/drivers/driver-api/pm/cpuidle.rst
similarity index 100%
rename from Documentation/driver-api/pm/cpuidle.rst
rename to Documentation/drivers/driver-api/pm/cpuidle.rst
diff --git a/Documentation/driver-api/pm/devices.rst b/Documentation/drivers/driver-api/pm/devices.rst
similarity index 100%
rename from Documentation/driver-api/pm/devices.rst
rename to Documentation/drivers/driver-api/pm/devices.rst
diff --git a/Documentation/driver-api/pm/index.rst b/Documentation/drivers/driver-api/pm/index.rst
similarity index 100%
rename from Documentation/driver-api/pm/index.rst
rename to Documentation/drivers/driver-api/pm/index.rst
diff --git a/Documentation/driver-api/pm/notifiers.rst b/Documentation/drivers/driver-api/pm/notifiers.rst
similarity index 100%
rename from Documentation/driver-api/pm/notifiers.rst
rename to Documentation/drivers/driver-api/pm/notifiers.rst
diff --git a/Documentation/driver-api/pm/types.rst b/Documentation/drivers/driver-api/pm/types.rst
similarity index 100%
rename from Documentation/driver-api/pm/types.rst
rename to Documentation/drivers/driver-api/pm/types.rst
diff --git a/Documentation/driver-api/pps.rst b/Documentation/drivers/driver-api/pps.rst
similarity index 100%
rename from Documentation/driver-api/pps.rst
rename to Documentation/drivers/driver-api/pps.rst
diff --git a/Documentation/driver-api/ptp.rst b/Documentation/drivers/driver-api/ptp.rst
similarity index 100%
rename from Documentation/driver-api/ptp.rst
rename to Documentation/drivers/driver-api/ptp.rst
diff --git a/Documentation/driver-api/rapidio.rst b/Documentation/drivers/driver-api/rapidio.rst
similarity index 100%
rename from Documentation/driver-api/rapidio.rst
rename to Documentation/drivers/driver-api/rapidio.rst
diff --git a/Documentation/driver-api/regulator.rst b/Documentation/drivers/driver-api/regulator.rst
similarity index 100%
rename from Documentation/driver-api/regulator.rst
rename to Documentation/drivers/driver-api/regulator.rst
diff --git a/Documentation/driver-api/s390-drivers.rst b/Documentation/drivers/driver-api/s390-drivers.rst
similarity index 100%
rename from Documentation/driver-api/s390-drivers.rst
rename to Documentation/drivers/driver-api/s390-drivers.rst
diff --git a/Documentation/driver-api/scsi.rst b/Documentation/drivers/driver-api/scsi.rst
similarity index 100%
rename from Documentation/driver-api/scsi.rst
rename to Documentation/drivers/driver-api/scsi.rst
diff --git a/Documentation/driver-api/slimbus.rst b/Documentation/drivers/driver-api/slimbus.rst
similarity index 100%
rename from Documentation/driver-api/slimbus.rst
rename to Documentation/drivers/driver-api/slimbus.rst
diff --git a/Documentation/driver-api/sound.rst b/Documentation/drivers/driver-api/sound.rst
similarity index 100%
rename from Documentation/driver-api/sound.rst
rename to Documentation/drivers/driver-api/sound.rst
diff --git a/Documentation/driver-api/soundwire/error_handling.rst b/Documentation/drivers/driver-api/soundwire/error_handling.rst
similarity index 100%
rename from Documentation/driver-api/soundwire/error_handling.rst
rename to Documentation/drivers/driver-api/soundwire/error_handling.rst
diff --git a/Documentation/driver-api/soundwire/index.rst b/Documentation/drivers/driver-api/soundwire/index.rst
similarity index 100%
rename from Documentation/driver-api/soundwire/index.rst
rename to Documentation/drivers/driver-api/soundwire/index.rst
diff --git a/Documentation/driver-api/soundwire/locking.rst b/Documentation/drivers/driver-api/soundwire/locking.rst
similarity index 100%
rename from Documentation/driver-api/soundwire/locking.rst
rename to Documentation/drivers/driver-api/soundwire/locking.rst
diff --git a/Documentation/driver-api/soundwire/stream.rst b/Documentation/drivers/driver-api/soundwire/stream.rst
similarity index 100%
rename from Documentation/driver-api/soundwire/stream.rst
rename to Documentation/drivers/driver-api/soundwire/stream.rst
diff --git a/Documentation/driver-api/soundwire/summary.rst b/Documentation/drivers/driver-api/soundwire/summary.rst
similarity index 100%
rename from Documentation/driver-api/soundwire/summary.rst
rename to Documentation/drivers/driver-api/soundwire/summary.rst
diff --git a/Documentation/driver-api/spi.rst b/Documentation/drivers/driver-api/spi.rst
similarity index 100%
rename from Documentation/driver-api/spi.rst
rename to Documentation/drivers/driver-api/spi.rst
diff --git a/Documentation/driver-api/target.rst b/Documentation/drivers/driver-api/target.rst
similarity index 100%
rename from Documentation/driver-api/target.rst
rename to Documentation/drivers/driver-api/target.rst
diff --git a/Documentation/driver-api/uio-howto.rst b/Documentation/drivers/driver-api/uio-howto.rst
similarity index 100%
rename from Documentation/driver-api/uio-howto.rst
rename to Documentation/drivers/driver-api/uio-howto.rst
diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/drivers/driver-api/usb/URB.rst
similarity index 100%
rename from Documentation/driver-api/usb/URB.rst
rename to Documentation/drivers/driver-api/usb/URB.rst
diff --git a/Documentation/driver-api/usb/anchors.rst b/Documentation/drivers/driver-api/usb/anchors.rst
similarity index 100%
rename from Documentation/driver-api/usb/anchors.rst
rename to Documentation/drivers/driver-api/usb/anchors.rst
diff --git a/Documentation/driver-api/usb/bulk-streams.rst b/Documentation/drivers/driver-api/usb/bulk-streams.rst
similarity index 100%
rename from Documentation/driver-api/usb/bulk-streams.rst
rename to Documentation/drivers/driver-api/usb/bulk-streams.rst
diff --git a/Documentation/driver-api/usb/callbacks.rst b/Documentation/drivers/driver-api/usb/callbacks.rst
similarity index 100%
rename from Documentation/driver-api/usb/callbacks.rst
rename to Documentation/drivers/driver-api/usb/callbacks.rst
diff --git a/Documentation/driver-api/usb/dma.rst b/Documentation/drivers/driver-api/usb/dma.rst
similarity index 100%
rename from Documentation/driver-api/usb/dma.rst
rename to Documentation/drivers/driver-api/usb/dma.rst
diff --git a/Documentation/driver-api/usb/dwc3.rst b/Documentation/drivers/driver-api/usb/dwc3.rst
similarity index 100%
rename from Documentation/driver-api/usb/dwc3.rst
rename to Documentation/drivers/driver-api/usb/dwc3.rst
diff --git a/Documentation/driver-api/usb/error-codes.rst b/Documentation/drivers/driver-api/usb/error-codes.rst
similarity index 100%
rename from Documentation/driver-api/usb/error-codes.rst
rename to Documentation/drivers/driver-api/usb/error-codes.rst
diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/drivers/driver-api/usb/gadget.rst
similarity index 100%
rename from Documentation/driver-api/usb/gadget.rst
rename to Documentation/drivers/driver-api/usb/gadget.rst
diff --git a/Documentation/driver-api/usb/hotplug.rst b/Documentation/drivers/driver-api/usb/hotplug.rst
similarity index 100%
rename from Documentation/driver-api/usb/hotplug.rst
rename to Documentation/drivers/driver-api/usb/hotplug.rst
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/drivers/driver-api/usb/index.rst
similarity index 100%
rename from Documentation/driver-api/usb/index.rst
rename to Documentation/drivers/driver-api/usb/index.rst
diff --git a/Documentation/driver-api/usb/persist.rst b/Documentation/drivers/driver-api/usb/persist.rst
similarity index 100%
rename from Documentation/driver-api/usb/persist.rst
rename to Documentation/drivers/driver-api/usb/persist.rst
diff --git a/Documentation/driver-api/usb/power-management.rst b/Documentation/drivers/driver-api/usb/power-management.rst
similarity index 100%
rename from Documentation/driver-api/usb/power-management.rst
rename to Documentation/drivers/driver-api/usb/power-management.rst
diff --git a/Documentation/driver-api/usb/typec.rst b/Documentation/drivers/driver-api/usb/typec.rst
similarity index 100%
rename from Documentation/driver-api/usb/typec.rst
rename to Documentation/drivers/driver-api/usb/typec.rst
diff --git a/Documentation/driver-api/usb/typec_bus.rst b/Documentation/drivers/driver-api/usb/typec_bus.rst
similarity index 100%
rename from Documentation/driver-api/usb/typec_bus.rst
rename to Documentation/drivers/driver-api/usb/typec_bus.rst
diff --git a/Documentation/driver-api/usb/usb.rst b/Documentation/drivers/driver-api/usb/usb.rst
similarity index 100%
rename from Documentation/driver-api/usb/usb.rst
rename to Documentation/drivers/driver-api/usb/usb.rst
diff --git a/Documentation/driver-api/usb/usb3-debug-port.rst b/Documentation/drivers/driver-api/usb/usb3-debug-port.rst
similarity index 100%
rename from Documentation/driver-api/usb/usb3-debug-port.rst
rename to Documentation/drivers/driver-api/usb/usb3-debug-port.rst
diff --git a/Documentation/driver-api/usb/writing_musb_glue_layer.rst b/Documentation/drivers/driver-api/usb/writing_musb_glue_layer.rst
similarity index 100%
rename from Documentation/driver-api/usb/writing_musb_glue_layer.rst
rename to Documentation/drivers/driver-api/usb/writing_musb_glue_layer.rst
diff --git a/Documentation/driver-api/usb/writing_usb_driver.rst b/Documentation/drivers/driver-api/usb/writing_usb_driver.rst
similarity index 100%
rename from Documentation/driver-api/usb/writing_usb_driver.rst
rename to Documentation/drivers/driver-api/usb/writing_usb_driver.rst
diff --git a/Documentation/driver-api/vme.rst b/Documentation/drivers/driver-api/vme.rst
similarity index 100%
rename from Documentation/driver-api/vme.rst
rename to Documentation/drivers/driver-api/vme.rst
diff --git a/Documentation/driver-api/w1.rst b/Documentation/drivers/driver-api/w1.rst
similarity index 100%
rename from Documentation/driver-api/w1.rst
rename to Documentation/drivers/driver-api/w1.rst
diff --git a/Documentation/driver-model/binding.txt b/Documentation/drivers/driver-model/binding.txt
similarity index 100%
rename from Documentation/driver-model/binding.txt
rename to Documentation/drivers/driver-model/binding.txt
diff --git a/Documentation/driver-model/bus.txt b/Documentation/drivers/driver-model/bus.txt
similarity index 100%
rename from Documentation/driver-model/bus.txt
rename to Documentation/drivers/driver-model/bus.txt
diff --git a/Documentation/driver-model/class.txt b/Documentation/drivers/driver-model/class.txt
similarity index 100%
rename from Documentation/driver-model/class.txt
rename to Documentation/drivers/driver-model/class.txt
diff --git a/Documentation/driver-model/design-patterns.txt b/Documentation/drivers/driver-model/design-patterns.txt
similarity index 100%
rename from Documentation/driver-model/design-patterns.txt
rename to Documentation/drivers/driver-model/design-patterns.txt
diff --git a/Documentation/driver-model/device.txt b/Documentation/drivers/driver-model/device.txt
similarity index 100%
rename from Documentation/driver-model/device.txt
rename to Documentation/drivers/driver-model/device.txt
diff --git a/Documentation/driver-model/devres.txt b/Documentation/drivers/driver-model/devres.txt
similarity index 100%
rename from Documentation/driver-model/devres.txt
rename to Documentation/drivers/driver-model/devres.txt
diff --git a/Documentation/driver-model/driver.txt b/Documentation/drivers/driver-model/driver.txt
similarity index 100%
rename from Documentation/driver-model/driver.txt
rename to Documentation/drivers/driver-model/driver.txt
diff --git a/Documentation/driver-model/overview.txt b/Documentation/drivers/driver-model/overview.txt
similarity index 100%
rename from Documentation/driver-model/overview.txt
rename to Documentation/drivers/driver-model/overview.txt
diff --git a/Documentation/driver-model/platform.txt b/Documentation/drivers/driver-model/platform.txt
similarity index 100%
rename from Documentation/driver-model/platform.txt
rename to Documentation/drivers/driver-model/platform.txt
diff --git a/Documentation/driver-model/porting.txt b/Documentation/drivers/driver-model/porting.txt
similarity index 100%
rename from Documentation/driver-model/porting.txt
rename to Documentation/drivers/driver-model/porting.txt
diff --git a/Documentation/fpga/dfl.rst b/Documentation/drivers/fpga/dfl.rst
similarity index 100%
rename from Documentation/fpga/dfl.rst
rename to Documentation/drivers/fpga/dfl.rst
diff --git a/Documentation/fpga/index.rst b/Documentation/drivers/fpga/index.rst
similarity index 100%
rename from Documentation/fpga/index.rst
rename to Documentation/drivers/fpga/index.rst
diff --git a/Documentation/gpio/index.rst b/Documentation/drivers/gpio/index.rst
similarity index 100%
rename from Documentation/gpio/index.rst
rename to Documentation/drivers/gpio/index.rst
diff --git a/Documentation/gpio/sysfs.rst b/Documentation/drivers/gpio/sysfs.rst
similarity index 100%
rename from Documentation/gpio/sysfs.rst
rename to Documentation/drivers/gpio/sysfs.rst
diff --git a/Documentation/gpu/afbc.rst b/Documentation/drivers/gpu/afbc.rst
similarity index 100%
rename from Documentation/gpu/afbc.rst
rename to Documentation/drivers/gpu/afbc.rst
diff --git a/Documentation/gpu/amdgpu-dc.rst b/Documentation/drivers/gpu/amdgpu-dc.rst
similarity index 100%
rename from Documentation/gpu/amdgpu-dc.rst
rename to Documentation/drivers/gpu/amdgpu-dc.rst
diff --git a/Documentation/gpu/amdgpu.rst b/Documentation/drivers/gpu/amdgpu.rst
similarity index 100%
rename from Documentation/gpu/amdgpu.rst
rename to Documentation/drivers/gpu/amdgpu.rst
diff --git a/Documentation/gpu/bridge/dw-hdmi.rst b/Documentation/drivers/gpu/bridge/dw-hdmi.rst
similarity index 100%
rename from Documentation/gpu/bridge/dw-hdmi.rst
rename to Documentation/drivers/gpu/bridge/dw-hdmi.rst
diff --git a/Documentation/gpu/conf.py b/Documentation/drivers/gpu/conf.py
similarity index 100%
rename from Documentation/gpu/conf.py
rename to Documentation/drivers/gpu/conf.py
diff --git a/Documentation/gpu/dp-mst/topology-figure-1.dot b/Documentation/drivers/gpu/dp-mst/topology-figure-1.dot
similarity index 100%
rename from Documentation/gpu/dp-mst/topology-figure-1.dot
rename to Documentation/drivers/gpu/dp-mst/topology-figure-1.dot
diff --git a/Documentation/gpu/dp-mst/topology-figure-2.dot b/Documentation/drivers/gpu/dp-mst/topology-figure-2.dot
similarity index 100%
rename from Documentation/gpu/dp-mst/topology-figure-2.dot
rename to Documentation/drivers/gpu/dp-mst/topology-figure-2.dot
diff --git a/Documentation/gpu/dp-mst/topology-figure-3.dot b/Documentation/drivers/gpu/dp-mst/topology-figure-3.dot
similarity index 100%
rename from Documentation/gpu/dp-mst/topology-figure-3.dot
rename to Documentation/drivers/gpu/dp-mst/topology-figure-3.dot
diff --git a/Documentation/gpu/drivers.rst b/Documentation/drivers/gpu/drivers.rst
similarity index 100%
rename from Documentation/gpu/drivers.rst
rename to Documentation/drivers/gpu/drivers.rst
diff --git a/Documentation/gpu/drm-client.rst b/Documentation/drivers/gpu/drm-client.rst
similarity index 100%
rename from Documentation/gpu/drm-client.rst
rename to Documentation/drivers/gpu/drm-client.rst
diff --git a/Documentation/gpu/drm-internals.rst b/Documentation/drivers/gpu/drm-internals.rst
similarity index 100%
rename from Documentation/gpu/drm-internals.rst
rename to Documentation/drivers/gpu/drm-internals.rst
diff --git a/Documentation/gpu/drm-kms-helpers.rst b/Documentation/drivers/gpu/drm-kms-helpers.rst
similarity index 100%
rename from Documentation/gpu/drm-kms-helpers.rst
rename to Documentation/drivers/gpu/drm-kms-helpers.rst
diff --git a/Documentation/gpu/drm-kms.rst b/Documentation/drivers/gpu/drm-kms.rst
similarity index 100%
rename from Documentation/gpu/drm-kms.rst
rename to Documentation/drivers/gpu/drm-kms.rst
diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/drivers/gpu/drm-mm.rst
similarity index 100%
rename from Documentation/gpu/drm-mm.rst
rename to Documentation/drivers/gpu/drm-mm.rst
diff --git a/Documentation/gpu/drm-uapi.rst b/Documentation/drivers/gpu/drm-uapi.rst
similarity index 100%
rename from Documentation/gpu/drm-uapi.rst
rename to Documentation/drivers/gpu/drm-uapi.rst
diff --git a/Documentation/gpu/i915.rst b/Documentation/drivers/gpu/i915.rst
similarity index 100%
rename from Documentation/gpu/i915.rst
rename to Documentation/drivers/gpu/i915.rst
diff --git a/Documentation/gpu/index.rst b/Documentation/drivers/gpu/index.rst
similarity index 100%
rename from Documentation/gpu/index.rst
rename to Documentation/drivers/gpu/index.rst
diff --git a/Documentation/gpu/introduction.rst b/Documentation/drivers/gpu/introduction.rst
similarity index 100%
rename from Documentation/gpu/introduction.rst
rename to Documentation/drivers/gpu/introduction.rst
diff --git a/Documentation/gpu/kms-properties.csv b/Documentation/drivers/gpu/kms-properties.csv
similarity index 100%
rename from Documentation/gpu/kms-properties.csv
rename to Documentation/drivers/gpu/kms-properties.csv
diff --git a/Documentation/gpu/komeda-kms.rst b/Documentation/drivers/gpu/komeda-kms.rst
similarity index 100%
rename from Documentation/gpu/komeda-kms.rst
rename to Documentation/drivers/gpu/komeda-kms.rst
diff --git a/Documentation/gpu/meson.rst b/Documentation/drivers/gpu/meson.rst
similarity index 100%
rename from Documentation/gpu/meson.rst
rename to Documentation/drivers/gpu/meson.rst
diff --git a/Documentation/gpu/msm-crash-dump.rst b/Documentation/drivers/gpu/msm-crash-dump.rst
similarity index 100%
rename from Documentation/gpu/msm-crash-dump.rst
rename to Documentation/drivers/gpu/msm-crash-dump.rst
diff --git a/Documentation/gpu/pl111.rst b/Documentation/drivers/gpu/pl111.rst
similarity index 100%
rename from Documentation/gpu/pl111.rst
rename to Documentation/drivers/gpu/pl111.rst
diff --git a/Documentation/gpu/tegra.rst b/Documentation/drivers/gpu/tegra.rst
similarity index 100%
rename from Documentation/gpu/tegra.rst
rename to Documentation/drivers/gpu/tegra.rst
diff --git a/Documentation/gpu/tinydrm.rst b/Documentation/drivers/gpu/tinydrm.rst
similarity index 100%
rename from Documentation/gpu/tinydrm.rst
rename to Documentation/drivers/gpu/tinydrm.rst
diff --git a/Documentation/gpu/todo.rst b/Documentation/drivers/gpu/todo.rst
similarity index 100%
rename from Documentation/gpu/todo.rst
rename to Documentation/drivers/gpu/todo.rst
diff --git a/Documentation/gpu/tve200.rst b/Documentation/drivers/gpu/tve200.rst
similarity index 100%
rename from Documentation/gpu/tve200.rst
rename to Documentation/drivers/gpu/tve200.rst
diff --git a/Documentation/gpu/v3d.rst b/Documentation/drivers/gpu/v3d.rst
similarity index 100%
rename from Documentation/gpu/v3d.rst
rename to Documentation/drivers/gpu/v3d.rst
diff --git a/Documentation/gpu/vc4.rst b/Documentation/drivers/gpu/vc4.rst
similarity index 100%
rename from Documentation/gpu/vc4.rst
rename to Documentation/drivers/gpu/vc4.rst
diff --git a/Documentation/gpu/vga-switcheroo.rst b/Documentation/drivers/gpu/vga-switcheroo.rst
similarity index 100%
rename from Documentation/gpu/vga-switcheroo.rst
rename to Documentation/drivers/gpu/vga-switcheroo.rst
diff --git a/Documentation/gpu/vgaarbiter.rst b/Documentation/drivers/gpu/vgaarbiter.rst
similarity index 100%
rename from Documentation/gpu/vgaarbiter.rst
rename to Documentation/drivers/gpu/vgaarbiter.rst
diff --git a/Documentation/gpu/vkms.rst b/Documentation/drivers/gpu/vkms.rst
similarity index 100%
rename from Documentation/gpu/vkms.rst
rename to Documentation/drivers/gpu/vkms.rst
diff --git a/Documentation/gpu/xen-front.rst b/Documentation/drivers/gpu/xen-front.rst
similarity index 100%
rename from Documentation/gpu/xen-front.rst
rename to Documentation/drivers/gpu/xen-front.rst
diff --git a/Documentation/hid/hid-alps.txt b/Documentation/drivers/hid/hid-alps.txt
similarity index 100%
rename from Documentation/hid/hid-alps.txt
rename to Documentation/drivers/hid/hid-alps.txt
diff --git a/Documentation/hid/hid-sensor.txt b/Documentation/drivers/hid/hid-sensor.txt
similarity index 100%
rename from Documentation/hid/hid-sensor.txt
rename to Documentation/drivers/hid/hid-sensor.txt
diff --git a/Documentation/hid/hid-transport.txt b/Documentation/drivers/hid/hid-transport.txt
similarity index 100%
rename from Documentation/hid/hid-transport.txt
rename to Documentation/drivers/hid/hid-transport.txt
diff --git a/Documentation/hid/hiddev.txt b/Documentation/drivers/hid/hiddev.txt
similarity index 100%
rename from Documentation/hid/hiddev.txt
rename to Documentation/drivers/hid/hiddev.txt
diff --git a/Documentation/hid/hidraw.txt b/Documentation/drivers/hid/hidraw.txt
similarity index 100%
rename from Documentation/hid/hidraw.txt
rename to Documentation/drivers/hid/hidraw.txt
diff --git a/Documentation/hid/intel-ish-hid.txt b/Documentation/drivers/hid/intel-ish-hid.txt
similarity index 100%
rename from Documentation/hid/intel-ish-hid.txt
rename to Documentation/drivers/hid/intel-ish-hid.txt
diff --git a/Documentation/hid/uhid.txt b/Documentation/drivers/hid/uhid.txt
similarity index 100%
rename from Documentation/hid/uhid.txt
rename to Documentation/drivers/hid/uhid.txt
diff --git a/Documentation/i2c/DMA-considerations b/Documentation/drivers/i2c/DMA-considerations
similarity index 100%
rename from Documentation/i2c/DMA-considerations
rename to Documentation/drivers/i2c/DMA-considerations
diff --git a/Documentation/i2c/busses/i2c-ali1535 b/Documentation/drivers/i2c/busses/i2c-ali1535
similarity index 100%
rename from Documentation/i2c/busses/i2c-ali1535
rename to Documentation/drivers/i2c/busses/i2c-ali1535
diff --git a/Documentation/i2c/busses/i2c-ali1563 b/Documentation/drivers/i2c/busses/i2c-ali1563
similarity index 100%
rename from Documentation/i2c/busses/i2c-ali1563
rename to Documentation/drivers/i2c/busses/i2c-ali1563
diff --git a/Documentation/i2c/busses/i2c-ali15x3 b/Documentation/drivers/i2c/busses/i2c-ali15x3
similarity index 100%
rename from Documentation/i2c/busses/i2c-ali15x3
rename to Documentation/drivers/i2c/busses/i2c-ali15x3
diff --git a/Documentation/i2c/busses/i2c-amd-mp2 b/Documentation/drivers/i2c/busses/i2c-amd-mp2
similarity index 100%
rename from Documentation/i2c/busses/i2c-amd-mp2
rename to Documentation/drivers/i2c/busses/i2c-amd-mp2
diff --git a/Documentation/i2c/busses/i2c-amd756 b/Documentation/drivers/i2c/busses/i2c-amd756
similarity index 100%
rename from Documentation/i2c/busses/i2c-amd756
rename to Documentation/drivers/i2c/busses/i2c-amd756
diff --git a/Documentation/i2c/busses/i2c-amd8111 b/Documentation/drivers/i2c/busses/i2c-amd8111
similarity index 100%
rename from Documentation/i2c/busses/i2c-amd8111
rename to Documentation/drivers/i2c/busses/i2c-amd8111
diff --git a/Documentation/i2c/busses/i2c-diolan-u2c b/Documentation/drivers/i2c/busses/i2c-diolan-u2c
similarity index 100%
rename from Documentation/i2c/busses/i2c-diolan-u2c
rename to Documentation/drivers/i2c/busses/i2c-diolan-u2c
diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/drivers/i2c/busses/i2c-i801
similarity index 100%
rename from Documentation/i2c/busses/i2c-i801
rename to Documentation/drivers/i2c/busses/i2c-i801
diff --git a/Documentation/i2c/busses/i2c-ismt b/Documentation/drivers/i2c/busses/i2c-ismt
similarity index 100%
rename from Documentation/i2c/busses/i2c-ismt
rename to Documentation/drivers/i2c/busses/i2c-ismt
diff --git a/Documentation/i2c/busses/i2c-mlxcpld b/Documentation/drivers/i2c/busses/i2c-mlxcpld
similarity index 100%
rename from Documentation/i2c/busses/i2c-mlxcpld
rename to Documentation/drivers/i2c/busses/i2c-mlxcpld
diff --git a/Documentation/i2c/busses/i2c-nforce2 b/Documentation/drivers/i2c/busses/i2c-nforce2
similarity index 100%
rename from Documentation/i2c/busses/i2c-nforce2
rename to Documentation/drivers/i2c/busses/i2c-nforce2
diff --git a/Documentation/i2c/busses/i2c-nvidia-gpu b/Documentation/drivers/i2c/busses/i2c-nvidia-gpu
similarity index 100%
rename from Documentation/i2c/busses/i2c-nvidia-gpu
rename to Documentation/drivers/i2c/busses/i2c-nvidia-gpu
diff --git a/Documentation/i2c/busses/i2c-ocores b/Documentation/drivers/i2c/busses/i2c-ocores
similarity index 100%
rename from Documentation/i2c/busses/i2c-ocores
rename to Documentation/drivers/i2c/busses/i2c-ocores
diff --git a/Documentation/i2c/busses/i2c-parport b/Documentation/drivers/i2c/busses/i2c-parport
similarity index 100%
rename from Documentation/i2c/busses/i2c-parport
rename to Documentation/drivers/i2c/busses/i2c-parport
diff --git a/Documentation/i2c/busses/i2c-parport-light b/Documentation/drivers/i2c/busses/i2c-parport-light
similarity index 100%
rename from Documentation/i2c/busses/i2c-parport-light
rename to Documentation/drivers/i2c/busses/i2c-parport-light
diff --git a/Documentation/i2c/busses/i2c-pca-isa b/Documentation/drivers/i2c/busses/i2c-pca-isa
similarity index 100%
rename from Documentation/i2c/busses/i2c-pca-isa
rename to Documentation/drivers/i2c/busses/i2c-pca-isa
diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/drivers/i2c/busses/i2c-piix4
similarity index 100%
rename from Documentation/i2c/busses/i2c-piix4
rename to Documentation/drivers/i2c/busses/i2c-piix4
diff --git a/Documentation/i2c/busses/i2c-sis5595 b/Documentation/drivers/i2c/busses/i2c-sis5595
similarity index 100%
rename from Documentation/i2c/busses/i2c-sis5595
rename to Documentation/drivers/i2c/busses/i2c-sis5595
diff --git a/Documentation/i2c/busses/i2c-sis630 b/Documentation/drivers/i2c/busses/i2c-sis630
similarity index 100%
rename from Documentation/i2c/busses/i2c-sis630
rename to Documentation/drivers/i2c/busses/i2c-sis630
diff --git a/Documentation/i2c/busses/i2c-sis96x b/Documentation/drivers/i2c/busses/i2c-sis96x
similarity index 100%
rename from Documentation/i2c/busses/i2c-sis96x
rename to Documentation/drivers/i2c/busses/i2c-sis96x
diff --git a/Documentation/i2c/busses/i2c-taos-evm b/Documentation/drivers/i2c/busses/i2c-taos-evm
similarity index 100%
rename from Documentation/i2c/busses/i2c-taos-evm
rename to Documentation/drivers/i2c/busses/i2c-taos-evm
diff --git a/Documentation/i2c/busses/i2c-via b/Documentation/drivers/i2c/busses/i2c-via
similarity index 100%
rename from Documentation/i2c/busses/i2c-via
rename to Documentation/drivers/i2c/busses/i2c-via
diff --git a/Documentation/i2c/busses/i2c-viapro b/Documentation/drivers/i2c/busses/i2c-viapro
similarity index 100%
rename from Documentation/i2c/busses/i2c-viapro
rename to Documentation/drivers/i2c/busses/i2c-viapro
diff --git a/Documentation/i2c/busses/scx200_acb b/Documentation/drivers/i2c/busses/scx200_acb
similarity index 100%
rename from Documentation/i2c/busses/scx200_acb
rename to Documentation/drivers/i2c/busses/scx200_acb
diff --git a/Documentation/i2c/dev-interface b/Documentation/drivers/i2c/dev-interface
similarity index 100%
rename from Documentation/i2c/dev-interface
rename to Documentation/drivers/i2c/dev-interface
diff --git a/Documentation/i2c/fault-codes b/Documentation/drivers/i2c/fault-codes
similarity index 100%
rename from Documentation/i2c/fault-codes
rename to Documentation/drivers/i2c/fault-codes
diff --git a/Documentation/i2c/functionality b/Documentation/drivers/i2c/functionality
similarity index 100%
rename from Documentation/i2c/functionality
rename to Documentation/drivers/i2c/functionality
diff --git a/Documentation/i2c/gpio-fault-injection b/Documentation/drivers/i2c/gpio-fault-injection
similarity index 100%
rename from Documentation/i2c/gpio-fault-injection
rename to Documentation/drivers/i2c/gpio-fault-injection
diff --git a/Documentation/i2c/i2c-protocol b/Documentation/drivers/i2c/i2c-protocol
similarity index 100%
rename from Documentation/i2c/i2c-protocol
rename to Documentation/drivers/i2c/i2c-protocol
diff --git a/Documentation/i2c/i2c-stub b/Documentation/drivers/i2c/i2c-stub
similarity index 100%
rename from Documentation/i2c/i2c-stub
rename to Documentation/drivers/i2c/i2c-stub
diff --git a/Documentation/i2c/i2c-topology b/Documentation/drivers/i2c/i2c-topology
similarity index 100%
rename from Documentation/i2c/i2c-topology
rename to Documentation/drivers/i2c/i2c-topology
diff --git a/Documentation/i2c/instantiating-devices b/Documentation/drivers/i2c/instantiating-devices
similarity index 100%
rename from Documentation/i2c/instantiating-devices
rename to Documentation/drivers/i2c/instantiating-devices
diff --git a/Documentation/i2c/muxes/i2c-mux-gpio b/Documentation/drivers/i2c/muxes/i2c-mux-gpio
similarity index 100%
rename from Documentation/i2c/muxes/i2c-mux-gpio
rename to Documentation/drivers/i2c/muxes/i2c-mux-gpio
diff --git a/Documentation/i2c/old-module-parameters b/Documentation/drivers/i2c/old-module-parameters
similarity index 100%
rename from Documentation/i2c/old-module-parameters
rename to Documentation/drivers/i2c/old-module-parameters
diff --git a/Documentation/i2c/slave-eeprom-backend b/Documentation/drivers/i2c/slave-eeprom-backend
similarity index 100%
rename from Documentation/i2c/slave-eeprom-backend
rename to Documentation/drivers/i2c/slave-eeprom-backend
diff --git a/Documentation/i2c/slave-interface b/Documentation/drivers/i2c/slave-interface
similarity index 100%
rename from Documentation/i2c/slave-interface
rename to Documentation/drivers/i2c/slave-interface
diff --git a/Documentation/i2c/smbus-protocol b/Documentation/drivers/i2c/smbus-protocol
similarity index 100%
rename from Documentation/i2c/smbus-protocol
rename to Documentation/drivers/i2c/smbus-protocol
diff --git a/Documentation/i2c/summary b/Documentation/drivers/i2c/summary
similarity index 100%
rename from Documentation/i2c/summary
rename to Documentation/drivers/i2c/summary
diff --git a/Documentation/i2c/ten-bit-addresses b/Documentation/drivers/i2c/ten-bit-addresses
similarity index 100%
rename from Documentation/i2c/ten-bit-addresses
rename to Documentation/drivers/i2c/ten-bit-addresses
diff --git a/Documentation/i2c/upgrading-clients b/Documentation/drivers/i2c/upgrading-clients
similarity index 100%
rename from Documentation/i2c/upgrading-clients
rename to Documentation/drivers/i2c/upgrading-clients
diff --git a/Documentation/i2c/writing-clients b/Documentation/drivers/i2c/writing-clients
similarity index 100%
rename from Documentation/i2c/writing-clients
rename to Documentation/drivers/i2c/writing-clients
diff --git a/Documentation/ide/ChangeLog.ide-cd.1994-2004 b/Documentation/drivers/ide/ChangeLog.ide-cd.1994-2004
similarity index 100%
rename from Documentation/ide/ChangeLog.ide-cd.1994-2004
rename to Documentation/drivers/ide/ChangeLog.ide-cd.1994-2004
diff --git a/Documentation/ide/ChangeLog.ide-floppy.1996-2002 b/Documentation/drivers/ide/ChangeLog.ide-floppy.1996-2002
similarity index 100%
rename from Documentation/ide/ChangeLog.ide-floppy.1996-2002
rename to Documentation/drivers/ide/ChangeLog.ide-floppy.1996-2002
diff --git a/Documentation/ide/ChangeLog.ide-tape.1995-2002 b/Documentation/drivers/ide/ChangeLog.ide-tape.1995-2002
similarity index 100%
rename from Documentation/ide/ChangeLog.ide-tape.1995-2002
rename to Documentation/drivers/ide/ChangeLog.ide-tape.1995-2002
diff --git a/Documentation/ide/changelogs.rst b/Documentation/drivers/ide/changelogs.rst
similarity index 100%
rename from Documentation/ide/changelogs.rst
rename to Documentation/drivers/ide/changelogs.rst
diff --git a/Documentation/ide/ide-tape.rst b/Documentation/drivers/ide/ide-tape.rst
similarity index 100%
rename from Documentation/ide/ide-tape.rst
rename to Documentation/drivers/ide/ide-tape.rst
diff --git a/Documentation/ide/ide.rst b/Documentation/drivers/ide/ide.rst
similarity index 100%
rename from Documentation/ide/ide.rst
rename to Documentation/drivers/ide/ide.rst
diff --git a/Documentation/ide/index.rst b/Documentation/drivers/ide/index.rst
similarity index 100%
rename from Documentation/ide/index.rst
rename to Documentation/drivers/ide/index.rst
diff --git a/Documentation/ide/warm-plug-howto.rst b/Documentation/drivers/ide/warm-plug-howto.rst
similarity index 100%
rename from Documentation/ide/warm-plug-howto.rst
rename to Documentation/drivers/ide/warm-plug-howto.rst
diff --git a/Documentation/infiniband/core_locking.txt b/Documentation/drivers/infiniband/core_locking.txt
similarity index 100%
rename from Documentation/infiniband/core_locking.txt
rename to Documentation/drivers/infiniband/core_locking.txt
diff --git a/Documentation/infiniband/ipoib.txt b/Documentation/drivers/infiniband/ipoib.txt
similarity index 100%
rename from Documentation/infiniband/ipoib.txt
rename to Documentation/drivers/infiniband/ipoib.txt
diff --git a/Documentation/infiniband/opa_vnic.txt b/Documentation/drivers/infiniband/opa_vnic.txt
similarity index 100%
rename from Documentation/infiniband/opa_vnic.txt
rename to Documentation/drivers/infiniband/opa_vnic.txt
diff --git a/Documentation/infiniband/sysfs.txt b/Documentation/drivers/infiniband/sysfs.txt
similarity index 100%
rename from Documentation/infiniband/sysfs.txt
rename to Documentation/drivers/infiniband/sysfs.txt
diff --git a/Documentation/infiniband/tag_matching.txt b/Documentation/drivers/infiniband/tag_matching.txt
similarity index 100%
rename from Documentation/infiniband/tag_matching.txt
rename to Documentation/drivers/infiniband/tag_matching.txt
diff --git a/Documentation/infiniband/user_mad.txt b/Documentation/drivers/infiniband/user_mad.txt
similarity index 100%
rename from Documentation/infiniband/user_mad.txt
rename to Documentation/drivers/infiniband/user_mad.txt
diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/drivers/infiniband/user_verbs.txt
similarity index 100%
rename from Documentation/infiniband/user_verbs.txt
rename to Documentation/drivers/infiniband/user_verbs.txt
diff --git a/Documentation/leds/index.rst b/Documentation/drivers/leds/index.rst
similarity index 100%
rename from Documentation/leds/index.rst
rename to Documentation/drivers/leds/index.rst
diff --git a/Documentation/leds/leds-blinkm.rst b/Documentation/drivers/leds/leds-blinkm.rst
similarity index 100%
rename from Documentation/leds/leds-blinkm.rst
rename to Documentation/drivers/leds/leds-blinkm.rst
diff --git a/Documentation/leds/leds-class-flash.rst b/Documentation/drivers/leds/leds-class-flash.rst
similarity index 100%
rename from Documentation/leds/leds-class-flash.rst
rename to Documentation/drivers/leds/leds-class-flash.rst
diff --git a/Documentation/leds/leds-class.rst b/Documentation/drivers/leds/leds-class.rst
similarity index 100%
rename from Documentation/leds/leds-class.rst
rename to Documentation/drivers/leds/leds-class.rst
diff --git a/Documentation/leds/leds-lm3556.rst b/Documentation/drivers/leds/leds-lm3556.rst
similarity index 100%
rename from Documentation/leds/leds-lm3556.rst
rename to Documentation/drivers/leds/leds-lm3556.rst
diff --git a/Documentation/leds/leds-lp3944.rst b/Documentation/drivers/leds/leds-lp3944.rst
similarity index 100%
rename from Documentation/leds/leds-lp3944.rst
rename to Documentation/drivers/leds/leds-lp3944.rst
diff --git a/Documentation/leds/leds-lp5521.rst b/Documentation/drivers/leds/leds-lp5521.rst
similarity index 100%
rename from Documentation/leds/leds-lp5521.rst
rename to Documentation/drivers/leds/leds-lp5521.rst
diff --git a/Documentation/leds/leds-lp5523.rst b/Documentation/drivers/leds/leds-lp5523.rst
similarity index 100%
rename from Documentation/leds/leds-lp5523.rst
rename to Documentation/drivers/leds/leds-lp5523.rst
diff --git a/Documentation/leds/leds-lp5562.rst b/Documentation/drivers/leds/leds-lp5562.rst
similarity index 100%
rename from Documentation/leds/leds-lp5562.rst
rename to Documentation/drivers/leds/leds-lp5562.rst
diff --git a/Documentation/leds/leds-lp55xx.rst b/Documentation/drivers/leds/leds-lp55xx.rst
similarity index 100%
rename from Documentation/leds/leds-lp55xx.rst
rename to Documentation/drivers/leds/leds-lp55xx.rst
diff --git a/Documentation/leds/leds-mlxcpld.rst b/Documentation/drivers/leds/leds-mlxcpld.rst
similarity index 100%
rename from Documentation/leds/leds-mlxcpld.rst
rename to Documentation/drivers/leds/leds-mlxcpld.rst
diff --git a/Documentation/leds/ledtrig-oneshot.rst b/Documentation/drivers/leds/ledtrig-oneshot.rst
similarity index 100%
rename from Documentation/leds/ledtrig-oneshot.rst
rename to Documentation/drivers/leds/ledtrig-oneshot.rst
diff --git a/Documentation/leds/ledtrig-transient.rst b/Documentation/drivers/leds/ledtrig-transient.rst
similarity index 100%
rename from Documentation/leds/ledtrig-transient.rst
rename to Documentation/drivers/leds/ledtrig-transient.rst
diff --git a/Documentation/leds/ledtrig-usbport.rst b/Documentation/drivers/leds/ledtrig-usbport.rst
similarity index 100%
rename from Documentation/leds/ledtrig-usbport.rst
rename to Documentation/drivers/leds/ledtrig-usbport.rst
diff --git a/Documentation/leds/uleds.rst b/Documentation/drivers/leds/uleds.rst
similarity index 100%
rename from Documentation/leds/uleds.rst
rename to Documentation/drivers/leds/uleds.rst
diff --git a/Documentation/lightnvm/pblk.txt b/Documentation/drivers/lightnvm/pblk.txt
similarity index 100%
rename from Documentation/lightnvm/pblk.txt
rename to Documentation/drivers/lightnvm/pblk.txt
diff --git a/Documentation/md/md-cluster.txt b/Documentation/drivers/md/md-cluster.txt
similarity index 100%
rename from Documentation/md/md-cluster.txt
rename to Documentation/drivers/md/md-cluster.txt
diff --git a/Documentation/md/raid5-cache.txt b/Documentation/drivers/md/raid5-cache.txt
similarity index 100%
rename from Documentation/md/raid5-cache.txt
rename to Documentation/drivers/md/raid5-cache.txt
diff --git a/Documentation/md/raid5-ppl.txt b/Documentation/drivers/md/raid5-ppl.txt
similarity index 100%
rename from Documentation/md/raid5-ppl.txt
rename to Documentation/drivers/md/raid5-ppl.txt
diff --git a/Documentation/media/.gitignore b/Documentation/drivers/media/.gitignore
similarity index 100%
rename from Documentation/media/.gitignore
rename to Documentation/drivers/media/.gitignore
diff --git a/Documentation/media/Makefile b/Documentation/drivers/media/Makefile
similarity index 100%
rename from Documentation/media/Makefile
rename to Documentation/drivers/media/Makefile
diff --git a/Documentation/media/audio.h.rst.exceptions b/Documentation/drivers/media/audio.h.rst.exceptions
similarity index 100%
rename from Documentation/media/audio.h.rst.exceptions
rename to Documentation/drivers/media/audio.h.rst.exceptions
diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/drivers/media/ca.h.rst.exceptions
similarity index 100%
rename from Documentation/media/ca.h.rst.exceptions
rename to Documentation/drivers/media/ca.h.rst.exceptions
diff --git a/Documentation/media/cec-drivers/index.rst b/Documentation/drivers/media/cec-drivers/index.rst
similarity index 100%
rename from Documentation/media/cec-drivers/index.rst
rename to Documentation/drivers/media/cec-drivers/index.rst
diff --git a/Documentation/media/cec-drivers/pulse8-cec.rst b/Documentation/drivers/media/cec-drivers/pulse8-cec.rst
similarity index 100%
rename from Documentation/media/cec-drivers/pulse8-cec.rst
rename to Documentation/drivers/media/cec-drivers/pulse8-cec.rst
diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/drivers/media/cec.h.rst.exceptions
similarity index 100%
rename from Documentation/media/cec.h.rst.exceptions
rename to Documentation/drivers/media/cec.h.rst.exceptions
diff --git a/Documentation/media/conf.py b/Documentation/drivers/media/conf.py
similarity index 100%
rename from Documentation/media/conf.py
rename to Documentation/drivers/media/conf.py
diff --git a/Documentation/media/conf_nitpick.py b/Documentation/drivers/media/conf_nitpick.py
similarity index 100%
rename from Documentation/media/conf_nitpick.py
rename to Documentation/drivers/media/conf_nitpick.py
diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/drivers/media/dmx.h.rst.exceptions
similarity index 100%
rename from Documentation/media/dmx.h.rst.exceptions
rename to Documentation/drivers/media/dmx.h.rst.exceptions
diff --git a/Documentation/media/dvb-drivers/avermedia.rst b/Documentation/drivers/media/dvb-drivers/avermedia.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/avermedia.rst
rename to Documentation/drivers/media/dvb-drivers/avermedia.rst
diff --git a/Documentation/media/dvb-drivers/bt8xx.rst b/Documentation/drivers/media/dvb-drivers/bt8xx.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/bt8xx.rst
rename to Documentation/drivers/media/dvb-drivers/bt8xx.rst
diff --git a/Documentation/media/dvb-drivers/cards.rst b/Documentation/drivers/media/dvb-drivers/cards.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/cards.rst
rename to Documentation/drivers/media/dvb-drivers/cards.rst
diff --git a/Documentation/media/dvb-drivers/ci.rst b/Documentation/drivers/media/dvb-drivers/ci.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/ci.rst
rename to Documentation/drivers/media/dvb-drivers/ci.rst
diff --git a/Documentation/media/dvb-drivers/contributors.rst b/Documentation/drivers/media/dvb-drivers/contributors.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/contributors.rst
rename to Documentation/drivers/media/dvb-drivers/contributors.rst
diff --git a/Documentation/media/dvb-drivers/dvb-usb.rst b/Documentation/drivers/media/dvb-drivers/dvb-usb.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/dvb-usb.rst
rename to Documentation/drivers/media/dvb-drivers/dvb-usb.rst
diff --git a/Documentation/media/dvb-drivers/faq.rst b/Documentation/drivers/media/dvb-drivers/faq.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/faq.rst
rename to Documentation/drivers/media/dvb-drivers/faq.rst
diff --git a/Documentation/media/dvb-drivers/frontends.rst b/Documentation/drivers/media/dvb-drivers/frontends.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/frontends.rst
rename to Documentation/drivers/media/dvb-drivers/frontends.rst
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/drivers/media/dvb-drivers/index.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/index.rst
rename to Documentation/drivers/media/dvb-drivers/index.rst
diff --git a/Documentation/media/dvb-drivers/intro.rst b/Documentation/drivers/media/dvb-drivers/intro.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/intro.rst
rename to Documentation/drivers/media/dvb-drivers/intro.rst
diff --git a/Documentation/media/dvb-drivers/lmedm04.rst b/Documentation/drivers/media/dvb-drivers/lmedm04.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/lmedm04.rst
rename to Documentation/drivers/media/dvb-drivers/lmedm04.rst
diff --git a/Documentation/media/dvb-drivers/opera-firmware.rst b/Documentation/drivers/media/dvb-drivers/opera-firmware.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/opera-firmware.rst
rename to Documentation/drivers/media/dvb-drivers/opera-firmware.rst
diff --git a/Documentation/media/dvb-drivers/technisat.rst b/Documentation/drivers/media/dvb-drivers/technisat.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/technisat.rst
rename to Documentation/drivers/media/dvb-drivers/technisat.rst
diff --git a/Documentation/media/dvb-drivers/ttusb-dec.rst b/Documentation/drivers/media/dvb-drivers/ttusb-dec.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/ttusb-dec.rst
rename to Documentation/drivers/media/dvb-drivers/ttusb-dec.rst
diff --git a/Documentation/media/dvb-drivers/udev.rst b/Documentation/drivers/media/dvb-drivers/udev.rst
similarity index 100%
rename from Documentation/media/dvb-drivers/udev.rst
rename to Documentation/drivers/media/dvb-drivers/udev.rst
diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/drivers/media/frontend.h.rst.exceptions
similarity index 100%
rename from Documentation/media/frontend.h.rst.exceptions
rename to Documentation/drivers/media/frontend.h.rst.exceptions
diff --git a/Documentation/media/index.rst b/Documentation/drivers/media/index.rst
similarity index 100%
rename from Documentation/media/index.rst
rename to Documentation/drivers/media/index.rst
diff --git a/Documentation/media/intro.rst b/Documentation/drivers/media/intro.rst
similarity index 100%
rename from Documentation/media/intro.rst
rename to Documentation/drivers/media/intro.rst
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/drivers/media/kapi/cec-core.rst
similarity index 100%
rename from Documentation/media/kapi/cec-core.rst
rename to Documentation/drivers/media/kapi/cec-core.rst
diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/drivers/media/kapi/csi2.rst
similarity index 100%
rename from Documentation/media/kapi/csi2.rst
rename to Documentation/drivers/media/kapi/csi2.rst
diff --git a/Documentation/media/kapi/dtv-ca.rst b/Documentation/drivers/media/kapi/dtv-ca.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-ca.rst
rename to Documentation/drivers/media/kapi/dtv-ca.rst
diff --git a/Documentation/media/kapi/dtv-common.rst b/Documentation/drivers/media/kapi/dtv-common.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-common.rst
rename to Documentation/drivers/media/kapi/dtv-common.rst
diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/drivers/media/kapi/dtv-core.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-core.rst
rename to Documentation/drivers/media/kapi/dtv-core.rst
diff --git a/Documentation/media/kapi/dtv-demux.rst b/Documentation/drivers/media/kapi/dtv-demux.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-demux.rst
rename to Documentation/drivers/media/kapi/dtv-demux.rst
diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/drivers/media/kapi/dtv-frontend.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-frontend.rst
rename to Documentation/drivers/media/kapi/dtv-frontend.rst
diff --git a/Documentation/media/kapi/dtv-net.rst b/Documentation/drivers/media/kapi/dtv-net.rst
similarity index 100%
rename from Documentation/media/kapi/dtv-net.rst
rename to Documentation/drivers/media/kapi/dtv-net.rst
diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/drivers/media/kapi/mc-core.rst
similarity index 100%
rename from Documentation/media/kapi/mc-core.rst
rename to Documentation/drivers/media/kapi/mc-core.rst
diff --git a/Documentation/media/kapi/rc-core.rst b/Documentation/drivers/media/kapi/rc-core.rst
similarity index 100%
rename from Documentation/media/kapi/rc-core.rst
rename to Documentation/drivers/media/kapi/rc-core.rst
diff --git a/Documentation/media/kapi/v4l2-async.rst b/Documentation/drivers/media/kapi/v4l2-async.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-async.rst
rename to Documentation/drivers/media/kapi/v4l2-async.rst
diff --git a/Documentation/media/kapi/v4l2-clocks.rst b/Documentation/drivers/media/kapi/v4l2-clocks.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-clocks.rst
rename to Documentation/drivers/media/kapi/v4l2-clocks.rst
diff --git a/Documentation/media/kapi/v4l2-common.rst b/Documentation/drivers/media/kapi/v4l2-common.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-common.rst
rename to Documentation/drivers/media/kapi/v4l2-common.rst
diff --git a/Documentation/media/kapi/v4l2-controls.rst b/Documentation/drivers/media/kapi/v4l2-controls.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-controls.rst
rename to Documentation/drivers/media/kapi/v4l2-controls.rst
diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/drivers/media/kapi/v4l2-core.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-core.rst
rename to Documentation/drivers/media/kapi/v4l2-core.rst
diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/drivers/media/kapi/v4l2-dev.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-dev.rst
rename to Documentation/drivers/media/kapi/v4l2-dev.rst
diff --git a/Documentation/media/kapi/v4l2-device.rst b/Documentation/drivers/media/kapi/v4l2-device.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-device.rst
rename to Documentation/drivers/media/kapi/v4l2-device.rst
diff --git a/Documentation/media/kapi/v4l2-dv-timings.rst b/Documentation/drivers/media/kapi/v4l2-dv-timings.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-dv-timings.rst
rename to Documentation/drivers/media/kapi/v4l2-dv-timings.rst
diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/drivers/media/kapi/v4l2-event.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-event.rst
rename to Documentation/drivers/media/kapi/v4l2-event.rst
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/drivers/media/kapi/v4l2-fh.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-fh.rst
rename to Documentation/drivers/media/kapi/v4l2-fh.rst
diff --git a/Documentation/media/kapi/v4l2-flash-led-class.rst b/Documentation/drivers/media/kapi/v4l2-flash-led-class.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-flash-led-class.rst
rename to Documentation/drivers/media/kapi/v4l2-flash-led-class.rst
diff --git a/Documentation/media/kapi/v4l2-fwnode.rst b/Documentation/drivers/media/kapi/v4l2-fwnode.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-fwnode.rst
rename to Documentation/drivers/media/kapi/v4l2-fwnode.rst
diff --git a/Documentation/media/kapi/v4l2-intro.rst b/Documentation/drivers/media/kapi/v4l2-intro.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-intro.rst
rename to Documentation/drivers/media/kapi/v4l2-intro.rst
diff --git a/Documentation/media/kapi/v4l2-mc.rst b/Documentation/drivers/media/kapi/v4l2-mc.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-mc.rst
rename to Documentation/drivers/media/kapi/v4l2-mc.rst
diff --git a/Documentation/media/kapi/v4l2-mediabus.rst b/Documentation/drivers/media/kapi/v4l2-mediabus.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-mediabus.rst
rename to Documentation/drivers/media/kapi/v4l2-mediabus.rst
diff --git a/Documentation/media/kapi/v4l2-mem2mem.rst b/Documentation/drivers/media/kapi/v4l2-mem2mem.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-mem2mem.rst
rename to Documentation/drivers/media/kapi/v4l2-mem2mem.rst
diff --git a/Documentation/media/kapi/v4l2-rect.rst b/Documentation/drivers/media/kapi/v4l2-rect.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-rect.rst
rename to Documentation/drivers/media/kapi/v4l2-rect.rst
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/drivers/media/kapi/v4l2-subdev.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-subdev.rst
rename to Documentation/drivers/media/kapi/v4l2-subdev.rst
diff --git a/Documentation/media/kapi/v4l2-tuner.rst b/Documentation/drivers/media/kapi/v4l2-tuner.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-tuner.rst
rename to Documentation/drivers/media/kapi/v4l2-tuner.rst
diff --git a/Documentation/media/kapi/v4l2-tveeprom.rst b/Documentation/drivers/media/kapi/v4l2-tveeprom.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-tveeprom.rst
rename to Documentation/drivers/media/kapi/v4l2-tveeprom.rst
diff --git a/Documentation/media/kapi/v4l2-videobuf.rst b/Documentation/drivers/media/kapi/v4l2-videobuf.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-videobuf.rst
rename to Documentation/drivers/media/kapi/v4l2-videobuf.rst
diff --git a/Documentation/media/kapi/v4l2-videobuf2.rst b/Documentation/drivers/media/kapi/v4l2-videobuf2.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-videobuf2.rst
rename to Documentation/drivers/media/kapi/v4l2-videobuf2.rst
diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/drivers/media/lirc.h.rst.exceptions
similarity index 100%
rename from Documentation/media/lirc.h.rst.exceptions
rename to Documentation/drivers/media/lirc.h.rst.exceptions
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/drivers/media/media.h.rst.exceptions
similarity index 100%
rename from Documentation/media/media.h.rst.exceptions
rename to Documentation/drivers/media/media.h.rst.exceptions
diff --git a/Documentation/media/media_kapi.rst b/Documentation/drivers/media/media_kapi.rst
similarity index 100%
rename from Documentation/media/media_kapi.rst
rename to Documentation/drivers/media/media_kapi.rst
diff --git a/Documentation/media/media_uapi.rst b/Documentation/drivers/media/media_uapi.rst
similarity index 100%
rename from Documentation/media/media_uapi.rst
rename to Documentation/drivers/media/media_uapi.rst
diff --git a/Documentation/media/net.h.rst.exceptions b/Documentation/drivers/media/net.h.rst.exceptions
similarity index 100%
rename from Documentation/media/net.h.rst.exceptions
rename to Documentation/drivers/media/net.h.rst.exceptions
diff --git a/Documentation/media/typical_media_device.svg b/Documentation/drivers/media/typical_media_device.svg
similarity index 100%
rename from Documentation/media/typical_media_device.svg
rename to Documentation/drivers/media/typical_media_device.svg
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/drivers/media/uapi/cec/cec-api.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-api.rst
rename to Documentation/drivers/media/uapi/cec/cec-api.rst
diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/drivers/media/uapi/cec/cec-func-close.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-func-close.rst
rename to Documentation/drivers/media/uapi/cec/cec-func-close.rst
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/drivers/media/uapi/cec/cec-func-ioctl.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-func-ioctl.rst
rename to Documentation/drivers/media/uapi/cec/cec-func-ioctl.rst
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/drivers/media/uapi/cec/cec-func-open.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-func-open.rst
rename to Documentation/drivers/media/uapi/cec/cec-func-open.rst
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/drivers/media/uapi/cec/cec-func-poll.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-func-poll.rst
rename to Documentation/drivers/media/uapi/cec/cec-func-poll.rst
diff --git a/Documentation/media/uapi/cec/cec-funcs.rst b/Documentation/drivers/media/uapi/cec/cec-funcs.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-funcs.rst
rename to Documentation/drivers/media/uapi/cec/cec-funcs.rst
diff --git a/Documentation/media/uapi/cec/cec-header.rst b/Documentation/drivers/media/uapi/cec/cec-header.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-header.rst
rename to Documentation/drivers/media/uapi/cec/cec-header.rst
diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/drivers/media/uapi/cec/cec-intro.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-intro.rst
rename to Documentation/drivers/media/uapi/cec/cec-intro.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-caps.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-caps.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-dqevent.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-dqevent.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-dqevent.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-g-mode.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-g-mode.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-g-mode.rst
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/drivers/media/uapi/cec/cec-ioc-receive.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-ioc-receive.rst
rename to Documentation/drivers/media/uapi/cec/cec-ioc-receive.rst
diff --git a/Documentation/media/uapi/cec/cec-pin-error-inj.rst b/Documentation/drivers/media/uapi/cec/cec-pin-error-inj.rst
similarity index 100%
rename from Documentation/media/uapi/cec/cec-pin-error-inj.rst
rename to Documentation/drivers/media/uapi/cec/cec-pin-error-inj.rst
diff --git a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst b/Documentation/drivers/media/uapi/dvb/audio-bilingual-channel-select.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
rename to Documentation/drivers/media/uapi/dvb/audio-bilingual-channel-select.rst
diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/drivers/media/uapi/dvb/audio-channel-select.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-channel-select.rst
rename to Documentation/drivers/media/uapi/dvb/audio-channel-select.rst
diff --git a/Documentation/media/uapi/dvb/audio-clear-buffer.rst b/Documentation/drivers/media/uapi/dvb/audio-clear-buffer.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-clear-buffer.rst
rename to Documentation/drivers/media/uapi/dvb/audio-clear-buffer.rst
diff --git a/Documentation/media/uapi/dvb/audio-continue.rst b/Documentation/drivers/media/uapi/dvb/audio-continue.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-continue.rst
rename to Documentation/drivers/media/uapi/dvb/audio-continue.rst
diff --git a/Documentation/media/uapi/dvb/audio-fclose.rst b/Documentation/drivers/media/uapi/dvb/audio-fclose.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-fclose.rst
rename to Documentation/drivers/media/uapi/dvb/audio-fclose.rst
diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/drivers/media/uapi/dvb/audio-fopen.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-fopen.rst
rename to Documentation/drivers/media/uapi/dvb/audio-fopen.rst
diff --git a/Documentation/media/uapi/dvb/audio-fwrite.rst b/Documentation/drivers/media/uapi/dvb/audio-fwrite.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-fwrite.rst
rename to Documentation/drivers/media/uapi/dvb/audio-fwrite.rst
diff --git a/Documentation/media/uapi/dvb/audio-get-capabilities.rst b/Documentation/drivers/media/uapi/dvb/audio-get-capabilities.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-get-capabilities.rst
rename to Documentation/drivers/media/uapi/dvb/audio-get-capabilities.rst
diff --git a/Documentation/media/uapi/dvb/audio-get-status.rst b/Documentation/drivers/media/uapi/dvb/audio-get-status.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-get-status.rst
rename to Documentation/drivers/media/uapi/dvb/audio-get-status.rst
diff --git a/Documentation/media/uapi/dvb/audio-pause.rst b/Documentation/drivers/media/uapi/dvb/audio-pause.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-pause.rst
rename to Documentation/drivers/media/uapi/dvb/audio-pause.rst
diff --git a/Documentation/media/uapi/dvb/audio-play.rst b/Documentation/drivers/media/uapi/dvb/audio-play.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-play.rst
rename to Documentation/drivers/media/uapi/dvb/audio-play.rst
diff --git a/Documentation/media/uapi/dvb/audio-select-source.rst b/Documentation/drivers/media/uapi/dvb/audio-select-source.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-select-source.rst
rename to Documentation/drivers/media/uapi/dvb/audio-select-source.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-av-sync.rst b/Documentation/drivers/media/uapi/dvb/audio-set-av-sync.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-av-sync.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-av-sync.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/drivers/media/uapi/dvb/audio-set-bypass-mode.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-bypass-mode.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-id.rst b/Documentation/drivers/media/uapi/dvb/audio-set-id.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-id.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-id.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-mixer.rst b/Documentation/drivers/media/uapi/dvb/audio-set-mixer.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-mixer.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-mixer.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-mute.rst b/Documentation/drivers/media/uapi/dvb/audio-set-mute.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-mute.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-mute.rst
diff --git a/Documentation/media/uapi/dvb/audio-set-streamtype.rst b/Documentation/drivers/media/uapi/dvb/audio-set-streamtype.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-set-streamtype.rst
rename to Documentation/drivers/media/uapi/dvb/audio-set-streamtype.rst
diff --git a/Documentation/media/uapi/dvb/audio-stop.rst b/Documentation/drivers/media/uapi/dvb/audio-stop.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio-stop.rst
rename to Documentation/drivers/media/uapi/dvb/audio-stop.rst
diff --git a/Documentation/media/uapi/dvb/audio.rst b/Documentation/drivers/media/uapi/dvb/audio.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio.rst
rename to Documentation/drivers/media/uapi/dvb/audio.rst
diff --git a/Documentation/media/uapi/dvb/audio_data_types.rst b/Documentation/drivers/media/uapi/dvb/audio_data_types.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio_data_types.rst
rename to Documentation/drivers/media/uapi/dvb/audio_data_types.rst
diff --git a/Documentation/media/uapi/dvb/audio_function_calls.rst b/Documentation/drivers/media/uapi/dvb/audio_function_calls.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/audio_function_calls.rst
rename to Documentation/drivers/media/uapi/dvb/audio_function_calls.rst
diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/drivers/media/uapi/dvb/ca-fclose.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-fclose.rst
rename to Documentation/drivers/media/uapi/dvb/ca-fclose.rst
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/drivers/media/uapi/dvb/ca-fopen.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-fopen.rst
rename to Documentation/drivers/media/uapi/dvb/ca-fopen.rst
diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/drivers/media/uapi/dvb/ca-get-cap.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-get-cap.rst
rename to Documentation/drivers/media/uapi/dvb/ca-get-cap.rst
diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/drivers/media/uapi/dvb/ca-get-descr-info.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-get-descr-info.rst
rename to Documentation/drivers/media/uapi/dvb/ca-get-descr-info.rst
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/drivers/media/uapi/dvb/ca-get-msg.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-get-msg.rst
rename to Documentation/drivers/media/uapi/dvb/ca-get-msg.rst
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/drivers/media/uapi/dvb/ca-get-slot-info.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-get-slot-info.rst
rename to Documentation/drivers/media/uapi/dvb/ca-get-slot-info.rst
diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/drivers/media/uapi/dvb/ca-reset.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-reset.rst
rename to Documentation/drivers/media/uapi/dvb/ca-reset.rst
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/drivers/media/uapi/dvb/ca-send-msg.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-send-msg.rst
rename to Documentation/drivers/media/uapi/dvb/ca-send-msg.rst
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/drivers/media/uapi/dvb/ca-set-descr.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca-set-descr.rst
rename to Documentation/drivers/media/uapi/dvb/ca-set-descr.rst
diff --git a/Documentation/media/uapi/dvb/ca.rst b/Documentation/drivers/media/uapi/dvb/ca.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca.rst
rename to Documentation/drivers/media/uapi/dvb/ca.rst
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/drivers/media/uapi/dvb/ca_data_types.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca_data_types.rst
rename to Documentation/drivers/media/uapi/dvb/ca_data_types.rst
diff --git a/Documentation/media/uapi/dvb/ca_function_calls.rst b/Documentation/drivers/media/uapi/dvb/ca_function_calls.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/ca_function_calls.rst
rename to Documentation/drivers/media/uapi/dvb/ca_function_calls.rst
diff --git a/Documentation/media/uapi/dvb/demux.rst b/Documentation/drivers/media/uapi/dvb/demux.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/demux.rst
rename to Documentation/drivers/media/uapi/dvb/demux.rst
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/drivers/media/uapi/dvb/dmx-add-pid.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-add-pid.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-add-pid.rst
diff --git a/Documentation/media/uapi/dvb/dmx-expbuf.rst b/Documentation/drivers/media/uapi/dvb/dmx-expbuf.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-expbuf.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-expbuf.rst
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/drivers/media/uapi/dvb/dmx-fclose.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-fclose.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-fclose.rst
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/drivers/media/uapi/dvb/dmx-fopen.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-fopen.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-fopen.rst
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/drivers/media/uapi/dvb/dmx-fread.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-fread.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-fread.rst
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/drivers/media/uapi/dvb/dmx-fwrite.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-fwrite.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-fwrite.rst
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/drivers/media/uapi/dvb/dmx-get-pes-pids.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-get-pes-pids.rst
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/drivers/media/uapi/dvb/dmx-get-stc.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-get-stc.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-get-stc.rst
diff --git a/Documentation/media/uapi/dvb/dmx-mmap.rst b/Documentation/drivers/media/uapi/dvb/dmx-mmap.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-mmap.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-mmap.rst
diff --git a/Documentation/media/uapi/dvb/dmx-munmap.rst b/Documentation/drivers/media/uapi/dvb/dmx-munmap.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-munmap.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-munmap.rst
diff --git a/Documentation/media/uapi/dvb/dmx-qbuf.rst b/Documentation/drivers/media/uapi/dvb/dmx-qbuf.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-qbuf.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-qbuf.rst
diff --git a/Documentation/media/uapi/dvb/dmx-querybuf.rst b/Documentation/drivers/media/uapi/dvb/dmx-querybuf.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-querybuf.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-querybuf.rst
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/drivers/media/uapi/dvb/dmx-remove-pid.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-remove-pid.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-remove-pid.rst
diff --git a/Documentation/media/uapi/dvb/dmx-reqbufs.rst b/Documentation/drivers/media/uapi/dvb/dmx-reqbufs.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-reqbufs.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-reqbufs.rst
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/drivers/media/uapi/dvb/dmx-set-buffer-size.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-set-buffer-size.rst
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/drivers/media/uapi/dvb/dmx-set-filter.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-set-filter.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-set-filter.rst
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/drivers/media/uapi/dvb/dmx-set-pes-filter.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-set-pes-filter.rst
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/drivers/media/uapi/dvb/dmx-start.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-start.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-start.rst
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/drivers/media/uapi/dvb/dmx-stop.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx-stop.rst
rename to Documentation/drivers/media/uapi/dvb/dmx-stop.rst
diff --git a/Documentation/media/uapi/dvb/dmx_fcalls.rst b/Documentation/drivers/media/uapi/dvb/dmx_fcalls.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx_fcalls.rst
rename to Documentation/drivers/media/uapi/dvb/dmx_fcalls.rst
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/drivers/media/uapi/dvb/dmx_types.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dmx_types.rst
rename to Documentation/drivers/media/uapi/dvb/dmx_types.rst
diff --git a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst b/Documentation/drivers/media/uapi/dvb/dvb-fe-read-status.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dvb-fe-read-status.rst
rename to Documentation/drivers/media/uapi/dvb/dvb-fe-read-status.rst
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-event.rst b/Documentation/drivers/media/uapi/dvb/dvb-frontend-event.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dvb-frontend-event.rst
rename to Documentation/drivers/media/uapi/dvb/dvb-frontend-event.rst
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst b/Documentation/drivers/media/uapi/dvb/dvb-frontend-parameters.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
rename to Documentation/drivers/media/uapi/dvb/dvb-frontend-parameters.rst
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/drivers/media/uapi/dvb/dvbapi.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dvbapi.rst
rename to Documentation/drivers/media/uapi/dvb/dvbapi.rst
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/drivers/media/uapi/dvb/dvbproperty.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/dvbproperty.rst
rename to Documentation/drivers/media/uapi/dvb/dvbproperty.rst
diff --git a/Documentation/media/uapi/dvb/dvbstb.svg b/Documentation/drivers/media/uapi/dvb/dvbstb.svg
similarity index 100%
rename from Documentation/media/uapi/dvb/dvbstb.svg
rename to Documentation/drivers/media/uapi/dvb/dvbstb.svg
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/drivers/media/uapi/dvb/examples.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/examples.rst
rename to Documentation/drivers/media/uapi/dvb/examples.rst
diff --git a/Documentation/media/uapi/dvb/fe-bandwidth-t.rst b/Documentation/drivers/media/uapi/dvb/fe-bandwidth-t.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-bandwidth-t.rst
rename to Documentation/drivers/media/uapi/dvb/fe-bandwidth-t.rst
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/drivers/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
rename to Documentation/drivers/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/drivers/media/uapi/dvb/fe-diseqc-reset-overload.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
rename to Documentation/drivers/media/uapi/dvb/fe-diseqc-reset-overload.rst
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/drivers/media/uapi/dvb/fe-diseqc-send-burst.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
rename to Documentation/drivers/media/uapi/dvb/fe-diseqc-send-burst.rst
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/drivers/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
rename to Documentation/drivers/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/drivers/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
rename to Documentation/drivers/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
diff --git a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/drivers/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
rename to Documentation/drivers/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
diff --git a/Documentation/media/uapi/dvb/fe-get-event.rst b/Documentation/drivers/media/uapi/dvb/fe-get-event.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-get-event.rst
rename to Documentation/drivers/media/uapi/dvb/fe-get-event.rst
diff --git a/Documentation/media/uapi/dvb/fe-get-frontend.rst b/Documentation/drivers/media/uapi/dvb/fe-get-frontend.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-get-frontend.rst
rename to Documentation/drivers/media/uapi/dvb/fe-get-frontend.rst
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/drivers/media/uapi/dvb/fe-get-info.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-get-info.rst
rename to Documentation/drivers/media/uapi/dvb/fe-get-info.rst
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/drivers/media/uapi/dvb/fe-get-property.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-get-property.rst
rename to Documentation/drivers/media/uapi/dvb/fe-get-property.rst
diff --git a/Documentation/media/uapi/dvb/fe-read-ber.rst b/Documentation/drivers/media/uapi/dvb/fe-read-ber.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-read-ber.rst
rename to Documentation/drivers/media/uapi/dvb/fe-read-ber.rst
diff --git a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst b/Documentation/drivers/media/uapi/dvb/fe-read-signal-strength.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-read-signal-strength.rst
rename to Documentation/drivers/media/uapi/dvb/fe-read-signal-strength.rst
diff --git a/Documentation/media/uapi/dvb/fe-read-snr.rst b/Documentation/drivers/media/uapi/dvb/fe-read-snr.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-read-snr.rst
rename to Documentation/drivers/media/uapi/dvb/fe-read-snr.rst
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/drivers/media/uapi/dvb/fe-read-status.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-read-status.rst
rename to Documentation/drivers/media/uapi/dvb/fe-read-status.rst
diff --git a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst b/Documentation/drivers/media/uapi/dvb/fe-read-uncorrected-blocks.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
rename to Documentation/drivers/media/uapi/dvb/fe-read-uncorrected-blocks.rst
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/drivers/media/uapi/dvb/fe-set-frontend-tune-mode.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
rename to Documentation/drivers/media/uapi/dvb/fe-set-frontend-tune-mode.rst
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend.rst b/Documentation/drivers/media/uapi/dvb/fe-set-frontend.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-set-frontend.rst
rename to Documentation/drivers/media/uapi/dvb/fe-set-frontend.rst
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/drivers/media/uapi/dvb/fe-set-tone.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-set-tone.rst
rename to Documentation/drivers/media/uapi/dvb/fe-set-tone.rst
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/drivers/media/uapi/dvb/fe-set-voltage.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-set-voltage.rst
rename to Documentation/drivers/media/uapi/dvb/fe-set-voltage.rst
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/drivers/media/uapi/dvb/fe-type-t.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe-type-t.rst
rename to Documentation/drivers/media/uapi/dvb/fe-type-t.rst
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/drivers/media/uapi/dvb/fe_property_parameters.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/fe_property_parameters.rst
rename to Documentation/drivers/media/uapi/dvb/fe_property_parameters.rst
diff --git a/Documentation/media/uapi/dvb/frontend-header.rst b/Documentation/drivers/media/uapi/dvb/frontend-header.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend-header.rst
rename to Documentation/drivers/media/uapi/dvb/frontend-header.rst
diff --git a/Documentation/media/uapi/dvb/frontend-property-cable-systems.rst b/Documentation/drivers/media/uapi/dvb/frontend-property-cable-systems.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend-property-cable-systems.rst
rename to Documentation/drivers/media/uapi/dvb/frontend-property-cable-systems.rst
diff --git a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst b/Documentation/drivers/media/uapi/dvb/frontend-property-satellite-systems.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
rename to Documentation/drivers/media/uapi/dvb/frontend-property-satellite-systems.rst
diff --git a/Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst b/Documentation/drivers/media/uapi/dvb/frontend-property-terrestrial-systems.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend-property-terrestrial-systems.rst
rename to Documentation/drivers/media/uapi/dvb/frontend-property-terrestrial-systems.rst
diff --git a/Documentation/media/uapi/dvb/frontend-stat-properties.rst b/Documentation/drivers/media/uapi/dvb/frontend-stat-properties.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend-stat-properties.rst
rename to Documentation/drivers/media/uapi/dvb/frontend-stat-properties.rst
diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/drivers/media/uapi/dvb/frontend.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend.rst
rename to Documentation/drivers/media/uapi/dvb/frontend.rst
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/drivers/media/uapi/dvb/frontend_f_close.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend_f_close.rst
rename to Documentation/drivers/media/uapi/dvb/frontend_f_close.rst
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/drivers/media/uapi/dvb/frontend_f_open.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend_f_open.rst
rename to Documentation/drivers/media/uapi/dvb/frontend_f_open.rst
diff --git a/Documentation/media/uapi/dvb/frontend_fcalls.rst b/Documentation/drivers/media/uapi/dvb/frontend_fcalls.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend_fcalls.rst
rename to Documentation/drivers/media/uapi/dvb/frontend_fcalls.rst
diff --git a/Documentation/media/uapi/dvb/frontend_legacy_api.rst b/Documentation/drivers/media/uapi/dvb/frontend_legacy_api.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend_legacy_api.rst
rename to Documentation/drivers/media/uapi/dvb/frontend_legacy_api.rst
diff --git a/Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst b/Documentation/drivers/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
rename to Documentation/drivers/media/uapi/dvb/frontend_legacy_dvbv3_api.rst
diff --git a/Documentation/media/uapi/dvb/headers.rst b/Documentation/drivers/media/uapi/dvb/headers.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/headers.rst
rename to Documentation/drivers/media/uapi/dvb/headers.rst
diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/drivers/media/uapi/dvb/intro.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/intro.rst
rename to Documentation/drivers/media/uapi/dvb/intro.rst
diff --git a/Documentation/media/uapi/dvb/legacy_dvb_apis.rst b/Documentation/drivers/media/uapi/dvb/legacy_dvb_apis.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/legacy_dvb_apis.rst
rename to Documentation/drivers/media/uapi/dvb/legacy_dvb_apis.rst
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/drivers/media/uapi/dvb/net-add-if.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/net-add-if.rst
rename to Documentation/drivers/media/uapi/dvb/net-add-if.rst
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/drivers/media/uapi/dvb/net-get-if.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/net-get-if.rst
rename to Documentation/drivers/media/uapi/dvb/net-get-if.rst
diff --git a/Documentation/media/uapi/dvb/net-remove-if.rst b/Documentation/drivers/media/uapi/dvb/net-remove-if.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/net-remove-if.rst
rename to Documentation/drivers/media/uapi/dvb/net-remove-if.rst
diff --git a/Documentation/media/uapi/dvb/net-types.rst b/Documentation/drivers/media/uapi/dvb/net-types.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/net-types.rst
rename to Documentation/drivers/media/uapi/dvb/net-types.rst
diff --git a/Documentation/media/uapi/dvb/net.rst b/Documentation/drivers/media/uapi/dvb/net.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/net.rst
rename to Documentation/drivers/media/uapi/dvb/net.rst
diff --git a/Documentation/media/uapi/dvb/query-dvb-frontend-info.rst b/Documentation/drivers/media/uapi/dvb/query-dvb-frontend-info.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/query-dvb-frontend-info.rst
rename to Documentation/drivers/media/uapi/dvb/query-dvb-frontend-info.rst
diff --git a/Documentation/media/uapi/dvb/video-clear-buffer.rst b/Documentation/drivers/media/uapi/dvb/video-clear-buffer.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-clear-buffer.rst
rename to Documentation/drivers/media/uapi/dvb/video-clear-buffer.rst
diff --git a/Documentation/media/uapi/dvb/video-command.rst b/Documentation/drivers/media/uapi/dvb/video-command.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-command.rst
rename to Documentation/drivers/media/uapi/dvb/video-command.rst
diff --git a/Documentation/media/uapi/dvb/video-continue.rst b/Documentation/drivers/media/uapi/dvb/video-continue.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-continue.rst
rename to Documentation/drivers/media/uapi/dvb/video-continue.rst
diff --git a/Documentation/media/uapi/dvb/video-fast-forward.rst b/Documentation/drivers/media/uapi/dvb/video-fast-forward.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-fast-forward.rst
rename to Documentation/drivers/media/uapi/dvb/video-fast-forward.rst
diff --git a/Documentation/media/uapi/dvb/video-fclose.rst b/Documentation/drivers/media/uapi/dvb/video-fclose.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-fclose.rst
rename to Documentation/drivers/media/uapi/dvb/video-fclose.rst
diff --git a/Documentation/media/uapi/dvb/video-fopen.rst b/Documentation/drivers/media/uapi/dvb/video-fopen.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-fopen.rst
rename to Documentation/drivers/media/uapi/dvb/video-fopen.rst
diff --git a/Documentation/media/uapi/dvb/video-freeze.rst b/Documentation/drivers/media/uapi/dvb/video-freeze.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-freeze.rst
rename to Documentation/drivers/media/uapi/dvb/video-freeze.rst
diff --git a/Documentation/media/uapi/dvb/video-fwrite.rst b/Documentation/drivers/media/uapi/dvb/video-fwrite.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-fwrite.rst
rename to Documentation/drivers/media/uapi/dvb/video-fwrite.rst
diff --git a/Documentation/media/uapi/dvb/video-get-capabilities.rst b/Documentation/drivers/media/uapi/dvb/video-get-capabilities.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-capabilities.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-capabilities.rst
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/drivers/media/uapi/dvb/video-get-event.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-event.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-event.rst
diff --git a/Documentation/media/uapi/dvb/video-get-frame-count.rst b/Documentation/drivers/media/uapi/dvb/video-get-frame-count.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-frame-count.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-frame-count.rst
diff --git a/Documentation/media/uapi/dvb/video-get-pts.rst b/Documentation/drivers/media/uapi/dvb/video-get-pts.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-pts.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-pts.rst
diff --git a/Documentation/media/uapi/dvb/video-get-size.rst b/Documentation/drivers/media/uapi/dvb/video-get-size.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-size.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-size.rst
diff --git a/Documentation/media/uapi/dvb/video-get-status.rst b/Documentation/drivers/media/uapi/dvb/video-get-status.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-get-status.rst
rename to Documentation/drivers/media/uapi/dvb/video-get-status.rst
diff --git a/Documentation/media/uapi/dvb/video-play.rst b/Documentation/drivers/media/uapi/dvb/video-play.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-play.rst
rename to Documentation/drivers/media/uapi/dvb/video-play.rst
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/drivers/media/uapi/dvb/video-select-source.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-select-source.rst
rename to Documentation/drivers/media/uapi/dvb/video-select-source.rst
diff --git a/Documentation/media/uapi/dvb/video-set-blank.rst b/Documentation/drivers/media/uapi/dvb/video-set-blank.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-set-blank.rst
rename to Documentation/drivers/media/uapi/dvb/video-set-blank.rst
diff --git a/Documentation/media/uapi/dvb/video-set-display-format.rst b/Documentation/drivers/media/uapi/dvb/video-set-display-format.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-set-display-format.rst
rename to Documentation/drivers/media/uapi/dvb/video-set-display-format.rst
diff --git a/Documentation/media/uapi/dvb/video-set-format.rst b/Documentation/drivers/media/uapi/dvb/video-set-format.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-set-format.rst
rename to Documentation/drivers/media/uapi/dvb/video-set-format.rst
diff --git a/Documentation/media/uapi/dvb/video-set-streamtype.rst b/Documentation/drivers/media/uapi/dvb/video-set-streamtype.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-set-streamtype.rst
rename to Documentation/drivers/media/uapi/dvb/video-set-streamtype.rst
diff --git a/Documentation/media/uapi/dvb/video-slowmotion.rst b/Documentation/drivers/media/uapi/dvb/video-slowmotion.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-slowmotion.rst
rename to Documentation/drivers/media/uapi/dvb/video-slowmotion.rst
diff --git a/Documentation/media/uapi/dvb/video-stillpicture.rst b/Documentation/drivers/media/uapi/dvb/video-stillpicture.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-stillpicture.rst
rename to Documentation/drivers/media/uapi/dvb/video-stillpicture.rst
diff --git a/Documentation/media/uapi/dvb/video-stop.rst b/Documentation/drivers/media/uapi/dvb/video-stop.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-stop.rst
rename to Documentation/drivers/media/uapi/dvb/video-stop.rst
diff --git a/Documentation/media/uapi/dvb/video-try-command.rst b/Documentation/drivers/media/uapi/dvb/video-try-command.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video-try-command.rst
rename to Documentation/drivers/media/uapi/dvb/video-try-command.rst
diff --git a/Documentation/media/uapi/dvb/video.rst b/Documentation/drivers/media/uapi/dvb/video.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video.rst
rename to Documentation/drivers/media/uapi/dvb/video.rst
diff --git a/Documentation/media/uapi/dvb/video_function_calls.rst b/Documentation/drivers/media/uapi/dvb/video_function_calls.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video_function_calls.rst
rename to Documentation/drivers/media/uapi/dvb/video_function_calls.rst
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/drivers/media/uapi/dvb/video_types.rst
similarity index 100%
rename from Documentation/media/uapi/dvb/video_types.rst
rename to Documentation/drivers/media/uapi/dvb/video_types.rst
diff --git a/Documentation/media/uapi/fdl-appendix.rst b/Documentation/drivers/media/uapi/fdl-appendix.rst
similarity index 100%
rename from Documentation/media/uapi/fdl-appendix.rst
rename to Documentation/drivers/media/uapi/fdl-appendix.rst
diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/drivers/media/uapi/gen-errors.rst
similarity index 100%
rename from Documentation/media/uapi/gen-errors.rst
rename to Documentation/drivers/media/uapi/gen-errors.rst
diff --git a/Documentation/media/uapi/mediactl/media-controller-intro.rst b/Documentation/drivers/media/uapi/mediactl/media-controller-intro.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-controller-intro.rst
rename to Documentation/drivers/media/uapi/mediactl/media-controller-intro.rst
diff --git a/Documentation/media/uapi/mediactl/media-controller-model.rst b/Documentation/drivers/media/uapi/mediactl/media-controller-model.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-controller-model.rst
rename to Documentation/drivers/media/uapi/mediactl/media-controller-model.rst
diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/drivers/media/uapi/mediactl/media-controller.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-controller.rst
rename to Documentation/drivers/media/uapi/mediactl/media-controller.rst
diff --git a/Documentation/media/uapi/mediactl/media-func-close.rst b/Documentation/drivers/media/uapi/mediactl/media-func-close.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-func-close.rst
rename to Documentation/drivers/media/uapi/mediactl/media-func-close.rst
diff --git a/Documentation/media/uapi/mediactl/media-func-ioctl.rst b/Documentation/drivers/media/uapi/mediactl/media-func-ioctl.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-func-ioctl.rst
rename to Documentation/drivers/media/uapi/mediactl/media-func-ioctl.rst
diff --git a/Documentation/media/uapi/mediactl/media-func-open.rst b/Documentation/drivers/media/uapi/mediactl/media-func-open.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-func-open.rst
rename to Documentation/drivers/media/uapi/mediactl/media-func-open.rst
diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst b/Documentation/drivers/media/uapi/mediactl/media-funcs.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-funcs.rst
rename to Documentation/drivers/media/uapi/mediactl/media-funcs.rst
diff --git a/Documentation/media/uapi/mediactl/media-header.rst b/Documentation/drivers/media/uapi/mediactl/media-header.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-header.rst
rename to Documentation/drivers/media/uapi/mediactl/media-header.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-device-info.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-device-info.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-device-info.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-enum-entities.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-enum-entities.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-enum-links.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-enum-links.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-g-topology.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-g-topology.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-request-alloc.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-request-alloc.rst
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/drivers/media/uapi/mediactl/media-ioc-setup-link.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
rename to Documentation/drivers/media/uapi/mediactl/media-ioc-setup-link.rst
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-queue.rst b/Documentation/drivers/media/uapi/mediactl/media-request-ioc-queue.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
rename to Documentation/drivers/media/uapi/mediactl/media-request-ioc-queue.rst
diff --git a/Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst b/Documentation/drivers/media/uapi/mediactl/media-request-ioc-reinit.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
rename to Documentation/drivers/media/uapi/mediactl/media-request-ioc-reinit.rst
diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/drivers/media/uapi/mediactl/media-types.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/media-types.rst
rename to Documentation/drivers/media/uapi/mediactl/media-types.rst
diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/drivers/media/uapi/mediactl/request-api.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/request-api.rst
rename to Documentation/drivers/media/uapi/mediactl/request-api.rst
diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/drivers/media/uapi/mediactl/request-func-close.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/request-func-close.rst
rename to Documentation/drivers/media/uapi/mediactl/request-func-close.rst
diff --git a/Documentation/media/uapi/mediactl/request-func-ioctl.rst b/Documentation/drivers/media/uapi/mediactl/request-func-ioctl.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/request-func-ioctl.rst
rename to Documentation/drivers/media/uapi/mediactl/request-func-ioctl.rst
diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/drivers/media/uapi/mediactl/request-func-poll.rst
similarity index 100%
rename from Documentation/media/uapi/mediactl/request-func-poll.rst
rename to Documentation/drivers/media/uapi/mediactl/request-func-poll.rst
diff --git a/Documentation/media/uapi/rc/keytable.c.rst b/Documentation/drivers/media/uapi/rc/keytable.c.rst
similarity index 100%
rename from Documentation/media/uapi/rc/keytable.c.rst
rename to Documentation/drivers/media/uapi/rc/keytable.c.rst
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/drivers/media/uapi/rc/lirc-dev-intro.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-dev-intro.rst
rename to Documentation/drivers/media/uapi/rc/lirc-dev-intro.rst
diff --git a/Documentation/media/uapi/rc/lirc-dev.rst b/Documentation/drivers/media/uapi/rc/lirc-dev.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-dev.rst
rename to Documentation/drivers/media/uapi/rc/lirc-dev.rst
diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/drivers/media/uapi/rc/lirc-func.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-func.rst
rename to Documentation/drivers/media/uapi/rc/lirc-func.rst
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/drivers/media/uapi/rc/lirc-get-features.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-get-features.rst
rename to Documentation/drivers/media/uapi/rc/lirc-get-features.rst
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/drivers/media/uapi/rc/lirc-get-rec-mode.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-get-rec-mode.rst
rename to Documentation/drivers/media/uapi/rc/lirc-get-rec-mode.rst
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst b/Documentation/drivers/media/uapi/rc/lirc-get-rec-resolution.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
rename to Documentation/drivers/media/uapi/rc/lirc-get-rec-resolution.rst
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/drivers/media/uapi/rc/lirc-get-send-mode.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-get-send-mode.rst
rename to Documentation/drivers/media/uapi/rc/lirc-get-send-mode.rst
diff --git a/Documentation/media/uapi/rc/lirc-get-timeout.rst b/Documentation/drivers/media/uapi/rc/lirc-get-timeout.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-get-timeout.rst
rename to Documentation/drivers/media/uapi/rc/lirc-get-timeout.rst
diff --git a/Documentation/media/uapi/rc/lirc-header.rst b/Documentation/drivers/media/uapi/rc/lirc-header.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-header.rst
rename to Documentation/drivers/media/uapi/rc/lirc-header.rst
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/drivers/media/uapi/rc/lirc-read.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-read.rst
rename to Documentation/drivers/media/uapi/rc/lirc-read.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst b/Documentation/drivers/media/uapi/rc/lirc-set-measure-carrier-mode.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-measure-carrier-mode.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/drivers/media/uapi/rc/lirc-set-rec-carrier-range.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-rec-carrier-range.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst b/Documentation/drivers/media/uapi/rc/lirc-set-rec-carrier.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-rec-carrier.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/drivers/media/uapi/rc/lirc-set-rec-timeout-reports.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-rec-timeout-reports.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/drivers/media/uapi/rc/lirc-set-rec-timeout.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-rec-timeout.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst b/Documentation/drivers/media/uapi/rc/lirc-set-send-carrier.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-send-carrier.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-send-carrier.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst b/Documentation/drivers/media/uapi/rc/lirc-set-send-duty-cycle.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-send-duty-cycle.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst b/Documentation/drivers/media/uapi/rc/lirc-set-transmitter-mask.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-transmitter-mask.rst
diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/drivers/media/uapi/rc/lirc-set-wideband-receiver.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
rename to Documentation/drivers/media/uapi/rc/lirc-set-wideband-receiver.rst
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/drivers/media/uapi/rc/lirc-write.rst
similarity index 100%
rename from Documentation/media/uapi/rc/lirc-write.rst
rename to Documentation/drivers/media/uapi/rc/lirc-write.rst
diff --git a/Documentation/media/uapi/rc/rc-intro.rst b/Documentation/drivers/media/uapi/rc/rc-intro.rst
similarity index 100%
rename from Documentation/media/uapi/rc/rc-intro.rst
rename to Documentation/drivers/media/uapi/rc/rc-intro.rst
diff --git a/Documentation/media/uapi/rc/rc-sysfs-nodes.rst b/Documentation/drivers/media/uapi/rc/rc-sysfs-nodes.rst
similarity index 100%
rename from Documentation/media/uapi/rc/rc-sysfs-nodes.rst
rename to Documentation/drivers/media/uapi/rc/rc-sysfs-nodes.rst
diff --git a/Documentation/media/uapi/rc/rc-table-change.rst b/Documentation/drivers/media/uapi/rc/rc-table-change.rst
similarity index 100%
rename from Documentation/media/uapi/rc/rc-table-change.rst
rename to Documentation/drivers/media/uapi/rc/rc-table-change.rst
diff --git a/Documentation/media/uapi/rc/rc-tables.rst b/Documentation/drivers/media/uapi/rc/rc-tables.rst
similarity index 100%
rename from Documentation/media/uapi/rc/rc-tables.rst
rename to Documentation/drivers/media/uapi/rc/rc-tables.rst
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/drivers/media/uapi/rc/remote_controllers.rst
similarity index 100%
rename from Documentation/media/uapi/rc/remote_controllers.rst
rename to Documentation/drivers/media/uapi/rc/remote_controllers.rst
diff --git a/Documentation/media/uapi/v4l/app-pri.rst b/Documentation/drivers/media/uapi/v4l/app-pri.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/app-pri.rst
rename to Documentation/drivers/media/uapi/v4l/app-pri.rst
diff --git a/Documentation/media/uapi/v4l/async.rst b/Documentation/drivers/media/uapi/v4l/async.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/async.rst
rename to Documentation/drivers/media/uapi/v4l/async.rst
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/drivers/media/uapi/v4l/audio.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/audio.rst
rename to Documentation/drivers/media/uapi/v4l/audio.rst
diff --git a/Documentation/media/uapi/v4l/bayer.svg b/Documentation/drivers/media/uapi/v4l/bayer.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/bayer.svg
rename to Documentation/drivers/media/uapi/v4l/bayer.svg
diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/drivers/media/uapi/v4l/biblio.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/biblio.rst
rename to Documentation/drivers/media/uapi/v4l/biblio.rst
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/drivers/media/uapi/v4l/buffer.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/buffer.rst
rename to Documentation/drivers/media/uapi/v4l/buffer.rst
diff --git a/Documentation/media/uapi/v4l/capture-example.rst b/Documentation/drivers/media/uapi/v4l/capture-example.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/capture-example.rst
rename to Documentation/drivers/media/uapi/v4l/capture-example.rst
diff --git a/Documentation/media/uapi/v4l/capture.c.rst b/Documentation/drivers/media/uapi/v4l/capture.c.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/capture.c.rst
rename to Documentation/drivers/media/uapi/v4l/capture.c.rst
diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/drivers/media/uapi/v4l/colorspaces-defs.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/colorspaces-defs.rst
rename to Documentation/drivers/media/uapi/v4l/colorspaces-defs.rst
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/drivers/media/uapi/v4l/colorspaces-details.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/colorspaces-details.rst
rename to Documentation/drivers/media/uapi/v4l/colorspaces-details.rst
diff --git a/Documentation/media/uapi/v4l/colorspaces.rst b/Documentation/drivers/media/uapi/v4l/colorspaces.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/colorspaces.rst
rename to Documentation/drivers/media/uapi/v4l/colorspaces.rst
diff --git a/Documentation/media/uapi/v4l/common-defs.rst b/Documentation/drivers/media/uapi/v4l/common-defs.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/common-defs.rst
rename to Documentation/drivers/media/uapi/v4l/common-defs.rst
diff --git a/Documentation/media/uapi/v4l/common.rst b/Documentation/drivers/media/uapi/v4l/common.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/common.rst
rename to Documentation/drivers/media/uapi/v4l/common.rst
diff --git a/Documentation/media/uapi/v4l/compat.rst b/Documentation/drivers/media/uapi/v4l/compat.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/compat.rst
rename to Documentation/drivers/media/uapi/v4l/compat.rst
diff --git a/Documentation/media/uapi/v4l/constraints.svg b/Documentation/drivers/media/uapi/v4l/constraints.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/constraints.svg
rename to Documentation/drivers/media/uapi/v4l/constraints.svg
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/drivers/media/uapi/v4l/control.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/control.rst
rename to Documentation/drivers/media/uapi/v4l/control.rst
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/drivers/media/uapi/v4l/crop.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/crop.rst
rename to Documentation/drivers/media/uapi/v4l/crop.rst
diff --git a/Documentation/media/uapi/v4l/crop.svg b/Documentation/drivers/media/uapi/v4l/crop.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/crop.svg
rename to Documentation/drivers/media/uapi/v4l/crop.svg
diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/drivers/media/uapi/v4l/depth-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/depth-formats.rst
rename to Documentation/drivers/media/uapi/v4l/depth-formats.rst
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/drivers/media/uapi/v4l/dev-capture.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-capture.rst
rename to Documentation/drivers/media/uapi/v4l/dev-capture.rst
diff --git a/Documentation/media/uapi/v4l/dev-event.rst b/Documentation/drivers/media/uapi/v4l/dev-event.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-event.rst
rename to Documentation/drivers/media/uapi/v4l/dev-event.rst
diff --git a/Documentation/media/uapi/v4l/dev-mem2mem.rst b/Documentation/drivers/media/uapi/v4l/dev-mem2mem.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-mem2mem.rst
rename to Documentation/drivers/media/uapi/v4l/dev-mem2mem.rst
diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/drivers/media/uapi/v4l/dev-meta.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-meta.rst
rename to Documentation/drivers/media/uapi/v4l/dev-meta.rst
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/drivers/media/uapi/v4l/dev-osd.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-osd.rst
rename to Documentation/drivers/media/uapi/v4l/dev-osd.rst
diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/drivers/media/uapi/v4l/dev-output.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-output.rst
rename to Documentation/drivers/media/uapi/v4l/dev-output.rst
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/drivers/media/uapi/v4l/dev-overlay.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-overlay.rst
rename to Documentation/drivers/media/uapi/v4l/dev-overlay.rst
diff --git a/Documentation/media/uapi/v4l/dev-radio.rst b/Documentation/drivers/media/uapi/v4l/dev-radio.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-radio.rst
rename to Documentation/drivers/media/uapi/v4l/dev-radio.rst
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/drivers/media/uapi/v4l/dev-raw-vbi.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-raw-vbi.rst
rename to Documentation/drivers/media/uapi/v4l/dev-raw-vbi.rst
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/drivers/media/uapi/v4l/dev-rds.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-rds.rst
rename to Documentation/drivers/media/uapi/v4l/dev-rds.rst
diff --git a/Documentation/media/uapi/v4l/dev-sdr.rst b/Documentation/drivers/media/uapi/v4l/dev-sdr.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-sdr.rst
rename to Documentation/drivers/media/uapi/v4l/dev-sdr.rst
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/drivers/media/uapi/v4l/dev-sliced-vbi.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-sliced-vbi.rst
rename to Documentation/drivers/media/uapi/v4l/dev-sliced-vbi.rst
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/drivers/media/uapi/v4l/dev-subdev.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-subdev.rst
rename to Documentation/drivers/media/uapi/v4l/dev-subdev.rst
diff --git a/Documentation/media/uapi/v4l/dev-touch.rst b/Documentation/drivers/media/uapi/v4l/dev-touch.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dev-touch.rst
rename to Documentation/drivers/media/uapi/v4l/dev-touch.rst
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/drivers/media/uapi/v4l/devices.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/devices.rst
rename to Documentation/drivers/media/uapi/v4l/devices.rst
diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/drivers/media/uapi/v4l/diff-v4l.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/diff-v4l.rst
rename to Documentation/drivers/media/uapi/v4l/diff-v4l.rst
diff --git a/Documentation/media/uapi/v4l/dmabuf.rst b/Documentation/drivers/media/uapi/v4l/dmabuf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dmabuf.rst
rename to Documentation/drivers/media/uapi/v4l/dmabuf.rst
diff --git a/Documentation/media/uapi/v4l/dv-timings.rst b/Documentation/drivers/media/uapi/v4l/dv-timings.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/dv-timings.rst
rename to Documentation/drivers/media/uapi/v4l/dv-timings.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-camera.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-camera.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-camera.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-camera.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-codec.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-codec.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-codec.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-detect.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-detect.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-detect.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-detect.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-dv.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-dv.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-dv.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-dv.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-flash.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-flash.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-flash.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-flash.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-fm-rx.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-fm-rx.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-fm-tx.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-fm-tx.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-image-process.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-image-process.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-image-process.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-image-process.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-image-source.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-image-source.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-image-source.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-image-source.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-jpeg.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-jpeg.rst
diff --git a/Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst b/Documentation/drivers/media/uapi/v4l/ext-ctrls-rf-tuner.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst
rename to Documentation/drivers/media/uapi/v4l/ext-ctrls-rf-tuner.rst
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/drivers/media/uapi/v4l/extended-controls.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/extended-controls.rst
rename to Documentation/drivers/media/uapi/v4l/extended-controls.rst
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/drivers/media/uapi/v4l/field-order.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/field-order.rst
rename to Documentation/drivers/media/uapi/v4l/field-order.rst
diff --git a/Documentation/media/uapi/v4l/fieldseq_bt.svg b/Documentation/drivers/media/uapi/v4l/fieldseq_bt.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/fieldseq_bt.svg
rename to Documentation/drivers/media/uapi/v4l/fieldseq_bt.svg
diff --git a/Documentation/media/uapi/v4l/fieldseq_tb.svg b/Documentation/drivers/media/uapi/v4l/fieldseq_tb.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/fieldseq_tb.svg
rename to Documentation/drivers/media/uapi/v4l/fieldseq_tb.svg
diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/drivers/media/uapi/v4l/format.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/format.rst
rename to Documentation/drivers/media/uapi/v4l/format.rst
diff --git a/Documentation/media/uapi/v4l/func-close.rst b/Documentation/drivers/media/uapi/v4l/func-close.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-close.rst
rename to Documentation/drivers/media/uapi/v4l/func-close.rst
diff --git a/Documentation/media/uapi/v4l/func-ioctl.rst b/Documentation/drivers/media/uapi/v4l/func-ioctl.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-ioctl.rst
rename to Documentation/drivers/media/uapi/v4l/func-ioctl.rst
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/drivers/media/uapi/v4l/func-mmap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-mmap.rst
rename to Documentation/drivers/media/uapi/v4l/func-mmap.rst
diff --git a/Documentation/media/uapi/v4l/func-munmap.rst b/Documentation/drivers/media/uapi/v4l/func-munmap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-munmap.rst
rename to Documentation/drivers/media/uapi/v4l/func-munmap.rst
diff --git a/Documentation/media/uapi/v4l/func-open.rst b/Documentation/drivers/media/uapi/v4l/func-open.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-open.rst
rename to Documentation/drivers/media/uapi/v4l/func-open.rst
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/drivers/media/uapi/v4l/func-poll.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-poll.rst
rename to Documentation/drivers/media/uapi/v4l/func-poll.rst
diff --git a/Documentation/media/uapi/v4l/func-read.rst b/Documentation/drivers/media/uapi/v4l/func-read.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-read.rst
rename to Documentation/drivers/media/uapi/v4l/func-read.rst
diff --git a/Documentation/media/uapi/v4l/func-select.rst b/Documentation/drivers/media/uapi/v4l/func-select.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-select.rst
rename to Documentation/drivers/media/uapi/v4l/func-select.rst
diff --git a/Documentation/media/uapi/v4l/func-write.rst b/Documentation/drivers/media/uapi/v4l/func-write.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/func-write.rst
rename to Documentation/drivers/media/uapi/v4l/func-write.rst
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/drivers/media/uapi/v4l/hist-v4l2.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/hist-v4l2.rst
rename to Documentation/drivers/media/uapi/v4l/hist-v4l2.rst
diff --git a/Documentation/media/uapi/v4l/hsv-formats.rst b/Documentation/drivers/media/uapi/v4l/hsv-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/hsv-formats.rst
rename to Documentation/drivers/media/uapi/v4l/hsv-formats.rst
diff --git a/Documentation/media/uapi/v4l/io.rst b/Documentation/drivers/media/uapi/v4l/io.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/io.rst
rename to Documentation/drivers/media/uapi/v4l/io.rst
diff --git a/Documentation/media/uapi/v4l/libv4l-introduction.rst b/Documentation/drivers/media/uapi/v4l/libv4l-introduction.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/libv4l-introduction.rst
rename to Documentation/drivers/media/uapi/v4l/libv4l-introduction.rst
diff --git a/Documentation/media/uapi/v4l/libv4l.rst b/Documentation/drivers/media/uapi/v4l/libv4l.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/libv4l.rst
rename to Documentation/drivers/media/uapi/v4l/libv4l.rst
diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/drivers/media/uapi/v4l/meta-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/meta-formats.rst
rename to Documentation/drivers/media/uapi/v4l/meta-formats.rst
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/drivers/media/uapi/v4l/mmap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/mmap.rst
rename to Documentation/drivers/media/uapi/v4l/mmap.rst
diff --git a/Documentation/media/uapi/v4l/nv12mt.svg b/Documentation/drivers/media/uapi/v4l/nv12mt.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/nv12mt.svg
rename to Documentation/drivers/media/uapi/v4l/nv12mt.svg
diff --git a/Documentation/media/uapi/v4l/nv12mt_example.svg b/Documentation/drivers/media/uapi/v4l/nv12mt_example.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/nv12mt_example.svg
rename to Documentation/drivers/media/uapi/v4l/nv12mt_example.svg
diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/drivers/media/uapi/v4l/open.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/open.rst
rename to Documentation/drivers/media/uapi/v4l/open.rst
diff --git a/Documentation/media/uapi/v4l/pipeline.dot b/Documentation/drivers/media/uapi/v4l/pipeline.dot
similarity index 100%
rename from Documentation/media/uapi/v4l/pipeline.dot
rename to Documentation/drivers/media/uapi/v4l/pipeline.dot
diff --git a/Documentation/media/uapi/v4l/pixfmt-cnf4.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-cnf4.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-cnf4.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-cnf4.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-compressed.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-compressed.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-compressed.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-grey.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-grey.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-grey.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-grey.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-indexed.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-indexed.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-indexed.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-indexed.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-intro.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-intro.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-intro.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-intro.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-inzi.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-inzi.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-inzi.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-m420.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-m420.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-m420.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-m420.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-meta-d4xx.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-meta-d4xx.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-meta-uvc.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-meta-uvc.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv12.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv12.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv12.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv12m.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv12m.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv12m.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv12mt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv12mt.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv16m.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv16m.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv16m.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv24.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-nv24.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-nv24.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-nv24.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-packed-hsv.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-packed-hsv.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-packed-rgb.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-packed-rgb.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-packed-yuv.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-packed-yuv.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-reserved.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-reserved.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-reserved.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-reserved.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-rgb.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-rgb.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-rgb.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-rgb.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cs08.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cs08.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cs14le.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cs14le.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cu08.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cu08.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cu16le.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-cu16le.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-sdr-ru12le.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-sdr-ru12le.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb10.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb10.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb10.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb10alaw8.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb10alaw8.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb10dpcm8.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb10p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb10p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb12.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb12.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb12.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb12p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb12p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb12p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb14p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb14p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb14p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-srggb8.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-srggb8.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-srggb8.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td08.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-tch-td08.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-tch-td08.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-td16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-tch-td16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-tch-td16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-tch-tu08.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-tch-tu08.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-tch-tu16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-tch-tu16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-uv8.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-uv8.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-uv8.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-uv8.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-uyvy.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-uyvy.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-uyvy.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-v4l2-mplane.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-v4l2-mplane.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-v4l2.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-v4l2.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-v4l2.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-vyuy.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-vyuy.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-vyuy.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y10.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y10.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y10.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10b.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y10b.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y10b.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y10b.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y10p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y10p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y10p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y12.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y12.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y12.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12i.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y12i.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y12i.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y12i.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y16-be.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y16-be.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y16-be.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y41p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y41p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y41p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y41p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-y8i.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-y8i.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-y8i.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-y8i.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv410.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv410.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv410.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv411p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv411p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv420.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv420.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv420.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv420m.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv420m.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv422m.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv422m.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv422p.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv422p.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuv444m.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuv444m.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yuyv.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yuyv.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yuyv.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-yvyu.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-yvyu.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-yvyu.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-z16.rst b/Documentation/drivers/media/uapi/v4l/pixfmt-z16.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-z16.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt-z16.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/drivers/media/uapi/v4l/pixfmt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt.rst
rename to Documentation/drivers/media/uapi/v4l/pixfmt.rst
diff --git a/Documentation/media/uapi/v4l/planar-apis.rst b/Documentation/drivers/media/uapi/v4l/planar-apis.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/planar-apis.rst
rename to Documentation/drivers/media/uapi/v4l/planar-apis.rst
diff --git a/Documentation/media/uapi/v4l/querycap.rst b/Documentation/drivers/media/uapi/v4l/querycap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/querycap.rst
rename to Documentation/drivers/media/uapi/v4l/querycap.rst
diff --git a/Documentation/media/uapi/v4l/rw.rst b/Documentation/drivers/media/uapi/v4l/rw.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/rw.rst
rename to Documentation/drivers/media/uapi/v4l/rw.rst
diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst b/Documentation/drivers/media/uapi/v4l/sdr-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/sdr-formats.rst
rename to Documentation/drivers/media/uapi/v4l/sdr-formats.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-configuration.rst b/Documentation/drivers/media/uapi/v4l/selection-api-configuration.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-configuration.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api-configuration.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-examples.rst b/Documentation/drivers/media/uapi/v4l/selection-api-examples.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-examples.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api-examples.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-intro.rst b/Documentation/drivers/media/uapi/v4l/selection-api-intro.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-intro.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api-intro.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-targets.rst b/Documentation/drivers/media/uapi/v4l/selection-api-targets.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-targets.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api-targets.rst
diff --git a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst b/Documentation/drivers/media/uapi/v4l/selection-api-vs-crop-api.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api-vs-crop-api.rst
diff --git a/Documentation/media/uapi/v4l/selection-api.rst b/Documentation/drivers/media/uapi/v4l/selection-api.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selection-api.rst
rename to Documentation/drivers/media/uapi/v4l/selection-api.rst
diff --git a/Documentation/media/uapi/v4l/selection.svg b/Documentation/drivers/media/uapi/v4l/selection.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/selection.svg
rename to Documentation/drivers/media/uapi/v4l/selection.svg
diff --git a/Documentation/media/uapi/v4l/selections-common.rst b/Documentation/drivers/media/uapi/v4l/selections-common.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/selections-common.rst
rename to Documentation/drivers/media/uapi/v4l/selections-common.rst
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/drivers/media/uapi/v4l/standard.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/standard.rst
rename to Documentation/drivers/media/uapi/v4l/standard.rst
diff --git a/Documentation/media/uapi/v4l/streaming-par.rst b/Documentation/drivers/media/uapi/v4l/streaming-par.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/streaming-par.rst
rename to Documentation/drivers/media/uapi/v4l/streaming-par.rst
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/drivers/media/uapi/v4l/subdev-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/subdev-formats.rst
rename to Documentation/drivers/media/uapi/v4l/subdev-formats.rst
diff --git a/Documentation/media/uapi/v4l/subdev-image-processing-crop.svg b/Documentation/drivers/media/uapi/v4l/subdev-image-processing-crop.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/subdev-image-processing-crop.svg
rename to Documentation/drivers/media/uapi/v4l/subdev-image-processing-crop.svg
diff --git a/Documentation/media/uapi/v4l/subdev-image-processing-full.svg b/Documentation/drivers/media/uapi/v4l/subdev-image-processing-full.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/subdev-image-processing-full.svg
rename to Documentation/drivers/media/uapi/v4l/subdev-image-processing-full.svg
diff --git a/Documentation/media/uapi/v4l/subdev-image-processing-scaling-multi-source.svg b/Documentation/drivers/media/uapi/v4l/subdev-image-processing-scaling-multi-source.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/subdev-image-processing-scaling-multi-source.svg
rename to Documentation/drivers/media/uapi/v4l/subdev-image-processing-scaling-multi-source.svg
diff --git a/Documentation/media/uapi/v4l/tch-formats.rst b/Documentation/drivers/media/uapi/v4l/tch-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/tch-formats.rst
rename to Documentation/drivers/media/uapi/v4l/tch-formats.rst
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/drivers/media/uapi/v4l/tuner.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/tuner.rst
rename to Documentation/drivers/media/uapi/v4l/tuner.rst
diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/drivers/media/uapi/v4l/user-func.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/user-func.rst
rename to Documentation/drivers/media/uapi/v4l/user-func.rst
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/drivers/media/uapi/v4l/userp.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/userp.rst
rename to Documentation/drivers/media/uapi/v4l/userp.rst
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-flags.rst b/Documentation/drivers/media/uapi/v4l/v4l2-selection-flags.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/v4l2-selection-flags.rst
rename to Documentation/drivers/media/uapi/v4l/v4l2-selection-flags.rst
diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/drivers/media/uapi/v4l/v4l2-selection-targets.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/v4l2-selection-targets.rst
rename to Documentation/drivers/media/uapi/v4l/v4l2-selection-targets.rst
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/drivers/media/uapi/v4l/v4l2.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/v4l2.rst
rename to Documentation/drivers/media/uapi/v4l/v4l2.rst
diff --git a/Documentation/media/uapi/v4l/v4l2grab-example.rst b/Documentation/drivers/media/uapi/v4l/v4l2grab-example.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/v4l2grab-example.rst
rename to Documentation/drivers/media/uapi/v4l/v4l2grab-example.rst
diff --git a/Documentation/media/uapi/v4l/v4l2grab.c.rst b/Documentation/drivers/media/uapi/v4l/v4l2grab.c.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/v4l2grab.c.rst
rename to Documentation/drivers/media/uapi/v4l/v4l2grab.c.rst
diff --git a/Documentation/media/uapi/v4l/vbi_525.svg b/Documentation/drivers/media/uapi/v4l/vbi_525.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/vbi_525.svg
rename to Documentation/drivers/media/uapi/v4l/vbi_525.svg
diff --git a/Documentation/media/uapi/v4l/vbi_625.svg b/Documentation/drivers/media/uapi/v4l/vbi_625.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/vbi_625.svg
rename to Documentation/drivers/media/uapi/v4l/vbi_625.svg
diff --git a/Documentation/media/uapi/v4l/vbi_hsync.svg b/Documentation/drivers/media/uapi/v4l/vbi_hsync.svg
similarity index 100%
rename from Documentation/media/uapi/v4l/vbi_hsync.svg
rename to Documentation/drivers/media/uapi/v4l/vbi_hsync.svg
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/drivers/media/uapi/v4l/video.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/video.rst
rename to Documentation/drivers/media/uapi/v4l/video.rst
diff --git a/Documentation/media/uapi/v4l/videodev.rst b/Documentation/drivers/media/uapi/v4l/videodev.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/videodev.rst
rename to Documentation/drivers/media/uapi/v4l/videodev.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/drivers/media/uapi/v4l/vidioc-create-bufs.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-create-bufs.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-create-bufs.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/drivers/media/uapi/v4l/vidioc-cropcap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-cropcap.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-cropcap.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/drivers/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/drivers/media/uapi/v4l/vidioc-dbg-g-register.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-dbg-g-register.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/drivers/media/uapi/v4l/vidioc-decoder-cmd.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-decoder-cmd.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/drivers/media/uapi/v4l/vidioc-dqevent.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-dqevent.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-dqevent.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/drivers/media/uapi/v4l/vidioc-dv-timings-cap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-dv-timings-cap.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/drivers/media/uapi/v4l/vidioc-encoder-cmd.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-encoder-cmd.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enum-dv-timings.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enum-dv-timings.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enum-fmt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enum-fmt.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enum-frameintervals.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enum-frameintervals.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enum-framesizes.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enum-framesizes.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enum-freq-bands.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enum-freq-bands.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enumaudio.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enumaudio.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enumaudio.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enumaudioout.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enumaudioout.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enuminput.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enuminput.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enuminput.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enumoutput.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enumoutput.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enumoutput.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/drivers/media/uapi/v4l/vidioc-enumstd.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-enumstd.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-enumstd.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/drivers/media/uapi/v4l/vidioc-expbuf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-expbuf.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-expbuf.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-audio.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-audio.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-audio.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-audioout.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-audioout.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-audioout.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-crop.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-crop.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-crop.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-ctrl.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-ctrl.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-dv-timings.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-dv-timings.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-edid.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-edid.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-edid.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-enc-index.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-enc-index.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-ext-ctrls.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-ext-ctrls.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-fbuf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-fbuf.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-fmt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-fmt.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-fmt.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-frequency.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-frequency.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-frequency.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-input.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-input.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-input.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-jpegcomp.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-jpegcomp.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-modulator.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-modulator.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-modulator.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-output.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-output.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-output.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-parm.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-parm.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-parm.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-priority.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-priority.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-priority.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-selection.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-selection.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-selection.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-std.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-std.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-std.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/drivers/media/uapi/v4l/vidioc-g-tuner.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-g-tuner.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-g-tuner.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-log-status.rst b/Documentation/drivers/media/uapi/v4l/vidioc-log-status.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-log-status.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-log-status.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-overlay.rst b/Documentation/drivers/media/uapi/v4l/vidioc-overlay.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-overlay.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-overlay.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/drivers/media/uapi/v4l/vidioc-prepare-buf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-prepare-buf.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/drivers/media/uapi/v4l/vidioc-qbuf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-qbuf.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-qbuf.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/drivers/media/uapi/v4l/vidioc-query-dv-timings.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-query-dv-timings.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/drivers/media/uapi/v4l/vidioc-querybuf.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-querybuf.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-querybuf.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/drivers/media/uapi/v4l/vidioc-querycap.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-querycap.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-querycap.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/drivers/media/uapi/v4l/vidioc-queryctrl.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-queryctrl.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-queryctrl.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/drivers/media/uapi/v4l/vidioc-querystd.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-querystd.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-querystd.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/drivers/media/uapi/v4l/vidioc-reqbufs.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-reqbufs.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-reqbufs.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/drivers/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/drivers/media/uapi/v4l/vidioc-streamon.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-streamon.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-streamon.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-crop.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-crop.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-fmt.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-fmt.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-selection.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subdev-g-selection.rst
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/drivers/media/uapi/v4l/vidioc-subscribe-event.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
rename to Documentation/drivers/media/uapi/v4l/vidioc-subscribe-event.rst
diff --git a/Documentation/media/uapi/v4l/yuv-formats.rst b/Documentation/drivers/media/uapi/v4l/yuv-formats.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/yuv-formats.rst
rename to Documentation/drivers/media/uapi/v4l/yuv-formats.rst
diff --git a/Documentation/media/v4l-drivers/au0828-cardlist.rst b/Documentation/drivers/media/v4l-drivers/au0828-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/au0828-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/au0828-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/bttv-cardlist.rst b/Documentation/drivers/media/v4l-drivers/bttv-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/bttv-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/bttv-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/bttv.rst b/Documentation/drivers/media/v4l-drivers/bttv.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/bttv.rst
rename to Documentation/drivers/media/v4l-drivers/bttv.rst
diff --git a/Documentation/media/v4l-drivers/cafe_ccic.rst b/Documentation/drivers/media/v4l-drivers/cafe_ccic.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cafe_ccic.rst
rename to Documentation/drivers/media/v4l-drivers/cafe_ccic.rst
diff --git a/Documentation/media/v4l-drivers/cardlist.rst b/Documentation/drivers/media/v4l-drivers/cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/cardlist.rst
diff --git a/Documentation/media/v4l-drivers/cpia2.rst b/Documentation/drivers/media/v4l-drivers/cpia2.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cpia2.rst
rename to Documentation/drivers/media/v4l-drivers/cpia2.rst
diff --git a/Documentation/media/v4l-drivers/cx18.rst b/Documentation/drivers/media/v4l-drivers/cx18.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cx18.rst
rename to Documentation/drivers/media/v4l-drivers/cx18.rst
diff --git a/Documentation/media/v4l-drivers/cx2341x.rst b/Documentation/drivers/media/v4l-drivers/cx2341x.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cx2341x.rst
rename to Documentation/drivers/media/v4l-drivers/cx2341x.rst
diff --git a/Documentation/media/v4l-drivers/cx23885-cardlist.rst b/Documentation/drivers/media/v4l-drivers/cx23885-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cx23885-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/cx23885-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/cx88-cardlist.rst b/Documentation/drivers/media/v4l-drivers/cx88-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cx88-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/cx88-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/drivers/media/v4l-drivers/cx88.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/cx88.rst
rename to Documentation/drivers/media/v4l-drivers/cx88.rst
diff --git a/Documentation/media/v4l-drivers/davinci-vpbe.rst b/Documentation/drivers/media/v4l-drivers/davinci-vpbe.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/davinci-vpbe.rst
rename to Documentation/drivers/media/v4l-drivers/davinci-vpbe.rst
diff --git a/Documentation/media/v4l-drivers/em28xx-cardlist.rst b/Documentation/drivers/media/v4l-drivers/em28xx-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/em28xx-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/em28xx-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/fimc.rst b/Documentation/drivers/media/v4l-drivers/fimc.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/fimc.rst
rename to Documentation/drivers/media/v4l-drivers/fimc.rst
diff --git a/Documentation/media/v4l-drivers/fourcc.rst b/Documentation/drivers/media/v4l-drivers/fourcc.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/fourcc.rst
rename to Documentation/drivers/media/v4l-drivers/fourcc.rst
diff --git a/Documentation/media/v4l-drivers/gspca-cardlist.rst b/Documentation/drivers/media/v4l-drivers/gspca-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/gspca-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/gspca-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/drivers/media/v4l-drivers/imx.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/imx.rst
rename to Documentation/drivers/media/v4l-drivers/imx.rst
diff --git a/Documentation/media/v4l-drivers/imx7.rst b/Documentation/drivers/media/v4l-drivers/imx7.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/imx7.rst
rename to Documentation/drivers/media/v4l-drivers/imx7.rst
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/drivers/media/v4l-drivers/index.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/index.rst
rename to Documentation/drivers/media/v4l-drivers/index.rst
diff --git a/Documentation/media/v4l-drivers/ipu3.rst b/Documentation/drivers/media/v4l-drivers/ipu3.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/ipu3.rst
rename to Documentation/drivers/media/v4l-drivers/ipu3.rst
diff --git a/Documentation/media/v4l-drivers/ivtv-cardlist.rst b/Documentation/drivers/media/v4l-drivers/ivtv-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/ivtv-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/ivtv-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/ivtv.rst b/Documentation/drivers/media/v4l-drivers/ivtv.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/ivtv.rst
rename to Documentation/drivers/media/v4l-drivers/ivtv.rst
diff --git a/Documentation/media/v4l-drivers/max2175.rst b/Documentation/drivers/media/v4l-drivers/max2175.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/max2175.rst
rename to Documentation/drivers/media/v4l-drivers/max2175.rst
diff --git a/Documentation/media/v4l-drivers/meye.rst b/Documentation/drivers/media/v4l-drivers/meye.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/meye.rst
rename to Documentation/drivers/media/v4l-drivers/meye.rst
diff --git a/Documentation/media/v4l-drivers/omap3isp.rst b/Documentation/drivers/media/v4l-drivers/omap3isp.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/omap3isp.rst
rename to Documentation/drivers/media/v4l-drivers/omap3isp.rst
diff --git a/Documentation/media/v4l-drivers/omap4_camera.rst b/Documentation/drivers/media/v4l-drivers/omap4_camera.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/omap4_camera.rst
rename to Documentation/drivers/media/v4l-drivers/omap4_camera.rst
diff --git a/Documentation/media/v4l-drivers/philips.rst b/Documentation/drivers/media/v4l-drivers/philips.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/philips.rst
rename to Documentation/drivers/media/v4l-drivers/philips.rst
diff --git a/Documentation/media/v4l-drivers/pvrusb2.rst b/Documentation/drivers/media/v4l-drivers/pvrusb2.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/pvrusb2.rst
rename to Documentation/drivers/media/v4l-drivers/pvrusb2.rst
diff --git a/Documentation/media/v4l-drivers/pxa_camera.rst b/Documentation/drivers/media/v4l-drivers/pxa_camera.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/pxa_camera.rst
rename to Documentation/drivers/media/v4l-drivers/pxa_camera.rst
diff --git a/Documentation/media/v4l-drivers/qcom_camss.rst b/Documentation/drivers/media/v4l-drivers/qcom_camss.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/qcom_camss.rst
rename to Documentation/drivers/media/v4l-drivers/qcom_camss.rst
diff --git a/Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot b/Documentation/drivers/media/v4l-drivers/qcom_camss_8x96_graph.dot
similarity index 100%
rename from Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
rename to Documentation/drivers/media/v4l-drivers/qcom_camss_8x96_graph.dot
diff --git a/Documentation/media/v4l-drivers/qcom_camss_graph.dot b/Documentation/drivers/media/v4l-drivers/qcom_camss_graph.dot
similarity index 100%
rename from Documentation/media/v4l-drivers/qcom_camss_graph.dot
rename to Documentation/drivers/media/v4l-drivers/qcom_camss_graph.dot
diff --git a/Documentation/media/v4l-drivers/radiotrack.rst b/Documentation/drivers/media/v4l-drivers/radiotrack.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/radiotrack.rst
rename to Documentation/drivers/media/v4l-drivers/radiotrack.rst
diff --git a/Documentation/media/v4l-drivers/rcar-fdp1.rst b/Documentation/drivers/media/v4l-drivers/rcar-fdp1.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/rcar-fdp1.rst
rename to Documentation/drivers/media/v4l-drivers/rcar-fdp1.rst
diff --git a/Documentation/media/v4l-drivers/saa7134-cardlist.rst b/Documentation/drivers/media/v4l-drivers/saa7134-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/saa7134-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/saa7134-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/saa7134.rst b/Documentation/drivers/media/v4l-drivers/saa7134.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/saa7134.rst
rename to Documentation/drivers/media/v4l-drivers/saa7134.rst
diff --git a/Documentation/media/v4l-drivers/saa7164-cardlist.rst b/Documentation/drivers/media/v4l-drivers/saa7164-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/saa7164-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/saa7164-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst b/Documentation/drivers/media/v4l-drivers/sh_mobile_ceu_camera.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
rename to Documentation/drivers/media/v4l-drivers/sh_mobile_ceu_camera.rst
diff --git a/Documentation/media/v4l-drivers/si470x.rst b/Documentation/drivers/media/v4l-drivers/si470x.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/si470x.rst
rename to Documentation/drivers/media/v4l-drivers/si470x.rst
diff --git a/Documentation/media/v4l-drivers/si4713.rst b/Documentation/drivers/media/v4l-drivers/si4713.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/si4713.rst
rename to Documentation/drivers/media/v4l-drivers/si4713.rst
diff --git a/Documentation/media/v4l-drivers/si476x.rst b/Documentation/drivers/media/v4l-drivers/si476x.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/si476x.rst
rename to Documentation/drivers/media/v4l-drivers/si476x.rst
diff --git a/Documentation/media/v4l-drivers/soc-camera.rst b/Documentation/drivers/media/v4l-drivers/soc-camera.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/soc-camera.rst
rename to Documentation/drivers/media/v4l-drivers/soc-camera.rst
diff --git a/Documentation/media/v4l-drivers/tm6000-cardlist.rst b/Documentation/drivers/media/v4l-drivers/tm6000-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/tm6000-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/tm6000-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/tuner-cardlist.rst b/Documentation/drivers/media/v4l-drivers/tuner-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/tuner-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/tuner-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/tuners.rst b/Documentation/drivers/media/v4l-drivers/tuners.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/tuners.rst
rename to Documentation/drivers/media/v4l-drivers/tuners.rst
diff --git a/Documentation/media/v4l-drivers/usbvision-cardlist.rst b/Documentation/drivers/media/v4l-drivers/usbvision-cardlist.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/usbvision-cardlist.rst
rename to Documentation/drivers/media/v4l-drivers/usbvision-cardlist.rst
diff --git a/Documentation/media/v4l-drivers/uvcvideo.rst b/Documentation/drivers/media/v4l-drivers/uvcvideo.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/uvcvideo.rst
rename to Documentation/drivers/media/v4l-drivers/uvcvideo.rst
diff --git a/Documentation/media/v4l-drivers/v4l-with-ir.rst b/Documentation/drivers/media/v4l-drivers/v4l-with-ir.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/v4l-with-ir.rst
rename to Documentation/drivers/media/v4l-drivers/v4l-with-ir.rst
diff --git a/Documentation/media/v4l-drivers/vimc.dot b/Documentation/drivers/media/v4l-drivers/vimc.dot
similarity index 100%
rename from Documentation/media/v4l-drivers/vimc.dot
rename to Documentation/drivers/media/v4l-drivers/vimc.dot
diff --git a/Documentation/media/v4l-drivers/vimc.rst b/Documentation/drivers/media/v4l-drivers/vimc.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/vimc.rst
rename to Documentation/drivers/media/v4l-drivers/vimc.rst
diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/drivers/media/v4l-drivers/vivid.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/vivid.rst
rename to Documentation/drivers/media/v4l-drivers/vivid.rst
diff --git a/Documentation/media/v4l-drivers/zr364xx.rst b/Documentation/drivers/media/v4l-drivers/zr364xx.rst
similarity index 100%
rename from Documentation/media/v4l-drivers/zr364xx.rst
rename to Documentation/drivers/media/v4l-drivers/zr364xx.rst
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/drivers/media/video.h.rst.exceptions
similarity index 100%
rename from Documentation/media/video.h.rst.exceptions
rename to Documentation/drivers/media/video.h.rst.exceptions
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/drivers/media/videodev2.h.rst.exceptions
similarity index 100%
rename from Documentation/media/videodev2.h.rst.exceptions
rename to Documentation/drivers/media/videodev2.h.rst.exceptions
diff --git a/Documentation/memory-devices/ti-emif.txt b/Documentation/drivers/memory/ti-emif.txt
similarity index 100%
rename from Documentation/memory-devices/ti-emif.txt
rename to Documentation/drivers/memory/ti-emif.txt
diff --git a/Documentation/misc-devices/ad525x_dpot.txt b/Documentation/drivers/misc/ad525x_dpot.txt
similarity index 100%
rename from Documentation/misc-devices/ad525x_dpot.txt
rename to Documentation/drivers/misc/ad525x_dpot.txt
diff --git a/Documentation/misc-devices/apds990x.txt b/Documentation/drivers/misc/apds990x.txt
similarity index 100%
rename from Documentation/misc-devices/apds990x.txt
rename to Documentation/drivers/misc/apds990x.txt
diff --git a/Documentation/misc-devices/bh1770glc.txt b/Documentation/drivers/misc/bh1770glc.txt
similarity index 100%
rename from Documentation/misc-devices/bh1770glc.txt
rename to Documentation/drivers/misc/bh1770glc.txt
diff --git a/Documentation/misc-devices/c2port.txt b/Documentation/drivers/misc/c2port.txt
similarity index 100%
rename from Documentation/misc-devices/c2port.txt
rename to Documentation/drivers/misc/c2port.txt
diff --git a/Documentation/misc-devices/eeprom b/Documentation/drivers/misc/eeprom
similarity index 100%
rename from Documentation/misc-devices/eeprom
rename to Documentation/drivers/misc/eeprom
diff --git a/Documentation/misc-devices/ibmvmc.rst b/Documentation/drivers/misc/ibmvmc.rst
similarity index 100%
rename from Documentation/misc-devices/ibmvmc.rst
rename to Documentation/drivers/misc/ibmvmc.rst
diff --git a/Documentation/misc-devices/ics932s401 b/Documentation/drivers/misc/ics932s401
similarity index 100%
rename from Documentation/misc-devices/ics932s401
rename to Documentation/drivers/misc/ics932s401
diff --git a/Documentation/misc-devices/index.rst b/Documentation/drivers/misc/index.rst
similarity index 100%
rename from Documentation/misc-devices/index.rst
rename to Documentation/drivers/misc/index.rst
diff --git a/Documentation/misc-devices/isl29003 b/Documentation/drivers/misc/isl29003
similarity index 100%
rename from Documentation/misc-devices/isl29003
rename to Documentation/drivers/misc/isl29003
diff --git a/Documentation/misc-devices/lis3lv02d b/Documentation/drivers/misc/lis3lv02d
similarity index 100%
rename from Documentation/misc-devices/lis3lv02d
rename to Documentation/drivers/misc/lis3lv02d
diff --git a/Documentation/misc-devices/max6875 b/Documentation/drivers/misc/max6875
similarity index 100%
rename from Documentation/misc-devices/max6875
rename to Documentation/drivers/misc/max6875
diff --git a/Documentation/misc-devices/mei/mei-client-bus.txt b/Documentation/drivers/misc/mei/mei-client-bus.txt
similarity index 100%
rename from Documentation/misc-devices/mei/mei-client-bus.txt
rename to Documentation/drivers/misc/mei/mei-client-bus.txt
diff --git a/Documentation/misc-devices/mei/mei.txt b/Documentation/drivers/misc/mei/mei.txt
similarity index 100%
rename from Documentation/misc-devices/mei/mei.txt
rename to Documentation/drivers/misc/mei/mei.txt
diff --git a/Documentation/misc-devices/pci-endpoint-test.txt b/Documentation/drivers/misc/pci-endpoint-test.txt
similarity index 100%
rename from Documentation/misc-devices/pci-endpoint-test.txt
rename to Documentation/drivers/misc/pci-endpoint-test.txt
diff --git a/Documentation/misc-devices/spear-pcie-gadget.txt b/Documentation/drivers/misc/spear-pcie-gadget.txt
similarity index 100%
rename from Documentation/misc-devices/spear-pcie-gadget.txt
rename to Documentation/drivers/misc/spear-pcie-gadget.txt
diff --git a/Documentation/mmc/mmc-async-req.txt b/Documentation/drivers/mmc/mmc-async-req.txt
similarity index 100%
rename from Documentation/mmc/mmc-async-req.txt
rename to Documentation/drivers/mmc/mmc-async-req.txt
diff --git a/Documentation/mmc/mmc-dev-attrs.txt b/Documentation/drivers/mmc/mmc-dev-attrs.txt
similarity index 100%
rename from Documentation/mmc/mmc-dev-attrs.txt
rename to Documentation/drivers/mmc/mmc-dev-attrs.txt
diff --git a/Documentation/mmc/mmc-dev-parts.txt b/Documentation/drivers/mmc/mmc-dev-parts.txt
similarity index 100%
rename from Documentation/mmc/mmc-dev-parts.txt
rename to Documentation/drivers/mmc/mmc-dev-parts.txt
diff --git a/Documentation/mmc/mmc-tools.txt b/Documentation/drivers/mmc/mmc-tools.txt
similarity index 100%
rename from Documentation/mmc/mmc-tools.txt
rename to Documentation/drivers/mmc/mmc-tools.txt
diff --git a/Documentation/mtd/intel-spi.txt b/Documentation/drivers/mtd/intel-spi.txt
similarity index 100%
rename from Documentation/mtd/intel-spi.txt
rename to Documentation/drivers/mtd/intel-spi.txt
diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/drivers/mtd/nand_ecc.txt
similarity index 100%
rename from Documentation/mtd/nand_ecc.txt
rename to Documentation/drivers/mtd/nand_ecc.txt
diff --git a/Documentation/mtd/spi-nor.txt b/Documentation/drivers/mtd/spi-nor.txt
similarity index 100%
rename from Documentation/mtd/spi-nor.txt
rename to Documentation/drivers/mtd/spi-nor.txt
diff --git a/Documentation/nfc/nfc-hci.txt b/Documentation/drivers/nfc/nfc-hci.txt
similarity index 100%
rename from Documentation/nfc/nfc-hci.txt
rename to Documentation/drivers/nfc/nfc-hci.txt
diff --git a/Documentation/nfc/nfc-pn544.txt b/Documentation/drivers/nfc/nfc-pn544.txt
similarity index 100%
rename from Documentation/nfc/nfc-pn544.txt
rename to Documentation/drivers/nfc/nfc-pn544.txt
diff --git a/Documentation/nvdimm/btt.txt b/Documentation/drivers/nvdimm/btt.txt
similarity index 100%
rename from Documentation/nvdimm/btt.txt
rename to Documentation/drivers/nvdimm/btt.txt
diff --git a/Documentation/nvdimm/nvdimm.txt b/Documentation/drivers/nvdimm/nvdimm.txt
similarity index 100%
rename from Documentation/nvdimm/nvdimm.txt
rename to Documentation/drivers/nvdimm/nvdimm.txt
diff --git a/Documentation/nvdimm/security.txt b/Documentation/drivers/nvdimm/security.txt
similarity index 100%
rename from Documentation/nvdimm/security.txt
rename to Documentation/drivers/nvdimm/security.txt
diff --git a/Documentation/nvmem/nvmem.txt b/Documentation/drivers/nvmem/nvmem.txt
similarity index 100%
rename from Documentation/nvmem/nvmem.txt
rename to Documentation/drivers/nvmem/nvmem.txt
diff --git a/Documentation/pcmcia/devicetable.rst b/Documentation/drivers/pcmcia/devicetable.rst
similarity index 100%
rename from Documentation/pcmcia/devicetable.rst
rename to Documentation/drivers/pcmcia/devicetable.rst
diff --git a/Documentation/pcmcia/driver-changes.rst b/Documentation/drivers/pcmcia/driver-changes.rst
similarity index 100%
rename from Documentation/pcmcia/driver-changes.rst
rename to Documentation/drivers/pcmcia/driver-changes.rst
diff --git a/Documentation/pcmcia/driver.rst b/Documentation/drivers/pcmcia/driver.rst
similarity index 100%
rename from Documentation/pcmcia/driver.rst
rename to Documentation/drivers/pcmcia/driver.rst
diff --git a/Documentation/pcmcia/index.rst b/Documentation/drivers/pcmcia/index.rst
similarity index 100%
rename from Documentation/pcmcia/index.rst
rename to Documentation/drivers/pcmcia/index.rst
diff --git a/Documentation/pcmcia/locking.rst b/Documentation/drivers/pcmcia/locking.rst
similarity index 100%
rename from Documentation/pcmcia/locking.rst
rename to Documentation/drivers/pcmcia/locking.rst
diff --git a/Documentation/rapidio/mport_cdev.txt b/Documentation/drivers/rapidio/mport_cdev.txt
similarity index 100%
rename from Documentation/rapidio/mport_cdev.txt
rename to Documentation/drivers/rapidio/mport_cdev.txt
diff --git a/Documentation/rapidio/rapidio.txt b/Documentation/drivers/rapidio/rapidio.txt
similarity index 100%
rename from Documentation/rapidio/rapidio.txt
rename to Documentation/drivers/rapidio/rapidio.txt
diff --git a/Documentation/rapidio/rio_cm.txt b/Documentation/drivers/rapidio/rio_cm.txt
similarity index 100%
rename from Documentation/rapidio/rio_cm.txt
rename to Documentation/drivers/rapidio/rio_cm.txt
diff --git a/Documentation/rapidio/sysfs.txt b/Documentation/drivers/rapidio/sysfs.txt
similarity index 100%
rename from Documentation/rapidio/sysfs.txt
rename to Documentation/drivers/rapidio/sysfs.txt
diff --git a/Documentation/rapidio/tsi721.txt b/Documentation/drivers/rapidio/tsi721.txt
similarity index 100%
rename from Documentation/rapidio/tsi721.txt
rename to Documentation/drivers/rapidio/tsi721.txt
diff --git a/Documentation/scsi/53c700.txt b/Documentation/drivers/scsi/53c700.txt
similarity index 100%
rename from Documentation/scsi/53c700.txt
rename to Documentation/drivers/scsi/53c700.txt
diff --git a/Documentation/scsi/BusLogic.txt b/Documentation/drivers/scsi/BusLogic.txt
similarity index 100%
rename from Documentation/scsi/BusLogic.txt
rename to Documentation/drivers/scsi/BusLogic.txt
diff --git a/Documentation/scsi/ChangeLog.arcmsr b/Documentation/drivers/scsi/ChangeLog.arcmsr
similarity index 100%
rename from Documentation/scsi/ChangeLog.arcmsr
rename to Documentation/drivers/scsi/ChangeLog.arcmsr
diff --git a/Documentation/scsi/ChangeLog.ips b/Documentation/drivers/scsi/ChangeLog.ips
similarity index 100%
rename from Documentation/scsi/ChangeLog.ips
rename to Documentation/drivers/scsi/ChangeLog.ips
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/drivers/scsi/ChangeLog.lpfc
similarity index 100%
rename from Documentation/scsi/ChangeLog.lpfc
rename to Documentation/drivers/scsi/ChangeLog.lpfc
diff --git a/Documentation/scsi/ChangeLog.megaraid b/Documentation/drivers/scsi/ChangeLog.megaraid
similarity index 100%
rename from Documentation/scsi/ChangeLog.megaraid
rename to Documentation/drivers/scsi/ChangeLog.megaraid
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/drivers/scsi/ChangeLog.megaraid_sas
similarity index 100%
rename from Documentation/scsi/ChangeLog.megaraid_sas
rename to Documentation/drivers/scsi/ChangeLog.megaraid_sas
diff --git a/Documentation/scsi/ChangeLog.ncr53c8xx b/Documentation/drivers/scsi/ChangeLog.ncr53c8xx
similarity index 100%
rename from Documentation/scsi/ChangeLog.ncr53c8xx
rename to Documentation/drivers/scsi/ChangeLog.ncr53c8xx
diff --git a/Documentation/scsi/ChangeLog.sym53c8xx b/Documentation/drivers/scsi/ChangeLog.sym53c8xx
similarity index 100%
rename from Documentation/scsi/ChangeLog.sym53c8xx
rename to Documentation/drivers/scsi/ChangeLog.sym53c8xx
diff --git a/Documentation/scsi/ChangeLog.sym53c8xx_2 b/Documentation/drivers/scsi/ChangeLog.sym53c8xx_2
similarity index 100%
rename from Documentation/scsi/ChangeLog.sym53c8xx_2
rename to Documentation/drivers/scsi/ChangeLog.sym53c8xx_2
diff --git a/Documentation/scsi/FlashPoint.txt b/Documentation/drivers/scsi/FlashPoint.txt
similarity index 100%
rename from Documentation/scsi/FlashPoint.txt
rename to Documentation/drivers/scsi/FlashPoint.txt
diff --git a/Documentation/scsi/LICENSE.FlashPoint b/Documentation/drivers/scsi/LICENSE.FlashPoint
similarity index 100%
rename from Documentation/scsi/LICENSE.FlashPoint
rename to Documentation/drivers/scsi/LICENSE.FlashPoint
diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/drivers/scsi/LICENSE.qla2xxx
similarity index 100%
rename from Documentation/scsi/LICENSE.qla2xxx
rename to Documentation/drivers/scsi/LICENSE.qla2xxx
diff --git a/Documentation/scsi/LICENSE.qla4xxx b/Documentation/drivers/scsi/LICENSE.qla4xxx
similarity index 100%
rename from Documentation/scsi/LICENSE.qla4xxx
rename to Documentation/drivers/scsi/LICENSE.qla4xxx
diff --git a/Documentation/scsi/NinjaSCSI.txt b/Documentation/drivers/scsi/NinjaSCSI.txt
similarity index 100%
rename from Documentation/scsi/NinjaSCSI.txt
rename to Documentation/drivers/scsi/NinjaSCSI.txt
diff --git a/Documentation/scsi/aacraid.txt b/Documentation/drivers/scsi/aacraid.txt
similarity index 100%
rename from Documentation/scsi/aacraid.txt
rename to Documentation/drivers/scsi/aacraid.txt
diff --git a/Documentation/scsi/advansys.txt b/Documentation/drivers/scsi/advansys.txt
similarity index 100%
rename from Documentation/scsi/advansys.txt
rename to Documentation/drivers/scsi/advansys.txt
diff --git a/Documentation/scsi/aha152x.txt b/Documentation/drivers/scsi/aha152x.txt
similarity index 100%
rename from Documentation/scsi/aha152x.txt
rename to Documentation/drivers/scsi/aha152x.txt
diff --git a/Documentation/scsi/aic79xx.txt b/Documentation/drivers/scsi/aic79xx.txt
similarity index 100%
rename from Documentation/scsi/aic79xx.txt
rename to Documentation/drivers/scsi/aic79xx.txt
diff --git a/Documentation/scsi/aic7xxx.txt b/Documentation/drivers/scsi/aic7xxx.txt
similarity index 100%
rename from Documentation/scsi/aic7xxx.txt
rename to Documentation/drivers/scsi/aic7xxx.txt
diff --git a/Documentation/scsi/arcmsr_spec.txt b/Documentation/drivers/scsi/arcmsr_spec.txt
similarity index 100%
rename from Documentation/scsi/arcmsr_spec.txt
rename to Documentation/drivers/scsi/arcmsr_spec.txt
diff --git a/Documentation/scsi/bfa.txt b/Documentation/drivers/scsi/bfa.txt
similarity index 100%
rename from Documentation/scsi/bfa.txt
rename to Documentation/drivers/scsi/bfa.txt
diff --git a/Documentation/scsi/bnx2fc.txt b/Documentation/drivers/scsi/bnx2fc.txt
similarity index 100%
rename from Documentation/scsi/bnx2fc.txt
rename to Documentation/drivers/scsi/bnx2fc.txt
diff --git a/Documentation/scsi/cxgb3i.txt b/Documentation/drivers/scsi/cxgb3i.txt
similarity index 100%
rename from Documentation/scsi/cxgb3i.txt
rename to Documentation/drivers/scsi/cxgb3i.txt
diff --git a/Documentation/scsi/dc395x.txt b/Documentation/drivers/scsi/dc395x.txt
similarity index 100%
rename from Documentation/scsi/dc395x.txt
rename to Documentation/drivers/scsi/dc395x.txt
diff --git a/Documentation/scsi/dpti.txt b/Documentation/drivers/scsi/dpti.txt
similarity index 100%
rename from Documentation/scsi/dpti.txt
rename to Documentation/drivers/scsi/dpti.txt
diff --git a/Documentation/scsi/g_NCR5380.txt b/Documentation/drivers/scsi/g_NCR5380.txt
similarity index 100%
rename from Documentation/scsi/g_NCR5380.txt
rename to Documentation/drivers/scsi/g_NCR5380.txt
diff --git a/Documentation/scsi/hpsa.txt b/Documentation/drivers/scsi/hpsa.txt
similarity index 100%
rename from Documentation/scsi/hpsa.txt
rename to Documentation/drivers/scsi/hpsa.txt
diff --git a/Documentation/scsi/hptiop.txt b/Documentation/drivers/scsi/hptiop.txt
similarity index 100%
rename from Documentation/scsi/hptiop.txt
rename to Documentation/drivers/scsi/hptiop.txt
diff --git a/Documentation/scsi/libsas.txt b/Documentation/drivers/scsi/libsas.txt
similarity index 100%
rename from Documentation/scsi/libsas.txt
rename to Documentation/drivers/scsi/libsas.txt
diff --git a/Documentation/scsi/link_power_management_policy.txt b/Documentation/drivers/scsi/link_power_management_policy.txt
similarity index 100%
rename from Documentation/scsi/link_power_management_policy.txt
rename to Documentation/drivers/scsi/link_power_management_policy.txt
diff --git a/Documentation/scsi/lpfc.txt b/Documentation/drivers/scsi/lpfc.txt
similarity index 100%
rename from Documentation/scsi/lpfc.txt
rename to Documentation/drivers/scsi/lpfc.txt
diff --git a/Documentation/scsi/megaraid.txt b/Documentation/drivers/scsi/megaraid.txt
similarity index 100%
rename from Documentation/scsi/megaraid.txt
rename to Documentation/drivers/scsi/megaraid.txt
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/drivers/scsi/ncr53c8xx.txt
similarity index 100%
rename from Documentation/scsi/ncr53c8xx.txt
rename to Documentation/drivers/scsi/ncr53c8xx.txt
diff --git a/Documentation/scsi/osst.txt b/Documentation/drivers/scsi/osst.txt
similarity index 100%
rename from Documentation/scsi/osst.txt
rename to Documentation/drivers/scsi/osst.txt
diff --git a/Documentation/scsi/ppa.txt b/Documentation/drivers/scsi/ppa.txt
similarity index 100%
rename from Documentation/scsi/ppa.txt
rename to Documentation/drivers/scsi/ppa.txt
diff --git a/Documentation/scsi/qlogicfas.txt b/Documentation/drivers/scsi/qlogicfas.txt
similarity index 100%
rename from Documentation/scsi/qlogicfas.txt
rename to Documentation/drivers/scsi/qlogicfas.txt
diff --git a/Documentation/scsi/scsi-changer.txt b/Documentation/drivers/scsi/scsi-changer.txt
similarity index 100%
rename from Documentation/scsi/scsi-changer.txt
rename to Documentation/drivers/scsi/scsi-changer.txt
diff --git a/Documentation/scsi/scsi-generic.txt b/Documentation/drivers/scsi/scsi-generic.txt
similarity index 100%
rename from Documentation/scsi/scsi-generic.txt
rename to Documentation/drivers/scsi/scsi-generic.txt
diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/drivers/scsi/scsi-parameters.txt
similarity index 100%
rename from Documentation/scsi/scsi-parameters.txt
rename to Documentation/drivers/scsi/scsi-parameters.txt
diff --git a/Documentation/scsi/scsi.txt b/Documentation/drivers/scsi/scsi.txt
similarity index 100%
rename from Documentation/scsi/scsi.txt
rename to Documentation/drivers/scsi/scsi.txt
diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/drivers/scsi/scsi_eh.txt
similarity index 100%
rename from Documentation/scsi/scsi_eh.txt
rename to Documentation/drivers/scsi/scsi_eh.txt
diff --git a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/drivers/scsi/scsi_fc_transport.txt
similarity index 100%
rename from Documentation/scsi/scsi_fc_transport.txt
rename to Documentation/drivers/scsi/scsi_fc_transport.txt
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/drivers/scsi/scsi_mid_low_api.txt
similarity index 100%
rename from Documentation/scsi/scsi_mid_low_api.txt
rename to Documentation/drivers/scsi/scsi_mid_low_api.txt
diff --git a/Documentation/scsi/scsi_transport_srp/Makefile b/Documentation/drivers/scsi/scsi_transport_srp/Makefile
similarity index 100%
rename from Documentation/scsi/scsi_transport_srp/Makefile
rename to Documentation/drivers/scsi/scsi_transport_srp/Makefile
diff --git a/Documentation/scsi/scsi_transport_srp/rport_state_diagram.dot b/Documentation/drivers/scsi/scsi_transport_srp/rport_state_diagram.dot
similarity index 100%
rename from Documentation/scsi/scsi_transport_srp/rport_state_diagram.dot
rename to Documentation/drivers/scsi/scsi_transport_srp/rport_state_diagram.dot
diff --git a/Documentation/scsi/sd-parameters.txt b/Documentation/drivers/scsi/sd-parameters.txt
similarity index 100%
rename from Documentation/scsi/sd-parameters.txt
rename to Documentation/drivers/scsi/sd-parameters.txt
diff --git a/Documentation/scsi/smartpqi.txt b/Documentation/drivers/scsi/smartpqi.txt
similarity index 100%
rename from Documentation/scsi/smartpqi.txt
rename to Documentation/drivers/scsi/smartpqi.txt
diff --git a/Documentation/scsi/st.txt b/Documentation/drivers/scsi/st.txt
similarity index 100%
rename from Documentation/scsi/st.txt
rename to Documentation/drivers/scsi/st.txt
diff --git a/Documentation/scsi/sym53c500_cs.txt b/Documentation/drivers/scsi/sym53c500_cs.txt
similarity index 100%
rename from Documentation/scsi/sym53c500_cs.txt
rename to Documentation/drivers/scsi/sym53c500_cs.txt
diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/drivers/scsi/sym53c8xx_2.txt
similarity index 100%
rename from Documentation/scsi/sym53c8xx_2.txt
rename to Documentation/drivers/scsi/sym53c8xx_2.txt
diff --git a/Documentation/scsi/tcm_qla2xxx.txt b/Documentation/drivers/scsi/tcm_qla2xxx.txt
similarity index 100%
rename from Documentation/scsi/tcm_qla2xxx.txt
rename to Documentation/drivers/scsi/tcm_qla2xxx.txt
diff --git a/Documentation/scsi/ufs.txt b/Documentation/drivers/scsi/ufs.txt
similarity index 100%
rename from Documentation/scsi/ufs.txt
rename to Documentation/drivers/scsi/ufs.txt
diff --git a/Documentation/scsi/wd719x.txt b/Documentation/drivers/scsi/wd719x.txt
similarity index 100%
rename from Documentation/scsi/wd719x.txt
rename to Documentation/drivers/scsi/wd719x.txt
diff --git a/Documentation/serial/cyclades_z.rst b/Documentation/drivers/serial/cyclades_z.rst
similarity index 100%
rename from Documentation/serial/cyclades_z.rst
rename to Documentation/drivers/serial/cyclades_z.rst
diff --git a/Documentation/serial/driver.rst b/Documentation/drivers/serial/driver.rst
similarity index 100%
rename from Documentation/serial/driver.rst
rename to Documentation/drivers/serial/driver.rst
diff --git a/Documentation/serial/index.rst b/Documentation/drivers/serial/index.rst
similarity index 100%
rename from Documentation/serial/index.rst
rename to Documentation/drivers/serial/index.rst
diff --git a/Documentation/serial/moxa-smartio.rst b/Documentation/drivers/serial/moxa-smartio.rst
similarity index 100%
rename from Documentation/serial/moxa-smartio.rst
rename to Documentation/drivers/serial/moxa-smartio.rst
diff --git a/Documentation/serial/n_gsm.rst b/Documentation/drivers/serial/n_gsm.rst
similarity index 100%
rename from Documentation/serial/n_gsm.rst
rename to Documentation/drivers/serial/n_gsm.rst
diff --git a/Documentation/serial/rocket.rst b/Documentation/drivers/serial/rocket.rst
similarity index 100%
rename from Documentation/serial/rocket.rst
rename to Documentation/drivers/serial/rocket.rst
diff --git a/Documentation/serial/serial-iso7816.rst b/Documentation/drivers/serial/serial-iso7816.rst
similarity index 100%
rename from Documentation/serial/serial-iso7816.rst
rename to Documentation/drivers/serial/serial-iso7816.rst
diff --git a/Documentation/serial/serial-rs485.rst b/Documentation/drivers/serial/serial-rs485.rst
similarity index 100%
rename from Documentation/serial/serial-rs485.rst
rename to Documentation/drivers/serial/serial-rs485.rst
diff --git a/Documentation/serial/tty.rst b/Documentation/drivers/serial/tty.rst
similarity index 100%
rename from Documentation/serial/tty.rst
rename to Documentation/drivers/serial/tty.rst
diff --git a/Documentation/sound/alsa-configuration.rst b/Documentation/drivers/sound/alsa-configuration.rst
similarity index 100%
rename from Documentation/sound/alsa-configuration.rst
rename to Documentation/drivers/sound/alsa-configuration.rst
diff --git a/Documentation/sound/cards/audigy-mixer.rst b/Documentation/drivers/sound/cards/audigy-mixer.rst
similarity index 100%
rename from Documentation/sound/cards/audigy-mixer.rst
rename to Documentation/drivers/sound/cards/audigy-mixer.rst
diff --git a/Documentation/sound/cards/audiophile-usb.rst b/Documentation/drivers/sound/cards/audiophile-usb.rst
similarity index 100%
rename from Documentation/sound/cards/audiophile-usb.rst
rename to Documentation/drivers/sound/cards/audiophile-usb.rst
diff --git a/Documentation/sound/cards/bt87x.rst b/Documentation/drivers/sound/cards/bt87x.rst
similarity index 100%
rename from Documentation/sound/cards/bt87x.rst
rename to Documentation/drivers/sound/cards/bt87x.rst
diff --git a/Documentation/sound/cards/cmipci.rst b/Documentation/drivers/sound/cards/cmipci.rst
similarity index 100%
rename from Documentation/sound/cards/cmipci.rst
rename to Documentation/drivers/sound/cards/cmipci.rst
diff --git a/Documentation/sound/cards/emu10k1-jack.rst b/Documentation/drivers/sound/cards/emu10k1-jack.rst
similarity index 100%
rename from Documentation/sound/cards/emu10k1-jack.rst
rename to Documentation/drivers/sound/cards/emu10k1-jack.rst
diff --git a/Documentation/sound/cards/hdspm.rst b/Documentation/drivers/sound/cards/hdspm.rst
similarity index 100%
rename from Documentation/sound/cards/hdspm.rst
rename to Documentation/drivers/sound/cards/hdspm.rst
diff --git a/Documentation/sound/cards/img-spdif-in.rst b/Documentation/drivers/sound/cards/img-spdif-in.rst
similarity index 100%
rename from Documentation/sound/cards/img-spdif-in.rst
rename to Documentation/drivers/sound/cards/img-spdif-in.rst
diff --git a/Documentation/sound/cards/index.rst b/Documentation/drivers/sound/cards/index.rst
similarity index 100%
rename from Documentation/sound/cards/index.rst
rename to Documentation/drivers/sound/cards/index.rst
diff --git a/Documentation/sound/cards/joystick.rst b/Documentation/drivers/sound/cards/joystick.rst
similarity index 100%
rename from Documentation/sound/cards/joystick.rst
rename to Documentation/drivers/sound/cards/joystick.rst
diff --git a/Documentation/sound/cards/maya44.rst b/Documentation/drivers/sound/cards/maya44.rst
similarity index 100%
rename from Documentation/sound/cards/maya44.rst
rename to Documentation/drivers/sound/cards/maya44.rst
diff --git a/Documentation/sound/cards/mixart.rst b/Documentation/drivers/sound/cards/mixart.rst
similarity index 100%
rename from Documentation/sound/cards/mixart.rst
rename to Documentation/drivers/sound/cards/mixart.rst
diff --git a/Documentation/sound/cards/multisound.sh b/Documentation/drivers/sound/cards/multisound.sh
similarity index 100%
rename from Documentation/sound/cards/multisound.sh
rename to Documentation/drivers/sound/cards/multisound.sh
diff --git a/Documentation/sound/cards/sb-live-mixer.rst b/Documentation/drivers/sound/cards/sb-live-mixer.rst
similarity index 100%
rename from Documentation/sound/cards/sb-live-mixer.rst
rename to Documentation/drivers/sound/cards/sb-live-mixer.rst
diff --git a/Documentation/sound/cards/serial-u16550.rst b/Documentation/drivers/sound/cards/serial-u16550.rst
similarity index 100%
rename from Documentation/sound/cards/serial-u16550.rst
rename to Documentation/drivers/sound/cards/serial-u16550.rst
diff --git a/Documentation/sound/cards/via82xx-mixer.rst b/Documentation/drivers/sound/cards/via82xx-mixer.rst
similarity index 100%
rename from Documentation/sound/cards/via82xx-mixer.rst
rename to Documentation/drivers/sound/cards/via82xx-mixer.rst
diff --git a/Documentation/sound/conf.py b/Documentation/drivers/sound/conf.py
similarity index 100%
rename from Documentation/sound/conf.py
rename to Documentation/drivers/sound/conf.py
diff --git a/Documentation/sound/designs/channel-mapping-api.rst b/Documentation/drivers/sound/designs/channel-mapping-api.rst
similarity index 100%
rename from Documentation/sound/designs/channel-mapping-api.rst
rename to Documentation/drivers/sound/designs/channel-mapping-api.rst
diff --git a/Documentation/sound/designs/compress-offload.rst b/Documentation/drivers/sound/designs/compress-offload.rst
similarity index 100%
rename from Documentation/sound/designs/compress-offload.rst
rename to Documentation/drivers/sound/designs/compress-offload.rst
diff --git a/Documentation/sound/designs/control-names.rst b/Documentation/drivers/sound/designs/control-names.rst
similarity index 100%
rename from Documentation/sound/designs/control-names.rst
rename to Documentation/drivers/sound/designs/control-names.rst
diff --git a/Documentation/sound/designs/index.rst b/Documentation/drivers/sound/designs/index.rst
similarity index 100%
rename from Documentation/sound/designs/index.rst
rename to Documentation/drivers/sound/designs/index.rst
diff --git a/Documentation/sound/designs/jack-controls.rst b/Documentation/drivers/sound/designs/jack-controls.rst
similarity index 100%
rename from Documentation/sound/designs/jack-controls.rst
rename to Documentation/drivers/sound/designs/jack-controls.rst
diff --git a/Documentation/sound/designs/oss-emulation.rst b/Documentation/drivers/sound/designs/oss-emulation.rst
similarity index 100%
rename from Documentation/sound/designs/oss-emulation.rst
rename to Documentation/drivers/sound/designs/oss-emulation.rst
diff --git a/Documentation/sound/designs/powersave.rst b/Documentation/drivers/sound/designs/powersave.rst
similarity index 100%
rename from Documentation/sound/designs/powersave.rst
rename to Documentation/drivers/sound/designs/powersave.rst
diff --git a/Documentation/sound/designs/procfile.rst b/Documentation/drivers/sound/designs/procfile.rst
similarity index 100%
rename from Documentation/sound/designs/procfile.rst
rename to Documentation/drivers/sound/designs/procfile.rst
diff --git a/Documentation/sound/designs/seq-oss.rst b/Documentation/drivers/sound/designs/seq-oss.rst
similarity index 100%
rename from Documentation/sound/designs/seq-oss.rst
rename to Documentation/drivers/sound/designs/seq-oss.rst
diff --git a/Documentation/sound/designs/timestamping.rst b/Documentation/drivers/sound/designs/timestamping.rst
similarity index 100%
rename from Documentation/sound/designs/timestamping.rst
rename to Documentation/drivers/sound/designs/timestamping.rst
diff --git a/Documentation/sound/designs/tracepoints.rst b/Documentation/drivers/sound/designs/tracepoints.rst
similarity index 100%
rename from Documentation/sound/designs/tracepoints.rst
rename to Documentation/drivers/sound/designs/tracepoints.rst
diff --git a/Documentation/sound/hd-audio/controls.rst b/Documentation/drivers/sound/hd-audio/controls.rst
similarity index 100%
rename from Documentation/sound/hd-audio/controls.rst
rename to Documentation/drivers/sound/hd-audio/controls.rst
diff --git a/Documentation/sound/hd-audio/dp-mst.rst b/Documentation/drivers/sound/hd-audio/dp-mst.rst
similarity index 100%
rename from Documentation/sound/hd-audio/dp-mst.rst
rename to Documentation/drivers/sound/hd-audio/dp-mst.rst
diff --git a/Documentation/sound/hd-audio/index.rst b/Documentation/drivers/sound/hd-audio/index.rst
similarity index 100%
rename from Documentation/sound/hd-audio/index.rst
rename to Documentation/drivers/sound/hd-audio/index.rst
diff --git a/Documentation/sound/hd-audio/models.rst b/Documentation/drivers/sound/hd-audio/models.rst
similarity index 100%
rename from Documentation/sound/hd-audio/models.rst
rename to Documentation/drivers/sound/hd-audio/models.rst
diff --git a/Documentation/sound/hd-audio/notes.rst b/Documentation/drivers/sound/hd-audio/notes.rst
similarity index 100%
rename from Documentation/sound/hd-audio/notes.rst
rename to Documentation/drivers/sound/hd-audio/notes.rst
diff --git a/Documentation/sound/index.rst b/Documentation/drivers/sound/index.rst
similarity index 100%
rename from Documentation/sound/index.rst
rename to Documentation/drivers/sound/index.rst
diff --git a/Documentation/sound/kernel-api/alsa-driver-api.rst b/Documentation/drivers/sound/kernel-api/alsa-driver-api.rst
similarity index 100%
rename from Documentation/sound/kernel-api/alsa-driver-api.rst
rename to Documentation/drivers/sound/kernel-api/alsa-driver-api.rst
diff --git a/Documentation/sound/kernel-api/index.rst b/Documentation/drivers/sound/kernel-api/index.rst
similarity index 100%
rename from Documentation/sound/kernel-api/index.rst
rename to Documentation/drivers/sound/kernel-api/index.rst
diff --git a/Documentation/sound/kernel-api/writing-an-alsa-driver.rst b/Documentation/drivers/sound/kernel-api/writing-an-alsa-driver.rst
similarity index 100%
rename from Documentation/sound/kernel-api/writing-an-alsa-driver.rst
rename to Documentation/drivers/sound/kernel-api/writing-an-alsa-driver.rst
diff --git a/Documentation/sound/soc/clocking.rst b/Documentation/drivers/sound/soc/clocking.rst
similarity index 100%
rename from Documentation/sound/soc/clocking.rst
rename to Documentation/drivers/sound/soc/clocking.rst
diff --git a/Documentation/sound/soc/codec-to-codec.rst b/Documentation/drivers/sound/soc/codec-to-codec.rst
similarity index 100%
rename from Documentation/sound/soc/codec-to-codec.rst
rename to Documentation/drivers/sound/soc/codec-to-codec.rst
diff --git a/Documentation/sound/soc/codec.rst b/Documentation/drivers/sound/soc/codec.rst
similarity index 100%
rename from Documentation/sound/soc/codec.rst
rename to Documentation/drivers/sound/soc/codec.rst
diff --git a/Documentation/sound/soc/dai.rst b/Documentation/drivers/sound/soc/dai.rst
similarity index 100%
rename from Documentation/sound/soc/dai.rst
rename to Documentation/drivers/sound/soc/dai.rst
diff --git a/Documentation/sound/soc/dapm.rst b/Documentation/drivers/sound/soc/dapm.rst
similarity index 100%
rename from Documentation/sound/soc/dapm.rst
rename to Documentation/drivers/sound/soc/dapm.rst
diff --git a/Documentation/sound/soc/dpcm.rst b/Documentation/drivers/sound/soc/dpcm.rst
similarity index 100%
rename from Documentation/sound/soc/dpcm.rst
rename to Documentation/drivers/sound/soc/dpcm.rst
diff --git a/Documentation/sound/soc/index.rst b/Documentation/drivers/sound/soc/index.rst
similarity index 100%
rename from Documentation/sound/soc/index.rst
rename to Documentation/drivers/sound/soc/index.rst
diff --git a/Documentation/sound/soc/jack.rst b/Documentation/drivers/sound/soc/jack.rst
similarity index 100%
rename from Documentation/sound/soc/jack.rst
rename to Documentation/drivers/sound/soc/jack.rst
diff --git a/Documentation/sound/soc/machine.rst b/Documentation/drivers/sound/soc/machine.rst
similarity index 100%
rename from Documentation/sound/soc/machine.rst
rename to Documentation/drivers/sound/soc/machine.rst
diff --git a/Documentation/sound/soc/overview.rst b/Documentation/drivers/sound/soc/overview.rst
similarity index 100%
rename from Documentation/sound/soc/overview.rst
rename to Documentation/drivers/sound/soc/overview.rst
diff --git a/Documentation/sound/soc/platform.rst b/Documentation/drivers/sound/soc/platform.rst
similarity index 100%
rename from Documentation/sound/soc/platform.rst
rename to Documentation/drivers/sound/soc/platform.rst
diff --git a/Documentation/sound/soc/pops-clicks.rst b/Documentation/drivers/sound/soc/pops-clicks.rst
similarity index 100%
rename from Documentation/sound/soc/pops-clicks.rst
rename to Documentation/drivers/sound/soc/pops-clicks.rst
diff --git a/Documentation/usb/CREDITS b/Documentation/drivers/usb/CREDITS
similarity index 100%
rename from Documentation/usb/CREDITS
rename to Documentation/drivers/usb/CREDITS
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/drivers/usb/WUSB-Design-overview.txt
similarity index 100%
rename from Documentation/usb/WUSB-Design-overview.txt
rename to Documentation/drivers/usb/WUSB-Design-overview.txt
diff --git a/Documentation/usb/acm.txt b/Documentation/drivers/usb/acm.txt
similarity index 100%
rename from Documentation/usb/acm.txt
rename to Documentation/drivers/usb/acm.txt
diff --git a/Documentation/usb/authorization.txt b/Documentation/drivers/usb/authorization.txt
similarity index 100%
rename from Documentation/usb/authorization.txt
rename to Documentation/drivers/usb/authorization.txt
diff --git a/Documentation/usb/chipidea.txt b/Documentation/drivers/usb/chipidea.txt
similarity index 100%
rename from Documentation/usb/chipidea.txt
rename to Documentation/drivers/usb/chipidea.txt
diff --git a/Documentation/usb/dwc3.txt b/Documentation/drivers/usb/dwc3.txt
similarity index 100%
rename from Documentation/usb/dwc3.txt
rename to Documentation/drivers/usb/dwc3.txt
diff --git a/Documentation/usb/ehci.txt b/Documentation/drivers/usb/ehci.txt
similarity index 100%
rename from Documentation/usb/ehci.txt
rename to Documentation/drivers/usb/ehci.txt
diff --git a/Documentation/usb/functionfs.txt b/Documentation/drivers/usb/functionfs.txt
similarity index 100%
rename from Documentation/usb/functionfs.txt
rename to Documentation/drivers/usb/functionfs.txt
diff --git a/Documentation/usb/gadget-testing.txt b/Documentation/drivers/usb/gadget-testing.txt
similarity index 100%
rename from Documentation/usb/gadget-testing.txt
rename to Documentation/drivers/usb/gadget-testing.txt
diff --git a/Documentation/usb/gadget_configfs.txt b/Documentation/drivers/usb/gadget_configfs.txt
similarity index 100%
rename from Documentation/usb/gadget_configfs.txt
rename to Documentation/drivers/usb/gadget_configfs.txt
diff --git a/Documentation/usb/gadget_hid.txt b/Documentation/drivers/usb/gadget_hid.txt
similarity index 100%
rename from Documentation/usb/gadget_hid.txt
rename to Documentation/drivers/usb/gadget_hid.txt
diff --git a/Documentation/usb/gadget_multi.txt b/Documentation/drivers/usb/gadget_multi.txt
similarity index 100%
rename from Documentation/usb/gadget_multi.txt
rename to Documentation/drivers/usb/gadget_multi.txt
diff --git a/Documentation/usb/gadget_printer.txt b/Documentation/drivers/usb/gadget_printer.txt
similarity index 100%
rename from Documentation/usb/gadget_printer.txt
rename to Documentation/drivers/usb/gadget_printer.txt
diff --git a/Documentation/usb/gadget_serial.txt b/Documentation/drivers/usb/gadget_serial.txt
similarity index 100%
rename from Documentation/usb/gadget_serial.txt
rename to Documentation/drivers/usb/gadget_serial.txt
diff --git a/Documentation/usb/iuu_phoenix.txt b/Documentation/drivers/usb/iuu_phoenix.txt
similarity index 100%
rename from Documentation/usb/iuu_phoenix.txt
rename to Documentation/drivers/usb/iuu_phoenix.txt
diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/drivers/usb/linux-cdc-acm.inf
similarity index 100%
rename from Documentation/usb/linux-cdc-acm.inf
rename to Documentation/drivers/usb/linux-cdc-acm.inf
diff --git a/Documentation/usb/linux.inf b/Documentation/drivers/usb/linux.inf
similarity index 100%
rename from Documentation/usb/linux.inf
rename to Documentation/drivers/usb/linux.inf
diff --git a/Documentation/usb/mass-storage.txt b/Documentation/drivers/usb/mass-storage.txt
similarity index 100%
rename from Documentation/usb/mass-storage.txt
rename to Documentation/drivers/usb/mass-storage.txt
diff --git a/Documentation/usb/misc_usbsevseg.txt b/Documentation/drivers/usb/misc_usbsevseg.txt
similarity index 100%
rename from Documentation/usb/misc_usbsevseg.txt
rename to Documentation/drivers/usb/misc_usbsevseg.txt
diff --git a/Documentation/usb/mtouchusb.txt b/Documentation/drivers/usb/mtouchusb.txt
similarity index 100%
rename from Documentation/usb/mtouchusb.txt
rename to Documentation/drivers/usb/mtouchusb.txt
diff --git a/Documentation/usb/ohci.txt b/Documentation/drivers/usb/ohci.txt
similarity index 100%
rename from Documentation/usb/ohci.txt
rename to Documentation/drivers/usb/ohci.txt
diff --git a/Documentation/usb/rio.txt b/Documentation/drivers/usb/rio.txt
similarity index 100%
rename from Documentation/usb/rio.txt
rename to Documentation/drivers/usb/rio.txt
diff --git a/Documentation/usb/usb-help.txt b/Documentation/drivers/usb/usb-help.txt
similarity index 100%
rename from Documentation/usb/usb-help.txt
rename to Documentation/drivers/usb/usb-help.txt
diff --git a/Documentation/usb/usb-serial.txt b/Documentation/drivers/usb/usb-serial.txt
similarity index 100%
rename from Documentation/usb/usb-serial.txt
rename to Documentation/drivers/usb/usb-serial.txt
diff --git a/Documentation/usb/usbdevfs-drop-permissions.c b/Documentation/drivers/usb/usbdevfs-drop-permissions.c
similarity index 100%
rename from Documentation/usb/usbdevfs-drop-permissions.c
rename to Documentation/drivers/usb/usbdevfs-drop-permissions.c
diff --git a/Documentation/usb/usbip_protocol.txt b/Documentation/drivers/usb/usbip_protocol.txt
similarity index 100%
rename from Documentation/usb/usbip_protocol.txt
rename to Documentation/drivers/usb/usbip_protocol.txt
diff --git a/Documentation/usb/usbmon.txt b/Documentation/drivers/usb/usbmon.txt
similarity index 100%
rename from Documentation/usb/usbmon.txt
rename to Documentation/drivers/usb/usbmon.txt
diff --git a/Documentation/usb/wusb-cbaf b/Documentation/drivers/usb/wusb-cbaf
similarity index 100%
rename from Documentation/usb/wusb-cbaf
rename to Documentation/drivers/usb/wusb-cbaf
diff --git a/Documentation/watchdog/convert_drivers_to_kernel_api.rst b/Documentation/drivers/watchdog/convert_drivers_to_kernel_api.rst
similarity index 100%
rename from Documentation/watchdog/convert_drivers_to_kernel_api.rst
rename to Documentation/drivers/watchdog/convert_drivers_to_kernel_api.rst
diff --git a/Documentation/watchdog/hpwdt.rst b/Documentation/drivers/watchdog/hpwdt.rst
similarity index 100%
rename from Documentation/watchdog/hpwdt.rst
rename to Documentation/drivers/watchdog/hpwdt.rst
diff --git a/Documentation/watchdog/index.rst b/Documentation/drivers/watchdog/index.rst
similarity index 100%
rename from Documentation/watchdog/index.rst
rename to Documentation/drivers/watchdog/index.rst
diff --git a/Documentation/watchdog/mlx-wdt.rst b/Documentation/drivers/watchdog/mlx-wdt.rst
similarity index 100%
rename from Documentation/watchdog/mlx-wdt.rst
rename to Documentation/drivers/watchdog/mlx-wdt.rst
diff --git a/Documentation/watchdog/pcwd-watchdog.rst b/Documentation/drivers/watchdog/pcwd-watchdog.rst
similarity index 100%
rename from Documentation/watchdog/pcwd-watchdog.rst
rename to Documentation/drivers/watchdog/pcwd-watchdog.rst
diff --git a/Documentation/watchdog/watchdog-api.rst b/Documentation/drivers/watchdog/watchdog-api.rst
similarity index 100%
rename from Documentation/watchdog/watchdog-api.rst
rename to Documentation/drivers/watchdog/watchdog-api.rst
diff --git a/Documentation/watchdog/watchdog-kernel-api.rst b/Documentation/drivers/watchdog/watchdog-kernel-api.rst
similarity index 100%
rename from Documentation/watchdog/watchdog-kernel-api.rst
rename to Documentation/drivers/watchdog/watchdog-kernel-api.rst
diff --git a/Documentation/watchdog/watchdog-parameters.rst b/Documentation/drivers/watchdog/watchdog-parameters.rst
similarity index 100%
rename from Documentation/watchdog/watchdog-parameters.rst
rename to Documentation/drivers/watchdog/watchdog-parameters.rst
diff --git a/Documentation/watchdog/watchdog-pm.rst b/Documentation/drivers/watchdog/watchdog-pm.rst
similarity index 100%
rename from Documentation/watchdog/watchdog-pm.rst
rename to Documentation/drivers/watchdog/watchdog-pm.rst
diff --git a/Documentation/watchdog/wdt.rst b/Documentation/drivers/watchdog/wdt.rst
similarity index 100%
rename from Documentation/watchdog/wdt.rst
rename to Documentation/drivers/watchdog/wdt.rst
-- 
2.19.1.856.g8858448bb

