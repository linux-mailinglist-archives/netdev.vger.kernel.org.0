Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A129C6155BC
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiKAXFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiKAXFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:05:03 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22DFD60C9;
        Tue,  1 Nov 2022 16:04:59 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id AF4234ED4;
        Wed,  2 Nov 2022 00:04:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1667343895;
        bh=PkAWXYqxDceSEZsozbKBt1CBt2T3QIdB9eUX7dEkLmg=;
        h=Date:From:Cc:Subject:From;
        b=TSFhvujd2SRCajv7R8zAVm+EuCS5Vh7AysxBgNGEvWADxkrv9qvgHW9m2Cdb5trJp
         FcE+jF2i19LfTk6JQymlUrtpA5eztwtCkCW8RPcFjBKvB3hshGqRsE2JLsnEq4c+nt
         fvOcsrVyWl6I3C7+O8ulD+J/uGCDcWkdGGyHAbMjg2XuyGAULVV6M5ev6enMVnJyMZ
         NpHKD/PHQXItBON7xEKyVBFEn3I+Z5iNjue4c8/MPBye67rmFrh9SmPZflFbbBds30
         ZAAK3IJMi3raN0h2I2WngCjORr/19e40LKbQPzDK+YXi2BeaaavH1sQfTi3aZt5397
         Qawk3vmFpnCfw55RRNhmkJYixnh7hC5YaXFDUd1ehSoOfUGmJmHx285PCPzLeNK1r/
         S2Dx46EXuZjQBL1i55lpJBrvcVXafn20zW6BaOUjdwJMmUIOkOh3DGKcJk8s4+cjPI
         mipGk4QQ1v5t62MLsoj8cvueYNv+CJM/Ih0/DeztWwJaszMjD8DTbZGMgb7nP9BUhW
         EHbs9bnZ2x74ARL2YaVpsuzPJvBZdAml5lxmc3bk/XXIrmQ1fhsWVDT4TA05dRBjC7
         Nzk6xVMZQgXuUqusuxaqwO/RCzMIWPwHEqHUffPdMcQaLnP6IvXtGDSMazKaLWsq8H
         VqbmW62LOL0tiz4CJSy5rq44=
Date:   Wed, 2 Nov 2022 00:04:54 +0100
From:   Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= 
        <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-arm-kernel@lists.infradead.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 00/15] magic-number.rst funeral rites
Message-ID: <cover.1667330271.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="epsbez2xcv56ijjf"
Content-Disposition: inline
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,MISSING_HEADERS,PDS_OTHER_BAD_TLD,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--epsbez2xcv56ijjf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is a follow-up for the 18+1-patch series (
https://lore.kernel.org/linux-kernel/8389a7b85b5c660c6891b1740b5dacc53491a4=
1b.1663280877.git.nabijaczleweli@nabijaczleweli.xyz/
https://lore.kernel.org/linux-kernel/20220927003727.slf4ofb7dgum6apt@tarta.=
nabijaczleweli.xyz/
) I sent in September, and the same reasoning applies:

