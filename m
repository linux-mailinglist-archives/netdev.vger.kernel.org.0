Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287D7F5A21
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbfKHVf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:35:56 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:33583 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387700AbfKHVf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:35:56 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MXXdn-1iQ6AP0R4R-00YveV; Fri, 08 Nov 2019 22:33:06 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        jdike@addtoit.com, richard@nod.at, jcmvbkbc@gmail.com,
        stefanr@s5r6.in-berlin.de, l.stach@pengutronix.de,
        linux+etnaviv@armlinux.org.uk, christian.gmeiner@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, robdclark@gmail.com,
        sean@poorly.run, valdis.kletnieks@vt.edu,
        gregkh@linuxfoundation.org, ccaulfie@redhat.com,
        teigland@redhat.com, hirofumi@mail.parknet.co.jp, jack@suse.com,
        davem@davemloft.net, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, willemb@google.com,
        viro@zeniv.linux.org.uk, rfontana@redhat.com, tglx@linutronix.de,
        linux-um@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
        devel@driverdev.osuosl.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 00/16] drivers: y2038 updates
Date:   Fri,  8 Nov 2019 22:32:38 +0100
Message-Id: <20191108213257.3097633-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cC60oL5qW9T6f3VnEX4IUPUnbZtH58Z5jHTCkfEP3lSVCyJMvvf
 nXa+3lb+MuvX4UyJFUN+jNUJOtYV6vEdBeRluSdOxKcMLTIRW/MA2X5WNg5vjL4h5VMaMqq
 bNkxydHkOOB1gWSeiigewsSsL+Ope/gjBqLstKOktXFNHvIvAI8OyB16Bh3/KHWq5bI5gbP
 ttyknhIOC7MVt+zSJY39Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:C6N/AXULkaM=:Y7JwaiMRl7Ar2O9O2mXFFn
 XNkpKgwWM8P0qO+0Is3DdFORJejcsg4Z7H/JEbKB71PaPIxwYqUaCL54KvYWbGI4UgpeJv2VL
 TDM5JP6XHLZEPg418lMXvJDgfjoG3Hi8z6xcm4eVCYMVOopNmDKLw8sRTvZs5Y9MehLPeuCjA
 FJDznxm+bmmpVwkpxdVxGg/UsFc/GByVXrqgr8aIeNTyU+6QiRoIugryzBDmS8vQIcTfTmtwM
 Xis+iVVThIPm/7TlELGn4QUpWrGuBM87bpEytZmN7iZ2Xv4Pi09GCc0fWAfdVlykCBom4fWhN
 SzMqNyByMJJu1qqSoOmRZIb/A06TGj1hHe1DR8fSuMXOJgyyZG4W2LkZTNTrG0kWBaTiNY4qD
 FOQ5PN5Ds9rUxxJ5jvFQEnBCHs0boCj+R1ogKQHj961SNOjz/iTK9PRAJ2Q/S9lr1OiO0Aill
 9n9w+FUDSA0uaCjboLcZG7ZPwbRrutTP1fW0uPjb2lcWPcBIloby7q+PHrtvR5VMW5jiv1fmf
 hfT7ITXtJL4SPQ1ZG94BaqALxufFNPlW7b2L8+b77UeY7PzZf7Q27rY8HVKNoecjq4sWzCpXp
 sCo16dBMR11yeGV02rWBECYG21JJTtOeHNbls/EWzI9gHEegxzRctljs0BXpmtr3fDrj8dL0R
 TjY2ibzd1SUcPAPXUGKnTI3EjBlBn5NTJbwUJGVyl+zhLeAtQdCVVn9ZET82XUaihtFVsb6l/
 VlZeLSfRYEOZKFWPEnJYv06Nf3Nrd84B+GWSJ7z9QIE1YkNSFvSz0y/FFznyuSImBN+NzxHxs
 7v0SH2wqAYB54MS6c3rahz8Oz2PuxEdQKh0LU5tG8fz8w3hUaZHnsrADS9CMXvPoTccssMd61
 Ly+JSeRt68rTP+cnNhXA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are updates to devidce drivers and file systems that for some
reason or another were not included in the kernel in the previous
y2038 series.

I've gone through all users of time_t again to make sure the
kernel is in a long-term maintainable state.

Posting these as a series for better organization, but each change
here is applicable standalone.

Please merge, review, ack/nack etc as you see fit. My plan is to
include any patches that don't get a reply this time around in
a future pull request, probably for linux-5.6.

As mentioned before, the full series of 90 patches is available at
https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame

    Arnd

