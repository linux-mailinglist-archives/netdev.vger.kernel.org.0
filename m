Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB4C1A8648
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502499AbgDNQzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440299AbgDNQtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 12:49:08 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BDD20787;
        Tue, 14 Apr 2020 16:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586882942;
        bh=hpU3ilpDhIBh1EkpHoT8CRglKxDNGuySrswIRHuRmXU=;
        h=From:To:Cc:Subject:Date:From;
        b=qP/fh2JuBrTWMBDU0Po9QgHcYacrRlFhnHwEY8en7h953JH1K2J6xRWgtWi+ouXIY
         3gGiDenojv2rrUzJ4Wxk3whARW64aaikv0MOeHbofi1sPuRVe5IZT8BpzPaRPNxcO+
         07Ps8XSWU9UmRtIfijlblMPlQG+5+iBYwuA7KjAY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jOOk8-0068kv-FR; Tue, 14 Apr 2020 18:49:00 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Yuti Amonkar <yamonkar@cadence.com>,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-afs@lists.infradead.org,
        ecryptfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-pci@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-spi@vger.kernel.org,
        Sandeep Maheswaram <sanm@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        linux-usb@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [PATCH v2 00/33] Documentation fixes for Kernel 5.8
Date:   Tue, 14 Apr 2020 18:48:26 +0200
Message-Id: <cover.1586881715.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches 1 to 5 contain changes to the documentation toolset:

- The first 3 patches help to reduce a lot the number of reported
  kernel-doc issues, by making the tool more smart.

- Patches 4 and 5 are meant to partially address the PDF
  build, with now requires Sphinx version 2.4 or upper.

The remaining patches fix broken references detected by
this tool:

        ./scripts/documentation-file-ref-check

and address other random errors due to tags being mis-interpreted
or mis-used.

They are independent each other, but some may depend on
the kernel-doc improvements.

PS.: Due to the large number of C/C, I opted to keep a smaller
set of C/C at this first e-mail (only e-mails with "L:" tag from
MAINTAINERS file).

Jon,

Those patches should apply cleanly at docs-next, once you
pull from v5.7-rc1.


-

v2:

- patches re-ordered;
- added reviewed/acked-by tags;
- rebased on the top of docs-next + v5.7-rc1.


