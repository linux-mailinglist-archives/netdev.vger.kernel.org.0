Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1BA4AE803
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiBIEH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbiBID25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:28:57 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6347AC06174F;
        Tue,  8 Feb 2022 19:28:56 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id i5so1250951oih.1;
        Tue, 08 Feb 2022 19:28:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kjI3FganN8B+/UNVIHZUWUot23btySuPCC/YwUANh4I=;
        b=WSemVN/wjNUxp37gUU6xMDk21UrvsULSt98cdtj3nAc9/lUqmkO9MdxG0ZoPtn5mhs
         lY7f4mjXqmbc40FpvF9xHfXq9a+AiYD7FN/C6lnPrfVvQMEq5bF+O1xf/0K2y+XYNHmN
         6sYeIKpL6nT/Q0P1Yb3owhLdoZ6+xABSr4/2tmPnKWOZnTgA6tNG9ErSXlNA/zkGxV37
         mBm2AwEV7p1KKWZ/PdWXciewbxJxeHfEwu98XaPn/5HzMunoJLOihvnIuzEvriORk4oo
         J5PHvgdoPnTmhzFrXJMBSyWuhlYoQOGnxas65W/kBrGWCa0zJstANhO/0hik4uFSJW1P
         NKTA==
X-Gm-Message-State: AOAM531BKsT0iL62RMO5ZRF9CmSo0cq0GdOwzca8AOOeeFlkPHRloqs5
        //dUsLd80EW/MYdcNy80jppRCXkpQg==
X-Google-Smtp-Source: ABdhPJzA5VflbMDZ34MEnPMfCWN4Ru/h+2IVBrOwYYE55PqKM9y1IOmlr/JmkQhk/ZUR4RGccMfDwQ==
X-Received: by 2002:a05:6808:21a5:: with SMTP id be37mr494127oib.339.1644377335703;
        Tue, 08 Feb 2022 19:28:55 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bb16sm6446122oob.42.2022.02.08.19.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:28:54 -0800 (PST)
Received: (nullmailer pid 3580379 invoked by uid 1000);
        Wed, 09 Feb 2022 03:28:54 -0000
Date:   Tue, 8 Feb 2022 21:28:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells /
 nvmem-cell-names properties
Message-ID: <YgM09mGTZv3U5nBT@robh.at.kernel.org>
References: <20220126144748.246073-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126144748.246073-1-alexander.stein@ew.tq-group.com>
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

On Wed, Jan 26, 2022 at 03:47:48PM +0100, Alexander Stein wrote:
> These properties are inherited from ethernet-controller.yaml.
> This fixes the dt_binding_check warning:
> imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
> 'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> index daa2f79a294f..73616924fa29 100644
> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> @@ -121,6 +121,10 @@ properties:
>  
>    mac-address: true
>  
> +  nvmem-cells: true

Need to define how many.

> +
> +  nvmem-cell-names: true

And what the names are.

> +
>    tx-internal-delay-ps:
>      enum: [0, 2000]
>  
> -- 
> 2.25.1
> 
> 
