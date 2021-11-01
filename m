Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10E6441453
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhKAHtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhKAHtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 03:49:06 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7BBC061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 00:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1635752791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMM5VdyfST0WkYFfPCUR+vTsJivHT2VK2DMrXFvwtTA=;
        b=HIW9pF/9/sNYVjUa9VHDta3h+pRHBShB6UAvxCDnSWaFX/FUNXxNQzFajtDOqSHWFxSIH+
        uAoICTZiyFpvkbkRRmwOh1KF6qbK2ZniuwxnVzrCWLlw/frpgU2ICjgrZWuFnMDWVjwzwy
        LpGrmZJhPkd6832ggChPijidDmR/ot4=
From:   Sven Eckelmann <sven@narfation.org>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Antonio Quartulli <antonio@open-mesh.com>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: batman-adv: fix warning in batadv_v_ogm_free
Date:   Mon, 01 Nov 2021 08:46:16 +0100
Message-ID: <3170956.dbteMgFBTL@ripper>
In-Reply-To: <20211101040103.388646-1-mudongliangabcd@gmail.com>
References: <20211101040103.388646-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4506140.dEfYWnWTC4"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4506140.dEfYWnWTC4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Marek Lindner <mareklindner@neomailbox.ch>, Simon Wunderlich <sw@simonwunderlich.de>, Antonio Quartulli <a@unstable.cc>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Dongliang Mu <mudongliangabcd@gmail.com>
Cc: Dongliang Mu <mudongliangabcd@gmail.com>, Antonio Quartulli <antonio@open-mesh.com>, b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: batman-adv: fix warning in batadv_v_ogm_free
Date: Mon, 01 Nov 2021 08:46:16 +0100
Message-ID: <3170956.dbteMgFBTL@ripper>
In-Reply-To: <20211101040103.388646-1-mudongliangabcd@gmail.com>
References: <20211101040103.388646-1-mudongliangabcd@gmail.com>

On Monday, 1 November 2021 05:01:02 CET Dongliang Mu wrote:
> Call Trace:
>  __cancel_work_timer+0x1c9/0x280 kernel/workqueue.c:3170
>  batadv_v_ogm_free+0x1d/0x50 net/batman-adv/bat_v_ogm.c:1076
>  batadv_mesh_free+0x35/0xa0 net/batman-adv/main.c:244
>  batadv_mesh_init+0x22a/0x240 net/batman-adv/main.c:226
>  batadv_softif_init_late+0x1ad/0x240 net/batman-adv/soft-interface.c:804
>  register_netdevice+0x15d/0x810 net/core/dev.c:10229

This is definitely not a backtrace of the current code and its error handling. 
Please check the current code [1] and explain the situation against this 
version.

Kind regards,
	Sven

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/batman-adv/main.c?id=ae0393500e3b0139210749d52d22b29002c20e16#n237
--nextPart4506140.dEfYWnWTC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmF/m0gACgkQXYcKB8Em
e0bxPRAAzrrbbgZ90XBfIGxWDbp9z/P9TzluLSCD7NVCVy2o+23bt8jEsjh762a1
ChAnSLOf7xmtDxc+EubBQOkKFqCWDeVYPo7YiZcnihY+2k4lLdMX8bWo9L5OxwA6
GiJEXk5CHEhh6BUOL1Qv6RsrCfhHowPyi7ycDWiap9g6kwVLQUsthOn0B6quPonx
1AJBfmyHwxY9nyvx0JNP7P6UQkiNzuKVhBJbZnpmAX+AzNEHB10XxyM+kMXXFh1h
JGtsLs0Zcw6yEIwxSxWY4SxBeqK3LV/+9ym/jBGs+aPjgBblYHxndlQeS0+UB52p
/eM4zdnHk2x9rqvaqeikQb3OZw1wN+y73/Xq/z5knyqxABOHQnGE8QoBah3dLiF7
5fFdJZosHvboSV+YWnx79WHzTbBxKdG0/5hHEB0nbFfYfrUzlfkS8NYOqK6aBezC
hAPms928ro8D+AA6kotEYDN41h/Z4LdWOINwBG2za8nfAquPyC4iHCc3WYm4F9w2
QIpp61jkhoawboxtnn6w1n0S3w/ZY4tKL4j/YyBDjRHVZ7g7qDLnMY+yXCkHf6cW
dMHis7OC/Enf0LSN99sbE0R/3aSUBG7m9d1HY4tYZwfYFrPl25vNXXGdPZVf+apT
RMkmifjFyrfQ1rCUpT9OL1Z8hJIQxOXmM4G+ZOG+lGqukOC+5UE=
=QUqO
-----END PGP SIGNATURE-----

--nextPart4506140.dEfYWnWTC4--