Arnd Bergmann (16):
  staging: exfat: use prandom_u32() for i_generation
  fat: use prandom_u32() for i_generation
  net: sock: use __kernel_old_timespec instead of timespec
  dlm: use SO_SNDTIMEO_NEW instead of SO_SNDTIMEO_OLD
  xtensa: ISS: avoid struct timeval
  um: ubd: use 64-bit time_t where possible
  acct: stop using get_seconds()
  tsacct: add 64-bit btime field
  netfilter: nft_meta: use 64-bit time arithmetic
  packet: clarify timestamp overflow
  quota: avoid time_t in v1_disk_dqblk definition
  hostfs: pass 64-bit timestamps to/from user space
  hfs/hfsplus: use 64-bit inode timestamps
  drm/msm: avoid using 'timespec'
  drm/etnaviv: use ktime_t for timeouts
  firewire: ohci: stop using get_seconds() for BUS_TIME

 arch/um/drivers/cow.h                         |  2 +-
 arch/um/drivers/cow_user.c                    |  7 +++--
 arch/um/drivers/ubd_kern.c                    | 10 +++----
 arch/um/include/shared/os.h                   |  2 +-
 arch/um/os-Linux/file.c                       |  2 +-
 .../platforms/iss/include/platform/simcall.h  |  4 +--
 drivers/firewire/ohci.c                       |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c         | 19 ++++++-------
 drivers/gpu/drm/etnaviv/etnaviv_drv.h         | 21 ++++++--------
 drivers/gpu/drm/etnaviv/etnaviv_gem.c         |  5 ++--
 drivers/gpu/drm/etnaviv/etnaviv_gem.h         |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c         |  4 +--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h         |  4 +--
 drivers/gpu/drm/msm/msm_drv.h                 |  3 +-
 drivers/staging/exfat/exfat_super.c           |  4 +--
 fs/dlm/lowcomms.c                             |  6 ++--
 fs/fat/inode.c                                |  3 +-
 fs/hfs/hfs_fs.h                               | 26 +++++++++++++----
 fs/hfs/inode.c                                |  4 +--
 fs/hfsplus/hfsplus_fs.h                       | 26 +++++++++++++----
 fs/hfsplus/inode.c                            | 12 ++++----
 fs/hostfs/hostfs.h                            | 22 +++++++++------
 fs/hostfs/hostfs_kern.c                       | 15 ++++++----
 fs/quota/quotaio_v1.h                         |  6 ++--
 include/linux/skbuff.h                        |  7 +++--
 include/uapi/linux/acct.h                     |  2 ++
 include/uapi/linux/taskstats.h                |  6 +++-
 kernel/acct.c                                 |  4 ++-
 kernel/tsacct.c                               |  9 ++++--
 net/compat.c                                  |  2 +-
 net/ipv4/tcp.c                                | 28 +++++++++++--------
 net/netfilter/nft_meta.c                      | 10 +++----
 net/packet/af_packet.c                        | 27 +++++++++++-------
 net/socket.c                                  |  2 +-
 34 files changed, 184 insertions(+), 124 deletions(-)

-- 
2.20.0

Cc: jdike@addtoit.com
Cc: richard@nod.at
Cc: jcmvbkbc@gmail.com
Cc: stefanr@s5r6.in-berlin.de
Cc: l.stach@pengutronix.de
Cc: linux+etnaviv@armlinux.org.uk
Cc: christian.gmeiner@gmail.com
Cc: airlied@linux.ie
Cc: daniel@ffwll.ch
Cc: robdclark@gmail.com
Cc: sean@poorly.run
Cc: valdis.kletnieks@vt.edu
Cc: gregkh@linuxfoundation.org
Cc: ccaulfie@redhat.com
Cc: teigland@redhat.com
Cc: hirofumi@mail.parknet.co.jp
Cc: jack@suse.com
Cc: davem@davemloft.net
Cc: edumazet@google.com
Cc: pablo@netfilter.org
Cc: kadlec@netfilter.org
Cc: fw@strlen.de
Cc: willemb@google.com
Cc: viro@zeniv.linux.org.uk
Cc: rfontana@redhat.com
Cc: tglx@linutronix.de
Cc: linux-um@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net
Cc: etnaviv@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org>
Cc: linux-arm-msm@vger.kernel.org>
Cc: freedreno@lists.freedesktop.org>
Cc: devel@driverdev.osuosl.org>
Cc: cluster-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org>
Cc: netdev@vger.kernel.org>
Cc: netfilter-devel@vger.kernel.org>
Cc: coreteam@netfilter.org>
