Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9BCCF91A6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKLOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:12:16 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37814 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfKLOMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:12:16 -0500
Received: by mail-ed1-f68.google.com with SMTP id k14so15012153eds.4;
        Tue, 12 Nov 2019 06:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxSPlrqtEzHjDjmMoesMoA1oYmvT3buCd5ykJgz1zH4=;
        b=azxIbnR14SLX1EEBSNv3knBGIxYmKTsERV55xjemZBeEqgKPTy37mAxU7sFe2Rj/tf
         OY1Jisto9ME9u6C31XRuv2Sh6WwETVDHCBCGdGvfUpUafPdNZRrn7hg8Fcc6kJVqsL+N
         LDHra+Z0UDv49RtAlISWxn5bNJ65EXgriDHyOUw/jwOjySmNy/jmAbtwONICQJBTaP6I
         QF5kBz2CAuZ6yfB3/QV7SzKo9ofZBaV/TfsijKaGB0av6B+9x7LaikNc5YYLvTJKHzeK
         XZd39b7WwXlmuRPFEF/Xj4h87odt64jwzcjSVZx+vuArqAIJ+o1WeDZS/hjln6zSd+zW
         aGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxSPlrqtEzHjDjmMoesMoA1oYmvT3buCd5ykJgz1zH4=;
        b=uikXJrOJcwFWX59IwiiCZ/vKU4fMAZzvaHquO2WpR58DYmsONxR1wCFpE16pPf3g/y
         24Q2so7MUppoTvspnGfTBORnXsobAmVMfiLopY2OYRxJYpH0K2Ph8Ix94RwXiO+aNP3y
         +OIRWA706xG4yPxgIum5pLHs8+vnbqUhBzQkYBzKvcQNTS0ncN5VVAVGfcOyUOljBr6T
         LeaxkIW65RTI/Ic+vI6ZXf+aUV9IHL+6jf/ekCQ2ZgawrS1cMU34GGkSefes7WwI39t4
         et4LE/xm00OdfZS0QrStoJgs20jtWIBVNjbZPxucvwJ63TjCjI9+6X4AEhblcRXmbeTe
         5reQ==
X-Gm-Message-State: APjAAAUtaA/Z73efshZ4MGuhkbl8s+ZNIV1Ij2oa0LPRhpOnE8/mvawk
        nNlcV/668Rrs9d5wslDSUL2VS83L96edbj0jnUw=
X-Google-Smtp-Source: APXvYqx6gy2SiezBYVxCNFX0y4S7P2z/l2MUZWIDu9IBINqX69LmFc046Aug3tBhXJobpzrUhTTqryc2NmW89CYErdw=
X-Received: by 2002:a50:91c4:: with SMTP id h4mr33376125eda.36.1573567933749;
 Tue, 12 Nov 2019 06:12:13 -0800 (PST)
MIME-Version: 1.0
References: <20191112132010.18274-1-linux@rasmusvillemoes.dk>
 <20191112132010.18274-3-linux@rasmusvillemoes.dk> <CA+h21hqw16o0TqOV1WWYYcOs3YWJe=xq_K0=miU+BFTA31OTmQ@mail.gmail.com>
 <6d4292fcb0cf290837306388bdfe9b0f@www.loen.fr> <CA+h21hpE-Nu_Sh1fRizUoEs082ev=9nzuumSXDrk-QTXdnEbzg@mail.gmail.com>
 <aee81d64979bb72b63a8889fb7193c3f@www.loen.fr>
In-Reply-To: <aee81d64979bb72b63a8889fb7193c3f@www.loen.fr>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 16:12:02 +0200
Message-ID: <CA+h21hqxpy-n6HBkyGSKFEm_CujG5x3Y3Wj-frj0OSwbVWgCng@mail.gmail.com>
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

On Tue, 12 Nov 2019 at 16:04, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2019-11-12 15:03, Vladimir Oltean wrote:
> > On Tue, 12 Nov 2019 at 15:49, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> On 2019-11-12 14:53, Vladimir Oltean wrote:
> >> > On Tue, 12 Nov 2019 at 15:20, Rasmus Villemoes
> >> > <linux@rasmusvillemoes.dk> wrote:
> >> >>
> >> >> From: Vladimir Oltean <olteanv@gmail.com>
> >> >>
> >> >> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and
> >> >> eth1
> >> >> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
> >> >>
> >> >> Switching to interrupts offloads the PHY library from the task of
> >> >> polling the MDIO status and AN registers (1, 4, 5) every second.
> >> >>
> >> >> Unfortunately, the BCM5464R quad PHY connected to the switch does
> >> >> not
> >> >> appear to have an interrupt line routed to the SoC.
> >> >>
> >> >> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> >> >> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >> >> ---
> >> >>  arch/arm/boot/dts/ls1021a-tsn.dts | 4 ++++
> >> >>  1 file changed, 4 insertions(+)
> >> >>
> >> >> diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts
> >> >> b/arch/arm/boot/dts/ls1021a-tsn.dts
> >> >> index 5b7689094b70..135d36461af4 100644
> >> >> --- a/arch/arm/boot/dts/ls1021a-tsn.dts
> >> >> +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> >> >> @@ -203,11 +203,15 @@
> >> >>         /* AR8031 */
> >> >>         sgmii_phy1: ethernet-phy@1 {
> >> >>                 reg = <0x1>;
> >> >> +               /* SGMII1_PHY_INT_B: connected to IRQ2, active
> >> low
> >> >> */
> >> >> +               interrupts-extended = <&extirq 2
> >> >> IRQ_TYPE_EDGE_FALLING>;
> >> >>         };
> >> >>
> >> >>         /* AR8031 */
> >> >>         sgmii_phy2: ethernet-phy@2 {
> >> >>                 reg = <0x2>;
> >> >> +               /* SGMII2_PHY_INT_B: connected to IRQ2, active
> >> low
> >> >> */
> >> >> +               interrupts-extended = <&extirq 2
> >> >> IRQ_TYPE_EDGE_FALLING>;
> >> >>         };
> >> >>
> >> >>         /* BCM5464 quad PHY */
> >> >> --
> >> >> 2.23.0
> >> >>
> >> >
> >> > +netdev and Andrew for this patch, since the interrupt polarity
> >> > caught
> >> > his attention in v1.
> >>
> >> Certainly, the comments and the interrupt specifier do not match.
> >> Which one is true?
> >>
> >>          M.
> >> --
> >> Jazz is not dead. It just smells funny...
> >
> > The interrupt specifier certainly works. So that points to an issue
> > with the description. What do you mean, exactly? Does "active low"
> > mean "level-triggered"? How would you have described this?
>
> Active Low definitely implies level triggered. And if that's how it
> is described in the TRM, than the interrupt specifier is wrong, and
> just *seem to work* because the level goes back to high between two
> interrupts.
>
> Also, shared *edge* interrupts do not work, full stop. So I'm pretty
> convinced that what you have here is just wrong.
>
>          M.
> --
> Jazz is not dead. It just smells funny...

Ok, I've tested both interrupts with IRQ_TYPE_LEVEL_LOW and they still
work. I'll let Rasmus re-send if there is no trouble with the dtsi
patch. Sorry for the trouble and thanks for teaching me something new.

Cheers,
-Vladimir
