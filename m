Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B32F578B26
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiGRTqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiGRTqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:46:24 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B6B861;
        Mon, 18 Jul 2022 12:46:23 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id v185so10147607ioe.11;
        Mon, 18 Jul 2022 12:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LDIcSSdSuEY2G/DAB4xr+Im2NXlqFrVtmyYQ1W3d1kM=;
        b=aVgiyNtIOxjsNT7RwfLWaVKtf7LRjFlVYv6Q3RsRoCWO5RrBjMOwBqK9UpdkgtasQ3
         YZ2wGsu5GaWkweV4UjchUKo4ddqAzTXvKXG2jkgNHNuIRnMNwVuPLnL5SxIIUWMVMhmY
         uApgAePnVf40tYd+Fx7/2OTPreuGxujJmVn0GohOHeBHuFVXzxR+ZM+RNBNLYe1D1qvx
         kVFE5mYwnJ3K01owvY9ia6ENU6hc7PPa0cfG2BuW9zdG293PD/ewlL8xd0IHoVDSmunJ
         2dCw9E5scDezOjVpSGBUcSrVXmEXJMFRKAW7Myx/dSZ8CEqP1FAyV0Rj/bTZ+kctvE86
         SLuw==
X-Gm-Message-State: AJIora+jGNEMempjq778PE05B90bkWTJ44klZ+N6Vupd5vk0tuBy6SV8
        GATbV4QJf7ARTMBSqopVKQ==
X-Google-Smtp-Source: AGRyM1uvcKF6ziPm4Yv3YA+hZ/xOz/ohcyBKZqePnnm+y/DNXmzTvXSQYgWQkrlsY/eT0ZGml84G/Q==
X-Received: by 2002:a05:6638:1c1a:b0:33f:45c9:effb with SMTP id ca26-20020a0566381c1a00b0033f45c9effbmr15449820jab.305.1658173583176;
        Mon, 18 Jul 2022 12:46:23 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id g5-20020a02c545000000b0033f4b1c2151sm5962542jaj.154.2022.07.18.12.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:46:22 -0700 (PDT)
Received: (nullmailer pid 3425548 invoked by uid 1000);
        Mon, 18 Jul 2022 19:46:20 -0000
Date:   Mon, 18 Jul 2022 13:46:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to
 an array
Message-ID: <20220718194620.GB3377770-robh@kernel.org>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-3-sean.anderson@seco.com>
 <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
 <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
 <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
 <Ys2aeRBGGv6ajMZ5@shell.armlinux.org.uk>
 <f2a29c57-be8c-88c2-1c75-f6e5d1164b8f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2a29c57-be8c-88c2-1c75-f6e5d1164b8f@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 12:45:54PM +0200, Krzysztof Kozlowski wrote:
> On 12/07/2022 17:59, Russell King (Oracle) wrote:
> >> However before implementing this, please wait for more feedback. Maybe
> >> Rob or net folks will have different opinions.
> > 
> > We decided on "pcs-handle" for PCS for several drivers, to be consistent
> > with the situation for network PHYs (which are "phy-handle", settled on
> > after we also had "phy" and "phy-device" and decided to deprecate these
> > two.
> > 
> > Surely we should have consistency within the net code - so either "phy"
> > and "pcs" or "phy-handle" and "pcs-handle" but not a mixture of both?
> 
> True. Then the new property should be "pcs-handle-names"?

IMO, just keep "pcs-handle" and then "pcs-handle-names". We never seem 
to get free of the deprecated versions (-gpio).

While just add/remove 's' would be nice, we have to deal with things 
like 'mboxes' and I think some other inconsistencies. 

Rob
