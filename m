Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD855F17C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiF1WlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF1WlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:41:14 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E4B3A707;
        Tue, 28 Jun 2022 15:41:13 -0700 (PDT)
Received: by mail-io1-f45.google.com with SMTP id z191so14302972iof.6;
        Tue, 28 Jun 2022 15:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qEJ6NIMODyzLSJUUAKgzdz2kgaLM3nSVraMHRGonfRw=;
        b=n0FOmfZFkOvAT35mF50Y3BOKKecDoxOnk7M56Nj+HpCD73gpOaTfeIRys84GZzM+eR
         VDG3C4xtB/nEi6zXc0CDPTAd5zGMC7pY7slSBkmg6B2xa/n7j6loRqIcE8J8w8dJllQ0
         7bPBV28nC10HD8qUCCOSjW7xI1z/QCHKurNU9IbuSwV6HU3d4rD9AOMAmPLwN6WcvnjP
         2QmVBI255CLWAkq+tkJxCwq7TEt2bkldGo0q/bkGIYOipqwOFD31vIXUDUfpS0hzaYB1
         dZE8BCGHZ2nQDGX8FArEH99IanJ3O27pO/YMcFeF21xR3bBaqhHdFhxDg02dY9qNtCmZ
         6P+A==
X-Gm-Message-State: AJIora9alvZhpTZsaDFLHBku+pNYMzM7V+rMUgZ/ix+5vzbvuiO2aJHD
        Kvh5rhUC4geeVmpAgxrVBw==
X-Google-Smtp-Source: AGRyM1uSqS4KlfGzSRqKyLMgOQjXcJTHLzK0bXfAvbV6EJQA8L+i2z/OhYLFHbF+PkFivCw74lkDTg==
X-Received: by 2002:a6b:b40e:0:b0:672:75a9:c0d5 with SMTP id d14-20020a6bb40e000000b0067275a9c0d5mr179865iof.59.1656456072986;
        Tue, 28 Jun 2022 15:41:12 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id e39-20020a022127000000b0032e49fcc241sm6585227jaa.176.2022.06.28.15.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 15:41:12 -0700 (PDT)
Received: (nullmailer pid 1105293 invoked by uid 1000);
        Tue, 28 Jun 2022 22:41:10 -0000
Date:   Tue, 28 Jun 2022 16:41:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/4] dt-bindings: net: broadcom-bluetooth: Add CYW55572
 DT binding
Message-ID: <20220628224110.GD963202-robh@kernel.org>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <acd9e85b1ba82875e83ca68ae2aa62d828bfdfa3.1655723462.git.hakan.jansson@infineon.com>
 <2c753258-b68e-b2ad-c4cc-f0a437769bc2@linaro.org>
 <cb973352-36f9-8d70-95ac-5b63a566422c@infineon.com>
 <20220627173436.GA2616639-robh@kernel.org>
 <6e3a557a-fb0e-3b28-68f2-32804b071cfb@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e3a557a-fb0e-3b28-68f2-32804b071cfb@infineon.com>
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

On Tue, Jun 28, 2022 at 04:03:57PM +0200, Hakan Jansson wrote:
> Hi Rob,
> 
> On 6/27/2022 7:34 PM, Rob Herring wrote:
> > On Mon, Jun 20, 2022 at 04:06:25PM +0200, Hakan Jansson wrote:
> > > Hi Krzysztof,
> > > 
> > > Thanks for replying.
> > > 
> > > On 6/20/2022 2:32 PM, Krzysztof Kozlowski wrote:
> > > > > CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
> > > > > Extend the binding with its DT compatible.
> > > > > 
> > > > > Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> > > > > ---
> > > > >    Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
> > > > >    1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > > > index df59575840fe..71fe9b17f8f1 100644
> > > > > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > > > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > > > @@ -24,6 +24,7 @@ properties:
> > > > >          - brcm,bcm43540-bt
> > > > >          - brcm,bcm4335a0
> > > > >          - brcm,bcm4349-bt
> > > > > +      - infineon,cyw55572-bt
> > > > Patch is okay, but just to be sure - is it entirely different device
> > > > from Infineon or some variant of Broadcom block?
> > > CYW55572 is a new device from Infineon. It is not the same as any Broadcom
> > > device.
> > > 
> > > >    Are all existing
> > > > properties applicable to it as well?
> > > Yes, all existing properties are applicable.
> > Including 'brcm,bt-pcm-int-params'?
> 
> Yes, 'brcm,bt-pcm-int-params' is also applicable to CYW55572.
> 
> > I don't see a BT reset signal
> > either, but maybe that's not pinned out in the AzureWave module which
> > was the only documentation details I could find[1].
> 
> That's correct, CYW55572 does not have a BT reset signal. Most of the
> existing listed compatible devices does not seem to have a BT reset signal
> either so I think this is in line with the intention of the existing
> document and driver implementation.
> 
> > I think a separate doc will be better as it can be more precise as to
> > what's allowed or not. It's fine to reuse the same property names
> > though.
> 
> I don't really see anything besides the optional BT reset property that
> would be changed in a separate doc.  As a separate doc would mean a
> duplication of data that would need to be maintained in two more or less
> identical docs, perhaps it would be better to modify the existing doc to
> clarify for which compatible devices that the BT reset property applies?
> (Which I believe are only these three: bcm20702a1, bcm4329-bt and
> bcm4330-bt)

Okay, I guess this is fine in the same doc. Any conditionals to tighten 
up the constraints would be welcome.

Rob
