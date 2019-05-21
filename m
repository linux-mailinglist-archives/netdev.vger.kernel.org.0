Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0BD24C09
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEUJ4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:56:34 -0400
Received: from vps.xff.cz ([195.181.215.36]:37802 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfEUJ4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 05:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1558432591; bh=1nbvGwWgSb1jI/P1ZT27Mo4T3fhSGGa/u2NrHc/bhEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aQxlmz+L5OjzAbaGr0IgpRjnbM2RyEQ9ga6eu6t3E1wgEuRsrhjeZ3D6nbtxshUqQ
         EFtz03J7GkN8M0jpVIqGGEF95yxB7bHBJWFoHkXR0AupOG3A5VI/5BhgWHf71ZAzVl
         J10mK1Th7bIsLg6pDXlJsqz4NYBtfHlHzsAteH3k=
Date:   Tue, 21 May 2019 11:56:31 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Icenowy Zheng <icenowy@aosc.io>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v5 2/6] net: stmmac: sun8i: force select external PHY
 when no internal one
Message-ID: <20190521095631.v5n3qml5ujofufk4@core.my.home>
Mail-Followup-To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Icenowy Zheng <icenowy@aosc.io>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20190520235009.16734-1-megous@megous.com>
 <20190520235009.16734-3-megous@megous.com>
 <4e031eeb-2819-a97f-73bf-af84b04aa7b2@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e031eeb-2819-a97f-73bf-af84b04aa7b2@cogentembedded.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sergei,

On Tue, May 21, 2019 at 12:27:24PM +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 21.05.2019 2:50, megous@megous.com wrote:
> 
> > From: Icenowy Zheng <icenowy@aosc.io>
> > 
> > The PHY selection bit also exists on SoCs without an internal PHY; if it's
> > set to 1 (internal PHY, default value) then the MAC will not make use of
> > any PHY such SoCs.
>          ^ "on" or "with" missing?

It's missing 'on'.

thank you,
	Ondrej

> > This problem appears when adapting for H6, which has no real internal PHY
> > (the "internal PHY" on H6 is not on-die, but on a co-packaged AC200 chip,
> > connected via RMII interface at GPIO bank A).
> > 
> > Force the PHY selection bit to 0 when the SOC doesn't have an internal PHY,
> > to address the problem of a wrong default value.
> > 
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> [...]
> 
> MBR, Sergei
