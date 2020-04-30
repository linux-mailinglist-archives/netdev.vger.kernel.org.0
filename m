Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27AD1C0961
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgD3Vda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:33:30 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45197 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgD3Vd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:33:29 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MmlCY-1imznH36yU-00jrwf; Thu, 30 Apr 2020 23:31:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        James Smart <james.smart@broadcom.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Bob Copeland <me@bobcopeland.com>, Jan Kara <jack@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org,
        linux-karma-devel@lists.sourceforge.net, bpf@vger.kernel.org,
        linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH 00/15] gcc-10 warning fixes
Date:   Thu, 30 Apr 2020 23:30:42 +0200
Message-Id: <20200430213101.135134-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:d0r1T0atJ0fP6VC0lsoU2Nb50uVHm7+C7HFBKxo5Oh9FT7cjF4F
 56LFacsuF89qNSNIhAKt16YSLWAlWssvN8MtPe8NN45LaPwc/cCelzxDkHr4+0tFL6+Sa9G
 a57V34rwqixwafD6sE/njElSMiK55+3n3WBVw4f5PpMdpEy2CNFI8yBkDaQox92MxOq478P
 ATheht8WQuHpTQRLL5ZEQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qtjOffXScL0=:Yde/YTTIyDLV71HcVFV/g8
 5aCgJ4X4xNzxI3sDnVHzb+4x1iuaUyj/FDU6axm1cC5dNjOHg+8xAyvhGoryNPJJFdXCQ9E8u
 /vBjaVgpQi6NvTWJp+z0wFIoWkqjlRGR2wCLBCvG5ImhRZo6H4jl5uiqg/TUea1BRC5KOAUug
 NLH3+1SoQ96QZaVVmYPbql6nsHgFb4uZYdjCp8JTVI2L30Rp4+0Uw3uwnSsZJuLBGqAnsFaeh
 k7gAnZ02jIaJcsH2V+TwomCcLBG4OX9P3yetdeZWPtDSychl7RC+/gMGRpPt2beTcJXb7Sr4/
 wgqf3CYR6/N2vUz2MhXS9Sl+HtdkF3gKvKsNTp2mw9draDW6IVxA+E16ianBs3s2/Jj86Cp4d
 ehuoj5P2KJYrz+9tZ+et7SchBa5i/iGqThgNGHpUmVXaAI8nZHkjO7rEce0Ctm42WVr0HLTd4
 o1jt4fwG8tpZvziYdVKKK9x4WQWsYAq2xx0LoedsVxg8abX+ql1c1UVSezkM6FJvLsBYSOqLC
 Wl2wmpwXK3rQEhxxX4Sh0+p7vR68f1MiX8v4GGJjHzQvAfDgNp//3vXmnFa9OfQMY1+J5Oamt
 RKC21TWUo81CDfLbGJUutjWh36LNJfa+N4p4bSAvqbx+J8urAAoBgP4lL7BwvnjawPWVT3bQ7
 nx782MGIljH805ldEh/1deDsyPsEUVqES3Wx9pJakt2RNm+5lKUyzj8TLjsuKM9bM+MwiaVGP
 y3sVYv2Jji3wkCZuDo3KR4124HQta8GSeSFOnIEeWuWxcaFbOJf9loaB0IyqLaH/bv1s0C1At
 ctEvneGxLk11FkM6cOL//qiBQ4ws+UB1hR0Fmjp4sHdhGtlvK4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are a couple of fixes for warnings introduced with gcc-10.
If you wish to reproduce these, you can find the compiler I used
at [1].

If you like the fixes, please apply them directly into maintainer
trees. I expect that we will also need them to be backported
into stable kernels later.

I disabled -Wrestrict on gcc in my local test tree, but with
the patches from this series and the ones I have already sent,
I see no gcc-10 specific warnings in linux-next when doing
many randconfig builds for arm/arm64/x86.

      Arnd

Arnd Bergmann (15):
  crypto - Avoid free() namespace collision
  iwlwifi: mvm: fix gcc-10 zero-length-bounds warning
  mwifiex: avoid -Wstringop-overflow warning
  ath10k: fix gcc-10 zero-length-bounds warnings
  bpf: avoid gcc-10 stringop-overflow warning
  netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
  drop_monitor: work around gcc-10 stringop-overflow warning
  usb: ehci: avoid gcc-10 zero-length-bounds warning
  udf: avoid gcc-10 zero-length-bounds warnings
  hpfs: avoid gcc-10 zero-length-bounds warning
  omfs: avoid gcc-10 stringop-overflow warning
  media: s5k5baf: avoid gcc-10 zero-length-bounds warning
  scsi: sas: avoid gcc-10 zero-length-bounds warning
  isci: avoid gcc-10 zero-length-bounds warning
  nvme: avoid gcc-10 zero-length-bounds warning

 crypto/lrw.c                                  |  6 +--
 crypto/xts.c                                  |  6 +--
 drivers/media/i2c/s5k5baf.c                   |  4 +-
 drivers/net/wireless/ath/ath10k/htt.h         |  4 +-
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    | 14 +++----
 .../net/wireless/marvell/mwifiex/sta_cmd.c    | 39 ++++++++-----------
 drivers/nvme/host/fc.c                        |  2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c            |  4 +-
 drivers/scsi/isci/task.h                      |  7 ++--
 drivers/scsi/libsas/sas_task.c                |  3 +-
 fs/hpfs/anode.c                               |  7 +++-
 fs/omfs/file.c                                | 12 +++---
 fs/omfs/omfs_fs.h                             |  2 +-
 fs/udf/ecma_167.h                             |  2 +-
 fs/udf/super.c                                |  2 +-
 include/linux/filter.h                        |  6 +--
 include/linux/usb/ehci_def.h                  | 12 ++++--
 include/net/netfilter/nf_conntrack.h          |  2 +-
 net/core/drop_monitor.c                       | 11 ++++--
 net/netfilter/nf_conntrack_core.c             |  4 +-
 20 files changed, 76 insertions(+), 73 deletions(-)

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/10.0.20200413/

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Jan Kara <jack@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-karma-devel@lists.sourceforge.net
Cc: bpf@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org



-- 
2.26.0

