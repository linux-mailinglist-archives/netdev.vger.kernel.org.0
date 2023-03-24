Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B236E6C87DB
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjCXV7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjCXV7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:59:36 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81315562;
        Fri, 24 Mar 2023 14:59:35 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id r16so2216676oij.5;
        Fri, 24 Mar 2023 14:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNL5w5eYDM55BXRsVUv16I402Vb2xlU+5wdQWl0ZA5o=;
        b=BfQmJD3ItifKSUonchLCTksqwzMNOfXIjelC+DoKRkEs8eC5iEKEAIYgPfn2nXnTuS
         IGLKDwBCaMmXmCb8stcnLurzYePW2+iVubNja/Gxqs2Ua3H/3ADO1Lt6n96Sr0wGyR1g
         gZN1w9zS+cGB+IEMDB2GbyMxflt9AEvY00/CpEYD3XxvM5Yd21ShQOoRih3r7MFxo1hr
         WrKIUaaWkxNma0VZ1LBsVkwsOJEqm52mACvhckA69MMvm4+cktahETNnO9kUV3qxwWsj
         M+M1yWOPwRH70oF9qDFqZOEHrAPHDHNtK7jAWnOZuelJtnqL30YNdrhfbz+WRGgVt5M2
         IXBg==
X-Gm-Message-State: AO0yUKXAJij5kG8dBK+w8t/HUjHrSzW4qUpp9dkhAc4F7HSqJHWSPS4r
        eDBTG2lQskh/oJ952ZfUYQ==
X-Google-Smtp-Source: AK7set83OMMwHEd/xmeCKjvOBf+FPOq4sNLD29gH0PdiDnCImpMV3fVRF6vT6C/vpyBYUnXPJA7boA==
X-Received: by 2002:a54:4805:0:b0:386:ce06:8d87 with SMTP id j5-20020a544805000000b00386ce068d87mr1666502oij.38.1679695174268;
        Fri, 24 Mar 2023 14:59:34 -0700 (PDT)
Received: from robh_at_kernel.org ([2605:ef80:80f9:92f0:b372:78c0:69c1:66d6])
        by smtp.gmail.com with ESMTPSA id r2-20020a056808210200b00387160bcd46sm4918565oiw.46.2023.03.24.14.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 14:59:33 -0700 (PDT)
Received: (nullmailer pid 54572 invoked by uid 1000);
        Fri, 24 Mar 2023 21:59:30 -0000
Date:   Fri, 24 Mar 2023 16:59:30 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 10/15] dt-bindings: net: ethernet-controller:
 Document support for LEDs node
Message-ID: <20230324215930.GA49367-robh@kernel.org>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-11-ansuelsmth@gmail.com>
 <20230321211953.GA1544549-robh@kernel.org>
 <641a35b8.1c0a0220.25419.2b4d@mx.google.com>
 <38534a25-4bb3-4371-b80b-abfc259de781@lunn.ch>
 <641a4046.7b0a0220.44d4e.95d4@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641a4046.7b0a0220.44d4e.95d4@mx.google.com>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:39:48AM +0100, Christian Marangi wrote:
> On Wed, Mar 22, 2023 at 12:23:59AM +0100, Andrew Lunn wrote:
> > > > Are specific ethernet controllers allowed to add their own properties in 
> > > > led nodes? If so, this doesn't work. As-is, this allows any other 
> > > > properties. You need 'unevaluatedProperties: false' here to prevent 
> > > > that. But then no one can add properties. If you want to support that, 
> > > > then you need this to be a separate schema that devices can optionally 
> > > > include if they don't extend the properties, and then devices that 
> > > > extend the binding would essentially have the above with:
> > > > 
> > > > $ref: /schemas/leds/common.yaml#
> > > > unevaluatedProperties: false
> > > > properties:
> > > >   a-custom-device-prop: ...
> > > > 
> > > > 
> > > > If you wanted to define both common ethernet LED properties and 
> > > > device specific properties, then you'd need to replace leds/common.yaml 
> > > > above  with the ethernet one.
> > > > 
> > > > This is all the same reasons the DSA/switch stuff and graph bindings are 
> > > > structured the way they are.
> > > > 
> > > 
> > > Hi Rob, thanks for the review/questions.
> > > 
> > > The idea of all of this is to keep leds node as standard as possible.
> > > It was asked to add unevaluatedProperties: False but I didn't understood
> > > it was needed also for the led nodes.
> > > 
> > > leds/common.yaml have additionalProperties set to true but I guess that
> > > is not OK for the final schema and we need something more specific.
> > > 
> > > Looking at the common.yaml schema reg binding is missing so an
> > > additional schema is needed.
> > > 
> > > Reg is needed for ethernet LEDs and PHY but I think we should also permit
> > > to skip that if the device actually have just one LED. (if this wouldn't
> > > complicate the implementation. Maybe some hints from Andrew about this
> > > decision?)
> > 
> > I would make reg mandatory.
> >
> 
> Ok will add a new schema and change the regex.
> 
> > We should not encourage additional properties, but i also think we
> > cannot block it.
> > 
> > The problem we have is that there is absolutely no standardisation
> > here. Vendors are free to do whatever they want, and they do. So i
> > would not be too surprised if some vendor properties are needed
> > eventually.
> >
> 
> Think that will come later with defining a more specific schema. But I
> honestly think most of the special implementation will be handled to the
> driver internally and not with special binding in DT.

Then encourage no additional properties by letting whomever wants to add 
them to restructure the schema. ;)

Rob
