Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ADD31CA92
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 13:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBPMfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 07:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBPMfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 07:35:22 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488CCC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 04:34:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id do6so5805115ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 04:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ueHbYP18tWvlHJTvKfv+KiiuFw4qDAo6d4b9ieKrjtA=;
        b=MEqDpuWJEK/w8J3txlGCNfi6AsGBbRD5uDoOClDxlhBXfP09gDCTC+7b/DkxAnH9q9
         PQzhlHUJVxxdR1PfdxFskI1stRZCsyHqn3VhCztonmpPgDpGHn5ac8KEUwz/G4BCeEAe
         tEP6rgYOjCLGIwIHQMoUXv/8Y2SJpt0Oi2L6euBLpzs7GnPLtk93Pdb0ZSb9GlqdkMuD
         kRf5mk9JW/jjZ28ka9QT+0x1uM2fQHj8ZVp3vUZbQTE36HH4gu5XMCawt82TvmZSBlHI
         DD0Ip+GqAS2CnUXZAZ1Po6tm9lGKrTYUu1GD9s0bW2KfyoypvVOHeUupFn3uXHWXcp4I
         rshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueHbYP18tWvlHJTvKfv+KiiuFw4qDAo6d4b9ieKrjtA=;
        b=sE8XW9Gi1uG++3CVYMGWiwBdfJN3J8YC7J9cAr8F0rqYprQpvYkYmEe+TKeZPc8Jgi
         5qmKHeRoqVlB111TXnQsA7Umx9Hs/8cDxZCaH4AXYqg0xnAxO5tVh4VVHZvb0sbOX+Gu
         5j2Dwxo4Iatz+mpVqfs7/t/seJOU4UMSjdVja7ic9j7+peeiKgY5xedWFyaFpA/9qXJv
         iIJp9IUhUVI/zENd5aRX32r/rXRQsutbU9oMaVXsEoAZ1IcUdnFXqJdiXcCTRgItoAsh
         F50tyy7Y2Y4y2xImFTz0Zq0b5/yPSCK4yJCUNa96VX3/fBUnE+cgx7kSndw59IK4zGJq
         ImDw==
X-Gm-Message-State: AOAM532ctjEh+a8dRyyVky+M59SPe4xeZCAigP4Fc7UR+tP3wQRhqOXB
        kYCxTefc9sTF3Q/t6FB8slv3B5OhfJLl7SZKQKaoEw==
X-Google-Smtp-Source: ABdhPJxf1wGe7JLUEYPK+lXkKOVAhqieiskKqDKYXDU0fKKFmCiFsnUPANuzIUfBs+8lgCkTxrNRZ/1zVRkOl1+/xy4=
X-Received: by 2002:a17:906:685a:: with SMTP id a26mr10974693ejs.503.1613478880844;
 Tue, 16 Feb 2021 04:34:40 -0800 (PST)
MIME-Version: 1.0
References: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp> <20210215152438.4318-5-nobuhiro1.iwamatsu@toshiba.co.jp>
In-Reply-To: <20210215152438.4318-5-nobuhiro1.iwamatsu@toshiba.co.jp>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Feb 2021 18:04:29 +0530
Message-ID: <CA+G9fYtDdZy=aNnB=8eQA2_h8bOtyFuizfbJzcj3OGcqJuM-Gg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] arm: dts: visconti: Add DT support for Toshiba
 Visconti5 ethernet controller
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Leon Romanovsky <leon@kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nobuhiro,


On Mon, 15 Feb 2021 at 21:00, Nobuhiro Iwamatsu
<nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
>
> Add the ethernet controller node in Toshiba Visconti5 SoC-specific DT file.
> And enable this node in TMPV7708 RM main board's board-specific DT file.
>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  .../boot/dts/toshiba/tmpv7708-rm-mbrc.dts     | 18 +++++++++++++
>  arch/arm64/boot/dts/toshiba/tmpv7708.dtsi     | 25 +++++++++++++++++++
>  2 files changed, 43 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> index ed0bf7f13f54..48fa8776e36f 100644
> --- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> +++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> @@ -41,3 +41,21 @@ &uart1 {
>         clocks = <&uart_clk>;
>         clock-names = "apb_pclk";
>  };
> +
> +&piether {
> +       status = "okay";
> +       phy-handle = <&phy0>;
> +       phy-mode = "rgmii-id";
> +       clocks = <&clk300mhz>, <&clk125mhz>;
> +       clock-names = "stmmaceth", "phy_ref_clk";
> +
> +       mdio0 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "snps,dwmac-mdio";
> +               phy0: ethernet-phy@1 {
> +                       device_type = "ethernet-phy";
> +                       reg = <0x1>;

This build error was noticed on LKFT builder while building arm64 dtb
on linux next 20210216 tag.

arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts:52.3-4 syntax error
FATAL ERROR: Unable to parse input tree

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

https://gitlab.com/Linaro/lkft/mirrors/next/linux-next/-/jobs/1033072509#L382

--
Linaro LKFT
https://lkft.linaro.org
