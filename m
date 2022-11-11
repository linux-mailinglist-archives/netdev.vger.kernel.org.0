Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B1C624F44
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiKKBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKKBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:13:39 -0500
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F5AE224;
        Thu, 10 Nov 2022 17:13:38 -0800 (PST)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 82334918;
        Fri, 11 Nov 2022 02:13:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202211; t=1668129214;
        bh=ilUGduLEOs7ZM1kAskrzDNpvJ7eDc5/y3SOXXESYTGw=;
        h=Date:From:Cc:Subject:From;
        b=FkCxNcv8DARzu4hTgKTxYybGTV0gAvdeWdPbJzoK74xOlXN0BBsjbzHIom/lDm5v8
         GqZzlWqksD5ixxvgY+U01byxjfKa7pFMA1iWKRHBUpxmSthi1/gbfuFvdUoY1q0F7o
         R5e/pG22z9qRUJLJIzgZOR722OrdGgSvqQJAYGp4OG3hIKUQJtNxpsvGv/Mj6VrWuY
         JpCSgQjxGCDz/yp/ZiO3hI1dEy3YQiPHBiF6bDykixnHGfgCVGATV1JufPSTcT3OFw
         GlJSk0G6UjO5kSWo1H7vhdmoZI29GLyOA0bbCVDZ0Jzh3GFehd5qqMFcJhuJehKZTO
         plzAPWXELL+qg==
Date:   Fri, 11 Nov 2022 02:13:33 +0100
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
Subject: [PATCH v3 00/15] magic-number.rst funeral rites
Message-ID: <cover.1668128257.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7w2pfo4anlfzv5kh"
Content-Disposition: inline
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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


--7w2pfo4anlfzv5kh
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

v3:
  7/15 no longer cleans out the header that defines NMI_MAGIC

Ahelenia Ziemia=C5=84ska (15):
  hamradio: baycom: remove BAYCOM_MAGIC
  hamradio: yam: remove YAM_MAGIC
  pcmcia: synclink_cs: remove MGSLPC_MAGIC
  pcmcia: synclink_cs: remove dead paranoia_check, warn for missing line
  coda: remove CODA_MAGIC
  Documentation: remove PG_MAGIC (not a magic number)
  Documentation: remove NMI_MAGIC (not a magic number)
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
 28 files changed, 29 insertions(+), 515 deletions(-)
 delete mode 100644 Documentation/process/magic-number.rst
 delete mode 100644 Documentation/translations/it_IT/process/magic-number.r=
st
 delete mode 100644 Documentation/translations/zh_CN/process/magic-number.r=
st
 delete mode 100644 Documentation/translations/zh_TW/process/magic-number.r=
st

--=20
2.30.2

--7w2pfo4anlfzv5kh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNtoboACgkQvP0LAY0m
WPHjGQ//cgXWRlPMxwRzQeiqfWSSphlxTEIc6X/ywh6snFW2V7S9TYAY6yO9XrML
JOJyOiW3JE1PE9LzBhPUdURPtrqrxWQVflm8NqZZC4sUP55HkzU8yWbgbWQ7bPtC
MIGW2cvK2LoWCeUiWvbGCG3vs2NYc7c2hJE2nSj19++1qNaJsw74Kqu1rltowy+L
IQq43OL0DYXVd58vQ2W4EZCG34X1N7BraOLqSAmGw+s1+EtsY7E3gg3jIbKFe1Da
CDWZfCdY1JFOcdjQCLtAik2+ksrMeMfNpQ0+7vUnv2O2rr97KG+gvUnJ3E6CpjL1
ljn9fg9w6lwT6leEuuE4oe7Cqy92/dkIxQceotqcmdKTwRGrWc67+eUR0xYhI4uJ
bcn2Mw3kF//TgoAe7a6F4/eKXpDFNmlmOdadc012Io5kLA3QcvuiCa2OHIEigXaf
wDdNejyg0xTTKgj1rM03yWn3mlC8cop1PB9cBI8iDdWR6k68bVgLc3CywF3bNH5n
dfwXhtAaa2xayfoYuKcvCujj6Gw/HEN90yULvhavmzxk0glmCQazGAdpNlDieaRk
EPEz+tvwGh+KPRrUPoWskwIQNUc5QB4GB3fQPu648OzaNMXqYNyVCqTTzq0CVzkh
5/syI7z1ezbcZePgLwtkLDXmEtxmMZwOaup0oM/4RhpaqBBboo4=
=aIwC
-----END PGP SIGNATURE-----

--7w2pfo4anlfzv5kh--
