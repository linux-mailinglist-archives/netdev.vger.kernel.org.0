Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281CD41FEE5
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 02:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhJCAWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 20:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhJCAWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 20:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749A761AA9;
        Sun,  3 Oct 2021 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633220457;
        bh=nbPhc931osaT2zECQbmZZ/zDrrQcA0c0n0Qt/lf4Fkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fw20hv6pyy9CFxka4LKTfxowr1N9Fn+eETdOQx088ytHZrMmsiSDzP6fKh2GKvvvR
         LeNhZ1sshx/mvlrdPnPX5Bp4ivT+99SsPhZq7hNlThF4DFfV458uvQvQ0WqG5M2id+
         7nb8esQUHw48WwBMQbOJ6BEsrCL/X755f8sbrCK2YQ36HOTSPUFK4Qmz9oGLHftVl6
         wbYpl/0LbopVgbameLfFKx6F77dbA3p4eWm2HxQfn53PCrwpzResjC51WzNTvCMwmV
         r4dJWj5Dv5Ek59prFHH9HZjH2Wk20tV2xXVGMQn5veSXTRmnqI41gLyoAxlyeGzsdq
         aMhff3V3aFoMQ==
Date:   Sat, 2 Oct 2021 17:20:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andreas Rammhold <andreas@rammhold.de>
Cc:     Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>,
        netdev@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based
 devices
Message-ID: <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211002213303.bofdao6ar7wvodka@wrt>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
        <12744188.XEzkDOsqEc@diego>
        <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211002213303.bofdao6ar7wvodka@wrt>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 23:33:03 +0200 Andreas Rammhold wrote:
> On 16:02 01.10.21, Jakub Kicinski wrote:
> > On Wed, 29 Sep 2021 23:02:35 +0200 Heiko St=C3=BCbner wrote: =20
> > > On a rk3399-puma which has the described issue,
> > > Tested-by: Heiko Stuebner <heiko@sntech.de> =20
> >=20
> > Applied, thanks! =20
>=20
> This also fixed the issue on a RockPi4.
>=20
> Will any of you submit this to the stable kernels (as this broke within
> 3.13 for me) or shall I do that?

I won't. The patch should be in Linus's tree in around 1 week - at which
point anyone can request the backport.

That said, as you probably know, 4.4 is the oldest active stable branch,
the ship has sailed for anything 3.x.
