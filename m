Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F87C115A6D
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 01:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfLGAyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 19:54:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42607 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfLGAyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 19:54:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so9642643wrf.9
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 16:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YyHqnh3RgU+jkragtEYCmywD+W1GeJPYa5pDIp3hGtA=;
        b=FcTHjpXtuWKl1ktGy/jvKmj2CEIxaOGf7WtJh22SSUSCoRnxI007b1epPMs2yzPAU6
         8XKVC+aUUW4HrvmDIskh7Faxk/Hkh/OBnV3BQ53u77XgaJZ944tnynobm08sy3X5HTGy
         p9ox1+HGbfpaQpNgvjmcoidglRxGol+snYZog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YyHqnh3RgU+jkragtEYCmywD+W1GeJPYa5pDIp3hGtA=;
        b=tQmNHW6P4rx+5qqCFyoWJKuNS5IBvep18HtdI1H5gDrnnxz+OfV+P9Rk6bodue+0fq
         Ctr7l1qbgOZvL6df+akoOPPcOJQcUvMrgSuywu9NEoGi9n7wBhJjQmSyzbhH7+LWdJUL
         /PNu0vHlz947nbqi4qadEaZ1QBueTTfcxJfkwcuIY7cXMmrhKTt3UZQPcNkVqhEST1gi
         tbAFd+OR7AySJPqlBqSOtSyc1bEWPtwt4WH8gDt6Ea9RdaNNiFIkmHUedN1DCz6Lx1h5
         48MB6i1p//9i1SKZo/Jx+GXywV7k+YIkZeK/N+Dn8XLb/NbYJOViWgRKPv4RsH8rD701
         WMCg==
X-Gm-Message-State: APjAAAXmWCc3aRljwhgpxqXjXusAcDMSo9iMBeRszpPqLSBnroVjbN71
        yWZ8381OvS/lgapoGHWhAXS4yQ==
X-Google-Smtp-Source: APXvYqycLhNIOEqhQ1FJre7Q/J/PU8EfKeYG6wG58YToIgr2m9pkiKsbRjmM2iUnZ/GXddXke7yIhQ==
X-Received: by 2002:a5d:540f:: with SMTP id g15mr17461759wrv.86.1575680069042;
        Fri, 06 Dec 2019 16:54:29 -0800 (PST)
Received: from rj-aorus.ric.broadcom.com ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id h97sm19347000wrh.56.2019.12.06.16.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 16:54:28 -0800 (PST)
Subject: Re: [PATCH] ARM: dts: Cygnus: Fix MDIO node address/size cells
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     grygorii.strashko@ti.com, simon.horman@netronome.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20191206181909.10962-1-f.fainelli@gmail.com>
From:   Ray Jui <ray.jui@broadcom.com>
Message-ID: <86e8fbec-f9e5-28d8-cc58-c12ce53a18e9@broadcom.com>
Date:   Fri, 6 Dec 2019 16:54:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191206181909.10962-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 10:19 AM, Florian Fainelli wrote:
> The MDIO node on Cygnus had an reversed #address-cells and
>   #size-cells properties, correct those.
> 
> Fixes: 40c26d3af60a ("ARM: dts: Cygnus: Add the ethernet switch and ethernet PHY")
> Reported-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   arch/arm/boot/dts/bcm-cygnus.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
> index 2dac3efc7640..1bc45cfd5453 100644
> --- a/arch/arm/boot/dts/bcm-cygnus.dtsi
> +++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
> @@ -174,8 +174,8 @@
>   		mdio: mdio@18002000 {
>   			compatible = "brcm,iproc-mdio";
>   			reg = <0x18002000 0x8>;
> -			#size-cells = <1>;
> -			#address-cells = <0>;
> +			#size-cells = <0>;
> +			#address-cells = <1>;
>   			status = "disabled";
>   
>   			gphy0: ethernet-phy@0 {
> 

Looks good! Thanks!

Reviewed-by: Ray Jui <ray.jui@broadcom.com>
