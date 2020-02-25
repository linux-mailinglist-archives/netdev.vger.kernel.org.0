Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A64B16F2CF
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgBYW7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:59:08 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47867 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728806AbgBYW7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 17:59:08 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48RvWF1ZKmz9sPR;
        Wed, 26 Feb 2020 09:59:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582671545;
        bh=FsIT/LG/Iu82AMwY16eCZxR4qz3TVYWCGa+ExdBjvP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+XeytSFTxpnXzisYdpBXxqxMZx9llv5OxlHJBT+SVfbgyWHFhQ8oZ794fGHAujay
         7oxbQBtmlRB9Ut373J5KdOHHecOWM6dYcKNSm5ik6ryWIsJd+BBsZkjfLpSTcAXsoW
         AlrAgsQzKkT6dCXh9/Jj4aMEKpFP+KlO7emZLEbd7Bl/RX0HwJSMiQ6gyRZDIssjHx
         GS3vqJ3IHsSmzYZVOSb7E4k/Pi1vfArJ5mSo5BxAYXRkGo3G6gWiKt4EKR09G7gUX/
         bbAWiC1mnGaScr1vLEtfmXnpg5hHXv7ZmTe8UXXkmzAtnoaNjyUgVyWQA2cF+wVNbh
         5o1oXC+ZUmXKg==
Date:   Wed, 26 Feb 2020 09:58:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20200226095855.64388b4a@canb.auug.org.au>
In-Reply-To: <20200224.144243.1485587034182183004.davem@davemloft.net>
References: <20200225092736.137df206@canb.auug.org.au>
        <20200224.144243.1485587034182183004.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e8ENf_75BTzs1duxn25sxue";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/e8ENf_75BTzs1duxn25sxue
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 24 Feb 2020 14:42:43 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> I've committed the following into net-next, hopefully it does the trick:

That fixed the warnings for me, thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/e8ENf_75BTzs1duxn25sxue
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5Vpq8ACgkQAVBC80lX
0Gxvegf6As+r+gXCaWneBNlZOG6h5CJ39JHetyb3xvCBJ6nXYIYMwDJSJAnrZBoN
Au6lYyLdghlUpz6wVqPZ+il2Y2QGoHJyaYeUGorcrZXSeTBn2VqGlMzWIJ2KyDse
eziWEWhVM2pNJ4r0ZTnOmsYmddkuaOWhr9GRI8XxAtV3FZeNr7VKcjn0M9evwbFy
GRfgB8eiAR8J8nJYU5A4hNBBnNyzhD93ObMST+tOSGy1RHq8zUJzfiRxOql4KZYX
p+NKQGkv4aw1zx/XYUqZnUX+SuwgMVo4iRZoGPLY3y5VIexFl6THt1JweOSsxl8F
0JJB7q0eCsklHM8Ldz7Ziv6mLa8p7w==
=03CM
-----END PGP SIGNATURE-----

--Sig_/e8ENf_75BTzs1duxn25sxue--
