Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2B75B629A
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiILVOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiILVOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:14:51 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F70CE26;
        Mon, 12 Sep 2022 14:14:49 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1274ec87ad5so26907197fac.0;
        Mon, 12 Sep 2022 14:14:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=fiSD7aHOomub7Bw8jMO+JVKqU+yrc5sM1nDH0VKG+Bk=;
        b=4Uj4ik5X2LxDVs4JTGjAZT3+KYmANEpAdywG1kFMYpxXa9j+8NoD0aM/k2fNKoZlWE
         wdentr+dLvFMGhrtb1494liM8yfR8Ko2Mf01Px9uUvYIdR7LGHBXhYbe67aQKuVopFaC
         qrxx4HSkiVI3EbFf7KjeGB7x1Qa/Wf02f+TCWXC7aA8QEW4Vr+FzKxXkJuB4DYymhr/w
         Bd+gK20fd8xa/fTRmoq9pQ6Y05GE8llxxWZ9JCTPhc2j6ek6CV4L+++yEpbR0QlQpviU
         5WyqCuREqD6X2jlCWS9GKo2OZ5GVzjG11insEKlAs9u+JI5tUMf9yGGYug2jF5URN78C
         t2uQ==
X-Gm-Message-State: ACgBeo0sVTdtdXHoAh9xBTww6WANphNgRNliGVVtOJpmr7nyPv0GE02C
        rdppOO/CC9hJQOi/8909jnJ8Ro2BeQ==
X-Google-Smtp-Source: AA6agR56LXac0gKGPNWMMY2CmdvxpOvzzadUO9D9Xr0ldGtCxf/0sjBd37ze5CYxEn3iCv9kikW/XA==
X-Received: by 2002:a05:6808:25a:b0:34d:8e1d:771f with SMTP id m26-20020a056808025a00b0034d8e1d771fmr117255oie.185.1663017288667;
        Mon, 12 Sep 2022 14:14:48 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w12-20020a056870338c00b0012769122387sm1500443oae.54.2022.09.12.14.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 14:14:48 -0700 (PDT)
Received: (nullmailer pid 1886514 invoked by uid 1000);
        Mon, 12 Sep 2022 21:14:47 -0000
Date:   Mon, 12 Sep 2022 16:14:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        agross@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/4] dt-bindings: net: snps,dwmac: Update reg maxitems
Message-ID: <20220912211447.GB1847448-robh@kernel.org>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-4-bhupesh.sharma@linaro.org>
 <da383499-fe9f-816e-8180-a9661a9c0496@linaro.org>
 <46087486-bacd-c408-7ead-5b120412412b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46087486-bacd-c408-7ead-5b120412412b@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 12:23:42AM +0530, Bhupesh Sharma wrote:
> On 9/8/22 8:11 PM, Krzysztof Kozlowski wrote:
> > On 07/09/2022 22:49, Bhupesh Sharma wrote:
> > > Since the Qualcomm dwmac based ETHQOS ethernet block
> > > supports 64-bit register addresses, update the
> > > reg maxitems inside snps,dwmac YAML bindings.
> > 
> > Please wrap commit message according to Linux coding style / submission
> > process:
> > https://elixir.bootlin.com/linux/v5.18-rc4/source/Documentation/process/submitting-patches.rst#L586
> > 
> > > 
> > > Cc: Bjorn Andersson <andersson@kernel.org>
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Vinod Koul <vkoul@kernel.org>
> > > Cc: David Miller <davem@davemloft.net>
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > > ---
> > >   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > index 2b6023ce3ac1..f89ca308d55f 100644
> > > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > @@ -94,7 +94,7 @@ properties:
> > >     reg:
> > >       minItems: 1
> > > -    maxItems: 2
> > > +    maxItems: 4
> > 
> > Qualcomm ETHQOS schema allows only 2 in reg-names, so this does not make
> > sense for Qualcomm and there are no users of 4 items.
> 
> On this platform the two reg spaces are 64-bit, whereas for other
> platforms based on dwmmac, for e.g. stm32 have 32-bit address space.

The schema for reg is how many addr/size entries regardless of cell 
sizes.

> Without this fix I was getting the following error with 'make dtbs_check':
> 
> Documentation/devicetree/bindings/net/qcom,ethqos.example.dtb:
> ethernet@20000: reg: [[0, 131072], [0, 65536], [0, 221184], [0, 256]] is too
> long
> 	From schema: /home/bhsharma/code/upstream/linux-bckup/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml

The default cell sizes for examples is 1 for addr/size. If you want it 
to be 2, you have to write your own parent node. But why? It's just an 
example. Use 1 cell like the example originally had.

Rob
