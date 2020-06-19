Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7D2200180
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 07:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgFSFCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 01:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgFSFCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 01:02:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86720C06174E;
        Thu, 18 Jun 2020 22:02:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k2so3585329pjs.2;
        Thu, 18 Jun 2020 22:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SiDB1J01wn7pLbZQ7NN544CR9V1CL0STkwNstWzaeL0=;
        b=Q+p8djyOFrojiC/CZXUfS2ozp4zwZo8x4pCbOFnDoDovi3kHP3dyPWsIZ8H7cf1cBM
         X8NZycMVklwlkXQ1DPTKMhKcaAo7+GIb2XPh36gbjYSLX8GE5wxKV6GxuTAKLUsqLqia
         6A2sz7QFWkjFescqu915j41GpLDPr0JfGAa0OArqggX4OcHp0q9HT9Gm7lMlSaCKfvCe
         3CpJFenzu8paxoAomHeGIZgJByHJVKtfNCBIrTjZyketYTEa7RguWc3mXhyBdwJDAXGW
         Wv0wVANE4WTiJN+HWgvQMp3rPKCNhO1gT1LqGMxhe1O5G+y1Uhkp26jhYdz75Y3ipGtp
         D9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SiDB1J01wn7pLbZQ7NN544CR9V1CL0STkwNstWzaeL0=;
        b=TdAUg/Mse5srkZX8FAfnS+RS8osM9pKIAYMYvtWe6P+ymqZRuhE62weGyF1dDky6Gb
         cKI2uvQVfvRfZr6Hr37qgrjf3C9S/+mVeH+WOXfqLrN8yUugmYuF5mxno7lTAeboZY7f
         4wttvrqUFnq9rN7UXAbGso4J3n+KcuWpLLVMJYbBpIBRlO6KtBZ3S6KsHVqO7zFkqPnv
         T6SJUKVMdDZqHLOfJxp9azi0G9PxbVbzDnbOsna5Y4yQAKPliYxW6q0i1lC1GDakr3en
         47ys1x848oBsiR5kg8UB7Oi+Z82LKe6xNBMlEuavNCg6kUIL04CGdwAWa7JktiGA1kjF
         IFfQ==
X-Gm-Message-State: AOAM530nFw7vRYW2JMRoDHrWEY/PDnFJVB+9H2YDttU215vK9ZCRDHzk
        FZrYR1YMMB/NuPBUP4RCYGU=
X-Google-Smtp-Source: ABdhPJzzw16q71O4BfPkHNLVa5OmqTfgAuceKUIEfpvaV41w5KPGLKxCaBtIOZhpdXHXEx6EQJD3wQ==
X-Received: by 2002:a17:902:e901:: with SMTP id k1mr6599989pld.92.1592542921858;
        Thu, 18 Jun 2020 22:02:01 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i63sm3992094pje.34.2020.06.18.22.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 22:02:00 -0700 (PDT)
Subject: Re: [PATCH v5 2/3] dt-bindings: net: mscc-vsc8531: add optional clock
 properties
To:     Heiko Stuebner <heiko@sntech.de>, davem@davemloft.net,
        kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
References: <20200618121139.1703762-1-heiko@sntech.de>
 <20200618121139.1703762-3-heiko@sntech.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a877e41d-4c3c-c4c2-1875-71e1e08cf977@gmail.com>
Date:   Thu, 18 Jun 2020 22:01:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618121139.1703762-3-heiko@sntech.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 5:11 AM, Heiko Stuebner wrote:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> Some mscc ethernet phys have a configurable clock output, so describe the
> generic properties to access them in devicetrees.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> ---
>  Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> index 5ff37c68c941..67625ba27f53 100644
> --- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> +++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> @@ -1,6 +1,8 @@
>  * Microsemi - vsc8531 Giga bit ethernet phy
>  
>  Optional properties:
> +- clock-output-names	: Name for the exposed clock output
> +- #clock-cells		: should be 0
>  - vsc8531,vddmac	: The vddmac in mV. Allowed values is listed
>  			  in the first row of Table 1 (below).
>  			  This property is only used in combination
> 

With that approach, you also need to be careful as a driver writer to
ensure that you have at least probed the MDIO bus to ensure that the PHY
device has been created (and therefore it is available as a clock
provider) if that same Ethernet MAC is a consumer of that clock (which
it appears to be). Otherwise you may just never probe and be trapped in
a circular dependency.
-- 
Florian
