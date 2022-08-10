Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D11858F227
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiHJSKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiHJSKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:10:17 -0400
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CC710D8;
        Wed, 10 Aug 2022 11:10:16 -0700 (PDT)
Received: by mail-il1-f177.google.com with SMTP id o14so8724735ilt.2;
        Wed, 10 Aug 2022 11:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0D2zsyejY7H3mCUQMpi1C3N991oh7KCilN66QDRGx+o=;
        b=Acc3xPZtKcljW8SzxOb/ZDnvQcmPH2FU0PlBXVFCvEsQENbCymQfzQZkr12wOdJWy1
         hFRQFq3ibeTFzbPcObvoKUBt9LpYknyqpwEvU5d4fq+pkAw/++wflHdx1LF1tacg/rJD
         RgBGCYjjerrlaDzpZ01qIKR4KnF9qUw7rn7QSk/pIpIJUOkitrafboOkfNmSna+gkZhr
         OXJYzWeFj0UQUmaqql4RuTu5p1PhWcrZDBpx7b8snOYgJYv86BnNI7XHVrr/P3WRAiqD
         DegzqiovukhbjyTWzr+qiOEWC8rgBXn7oTM3xZy+ywwYahQF4iqRcjHbjx95kMA/xZOq
         dDsw==
X-Gm-Message-State: ACgBeo3cyNblYpl8JNWzCMv4l0kp08IoUJBWAYlk/rrpnyGT9L83vDGc
        QK8jXaJpSaYkdrDguO92kA==
X-Google-Smtp-Source: AA6agR5d4AsX9K90n0Ys1OYAoyj/B+E1S7TnIfhjyAAak/DzJ5cPFU4MiDHA4HNZaHyC/UVS/jKP+w==
X-Received: by 2002:a05:6e02:1a41:b0:2de:e162:c5bb with SMTP id u1-20020a056e021a4100b002dee162c5bbmr13479096ilv.102.1660155015561;
        Wed, 10 Aug 2022 11:10:15 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l9-20020a02a889000000b00339e158bd3esm7757356jam.38.2022.08.10.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:10:15 -0700 (PDT)
Received: (nullmailer pid 260691 invoked by uid 1000);
        Wed, 10 Aug 2022 18:10:12 -0000
Date:   Wed, 10 Aug 2022 12:10:12 -0600
From:   Rob Herring <robh@kernel.org>
To:     Mark Kettenis <mark.kettenis@xs4all.nl>
Cc:     sven@svenpeter.dev, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, marcan@marcan.st, alyssa@rosenzweig.io,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCI
 Bluetooth
Message-ID: <20220810181012.GC200295-robh@kernel.org>
References: <20220801103633.27772-1-sven@svenpeter.dev>
 <20220801103633.27772-3-sven@svenpeter.dev>
 <20220801153921.GC1031441-robh@kernel.org>
 <d3ce6343fdaaf127@bloch.sibelius.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3ce6343fdaaf127@bloch.sibelius.xs4all.nl>
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

On Mon, Aug 01, 2022 at 05:51:23PM +0200, Mark Kettenis wrote:
> > Date: Mon, 1 Aug 2022 09:39:21 -0600
> > From: Rob Herring <robh@kernel.org>
> > 
> > On Mon, Aug 01, 2022 at 12:36:30PM +0200, Sven Peter wrote:
> > > These chips are combined Wi-Fi/Bluetooth radios which expose a
> > > PCI subfunction for the Bluetooth part.
> > > They are found in Apple machines such as the x86 models with the T2
> > > chip or the arm64 models with the M1 or M2 chips.
> > > 
> > > Signed-off-by: Sven Peter <sven@svenpeter.dev>
> > > ---
> > >  .../bindings/net/brcm,bcm4377-bluetooth.yaml  | 77 +++++++++++++++++++
> > >  MAINTAINERS                                   |  1 +
> > >  2 files changed, 78 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > > new file mode 100644
> > > index 000000000000..afe6ecebd939
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > > @@ -0,0 +1,77 @@
> > > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Broadcom BCM4377 family PCI Bluetooth Chips
> > > +
> > > +allOf:
> > > +  - $ref: bluetooth-controller.yaml#
> > > +
> > > +maintainers:
> > > +  - Sven Peter <sven@svenpeter.dev>
> > > +
> > > +description:
> > > +  This binding describes Broadcom BCM4377 family PCI-attached bluetooth chips
> > 
> > s/PCI/PCIe/
> > 
> > > +  usually found in Apple machines. The Wi-Fi part of the chip is described in
> > > +  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - pci14e4,5fa0 # BCM4377
> > > +      - pci14e4,5f69 # BCM4378
> > > +      - pci14e4,5f71 # BCM4387
> > > +
> > > +  reg:
> > > +    description: PCI device identifier.
> > > +
> > > +  brcm,board-type:
> > > +    $ref: /schemas/types.yaml#/definitions/string
> > > +    description: Board type of the Bluetooth chip. This is used to decouple
> > > +      the overall system board from the Bluetooth module and used to construct
> > > +      firmware and calibration data filenames.
> > > +      On Apple platforms, this should be the Apple module-instance codename
> > > +      prefixed by "apple,", e.g. "apple,atlantisb".
> > 
> > pattern: '^apple,.*'
> > 
> > And when there's other known vendors we can add them.
> > 
> > Really, I'm not all that crazy about this property. 'firmware-name' 
> > doesn't work? Or perhaps this should just be a more specific compatible 
> > string.
> 
> This matches the property proposed here:
> 
>   https://patchwork.kernel.org/project/linux-wireless/patch/20220104072658.69756-2-marcan@marcan.st/
> 
> Unfortunately that series didn't make progress for other reasons...
> 
> There was some significant bikeshedding in the original version of that series already:
> 
>   https://patchwork.kernel.org/project/linux-wireless/patch/20211226153624.162281-2-marcan@marcan.st/
> 
> Are you sure you want to repeat that? ;)

No, it's fine. :)

Rob
