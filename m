Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F941A07B8
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 08:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgDGGxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 02:53:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41225 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGGxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 02:53:05 -0400
Received: by mail-qt1-f194.google.com with SMTP id i3so1889931qtv.8;
        Mon, 06 Apr 2020 23:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vWzddfgz7uTE/9V/V86TERRrsNQQISOhESAwCEUneBo=;
        b=q1SWZgGwg4IOTQBPhG40WaUEPyUsX+FyFrDs5950iqCm/t8Heu0eZHAFpGoUmZq6Bd
         Xt9rXDCXr5n9qN08BMqz7yICGB2sH0AhkAXJlTs1J7X89vRCHIuaPvju9lH5s+f6PC/L
         9VOu1HA363LRV4cm1ZSVTe3/KXdojZNaS3z/JhiAGsbhSzHB0xJtMXNE1tArKqjoQ9dX
         J93dSXODgr6msokMUAPf5TyjdVehaJmZr57P2BIpLtHSJMbkqa12pUGAK1RsrhZOcA+S
         +GwPXJJGGlLkoUpRmAlQvM5i20ex3c1CjK0uQUPaCH7Msb6KUnoHHaI7KERkD6T+TxkD
         1zGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWzddfgz7uTE/9V/V86TERRrsNQQISOhESAwCEUneBo=;
        b=ZjNS4m2kBr2fFPnSiYrRMvM7AzdWEznIx3LCnkXsokMBT/TqXhjvUUslku03fY+ZP1
         6opJQrMTU32vfEKEJtYGpsdFkGnqKs3nBTJN7WlDQU9MBrpkEmJZshgQ9exlZwHuW8vF
         QhcD0/pEGS7cHhxLnvgAtc2oVO9o8QYuPZG8hKFLbOu14mZbJ7ilYYcDM1fKTjhX8d7v
         HVClyxSlfvGMSvVUvM4fwhlV1JYvKKwv9aE5IU/GO3b+BhNUUqYLmLESvOnyxZh0gPdp
         brc6ik3Gn1GNZGQ8wjgj5PYkZFW11tTG/uzTwGJrCztef7689JUn35NhS/rHTIV5mv2t
         EJ4w==
X-Gm-Message-State: AGi0PuZweS6aVTqAxZVl3yFrII8yq2ZfJ96+16GY0TeNBMm6UzqVrJHx
        HhWzPnrEVScsXlh7nliJ2UUul+2xnDza4IiobRg=
X-Google-Smtp-Source: APiQypI66gw7vMWPdfIdgXDBcmt9McXyUBt2rwqcPJXsAdNoo5YK7kjPqDasabdi/daxyv9FQqWl3aCPN2y58P0heE8=
X-Received: by 2002:aed:21c5:: with SMTP id m5mr897676qtc.42.1586242382828;
 Mon, 06 Apr 2020 23:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200407055837.3508017-1-alistair@alistair23.me> <20200407055837.3508017-3-alistair@alistair23.me>
In-Reply-To: <20200407055837.3508017-3-alistair@alistair23.me>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Mon, 6 Apr 2020 23:52:36 -0700
Message-ID: <CA+E=qVf_Zr6JXQVxRuUdTWL7oxq5dRp+jeHF8PWDSozyFZMaCw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm64: allwinner: Enable Bluetooth and WiFi on
 sopine baseboard
To:     Alistair Francis <alistair@alistair23.me>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        devicetree <devicetree@vger.kernel.org>, alistair23@gmail.com,
        arm-linux <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 10:58 PM Alistair Francis <alistair@alistair23.me> wrote:
>
> The sopine board has an optional RTL8723BS WiFi + BT module that can be
> connected to UART1. Add this to the device tree so that it will work
> for users if connected.

It's optional, so patch should have 'DO-NOT-MERGE' tag and appropriate
change should go into dt overlay.

> Signed-off-by: Alistair Francis <alistair@alistair23.me>
> ---
>  .../allwinner/sun50i-a64-sopine-baseboard.dts | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> index 2f6ea9f3f6a2..f4be1bc56b07 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-sopine-baseboard.dts
> @@ -103,6 +103,16 @@ ext_rgmii_phy: ethernet-phy@1 {
>         };
>  };
>
> +&mmc1 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&mmc1_pins>;
> +       vmmc-supply = <&reg_dldo4>;
> +       vqmmc-supply = <&reg_eldo1>;
> +       non-removable;
> +       bus-width = <4>;
> +       status = "okay";
> +};
> +
>  &mmc2 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&mmc2_pins>;
> @@ -174,6 +184,19 @@ &uart0 {
>         status = "okay";
>  };
>
> +&uart1 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
> +       uart-has-rtscts = <1>;
> +       status = "okay";
> +
> +       bluetooth {
> +               compatible = "realtek,rtl8723bs-bt";
> +               device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
> +               host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
> +       };
> +};
> +
>  /* On Pi-2 connector */
>  &uart2 {
>         pinctrl-names = "default";
> --
> 2.25.1
>
