Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8549581C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 03:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378347AbiAUCIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 21:08:23 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:44554 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244982AbiAUCIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 21:08:23 -0500
Received: by mail-oi1-f177.google.com with SMTP id s9so11602559oib.11;
        Thu, 20 Jan 2022 18:08:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Th8jqPs6GFoz5iooqRTIVf8WJqjULNpYX9hZBAb1zBw=;
        b=I62YOvpEiSCd6Yz7wq0o67k1FBDItELWVrYRtmvULwAMmvM4acPZgRB65VyEMgu6Cd
         hGPXry+UlZmAosj8fFS8cdx+o+2gkjYy9svp6sQIHILF+PytqQnb5Miyp200dKBxsg7e
         KRkD5NQ31HUnMUwucgfYHdKtLgGGL4qpUIO9Nhpx9DH0Bss1Y0dAFhJ/2Dw4bRo94Py5
         VpP75iJjO9ij/pbPwctZueFmb6BTJomI+Uj1fQYnFxHIcD7t3I171/xHVGhkMTDMWIQV
         Wu1df1cr9aaTSTmQ2oGgYOumZg3m6LPr/Oj+dvmu2zn31YOfBG6n07XMuJAbiX4XFc2k
         Ex2Q==
X-Gm-Message-State: AOAM531WGnjEdYi2s5cBlBXm8+fFRf25h0cCHGL8nhhSd5xX6T2IpMKE
        GpMoFau4Ml2Le+sos3cNvewCxgY/dA==
X-Google-Smtp-Source: ABdhPJyNkHt8brbyQs2aPnhIQLpEwQ9IcTq4y/uVsGTexWPEkPQd7CruZkZC8kYCcX5gJ5Nkw//RDw==
X-Received: by 2002:aca:4b03:: with SMTP id y3mr1597101oia.82.1642730902545;
        Thu, 20 Jan 2022 18:08:22 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t14sm406585ooq.9.2022.01.20.18.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 18:08:21 -0800 (PST)
Received: (nullmailer pid 2359343 invoked by uid 1000);
        Fri, 21 Jan 2022 02:08:20 -0000
Date:   Thu, 20 Jan 2022 20:08:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 2/4] dt-bindings: net: Document fsl,erratum-a009885
Message-ID: <YeoVlBEWWlqDf7NG@robh.at.kernel.org>
References: <20220118215054.2629314-1-tobias@waldekranz.com>
 <20220118215054.2629314-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118215054.2629314-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 10:50:51PM +0100, Tobias Waldekranz wrote:
> Update FMan binding documentation with the newly added workaround for
> erratum A-009885.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  Documentation/devicetree/bindings/net/fsl-fman.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
> index c00fb0d22c7b..020337f3c05f 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fman.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
> @@ -410,6 +410,15 @@ PROPERTIES
>  		The settings and programming routines for internal/external
>  		MDIO are different. Must be included for internal MDIO.
>  
> +- fsl,erratum-a009885

Adding errata properties doesn't work because then you have to update 
your dtb to fix the issue where as if you use the compatible property 
(specific to the SoC) you can fix the issue with just a (stable) kernel 
update.

Yes, I see we already have some, but doesn't mean we need more of them.

> +		Usage: optional
> +		Value type: <boolean>
> +		Definition: Indicates the presence of the A009885
> +		erratum describing that the contents of MDIO_DATA may
> +		become corrupt unless it is read within 16 MDC cycles
> +		of MDIO_CFG[BSY] being cleared, when performing an
> +		MDIO read operation.
> +
>  - fsl,erratum-a011043
>  		Usage: optional
>  		Value type: <boolean>
> -- 
> 2.25.1
> 
> 
