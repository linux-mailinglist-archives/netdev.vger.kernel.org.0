Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BBC130439
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgADT4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:56:08 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:48612 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgADT4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1578167764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UqiZRCJx1oOd2eCd6cVZ2EAaLCuKduqQh59G4MIC1hI=;
        b=N1dTr9LKpmbUm7jhHLkkAnSn4Uk0IqVABlm7QBukSZ6fiZ4vRyb1FBVnUMFlCclwuXXZBs
        Qs/8lHhZ5okHVrmW+zHFlNga0CODN/5lEd+nPh2WpPavaDxm2l8AtpAymxY0O+OHx9Jeaq
        96IXxU+T4mlDeBY0Zp8kN5wwL+CkiUg=
From:   Sven Eckelmann <sven@narfation.org>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 4/8] net: ipv4: use netdev_info()/netdev_warn()
Date:   Sat, 04 Jan 2020 20:55:56 +0100
Message-ID: <1717918.JrPmCOKjZS@sven-edge>
In-Reply-To: <20200104195131.16577-4-info@metux.net>
References: <20200104195131.16577-1-info@metux.net> <20200104195131.16577-4-info@metux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6903353.xe3xGztRYD"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart6903353.xe3xGztRYD
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Saturday, 4 January 2020 20:51:27 CET Enrico Weigelt, metux IT consult wrote:
> Use netdev_info() / netdev_warn() instead of pr_info() / pr_warn()
> for more consistent log output.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---

Patch description has nothing to do with the actual patch.

Kind regards,
	Sven

>  net/ipv4/tcp_cubic.c    | 1 -
>  net/ipv4/tcp_illinois.c | 1 -
>  net/ipv4/tcp_nv.c       | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
> index 1b3d032a4df2..83fda965186d 100644
> --- a/net/ipv4/tcp_cubic.c
> +++ b/net/ipv4/tcp_cubic.c
> @@ -513,4 +513,3 @@ module_exit(cubictcp_unregister);
>  MODULE_AUTHOR("Sangtae Ha, Stephen Hemminger");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("CUBIC TCP");
> -MODULE_VERSION("2.3");
> diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
> index 00e54873213e..8cc9967e82ef 100644
> --- a/net/ipv4/tcp_illinois.c
> +++ b/net/ipv4/tcp_illinois.c
> @@ -355,4 +355,3 @@ module_exit(tcp_illinois_unregister);
>  MODULE_AUTHOR("Stephen Hemminger, Shao Liu");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("TCP Illinois");
> -MODULE_VERSION("1.0");
> diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
> index 95db7a11ba2a..b3879fb24d33 100644
> --- a/net/ipv4/tcp_nv.c
> +++ b/net/ipv4/tcp_nv.c
> @@ -499,4 +499,3 @@ module_exit(tcpnv_unregister);
>  MODULE_AUTHOR("Lawrence Brakmo");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("TCP NV");
> -MODULE_VERSION("1.0");
> 


--nextPart6903353.xe3xGztRYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl4Q7cwACgkQXYcKB8Em
e0b7FxAApnNZqwnoUYpozOR6QRqjuLfnrOtYC07Y0PGVBxHQPzwQKI1qrHS5pnJY
pRHVwNNnRqXnCj5Age/miVF5AZGtrHCJDHR/5lciyHudORjk3RXOizXUD2Jc6ksj
ZNjSdQQqwyDGEsh4YYMPpGx6IsnXFSflYPulIOrAr1ekbrJr+4LUh2AtzzORwB7f
nsGBypPneKIfOWl4kWQkPUtqIPQVyjZhCezTaZTcyDgvKPbltdJGZC6f93iC2W6/
rwT86Fd7zJm7EvMlEC/3w6myVqyCgUJUID6bY9qEkn1X1qLESVYo+UTVkQlo22BG
XRzletVGhxROCI45qZ8tSqUjQ2Nt9exO5hhIxa+Tbl6UrMqjKuPhqiRgu4JjqeVv
Xks7x2aP/xPg74bzGQf0lhCUNSiAXQ99qw+P7J2ZMXR0AXLBL6ocyshKUwT+AVqE
khwBENTIDO8/I9TaPm4dFCNr7gXJQiRCs/NiAZgCxZUgvPNMOBCDeQQh3oarvnLf
IlyzO94Zbv57AYkM7zdLaLRLsqS8vdUSPFILSbFYXUU+tqH9F3loFgfic4e57h2l
zEawSvYrME9uIOu5dfbpZ4uw7WHzC2CeHWLytnaxhwJYAntZaqHaTwU0l0N3v8sz
+epMGNYt+x8KRnthWBBYtK52trmTOXNT9pIUolp+LBDzeZre9Gc=
=SIfr
-----END PGP SIGNATURE-----

--nextPart6903353.xe3xGztRYD--



