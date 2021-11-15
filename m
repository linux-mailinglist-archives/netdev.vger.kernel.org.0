Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42F5450953
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhKOQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232487AbhKOQOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 11:14:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94AE61BE1;
        Mon, 15 Nov 2021 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636992719;
        bh=gRUXtLEVm0DvEJ0poy+XhY6uS652755o2Y0drWsZnm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fMLIw//sAXp1Y9iXeBld02IRdUTBqxJCMYpMMOL+sSbGqsi+at85SRnPGzfhrx3ZO
         qhkQi/sH/jHi+Nqb3AewRHUgOdLVmtniOPGj2zoKVeHjFzH32Srb49z5ZjrihZq5iy
         Po8tcjGr1SVyKBZNo1lwMTSOb8v1eJx1SxzEOIsxYiPnA40nf2mkZvK+5thvXlChWX
         8JNyisY4COFfnSB5oFqYoJkUCrDDD932tHHKI7MNVtk00oSHYhFLlzTJ1pXGLFGAQ5
         dDTLL6A7mb4ScdfsYAE5Qyyr2mbtECzDkIjl00/i5NS4A2Y2KCMDOeIQ8Ehxdl8qeV
         fbRhb8+d70THA==
Date:   Mon, 15 Nov 2021 17:11:56 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>,
        zev@bewilderbeest.net, robh+dt@kernel.org, davem@davemloft.net,
        brendanhiggins@google.com, benh@kernel.crashing.org,
        joel@jms.id.au, andrew@aj.id.au, avifishman70@gmail.com,
        tmaimon77@gmail.com, tali.perry1@gmail.com, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
Message-ID: <YZKGzIdLdzx+/DG0@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        patchwork-bot+netdevbpf@kernel.org,
        Matt Johnston <matt@codeconstruct.com.au>, zev@bewilderbeest.net,
        robh+dt@kernel.org, davem@davemloft.net, brendanhiggins@google.com,
        benh@kernel.crashing.org, joel@jms.id.au, andrew@aj.id.au,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        jk@codeconstruct.com.au, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
 <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
 <YZJ9H4eM/M7OXVN0@shikoro>
 <20211115080834.0b238ccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i6FklpiSri82ZpuQ"
Content-Disposition: inline
In-Reply-To: <20211115080834.0b238ccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--i6FklpiSri82ZpuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Done, sorry: 2f6a470d6545 ("Revert "Merge branch 'mctp-i2c-driver'"")

No worries. Thanks for the quick fix!


--i6FklpiSri82ZpuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmGShsgACgkQFA3kzBSg
KbYSWQ//b5Tq7mEIXyUJQGx9IWJY0awvFiFFgoGxDTgZGaHbnP1oHinoYharvwx/
hXT7t4PXj+4vXDMk5zfcKFTarZicctpBK9Q0XIPT6ReAtzB1tDJeOtv+FXLR1vN0
VnUUPZFhsmODdms1vfBxUie8ScYAcRY0WBAoU0xMxoCOCtQ/02ZtjjrRO2GhLDx1
RnECyhO9ozIb12joKiKimo9JbghO8hRauoedyOnVEeVX3qO+RIqOmfTNhGobJb9Z
ngaAlCugVXCVzMtFEf7xCYriSAEGAj9Qyz7ekmk3gDbtt1Fz9VLDw6bv4HIIFsC7
x8u9kl1nUUuJs3aoTlhOL1jC5Wmv3QQucU7VBk7hfG0tXCcJl30HJYv3m7Dgamep
3KYf8SDDbivTSsamYtnRZTHBxhuRjqq55C+LePK9jzy46XmzsFFKfhsH5+X6qWAA
bKyBjzfcb7w+fmXoh6bO5lPU5mrfMt/LFaG2oAE7ca+AwSMkfEVkdsiw7GyWJTy6
N/3xE11fZ7GytlbE1KGntGP23IeN1AkDbyW4gcwN682JMCSuJQNx8bUno+ZZEPah
2D95WMwCfGNLoyrVuoNOOg3eupztxbLhe4cq9T17hMN51xoR5vbjzXLdvWuCl8xz
8DSPat9PFKBj8R8dEcptXxY5uMDBf2sU5PZm2CvnQw7Ya+F7aVY=
=igQC
-----END PGP SIGNATURE-----

--i6FklpiSri82ZpuQ--
