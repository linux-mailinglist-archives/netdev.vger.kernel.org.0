Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5EE42E09
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403830AbfFLRzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:55:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388857AbfFLRxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LWHw/mHRS2Jnv5F3QjbBvx/TSqLmKvi4509nvq3fdcQ=; b=d4Lg5NzDiplkj29PWJgJzVUTE
        c7ZIJI2ctzioxG8KYD2QKVzIo+RbBHHUDI0qh90hAJU80MFB2vONoAHpumDlilSHXXZdvDHdvvpC7
        ID6ABFSmR3Szq+xUWmfpM9UEZ2S+jV6c3ViHJB9rzKAdtflrx+0e6QPK70CbOuKeNwypDnj56m2Ls
        UATpPRG/JngZYwEaSa3m3nVRPlbob/1ZEKSewyzSFO6N6o//jsuyMCEIobYtS16TnbHHLZIMy3KFy
        563Hugj1ue/ZItOO3nFXFtGJ4khaV6LKNuhjECWBGOLRT03YYXIgG6oS7cl9O48ZLEJ628KfDVggE
        Dnu0bIk6Q==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hb7Qt-0002Db-3D; Wed, 12 Jun 2019 17:53:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hb7Qp-0001fd-Tv; Wed, 12 Jun 2019 14:53:07 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v4 00/28] Convert files to ReST - part 1
Date:   Wed, 12 Jun 2019 14:52:36 -0300
Message-Id: <cover.1560361364.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is mostly a rebase of the /33 series v3 I sent, on the top of the latest
linux-next  (next-20190612).

Changes from v3:

- dropped cpufreq conversion - documents are too outdated;
- infiniband patch is not here anymore - as it should be merged via RDMA;
- s390 patches were already merged;
- Dropped Geert as Maintainer from fb/framebuffer.rst, as per his request;
- Did a minor editorial change at popwerpc/cxl.rst per Andrew Donellan
  request;
- Added acks/reviews;
- trivial rebase fixups.

Jon, 

the first version of this series was sent back on April, 15. So, I
suspect it should be fine to merge those patches via docs tree.

I should be sending soon the next part of this conversion series.

-

This is the first part of a series I wrote sometime ago where I manually
convert lots of files to be properly parsed by Sphinx as ReST files.

As it touches on lot of stuff, this series is based on today's docs-next
+ linux-next, at tag next-20190607.

I have right now about 85 patches with this undergoing work. That's
because I opted to do ~1 patch per converted directory.

That sounds too much to be send on a single round. So, I'm opting to split
it on 3 parts. Those patches should probably be good to be merged
either by subsystem maintainers or via the docs tree.

I opted to mark new files not included yet to the main index.rst (directly or
indirectly ) with the :orphan: tag, in order to avoid adding warnings to the
build system. This should be removed after we find a "home" for all
the converted files within the new document tree arrangement.

Both this series and  the next parts are on my devel git tree,
at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=convert_rst_renames_v4.2

The final output in html (after all patches I currently have, including 
the upcoming series) can be seen at:

	https://www.infradead.org/~mchehab/rst_conversion/

