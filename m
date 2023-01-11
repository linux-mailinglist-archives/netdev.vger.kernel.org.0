Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F156664D5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjAKU2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239582AbjAKU1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:27:49 -0500
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1923F125;
        Wed, 11 Jan 2023 12:26:41 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so9475690oto.5;
        Wed, 11 Jan 2023 12:26:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtUlkPBnTibbizf/H3Nw9CiF2dvWYJd3fBoMYMkkY6o=;
        b=eJZXtNG9fmL2IgALzepTbFMLTTId2h7zcZC+568o4WnNFQB/oDtx8qM78sBA8vXrbs
         DZhYBH1Fjs+Z+8cD19DDpZiAhjPdV+WIKlynHnXSMcYhrLS2p4DGt9VbtFgXSHqPaGW/
         7zylxPZb0sZt2D9qFvkA+IbiC+tczsxS3iAF8oFSELq3hLbI86SYDetDGk0k0bNkDuYQ
         BwbVvoYPRShaGEqNXBrHB+ITFenniAd0xDe/OlavEJXl8UYCQrmQFcp1FjUJwg3/9kgF
         /LtUID0TMjVKdJDrw7M4hDMR2m+2dfdDIYViLdGKxNJjRpvjOCBLYnMqnbFI9oSdZogT
         05OA==
X-Gm-Message-State: AFqh2kqR13EbrVvKG7ZaPqNpruw5QUVkukuEskS8n0rE615yidCX8HBD
        xqhA5mZxQo1kbV36Xc8Hlw==
X-Google-Smtp-Source: AMrXdXvk+/Ain/i5yL9ul+PeQV5I/RK3qfqLYNdxxu4RWqGzhh535t4/xZ1jsbIuH7DIsftuVkCLfA==
X-Received: by 2002:a9d:7e8a:0:b0:670:9684:404c with SMTP id m10-20020a9d7e8a000000b006709684404cmr42684143otp.28.1673468801076;
        Wed, 11 Jan 2023 12:26:41 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v26-20020a9d605a000000b0066eab2ec808sm8077274otj.1.2023.01.11.12.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 12:26:40 -0800 (PST)
Received: (nullmailer pid 1362478 invoked by uid 1000);
        Wed, 11 Jan 2023 20:26:39 -0000
Date:   Wed, 11 Jan 2023 14:26:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <20230111202639.GA1236027-robh@kernel.org>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109123013.3094144-3-michael@walle.cc>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:30:11PM +0100, Michael Walle wrote:
> Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
> essentially adds just one flag: maxlinear,use-broken-interrupts.
> 
> One might argue, that if interrupts are broken, just don't use
> the interrupt property in the first place. But it needs to be more
> nuanced. First, this interrupt line is also used to wake up systems by
> WoL, which has nothing to do with the (broken) PHY interrupt handling.

I don't understand how this is useful. If the interrupt line is asserted 
after the 1st interrupt, how is it ever deasserted later on to be 
useful. 

In any case, you could use 'wakeup-source' if that's the functionality 
you need. Then just ignore the interrupt if 'wakeup-source' is not 
present.

> Second and more importantly, there are devicetrees which have this
> property set. Thus, within the driver we have to switch off interrupt
> handling by default as a workaround. But OTOH, a systems designer who
> knows the hardware and knows there are no shared interrupts for example,
> can use this new property as a hint to the driver that it can enable the
> interrupt nonetheless.

Pretty sure I said this already, but this schema has no effect. Add an 
extra property to the example and see. No error despite your 
'unevaluatedProperties: false'. Or drop 'interrupts-extended' and no 
dependency error... 

You won't get errors as there's no defined way to decide when to apply 
this because it is based on node name or compatible unless you do a 
custom select, but I don't see what you would key off of here...

The real answer here is add a compatible. But I'm tired of pointing this 
out to the networking maintainers every damn time. Ethernet PHYs are not 
special.

Rob
