Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED6E3ECD58
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 05:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhHPDwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 23:52:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60019 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhHPDww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 23:52:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gp0bk11PTz9sWX;
        Mon, 16 Aug 2021 13:52:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629085939;
        bh=o5U4EJAaA4O1nIv/FUMiCariUGAr1fCFYsyQPwcfzvs=;
        h=Date:From:To:Cc:Subject:From;
        b=fuxaRjblG5LxqL8UW3Dlq4MREL+AX0ST6iQmBwqtdRWNHIb/NycYU719TaCtWaJGW
         IUVyk+jlA5rvWO3zghWc6sYPKHCTno4ZFu9HJpXq0pidJ+Q6emKkf1DYLQ5OossOQ+
         EKM5IZvtoiWv11HCZ0HulQUAdmrp/n4WjYyVHlF18HrJ/c3Vaearhvsi8H1nt2r2zf
         m9UK/p0KlheJK49fcwVKS0krD3+9GzLF4RosydGRx8OURGoDzD6UgbwkgijeLkkVUC
         A354TQpTqyEPidsgoZlmhfvaXGr0ysqoyDwOJTs/RiwneZgKOk8CZ2B2z3WFHoeOfL
         BOjklq4UJRegQ==
Date:   Mon, 16 Aug 2021 13:52:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Cai Huoqing <caihuoqing@baidu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the staging tree
Message-ID: <20210816135216.46e50364@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/b/sonLovy7ZsG1_HHN3KZ3C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/b/sonLovy7ZsG1_HHN3KZ3C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/r8188eu/core/rtw_br_ext.c:8:10: fatal error: ../include/net=
/ipx.h: No such file or directory
    8 | #include "../include/net/ipx.h"
      |          ^~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  6c9b40844751 ("net: Remove net/ipx.h and uapi/linux/ipx.h header files")

from the net-next tree.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/b/sonLovy7ZsG1_HHN3KZ3C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEZ4PAACgkQAVBC80lX
0GyrJAf/XFxt/PEXW7pjVXf/w5MZn9lvtoGm/bO9sQ6ei93oegLkbkPMtfVnydZ+
9Do9mLhXCXjE0ivnstYNY9vNMMWtfNJII2SWYdgID96HwzZKU06yNVM3oHI/aFEI
fTsbsPK9GHtyKs8un7u8fytfRQAnkywpeH8pBgvKh51bZ4H242FMZtvh7HiRnVwq
pMunFyESpDR/C1HYXRQrRB5SCh7MHnFEgrBsHeeFUf/lfVuiGnudW+bppchJlDAW
FE39RacQWXz4yhDtqYk9DI0x4sMgT1IrefhuLt7peoIiSO/rejXou4PTrnIE6GX9
WP0eLliqPjrH0mmyn5Uc2CN0LI1wpQ==
=3704
-----END PGP SIGNATURE-----

--Sig_/b/sonLovy7ZsG1_HHN3KZ3C--
