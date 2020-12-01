Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B4E2CA129
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgLALV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbgLALV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:21:26 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A34C0613D3;
        Tue,  1 Dec 2020 03:20:46 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id j13so1048446pjz.3;
        Tue, 01 Dec 2020 03:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TrnLCS8SJjrXmy8WkOa5em93leyCPGh+DeLolDdRbhI=;
        b=Z0LPzdGpWyph1LfOPWigYQfgN9jHLj/f/+Nw340G5HGseV+3kZyHDTdCFw7mUC+p0D
         e/BuK1yByV0y82+FLkh7ZcdLDw2gboe3jY+2VOmfvu+q49onTJ2I5W+uMg7bCpYEgR40
         6D+KgRUAe/n01v3+jeeL/3iJUFgTP9555wrWEWNVAAPAKnzJbLYtgEkR7eEsOWReUKs6
         VrxUP5HUItNqliN+MHSDZgFdnh8d5uL7dwx4GiyWstlOSECtIBqmblx4U6ou2ufgqHlp
         oGiWef+kDUSZdpykzC5ExoxQYO+kvJnGguNbuqfCFFpkL8OfP76hhFI9gRJYbwSZYXmA
         lTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TrnLCS8SJjrXmy8WkOa5em93leyCPGh+DeLolDdRbhI=;
        b=HzLlm5jVIktE5YZiIoCUx+/K6XiByxqjjBfADoxsRHjGcf4amHOki2pldVJcx6oHeV
         76vKVytWqoi+2lpAtEdADsGYL2jDxr1IL/31BtvpleEJU+92bBtcXIfwIpnkMzkyyCbe
         sLz235Ag+sXgW4r3hG0pHLj64JGFBE6cAmqHV9lwKhuZO4u+l661RtjJhpDvdvSqpnA/
         C19KX0c4SIdBgTcdtYc+8w3/6eCrzWY8Uj0SMCQFf74vX7go/JUD8+SUgEGj9PmPrP4g
         w9+Qz6sXuRrdgyTmA7Ykxv66LK8n4XWHwtL8I5rTWCVdadZeFyg1GV7DKw35obHn2jM3
         Vf0w==
X-Gm-Message-State: AOAM531yuFB3HESzhlg7cTuFdxzWIHJ6MtElAcIY2gWwTRT3eXKYLsbC
        iWzB6emjNZk+4MpTchsjnRFbeJiSA/Og+9DQOF4=
X-Google-Smtp-Source: ABdhPJz8LscOH3V/SR/cCHRR86/3yyzJDx//0AKtD/joJTXgjwlrx7ap1XMw5J6/5Y+VzeI8q0TmfybgjUMH+k3TXQI=
X-Received: by 2002:a17:90b:a17:: with SMTP id gg23mr2214360pjb.129.1606821646034;
 Tue, 01 Dec 2020 03:20:46 -0800 (PST)
MIME-Version: 1.0
References: <20201201081146.31332-1-frieder.schrempf@kontron.de>
In-Reply-To: <20201201081146.31332-1-frieder.schrempf@kontron.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 1 Dec 2020 13:21:34 +0200
Message-ID: <CAHp75VcEOgdu+9WPGOnLC+px9=N14xpUs0DSVgsS0pNXov8ruQ@mail.gmail.com>
Subject: Re: [PATCH v2] NFC: nxp-nci: Make firmware GPIO pin optional
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org, netdev <netdev@vger.kernel.org>,
        Stephan Gerhold <stephan@gerhold.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 10:12 AM Schrempf Frieder
<frieder.schrempf@kontron.de> wrote:
>
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> There are other NXP NCI compatible NFC controllers such as the PN7150
> that use an integrated firmware and therefore do not have a GPIO to
> select firmware downloading mode. To support these kind of chips,

these -> this
 OR
kind -> kinds

> let's make the firmware GPIO optional.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>
> ---
> Changes in v2:
>   * Remove unneeded null check for phy->gpiod_fw
> ---
>  Documentation/devicetree/bindings/net/nfc/nxp-nci.txt | 2 +-
>  drivers/nfc/nxp-nci/i2c.c                             | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
> index cfaf88998918..cb2385c277d0 100644
> --- a/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
> +++ b/Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
> @@ -6,11 +6,11 @@ Required properties:
>  - reg: address on the bus
>  - interrupts: GPIO interrupt to which the chip is connected
>  - enable-gpios: Output GPIO pin used for enabling/disabling the chip
> -- firmware-gpios: Output GPIO pin used to enter firmware download mode
>
>  Optional SoC Specific Properties:
>  - pinctrl-names: Contains only one value - "default".
>  - pintctrl-0: Specifies the pin control groups used for this controller.
> +- firmware-gpios: Output GPIO pin used to enter firmware download mode
>
>  Example (for ARM-based BeagleBone with NPC100 NFC controller on I2C2):
>
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index 9f60e4dc5a90..7e451c10985d 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -286,7 +286,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client,
>                 return PTR_ERR(phy->gpiod_en);
>         }
>
> -       phy->gpiod_fw = devm_gpiod_get(dev, "firmware", GPIOD_OUT_LOW);
> +       phy->gpiod_fw = devm_gpiod_get_optional(dev, "firmware", GPIOD_OUT_LOW);
>         if (IS_ERR(phy->gpiod_fw)) {
>                 nfc_err(dev, "Failed to get FW gpio\n");
>                 return PTR_ERR(phy->gpiod_fw);
> --
> 2.17.1
>


-- 
With Best Regards,
Andy Shevchenko
