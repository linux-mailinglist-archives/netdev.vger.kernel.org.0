Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A5D251F41
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 20:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgHYStW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Aug 2020 14:49:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52937 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYStU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 14:49:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id x5so3660175wmi.2;
        Tue, 25 Aug 2020 11:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=lwlHflOE4Bg8GdD7kpfA2k4MUUB6oSMZ6rjs7tdlxjk=;
        b=GQh/5LNNwwYo3RfuGclP9MKz1aWiNI/txOSQ7ntjEyRCTM40Isw+DKTpfuEhAwfOK4
         qT1cBkGfQfJsfB21vwAToXgEb+NWa/sJXJb4uy45hyYbFBf7s8+5k6ImE+VkSBXDRcml
         SWhqEv1FMBDXQY5LdoUCKZEDm/s778dqHxsi4AROYzkYzvjKqjvNfeh/veUwO3v467NQ
         wCYVx2J/+nuvxf0zq3ZIv3uv4xLHelkB9UCmPF7Tkzb5hMbJCJ+DqLq/R8WNHZD2xW2X
         pBDNQxIWicXuPUyFTbYEiYTCFC2CD/iZadcMUWHV5Pw92C+RdHfe/U+tWe3INTk/oDKD
         sb9A==
X-Gm-Message-State: AOAM533nVnRU85PDgqLuCJuVsnZYw/Qy1Brtcmaa1jlrM8y/YVlqhECe
        2v6Ix6hvYS58EAo3LVP6qpE9z9tYMPI=
X-Google-Smtp-Source: ABdhPJy+C0eo7c2RxD1Gpi+NLpYBFVtKtj9PQvX0Zbfdy+e8F4TgRXykHdY/YRcIvDVUJ/iHHC4h3A==
X-Received: by 2002:a1c:1fcb:: with SMTP id f194mr3434635wmf.28.1598381357412;
        Tue, 25 Aug 2020 11:49:17 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id y142sm8270483wmd.3.2020.08.25.11.49.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 11:49:16 -0700 (PDT)
Date:   Tue, 25 Aug 2020 20:49:14 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 2/3] ARM: dts: Add ethernet
Message-ID: <20200825184914.GB2693@kozik-lap>
References: <20200825170311.24886-1-l.stelmach@samsung.com>
 <CGME20200825170323eucas1p2d299a6ac365e6a70d802757d439bc77c@eucas1p2.samsung.com>
 <20200825170311.24886-2-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200825170311.24886-2-l.stelmach@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 07:03:10PM +0200, Łukasz Stelmach wrote:
> Add node for ax88796c ethernet chip.

Subject
  ARM: dts: exynos: Add Ethernet to Artik 5 board

> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> index 20446a846a98..44151a2cb35d 100644
> --- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> +++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> @@ -37,3 +37,24 @@ &mshc_2 {
>  &serial_2 {
>  	status = "okay";
>  };
> +
> +&spi_0 {
> +		status = "okay";
> +		cs-gpios = <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
> +
> +		assigned-clocks        = <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SPI0_PRE>, <&cmu CLK_SCLK_SPI0>;
> +		assigned-clock-parents = <&cmu CLK_FOUT_MPLL>, <&cmu CLK_MOUT_MPLL>,    <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu CLK_DIV_SPI0>,     <&cmu CLK_DIV_SPI0_PRE>;
> +
> +		ax88796c@0 {
> +			compatible = "asix,ax88796c";

Isn't checkpatch complaining about undocumented compatible? I didn't see
a binding here.

> +			interrupt-parent = <&gpx2>;
> +			interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> +			spi-max-frequency = <40000000>;
> +			reg = <0x0>;
> +			reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;

One line break.

> +			controller-data {
> +				samsung,spi-feedback-delay = <2>;
> +				samsung,spi-chip-select-mode;

What does samsung,spi-chip-select-mode mean? git grep does not find a binding.

> +		};
> +	};

Whatever formatting you used here, it is not Linux coding style. Please
fix indentation, linewrapping.

Best regards,
Krzysztof
