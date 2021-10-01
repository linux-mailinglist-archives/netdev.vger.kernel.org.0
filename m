Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE941F7FD
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhJAXEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhJAXEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 19:04:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD37661AAB;
        Fri,  1 Oct 2021 23:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633129359;
        bh=Et1vBAzzXp38/cf+29ag0WERSDPG0JukGE/4eE9eArw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sup5I6n2GufZT9C0pd+8i1mSTb1yX8W7QsogbRBHs01r0s0b1OnqXbVnjyvTGS2IF
         Cmg8+tZYI/7GS0weqKJYeuLjPvNA2ho0UKt6ueGQaXqN41N56RdfwUQXwcJbg8mz3c
         XTiUCodhw54UEl+AoYwHILR/f4H7EPbH/0tk5Dvd7QUktfCHZJUrqHH7xRp73/RgZ0
         uzFZuA/uzdPRk+Y0ROC2xykjaaMNJsPbUUaU/lZM1vZBfh7JL/PBIGHNnF+JcaZQyZ
         CO0cMXfdfWmQbQJx6jtK90Ag4V5MKcZlHt5F+elmDjOp0FhsDnyNYM+SHBCXuPJxKw
         yzMi22MTjinEQ==
Date:   Fri, 1 Oct 2021 16:02:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Cc:     netdev@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based
 devices
Message-ID: <20211001160238.4335a83d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <12744188.XEzkDOsqEc@diego>
References: <20210929135049.3426058-1-punitagrawal@gmail.com>
        <12744188.XEzkDOsqEc@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 23:02:35 +0200 Heiko St=C3=BCbner wrote:
> Am Mittwoch, 29. September 2021, 15:50:49 CEST schrieb Punit Agrawal:
> > Commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_=
enable warnings")
> > while getting rid of a runtime PM warning ended up breaking ethernet
> > on rk3399 based devices. By dropping an extra reference to the device,
> > the commit ends up enabling suspend / resume of the ethernet device -
> > which appears to be broken.
> >=20
> > While the issue with runtime pm is being investigated, partially
> > revert commit 2d26f6e39afb to restore the network on rk3399.
> >=20
> > Fixes: 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced pm_runtime_=
enable warnings")
> > Suggested-by: Heiko Stuebner <heiko@sntech.de>
> > Signed-off-by: Punit Agrawal <punitagrawal@gmail.com>
> > Cc: Michael Riesch <michael.riesch@wolfvision.net> =20
>=20
> On a rk3399-puma which has the described issue,
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Applied, thanks!