Mauro Carvalho Chehab (28):
  docs: aoe: convert docs to ReST and rename to *.rst
  docs: arm64: convert docs to ReST and rename to .rst
  docs: cdrom-standard.tex: convert from LaTeX to ReST
  docs: cdrom: convert docs to ReST and rename to *.rst
  docs: cgroup-v1: convert docs to ReST and rename to *.rst
  docs: cgroup-v1/blkio-controller.rst: add a note about CFQ scheduler
  docs: convert docs to ReST and rename to *.rst
  docs: fault-injection: convert docs to ReST and rename to *.rst
  docs: fb: convert docs to ReST and rename to *.rst
  docs: fpga: convert docs to ReST and rename to *.rst
  docs: ide: convert docs to ReST and rename to *.rst
  docs: kbuild: convert docs to ReST and rename to *.rst
  docs: kdump: convert docs to ReST and rename to *.rst
  docs: locking: convert docs to ReST and rename to *.rst
  docs: mic: convert docs to ReST and rename to *.rst
  docs: netlabel: convert docs to ReST and rename to *.rst
  docs: pcmcia: convert docs to ReST and rename to *.rst
  docs: convert docs to ReST and rename to *.rst
  docs: powerpc: convert docs to ReST and rename to *.rst
  docs: pps.txt: convert to ReST and rename to pps.rst
  docs: ptp.txt: convert to ReST and move to driver-api
  docs: riscv: convert docs to ReST and rename to *.rst
  docs: target: convert docs to ReST and rename to *.rst
  docs: timers: convert docs to ReST and rename to *.rst
  docs: watchdog: convert docs to ReST and rename to *.rst
  docs: xilinx: convert eemi.txt to eemi.rst
  docs: scheduler: convert docs to ReST and rename to *.rst
  docs: EDID/HOWTO.txt: convert it and rename to howto.rst

 .../ABI/testing/sysfs-class-powercap          |    2 +-
 Documentation/ABI/testing/sysfs-kernel-uids   |    2 +-
 Documentation/EDID/{HOWTO.txt => howto.rst}   |   31 +-
 Documentation/PCI/pci-error-recovery.rst      |   23 +-
 Documentation/admin-guide/README.rst          |    2 +-
 Documentation/admin-guide/bug-hunting.rst     |    2 +-
 Documentation/admin-guide/hw-vuln/l1tf.rst    |    2 +-
 .../admin-guide/kernel-parameters.txt         |   24 +-
 .../admin-guide/mm/numa_memory_policy.rst     |    2 +-
 Documentation/aoe/{aoe.txt => aoe.rst}        |   63 +-
 Documentation/aoe/examples.rst                |   23 +
 Documentation/aoe/index.rst                   |   19 +
 Documentation/aoe/{todo.txt => todo.rst}      |    3 +
 Documentation/aoe/udev.txt                    |    2 +-
 ...object_usage.txt => acpi_object_usage.rst} |  288 +++--
 .../arm64/{arm-acpi.txt => arm-acpi.rst}      |  155 +--
 .../arm64/{booting.txt => booting.rst}        |   91 +-
 ...egisters.txt => cpu-feature-registers.rst} |  204 ++--
 .../arm64/{elf_hwcaps.txt => elf_hwcaps.rst}  |   56 +-
 .../{hugetlbpage.txt => hugetlbpage.rst}      |    7 +-
 Documentation/arm64/index.rst                 |   28 +
 ...structions.txt => legacy_instructions.rst} |   43 +-
 Documentation/arm64/memory.rst                |   98 ++
 Documentation/arm64/memory.txt                |   97 --
 ...ication.txt => pointer-authentication.rst} |    2 +
 ...{silicon-errata.txt => silicon-errata.rst} |   65 +-
 Documentation/arm64/{sve.txt => sve.rst}      |   12 +-
 ...agged-pointers.txt => tagged-pointers.rst} |    6 +-
 Documentation/block/bfq-iosched.txt           |    2 +-
 Documentation/cdrom/Makefile                  |   21 -
 Documentation/cdrom/cdrom-standard.rst        | 1063 +++++++++++++++++
 Documentation/cdrom/cdrom-standard.tex        | 1026 ----------------
 Documentation/cdrom/{ide-cd => ide-cd.rst}    |  196 +--
 Documentation/cdrom/index.rst                 |   19 +
 ...{packet-writing.txt => packet-writing.rst} |   27 +-
 ...io-controller.txt => blkio-controller.rst} |  103 +-
 .../cgroup-v1/{cgroups.txt => cgroups.rst}    |  184 +--
 .../cgroup-v1/{cpuacct.txt => cpuacct.rst}    |   15 +-
 .../cgroup-v1/{cpusets.txt => cpusets.rst}    |  205 ++--
 .../cgroup-v1/{devices.txt => devices.rst}    |   40 +-
 ...er-subsystem.txt => freezer-subsystem.rst} |   14 +-
 .../cgroup-v1/{hugetlb.txt => hugetlb.rst}    |   39 +-
 Documentation/cgroup-v1/index.rst             |   30 +
 .../{memcg_test.txt => memcg_test.rst}        |  263 ++--
 .../cgroup-v1/{memory.txt => memory.rst}      |  449 ++++---
 .../cgroup-v1/{net_cls.txt => net_cls.rst}    |   37 +-
 .../cgroup-v1/{net_prio.txt => net_prio.rst}  |   24 +-
 .../cgroup-v1/{pids.txt => pids.rst}          |   78 +-
 .../cgroup-v1/{rdma.txt => rdma.rst}          |   66 +-
 Documentation/cpu-freq/core.txt               |    2 +-
 ...{cache-policies.txt => cache-policies.rst} |   24 +-
 .../device-mapper/{cache.txt => cache.rst}    |  206 ++--
 .../device-mapper/{delay.txt => delay.rst}    |   29 +-
 .../{dm-crypt.txt => dm-crypt.rst}            |   57 +-
 .../{dm-flakey.txt => dm-flakey.rst}          |   45 +-
 .../{dm-init.txt => dm-init.rst}              |   75 +-
 .../{dm-integrity.txt => dm-integrity.rst}    |   62 +-
 .../device-mapper/{dm-io.txt => dm-io.rst}    |   14 +-
 .../device-mapper/{dm-log.txt => dm-log.rst}  |    5 +-
 ...m-queue-length.txt => dm-queue-length.rst} |   25 +-
 .../{dm-raid.txt => dm-raid.rst}              |  225 ++--
 ...m-service-time.txt => dm-service-time.rst} |   68 +-
 Documentation/device-mapper/dm-uevent.rst     |  110 ++
 Documentation/device-mapper/dm-uevent.txt     |   97 --
 .../{dm-zoned.txt => dm-zoned.rst}            |   10 +-
 .../device-mapper/{era.txt => era.rst}        |   36 +-
 Documentation/device-mapper/index.rst         |   44 +
 .../device-mapper/{kcopyd.txt => kcopyd.rst}  |   10 +-
 Documentation/device-mapper/linear.rst        |   63 +
 Documentation/device-mapper/linear.txt        |   61 -
 .../{log-writes.txt => log-writes.rst}        |   91 +-
 ...ersistent-data.txt => persistent-data.rst} |    4 +
 .../{snapshot.txt => snapshot.rst}            |  116 +-
 .../{statistics.txt => statistics.rst}        |   62 +-
 Documentation/device-mapper/striped.rst       |   61 +
 Documentation/device-mapper/striped.txt       |   57 -
 .../device-mapper/{switch.txt => switch.rst}  |   47 +-
 ...provisioning.txt => thin-provisioning.rst} |   68 +-
 .../{unstriped.txt => unstriped.rst}          |  111 +-
 .../device-mapper/{verity.txt => verity.rst}  |   20 +-
 .../{writecache.txt => writecache.rst}        |   13 +-
 .../device-mapper/{zero.txt => zero.rst}      |   14 +-
 Documentation/driver-api/pm/devices.rst       |    6 +-
 .../{pps/pps.txt => driver-api/pps.rst}       |   67 +-
 .../{ptp/ptp.txt => driver-api/ptp.rst}       |   26 +-
 .../driver-api/usb/power-management.rst       |    2 +-
 ...ault-injection.txt => fault-injection.rst} |  265 ++--
 Documentation/fault-injection/index.rst       |   20 +
 ...r-inject.txt => notifier-error-inject.rst} |   18 +-
 .../fault-injection/nvme-fault-injection.rst  |  120 ++
 .../fault-injection/nvme-fault-injection.txt  |  116 --
 .../fault-injection/provoke-crashes.rst       |   48 +
 .../fault-injection/provoke-crashes.txt       |   38 -
 Documentation/fb/{api.txt => api.rst}         |   29 +-
 Documentation/fb/{arkfb.txt => arkfb.rst}     |    8 +-
 .../fb/{aty128fb.txt => aty128fb.rst}         |   35 +-
 .../fb/{cirrusfb.txt => cirrusfb.rst}         |   47 +-
 .../fb/{cmap_xfbdev.txt => cmap_xfbdev.rst}   |   57 +-
 .../fb/{deferred_io.txt => deferred_io.rst}   |   28 +-
 Documentation/fb/{efifb.txt => efifb.rst}     |   18 +-
 .../fb/{ep93xx-fb.txt => ep93xx-fb.rst}       |   27 +-
 Documentation/fb/{fbcon.txt => fbcon.rst}     |  177 +--
 .../fb/{framebuffer.txt => framebuffer.rst}   |   80 +-
 Documentation/fb/{gxfb.txt => gxfb.rst}       |   24 +-
 Documentation/fb/index.rst                    |   50 +
 .../fb/{intel810.txt => intel810.rst}         |   79 +-
 Documentation/fb/{intelfb.txt => intelfb.rst} |   62 +-
 .../fb/{internals.txt => internals.rst}       |   24 +-
 Documentation/fb/{lxfb.txt => lxfb.rst}       |   25 +-
 Documentation/fb/matroxfb.rst                 |  443 +++++++
 Documentation/fb/matroxfb.txt                 |  413 -------
 .../fb/{metronomefb.txt => metronomefb.rst}   |    8 +-
 Documentation/fb/{modedb.txt => modedb.rst}   |   44 +-
 Documentation/fb/pvr2fb.rst                   |   66 +
 Documentation/fb/pvr2fb.txt                   |   65 -
 Documentation/fb/{pxafb.txt => pxafb.rst}     |   81 +-
 Documentation/fb/{s3fb.txt => s3fb.rst}       |    8 +-
 .../fb/{sa1100fb.txt => sa1100fb.rst}         |   23 +-
 Documentation/fb/sh7760fb.rst                 |  130 ++
 Documentation/fb/sh7760fb.txt                 |  131 --
 Documentation/fb/{sisfb.txt => sisfb.rst}     |   40 +-
 Documentation/fb/{sm501.txt => sm501.rst}     |    7 +-
 Documentation/fb/{sm712fb.txt => sm712fb.rst} |   18 +-
 Documentation/fb/sstfb.rst                    |  207 ++++
 Documentation/fb/sstfb.txt                    |  174 ---
 Documentation/fb/{tgafb.txt => tgafb.rst}     |   30 +-
 .../fb/{tridentfb.txt => tridentfb.rst}       |   36 +-
 Documentation/fb/{udlfb.txt => udlfb.rst}     |   55 +-
 Documentation/fb/{uvesafb.txt => uvesafb.rst} |  128 +-
 Documentation/fb/{vesafb.txt => vesafb.rst}   |  121 +-
 Documentation/fb/viafb.rst                    |  297 +++++
 Documentation/fb/viafb.txt                    |  252 ----
 .../fb/{vt8623fb.txt => vt8623fb.rst}         |   10 +-
 Documentation/filesystems/tmpfs.txt           |    2 +-
 .../filesystems/ubifs-authentication.md       |    4 +-
 Documentation/fpga/{dfl.txt => dfl.rst}       |   58 +-
 Documentation/fpga/index.rst                  |   17 +
 Documentation/ide/changelogs.rst              |   17 +
 .../ide/{ide-tape.txt => ide-tape.rst}        |   23 +-
 Documentation/ide/{ide.txt => ide.rst}        |  147 +--
 Documentation/ide/index.rst                   |   21 +
 ...arm-plug-howto.txt => warm-plug-howto.rst} |   10 +-
 ...eaders_install.txt => headers_install.rst} |    5 +-
 Documentation/kbuild/index.rst                |   27 +
 Documentation/kbuild/issues.rst               |   11 +
 .../kbuild/{kbuild.txt => kbuild.rst}         |  119 +-
 ...nfig-language.txt => kconfig-language.rst} |  232 ++--
 ...anguage.txt => kconfig-macro-language.rst} |   37 +-
 .../kbuild/{kconfig.txt => kconfig.rst}       |  136 ++-
 .../kbuild/{makefiles.txt => makefiles.rst}   |  530 +++++---
 .../kbuild/{modules.txt => modules.rst}       |  168 +--
 Documentation/kdump/index.rst                 |   21 +
 Documentation/kdump/{kdump.txt => kdump.rst}  |  131 +-
 .../kdump/{vmcoreinfo.txt => vmcoreinfo.rst}  |   59 +-
 Documentation/kernel-hacking/hacking.rst      |    4 +-
 Documentation/kernel-hacking/locking.rst      |    2 +-
 Documentation/kernel-per-CPU-kthreads.txt     |    2 +-
 Documentation/locking/index.rst               |   24 +
 ...{lockdep-design.txt => lockdep-design.rst} |   51 +-
 Documentation/locking/lockstat.rst            |  204 ++++
 Documentation/locking/lockstat.txt            |  183 ---
 .../{locktorture.txt => locktorture.rst}      |  105 +-
 .../{mutex-design.txt => mutex-design.rst}    |   26 +-
 ...t-mutex-design.txt => rt-mutex-design.rst} |  139 ++-
 .../locking/{rt-mutex.txt => rt-mutex.rst}    |   30 +-
 .../locking/{spinlocks.txt => spinlocks.rst}  |   32 +-
 ...w-mutex-design.txt => ww-mutex-design.rst} |   82 +-
 Documentation/mic/index.rst                   |   18 +
 .../{mic_overview.txt => mic_overview.rst}    |    6 +-
 .../{scif_overview.txt => scif_overview.rst}  |   58 +-
 .../{cipso_ipv4.txt => cipso_ipv4.rst}        |   19 +-
 Documentation/netlabel/draft_ietf.rst         |    5 +
 Documentation/netlabel/index.rst              |   21 +
 .../{introduction.txt => introduction.rst}    |   16 +-
 .../{lsm_interface.txt => lsm_interface.rst}  |   16 +-
 Documentation/networking/timestamping.txt     |    2 +-
 .../{devicetable.txt => devicetable.rst}      |    4 +
 ...{driver-changes.txt => driver-changes.rst} |   35 +-
 .../pcmcia/{driver.txt => driver.rst}         |   18 +-
 Documentation/pcmcia/index.rst                |   20 +
 .../pcmcia/{locking.txt => locking.rst}       |   39 +-
 Documentation/pi-futex.txt                    |    2 +-
 .../power/{apm-acpi.txt => apm-acpi.rst}      |   10 +-
 ...m-debugging.txt => basic-pm-debugging.rst} |   79 +-
 ...harger-manager.txt => charger-manager.rst} |  101 +-
 ...rivers-testing.txt => drivers-testing.rst} |   15 +-
 .../{energy-model.txt => energy-model.rst}    |  101 +-
 ...ing-of-tasks.txt => freezing-of-tasks.rst} |   91 +-
 Documentation/power/index.rst                 |   46 +
 .../power/{interface.txt => interface.rst}    |   24 +-
 Documentation/power/{opp.txt => opp.rst}      |  175 +--
 Documentation/power/{pci.txt => pci.rst}      |   87 +-
 ...qos_interface.txt => pm_qos_interface.rst} |  127 +-
 Documentation/power/power_supply_class.rst    |  282 +++++
 Documentation/power/power_supply_class.txt    |  231 ----
 Documentation/power/powercap/powercap.rst     |  257 ++++
 Documentation/power/powercap/powercap.txt     |  236 ----
 .../regulator/{consumer.txt => consumer.rst}  |  141 ++-
 .../regulator/{design.txt => design.rst}      |    9 +-
 .../regulator/{machine.txt => machine.rst}    |   47 +-
 .../regulator/{overview.txt => overview.rst}  |   57 +-
 Documentation/power/regulator/regulator.rst   |   32 +
 Documentation/power/regulator/regulator.txt   |   30 -
 .../power/{runtime_pm.txt => runtime_pm.rst}  |  234 ++--
 Documentation/power/{s2ram.txt => s2ram.rst}  |   20 +-
 ...hotplug.txt => suspend-and-cpuhotplug.rst} |   42 +-
 ...errupts.txt => suspend-and-interrupts.rst} |    2 +
 ...ap-files.txt => swsusp-and-swap-files.rst} |   17 +-
 ...{swsusp-dmcrypt.txt => swsusp-dmcrypt.rst} |  120 +-
 Documentation/power/swsusp.rst                |  501 ++++++++
 Documentation/power/swsusp.txt                |  446 -------
 .../power/{tricks.txt => tricks.rst}          |    6 +-
 ...serland-swsusp.txt => userland-swsusp.rst} |   55 +-
 Documentation/power/{video.txt => video.rst}  |  156 ++-
 .../{bootwrapper.txt => bootwrapper.rst}      |   28 +-
 .../{cpu_families.txt => cpu_families.rst}    |   23 +-
 .../{cpu_features.txt => cpu_features.rst}    |    6 +-
 Documentation/powerpc/{cxl.txt => cxl.rst}    |   46 +-
 .../powerpc/{cxlflash.txt => cxlflash.rst}    |   10 +-
 .../{DAWR-POWER9.txt => dawr-power9.rst}      |   15 +-
 Documentation/powerpc/{dscr.txt => dscr.rst}  |   18 +-
 ...ecovery.txt => eeh-pci-error-recovery.rst} |  108 +-
 ...ed-dump.txt => firmware-assisted-dump.rst} |  119 +-
 Documentation/powerpc/{hvcs.txt => hvcs.rst}  |  108 +-
 Documentation/powerpc/index.rst               |   34 +
 Documentation/powerpc/isa-versions.rst        |   15 +-
 .../powerpc/{mpc52xx.txt => mpc52xx.rst}      |   12 +-
 ...nv.txt => pci_iov_resource_on_powernv.rst} |   15 +-
 .../powerpc/{pmu-ebb.txt => pmu-ebb.rst}      |    1 +
 Documentation/powerpc/ptrace.rst              |  156 +++
 Documentation/powerpc/ptrace.txt              |  151 ---
 .../{qe_firmware.txt => qe_firmware.rst}      |   37 +-
 .../{syscall64-abi.txt => syscall64-abi.rst}  |   29 +-
 ...al_memory.txt => transactional_memory.rst} |   45 +-
 Documentation/process/4.Coding.rst            |    2 +-
 Documentation/process/coding-style.rst        |    2 +-
 Documentation/process/submit-checklist.rst    |    2 +-
 Documentation/process/submitting-drivers.rst  |    2 +-
 Documentation/riscv/index.rst                 |   17 +
 Documentation/riscv/{pmu.txt => pmu.rst}      |   98 +-
 .../{completion.txt => completion.rst}        |   38 +-
 Documentation/scheduler/index.rst             |   29 +
 .../{sched-arch.txt => sched-arch.rst}        |   18 +-
 .../{sched-bwc.txt => sched-bwc.rst}          |   30 +-
 ...{sched-deadline.txt => sched-deadline.rst} |  297 ++---
 ...ed-design-CFS.txt => sched-design-CFS.rst} |   17 +-
 .../{sched-domains.txt => sched-domains.rst}  |    8 +-
 .../{sched-energy.txt => sched-energy.rst}    |   53 +-
 ...-nice-design.txt => sched-nice-design.rst} |    6 +-
 ...{sched-rt-group.txt => sched-rt-group.rst} |   30 +-
 .../{sched-stats.txt => sched-stats.rst}      |   35 +-
 Documentation/scheduler/text_files.rst        |    5 +
 Documentation/target/index.rst                |   19 +
 Documentation/target/scripts.rst              |   11 +
 Documentation/target/tcm_mod_builder.rst      |  149 +++
 Documentation/target/tcm_mod_builder.txt      |  145 ---
 .../{tcmu-design.txt => tcmu-design.rst}      |  268 +++--
 .../timers/{highres.txt => highres.rst}       |   13 +-
 Documentation/timers/{hpet.txt => hpet.rst}   |    4 +-
 .../timers/{hrtimers.txt => hrtimers.rst}     |    6 +-
 Documentation/timers/index.rst                |   22 +
 Documentation/timers/{NO_HZ.txt => no_hz.rst} |   40 +-
 .../{timekeeping.txt => timekeeping.rst}      |    3 +-
 .../{timers-howto.txt => timers-howto.rst}    |   15 +-
 Documentation/trace/coresight-cpu-debug.txt   |    2 +-
 .../it_IT/kernel-hacking/hacking.rst          |    4 +-
 .../it_IT/kernel-hacking/locking.rst          |    2 +-
 .../translations/it_IT/process/4.Coding.rst   |    2 +-
 .../it_IT/process/coding-style.rst            |    2 +-
 .../it_IT/process/submit-checklist.rst        |    2 +-
 .../translations/zh_CN/arm64/booting.txt      |    4 +-
 .../zh_CN/arm64/legacy_instructions.txt       |    4 +-
 .../translations/zh_CN/arm64/memory.txt       |    4 +-
 .../zh_CN/arm64/silicon-errata.txt            |    4 +-
 .../zh_CN/arm64/tagged-pointers.txt           |    4 +-
 .../translations/zh_CN/oops-tracing.txt       |    2 +-
 .../translations/zh_CN/process/4.Coding.rst   |    2 +-
 .../zh_CN/process/coding-style.rst            |    2 +-
 .../zh_CN/process/submit-checklist.rst        |    2 +-
 .../zh_CN/process/submitting-drivers.rst      |    2 +-
 Documentation/virtual/kvm/api.txt             |    2 +-
 Documentation/vm/numa.rst                     |    6 +-
 Documentation/vm/page_migration.rst           |    2 +-
 Documentation/vm/unevictable-lru.rst          |    2 +-
 ....txt => convert_drivers_to_kernel_api.rst} |  109 +-
 .../watchdog/{hpwdt.txt => hpwdt.rst}         |   27 +-
 Documentation/watchdog/index.rst              |   25 +
 .../watchdog/{mlx-wdt.txt => mlx-wdt.rst}     |   24 +-
 .../{pcwd-watchdog.txt => pcwd-watchdog.rst}  |   13 +-
 .../{watchdog-api.txt => watchdog-api.rst}    |   76 +-
 ...kernel-api.txt => watchdog-kernel-api.rst} |   91 +-
 .../watchdog/watchdog-parameters.rst          |  736 ++++++++++++
 .../watchdog/watchdog-parameters.txt          |  410 -------
 .../{watchdog-pm.txt => watchdog-pm.rst}      |    3 +
 Documentation/watchdog/{wdt.txt => wdt.rst}   |   31 +-
 .../x86/x86_64/fake-numa-for-cpusets.rst      |    4 +-
 Documentation/xilinx/{eemi.txt => eemi.rst}   |    8 +-
 Documentation/xilinx/index.rst                |   17 +
 Kconfig                                       |    2 +-
 MAINTAINERS                                   |   34 +-
 arch/arc/plat-eznps/Kconfig                   |    2 +-
 arch/arm/Kconfig                              |    2 +-
 arch/arm64/Kconfig                            |    2 +-
 arch/arm64/include/asm/efi.h                  |    2 +-
 arch/arm64/include/asm/image.h                |    2 +-
 arch/arm64/include/uapi/asm/sigcontext.h      |    2 +-
 arch/arm64/kernel/kexec_image.c               |    2 +-
 arch/c6x/Kconfig                              |    2 +-
 arch/m68k/q40/README                          |    2 +-
 arch/microblaze/Kconfig.debug                 |    2 +-
 arch/microblaze/Kconfig.platform              |    2 +-
 arch/nds32/Kconfig                            |    2 +-
 arch/openrisc/Kconfig                         |    2 +-
 arch/powerpc/kernel/exceptions-64s.S          |    2 +-
 arch/powerpc/sysdev/Kconfig                   |    2 +-
 arch/riscv/Kconfig                            |    2 +-
 arch/sh/Kconfig                               |    2 +-
 arch/x86/Kconfig                              |    6 +-
 block/Kconfig                                 |    2 +-
 drivers/auxdisplay/Kconfig                    |    2 +-
 drivers/block/Kconfig                         |    2 +-
 drivers/cdrom/cdrom.c                         |    2 +-
 drivers/firmware/Kconfig                      |    2 +-
 drivers/gpu/drm/Kconfig                       |    2 +-
 drivers/gpu/drm/drm_modeset_lock.c            |    2 +-
 drivers/gpu/drm/i915/i915_drv.h               |    2 +-
 drivers/ide/Kconfig                           |   20 +-
 drivers/ide/ide-cd.c                          |    2 +-
 drivers/md/Kconfig                            |    2 +-
 drivers/md/dm-init.c                          |    2 +-
 drivers/md/dm-raid.c                          |    2 +-
 drivers/media/usb/dvb-usb-v2/anysee.c         |    2 +-
 drivers/misc/lkdtm/core.c                     |    2 +-
 drivers/mtd/devices/Kconfig                   |    2 +-
 drivers/net/ethernet/smsc/Kconfig             |    6 +-
 drivers/net/wireless/intel/iwlegacy/Kconfig   |    4 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig    |    2 +-
 drivers/opp/Kconfig                           |    2 +-
 drivers/parport/Kconfig                       |    2 +-
 drivers/pcmcia/ds.c                           |    2 +-
 drivers/power/supply/power_supply_core.c      |    2 +-
 drivers/regulator/core.c                      |    2 +-
 drivers/scsi/Kconfig                          |    4 +-
 drivers/soc/fsl/qe/qe.c                       |    2 +-
 drivers/staging/sm750fb/Kconfig               |    2 +-
 drivers/tty/Kconfig                           |    2 +-
 drivers/tty/hvc/hvcs.c                        |    2 +-
 drivers/usb/misc/Kconfig                      |    4 +-
 drivers/video/fbdev/Kconfig                   |   38 +-
 drivers/video/fbdev/matrox/matroxfb_base.c    |    2 +-
 drivers/video/fbdev/pxafb.c                   |    2 +-
 drivers/video/fbdev/sh7760fb.c                |    2 +-
 drivers/watchdog/Kconfig                      |    6 +-
 drivers/watchdog/smsc37b787_wdt.c             |    2 +-
 include/linux/cgroup-defs.h                   |    2 +-
 include/linux/fault-inject.h                  |    2 +-
 include/linux/interrupt.h                     |    2 +-
 include/linux/iopoll.h                        |    4 +-
 include/linux/lockdep.h                       |    2 +-
 include/linux/mutex.h                         |    2 +-
 include/linux/pci.h                           |    2 +-
 include/linux/pm.h                            |    2 +-
 include/linux/regmap.h                        |    4 +-
 include/linux/rwsem.h                         |    2 +-
 include/pcmcia/ds.h                           |    2 +-
 include/pcmcia/ss.h                           |    2 +-
 include/soc/fsl/qe/qe.h                       |    2 +-
 include/uapi/linux/bpf.h                      |    2 +-
 init/Kconfig                                  |    8 +-
 kernel/cgroup/cpuset.c                        |    2 +-
 kernel/locking/mutex.c                        |    2 +-
 kernel/locking/rtmutex.c                      |    2 +-
 kernel/power/Kconfig                          |    6 +-
 kernel/sched/deadline.c                       |    2 +-
 lib/Kconfig.debug                             |    6 +-
 net/bridge/netfilter/Kconfig                  |    2 +-
 net/ipv4/netfilter/Kconfig                    |    2 +-
 net/ipv6/netfilter/Kconfig                    |    2 +-
 net/netfilter/Kconfig                         |   16 +-
 net/tipc/Kconfig                              |    2 +-
 net/wireless/Kconfig                          |    2 +-
 scripts/Kbuild.include                        |    4 +-
 scripts/Makefile.host                         |    2 +-
 scripts/checkpatch.pl                         |    8 +-
 scripts/documentation-file-ref-check          |    2 +-
 scripts/kconfig/symbol.c                      |    2 +-
 .../tests/err_recursive_dep/expected_stderr   |   14 +-
 security/device_cgroup.c                      |    2 +-
 sound/oss/dmasound/Kconfig                    |    6 +-
 sound/soc/sof/ops.h                           |    2 +-
 tools/include/uapi/linux/bpf.h                |    2 +-
 tools/testing/fault-injection/failcmd.sh      |    2 +-
 392 files changed, 12880 insertions(+), 9641 deletions(-)
 rename Documentation/EDID/{HOWTO.txt => howto.rst} (83%)
 rename Documentation/aoe/{aoe.txt => aoe.rst} (79%)
 create mode 100644 Documentation/aoe/examples.rst
 create mode 100644 Documentation/aoe/index.rst
 rename Documentation/aoe/{todo.txt => todo.rst} (98%)
 rename Documentation/arm64/{acpi_object_usage.txt => acpi_object_usage.rst} (84%)
 rename Documentation/arm64/{arm-acpi.txt => arm-acpi.rst} (86%)
 rename Documentation/arm64/{booting.txt => booting.rst} (86%)
 rename Documentation/arm64/{cpu-feature-registers.txt => cpu-feature-registers.rst} (65%)
 rename Documentation/arm64/{elf_hwcaps.txt => elf_hwcaps.rst} (92%)
 rename Documentation/arm64/{hugetlbpage.txt => hugetlbpage.rst} (86%)
 create mode 100644 Documentation/arm64/index.rst
 rename Documentation/arm64/{legacy_instructions.txt => legacy_instructions.rst} (73%)
 create mode 100644 Documentation/arm64/memory.rst
 delete mode 100644 Documentation/arm64/memory.txt
 rename Documentation/arm64/{pointer-authentication.txt => pointer-authentication.rst} (99%)
 rename Documentation/arm64/{silicon-errata.txt => silicon-errata.rst} (55%)
 rename Documentation/arm64/{sve.txt => sve.rst} (98%)
 rename Documentation/arm64/{tagged-pointers.txt => tagged-pointers.rst} (94%)
 delete mode 100644 Documentation/cdrom/Makefile
 create mode 100644 Documentation/cdrom/cdrom-standard.rst
 delete mode 100644 Documentation/cdrom/cdrom-standard.tex
 rename Documentation/cdrom/{ide-cd => ide-cd.rst} (82%)
 create mode 100644 Documentation/cdrom/index.rst
 rename Documentation/cdrom/{packet-writing.txt => packet-writing.rst} (91%)
 rename Documentation/cgroup-v1/{blkio-controller.txt => blkio-controller.rst} (89%)
 rename Documentation/cgroup-v1/{cgroups.txt => cgroups.rst} (88%)
 rename Documentation/cgroup-v1/{cpuacct.txt => cpuacct.rst} (90%)
 rename Documentation/cgroup-v1/{cpusets.txt => cpusets.rst} (90%)
 rename Documentation/cgroup-v1/{devices.txt => devices.rst} (88%)
 rename Documentation/cgroup-v1/{freezer-subsystem.txt => freezer-subsystem.rst} (95%)
 rename Documentation/cgroup-v1/{hugetlb.txt => hugetlb.rst} (70%)
 create mode 100644 Documentation/cgroup-v1/index.rst
 rename Documentation/cgroup-v1/{memcg_test.txt => memcg_test.rst} (62%)
 rename Documentation/cgroup-v1/{memory.txt => memory.rst} (71%)
 rename Documentation/cgroup-v1/{net_cls.txt => net_cls.rst} (50%)
 rename Documentation/cgroup-v1/{net_prio.txt => net_prio.rst} (71%)
 rename Documentation/cgroup-v1/{pids.txt => pids.rst} (62%)
 rename Documentation/cgroup-v1/{rdma.txt => rdma.rst} (79%)
 rename Documentation/device-mapper/{cache-policies.txt => cache-policies.rst} (94%)
 rename Documentation/device-mapper/{cache.txt => cache.rst} (61%)
 rename Documentation/device-mapper/{delay.txt => delay.rst} (53%)
 rename Documentation/device-mapper/{dm-crypt.txt => dm-crypt.rst} (87%)
 rename Documentation/device-mapper/{dm-flakey.txt => dm-flakey.rst} (60%)
 rename Documentation/device-mapper/{dm-init.txt => dm-init.rst} (69%)
 rename Documentation/device-mapper/{dm-integrity.txt => dm-integrity.rst} (90%)
 rename Documentation/device-mapper/{dm-io.txt => dm-io.rst} (92%)
 rename Documentation/device-mapper/{dm-log.txt => dm-log.rst} (90%)
 rename Documentation/device-mapper/{dm-queue-length.txt => dm-queue-length.rst} (76%)
 rename Documentation/device-mapper/{dm-raid.txt => dm-raid.rst} (71%)
 rename Documentation/device-mapper/{dm-service-time.txt => dm-service-time.rst} (60%)
 create mode 100644 Documentation/device-mapper/dm-uevent.rst
 delete mode 100644 Documentation/device-mapper/dm-uevent.txt
 rename Documentation/device-mapper/{dm-zoned.txt => dm-zoned.rst} (97%)
 rename Documentation/device-mapper/{era.txt => era.rst} (70%)
 create mode 100644 Documentation/device-mapper/index.rst
 rename Documentation/device-mapper/{kcopyd.txt => kcopyd.rst} (93%)
 create mode 100644 Documentation/device-mapper/linear.rst
 delete mode 100644 Documentation/device-mapper/linear.txt
 rename Documentation/device-mapper/{log-writes.txt => log-writes.rst} (61%)
 rename Documentation/device-mapper/{persistent-data.txt => persistent-data.rst} (98%)
 rename Documentation/device-mapper/{snapshot.txt => snapshot.rst} (62%)
 rename Documentation/device-mapper/{statistics.txt => statistics.rst} (87%)
 create mode 100644 Documentation/device-mapper/striped.rst
 delete mode 100644 Documentation/device-mapper/striped.txt
 rename Documentation/device-mapper/{switch.txt => switch.rst} (84%)
 rename Documentation/device-mapper/{thin-provisioning.txt => thin-provisioning.rst} (92%)
 rename Documentation/device-mapper/{unstriped.txt => unstriped.rst} (60%)
 rename Documentation/device-mapper/{verity.txt => verity.rst} (98%)
 rename Documentation/device-mapper/{writecache.txt => writecache.rst} (96%)
 rename Documentation/device-mapper/{zero.txt => zero.rst} (83%)
 rename Documentation/{pps/pps.txt => driver-api/pps.rst} (89%)
 rename Documentation/{ptp/ptp.txt => driver-api/ptp.rst} (88%)
 rename Documentation/fault-injection/{fault-injection.txt => fault-injection.rst} (68%)
 create mode 100644 Documentation/fault-injection/index.rst
 rename Documentation/fault-injection/{notifier-error-inject.txt => notifier-error-inject.rst} (83%)
 create mode 100644 Documentation/fault-injection/nvme-fault-injection.rst
 delete mode 100644 Documentation/fault-injection/nvme-fault-injection.txt
 create mode 100644 Documentation/fault-injection/provoke-crashes.rst
 delete mode 100644 Documentation/fault-injection/provoke-crashes.txt
 rename Documentation/fb/{api.txt => api.rst} (97%)
 rename Documentation/fb/{arkfb.txt => arkfb.rst} (92%)
 rename Documentation/fb/{aty128fb.txt => aty128fb.rst} (61%)
 rename Documentation/fb/{cirrusfb.txt => cirrusfb.rst} (75%)
 rename Documentation/fb/{cmap_xfbdev.txt => cmap_xfbdev.rst} (50%)
 rename Documentation/fb/{deferred_io.txt => deferred_io.rst} (86%)
 rename Documentation/fb/{efifb.txt => efifb.rst} (75%)
 rename Documentation/fb/{ep93xx-fb.txt => ep93xx-fb.rst} (85%)
 rename Documentation/fb/{fbcon.txt => fbcon.rst} (69%)
 rename Documentation/fb/{framebuffer.txt => framebuffer.rst} (92%)
 rename Documentation/fb/{gxfb.txt => gxfb.rst} (60%)
 create mode 100644 Documentation/fb/index.rst
 rename Documentation/fb/{intel810.txt => intel810.rst} (83%)
 rename Documentation/fb/{intelfb.txt => intelfb.rst} (73%)
 rename Documentation/fb/{internals.txt => internals.rst} (82%)
 rename Documentation/fb/{lxfb.txt => lxfb.rst} (60%)
 create mode 100644 Documentation/fb/matroxfb.rst
 delete mode 100644 Documentation/fb/matroxfb.txt
 rename Documentation/fb/{metronomefb.txt => metronomefb.rst} (98%)
 rename Documentation/fb/{modedb.txt => modedb.rst} (87%)
 create mode 100644 Documentation/fb/pvr2fb.rst
 delete mode 100644 Documentation/fb/pvr2fb.txt
 rename Documentation/fb/{pxafb.txt => pxafb.rst} (78%)
 rename Documentation/fb/{s3fb.txt => s3fb.rst} (94%)
 rename Documentation/fb/{sa1100fb.txt => sa1100fb.rst} (64%)
 create mode 100644 Documentation/fb/sh7760fb.rst
 delete mode 100644 Documentation/fb/sh7760fb.txt
 rename Documentation/fb/{sisfb.txt => sisfb.rst} (85%)
 rename Documentation/fb/{sm501.txt => sm501.rst} (65%)
 rename Documentation/fb/{sm712fb.txt => sm712fb.rst} (59%)
 create mode 100644 Documentation/fb/sstfb.rst
 delete mode 100644 Documentation/fb/sstfb.txt
 rename Documentation/fb/{tgafb.txt => tgafb.rst} (71%)
 rename Documentation/fb/{tridentfb.txt => tridentfb.rst} (70%)
 rename Documentation/fb/{udlfb.txt => udlfb.rst} (77%)
 rename Documentation/fb/{uvesafb.txt => uvesafb.rst} (52%)
 rename Documentation/fb/{vesafb.txt => vesafb.rst} (57%)
 create mode 100644 Documentation/fb/viafb.rst
 delete mode 100644 Documentation/fb/viafb.txt
 rename Documentation/fb/{vt8623fb.txt => vt8623fb.rst} (85%)
 rename Documentation/fpga/{dfl.txt => dfl.rst} (89%)
 create mode 100644 Documentation/fpga/index.rst
 create mode 100644 Documentation/ide/changelogs.rst
 rename Documentation/ide/{ide-tape.txt => ide-tape.rst} (83%)
 rename Documentation/ide/{ide.txt => ide.rst} (72%)
 create mode 100644 Documentation/ide/index.rst
 rename Documentation/ide/{warm-plug-howto.txt => warm-plug-howto.rst} (61%)
 rename Documentation/kbuild/{headers_install.txt => headers_install.rst} (96%)
 create mode 100644 Documentation/kbuild/index.rst
 create mode 100644 Documentation/kbuild/issues.rst
 rename Documentation/kbuild/{kbuild.txt => kbuild.rst} (72%)
 rename Documentation/kbuild/{kconfig-language.txt => kconfig-language.rst} (85%)
 rename Documentation/kbuild/{kconfig-macro-language.txt => kconfig-macro-language.rst} (94%)
 rename Documentation/kbuild/{kconfig.txt => kconfig.rst} (80%)
 rename Documentation/kbuild/{makefiles.txt => makefiles.rst} (83%)
 rename Documentation/kbuild/{modules.txt => modules.rst} (84%)
 create mode 100644 Documentation/kdump/index.rst
 rename Documentation/kdump/{kdump.txt => kdump.rst} (91%)
 rename Documentation/kdump/{vmcoreinfo.txt => vmcoreinfo.rst} (95%)
 create mode 100644 Documentation/locking/index.rst
 rename Documentation/locking/{lockdep-design.txt => lockdep-design.rst} (93%)
 create mode 100644 Documentation/locking/lockstat.rst
 delete mode 100644 Documentation/locking/lockstat.txt
 rename Documentation/locking/{locktorture.txt => locktorture.rst} (57%)
 rename Documentation/locking/{mutex-design.txt => mutex-design.rst} (94%)
 rename Documentation/locking/{rt-mutex-design.txt => rt-mutex-design.rst} (91%)
 rename Documentation/locking/{rt-mutex.txt => rt-mutex.rst} (71%)
 rename Documentation/locking/{spinlocks.txt => spinlocks.rst} (89%)
 rename Documentation/locking/{ww-mutex-design.txt => ww-mutex-design.rst} (93%)
 create mode 100644 Documentation/mic/index.rst
 rename Documentation/mic/{mic_overview.txt => mic_overview.rst} (96%)
 rename Documentation/mic/{scif_overview.txt => scif_overview.rst} (76%)
 rename Documentation/netlabel/{cipso_ipv4.txt => cipso_ipv4.rst} (87%)
 create mode 100644 Documentation/netlabel/draft_ietf.rst
 create mode 100644 Documentation/netlabel/index.rst
 rename Documentation/netlabel/{introduction.txt => introduction.rst} (91%)
 rename Documentation/netlabel/{lsm_interface.txt => lsm_interface.rst} (88%)
 rename Documentation/pcmcia/{devicetable.txt => devicetable.rst} (97%)
 rename Documentation/pcmcia/{driver-changes.txt => driver-changes.rst} (90%)
 rename Documentation/pcmcia/{driver.txt => driver.rst} (66%)
 create mode 100644 Documentation/pcmcia/index.rst
 rename Documentation/pcmcia/{locking.txt => locking.rst} (81%)
 rename Documentation/power/{apm-acpi.txt => apm-acpi.rst} (87%)
 rename Documentation/power/{basic-pm-debugging.txt => basic-pm-debugging.rst} (87%)
 rename Documentation/power/{charger-manager.txt => charger-manager.rst} (78%)
 rename Documentation/power/{drivers-testing.txt => drivers-testing.rst} (86%)
 rename Documentation/power/{energy-model.txt => energy-model.rst} (74%)
 rename Documentation/power/{freezing-of-tasks.txt => freezing-of-tasks.rst} (75%)
 create mode 100644 Documentation/power/index.rst
 rename Documentation/power/{interface.txt => interface.rst} (84%)
 rename Documentation/power/{opp.txt => opp.rst} (78%)
 rename Documentation/power/{pci.txt => pci.rst} (97%)
 rename Documentation/power/{pm_qos_interface.txt => pm_qos_interface.rst} (62%)
 create mode 100644 Documentation/power/power_supply_class.rst
 delete mode 100644 Documentation/power/power_supply_class.txt
 create mode 100644 Documentation/power/powercap/powercap.rst
 delete mode 100644 Documentation/power/powercap/powercap.txt
 rename Documentation/power/regulator/{consumer.txt => consumer.rst} (61%)
 rename Documentation/power/regulator/{design.txt => design.rst} (86%)
 rename Documentation/power/regulator/{machine.txt => machine.rst} (75%)
 rename Documentation/power/regulator/{overview.txt => overview.rst} (79%)
 create mode 100644 Documentation/power/regulator/regulator.rst
 delete mode 100644 Documentation/power/regulator/regulator.txt
 rename Documentation/power/{runtime_pm.txt => runtime_pm.rst} (89%)
 rename Documentation/power/{s2ram.txt => s2ram.rst} (92%)
 rename Documentation/power/{suspend-and-cpuhotplug.txt => suspend-and-cpuhotplug.rst} (90%)
 rename Documentation/power/{suspend-and-interrupts.txt => suspend-and-interrupts.rst} (98%)
 rename Documentation/power/{swsusp-and-swap-files.txt => swsusp-and-swap-files.rst} (83%)
 rename Documentation/power/{swsusp-dmcrypt.txt => swsusp-dmcrypt.rst} (67%)
 create mode 100644 Documentation/power/swsusp.rst
 delete mode 100644 Documentation/power/swsusp.txt
 rename Documentation/power/{tricks.txt => tricks.rst} (93%)
 rename Documentation/power/{userland-swsusp.txt => userland-swsusp.rst} (85%)
 rename Documentation/power/{video.txt => video.rst} (56%)
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
 create mode 100644 Documentation/powerpc/ptrace.rst
 delete mode 100644 Documentation/powerpc/ptrace.txt
 rename Documentation/powerpc/{qe_firmware.txt => qe_firmware.rst} (95%)
 rename Documentation/powerpc/{syscall64-abi.txt => syscall64-abi.rst} (82%)
 rename Documentation/powerpc/{transactional_memory.txt => transactional_memory.rst} (93%)
 create mode 100644 Documentation/riscv/index.rst
 rename Documentation/riscv/{pmu.txt => pmu.rst} (77%)
 rename Documentation/scheduler/{completion.txt => completion.rst} (94%)
 create mode 100644 Documentation/scheduler/index.rst
 rename Documentation/scheduler/{sched-arch.txt => sched-arch.rst} (81%)
 rename Documentation/scheduler/{sched-bwc.txt => sched-bwc.rst} (90%)
 rename Documentation/scheduler/{sched-deadline.txt => sched-deadline.rst} (88%)
 rename Documentation/scheduler/{sched-design-CFS.txt => sched-design-CFS.rst} (97%)
 rename Documentation/scheduler/{sched-domains.txt => sched-domains.rst} (97%)
 rename Documentation/scheduler/{sched-energy.txt => sched-energy.rst} (96%)
 rename Documentation/scheduler/{sched-nice-design.txt => sched-nice-design.rst} (98%)
 rename Documentation/scheduler/{sched-rt-group.txt => sched-rt-group.rst} (95%)
 rename Documentation/scheduler/{sched-stats.txt => sched-stats.rst} (91%)
 create mode 100644 Documentation/scheduler/text_files.rst
 create mode 100644 Documentation/target/index.rst
 create mode 100644 Documentation/target/scripts.rst
 create mode 100644 Documentation/target/tcm_mod_builder.rst
 delete mode 100644 Documentation/target/tcm_mod_builder.txt
 rename Documentation/target/{tcmu-design.txt => tcmu-design.rst} (69%)
 rename Documentation/timers/{highres.txt => highres.rst} (98%)
 rename Documentation/timers/{hpet.txt => hpet.rst} (91%)
 rename Documentation/timers/{hrtimers.txt => hrtimers.rst} (98%)
 create mode 100644 Documentation/timers/index.rst
 rename Documentation/timers/{NO_HZ.txt => no_hz.rst} (93%)
 rename Documentation/timers/{timekeeping.txt => timekeeping.rst} (98%)
 rename Documentation/timers/{timers-howto.txt => timers-howto.rst} (93%)
 rename Documentation/watchdog/{convert_drivers_to_kernel_api.txt => convert_drivers_to_kernel_api.rst} (75%)
 rename Documentation/watchdog/{hpwdt.txt => hpwdt.rst} (78%)
 create mode 100644 Documentation/watchdog/index.rst
 rename Documentation/watchdog/{mlx-wdt.txt => mlx-wdt.rst} (78%)
 rename Documentation/watchdog/{pcwd-watchdog.txt => pcwd-watchdog.rst} (89%)
 rename Documentation/watchdog/{watchdog-api.txt => watchdog-api.rst} (80%)
 rename Documentation/watchdog/{watchdog-kernel-api.txt => watchdog-kernel-api.rst} (90%)
 create mode 100644 Documentation/watchdog/watchdog-parameters.rst
 delete mode 100644 Documentation/watchdog/watchdog-parameters.txt
 rename Documentation/watchdog/{watchdog-pm.txt => watchdog-pm.rst} (92%)
 rename Documentation/watchdog/{wdt.txt => wdt.rst} (68%)
 rename Documentation/xilinx/{eemi.txt => eemi.rst} (92%)
 create mode 100644 Documentation/xilinx/index.rst

-- 
2.21.0


