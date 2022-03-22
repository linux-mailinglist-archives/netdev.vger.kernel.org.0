Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4F34E448B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiCVQxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 12:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbiCVQxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 12:53:10 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6653C85671;
        Tue, 22 Mar 2022 09:51:42 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-d6ca46da48so2257079fac.12;
        Tue, 22 Mar 2022 09:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zvgWAYARdRLJ1nVqJhPCnY48Nqpcp9HM0eT5TESAt8o=;
        b=nQnic7AiVIBE8XFIarh4nczv3drHlkE1S359jf37WJY9R0S8J66nf24cyd9QxZWDA/
         UHgB4JMyM09KF/2TrPJsn4faHN6K9Btg7in/ZWXfoo2/hKpJ4P3YDHpbBIoHlsA/7/1F
         WR93MQlMXLut2mhHxK8lWnwnyVzFIDp3F/BNCECJV1JIbXom4K7qkKznvbhL6Yi3e6ee
         uBcyYqbEwL0Cy4WPLP0McUXsfxpe2YFKG0WKAOeW1v+cvgfcXB1SMzvjGjR3YhshpP7G
         1UdkU+7XS1Sy9fv8T/ZpjQUyh5UNxabMDMRb7t8L5s6S+eC+DH3h7zt+1Bu1mqWvrt3U
         Qrxg==
X-Gm-Message-State: AOAM530RZJN8B0TcL+RrfE8gAy9g/P8OYE3CTjlmyNCoRFqCEZEr0EJJ
        G7ThWDgC/7ju4lDA28QG3Q==
X-Google-Smtp-Source: ABdhPJx78WOrvUoO4mLORYb5IlvGM+FtNbdD8Rl9H05HaiyYGpdJM7gRQOuNxEW/L8wDNrvUD/zOgg==
X-Received: by 2002:a05:6870:206:b0:dd:b3d7:3f7e with SMTP id j6-20020a056870020600b000ddb3d73f7emr2140325oad.252.1647967901683;
        Tue, 22 Mar 2022 09:51:41 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 24-20020a056870109800b000dded4f78f1sm4044802oaq.51.2022.03.22.09.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 09:51:40 -0700 (PDT)
Received: (nullmailer pid 2162771 invoked by uid 1000);
        Tue, 22 Mar 2022 16:51:39 -0000
Date:   Tue, 22 Mar 2022 11:51:39 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Radhey Shyam Pandey <radheys@xilinx.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        "robert.hancock@calian.com" <robert.hancock@calian.com>,
        Michal Simek <michals@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Message-ID: <Yjn+m6OwkxPAc8/A@robh.at.kernel.org>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
 <20220321152515.287119-3-andy.chiu@sifive.com>
 <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
 <YjkN6uo/3hXMU36c@robh.at.kernel.org>
 <YjkWca40JbosV7Hq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjkWca40JbosV7Hq@lunn.ch>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 01:21:05AM +0100, Andrew Lunn wrote:
> > > The use case is generic i.e. require separate handle to internal SGMII
> > > and external Phy so would prefer this new DT convention is 
> > > standardized or we discuss possible approaches on how to handle
> > > both phys and not add it as vendor specific property in the first 
> > > place.
> > 
> > IMO, you should use 'phys' for the internal PCS phy. That's aligned with 
> > other uses like PCIe, SATA, etc. (there is phy h/w that will do PCS, 
> > PCIe, SATA). 'phy-handle' is for the ethernet PHY.
> 
> We need to be careful here, because the PCS can have a well defined
> set of registers accessible over MDIO. Generic PHY has no
> infrastructure for that, it is all inside phylink which implements the
> pcs registers which are part of 802.3.

Using the phy binding doesn't mean you have to use the kernel's 'generic 
PHY' subsytem.

But if there's a need to do something different then propose something 
that handles the complex cases.

> 
> I also wonder if a PCS might actually have a generic PHY embedded in
> it to provide its lower interface?

That's just looking at a single PCS/PHY block the other way around. 
PCS is part of the PHY or the PHY is part of PCS? I don't think that 
matters too much. I think the 2 cases would be it's all 1 block or 2 
blocks.

Rob
