Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0505E39815E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFBGtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhFBGtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:49:07 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B4EC061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 23:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1622616441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BB+iaYp4LyFwJ9jGzQ7cmHxv8GHima8n/NGSOQHI0s4=;
        b=gT355vjzgjUhPMYzSmsu52NzowUci9aReYxeuOdY53rumwmwnIlHmFV7zxbp3L0MO13Xvx
        yFv+9vinBKDGbb3ceW2yLaxvBhOSSEmFuSVFE/AVpOu47BlATc3eeycsnJL5L5o8KeOsxi
        JHOnvRPq/Ro84nxder7/568C8piQF5c=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next] batman-adv: Fix spelling mistakes
Date:   Wed, 02 Jun 2021 08:47:18 +0200
Message-ID: <48077100.4opSpZgCWW@ripper>
In-Reply-To: <20210602065603.106030-1-zhengyongjun3@huawei.com>
References: <20210602065603.106030-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart35456750.oCVJAORbYE"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart35456750.oCVJAORbYE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH net-next] batman-adv: Fix spelling mistakes
Date: Wed, 02 Jun 2021 08:47:18 +0200
Message-ID: <48077100.4opSpZgCWW@ripper>
In-Reply-To: <20210602065603.106030-1-zhengyongjun3@huawei.com>
References: <20210602065603.106030-1-zhengyongjun3@huawei.com>

On Wednesday, 2 June 2021 08:56:03 CEST Zheng Yongjun wrote:
> Fix some spelling mistakes in comments:
> containg  ==> containing
> dont  ==> don't
> datas  ==> data
> brodcast  ==> broadcast
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/batman-adv/bridge_loop_avoidance.c | 4 ++--
>  net/batman-adv/hard-interface.c        | 2 +-
>  net/batman-adv/hash.h                  | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)


You forgot to send it to the B.A.T.M.A.N. mailing list. And it therefore 
didn't appear in our patchwork. And you send stuff from the future - which is 
rather odd.

Applied anyway.

Thanks,
	Sven

--nextPart35456750.oCVJAORbYE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmC3KXYACgkQXYcKB8Em
e0YXng//aLzrW36XvD5wdUTS/jlzrlxggP0i3YehwpVFOiSon6nDcxoAjjMij3qa
8kJKrY1cjoVgQe93P6fc0nYb+UWwwbKEE9fOHw/FYIa6qU9XwfWN3MjbVAy0HEfr
0OyBtx4o5MFA34uTCtxaE4TFXIn6am5P2U4u7rGLn9LejE1e0lfpWRUf3Wam/8Hg
Mm681yStajB159NrEjVa6YnagZhqNI47U7mId+ZfAGjeHaGQX16p6NUD654+CtPW
1P56KmH9p5JmKu1bbeUxXTaEq199I2GTsZUGZli6M6dcWaqcr2ILj6RV2G1y9vEK
vltKRHnRo3vUlbONLgiCc6TwX+CZwf0D9fn4y5Fbhpwg+SKlMeTYoIsH36Q/VkQk
kX+/iYT6WU+uQAnVcnYz9rAU6VIpkY2Gfnv9oDv5M1I653ySRY7x+5BnQBnUMCp4
TYfojqC3Yd5U/RbT5giP+qh2yB88cBq26oxUDVEPs6VMQegcju3RBnh85rT/Iqav
7pdWoLJicoB9ycbf8QFiwj8UcvEdXQKXdblkmCExuqG2BN2ln5G8GBK5PqOUenuJ
3aozntk641U3swH54hjFP+c4ZyxVASGILANTHJk+HoM0x4aGQKABPGacO39V9oK9
SkgMX8p285zxHwXICiCZGCt664FYBz9bUk1+Q9uc8bxj9mlSU/0=
=+Ayg
-----END PGP SIGNATURE-----

--nextPart35456750.oCVJAORbYE--



