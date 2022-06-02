Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2253BB5A
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiFBPIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiFBPH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:07:58 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905F569496;
        Thu,  2 Jun 2022 08:07:57 -0700 (PDT)
Received: by mail-oi1-f172.google.com with SMTP id r206so6852714oib.8;
        Thu, 02 Jun 2022 08:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IeojhjDK1pB+KLRGjH83PQVoVBcwA3TY89wSB9R9mIM=;
        b=ZlHreDlzNH7rrZGEICkTJvr+mbn0IqEyNcklDnF4glly2qFwUquiZVNkzN+TVsLxM4
         2A9OLFV/iNEhsVqll9bePqJ89vodJZJmBq36xmzGB3BA+LrH1Rn8kj5X8VHa0YoYZKGS
         MSu6X21ZT3uUTzBaMacWHo/RjAbTgOltKs8OVguAjLGxzltnL2kz8Ws7t9bgyrtsgT8y
         JLpW9hjQ5eQRUJiO95zPcCN7paiJkjY9V+RNv/qT4gQX5MEpqdBOYB3zU7A+eHz3KubQ
         536rL8o15LbQOVp6v1cFN5hI02WCMR8VGhK+Gte5hq6kAe8dBoEYWxbrH1Nwtb7gT98K
         EJWQ==
X-Gm-Message-State: AOAM530e33jJni8L/ZJF2DWZL21Bal9j3YYGClonsqi1M4PtftNodJ59
        F9214pJLT/1pS6uughPW6g==
X-Google-Smtp-Source: ABdhPJzlbe96ZgKJPKxe6kkBQL0Da/rm3HrAFZdrqRcPEVPDFd4PftNWU9ErtEa/+kVbBiUb+9xZdg==
X-Received: by 2002:a05:6808:f11:b0:32b:d11c:9b9a with SMTP id m17-20020a0568080f1100b0032bd11c9b9amr16530279oiw.138.1654182476855;
        Thu, 02 Jun 2022 08:07:56 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m11-20020a4aedcb000000b00415a9971cfcsm2387584ooh.38.2022.06.02.08.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 08:07:56 -0700 (PDT)
Received: (nullmailer pid 2328431 invoked by uid 1000);
        Thu, 02 Jun 2022 15:07:55 -0000
Date:   Thu, 2 Jun 2022 10:07:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        cchavva@marvell.com, deppel@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 2/3] dt-bindings: net: cavium-mdio.txt: add
 clock-frequency attribute
Message-ID: <20220602150755.GA2323599-robh@kernel.org>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
 <20220530125329.30717-3-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530125329.30717-3-pmalgujar@marvell.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 05:53:27AM -0700, Piyush Malgujar wrote:
> Add support to configure MDIO clock frequency via DTS
> 
> Signed-off-by: Damian Eppel <deppel@marvell.com>
> Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
> ---
>  Documentation/devicetree/bindings/net/cavium-mdio.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/cavium-mdio.txt b/Documentation/devicetree/bindings/net/cavium-mdio.txt
> index 020df08b8a30f4df80766bb90e100ae6210a777b..638c341966a80823b9eb2f33b947f38110907cc1 100644
> --- a/Documentation/devicetree/bindings/net/cavium-mdio.txt
> +++ b/Documentation/devicetree/bindings/net/cavium-mdio.txt
> @@ -41,6 +41,9 @@ Properties:
>  
>  - reg: The PCI device and function numbers of the nexus device.
>  
> +- clock-frequency: MDIO bus clock frequency in Hz. It defaults to 3.125 MHz and
> +		   and not to standard 2.5 MHz for Marvell Octeon family.

Already covered by mdio.yaml, so perhaps convert this to DT schema 
format instead.

Rob