The entire file blames back to the start of git
(minus whitespace from the RST translation and a typo fix):
  * there are changelog comments for March 1994 through to Linux 2.5.74
  * struct tty_ldisc is two pointers nowadays, so naturally no magic
  * GDA_MAGIC is defined but unused, and it's been this way
    since start-of-git
  * M3_CARD_MAGIC isn't defined, because
    commit d56b9b9c464a ("[PATCH] The scheduled removal of some OSS
    drivers") removed the entire driver in 2006
  * CS_CARD_MAGIC likewise since
    commit b5d425c97f7d ("more scheduled OSS driver removal") in 2007
  * KMALLOC_MAGIC and VMALLOC_MAGIC were removed in
    commit e38e0cfa48ac ("[ALSA] Remove kmalloc wrappers"),
    six months after start of git
  * SLAB_C_MAGIC has never even appeared in git
    (removed in 2.4.0-test3pre6)
  * &c., &c., &c.

magic-number.rst is a low-value historial relic at best and misleading
cruft at worst.

This latter half cleans out the remaining entries (either by recognising
that they aren't actually magic numbers or by cutting them out entirely)
and inters the file.

amd64 allyesconfig builds; this largely touches code that would be
exceedingly expensive to test (and largely untouched since the git
import), but is very receptive to static analysis.

v2:
  Messages restyled
  Moved printk() in synclink_cs.c became pr_warn
  (__func__ instead of prescribed hard function name per checkpatch.pl)

Ahelenia Ziemia=C5=84ska (15):
  hamradio: baycom: remove BAYCOM_MAGIC
  hamradio: yam: remove YAM_MAGIC
  pcmcia: synclink_cs: remove MGSLPC_MAGIC
  pcmcia: synclink_cs: remove dead paranoia_check, warn for missing line
  coda: remove CODA_MAGIC
  Documentation: remove PG_MAGIC (not a magic number)
  MIPS: IP27: clean out sn/nmi.h
  MIPS: IP27: remove KV_MAGIC
  x86/APM: remove APM_BIOS_MAGIC
  scsi: acorn: remove QUEUE_MAGIC_{FREE,USED}
  hdlcdrv: remove HDLCDRV_MAGIC
  drivers: net: slip: remove SLIP_MAGIC
  fcntl: remove FASYNC_MAGIC
  scsi: ncr53c8xx: replace CCB_MAGIC with bool busy
  Documentation: remove magic-number.rst

 Documentation/process/index.rst               |  1 -
 Documentation/process/magic-number.rst        | 85 -----------------
 .../translations/it_IT/process/index.rst      |  1 -
 .../it_IT/process/magic-number.rst            | 91 -------------------
 .../translations/zh_CN/process/index.rst      |  1 -
 .../zh_CN/process/magic-number.rst            | 74 ---------------
 .../translations/zh_TW/process/index.rst      |  1 -
 .../zh_TW/process/magic-number.rst            | 77 ----------------
 arch/mips/include/asm/sn/klkernvars.h         |  8 +-
 arch/mips/include/asm/sn/nmi.h                | 60 ------------
 arch/mips/sgi-ip27/ip27-klnuma.c              |  1 -
 arch/x86/kernel/apm_32.c                      |  9 +-
 drivers/char/pcmcia/synclink_cs.c             | 79 +---------------
 drivers/net/hamradio/baycom_epp.c             | 15 +--
 drivers/net/hamradio/baycom_par.c             |  1 -
 drivers/net/hamradio/baycom_ser_fdx.c         |  3 +-
 drivers/net/hamradio/baycom_ser_hdx.c         |  3 +-
 drivers/net/hamradio/hdlcdrv.c                |  9 +-
 drivers/net/hamradio/yam.c                    |  8 +-
 drivers/net/slip/slip.c                       | 11 +--
 drivers/net/slip/slip.h                       |  4 -
 drivers/scsi/arm/queue.c                      | 21 -----
 drivers/scsi/ncr53c8xx.c                      | 25 ++---
 fs/coda/cnode.c                               |  2 +-
 fs/coda/coda_fs_i.h                           |  2 -
 fs/coda/file.c                                |  1 -
 fs/fcntl.c                                    |  6 --
 include/linux/fs.h                            |  3 -
 include/linux/hdlcdrv.h                       |  2 -
 29 files changed, 29 insertions(+), 575 deletions(-)
 delete mode 100644 Documentation/process/magic-number.rst
 delete mode 100644 Documentation/translations/it_IT/process/magic-number.r=
st
 delete mode 100644 Documentation/translations/zh_CN/process/magic-number.r=
st
 delete mode 100644 Documentation/translations/zh_TW/process/magic-number.r=
st

--=20
2.30.2

--epsbez2xcv56ijjf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNhphIACgkQvP0LAY0m
WPHX3w//eCKxL28PXY15VC7spPr1aftrAychBKxXUo24FVkq0kZeKR7+UGLbL0/c
luGQoQrpIL2DNgS22EJmKh2kR9ilQe3EIWWWG6R77YUl3kjTKNYG9YcsttrVgzbO
n1M5Bu/YlJcd+ZYZEqZ3oz7Tp4apHEdqFE7qRKVDhYq9F/wwKXFUN7AAaMEG/A7G
9u3NjWCOSD+xX03GE8JJFd3CZBSLurvtBGO6YuTQayjp/VViUpIC9dofuVN4Ugva
0+tlKlnVnYcFfeij5vOIjKrj+PE50c7TV4FQwetNf3T87b/D7opLKeour7Tf9l+a
kT00fjG7zKCv9uFbjG95SkSe4e58PfT3icgXYd74vqEda5AJJuXUXTqDqSGcMgPu
361QK4YwSq2iS8h70Fg204vmpjfcqA7Jst7C44FE7bbEFTbmDTXqNvnztLOxtJXQ
XtmUUr2Ta+bRcNN3dQ5SLGisXvAtBbLQKaB5xBtOnAfMGO544sJ3K0t5ZzlsQqVI
Ncw9SRZmnbQvDQJcaJI8ferdn1I7nZw8PtI8toOD3dC3zyXrTexcdtOzpjD5rlyJ
V9KlBJ8svIf8N0hXSpPBSOfAYCJBkPJz+GIw+2RTj4HRKlcTD52JbbUaoBuifd+q
wbrU4TONKAq3yrRweH0aH8HPDRVOm1mva4vGcFM1AM6Nbx5k7xM=
=8xd9
-----END PGP SIGNATURE-----

--epsbez2xcv56ijjf--
