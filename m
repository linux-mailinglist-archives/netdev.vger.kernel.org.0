Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D871251129
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgHYE4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:56:51 -0400
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:35610 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgHYE4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:56:46 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id B846B180A9F54;
        Tue, 25 Aug 2020 04:56:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:857:966:967:973:988:989:1260:1311:1314:1345:1437:1515:1535:1544:1711:1730:1747:1777:1792:1801:2196:2199:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3865:3867:3868:3870:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4384:4385:4395:4605:5007:6119:6261:6737:6742:7875:9025:10004:10848:11026:11473:11658:11914:12043:12048:12050:12297:12438:12555:12679:12895:12986:13161:13229:13894:14096:14181:14394:14721:21080:21433:21451:21627:21740:21773:30054:30056,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: chalk60_631385f27059
X-Filterd-Recvd-Size: 5825
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 04:56:38 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jiri Kosina <trivial@kernel.org>, oprofile-list@lists.sf.net,
        linux-ide@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
        linux-bcache@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH 00/29] treewide: Convert comma separated statements
Date:   Mon, 24 Aug 2020 21:55:57 -0700
Message-Id: <cover.1598331148.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many comma separated statements in the kernel.
See:https://lore.kernel.org/lkml/alpine.DEB.2.22.394.2008201856110.2524@hadrien/

Convert the comma separated statements that are in if/do/while blocks
to use braces and semicolons.

Many comma separated statements still exist but those are changes for
another day.

Joe Perches (29):
  coding-style.rst: Avoid comma statements
  alpha: Avoid comma separated statements
  ia64: Avoid comma separated statements
  sparc: Avoid comma separated statements
  ata: Avoid comma separated statements
  drbd: Avoid comma separated statements
  lp: Avoid comma separated statements
  dma-buf: Avoid comma separated statements
  drm/gma500: Avoid comma separated statements
  drm/i915: Avoid comma separated statements
  hwmon: (scmi-hwmon): Avoid comma separated statements
  Input: MT - Avoid comma separated statements
  bcache: Avoid comma separated statements
  media: Avoid comma separated statements
  mtd: Avoid comma separated statements
  8390: Avoid comma separated statements
  fs_enet: Avoid comma separated statements
  wan: sbni: Avoid comma separated statements
  s390/tty3270: Avoid comma separated statements
  scai/arm: Avoid comma separated statements
  media: atomisp: Avoid comma separated statements
  video: fbdev: Avoid comma separated statements
  fuse: Avoid comma separated statements
  reiserfs: Avoid comma separated statements
  lib/zlib: Avoid comma separated statements
  lib: zstd: Avoid comma separated statements
  ipv6: fib6: Avoid comma separated statements
  sunrpc: Avoid comma separated statements
  tools: Avoid comma separated statements

 Documentation/process/coding-style.rst        |  17 +
 arch/alpha/kernel/pci_iommu.c                 |   8 +-
 arch/alpha/oprofile/op_model_ev4.c            |  22 +-
 arch/alpha/oprofile/op_model_ev5.c            |   8 +-
 arch/ia64/kernel/smpboot.c                    |   7 +-
 arch/sparc/kernel/smp_64.c                    |   7 +-
 drivers/ata/pata_icside.c                     |  21 +-
 drivers/block/drbd/drbd_receiver.c            |   6 +-
 drivers/char/lp.c                             |   6 +-
 drivers/dma-buf/st-dma-fence.c                |   7 +-
 drivers/gpu/drm/gma500/mdfld_intel_display.c  |  44 ++-
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c          |   8 +-
 drivers/gpu/drm/i915/gt/intel_gt_requests.c   |   6 +-
 .../gpu/drm/i915/gt/selftest_workarounds.c    |   6 +-
 drivers/gpu/drm/i915/intel_runtime_pm.c       |   6 +-
 drivers/hwmon/scmi-hwmon.c                    |   6 +-
 drivers/input/input-mt.c                      |  11 +-
 drivers/md/bcache/bset.c                      |  12 +-
 drivers/md/bcache/sysfs.c                     |   6 +-
 drivers/media/i2c/msp3400-kthreads.c          |  12 +-
 drivers/media/pci/bt8xx/bttv-cards.c          |   6 +-
 drivers/media/pci/saa7134/saa7134-video.c     |   7 +-
 drivers/mtd/devices/lart.c                    |  10 +-
 drivers/net/ethernet/8390/axnet_cs.c          |  19 +-
 drivers/net/ethernet/8390/lib8390.c           |  14 +-
 drivers/net/ethernet/8390/pcnet_cs.c          |   6 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |  11 +-
 drivers/net/wan/sbni.c                        | 101 +++---
 drivers/s390/char/tty3270.c                   |   6 +-
 drivers/scsi/arm/cumana_2.c                   |  19 +-
 drivers/scsi/arm/eesox.c                      |   9 +-
 drivers/scsi/arm/powertec.c                   |   9 +-
 .../media/atomisp/pci/atomisp_subdev.c        |   6 +-
 drivers/video/fbdev/tgafb.c                   |  12 +-
 fs/fuse/dir.c                                 |  24 +-
 fs/reiserfs/fix_node.c                        |  36 ++-
 lib/zlib_deflate/deftree.c                    |  49 ++-
 lib/zstd/compress.c                           | 120 ++++---
 lib/zstd/fse_compress.c                       |  24 +-
 lib/zstd/huf_compress.c                       |   6 +-
 net/ipv6/ip6_fib.c                            |  12 +-
 net/sunrpc/sysctl.c                           |   6 +-
 tools/lib/subcmd/help.c                       |  10 +-
 tools/power/cpupower/utils/cpufreq-set.c      |  14 +-
 tools/testing/selftests/vm/gup_benchmark.c    |  18 +-
 tools/testing/selftests/vm/userfaultfd.c      | 296 +++++++++++-------
 46 files changed, 694 insertions(+), 382 deletions(-)

-- 
2.26.0

