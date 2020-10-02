Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904642816BC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388224AbgJBPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:37:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEA5C0613D0;
        Fri,  2 Oct 2020 08:37:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id n14so1490891pff.6;
        Fri, 02 Oct 2020 08:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tW/tQRJkx7M0MHOQZke642HuatkzRo9Oo4QqDIuWkwU=;
        b=RW/Zlno5dwvcjqyiBel/glNmwoJCaph1KEcHThPQpyp7VIMrUd3uuZImc6YHcTlkjQ
         86rKzCAX5DCH0U1R1AnSXobYtmXj1o45AkxNOBeOV6HC/ol3NQExXfxWrut72gRJcePA
         oXl4MD2Jd+7UYTMXtyT2mBS4FeCNLxXgGvtD/btV82y5aHIq8WTeRPY4ByiGLSNK/ww1
         pGQnPgyctqz1oAWsJ9O5KtKMb2fc+iWaB/quy/mK5LLy/u0DVZqdvwhTRrCONijFzlXQ
         x+HnQRHcnBNfuSLmG7UXI+Mns1EHC4PcDadPd+7NQFgZCEdjg19krlhRpnKLst7UqmgT
         uI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tW/tQRJkx7M0MHOQZke642HuatkzRo9Oo4QqDIuWkwU=;
        b=MeKNlWIZyvNhxamfrEr3jBp7bCFTYjQokV0wHQdbr5wkUsWuZWQOIEeQP+u6rXdNrQ
         etMpg7hvuf2ftuhuISl4Xdbzlyb6kmiBWOmpyzmvKDq0bLXubEHxNslPJ9vvn0x1bmUH
         ZZ5aErBT9gXu2raurQiGCrMMQgOxRFCa3gXfBwhZmBYTZSIvssI7CkhCn8l2xaHIrXng
         i5kYw6XHQs97Pc42QY+ohBKfrVQbrjl34u6p2EpeIvFn2MfcXWEP+rbHNXbAqlRZQWn/
         zQDzmH959lDkpMdMqGzy9N39C7dlV2KcfB3ZKNjUT9Tk3tAmPzoqAF1uhv4FTzSNXRHw
         Aw6Q==
X-Gm-Message-State: AOAM532AFKg6Vish6T0NTOTRkwrOPa+pd2Q0zI5H4HnT1+MCxKE3QOR6
        kGXZts5ggstBwUaP8LpGChOQSzYKK/RsxQ==
X-Google-Smtp-Source: ABdhPJwcfZcVKbs/4+yqAPz2kOarpxrU1z/XvjQ1akojCTvXjFSIFsux2YwtnLZxdFSynJi5dUApfA==
X-Received: by 2002:aa7:8e54:0:b029:142:2501:34d2 with SMTP id d20-20020aa78e540000b0290142250134d2mr3260389pfr.43.1601653029546;
        Fri, 02 Oct 2020 08:37:09 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm1683921pgj.77.2020.10.02.08.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:37:08 -0700 (PDT)
Subject: Re: [RESEND net-next 2/9] arm64: dts: ls1088ardb: add QSGMII PHY
 nodes
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org
References: <20201002144847.13793-1-ioana.ciornei@nxp.com>
 <20201002144847.13793-3-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02d2d46c-8a88-2d44-f8b7-ed73cae93eda@gmail.com>
Date:   Fri, 2 Oct 2020 08:37:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002144847.13793-3-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2020 7:48 AM, Ioana Ciornei wrote:
> Annotate the external MDIO1 node and describe the 8 QSGMII PHYs found on
> the LS1088ARDB board and add phy-handles for DPMACs 3-10 to its
> associated PHY.  Also, add the internal PCS MDIO nodes for the internal
> MDIO buses found on the LS1088A SoC along with their internal PCS PHY
> and link the corresponding DPMAC to the PCS through the pcs-handle.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>   .../boot/dts/freescale/fsl-ls1088a-rdb.dts    | 100 ++++++++++++++++++
>   .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |  50 +++++++++
>   2 files changed, 150 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> index 5633e59febc3..d7886b084f7f 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
> @@ -17,6 +17,98 @@ / {
>   	compatible = "fsl,ls1088a-rdb", "fsl,ls1088a";
>   };
>   
> +&dpmac3 {
> +	phy-handle = <&mdio1_phy5>;
> +	phy-connection-type = "qsgmii";
> +	managed = "in-band-status";
> +	pcs-handle = <&pcs3_0>;

from net-next/master

  git grep 'pcs-handle' Documentation/devicetree/bindings/*
zsh: exit 1     git grep 'pcs-handle' Documentation/devicetree/bindings/*

Is there a binding that we are missing?
-- 
Florian
