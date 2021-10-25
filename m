Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE4B43A370
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbhJYT72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:59:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21221 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhJYT4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:56:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211025195413euoutp02dfce1ee59f56b09a57365fab4eab0cc8~xXiUjuOBg0329203292euoutp02u;
        Mon, 25 Oct 2021 19:54:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211025195413euoutp02dfce1ee59f56b09a57365fab4eab0cc8~xXiUjuOBg0329203292euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635191653;
        bh=0AP6kZ9hcyG9MiSTfZjybF2XD60QxF3lzKOPGQEstXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ww/yPv3G0Ys/cfYKLXWw5vXLEsmSYsY62ykkVVSxbuFC8d1mlBX0q+NgQtj660vPE
         fVbOXAt2Ik8iindtx27vjoAwcxctK2rqPEKKrnnosqyF2m+QXgwP5hKohbgYi2oufD
         musIjj3LlXPNDeOb8+NhvYMJKF/S5E95JgYExfgg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211025195412eucas1p11aa98c7133b70b25f68d157a06433186~xXiT1GUqs2057920579eucas1p1A;
        Mon, 25 Oct 2021 19:54:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 1B.BC.56448.46B07716; Mon, 25
        Oct 2021 20:54:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0~xXiTFoGTx2057920579eucas1p1-;
        Mon, 25 Oct 2021 19:54:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211025195411eusmtrp1d6350a1544971ded1c09b3b86961b806~xXiTFCP9F1659016590eusmtrp1A;
        Mon, 25 Oct 2021 19:54:11 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-27-61770b64818a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id E4.E3.31287.36B07716; Mon, 25
        Oct 2021 20:54:11 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211025195411eusmtip2166880f52794a91db06edf12810bd63e~xXiS5QHGs1532815328eusmtip2h;
        Mon, 25 Oct 2021 19:54:11 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ax88796c: fix fetching error stats from percpu
 containers
Date:   Mon, 25 Oct 2021 21:54:01 +0200
In-Reply-To: <20211023121148.113466-1-alobakin@pm.me> (Alexander Lobakin's
        message of "Sat, 23 Oct 2021 12:19:16 +0000")
Message-ID: <dleftj5ytkop7q.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7djPc7op3OWJBr+uSVmserydxWLO+RYW
        iwvb+lgtLu+aw2ZxbIGYA6vHlpU3mTw2repk8zi65xybx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
        i17NYCyYJ1RxsvsfawPjfv4uRk4OCQETibfH/jB2MXJxCAmsYJT4/+s2O4TzhVHi38ZFLBDO
        Z0aJCXv/AZVxgLXsOV4NEV/OKNHx7DgzhPOcUeLj7q+sIEVsAnoSa9dGgKwQEVCTmPn/GdgK
        ZoEORonH716wgSSEBSIlHmxawwRiswioSky5d4oRxOYUqJJ4/mAlE8gcXgFziRf7REHCogKW
        En+efWQHsXkFBCVOznzCAmIzC+RKzDz/Bmy+hMADDomG7pdsEL+5SEy5e5oZwhaWeHV8CzuE
        LSNxenIPC8Qz9RKTJ5lB9PYwSmyb84MFosZa4s65X1BzHCW6dq5lgqjnk7jxVhBiL5/EpG3T
        mSHCvBIdbUIQ1SoS6/r3QE2Rkuh9tYIRwvaQmHO1jxUSVMBgmDZ9P+MERoVZSN6ZheSdWUBj
        mQU0Jdbv0ocIa0ssW/iaGcK2lVi37j3LAkbWVYziqaXFuempxcZ5qeV6xYm5xaV56XrJ+bmb
        GIGp5/S/4193MK549VHvECMTB+MhRhWg5kcbVl9glGLJy89LVRLhtflUkijEm5JYWZValB9f
        VJqTWnyIUZqDRUmcd9fWNfFCAumJJanZqakFqUUwWSYOTqkGJhOPmTU3dK70npuUdmca75Yd
        HHuu7v2uKXR5zotmkZSKl0KhTie1k3nZpx//9nfR/omv9c52CJ1+4C0w3+6w0BGVXwHib0uN
        5rLc5vD4+T1URezwhhQtuQ+fEmX1OUs/83zexnTkpL/jqkzN0o4dLV9TBKRbFuv94dlwfd/B
        K5KfSrSFNfrWzVY75uT25PGmn/via/KV11y8lyg4Mcb8idnO7m2CigoLjl268v18xi8drecT
        0znKe/Xi5cPcv2o9WTZBwYfdmkff5fG/T2yNhYfUus8pVjBF1S1w0oy9ynJM69WuTttJNgJv
        t25bc8Es78bzKVJX6m68zTWJObEkzFH99sddaQ5Nxcq33zf/OqzEUpyRaKjFXFScCABPFHQs
        uAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xe7rJ3OWJBv/OaFqserydxWLO+RYW
        iwvb+lgtLu+aw2ZxbIGYA6vHlpU3mTw2repk8zi65xybx+dNcgEsUXo2RfmlJakKGfnFJbZK
        0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZi17NYCyYJ1RxsvsfawPjfv4u
        Rg4OCQETiT3Hq7sYOTmEBJYySuzsSYYIS0msnJsOEpYQEJb4c62LrYuRC6jkKaPElCvr2UBq
        2AT0JNaujQCpERFQk5j5/xkjSA2zQAejxMql91hAEsICkRIPNq1hgphvInHr4xxGEJtFQFVi
        yr1TYDanQJXE8wcrmUBm8gqYS7zYJwoSFhWwlPjz7CM7iM0rIChxcuYTsJHMAtkSX1c/Z57A
        KDALSWoWktQsoEnMApoS63fpQ4S1JZYtfM0MYdtKrFv3nmUBI+sqRpHU0uLc9NxiQ73ixNzi
        0rx0veT83E2MwJjZduzn5h2M81591DvEyMTBeIhRBajz0YbVFxilWPLy81KVRHhtPpUkCvGm
        JFZWpRblxxeV5qQWH2I0BfpsIrOUaHI+MJrzSuINzQxMDU3MLA1MLc2MlcR5t85dEy8kkJ5Y
        kpqdmlqQWgTTx8TBKdXAtNJ/qXjeh59Rzf25LkmnmMRrOS5/UTt9ISLt8lqbp+qbejSO9FV3
        7WlU+L10wSfT8uu938t8A1MvP/br/jb98W43a9FJ5/jaT8S/XFO/5+2kpNmiescLg6MOnHi4
        XK0pnEHUgbH0VKtrhf770MgHC07n8uqrh+514/ugcCHD1WPrrd88msebLZb1i2XovfzCwHDk
        mZvlgeoHl3MOC078o6obEszpvi9P/JloYqnjWxk2hncZp2qXVVdL/5rvcf7gnl3tfz5deRPw
        sKL4C9OR/T9af9dXGvEvmXulLX3Fg4OHKicltEdblSr1T2YTcbrZGG4cH6qcu2dVduKd+xvs
        Fq24OHmp64IPhvc7OGYWKbEUZyQaajEXFScCAIDIQz0uAwAA
