Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1685EE25
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfGCVL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbfGCVL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 17:11:26 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 025C6218AD;
        Wed,  3 Jul 2019 21:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562188285;
        bh=6aVvitJ2eQg7l8Z/jfjS1nTET2e6zwxLEVDtiVxsvuY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I6zieWHbYXuDTvqFmLgAYXkG2rRbka6EwT1DhfYsdVikRogo0nSR6/3v1Y9ERV1Db
         pSeqSg13VZ5EHMX3cohtBMB6eBZcl8yNk3WlGtV6i4S5Q7LVv+KCZY4SvqgAfLhmDH
         h4cCBUMYPJ/H1peL6PCbiEDgORNDzGTVP0kAkJso=
Received: by mail-qt1-f173.google.com with SMTP id d23so5826960qto.2;
        Wed, 03 Jul 2019 14:11:24 -0700 (PDT)
X-Gm-Message-State: APjAAAXaxgdL5fJuzPN3a8INkc/BrQYIVzzH2yMogV0p+JcMrD/QGHyc
        6K9EHbPv6o0VH32NKCu4IdBB9UHvyEwj1bmPAg==
X-Google-Smtp-Source: APXvYqz2JpG3y/B5JHop/E8UqTGOE9Y3sBc3rmCutZyjkSWocM2iVeN7Rk1xUR4GzOGuOaW23rZIeT0cxfAMIfjjkmk=
X-Received: by 2002:a0c:baa1:: with SMTP id x33mr34537404qvf.200.1562188284250;
 Wed, 03 Jul 2019 14:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190703193724.246854-1-mka@chromium.org>
In-Reply-To: <20190703193724.246854-1-mka@chromium.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 3 Jul 2019 15:11:11 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
Message-ID: <CAL_JsqJdBAMPc1sZJfL7V9cxGgCb4GWwRokwJDmac5L2AO2-wg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: Add bindings for Realtek PHYs
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 1:37 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> Add the 'realtek,eee-led-mode-disable' property to disable EEE
> LED mode on Realtek PHYs that support it.
>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - document 'realtek,eee-led-mode-disable' instead of
>   'realtek,enable-ssc' in the initial version
> ---
>  .../devicetree/bindings/net/realtek.txt       | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/realtek.txt
>
> diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> new file mode 100644
> index 000000000000..63f7002fa704
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/realtek.txt
> @@ -0,0 +1,19 @@
> +Realtek PHY properties.
> +
> +This document describes properties of Realtek PHYs.
> +
> +Optional properties:
> +- realtek,eee-led-mode-disable: Disable EEE LED mode on this port.
> +
> +Example:
> +
> +mdio0 {
> +       compatible = "snps,dwmac-mdio";
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +
> +       ethphy: ethernet-phy@1 {
> +               reg = <1>;
> +               realtek,eee-led-mode-disable;

I think if we're going to have custom properties for phys, we should
have a compatible string to at least validate whether the custom
properties are even valid for the node.

Rob
