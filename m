Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1342876657
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfGZMvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:51:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfGZMvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fu356YrPMzndyFm+mjI4xYuszQip5jZIznwBf4V2bFA=; b=NIqaM7XSYnaOI+0JbvLfelNId
        e2SufG8jn+l1k8PHNZRSqf+J6epByjUKQ3giDW+BBx4ytRSOUxmffLivk4zYUJGkMTAYnOTqlGRlC
        puhDyzf+64CPiBXxI5yAuAV3g50sIkqXucPnjqBFqAHvXysltOeN1E7TyGdFHUrrNAhlt/SNVEqiy
        I1wgL/7+Bb4V1Be+jArftX4o4VWJuf9uflSNpXUbiLZNSZvXkFrlaVS4IwQN/Xu1VvIW62PjkSbYy
        AXOkbE589ZoOEQXbOT9oYM67TzhFvlhEsP7P2u7YycEY3rqamPmxXZauyS5P0cv/tu2nwL4sgLUQo
        V4nHpkdkA==;
Received: from [179.95.31.157] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqzhE-0006Aq-MV; Fri, 26 Jul 2019 12:51:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hqzhB-0005a5-Sq; Fri, 26 Jul 2019 09:51:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-rtc@vger.kernel.org,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        openrisc@lists.librecores.org, devel@driverdev.osuosl.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        devel@lists.orangefs.org, dmaengine@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org,
        linux-wireless@vger.kernel.org, rcu@vger.kernel.org
Subject: [PATCH v2 00/26] ReST conversion of text files without .txt extension
Date:   Fri, 26 Jul 2019 09:51:10 -0300
Message-Id: <cover.1564145354.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the text files under Documentation with doesn't end
neither .txt or .rst and are not part of ABI or features.

This series is at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=rst_for_5_4_v3

And it is based on yesterday's upstream tree.

After this series, we have ~320 files left to be converted to ReST.

v2:
  - Added 3 files submitted for v5.3 that weren't merged yet;
  - markdown patch broken into two, per Rob's request;
  - rebased on the top of upstream master branch