X-CMS-MailID: 20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0
X-Msg-Generator: CA
X-RootMTR: 20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0
References: <20211023121148.113466-1-alobakin@pm.me>
        <CGME20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-10-23 sob 12:19>, when Alexander Lobakin wrote:
> rx_dropped, tx_dropped, rx_frame_errors and rx_crc_errors are being
> wrongly fetched from the target container rather than source percpu
> ones.
> No idea if that goes from the vendor driver or was brainoed during
> the refactoring, but fix it either way.

It may be the latter. Thank you for fixing.

>
> Fixes: a97c69ba4f30e ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter =
Driver")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/net/ethernet/asix/ax88796c_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethe=
rnet/asix/ax88796c_main.c
> index cfc597f72e3d..91fa0499ea6a 100644
> --- a/drivers/net/ethernet/asix/ax88796c_main.c
> +++ b/drivers/net/ethernet/asix/ax88796c_main.c
> @@ -672,10 +672,10 @@ static void ax88796c_get_stats64(struct net_device =
*ndev,
>  		stats->tx_packets +=3D tx_packets;
>  		stats->tx_bytes   +=3D tx_bytes;
>
> -		rx_dropped      +=3D stats->rx_dropped;
> -		tx_dropped      +=3D stats->tx_dropped;
> -		rx_frame_errors +=3D stats->rx_frame_errors;
> -		rx_crc_errors   +=3D stats->rx_crc_errors;
> +		rx_dropped      +=3D s->rx_dropped;
> +		tx_dropped      +=3D s->tx_dropped;
> +		rx_frame_errors +=3D s->rx_frame_errors;
> +		rx_crc_errors   +=3D s->rx_crc_errors;
>  	}
>
>  	stats->rx_dropped =3D rx_dropped;
> --
> 2.33.1
>
>
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmF3C1kACgkQsK4enJil
gBA8pAf/az9fjPkouZfUGTQWiQ/HrrdpDgF4NydjuJtpn7ZlJxyGgj1dPNEJZpYf
RPJe2gg55/PDBMDT6NGb/ufYaHedOs+ZuxRvXhSwc9a5n+L6mqzrZNEv0GMhT7Wq
BrTuZ6xaqHToGwfBJrJWRXV5jbK6As3N2543s9qe6N/6W3lA2vZeIwUNsdW2celT
8QgUXjEqi0y9+f6o18eLsucdRvDTTiy390aOz+MBpppHfw6fTFXceXqPoCPTEBen
v/Oh5FVJb8IYELwHELAF98Dx30rrRwDTohVoW0p7b3diC7WA61q8YKrA7mI3UqBr
K8skp3/rGQV2YTLuIta1p1ZsgW+oLw==
=ii75
-----END PGP SIGNATURE-----
--=-=-=--
