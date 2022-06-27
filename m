Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE9455D1DB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbiF0Ren (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiF0Rel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:34:41 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64D1B1CD;
        Mon, 27 Jun 2022 10:34:39 -0700 (PDT)
Received: by mail-io1-f43.google.com with SMTP id p69so10277998iod.10;
        Mon, 27 Jun 2022 10:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a/8X5CuFWSs44Wf8DabrTq3lrtrQa6yryAnIBK8XrMM=;
        b=dpTwiJs0sVdT1dprtR6W49mKRmiOZLvX5QJCz7jLaFoMhZ613SSTKyOjtjAveo6f9A
         QPxBnkiAQXYnLrS+bZKV5vhwtPD/menrEhc7E0mDpeMR2SETfT/cM4GQxRRj8bX4wkTU
         b/eCoCRC/RbBKBU2SHKxRGq8sVjwQl2vdyBlFv5gEEwlP4bWZWta0xqIeGC78IcaSAtz
         OVRMszn/hNqDJDDA2yV0uSaQCdG+tBhNBVnwkugxeCGpz9IiNUL0E3Sw9R+KMVwAUtqX
         /qIhBATsJkFj8VMAb+53kmuODivn4ojdzNuz9q5R/hOIOvfu4CGibjST1azv2xe2eHz/
         1e/g==
X-Gm-Message-State: AJIora8k2Xj/cnpRQnvlyI9Hu7EPJd9KBbf7EHwXKJFXG8RTmpb74Tam
        QaTvFEEOrW4RuxVmz/oQetcRCiGmGw==
X-Google-Smtp-Source: AGRyM1sywh7nza/vYaLVKSMTgBH/gRL4kZTOpa021AlwH6FPO+QZDC2J6Bq3pJHgENIJ1ZNse6UfLQ==
X-Received: by 2002:a5e:c60a:0:b0:674:fd9d:e31f with SMTP id f10-20020a5ec60a000000b00674fd9de31fmr7164558iok.148.1656351278940;
        Mon, 27 Jun 2022 10:34:38 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id i39-20020a023b67000000b00339e90e57e6sm4946959jaf.104.2022.06.27.10.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 10:34:38 -0700 (PDT)
Received: (nullmailer pid 2637344 invoked by uid 1000);
        Mon, 27 Jun 2022 17:34:36 -0000
Date:   Mon, 27 Jun 2022 11:34:36 -0600
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
Message-ID: <20220627173436.GA2616639-robh@kernel.org>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <acd9e85b1ba82875e83ca68ae2aa62d828bfdfa3.1655723462.git.hakan.jansson@infineon.com>
 <2c753258-b68e-b2ad-c4cc-f0a437769bc2@linaro.org>
 <cb973352-36f9-8d70-95ac-5b63a566422c@infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb973352-36f9-8d70-95ac-5b63a566422c@infineon.com>
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

On Mon, Jun 20, 2022 at 04:06:25PM +0200, Hakan Jansson wrote:
> Hi Krzysztof,
> 
> Thanks for replying.
> 
> On 6/20/2022 2:32 PM, Krzysztof Kozlowski wrote:
> > > CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
> > > Extend the binding with its DT compatible.
> > > 
> > > Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> > > ---
> > >   Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > index df59575840fe..71fe9b17f8f1 100644
> > > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
> > > @@ -24,6 +24,7 @@ properties:
> > >         - brcm,bcm43540-bt
> > >         - brcm,bcm4335a0
> > >         - brcm,bcm4349-bt
> > > +      - infineon,cyw55572-bt
> > Patch is okay, but just to be sure - is it entirely different device
> > from Infineon or some variant of Broadcom block?
> 
> CYW55572 is a new device from Infineon. It is not the same as any Broadcom
> device.
> 
> >   Are all existing
> > properties applicable to it as well?
> 
> Yes, all existing properties are applicable.

Including 'brcm,bt-pcm-int-params'? I don't see a BT reset signal 
either, but maybe that's not pinned out in the AzureWave module which 
was the only documentation details I could find[1].

I think a separate doc will be better as it can be more precise as to 
what's allowed or not. It's fine to reuse the same property names 
though.

Rob

[1] https://www.azurewave.com/img/infineon/AW-XH316_DS_DF_A_STD.pdf
