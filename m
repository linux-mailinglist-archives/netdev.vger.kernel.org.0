Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2240B578D17
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiGRVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiGRVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:50:20 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4088D2CDFB;
        Mon, 18 Jul 2022 14:50:19 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id r70so9282041iod.10;
        Mon, 18 Jul 2022 14:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AcSlO1npiUHLzg6tvtDZkGhWbfqQ2WJHbMcDnY+OpNg=;
        b=CtFWfEGb/pPO3hBW+btI9GKxgQuRvWV5vdg8tE4wTx8JixOniNTEzYUA/FC0bLQW1F
         kZzFEGcJYto9JASKJNMDptgrrW7NdzBWApL4/F2K6BHBGSbwXj0lsMCvLejQLWHVVhuY
         JzybV+8kD71qzRYnIyfWcKovf0eWU/PG9AGa5ZYu4twuzUPEZ0CEXl9HGqi/nUdkqNvi
         EpaVjMXkV2GkgJKe8tkUb338oOAYJLFoMKlOujE6At9BZKgpaDE2H1Zu6CE0uUxJyaOd
         mGiVzbNSvdFT4QpE5TrQsbWCDW0m+c/acR8OiHJl7D5rNFQhGN1Yq1UXklfr7wWmg/Lc
         Ol5g==
X-Gm-Message-State: AJIora+LeabqZT2BK0LRI5SiX3Zt7LMuY5OhFmPy66Kk53fATM9IPF/w
        dWiXOxjPt0lf2BNcAgdCHw==
X-Google-Smtp-Source: AGRyM1stkhiJ8k9ndMJyxrUUTCQXY14eLka7jRMIg9uosRhBInKLtHR9Dk/HIAioEh2zvIDJ1aBHmQ==
X-Received: by 2002:a05:6602:14d:b0:67b:9536:680f with SMTP id v13-20020a056602014d00b0067b9536680fmr13940947iot.202.1658181018441;
        Mon, 18 Jul 2022 14:50:18 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q18-20020a02b052000000b00339c3906b08sm5928218jah.177.2022.07.18.14.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 14:50:18 -0700 (PDT)
Received: (nullmailer pid 3625096 invoked by uid 1000);
        Mon, 18 Jul 2022 21:50:16 -0000
Date:   Mon, 18 Jul 2022 15:50:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/1] dt-bindings: net: fsl,fec: Add nvmem-cells /
 nvmem-cell-names properties
Message-ID: <20220718215016.GA3615606-robh@kernel.org>
References: <20220715080640.881316-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715080640.881316-1-alexander.stein@ew.tq-group.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:06:40AM +0200, Alexander Stein wrote:
> These properties are inherited from ethernet-controller.yaml.
> This fixes the dt_binding_check warning:
> imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
> 'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> Changes in v2:
> * Add amount and names of nvmem-cells (copied from ethernet-controller.yaml)
> 
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> index daa2f79a294f..b5b55dca08cb 100644
> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> @@ -121,6 +121,14 @@ properties:
>  
>    mac-address: true
>  
> +  nvmem-cells:
> +    maxItems: 1
> +    description:
> +      Reference to an nvmem node for the MAC address
> +
> +  nvmem-cell-names:
> +    const: mac-address

Sorry, steered you wrong on this. I didn't realize 
ethernet-controller.yaml already defined these. You just need 
'unevaluatedProperties: false' instead additionalProperties.

I'm not sure what the FIXME for the additionalProperties is all about 
though.

Rob
