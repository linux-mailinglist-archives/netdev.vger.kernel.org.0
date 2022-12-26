Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2B86561AE
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiLZJvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLZJuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:50:55 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829721E7
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 01:50:54 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id o127so11274233yba.5
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 01:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MVRMGgw5dZzGQ0O6oGmpkNqTNghKBHu8OTMDeKct+WY=;
        b=z3wKFmZq4nKiUjZ8HaFH8u9iM0e6RXTdhqrNMXgLwtAt00KRkaNxgaUek5hp3jdnIi
         M5oNVjuNvrxN3x+KoKxy5g7RsTuYqoXJpaLQR6Akte4Jz5VQXORt/R3+I9PkXIIFV770
         /1TbsgwknqWA3dMNAAF6EMje0KLRIobWr72dIVYmNnpa12pmVYWVcyWFrzcfrvZ/MbTB
         iGsDCA25JeFDcdfPmTfqnQHJSc1mffTtIfB9xUSB640gWeo6QWeJGnL4umK7JTsZRUtT
         pZF7KmhzaVfg9JrKg4WDW04Yd1lqrNjWbNHbOq2Y3P3q87Do4MFWj8m7NjrX4v//Y0fw
         GX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MVRMGgw5dZzGQ0O6oGmpkNqTNghKBHu8OTMDeKct+WY=;
        b=z8KckiKrXQk3N3toM0mD+uT7pWvkWJ3TiFt94v2Vk7ihOZGyoqXnV8H06o8RatbB9R
         h+zYWSh5RgbQs5taBuGcNPUMhGnQH4cAnmbgPlmAWOkhK4rqSoClqo5YjYBQSb3J+Xjz
         dL/Q6YlJ6R0YyDcAjn3eAkIg952GrqaIS0OvIjx7xXuGjd6qQjRqnyWlwCiIrRHdX3PQ
         nl/6cniRNtkGDP6JFijfnPAAsKnKkCstiWou6adERRwkCuSzKJ25DTisw1pWfcraiuWB
         Ekd5XBktmaqXtuJTlTuAepGNqhaGQaOS+rUcoX5sgIXWTUuuLsCPdcSL7Wcv7r9/irQW
         ejZw==
X-Gm-Message-State: AFqh2krK7Rb8qAEjmnY46qHCT53nb6cgIkjGoJVv4ucxjlgU267CrBYp
        Ji5HYOShedUno8lUBEddMHocQ9otwzZ2XmVH1F99fA==
X-Google-Smtp-Source: AMrXdXvqf1hQEjhW4lczrPyf4YLQcHk253xaw8k5GNKURUZpf5nY94o373rSr1jZnnV9kbH/Dxwnjfrs5J7a0B/+Q50=
X-Received: by 2002:a25:c616:0:b0:706:d51a:bf7e with SMTP id
 k22-20020a25c616000000b00706d51abf7emr2167083ybf.416.1672048253769; Mon, 26
 Dec 2022 01:50:53 -0800 (PST)
MIME-Version: 1.0
References: <20221226063625.1913-1-anand@edgeble.ai> <20221226063625.1913-3-anand@edgeble.ai>
In-Reply-To: <20221226063625.1913-3-anand@edgeble.ai>
From:   Jagan Teki <jagan@edgeble.ai>
Date:   Mon, 26 Dec 2022 15:20:43 +0530
Message-ID: <CA+VMnFwq=iHBMtpu6QQKdPDoMz8zU-4WyNOJmvHaCRgXx4RVNg@mail.gmail.com>
Subject: Re: [PATCHv2 linux-next 3/4] ARM: dts: rockchip: rv1126: Add GMAC node
To:     Anand Moon <anand@edgeble.ai>
Cc:     Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Dec 2022 at 12:07, Anand Moon <anand@edgeble.ai> wrote:
>
> Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
> add GMAC node for RV1126 SoC.
>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> ---
> drop SoB of Jagan Teki
> ---
>  arch/arm/boot/dts/rv1126.dtsi | 63 +++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/arch/arm/boot/dts/rv1126.dtsi b/arch/arm/boot/dts/rv1126.dtsi
> index 1cb43147e90b..bae318c1d839 100644
> --- a/arch/arm/boot/dts/rv1126.dtsi
> +++ b/arch/arm/boot/dts/rv1126.dtsi
> @@ -90,6 +90,69 @@ xin24m: oscillator {
>                 #clock-cells = <0>;
>         };
>
> +       gmac_clkin_m0: external-gmac-clockm0 {
> +               compatible = "fixed-clock";
> +               clock-frequency = <125000000>;
> +               clock-output-names = "clk_gmac_rgmii_clkin_m0";
> +               #clock-cells = <0>;
> +       };
> +
> +       gmac_clkini_m1: external-gmac-clockm1 {
> +               compatible = "fixed-clock";
> +               clock-frequency = <125000000>;
> +               clock-output-names = "clk_gmac_rgmii_clkin_m1";
> +               #clock-cells = <0>;
> +       };

These seems not needed,