Mauro Carvalho Chehab (33):
  scripts: kernel-doc: proper handle @foo->bar()
  scripts: kernel-doc: accept negation like !@var
  scripts: kernel-doc: accept blank lines on parameter description
  docs: update recommended Sphinx version to 2.4.4
  docs: LaTeX/PDF: drop list of documents
  MAINTAINERS: dt: update display/allwinner file entry
  MAINTAINERS: dt: fix pointers for ARM Integrator, Versatile and
    RealView
  docs: dt: fix broken reference to phy-cadence-torrent.yaml
  docs: fix broken references to text files
  docs: fix broken references for ReST files that moved around
  docs: filesystems: fix renamed references
  docs: amu: supress some Sphinx warnings
  docs: arm64: booting.rst: get rid of some warnings
  docs: pci: boot-interrupts.rst: improve html output
  docs: ras: get rid of some warnings
  docs: ras: don't need to repeat twice the same thing
  docs: infiniband: verbs.c: fix some documentation warnings
  docs: spi: spi.h: fix a doc building warning
  docs: drivers: fix some warnings at base/platform.c when building docs
  docs: mm: userfaultfd.rst: use ``foo`` for literals
  docs: mm: userfaultfd.rst: use a cross-reference for a section
  docs: vm: index.rst: add an orphan doc to the building system
  docs: dt: qcom,dwc3.txt: fix cross-reference for a converted file
  docs: dt: fix a broken reference for a file converted to json
  docs: powerpc: cxl.rst: mark two section titles as such
  docs: i2c: rename i2c.svg to i2c_bus.svg
  docs: Makefile: place final pdf docs on a separate dir
  docs: dt: rockchip,dwc3.txt: fix a pointer to a renamed file
  ata: libata-core: fix a doc warning
  firewire: firewire-cdev.hL get rid of a docs warning
  fs: inode.c: get rid of docs warnings
  futex: get rid of a kernel-docs build warning
  lib: bitmap.c: get rid of some doc warnings

 Documentation/ABI/stable/sysfs-devices-node   |   2 +-
 Documentation/ABI/testing/procfs-smaps_rollup |   2 +-
 Documentation/Makefile                        |   6 +-
 Documentation/PCI/boot-interrupts.rst         |  34 +--
 Documentation/admin-guide/cpu-load.rst        |   2 +-
 Documentation/admin-guide/mm/userfaultfd.rst  | 209 +++++++++---------
 Documentation/admin-guide/nfs/nfsroot.rst     |   2 +-
 Documentation/admin-guide/ras.rst             |  18 +-
 Documentation/arm64/amu.rst                   |   5 +
 Documentation/arm64/booting.rst               |  36 +--
 Documentation/conf.py                         |  38 ----
 .../bindings/net/qualcomm-bluetooth.txt       |   2 +-
 .../bindings/phy/ti,phy-j721e-wiz.yaml        |   2 +-
 .../devicetree/bindings/usb/qcom,dwc3.txt     |   4 +-
 .../devicetree/bindings/usb/rockchip,dwc3.txt |   2 +-
 .../doc-guide/maintainer-profile.rst          |   2 +-
 .../driver-api/driver-model/device.rst        |   4 +-
 .../driver-api/driver-model/overview.rst      |   2 +-
 Documentation/filesystems/dax.txt             |   2 +-
 Documentation/filesystems/dnotify.txt         |   2 +-
 .../filesystems/ramfs-rootfs-initramfs.rst    |   2 +-
 Documentation/filesystems/sysfs.rst           |   2 +-
 Documentation/i2c/{i2c.svg => i2c_bus.svg}    |   2 +-
 Documentation/i2c/summary.rst                 |   2 +-
 Documentation/memory-barriers.txt             |   2 +-
 Documentation/powerpc/cxl.rst                 |   2 +
 .../powerpc/firmware-assisted-dump.rst        |   2 +-
 Documentation/process/adding-syscalls.rst     |   2 +-
 Documentation/process/submit-checklist.rst    |   2 +-
 Documentation/sphinx/requirements.txt         |   2 +-
 .../it_IT/process/adding-syscalls.rst         |   2 +-
 .../it_IT/process/submit-checklist.rst        |   2 +-
 .../translations/ko_KR/memory-barriers.txt    |   2 +-
 .../translations/zh_CN/filesystems/sysfs.txt  |   8 +-
 .../zh_CN/process/submit-checklist.rst        |   2 +-
 Documentation/virt/kvm/arm/pvtime.rst         |   2 +-
 Documentation/virt/kvm/devices/vcpu.rst       |   2 +-
 Documentation/virt/kvm/hypercalls.rst         |   4 +-
 Documentation/virt/kvm/mmu.rst                |   2 +-
 Documentation/virt/kvm/review-checklist.rst   |   2 +-
 Documentation/vm/index.rst                    |   1 +
 MAINTAINERS                                   |   7 +-
 arch/powerpc/include/uapi/asm/kvm_para.h      |   2 +-
 arch/x86/kvm/mmu/mmu.c                        |   2 +-
 drivers/ata/libata-core.c                     |   2 +-
 drivers/base/core.c                           |   2 +-
 drivers/base/platform.c                       |   6 +-
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      |   2 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |   2 +-
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |   2 +-
 drivers/gpu/drm/Kconfig                       |   2 +-
 drivers/gpu/drm/drm_ioctl.c                   |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h       |   2 +-
 drivers/hwtracing/coresight/Kconfig           |   2 +-
 drivers/infiniband/core/verbs.c               |   7 +-
 drivers/media/v4l2-core/v4l2-fwnode.c         |   2 +-
 fs/Kconfig                                    |   2 +-
 fs/Kconfig.binfmt                             |   2 +-
 fs/adfs/Kconfig                               |   2 +-
 fs/affs/Kconfig                               |   2 +-
 fs/afs/Kconfig                                |   6 +-
 fs/bfs/Kconfig                                |   2 +-
 fs/cramfs/Kconfig                             |   2 +-
 fs/ecryptfs/Kconfig                           |   2 +-
 fs/fat/Kconfig                                |   8 +-
 fs/fuse/Kconfig                               |   2 +-
 fs/fuse/dev.c                                 |   2 +-
 fs/hfs/Kconfig                                |   2 +-
 fs/hpfs/Kconfig                               |   2 +-
 fs/inode.c                                    |   6 +-
 fs/isofs/Kconfig                              |   2 +-
 fs/namespace.c                                |   2 +-
 fs/notify/inotify/Kconfig                     |   2 +-
 fs/ntfs/Kconfig                               |   2 +-
 fs/ocfs2/Kconfig                              |   2 +-
 fs/overlayfs/Kconfig                          |   6 +-
 fs/proc/Kconfig                               |   4 +-
 fs/romfs/Kconfig                              |   2 +-
 fs/sysfs/dir.c                                |   2 +-
 fs/sysfs/file.c                               |   2 +-
 fs/sysfs/mount.c                              |   2 +-
 fs/sysfs/symlink.c                            |   2 +-
 fs/sysv/Kconfig                               |   2 +-
 fs/udf/Kconfig                                |   2 +-
 include/linux/kobject.h                       |   2 +-
 include/linux/kobject_ns.h                    |   2 +-
 include/linux/mm.h                            |   4 +-
 include/linux/relay.h                         |   2 +-
 include/linux/spi/spi.h                       |   1 +
 include/linux/sysfs.h                         |   2 +-
 include/uapi/linux/ethtool_netlink.h          |   2 +-
 include/uapi/linux/firewire-cdev.h            |   2 +-
 include/uapi/linux/kvm.h                      |   4 +-
 include/uapi/rdma/rdma_user_ioctl_cmds.h      |   2 +-
 kernel/futex.c                                |   3 +
 kernel/relay.c                                |   2 +-
 lib/bitmap.c                                  |  27 +--
 lib/kobject.c                                 |   4 +-
 mm/gup.c                                      |  12 +-
 scripts/kernel-doc                            |  41 ++--
 tools/include/uapi/linux/kvm.h                |   4 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c              |   2 +-
 virt/kvm/arm/vgic/vgic.h                      |   4 +-
 104 files changed, 343 insertions(+), 326 deletions(-)
 rename Documentation/i2c/{i2c.svg => i2c_bus.svg} (99%)

-- 
2.25.2


