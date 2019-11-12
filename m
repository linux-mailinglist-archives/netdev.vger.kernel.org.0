Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC3C1F90E6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKLNob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:44:31 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37982 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfKLNob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:44:31 -0500
Received: by mail-ed1-f65.google.com with SMTP id s10so14950078edi.5;
        Tue, 12 Nov 2019 05:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gXwOc0pJ6hqLtPP5MF3njwCDDhwJ+LtuEm52q4JdFG0=;
        b=YwcU2/mITcV4eLtuCPb7UvqNbE8wHLtLX/4m397nu8Ryp88ewpHBgxlJ1IB8gkm/4D
         +y1zXkERVtNiYvtmcqA/ADrdJsNZd299zT6m+hZ3c/uSjcWwqOydkDXZKTG0ubCfpAxP
         ySLfu1WWcUYFbJPmqrkVi56XkRw4sjEL/6hfDwSuUa1tY2xYk/7LkTNhAS5WxFJjIegZ
         N5ZCaAi5dXg1YsV7viSgFpNHCw/3qlIqSCH24n3MVoSz1ppEHhSdBibhjzSvZk41K6yb
         IHqYq40KcXiUX0IV4GA5YpfvxyUkaFbr9NL0u3slJap8qUMWvzk8Ipabi9HMPk5T21US
         jCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gXwOc0pJ6hqLtPP5MF3njwCDDhwJ+LtuEm52q4JdFG0=;
        b=umyKzyBIOxXePAvciST6v1NdEl06JacCjgtO2OUk4pV3gkSu0h5J35+OGzJwGgeOGj
         b+w5i7oBe1N5sMIqh4jEQefO5HpApFgh+gKKclGxP1aNo09d/cQ90ZeSIVIOFf/VTVnb
         EaX0S/iT43fDn0CY4m9m7oQVEBz3NWvjAAxaZbDIFU+PGSZy/lZXt9ePEfOooiDD7YLw
         m7XF5j8xG6Tirx0aMZkTWVWPjy0lxMRac+8t12zh7UPaTyXKucljHyuYG5QNbw2chiUg
         /ESk8sXjw30vQdHwIcno0e38a2ANewXrdcaGma7ab4W/4dxgayGmVa5NeCBUMNmdSyzx
         rxbQ==
X-Gm-Message-State: APjAAAXa+1cQN2ZaLnllm0JeG2tH/D5XE9TzB+iQUzJlidrej5PHlzFF
        +DooMgCRK25Nd0QIWKzGM17l2SjipVSgc9zJaiA=
X-Google-Smtp-Source: APXvYqwEfukonUP8KqyQ+bKuKOQ1O/aGrq59NYnVrf1rT78e31Bw/atAL5285NQic4/J5nTNN05SD0UaFdCbcBRbuL4=
X-Received: by 2002:a50:b63b:: with SMTP id b56mr33037948ede.165.1573566267462;
 Tue, 12 Nov 2019 05:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20191112132010.18274-1-linux@rasmusvillemoes.dk> <20191112132010.18274-3-linux@rasmusvillemoes.dk>
In-Reply-To: <20191112132010.18274-3-linux@rasmusvillemoes.dk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:44:16 +0200
Message-ID: <CA+h21hqw16o0TqOV1WWYYcOs3YWJe=xq_K0=miU+BFTA31OTmQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII PHYs
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:20, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
>
> On the LS1021A-TSN board, the 2 Atheros AR8031 PHYs for eth0 and eth1
> have interrupt lines connected to the shared IRQ2_B LS1021A pin.
>
> Switching to interrupts offloads the PHY library from the task of
> polling the MDIO status and AN registers (1, 4, 5) every second.
>
> Unfortunately, the BCM5464R quad PHY connected to the switch does not
> appear to have an interrupt line routed to the SoC.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  arch/arm/boot/dts/ls1021a-tsn.dts | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
> index 5b7689094b70..135d36461af4 100644
> --- a/arch/arm/boot/dts/ls1021a-tsn.dts
> +++ b/arch/arm/boot/dts/ls1021a-tsn.dts
> @@ -203,11 +203,15 @@
>         /* AR8031 */
>         sgmii_phy1: ethernet-phy@1 {
>                 reg = <0x1>;
> +               /* SGMII1_PHY_INT_B: connected to IRQ2, active low */
> +               interrupts-extended = <&extirq 2 IRQ_TYPE_EDGE_FALLING>;
>         };
>
>         /* AR8031 */
>         sgmii_phy2: ethernet-phy@2 {
>                 reg = <0x2>;
> +               /* SGMII2_PHY_INT_B: connected to IRQ2, active low */
> +               interrupts-extended = <&extirq 2 IRQ_TYPE_EDGE_FALLING>;
>         };
>
>         /* BCM5464 quad PHY */
> --
> 2.23.0
>

+netdev and Andrew for this patch, since the interrupt polarity caught
his attention in v1.
