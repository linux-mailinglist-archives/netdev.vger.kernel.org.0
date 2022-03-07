Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2074D0964
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245482AbiCGVeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiCGVep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:34:45 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CEA50B36;
        Mon,  7 Mar 2022 13:33:50 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id n7so7007671oif.5;
        Mon, 07 Mar 2022 13:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKi3HHKVGpmeKTbiXrMkXO/qpORJuIc2PskVIUh7Ul0=;
        b=O8aegdWK3BCJSA8bBQo8H3LN+HCz7hI2BOQXXi1FYx0pHe8QngpkxpJqS5U0sLHmFv
         cpA+EEMvvZkK1H3zktJU+7CCpEqsOJALsd9LADuNBAp7wLVqqYn0MNFj5E47kfu2ZPd3
         cvbPrusPoIE+1s/wuCfiH77eNh5UNh1Lo/HzqMNqmplj5P0/PQkLWNYYlROfK8FxJkR0
         XpP52z3r30ve2IpyOSTGjG02rOpZdA3hG8KMrSjULxV9TuhR7x1tuvlTgG1YxOrScGV/
         o+eU5UrKivtKm/0k/nFhwyhiLv5ab90UXglvkr3hOWOp7FpxuuaZa+RjMTaaZiM1WMsa
         /2wg==
X-Gm-Message-State: AOAM531BubLfNQQl4M9ci3ud+nQEmgbApyiaxcPFEI+oUKVfXh0lXoMI
        YiLxNAjs/pT5xZoe7PCYp2epYnryhA==
X-Google-Smtp-Source: ABdhPJyHk1wozNhDsnc/eHiJaIyeWDdPzrh66zQ5MVd7xtFTOvAmcAjd/8AMsWAwi96QsdyLTm8wjA==
X-Received: by 2002:a05:6808:1983:b0:2d7:7fc:9e9b with SMTP id bj3-20020a056808198300b002d707fc9e9bmr649909oib.133.1646688829667;
        Mon, 07 Mar 2022 13:33:49 -0800 (PST)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p14-20020a056830304e00b005b246b673f2sm811780otr.71.2022.03.07.13.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 13:33:48 -0800 (PST)
Received: (nullmailer pid 3270524 invoked by uid 1000);
        Mon, 07 Mar 2022 21:33:47 -0000
Date:   Mon, 7 Mar 2022 15:33:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        devicetree@vger.kernel.org, richardcochran@gmail.com,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <YiZ6O2GeLIVEqgvY@robh.at.kernel.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304093418.31645-3-Divya.Koppera@microchip.com>
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

On Fri, Mar 04, 2022 at 03:04:17PM +0530, Divya Koppera wrote:
> Supports configuring latency values and also adds
> check for phy timestamping feature.
> 
> Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>

should be a space here:       ^

> ---
>  .../devicetree/bindings/net/micrel.txt          | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Please convert this to DT schema.

> 
> diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
> index 8d157f0295a5..c5ab62c39133 100644
> --- a/Documentation/devicetree/bindings/net/micrel.txt
> +++ b/Documentation/devicetree/bindings/net/micrel.txt
> @@ -45,3 +45,20 @@ Optional properties:
>  
>  	In fiber mode, auto-negotiation is disabled and the PHY can only work in
>  	100base-fx (full and half duplex) modes.
> +
> + - lan8814,ignore-ts: If present the PHY will not support timestamping.

'lan8814' is not a vendor and the format for properties is 
<vendor>,<propname>.

Is this configuration or lack of h/w feature? IOW, instead of 'will 
not', 'does not' or 'timestamping is disabled.'. As configuration, that 
seems like common property. For (lack of) h/w features, that should be 
implied by the compatible or VID/PID.

> +	This option acts as check whether Timestamping is supported by
> +	hardware or not. LAN8814 phy support hardware tmestamping.
> +
> + - lan8814,latency_rx_10: Configures Latency value of phy in ingress at 10 Mbps.

s/_/-/

What are the units here? Is this a common feature of PHYs?

> +
> + - lan8814,latency_tx_10: Configures Latency value of phy in egress at 10 Mbps.
> +
> + - lan8814,latency_rx_100: Configures Latency value of phy in ingress at 100 Mbps.
> +
> + - lan8814,latency_tx_100: Configures Latency value of phy in egress at 100 Mbps.
> +
> + - lan8814,latency_rx_1000: Configures Latency value of phy in ingress at 1000 Mbps.
> +
> + - lan8814,latency_tx_1000: Configures Latency value of phy in egress at 1000 Mbps.
> -- 
> 2.17.1
> 
> 
