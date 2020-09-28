Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190E127B105
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1PiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:38:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:35232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgI1PiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:38:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7CC30ADA8;
        Mon, 28 Sep 2020 15:38:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 46517603A9; Mon, 28 Sep 2020 17:38:19 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:38:19 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] netlink: fix copy-paste error in
 rtm_link_summary()
Message-ID: <20200928153819.hprdr5cefvnz45gb@lion.mk-sys.cz>
References: <20200925070527.1001190-1-ivecera@redhat.com>
 <20200925070527.1001190-2-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lzpx6ptvjvcqyxgq"
Content-Disposition: inline
In-Reply-To: <20200925070527.1001190-2-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lzpx6ptvjvcqyxgq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2020 at 09:05:27AM +0200, Ivan Vecera wrote:
> Fixes: bdfffab54933 ("netlink: message format descriptions for rtnetlink")
>=20
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---

Applied, thank you.

Michal

>  netlink/prettymsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
> index 9e62bebe615e..f992dcaf071f 100644
> --- a/netlink/prettymsg.c
> +++ b/netlink/prettymsg.c
> @@ -202,7 +202,7 @@ static void rtm_link_summary(const struct ifinfomsg *=
ifinfo)
>  		printf(" ifindex=3D%d", ifinfo->ifi_index);
>  	if (ifinfo->ifi_flags)
>  		printf(" flags=3D0x%x", ifinfo->ifi_flags);
> -	if (ifinfo->ifi_flags)
> +	if (ifinfo->ifi_change)
>  		printf(" change=3D0x%x", ifinfo->ifi_change);
>  }
> =20
> --=20
> 2.26.2
>=20

--lzpx6ptvjvcqyxgq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yA2UACgkQ538sG/LR
dpVXtAgAvgcVz4l+m37P2hlIAonzPreGwMOT+WJ0mxncYo2ut0Y8+JidN5QgUw/9
wvt05vAXjdtDr1e83v1I/PpyhoeLhE70nm0a3RbpdXI3MApjljiuPJ+sFzhAjfBW
hnbbnFn5MFA8+/9VWrCbzia4W1bcgMLgDG6Rs5mvGKoCDzeV9OZNLLb2SCHYA6ar
88X/vddF1cIMwf0UBgW4pfi6uzx9vGS8S6ayy1pS4imWV/O1QLnKYV0tpbnkAZP+
JnFAN/miqCBpYT4ae3hDHwbpJdqumTi5E7Z90rdgdX+nwaHcSJtipIlt8RJ9JchN
D5PrMc+PR+7RcSdHFj+dIl+QnwfmRg==
=hovr
-----END PGP SIGNATURE-----

--lzpx6ptvjvcqyxgq--
