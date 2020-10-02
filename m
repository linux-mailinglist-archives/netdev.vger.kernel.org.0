Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6C2816AF
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgJBPeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbgJBPeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:34:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0EC0613D0;
        Fri,  2 Oct 2020 08:34:00 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so1479805pfc.7;
        Fri, 02 Oct 2020 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1u5DHSgPvfJnxuXAGcYpoZqPhgnicM/Uc6lZhhDs3W8=;
        b=LR9UXNg5SiQ0mEZ5YOEuwwwQ3K/sPR0QgdhN+RVk3yHJttj3q7BeplSqc8gy/u0QQs
         PhG0z4SD3AdFOxpSTkRy3zJw2vX1fPIu6cl4r4g4aq1itUHVCdyT2FybdvifYsS6f434
         O0LuptDJrejVFP7po8f+uwdyNuw+ebOuJ+GTOYuqcZA8nAhPiIxamJ6rAJ8vWyyMo56S
         2VqFQHvM7KYFLUdUlNLBlCGurEcJdRfvRzR/jwWUlZjgKoOyQ/wkyTTYV5Wh+vyTgO+/
         ea3kkRCAvvCdwFoDcLP6qB40/ZLt79f/0kJZljYK0FaP3bMydh74mFyqO5fdPjcmInOf
         1t5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1u5DHSgPvfJnxuXAGcYpoZqPhgnicM/Uc6lZhhDs3W8=;
        b=U2zfhboebinPh41T2kE7DMAPVqoSBdPL7cNeHmYRTOJOKt0REcN1ZSIQiLYNF+Rv5T
         9VivBHWIvry1wpFK+Qarkfyd0ubuL0W1QCD3eyk0p6PjCOzCkwJbZ2DuO4HBPJP7O1io
         UyT28DDi/142dWJ4zdFx8P9KLBZrB2kaCqwc8x/qOKNsrOyhhmL17eJLdRD61BaFM5iV
         4ABP635gA2mxszGVoMsdtZaS10qHJsYXDXZiDtECNyvSCpkP3O+y7Hku9I5oWSgq7gdU
         3nNAwPu+8mPQDLeweJ1sMEzV0SCwcPpj9mYXyVWv+++Qu2m3/sz+JmjuVRnoKMndo4aB
         3lAQ==
X-Gm-Message-State: AOAM532esWN2qI2FHQ6yyWdc5AunI3JqAuo4KGBqxjV5NIUQcXLTwsI9
        FCd3jBl50sl4ljWziWx/is87qbD6in87Xw==
X-Google-Smtp-Source: ABdhPJzZrEGvd2qlqAHlSI1Ix0tcMeXFlJowsm5xcxteqwDSMd6myDKAs3wn9ggC4Bmz2tPKYy/ZYg==
X-Received: by 2002:a65:42c2:: with SMTP id l2mr2803892pgp.61.1601652839201;
        Fri, 02 Oct 2020 08:33:59 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ml20sm1912810pjb.20.2020.10.02.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:33:58 -0700 (PDT)
Subject: Re: [RESEND net-next 1/9] arm64: dts: ls1088a: add external MDIO
 device nodes
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
 <20201002144847.13793-2-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5c9c03b-8839-4923-b9f8-7ab9a9554d43@gmail.com>
Date:   Fri, 2 Oct 2020 08:33:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002144847.13793-2-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2020 7:48 AM, Ioana Ciornei wrote:
> Add the external MDIO device nodes found in the WRIOP global memory
> region. This is needed for management of external PHYs.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>   arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> index 169f4742ae3b..22544e3b7737 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> @@ -654,6 +654,24 @@ ptp-timer@8b95000 {
>   			fsl,extts-fifo;
>   		};
>   
> +		emdio1: mdio@0x8B96000 {

You should drop the 0x fro the unit address and likewise below.
-- 
Florian
