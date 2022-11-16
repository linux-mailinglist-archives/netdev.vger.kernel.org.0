Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14262C547
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbiKPQrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbiKPQq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:46:57 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADCB3E;
        Wed, 16 Nov 2022 08:43:36 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id t62so19078779oib.12;
        Wed, 16 Nov 2022 08:43:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8B5/87gKzEK1DHTjBN460dWTsUxNgyOjDKt1AO8fAIM=;
        b=oAxI32fGulcdp1ItejT1LU8zWaS3pJYwwycnLq3rDJ+weEGqCDYTn0Vss1nuDiopo8
         BbW1nFIjow9d+Fl21PKQukL5OzT8aiou15BzORKZ+MMeDt/S61Z5nmDnsnEUX3r0vV1O
         0fefZABKhKwHzNAIoWWTpw8RaKxHo+KWd3y6HkpBwRhVTBNjwBIKDMqkXStY9z2HOOZS
         OQtD7FivovlEgmkfZzw+ooplt4VeK0gqgiV/RbNVmUjUHEFMXEd/JStFrlS1EAA4Ra0C
         6L+Em5KO7B32X8cHHT3Op6RCYEGzykM0HHEMyo88ubptRu45BYLO0AFRXKozVpgw1sb/
         Zrqg==
X-Gm-Message-State: ANoB5plFX29inmjNu5g3TA7jno8gxcpAQq0kEJ7csXOWNCYE5YGo6YkA
        5NX8zhK7Ji0djPVFPwd1PQ==
X-Google-Smtp-Source: AA0mqf6l6fNt+UU2Tz8uYxAZJZVv7nnrGresiuFjASgy/dwkv0ln2dV9GKYUUtcrm7tX4B48WXq3lw==
X-Received: by 2002:a05:6808:a83:b0:354:b300:16d5 with SMTP id q3-20020a0568080a8300b00354b30016d5mr1972701oij.253.1668617015856;
        Wed, 16 Nov 2022 08:43:35 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f21-20020a9d6c15000000b00661ad8741b4sm6805514otq.24.2022.11.16.08.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 08:43:35 -0800 (PST)
Received: (nullmailer pid 217080 invoked by uid 1000);
        Wed, 16 Nov 2022 16:43:37 -0000
Date:   Wed, 16 Nov 2022 10:43:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     'Krzysztof Kozlowski' <krzysztof.kozlowski@linaro.org>,
        rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
Subject: Re: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Message-ID: <20221116164337.GA203961-robh@kernel.org>
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84@epcas5p3.samsung.com>
 <20221109100928.109478-2-vivek.2311@samsung.com>
 <709daf8b-a58e-9247-c5d8-f3be3e60fe70@linaro.org>
 <000001d8f4f6$1c7e96e0$557bc4a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d8f4f6$1c7e96e0$557bc4a0$@samsung.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 04:48:03PM +0530, Vivek Yadav wrote:
> 
> 
> > -----Original Message-----
> > From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Sent: 09 November 2022 16:39
> > To: Vivek Yadav <vivek.2311@samsung.com>; rcsekar@samsung.com;
> > krzysztof.kozlowski+dt@linaro.org; wg@grandegger.com;
> > mkl@pengutronix.de; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; pankaj.dubey@samsung.com;
> > ravi.patel@samsung.com; alim.akhtar@samsung.com; linux-fsd@tesla.com;
> > robh+dt@kernel.org
> > Cc: linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> > samsung-soc@vger.kernel.org; devicetree@vger.kernel.org;
> > aswani.reddy@samsung.com; sriranjani.p@samsung.com
> > Subject: Re: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
> > compatibles found on FSD SoC
> > 
> > On 09/11/2022 11:09, Vivek Yadav wrote:
> > > From: Sriranjani P <sriranjani.p@samsung.com>
> > >
> > 
> > Use subject prefixes matching the subsystem (git log --oneline -- ...).
> > 
> Okay, I will add the correct prefixes.
> > > Describe the compatible properties for SYSREG controllers found on FSD
> > > SoC.
> > 
> > This is ARM SoC patch, split it from the patchset.
> >
> I understand this patch is not to be subset of CAN patches, I will send these patches separately.
> These patches will be used by EQos patches. As per reference, I am adding the Address link.
> https://lore.kernel.org/all/20221104120517.77980-1-sriranjani.p@samsung.com/
>  
> > >
> > > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > > Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
> > > Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
> > > Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> > > Cc: devicetree@vger.kernel.org
> > > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > 
> > Drop the Cc list from commit log. It's not helpful.
> > 
> Okay, I will remove.
> > > Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> > > ---
> > >  .../devicetree/bindings/arm/tesla-sysreg.yaml | 50
> > +++++++++++++++++++
> > >  MAINTAINERS                                   |  1 +
> > >  2 files changed, 51 insertions(+)
> > >  create mode 100644
> > > Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > > b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > > new file mode 100644
> > > index 000000000000..bbcc6dd75918
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > 
> > arm is only for top level stuff. This goes to soc under tesla or samsung
> > directory.
> > 
> Okay, this is specific to Samsung fsd SoC, I will be moving this file to arm/samsung in next patch series. Hope that is fine.
> > > @@ -0,0 +1,50 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause %YAML 1.2
> > > +---
> > > +$id:
> > > +https://protect2.fireeye.com/v1/url?k=1ad2834a-7b59967c-1ad30805-
> > 000b
> > > +abff9b5d-1f65584e412e916c&q=1&e=a870a282-632a-4896-ae53-
> > 3ecb50f02be5&
> > > +u=http%3A%2F%2Fdevicetree.org%2Fschemas%2Farm%2Ftesla-
> > sysreg.yaml%23
> > > +$schema:
> > > +https://protect2.fireeye.com/v1/url?k=13876e33-720c7b05-1386e57c-
> > 000b
> > > +abff9b5d-edae3ff711999305&q=1&e=a870a282-632a-4896-ae53-
> > 3ecb50f02be5&
> > > +u=http%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
> > > +
> > > +title: Tesla Full Self-Driving platform's system registers
> > > +
> > > +maintainers:
> > > +  - Alim Akhtar <alim.akhtar@samsung.com>
> > > +
> > > +description: |
> > > +  This is a system control registers block, providing multiple low
> > > +level
> > > +  platform functions like board detection and identification,
> > > +software
> > > +  interrupt generation.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    oneOf:
> > 
> > No need for oneOf.
> > 
> Removing this results into dt_binding_check error, so this is required.
> > > +      - items:
> > > +          - enum:
> > > +              - tesla,sysreg_fsys0
> > > +              - tesla,sysreg_peric
> > 
> > From where did you get underscores in compatibles?
> > 
> I have seen in MCAN Driver <drivers/net/can/m_can/m_can_platform.c> and also too many other yaml files.
> Do you have any ref standard guideline of compatible which says underscore is not allowed.

Section 2.3.1 defining 'compatible' in the DT spec:

The compatible string should consist only of lowercase letters, digits  
and dashes, and should start with a letter. A single comma is typically 
only used following a vendor prefix. Underscores should not be used.