Mauro Carvalho Chehab (26):
  docs: power: add it to to the main documentation index
  docs: thermal: add it to the driver API
  docs: powerpc: convert docs to ReST and rename to *.rst
  docs: ubifs-authentication.md: convert to ReST
  docs: writing-schema.md: convert from markdown to ReST
  docs: i2c: convert to ReST and add to driver-api bookset
  docs: w1: convert to ReST and add to the kAPI group of docs
  spi: docs: convert to ReST and add it to the kABI bookset
  docs: ipmb: place it at driver-api and convert to ReST
  docs: packing: move it to core-api book and adjust markups
  docs: admin-guide: add auxdisplay files to it after conversion to ReST
  docs: README.buddha: convert to ReST and add to m68k book
  docs: parisc: convert to ReST and add to documentation body
  docs: openrisc: convert to ReST and add to documentation body
  docs: isdn: convert to ReST and add to kAPI bookset
  docs: fs: cifs: convert to ReST and add to admin-guide book
  docs: fs: convert docs without extension to ReST
  docs: fs: convert porting to ReST
  docs: index.rst: don't use genindex for pdf output
  docs: wimax: convert to ReST and add to admin-guide
  docs: mips: add to the documentation body as ReST
  docs: hwmon: pxe1610: convert to ReST format and add to the index
  docs: nios2: add it to the main Documentation body
  docs: net: convert two README files to ReST format
  docs: rcu: convert some articles from html to ReST
  docs: ABI: remove extension from sysfs-class-mic.txt

 Documentation/ABI/stable/sysfs-bus-w1         |    2 +-
 .../ABI/stable/sysfs-driver-w1_ds28e04        |    4 +-
 .../ABI/stable/sysfs-driver-w1_ds28ea00       |    2 +-
 .../{sysfs-class-mic.txt => sysfs-class-mic}  |    0
 Documentation/PCI/pci-error-recovery.rst      |    2 +-
 .../Data-Structures/Data-Structures.html      | 1391 -------
 .../Data-Structures/Data-Structures.rst       | 1163 ++++++
 ...riods.html => Expedited-Grace-Periods.rst} |  949 ++---
 .../Memory-Ordering/Tree-RCU-Diagram.html     |    9 -
 ...ring.html => Tree-RCU-Memory-Ordering.rst} | 1181 +++---
 .../RCU/Design/Requirements/Requirements.html | 3330 -----------------
 .../RCU/Design/Requirements/Requirements.rst  | 2662 +++++++++++++
 Documentation/RCU/index.rst                   |    5 +
 Documentation/RCU/whatisRCU.txt               |    4 +-
 .../auxdisplay/cfag12864b.rst}                |  115 +-
 .../admin-guide/auxdisplay/index.rst          |   16 +
 .../auxdisplay/ks0108.rst}                    |   53 +-
 .../AUTHORS => admin-guide/cifs/authors.rst}  |   64 +-
 .../CHANGES => admin-guide/cifs/changes.rst}  |    4 +
 Documentation/admin-guide/cifs/index.rst      |   21 +
 .../cifs/introduction.rst}                    |    8 +
 .../cifs/TODO => admin-guide/cifs/todo.rst}   |   87 +-
 .../README => admin-guide/cifs/usage.rst}     |  560 +--
 .../cifs/winucase_convert.pl                  |    0
 Documentation/admin-guide/index.rst           |    3 +
 .../wimax/i2400m.rst}                         |  145 +-
 Documentation/admin-guide/wimax/index.rst     |   19 +
 .../wimax/wimax.rst}                          |   36 +-
 Documentation/core-api/index.rst              |    3 +-
 .../{packing.txt => core-api/packing.rst}     |   81 +-
 .../devicetree/bindings/i2c/i2c-mux-gpmux.txt |    2 +-
 .../{writing-schema.md => writing-schema.rst} |  137 +-
 Documentation/driver-api/dmaengine/index.rst  |    2 +-
 Documentation/driver-api/index.rst            |    2 +
 Documentation/driver-api/ipmb.rst             |    2 +-
 Documentation/driver-api/soundwire/index.rst  |    2 +-
 .../thermal/cpu-cooling-api.rst               |    0
 .../thermal/exynos_thermal.rst                |    0
 .../thermal/exynos_thermal_emulation.rst      |    0
 .../{ => driver-api}/thermal/index.rst        |    2 +-
 .../thermal/intel_powerclamp.rst              |    0
 .../thermal/nouveau_thermal.rst               |    0
 .../thermal/power_allocator.rst               |    0
 .../{ => driver-api}/thermal/sysfs-api.rst    |   12 +-
 .../thermal/x86_pkg_temperature_thermal.rst   |    2 +-
 ...irectory-locking => directory-locking.rst} |   40 +-
 Documentation/filesystems/index.rst           |    4 +
 .../filesystems/{Locking => locking.rst}      |  257 +-
 .../nfs/{Exporting => exporting.rst}          |   31 +-
 .../filesystems/{porting => porting.rst}      |  824 ++--
 ...entication.md => ubifs-authentication.rst} |   70 +-
 Documentation/filesystems/vfs.rst             |    2 +-
 Documentation/hwmon/adm1021.rst               |    2 +-
 Documentation/hwmon/adm1275.rst               |    2 +-
 Documentation/hwmon/hih6130.rst               |    2 +-
 Documentation/hwmon/ibm-cffps.rst             |    2 +-
 Documentation/hwmon/index.rst                 |    1 +
 Documentation/hwmon/lm25066.rst               |    2 +-
 Documentation/hwmon/max16064.rst              |    2 +-
 Documentation/hwmon/max16065.rst              |    2 +-
 Documentation/hwmon/max20751.rst              |    2 +-
 Documentation/hwmon/max34440.rst              |    2 +-
 Documentation/hwmon/max6650.rst               |    2 +-
 Documentation/hwmon/max8688.rst               |    2 +-
 Documentation/hwmon/menf21bmc.rst             |    2 +-
 Documentation/hwmon/pcf8591.rst               |    2 +-
 Documentation/hwmon/{pxe1610 => pxe1610.rst}  |   33 +-
 Documentation/hwmon/sht3x.rst                 |    2 +-
 Documentation/hwmon/shtc1.rst                 |    2 +-
 Documentation/hwmon/tmp103.rst                |    2 +-
 Documentation/hwmon/tps40422.rst              |    2 +-
 Documentation/hwmon/ucd9000.rst               |    2 +-
 Documentation/hwmon/ucd9200.rst               |    2 +-
 Documentation/hwmon/via686a.rst               |    2 +-
 Documentation/hwmon/zl6100.rst                |    2 +-
 .../busses/{i2c-ali1535 => i2c-ali1535.rst}   |   13 +-
 .../busses/{i2c-ali1563 => i2c-ali1563.rst}   |    3 +
 .../busses/{i2c-ali15x3 => i2c-ali15x3.rst}   |   64 +-
 .../busses/{i2c-amd-mp2 => i2c-amd-mp2.rst}   |   14 +-
 .../i2c/busses/{i2c-amd756 => i2c-amd756.rst} |    8 +-
 .../busses/{i2c-amd8111 => i2c-amd8111.rst}   |   14 +-
 .../{i2c-diolan-u2c => i2c-diolan-u2c.rst}    |    3 +
 .../i2c/busses/{i2c-i801 => i2c-i801.rst}     |   33 +-
 .../i2c/busses/{i2c-ismt => i2c-ismt.rst}     |   20 +-
 .../busses/{i2c-mlxcpld => i2c-mlxcpld.rst}   |    6 +
 .../busses/{i2c-nforce2 => i2c-nforce2.rst}   |   33 +-
 .../{i2c-nvidia-gpu => i2c-nvidia-gpu.rst}    |    6 +-
 .../i2c/busses/{i2c-ocores => i2c-ocores.rst} |   22 +-
 ...2c-parport-light => i2c-parport-light.rst} |    8 +-
 .../busses/{i2c-parport => i2c-parport.rst}   |  164 +-
 .../busses/{i2c-pca-isa => i2c-pca-isa.rst}   |    9 +-
 .../i2c/busses/{i2c-piix4 => i2c-piix4.rst}   |   18 +-
 .../busses/{i2c-sis5595 => i2c-sis5595.rst}   |   19 +-
 .../i2c/busses/{i2c-sis630 => i2c-sis630.rst} |   39 +-
 .../i2c/busses/{i2c-sis96x => i2c-sis96x.rst} |   31 +-
 .../busses/{i2c-taos-evm => i2c-taos-evm.rst} |    8 +-
 .../i2c/busses/{i2c-via => i2c-via.rst}       |   28 +-
 .../i2c/busses/{i2c-viapro => i2c-viapro.rst} |   12 +-
 Documentation/i2c/busses/index.rst            |   33 +
 .../i2c/busses/{scx200_acb => scx200_acb.rst} |    9 +-
 .../i2c/{dev-interface => dev-interface.rst}  |   94 +-
 ...-considerations => dma-considerations.rst} |    0
 .../i2c/{fault-codes => fault-codes.rst}      |    5 +-
 .../i2c/{functionality => functionality.rst}  |   22 +-
 ...ult-injection => gpio-fault-injection.rst} |   12 +-
 .../i2c/{i2c-protocol => i2c-protocol.rst}    |   28 +-
 Documentation/i2c/{i2c-stub => i2c-stub.rst}  |   20 +-
 .../i2c/{i2c-topology => i2c-topology.rst}    |   68 +-
 Documentation/i2c/index.rst                   |   37 +
 ...ting-devices => instantiating-devices.rst} |   45 +-
 .../muxes/{i2c-mux-gpio => i2c-mux-gpio.rst}  |   26 +-
 ...e-parameters => old-module-parameters.rst} |   27 +-
 ...eprom-backend => slave-eeprom-backend.rst} |    4 +-
 .../{slave-interface => slave-interface.rst}  |   33 +-
 .../{smbus-protocol => smbus-protocol.rst}    |   86 +-
 Documentation/i2c/{summary => summary.rst}    |    6 +-
 ...en-bit-addresses => ten-bit-addresses.rst} |    5 +
 ...pgrading-clients => upgrading-clients.rst} |  204 +-
 .../{writing-clients => writing-clients.rst}  |   94 +-
 Documentation/index.rst                       |   10 +
 .../isdn/{README.avmb1 => avmb1.rst}          |  231 +-
 Documentation/isdn/{CREDITS => credits.rst}   |    7 +-
 .../isdn/{README.gigaset => gigaset.rst}      |  290 +-
 .../isdn/{README.hysdn => hysdn.rst}          |  125 +-
 Documentation/isdn/index.rst                  |   24 +
 .../{INTERFACE.CAPI => interface_capi.rst}    |  182 +-
 .../isdn/{README.mISDN => m_isdn.rst}         |    5 +-
 .../m68k/{README.buddha => buddha-driver.rst} |   95 +-
 Documentation/m68k/index.rst                  |    1 +
 .../{AU1xxx_IDE.README => au1xxx_ide.rst}     |   89 +-
 Documentation/mips/index.rst                  |   17 +
 .../networking/caif/{README => caif.rst}      |   88 +-
 .../networking/device_drivers/index.rst       |    2 +-
 Documentation/networking/index.rst            |    2 +-
 .../{README => mac80211_hwsim.rst}            |   28 +-
 Documentation/nios2/{README => nios2.rst}     |    1 +
 Documentation/openrisc/index.rst              |   18 +
 .../openrisc/{README => openrisc_port.rst}    |   25 +-
 Documentation/openrisc/{TODO => todo.rst}     |    9 +-
 .../parisc/{debugging => debugging.rst}       |    7 +
 Documentation/parisc/index.rst                |   18 +
 .../parisc/{registers => registers.rst}       |   59 +-
 Documentation/power/index.rst                 |    2 +-
 .../{bootwrapper.txt => bootwrapper.rst}      |   28 +-
 .../{cpu_families.txt => cpu_families.rst}    |   23 +-
 .../{cpu_features.txt => cpu_features.rst}    |    6 +-
 Documentation/powerpc/{cxl.txt => cxl.rst}    |   46 +-
 .../powerpc/{cxlflash.txt => cxlflash.rst}    |   10 +-
 .../{DAWR-POWER9.txt => dawr-power9.rst}      |   15 +-
 Documentation/powerpc/{dscr.txt => dscr.rst}  |   18 +-
 ...ecovery.txt => eeh-pci-error-recovery.rst} |  108 +-
 ...ed-dump.txt => firmware-assisted-dump.rst} |  117 +-
 Documentation/powerpc/{hvcs.txt => hvcs.rst}  |  108 +-
 Documentation/powerpc/index.rst               |   34 +
 Documentation/powerpc/isa-versions.rst        |   15 +-
 .../powerpc/{mpc52xx.txt => mpc52xx.rst}      |   12 +-
 ...nv.txt => pci_iov_resource_on_powernv.rst} |   15 +-
 .../powerpc/{pmu-ebb.txt => pmu-ebb.rst}      |    1 +
 .../powerpc/{ptrace.txt => ptrace.rst}        |  169 +-
 .../{qe_firmware.txt => qe_firmware.rst}      |   37 +-
 .../{syscall64-abi.txt => syscall64-abi.rst}  |   29 +-
 ...al_memory.txt => transactional_memory.rst} |   45 +-
 Documentation/sound/index.rst                 |    2 +-
 .../spi/{butterfly => butterfly.rst}          |   44 +-
 Documentation/spi/index.rst                   |   22 +
 Documentation/spi/{pxa2xx => pxa2xx.rst}      |   95 +-
 .../spi/{spi-lm70llp => spi-lm70llp.rst}      |   17 +-
 .../spi/{spi-sc18is602 => spi-sc18is602.rst}  |    5 +-
 .../spi/{spi-summary => spi-summary.rst}      |  105 +-
 Documentation/spi/{spidev => spidev.rst}      |   30 +-
 Documentation/w1/index.rst                    |   21 +
 .../w1/masters/{ds2482 => ds2482.rst}         |   16 +-
 .../w1/masters/{ds2490 => ds2490.rst}         |    6 +-
 Documentation/w1/masters/index.rst            |   14 +
 .../w1/masters/{mxc-w1 => mxc-w1.rst}         |   13 +-
 .../w1/masters/{omap-hdq => omap-hdq.rst}     |   12 +-
 .../w1/masters/{w1-gpio => w1-gpio.rst}       |   21 +-
 Documentation/w1/slaves/index.rst             |   16 +
 .../w1/slaves/{w1_ds2406 => w1_ds2406.rst}    |    4 +-
 .../w1/slaves/{w1_ds2413 => w1_ds2413.rst}    |    9 +
 .../w1/slaves/{w1_ds2423 => w1_ds2423.rst}    |   27 +-
 .../w1/slaves/{w1_ds2438 => w1_ds2438.rst}    |   10 +-
 .../w1/slaves/{w1_ds28e04 => w1_ds28e04.rst}  |    5 +
 .../w1/slaves/{w1_ds28e17 => w1_ds28e17.rst}  |   16 +-
 .../w1/slaves/{w1_therm => w1_therm.rst}      |   11 +-
 .../w1/{w1.generic => w1-generic.rst}         |   88 +-
 .../w1/{w1.netlink => w1-netlink.rst}         |   89 +-
 MAINTAINERS                                   |   68 +-
 arch/powerpc/kernel/exceptions-64s.S          |    2 +-
 drivers/auxdisplay/Kconfig                    |    2 +-
 drivers/hwmon/atxp1.c                         |    2 +-
 drivers/hwmon/smm665.c                        |    2 +-
 drivers/i2c/Kconfig                           |    4 +-
 drivers/i2c/busses/Kconfig                    |    2 +-
 drivers/i2c/busses/i2c-i801.c                 |    2 +-
 drivers/i2c/busses/i2c-taos-evm.c             |    2 +-
 drivers/i2c/i2c-core-base.c                   |    4 +-
 drivers/iio/dummy/iio_simple_dummy.c          |    4 +-
 drivers/rtc/rtc-ds1374.c                      |    2 +-
 drivers/soc/fsl/qe/qe.c                       |    2 +-
 drivers/spi/Kconfig                           |    2 +-
 drivers/spi/spi-butterfly.c                   |    2 +-
 drivers/spi/spi-lm70llp.c                     |    2 +-
 drivers/staging/isdn/hysdn/Kconfig            |    2 +-
 drivers/tty/hvc/hvcs.c                        |    2 +-
 fs/cifs/export.c                              |    2 +-
 fs/exportfs/expfs.c                           |    2 +-
 fs/isofs/export.c                             |    2 +-
 fs/orangefs/file.c                            |    2 +-
 fs/orangefs/orangefs-kernel.h                 |    2 +-
 include/linux/dcache.h                        |    2 +-
 include/linux/exportfs.h                      |    2 +-
 include/linux/i2c.h                           |    2 +-
 include/linux/platform_data/sc18is602.h       |    2 +-
 include/linux/thermal.h                       |    4 +-
 include/soc/fsl/qe/qe.h                       |    2 +-
 216 files changed, 9148 insertions(+), 8672 deletions(-)
 rename Documentation/ABI/testing/{sysfs-class-mic.txt => sysfs-class-mic} (100%)
 delete mode 100644 Documentation/RCU/Design/Data-Structures/Data-Structures.html
 create mode 100644 Documentation/RCU/Design/Data-Structures/Data-Structures.rst
 rename Documentation/RCU/Design/Expedited-Grace-Periods/{Expedited-Grace-Periods.html => Expedited-Grace-Periods.rst} (15%)
 delete mode 100644 Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Diagram.html
 rename Documentation/RCU/Design/Memory-Ordering/{Tree-RCU-Memory-Ordering.html => Tree-RCU-Memory-Ordering.rst} (10%)
 delete mode 100644 Documentation/RCU/Design/Requirements/Requirements.html
 create mode 100644 Documentation/RCU/Design/Requirements/Requirements.rst
 rename Documentation/{auxdisplay/cfag12864b => admin-guide/auxdisplay/cfag12864b.rst} (26%)
 create mode 100644 Documentation/admin-guide/auxdisplay/index.rst
 rename Documentation/{auxdisplay/ks0108 => admin-guide/auxdisplay/ks0108.rst} (32%)
 rename Documentation/{filesystems/cifs/AUTHORS => admin-guide/cifs/authors.rst} (60%)
 rename Documentation/{filesystems/cifs/CHANGES => admin-guide/cifs/changes.rst} (91%)
 create mode 100644 Documentation/admin-guide/cifs/index.rst
 rename Documentation/{filesystems/cifs/cifs.txt => admin-guide/cifs/introduction.rst} (98%)
 rename Documentation/{filesystems/cifs/TODO => admin-guide/cifs/todo.rst} (58%)
 rename Documentation/{filesystems/cifs/README => admin-guide/cifs/usage.rst} (72%)
 rename Documentation/{filesystems => admin-guide}/cifs/winucase_convert.pl (100%)
 rename Documentation/{wimax/README.i2400m => admin-guide/wimax/i2400m.rst} (69%)
 create mode 100644 Documentation/admin-guide/wimax/index.rst
 rename Documentation/{wimax/README.wimax => admin-guide/wimax/wimax.rst} (74%)
 rename Documentation/{packing.txt => core-api/packing.rst} (61%)
 rename Documentation/devicetree/{writing-schema.md => writing-schema.rst} (48%)
 rename Documentation/{ => driver-api}/thermal/cpu-cooling-api.rst (100%)
 rename Documentation/{ => driver-api}/thermal/exynos_thermal.rst (100%)
 rename Documentation/{ => driver-api}/thermal/exynos_thermal_emulation.rst (100%)
 rename Documentation/{ => driver-api}/thermal/index.rst (86%)
 rename Documentation/{ => driver-api}/thermal/intel_powerclamp.rst (100%)
 rename Documentation/{ => driver-api}/thermal/nouveau_thermal.rst (100%)
 rename Documentation/{ => driver-api}/thermal/power_allocator.rst (100%)
 rename Documentation/{ => driver-api}/thermal/sysfs-api.rst (98%)
 rename Documentation/{ => driver-api}/thermal/x86_pkg_temperature_thermal.rst (94%)
 rename Documentation/filesystems/{directory-locking => directory-locking.rst} (86%)
 rename Documentation/filesystems/{Locking => locking.rst} (79%)
 rename Documentation/filesystems/nfs/{Exporting => exporting.rst} (91%)
 rename Documentation/filesystems/{porting => porting.rst} (49%)
 rename Documentation/filesystems/{ubifs-authentication.md => ubifs-authentication.rst} (95%)
 rename Documentation/hwmon/{pxe1610 => pxe1610.rst} (82%)
 rename Documentation/i2c/busses/{i2c-ali1535 => i2c-ali1535.rst} (82%)
 rename Documentation/i2c/busses/{i2c-ali1563 => i2c-ali1563.rst} (93%)
 rename Documentation/i2c/busses/{i2c-ali15x3 => i2c-ali15x3.rst} (72%)
 rename Documentation/i2c/busses/{i2c-amd-mp2 => i2c-amd-mp2.rst} (42%)
 rename Documentation/i2c/busses/{i2c-amd756 => i2c-amd756.rst} (79%)
 rename Documentation/i2c/busses/{i2c-amd8111 => i2c-amd8111.rst} (66%)
 rename Documentation/i2c/busses/{i2c-diolan-u2c => i2c-diolan-u2c.rst} (91%)
 rename Documentation/i2c/busses/{i2c-i801 => i2c-i801.rst} (89%)
 rename Documentation/i2c/busses/{i2c-ismt => i2c-ismt.rst} (81%)
 rename Documentation/i2c/busses/{i2c-mlxcpld => i2c-mlxcpld.rst} (88%)
 rename Documentation/i2c/busses/{i2c-nforce2 => i2c-nforce2.rst} (58%)
 rename Documentation/i2c/busses/{i2c-nvidia-gpu => i2c-nvidia-gpu.rst} (63%)
 rename Documentation/i2c/busses/{i2c-ocores => i2c-ocores.rst} (82%)
 rename Documentation/i2c/busses/{i2c-parport-light => i2c-parport-light.rst} (91%)
 rename Documentation/i2c/busses/{i2c-parport => i2c-parport.rst} (49%)
 rename Documentation/i2c/busses/{i2c-pca-isa => i2c-pca-isa.rst} (72%)
 rename Documentation/i2c/busses/{i2c-piix4 => i2c-piix4.rst} (92%)
 rename Documentation/i2c/busses/{i2c-sis5595 => i2c-sis5595.rst} (74%)
 rename Documentation/i2c/busses/{i2c-sis630 => i2c-sis630.rst} (37%)
 rename Documentation/i2c/busses/{i2c-sis96x => i2c-sis96x.rst} (74%)
 rename Documentation/i2c/busses/{i2c-taos-evm => i2c-taos-evm.rst} (91%)
 rename Documentation/i2c/busses/{i2c-via => i2c-via.rst} (54%)
 rename Documentation/i2c/busses/{i2c-viapro => i2c-viapro.rst} (87%)
 create mode 100644 Documentation/i2c/busses/index.rst
 rename Documentation/i2c/busses/{scx200_acb => scx200_acb.rst} (86%)
 rename Documentation/i2c/{dev-interface => dev-interface.rst} (71%)
 rename Documentation/i2c/{DMA-considerations => dma-considerations.rst} (100%)
 rename Documentation/i2c/{fault-codes => fault-codes.rst} (98%)
 rename Documentation/i2c/{functionality => functionality.rst} (91%)
 rename Documentation/i2c/{gpio-fault-injection => gpio-fault-injection.rst} (97%)
 rename Documentation/i2c/{i2c-protocol => i2c-protocol.rst} (83%)
 rename Documentation/i2c/{i2c-stub => i2c-stub.rst} (93%)
 rename Documentation/i2c/{i2c-topology => i2c-topology.rst} (89%)
 create mode 100644 Documentation/i2c/index.rst
 rename Documentation/i2c/{instantiating-devices => instantiating-devices.rst} (93%)
 rename Documentation/i2c/muxes/{i2c-mux-gpio => i2c-mux-gpio.rst} (85%)
 rename Documentation/i2c/{old-module-parameters => old-module-parameters.rst} (75%)
 rename Documentation/i2c/{slave-eeprom-backend => slave-eeprom-backend.rst} (90%)
 rename Documentation/i2c/{slave-interface => slave-interface.rst} (94%)
 rename Documentation/i2c/{smbus-protocol => smbus-protocol.rst} (82%)
 rename Documentation/i2c/{summary => summary.rst} (96%)
 rename Documentation/i2c/{ten-bit-addresses => ten-bit-addresses.rst} (95%)
 rename Documentation/i2c/{upgrading-clients => upgrading-clients.rst} (54%)
 rename Documentation/i2c/{writing-clients => writing-clients.rst} (91%)
 rename Documentation/isdn/{README.avmb1 => avmb1.rst} (50%)
 rename Documentation/isdn/{CREDITS => credits.rst} (96%)
 rename Documentation/isdn/{README.gigaset => gigaset.rst} (74%)
 rename Documentation/isdn/{README.hysdn => hysdn.rst} (80%)
 create mode 100644 Documentation/isdn/index.rst
 rename Documentation/isdn/{INTERFACE.CAPI => interface_capi.rst} (75%)
 rename Documentation/isdn/{README.mISDN => m_isdn.rst} (89%)
 rename Documentation/m68k/{README.buddha => buddha-driver.rst} (73%)
 rename Documentation/mips/{AU1xxx_IDE.README => au1xxx_ide.rst} (67%)
 create mode 100644 Documentation/mips/index.rst
 rename Documentation/networking/caif/{README => caif.rst} (70%)
 rename Documentation/networking/mac80211_hwsim/{README => mac80211_hwsim.rst} (81%)
 rename Documentation/nios2/{README => nios2.rst} (96%)
 create mode 100644 Documentation/openrisc/index.rst
 rename Documentation/openrisc/{README => openrisc_port.rst} (80%)
 rename Documentation/openrisc/{TODO => todo.rst} (78%)
 rename Documentation/parisc/{debugging => debugging.rst} (94%)
 create mode 100644 Documentation/parisc/index.rst
 rename Documentation/parisc/{registers => registers.rst} (70%)
 rename Documentation/powerpc/{bootwrapper.txt => bootwrapper.rst} (93%)
 rename Documentation/powerpc/{cpu_families.txt => cpu_families.rst} (95%)
 rename Documentation/powerpc/{cpu_features.txt => cpu_features.rst} (97%)
 rename Documentation/powerpc/{cxl.txt => cxl.rst} (95%)
 rename Documentation/powerpc/{cxlflash.txt => cxlflash.rst} (98%)
 rename Documentation/powerpc/{DAWR-POWER9.txt => dawr-power9.rst} (95%)
 rename Documentation/powerpc/{dscr.txt => dscr.rst} (91%)
 rename Documentation/powerpc/{eeh-pci-error-recovery.txt => eeh-pci-error-recovery.rst} (82%)
 rename Documentation/powerpc/{firmware-assisted-dump.txt => firmware-assisted-dump.rst} (80%)
 rename Documentation/powerpc/{hvcs.txt => hvcs.rst} (91%)
 create mode 100644 Documentation/powerpc/index.rst
 rename Documentation/powerpc/{mpc52xx.txt => mpc52xx.rst} (91%)
 rename Documentation/powerpc/{pci_iov_resource_on_powernv.txt => pci_iov_resource_on_powernv.rst} (97%)
 rename Documentation/powerpc/{pmu-ebb.txt => pmu-ebb.rst} (99%)
 rename Documentation/powerpc/{ptrace.txt => ptrace.rst} (48%)
 rename Documentation/powerpc/{qe_firmware.txt => qe_firmware.rst} (95%)
 rename Documentation/powerpc/{syscall64-abi.txt => syscall64-abi.rst} (82%)
 rename Documentation/powerpc/{transactional_memory.txt => transactional_memory.rst} (93%)
 rename Documentation/spi/{butterfly => butterfly.rst} (71%)
 create mode 100644 Documentation/spi/index.rst
 rename Documentation/spi/{pxa2xx => pxa2xx.rst} (83%)
 rename Documentation/spi/{spi-lm70llp => spi-lm70llp.rst} (88%)
 rename Documentation/spi/{spi-sc18is602 => spi-sc18is602.rst} (92%)
 rename Documentation/spi/{spi-summary => spi-summary.rst} (93%)
 rename Documentation/spi/{spidev => spidev.rst} (90%)
 create mode 100644 Documentation/w1/index.rst
 rename Documentation/w1/masters/{ds2482 => ds2482.rst} (71%)
 rename Documentation/w1/masters/{ds2490 => ds2490.rst} (98%)
 create mode 100644 Documentation/w1/masters/index.rst
 rename Documentation/w1/masters/{mxc-w1 => mxc-w1.rst} (33%)
 rename Documentation/w1/masters/{omap-hdq => omap-hdq.rst} (90%)
 rename Documentation/w1/masters/{w1-gpio => w1-gpio.rst} (75%)
 create mode 100644 Documentation/w1/slaves/index.rst
 rename Documentation/w1/slaves/{w1_ds2406 => w1_ds2406.rst} (96%)
 rename Documentation/w1/slaves/{w1_ds2413 => w1_ds2413.rst} (81%)
 rename Documentation/w1/slaves/{w1_ds2423 => w1_ds2423.rst} (48%)
 rename Documentation/w1/slaves/{w1_ds2438 => w1_ds2438.rst} (93%)
 rename Documentation/w1/slaves/{w1_ds28e04 => w1_ds28e04.rst} (93%)
 rename Documentation/w1/slaves/{w1_ds28e17 => w1_ds28e17.rst} (88%)
 rename Documentation/w1/slaves/{w1_therm => w1_therm.rst} (95%)
 rename Documentation/w1/{w1.generic => w1-generic.rst} (59%)
 rename Documentation/w1/{w1.netlink => w1-netlink.rst} (77%)

-- 
2.21.0


