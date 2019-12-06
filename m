Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8069114E2E
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLFJby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:31:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45019 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfLFJby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:31:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so6953091wrm.11
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 01:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bjrso+OQmafKmtEWvkVUYyImbpjYTr/XVyq1DXIdCUo=;
        b=iAfWz5YzYiRiCZNhuRr09t/FmQAw6p9+6vvfi93jLSt0oiMp2cW85uVDW+iRBk8+GY
         cv8P2u7lQRhHDc9U0Zjh8Sq9erBdatuluurIKWMAlrGTkXleJqRL41aq8Hnh3fLnIZbb
         5aAYbxF0vgc35DJEeCjtl4JVUg10Vi1CHnSTukkdO6yTlU53yTL1tOhEnj+EqtgCjGyB
         dySLIE/vMuo5LM26UU8Xg2FMuvoN3lYNGwG5eh7cDRKxmuWB9hioLHWe/F8Z9b0dVMWa
         GSAslfT6xv2jseDndnHvZiyT0mOtfFKFAnrkrUq1Gk2qtYJiz+mVpQJ/xoPuhivCHamj
         xP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bjrso+OQmafKmtEWvkVUYyImbpjYTr/XVyq1DXIdCUo=;
        b=ikP+nLRVE3ZRRGHeCzSmIid6Q0B9wKxDk8NtVZaMo2wfGPyHjc8AYgq/PDKXUaoPGz
         anEQ7AQ3bnbioLsadN30+uMvwmrXxbbpfjIZ23qjsO5ieHtj6/g2Azfq3F8YuOBTx+0N
         06IIiOY/lzaCOIfiQxmScbuMKlZ7OJIcrxf6IOrR/ZVZaSo6tTOSA3KjuW4G8RoQ5b8o
         aYUcae1exvhLLlhJDbbV3gC7LxNZBKKMtaX14Du02wwkGch6coLi58Y3XtxdghOc9nH3
         S8yOQSr+MBT2y3hsUTIvRLXkvCU62iJfbD4YDJojxpPsCQCkX8rAiOmR0av7JtI5K1LZ
         qbMw==
X-Gm-Message-State: APjAAAW8SabKvq1UXaoCKSE8dWOr9Rs0JQ/6uHv0pf0JpxCLh7MDR+B3
        NtcUupqleRvSCg3sERnZaB+DfA==
X-Google-Smtp-Source: APXvYqwSvgXZPZYvhH5/TP4F6vU9XeDDqHNqzU+AeFmI0rkq740MlfQL7vuwL6pHE+wm5JOCIGoNMg==
X-Received: by 2002:a5d:5487:: with SMTP id h7mr14371488wrv.18.1575624712378;
        Fri, 06 Dec 2019 01:31:52 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id v188sm2950016wma.10.2019.12.06.01.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 01:31:51 -0800 (PST)
Date:   Fri, 6 Dec 2019 10:31:51 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@vger.kernel.org, grygorii.strashko@ti.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: BCM5301X: Fix MDIO node address/size cells
Message-ID: <20191206093150.GA27144@netronome.com>
References: <20191206000421.12541-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206000421.12541-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 04:04:21PM -0800, Florian Fainelli wrote:
> The MDIO node on BCM5301X had an reversed #address-cells and
>  #size-cells properties, correct those, silencing checker warnings:
> 
> .../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> 
> Reported-by: Simon Horman <simon.horman@netronome.com>
> Fixes: 23f1eca6d59b ("ARM: dts: BCM5301X: Specify MDIO bus in the DT")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks, make dtbs_check seems a lot happier now.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

FWIIW, I think a similar change might also be in order for bcm-cygnus.dtsi.

> ---
>  arch/arm/boot/dts/bcm5301x.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
> index 372dc1eb88a0..2d9b4dd05830 100644
> --- a/arch/arm/boot/dts/bcm5301x.dtsi
> +++ b/arch/arm/boot/dts/bcm5301x.dtsi
> @@ -353,8 +353,8 @@
>  	mdio: mdio@18003000 {
>  		compatible = "brcm,iproc-mdio";
>  		reg = <0x18003000 0x8>;
> -		#size-cells = <1>;
> -		#address-cells = <0>;
> +		#size-cells = <0>;
> +		#address-cells = <1>;
>  	};
>  
>  	mdio-bus-mux@18003000 {
> -- 
> 2.17.1
> 
