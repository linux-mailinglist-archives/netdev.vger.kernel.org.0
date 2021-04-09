Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58935A606
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhDISqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:46:23 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:36563 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDISqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:46:22 -0400
Received: by mail-ot1-f44.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso6632386otq.3;
        Fri, 09 Apr 2021 11:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z6eFqLMY5P4m+a9liLyXugoPHOz8+XlR7w752+mzNUo=;
        b=bxJbcnhAkgEEUf2DSVJHsNFZ7sKiC68JEW8NsY9CEj/6UjRQQkdIb7/VVdWKOgYWE8
         SU9rQxSn6wQYewRG55C/caUdAcURxY6FK8oRZkFInS8+pNa6Xl1uFbZFv3BQwUk27YEO
         6ao6OdV3Jm48MtMFLx7aZNmKw3SK75cAQfzV8wdv4k3hc6xe74clW9+N+7VQIJuZluAK
         j9IdsVYm09+LUWO63QYSyaKNVolG+ABhMie21HyQEuGHpFJDwqFRXMUw9PuOn2bWZFFx
         2MX2/jyY0unAGECLqMIWAfAaGanmQ/8HoRY+2GUu1jTuikh02sOSE872RdiNjLcD3j1R
         AppQ==
X-Gm-Message-State: AOAM533zuxaLMliA62GpycPcayokt4QtmOIlJD89bA5i56Z3SsMj0Y/Y
        kqYaPi8jNaoA046OPdZUwA==
X-Google-Smtp-Source: ABdhPJzC3gLQPb72Xi9Q9xBqOy7Spb8r25dVX5tVkbGh2PuyEEwC+CaphV3fhpD/E82uO+mZ1P2RTw==
X-Received: by 2002:a05:6830:3115:: with SMTP id b21mr13166754ots.318.1617993969010;
        Fri, 09 Apr 2021 11:46:09 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t14sm762150otj.50.2021.04.09.11.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:46:08 -0700 (PDT)
Received: (nullmailer pid 3943480 invoked by uid 1000);
        Fri, 09 Apr 2021 18:46:06 -0000
Date:   Fri, 9 Apr 2021 13:46:06 -0500
From:   Rob Herring <robh@kernel.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 1/2] dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
Message-ID: <20210409184606.GA3937918@robh.at.kernel.org>
References: <20210408113022.18180-1-shawn.guo@linaro.org>
 <20210408113022.18180-2-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408113022.18180-2-shawn.guo@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 07:30:21PM +0800, Shawn Guo wrote:
> Add optional brcm,ccode-map property to support translation from ISO3166
> country code to brcmfmac firmware country code and revision.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 7 +++++++
>  1 file changed, 7 insertions(+)

Can you convert this to schema first.

> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index cffb2d6876e3..a65ac4384c04 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -15,6 +15,12 @@ Optional properties:
>  	When not specified the device will use in-band SDIO interrupts.
>   - interrupt-names : name of the out-of-band interrupt, which must be set
>  	to "host-wake".
> + - brcm,ccode-map : multiple strings for translating ISO3166 country code to
> +	brcmfmac firmware country code and revision.  Each string must be in
> +	format "AA-BB-num" where:
> +	  AA is the ISO3166 country code which must be 2 characters.
> +	  BB is the firmware country code which must be 2 characters.
> +	  num is the revision number which must fit into signed integer.

Signed? So "AA-BB--num"?

You should be able to do something like:

items:
  pattern: '^[A-Z][A-Z]-[A-Z][A-Z]-[0-9]+$'

>  
>  Example:
>  
> @@ -34,5 +40,6 @@ mmc3: mmc@1c12000 {
>  		interrupt-parent = <&pio>;
>  		interrupts = <10 8>; /* PH10 / EINT10 */
>  		interrupt-names = "host-wake";
> +		brcm,ccode-map = "JP-JP-78", "US-Q2-86";
>  	};
>  };
> -- 
> 2.17.1
> 
