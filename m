Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A844E4264
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiCVO5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiCVO5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:57:33 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08A67091C;
        Tue, 22 Mar 2022 07:56:05 -0700 (PDT)
Received: by mail-ot1-f48.google.com with SMTP id k25-20020a056830151900b005b25d8588dbso12678082otp.4;
        Tue, 22 Mar 2022 07:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3aZJSkaV4ny64t/6HlHKKxxt5945ozoooWtgmmX/uNU=;
        b=tcL9lgGIuxoOkEksljj69uUN2duPSYqeZb+/1vFQJCmYHaGeHfJKL9N6zGl5wmq9J1
         5iQxS2KTuiCWKxB/R5f8S+OfXGtULOlKa25Wjx49GLCoLvVn8e31TIXDNVvrqsOIcbxb
         ogW8uP2ytdngg5t83H/uhfSOxEPNX1RM0343SI0WQ7RrCZ3E9eziwDfibo3xBkbUgNpW
         YVKiPaj37pLbba8XTkSOcD5rUGVczo0JJmQ4qHQ00qvdr0OTPc8R8zBCqc+Uo0GTfqDW
         kfri1ky1hxxnia8RTKzucK6F/BYLwm2tCKLFBuVh4ZIie1TltCZk/YLNQ9FlrjvT62yx
         lWVQ==
X-Gm-Message-State: AOAM532ehZBwGel73dFnNxivIMvT//FmMNrA1RBq7fA5m83bZTEk0ZaJ
        SlR2Y/IxjM228AdxNlSHQQ==
X-Google-Smtp-Source: ABdhPJx9+FpzjzNAETTVdejkaoBHKTeQ1RW2pVbI9oyMCE0s9FJqTk+pnMGCEg+8AMXBEDVft4MD5A==
X-Received: by 2002:a05:6830:2aa1:b0:5c9:2691:ea3c with SMTP id s33-20020a0568302aa100b005c92691ea3cmr10173109otu.365.1647960965013;
        Tue, 22 Mar 2022 07:56:05 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 11-20020a05687013cb00b000dd9b5dd71csm7523019oat.56.2022.03.22.07.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:56:03 -0700 (PDT)
Received: (nullmailer pid 2004138 invoked by uid 1000);
        Tue, 22 Mar 2022 14:56:01 -0000
Date:   Tue, 22 Mar 2022 09:56:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 02/11] dt-bindings: net: add mdio property
Message-ID: <YjnjgVchVwskX+kL@robh.at.kernel.org>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
 <YjkJxykT2dQxe3d/@robh.at.kernel.org>
 <7526eff194e4dcfec1b8d88fc30b22aeb83e3100.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7526eff194e4dcfec1b8d88fc30b22aeb83e3100.camel@microchip.com>
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

On Tue, Mar 22, 2022 at 08:16:00PM +0530, Prasanna Vengateshan wrote:
> On Mon, 2022-03-21 at 18:27 -0500, Rob Herring wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > content is safe
> > 
> > On Fri, Mar 18, 2022 at 02:25:31PM +0530, Prasanna Vengateshan wrote:
> > > mdio bus is applicable to any switch hence it is added as per the below
> > > request,
> > > https://lore.kernel.org/netdev/1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com/
> > 
> > Quoting that thread:
> > 
> > > Yes indeed, since this is a common property of all DSA switches, it can
> > > be defined or not depending on whether the switch does have an internal
> > > MDIO bus controller or not.
> > 
> > Whether or not a switch has an MDIO controller or not is a property of
> > that switch and therefore 'mdio' needs to be documented in those switch
> > bindings.
> > 
> > > 
> > > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > > ---
> > >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > index b9d48e357e77..0f8426e219eb 100644
> > > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > > @@ -31,6 +31,10 @@ properties:
> > >        switch 1. <1 0> is cluster 1, switch 0. A switch not part of any
> > > cluster
> > >        (single device hanging off a CPU port) must not specify this property
> > >      $ref: /schemas/types.yaml#/definitions/uint32-array
> > > +
> > > +  mdio:
> > > +    $ref: /schemas/net/mdio.yaml#
> > > +    unevaluatedProperties: false
> > 
> > From a schema standpoint, this bans every switch from adding additional
> > properties under an mdio node. Not likely what you want.
> > 
> > Rob
> 
> Thanks for the feedback. Do you mean that the 'unevaluatedProperties: false' to
> be removed, so that the additional properties can be added? or mdio is not
> supposed to be defined in the dsa.yaml ?

'mdio' should not be defined here.

Rob
