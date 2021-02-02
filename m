Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB78030CE3B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 22:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhBBVxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 16:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhBBVxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 16:53:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E4C64E46;
        Tue,  2 Feb 2021 21:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612302788;
        bh=FV4SidafuHXx0mzqW2WXyCidaw+f6f4dAH2hUPbYdXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Va4+m7l2b1UBrK+6zDoBTuz6CG5sLxCCMn+kzFHWwJXlhUBOyhBU+xc4noUNsGu3q
         adxPVH+1pteTM4PoKPVjDo8P+ii8TrMemZAsweuprwBa+GCZ5vXDYS8SmJKzRFjSFa
         bhtJFQ5zCam4d0S+Oc5kYfj6haGdCWEkgELXHaX0oNrRdgRRUUMF5iEOq463tkcg1i
         jVj6Dramy22FroLMsUKJi1LEDhjYAFThe3bz7ccnDSEmpZ5dkU0qBlFvk8WEOl1tt9
         a8+dsIKQ6cUmxuCqU33AYA8XyqOEs6qlriOJ9RGLyIpzG0YCKpqdwqoG3e0KMpFkll
         oTvKDBE7o9xGg==
Date:   Tue, 2 Feb 2021 13:53:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rong Chen <rong.a.chen@intel.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] selftests/tls: fix compile errors after adding
 CHACHA20-POLY1305
Message-ID: <20210202135307.6a2306fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202094500.679761-1-rong.a.chen@intel.com>
References: <20210202094500.679761-1-rong.a.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 17:45:00 +0800 Rong Chen wrote:
> The kernel test robot reported the following errors:
>=20
> tls.c: In function =E2=80=98tls_setup=E2=80=99:
> tls.c:136:27: error: storage size of =E2=80=98tls12=E2=80=99 isn=E2=80=99=
t known
>   union tls_crypto_context tls12;
>                            ^~~~~
> tls.c:150:21: error: =E2=80=98tls12_crypto_info_chacha20_poly1305=E2=80=
=99 undeclared (first use in this function)
>    tls12_sz =3D sizeof(tls12_crypto_info_chacha20_poly1305);
>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tls.c:150:21: note: each undeclared identifier is reported only once for =
each function it appears in
> tls.c:153:21: error: =E2=80=98tls12_crypto_info_aes_gcm_128=E2=80=99 unde=
clared (first use in this function)
>    tls12_sz =3D sizeof(tls12_crypto_info_aes_gcm_128);
>=20
> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftes=
ts")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9=
020/
> Signed-off-by: Rong Chen <rong.a.chen@intel.com>

Are you sure you have latest headers installed on your system?

Try make headers_install or some such, I forgot what the way to appease
selftest was exactly but selftests often don't build on a fresh kernel
clone if system headers are not very recent :S
