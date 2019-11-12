Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD755F9118
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfKLNxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:53:53 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42017 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfKLNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:53:53 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so14941196edv.9;
        Tue, 12 Nov 2019 05:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQcGXYOeHlLTHcZ1lo51qxyI9wQahbjQK0BQrlXS5rU=;
        b=ZQ4Ak+XUWpy6tCuJD8hjc5ZamO4lhS0gHReMpryPLOnorvowq4WXgrXPFvbyx/CCVg
         5Mv96LC4nLigaGD0ucmXb9/TCE/P7SzkMve/9RNYrcKx+ZtjQygIWfkCCb46IoiVLYaJ
         YheIG1ASMlRffDXyNQKIBFT6nGxc6PoIEVGO+WUr+cERECFDJsWbahMbIdJdttyw4pm7
         unBgDhkYDia6QBzqucjF6cX1FTf4kL6T/PjTZ37/cF/5dyscjmLUEG9xkYgIYGeOlT05
         bH6dCQVafBowD49kPxUUU1l5R/PZ10fYU75NLP+JwO1BUUV/FoOoSn/METjMmfDeQ3cA
         L+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQcGXYOeHlLTHcZ1lo51qxyI9wQahbjQK0BQrlXS5rU=;
        b=p72NZFABvlQikJaorIcQdIjsu4u0VYo2/7SpZFhuSORUkChkIC+aOjhhjwmTemDhuC
         YxiJpS+9rpyY5s57s+wRPWWWgNRSty0fUvOv3XeIWGLU6CVgCLAqgp7DtfUuATmYJoc1
         IQV0PD2r+WXid5A4p7e0Uyr2FiGhG1OrGLGQ8yEhK/UhGgrbrCnN+g7r2wLEXJsvpidh
         6YNWYJ3+fvL5MQu9PYaRtw3k/sfBUmMFv3e8LK2frKMpp66vO9omjRPuYdFuGoYXQfbK
         /HJbdEMaoy0w2z4MfYqRDqo/IMEwnC5Sf7z/GyGVpugtjEjkF2xfiT/yo4iifgBHcj+2
         ZwHw==
X-Gm-Message-State: APjAAAXI637A7iAScItnoH5t9mSLD5tbpkyHwWkXTEh8JGC1yC4g1gbz
        pKRPtqpcIo8Bg03J2UTf0aQOEZp8/dKS6TqnXPw=
X-Google-Smtp-Source: APXvYqxO+WXiBJcbRCoMLP1h3kWtN5lV2SPbs9qh6z3L3L/q4O6fs+gNTF9PRsVm3lEi6KFhnXmie4NP8OeBlrchtgQ=
X-Received: by 2002:a50:c408:: with SMTP id v8mr32855306edf.140.1573566831102;
 Tue, 12 Nov 2019 05:53:51 -0800 (PST)
MIME-Version: 1.0
References: <20191112132010.18274-1-linux@rasmusvillemoes.dk>
 <20191112132010.18274-3-linux@rasmusvillemoes.dk> <CA+h21hqw16o0TqOV1WWYYcOs3YWJe=xq_K0=miU+BFTA31OTmQ@mail.gmail.com>
 <6d4292fcb0cf290837306388bdfe9b0f@www.loen.fr>
In-Reply-To: <6d4292fcb0cf290837306388bdfe9b0f@www.loen.fr>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:53:40 +0200
Message-ID: <CA+h21hpE-Nu_Sh1fRizUoEs082ev=9nzuumSXDrk-QTXdnEbzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
To:     Marc Zyngier <maz@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:49, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2019-11-12 14:53, Vladimir Oltean wrote:
> > On Tue, 12 Nov 2019 at 15:20, Rasmus Villemoes
> > <linux@rasmusvillemoes.dk> wrote:
> >>
> >> From: Vladimir Oltean <olteanv@gmail.com>
> >>
> >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and
> >> eth1
> >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> >>
> >> Switching to interrupts offloads the PHY library from the task of
> >> polling the MDIO status and AN registers (1, 4, 5) every second.
> >>
> >> Unfortunately, the BCM5464R quad PHY connected to the switch does
> >> not
> >> appear to have an interrupt line routed to the SoC.
> >>
> >> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >> ---
> >>  arch/arm/boot/dts/ls1021a-tsn.dts | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts
> >> b/arch/arm/boot/dts/ls1021a-tsn.dts
> >> index 5b7689094b70..135d36461af4 100644
> >> --- a/arch/arm/boot/dts/ls1021a-tsn.dts
> >> +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> >> @@ -203,11 +203,15 @@
> >>         /* AR8031 */
> >>         sgmii_phy1: ethernet-phy@1 {
> >>                 reg = <0x1>;
> >> +               /* SGMII1_PHY_INT_B: connected to IRQ2, active low
> >> */
> >> +               interrupts-extended = <&extirq 2
> >> IRQ_TYPE_EDGE_FALLING>;
> >>         };
> >>
> >>         /* AR8031 */
> >>         sgmii_phy2: ethernet-phy@2 {
> >>                 reg = <0x2>;
> >> +               /* SGMII2_PHY_INT_B: connected to IRQ2, active low
> >> */
> >> +               interrupts-extended = <&extirq 2
> >> IRQ_TYPE_EDGE_FALLING>;
> >>         };
> >>
> >>         /* BCM5464 quad PHY */
> >> --
> >> 2.23.0
> >>
> >
> > +netdev and Andrew for this patch, since the interrupt polarity
> > caught
> > his attention in v1.
>
> Certainly, the comments and the interrupt specifier do not match.
> Which one is true?
>
>          M.
> --
> Jazz is not dead. It just smells funny...

The interrupt specifier certainly works. So that points to an issue
with the description. What do you mean, exactly? Does "active low"
mean "level-triggered"? How would you have described this?
