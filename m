Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C84C36749C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245741AbhDUVG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:06:57 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38296 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243828AbhDUVG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 17:06:56 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 3AB781F41EAC
Message-ID: <d1de806e3989900a8a6477f35dce1575473a8983.camel@collabora.com>
Subject: Re: [PATCH v2 3/3] net: stmmac: Add RK3566 SoC support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Johan Jonker <jbx6244@gmail.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Date:   Wed, 21 Apr 2021 18:06:13 -0300
In-Reply-To: <a3cef507-6480-eff8-625c-c5167db718f3@gmail.com>
References: <20210421203409.40717-1-ezequiel@collabora.com>
         <20210421203409.40717-4-ezequiel@collabora.com>
         <a3cef507-6480-eff8-625c-c5167db718f3@gmail.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-21 at 22:49 +0200, Johan Jonker wrote:
> On 4/21/21 10:34 PM, Ezequiel Garcia wrote:
> > From: David Wu <david.wu@rock-chips.com>
> > 
> > Add constants and callback functions for the dwmac present
> > on RK3566 SoCs. As can be seen, the base structure
> > is the same, only registers and the bits in them moved slightly.
> > 
> > The dwmac IP core version v5.1, and so the compatible string
> > is expected to be:
> > 
> >   compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
> > 
> > Signed-off-by: David Wu <david.wu@rock-chips.com>
> > [Ezequiel: Separate rk3566-gmac support]
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  .../bindings/net/rockchip-dwmac.txt           |  1 +
> >  .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 89 +++++++++++++++++++
> >  2 files changed, 90 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > index 3b71da7e8742..3bd4bbcd6c65 100644
> > --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.txt
> > @@ -12,6 +12,7 @@ Required properties:
> >     "rockchip,rk3366-gmac": found on RK3366 SoCs
> >     "rockchip,rk3368-gmac": found on RK3368 SoCs
> >     "rockchip,rk3399-gmac": found on RK3399 SoCs
> 
> > +   "rockchip,rk3566-gmac", "snps,dwmac-4.20a": found on RK3566 SoCs
> 
> This is still a text document.
> rob+dt has now scripts that check for undocumented compatibility
> strings, so first convert rockchip-dwmac.txt to YAML and then add this
> in a separated patch.
> 

Is it a showstopper to convert devicetree bindings to YAML, for driver submission?

Thanks,
Ezequiel

