Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13D32AD281
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgKJJbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJJbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:31:36 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA4FC0613CF;
        Tue, 10 Nov 2020 01:31:36 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id v18so13910734ljc.3;
        Tue, 10 Nov 2020 01:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZzUeLUSzED/NYF/wlcfMe4axUEZhGHtLkzkeiA+8sI=;
        b=fECK1GFswwZVrvBSEBiNzO2LS+qCNfBF8ZMdDejkwlJVudv1rtFL4/5VbBVxGqmQ/+
         0AwjucQX+Hwh2BPuwqCBea7xS6nkgRffiC/gCHkZSI9Q98MKl25PwUN6kkf98AT7J8Oe
         EeuwyEb5lzB9nIjd20wQaVQFXMJIYZWoozuOQtI7p+q8Wobyf3i6DVU9eWJb2CYKvWMC
         5aVsFJe48txhcaDvVuaks6crNOBWznNdWqBn0cORvYEAQcftEExuq1rLqXBh9XpxppYr
         4ce+iMwLharYadkDzipW21uljCZb/9XdQ5ZJdTEQea+adVKVEjjpuJfHY2/+5cHe08nk
         Akhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZzUeLUSzED/NYF/wlcfMe4axUEZhGHtLkzkeiA+8sI=;
        b=YwC68c20/yUIvUShmJc+WL9vKI9jgPrXpNV/m3ESpOansABaUYpt7Rk6lxo9NxlYcJ
         mXD54JaTiyLEWtaT7/7T8SCgexJz8RW5zCr9VU2gVGsLxDpEGTpSWnkPUS8j21gredSM
         sZUOu1j8CDJKnWghCfsP3AH1KRCYcSvY9s8t7jzCKL5UY7HUlUvf9GxmoAkvUSH5lbfZ
         1ILBQLf34L7qAC6R1/RtyFXES5reZ7mhh7qEwTXn9kmPpiJeNLh9DwJPWQq+X+q+agoA
         0oLdTOMBPMHVpkK30N7NSQw8s+2DQyLmt5KNf0/V6O2S2u3DiiNwTL4CBAE81sOV7jOk
         GHhg==
X-Gm-Message-State: AOAM533r6K8SQv9xf10Hy6VZhUKPkLHSndO6zoQSqXptUcwG4R/hzM1M
        3SCk62aE9KNT+XX4sAghy6ahk4ZO/oM=
X-Google-Smtp-Source: ABdhPJztddytDpiY5uFOds8GXmrDV34SH4jlXef3pFwX7KyDQfmCDksoGaG7QwPZb3xgytQBrqwNgQ==
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr7742089ljm.142.1605000694955;
        Tue, 10 Nov 2020 01:31:34 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id g10sm2034768lfc.179.2020.11.10.01.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 01:31:34 -0800 (PST)
Subject: Re: [PATCH 05/10] ARM: dts: BCM5301X: Provide defaults ports
 container node
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-6-f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <5c424006-90ea-aee3-db2e-96b3a627a4a6@gmail.com>
Date:   Tue, 10 Nov 2020 10:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110033113.31090-6-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  10.11.2020 04:31, Florian Fainelli wrote:
> Provide an empty 'ports' container node with the correct #address-cells
> and #size-cells properties. This silences the following warning:
> 
> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
> ethernet-switch@18007000: 'oneOf' conditional failed, one must be fixed:
>          'ports' is a required property
>          'ethernet-ports' is a required property
>          From schema:
> Documentation/devicetree/bindings/net/dsa/b53.yaml
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   arch/arm/boot/dts/bcm5301x.dtsi | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
> index 807580dd89f5..89993a8a6765 100644
> --- a/arch/arm/boot/dts/bcm5301x.dtsi
> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
> @@ -489,6 +489,10 @@ srab: ethernet-switch@18007000 {
>   		status = "disabled";
>   
>   		/* ports are defined in board DTS */
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};

You can drop those two lines from board files now I believe.

grep "ports {" arch/arm/boot/dts/bcm470*
+ arch/arm/boot/dts/bcm953012er.dts
