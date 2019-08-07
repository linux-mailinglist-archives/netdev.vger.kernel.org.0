Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756EF841FB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfHGByk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:54:40 -0400
Received: from ozlabs.org ([203.11.71.1]:57581 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727765AbfHGByk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 21:54:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 463F1T0Xg3z9s3Z;
        Wed,  7 Aug 2019 11:54:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565142877;
        bh=8AF/z94/zq3IT4SoNqw/TPbSGNHkTgwfNjsQrYKB7BM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FLsZZJkrZcYVyRmtrMqHQpt5fk6dDLgbvELAcHyQpPyYxxz6vi8u1TxhgNtM2dGRt
         J6HrKAbLqodOU/vnZVpMcj3EruGWZTIiT92iE5PkZZUmRh/PyQ43TPJ2ZHtG5Z01ko
         WPtAZL1BGeQK5laEADflgGwH5Tigtwn+1X+7/Nh0L9QpNs6EbipKoCGlopVUy+TchB
         pCp8KKhUJcU0HB+ShrJm/a3tBDq3Q7+va7zT3NvHKEr7tzNsILfXE3lab4nVPvhUm0
         myR5F4meqiWceauZ6SePl1kn9UkYSXQ2Lgnlv6poxrxdS1kybFSZ0JJc0VAM1epj7X
         LKbS7Yx85Ac1w==
Date:   Wed, 7 Aug 2019 11:54:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yifeng Sun <pkusunyifeng@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
Message-ID: <20190807115436.5f02155c@canb.auug.org.au>
In-Reply-To: <CAEYOeXMV1DbTsy7U1-Fu0eztVGpw-+ZEJTK0Hzm8xbqCL7fabw@mail.gmail.com>
References: <20190807093037.65ac614e@canb.auug.org.au>
        <CAEYOeXMV1DbTsy7U1-Fu0eztVGpw-+ZEJTK0Hzm8xbqCL7fabw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6VeeINC.6v_6tG/6nQL2IaS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6VeeINC.6v_6tG/6nQL2IaS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Yifeng,

On Tue, 6 Aug 2019 16:37:26 -0700 Yifeng Sun <pkusunyifeng@gmail.com> wrote:
>
> My apologies, thanks for the email. Please add the signed-off if you can.

Dave does not rebase his trees, so that is not possible.  Just remember
for next time, thanks :-)

--=20
Cheers,
Stephen Rothwell

--Sig_/6VeeINC.6v_6tG/6nQL2IaS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1KL1wACgkQAVBC80lX
0GxDrgf+NMuG/XgJTKJeqgeaPegG+0w3Bry/p2cVP8VuaKAvqKYPh7LvySqiK13t
cHlvHWyljAhWphtZ6M8U04UObnyckFBPCZx+hfclaZTzUCQrPxkFdDp0Kw4RAL8K
fStybyBcWLUv58d3pOpTjBLxwZyqG6ELqC+vFdbaZNc0CZ7E+oYjL3qRA6Oe6doC
/cGXYJJD/gpQf39givRbdnpNbSmRc5vZNoXrzMFGjBPVZ3o75PoNSlvwjd1EYkRF
WRvN57HrIT8JPg10VSwLpHQx9PsC3JOtgfVfw17tjavQ71CiWUpSZRv2zl2crGFP
Qjk7HQqjdOj+i4/Qmhv+4GgzpjT6rw==
=nOPj
-----END PGP SIGNATURE-----

--Sig_/6VeeINC.6v_6tG/6nQL2IaS--
