Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9738562785
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 02:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiGAABn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 20:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGAABm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 20:01:42 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A48599F1;
        Thu, 30 Jun 2022 17:01:41 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id i17so398723ils.12;
        Thu, 30 Jun 2022 17:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CreVyTURHuYPgde3qR5FRT+vG4KQiGhAS6Gr5ol0Hvg=;
        b=miMA1xaGyRxHuqBUDOsfJbOe2P6TkVd2ZlZ9SyOI29py6q1gYCxvMfCOGk6vlCVNqI
         i4mRp8kgKLcQQAfe+XM9+xcettGAAqpkXGwsPKS78MD07o0o7zw/C1ttl8daTPUByBSF
         WleA6xZtHeSMU2xJhVtokIXppPKa7lVg/heE1nHYc6eeNt1Dh1Lsu5tcfrcTHB7cVJwX
         +OFiK+ZIZvckDtIVkTxkaXG+sUDfxiFquiSVsuZHmmqNRPj447P85KqhYj+NWzqDcS+L
         R1KJBcO+ZI5V+bxY5F3196hSOc8QV5or2+nj1ZO7h6SpPDhWDhmb95mqp72dhSOXCGYI
         PaUw==
X-Gm-Message-State: AJIora8NravM+geRLnff3dviFZeJJX35WpvTbQOqsS+hb8zCQ19ksQMr
        BnEBDcaXissii36fGrIM/A==
X-Google-Smtp-Source: AGRyM1taVjwYRc75vaWbzEid6Nrhcnvj+ZzLXQ9zffihtdZys9ADBRoO+upZh20hT7r4mV34e88Vwg==
X-Received: by 2002:a05:6e02:b49:b0:2d9:4176:89d1 with SMTP id f9-20020a056e020b4900b002d9417689d1mr6669937ilu.214.1656633701004;
        Thu, 30 Jun 2022 17:01:41 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y20-20020a6bd814000000b006751347e61bsm8362302iob.27.2022.06.30.17.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:01:40 -0700 (PDT)
Received: (nullmailer pid 3588002 invoked by uid 1000);
        Fri, 01 Jul 2022 00:01:38 -0000
Date:   Thu, 30 Jun 2022 18:01:38 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     devicetree@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/35] dt-bindings: net: Convert FMan MAC
 bindings to yaml
Message-ID: <20220701000138.GA3587947-robh@kernel.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-3-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628221404.1444200-3-sean.anderson@seco.com>
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

On Tue, 28 Jun 2022 18:13:31 -0400, Sean Anderson wrote:
> This converts the MAC portion of the FMan MAC bindings to yaml.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - New
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 144 ++++++++++++++++++
>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>  2 files changed, 145 insertions(+), 127 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
