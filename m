Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08DD115DAF
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 18:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLGRNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 12:13:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33588 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfLGRNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 12:13:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so11296189wrq.0
        for <netdev@vger.kernel.org>; Sat, 07 Dec 2019 09:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jR3SyHBUEWSPjBlDW1LeGn/KYMF0y8nruNnoz/13mkQ=;
        b=AFL2+H+B1H0cUjM21DoS+EbPmSeWc+tVjHWCByl0XnHympdA1FNb5GilbogW6Vp6k8
         /0v51aHKBg9h7alJHCY9O0Pyv8JakfMZMXWW+ay7kMm8HztvZcuwFHeYDwih1eOF0MXe
         LUmrdjAIh3/bCLzXYh+/IISmwzaajZ0NH9T1nrmHIkS94ijrr/ua1fh0HO0tepKh4kWz
         Ox0GKA4bkAHKiUulETJQrkXORtnNCIqUj+Y3CgDM11nemud34mfxSKzApX6atyLiVkm4
         Zn3qp9eqjSvlcSFc8xZe8GDFW9fFR/8h5iMxkOawmFJfO92rH1hoIFbXuyB8seCGv41z
         MgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jR3SyHBUEWSPjBlDW1LeGn/KYMF0y8nruNnoz/13mkQ=;
        b=oBOvjtf5udk3pQJXspV5GzrhZ0lkNxUBzgdXdtmLBaIj6DvQCldyuyJExLoiwtDUo/
         8IUotOqHzXW+nf9Xb7Lcu7S9hYz1yrGA4f7XeCdxkH+l+ZfLVDcHsmfdrt7BTWxGLLjk
         Hb3TdocBgWSQFX/RKONNsOUcD91Q5+60TaEeMZlnSZLBfWfnWhOIqv225L6ZcXk1kiJq
         QpXZhhDVq5HAdlL+Z9RksKpFATf48YumDvFn6l483Rbnhc+M6wQ/bbHJB9Swt2RdXdko
         ikGc87pC+AOYnG+C9QNDqHZFlCXz8QVWYFWa+jSekQ6UluJRZSgXObQ5hoOfJpRyVuKm
         FMSw==
X-Gm-Message-State: APjAAAUs/ctsqd2vAyOm42Myjg2Q9DLbFNvkV9pp/ZnTTtLNEArpuuod
        wNJimyrqsVX2TkiiSlfCx85xdg==
X-Google-Smtp-Source: APXvYqzzT6cpEXbdQzFCSXPWWrCMrulA7XTI6/VFmEaL73RKZUx/P2+UHqPR7ey6iRNw14U/hJqzAA==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr22200705wrw.132.1575738816490;
        Sat, 07 Dec 2019 09:13:36 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 2sm21102237wrq.31.2019.12.07.09.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 09:13:35 -0800 (PST)
Date:   Sat, 7 Dec 2019 18:13:34 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, grygorii.strashko@ti.com,
        robh+dt@kernel.org, rafal@milecki.pl, davem@davemloft.net,
        andrew@lunn.ch, mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Eric Anholt <eric@anholt.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Cygnus: Fix MDIO node address/size cells
Message-ID: <20191207171333.GD26173@netronome.com>
References: <20191206181909.10962-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206181909.10962-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 10:19:09AM -0800, Florian Fainelli wrote:
> The MDIO node on Cygnus had an reversed #address-cells and
>  #size-cells properties, correct those.
> 
> Fixes: 40c26d3af60a ("ARM: dts: Cygnus: Add the ethernet switch and ethernet PHY")
> Reported-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Florian,

this looks good to me.

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  arch/arm/boot/dts/bcm-cygnus.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
> index 2dac3efc7640..1bc45cfd5453 100644
> --- a/arch/arm/boot/dts/bcm-cygnus.dtsi
> +++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
> @@ -174,8 +174,8 @@
>  		mdio: mdio@18002000 {
>  			compatible = "brcm,iproc-mdio";
>  			reg = <0x18002000 0x8>;
> -			#size-cells = <1>;
> -			#address-cells = <0>;
> +			#size-cells = <0>;
> +			#address-cells = <1>;
>  			status = "disabled";
>  
>  			gphy0: ethernet-phy@0 {
> -- 
> 2.17.1
> 
