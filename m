Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3530F1A97CA
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393843AbgDOJEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:04:36 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:41518 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393831AbgDOJEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1586941449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tVtwvlOsN93bbG9x0uA4RYzVQ7E8MaWkOr3JMOVqIew=;
        b=t4PUxGF66q+sK8FG57Ok5BLQHR3pCRxrdEwBBRvAsKHkHFT007ugssH4rWrDArHFxEljwB
        NEczT77qmd6oqnAlfbBCn+TlitS3ZptlLHjkA1lGla4/xsp7V+OgtX/0dP8zPGF8Axv9kg
        qEbrG0FlOIusx7qJep2lF9RO5GByTjQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] batman-adv: Fix refcnt leak in batadv_show_throughput_override
Date:   Wed, 15 Apr 2020 11:04:02 +0200
Message-ID: <28340414.QPzbqP6r4N@bentobox>
In-Reply-To: <1586939510-69461-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1586939510-69461-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3979470.HMjOjGzVmR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3979470.HMjOjGzVmR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, 15 April 2020 10:31:50 CEST Xiyu Yang wrote:
[...]
> Fix this issue by calling batadv_hardif_put() before the
[...]

Thanks, fixes for batadv_store_throughput_override [1] and 
batadv_show_throughput_override [2] were applied. I've also added the missing 
Fixes: line to both patches.

May I ask whether you are still a user of the deprecated sysfs interface or 
did you find this in an automated fashion?

Thanks,
	Sven

[1] https://git.open-mesh.org/linux-merge.git/commit/cd339d8b14cd895d8333d94d832b05f67f00eefc
[2] https://git.open-mesh.org/linux-merge.git/commit/3d3e548f74fe51aee9a3c9e297518a2655dbc642
--nextPart3979470.HMjOjGzVmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl6WzgIACgkQXYcKB8Em
e0YWYA//cxS1UcxnDCvjyQWGYwFAPix8PLJ9rCp7jlscYfwarzqplrpPvLM6GNkl
O0H1Hh6SEWsyJ4kBdWrcADqHWfhanPco1Bh0o+Oh307JFtlViDVWpZnAKsICz1Hm
X9GsDu1SwkTepf+py6GNUnMJj2FXC/M1bXQJC15t8gAXwVwhQU8VVP9Vq0Hk1c7a
vwKU4vdV1JTix1zzWWDHGHXrMODQMFdOfBMuSS+AdCPONmffbsRzfGw8aJPu/qDW
vdMajAZWgYC9LP4FFZxyK1DLkaEVeVUScobj69RuyxFdZT2dCPakgMeLKZmtLmxt
yCKzxetELw107//zOXbRGqf1R7zTnqj5Zn8DmmNGA8H1EVii1WQhB8M1r17f8ROy
093I3ZgvnCd5T2i7yPWP6BLIHGt6ckIvdqERhw3EV4xTiS5KyWpTRPJ8B0Mqva4y
Us4k+D8EaTrZuwZwCR20DUx2liWsDSoGfWjEJ0ufIPWAe4qTs0f5ZFRbSuQf7FQW
KSLuI1dTEZp3zZH4zMSxhapCLNZt6d/+HRaVWrdr1ZRTXzdqdFNWmZKRUMUpXZYT
pXJNA5PDJBYXRGEfJUsM0/m/B2NDCvfbXSgl0wOsT3kPyZkE93K8szKLJhvbfiCW
gPOrz+UQsl6Sd2i7fKLmC+W01l4DOURUplSyP4HgHL0XnCMz3K4=
=iyC7
-----END PGP SIGNATURE-----

--nextPart3979470.HMjOjGzVmR--



