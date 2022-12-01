Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF563F860
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiLATe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiLATeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:34:10 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A0117883;
        Thu,  1 Dec 2022 11:32:50 -0800 (PST)
Received: by mail-oi1-f175.google.com with SMTP id v82so3119750oib.4;
        Thu, 01 Dec 2022 11:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SmJRKIwqBp8gbnNMB6ag+fH04itLVPSAiCRSKnEYWIE=;
        b=hAUSF4xG4hh6r8GdTzmDPwWiPqbF5hdtiIPW46K3ElnGIdqbz8dJDGUlJezyWA5uKh
         Y9HKwgCyJAY6lfK/VtfZDEtuDE3AwxW60ihhsW85S9TvC9y8W6UDFNBqGN9hLBHoQPyA
         os95G6yr3tOpMeXtSAsl/Z4ce/EdOu1gOGYKnNHvTvaUhgTZOlGdVz7t6EucaGqNnB8k
         ACLABYtd8Eq//NMDFLyWvxRZbHR83yJR7fI7k7xZaA44uZJQ/Womo2NWHvR08+mF+kDa
         XvaeAYRI6duO7pno0yqUTWGdvbNSatfRV2KokF8O7OBi4nWIWBhNczuNDUn8JTKrFVlr
         WZeQ==
X-Gm-Message-State: ANoB5pnxOzrR/gHbYj5ymOB+iyGchUwFnqW5EjJWMMvhmOPIu7vaO4GO
        gPlorxo0SzXPykhdaYfSIg==
X-Google-Smtp-Source: AA0mqf76S50/fCO8mJTuqErpyB2kZCnIKu73wy3rgo6CPDCs+HL87HJ2zzP7LGwz5k3YUTQnYyjZfw==
X-Received: by 2002:a05:6808:8c9:b0:351:1a63:a74c with SMTP id k9-20020a05680808c900b003511a63a74cmr23789693oij.288.1669923169283;
        Thu, 01 Dec 2022 11:32:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z95-20020a9d24e8000000b0066101e9dccdsm2524124ota.45.2022.12.01.11.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 11:32:48 -0800 (PST)
Received: (nullmailer pid 1203239 invoked by uid 1000);
        Thu, 01 Dec 2022 19:32:47 -0000
Date:   Thu, 1 Dec 2022 13:32:47 -0600
From:   Rob Herring <robh@kernel.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Message-ID: <20221201193247.GA1190273-robh@kernel.org>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
 <Y4jl6awCMFgZsQGC@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4jl6awCMFgZsQGC@spud>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:35:37PM +0000, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:21:04PM +0100, Krzysztof Kozlowski wrote:
> > On 01/12/2022 10:02, Yanhong Wang wrote:
> > > Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
> > 
> > Subject: drop second, redundant "bindings".
> > 
> > > 
> > > Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> > > ---
> > >  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
> > > +properties:
> > > +  compatible:
> > > +    oneOf:
> > 
> > Drop oneOf. You do not have more cases here.
> > 
> > > +      - items:
> > > +          - enum:
> > > +               - starfive,dwmac
> > 
> > Wrong indentation.... kind of expected since you did not test the bindings.
> > 
> > > +          - const: snps,dwmac-5.20
> 
> Disclaimer: no familiarity with the version info with DW stuff
> 
> Is it a bit foolish to call this binding "starfive,dwmac"? Could there
> not be another StarFive SoC in the future that uses another DW mac IP
> version & this would be better off as "starfive,jh7110-dwmac" or similar?

Yes. Really, *only* "starfive,jh7110-dwmac" is enough IMO. 

The question is what would the OS do with only understanding 
"snps,dwmac-5.20"? The answer is typically nothing because it isn't 
enough information to act on. So that compatible is not needed. Maybe 
the driver can do some things based on version, but that can be implied 
from the compatible (if not read from a register). And often, the exact 
version is not known, so do you want to hardcode a guess in DT? For 
these reasons, we've moved away from using these generic IP compatibles 
(with or without versions).

Rob
