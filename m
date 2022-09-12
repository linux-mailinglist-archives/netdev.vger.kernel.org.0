Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331C85B6293
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiILVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiILVM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:12:29 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930A040565;
        Mon, 12 Sep 2022 14:12:28 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1280590722dso26857805fac.1;
        Mon, 12 Sep 2022 14:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Nip0DqpF4pFkRZH+cZCKwsl/yHMaJf5IoaaXn/QNxSk=;
        b=EA4/lT4fZgdAFSZckHI4+WzZzlAqPld7jfIcIyfTEF5Vyuc32sAKeWzHVFNTIym76C
         OQ7zXTyo5JRzQq6CkpbNUU95A2SSV4aFMcXfh8TX0Jb18nC+T4hBZHetMBOAspQKZW1b
         aVyCwH9j0+W+mwTvKuCzFOCn5WqaoIyLORwU+z+EreHtcdZIBbs2ZTYwF2EEHDQ/yknO
         B2zQYzsCSkCcrmpKc08gf9QnIR/sf9YW6VXYkH2lg/gv9gaUJRoRtxmukjQ5wAKRx84I
         pfu9ndrNScM0AHoBzNH4ldagIbL9dAuwomLLcI/Lj9Nh8G/gOi9Hs+nH7yGT0mzT4nDT
         7HFw==
X-Gm-Message-State: ACgBeo0KbgysU3Sm/SoPNiErJpp9BLKWj4Ba+qm7T7pdgCSxMtBTFECU
        XkNi7cLhZFOG7tnLPL/mtQ==
X-Google-Smtp-Source: AA6agR7BL/CQtAyYvQvcr+vIkRvAqs7VKLr+Xu8UpOBsWQGAV67Cg2TMBwDDp3CR4aFgS7C2yCTYNw==
X-Received: by 2002:a05:6808:1996:b0:34f:c809:e298 with SMTP id bj22-20020a056808199600b0034fc809e298mr128276oib.184.1663017147764;
        Mon, 12 Sep 2022 14:12:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c186-20020acab3c3000000b0034484c532c7sm4421093oif.32.2022.09.12.14.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 14:12:27 -0700 (PDT)
Received: (nullmailer pid 1872059 invoked by uid 1000);
        Mon, 12 Sep 2022 21:12:26 -0000
Date:   Mon, 12 Sep 2022 16:12:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sven Peter <sven@svenpeter.dev>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] dt-bindings: net: Add Broadcom BCM4377 family
 PCIe Bluetooth
Message-ID: <20220912211226.GA1847448-robh@kernel.org>
References: <20220907170935.11757-1-sven@svenpeter.dev>
 <20220907170935.11757-3-sven@svenpeter.dev>
 <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb799ea-d58e-70dc-c5c2-daaff1b19bf5@linaro.org>
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

On Thu, Sep 08, 2022 at 01:19:17PM +0200, Krzysztof Kozlowski wrote:
> On 07/09/2022 19:09, Sven Peter wrote:
> > These chips are combined Wi-Fi/Bluetooth radios which expose a
> > PCI subfunction for the Bluetooth part.
> > They are found in Apple machines such as the x86 models with the T2
> > chip or the arm64 models with the M1 or M2 chips.
> > 
> > Signed-off-by: Sven Peter <sven@svenpeter.dev>
> > ---
> > changes from v1:
> >   - added apple,* pattern to brcm,board-type
> >   - s/PCI/PCIe/
> >   - fixed 1st reg cell inside the example to not contain the bus number
> > 
> > .../bindings/net/brcm,bcm4377-bluetooth.yaml  | 78 +++++++++++++++++++
> >  MAINTAINERS                                   |  1 +
> >  2 files changed, 79 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > new file mode 100644
> > index 000000000000..fb851f8e6bcb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> > @@ -0,0 +1,78 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Broadcom BCM4377 family PCIe Bluetooth Chips
> > +
> > +allOf:
> > +  - $ref: bluetooth-controller.yaml#
> 
> Put it before properties (so after description).
> 
> > +
> > +maintainers:
> > +  - Sven Peter <sven@svenpeter.dev>
> > +
> > +description:
> > +  This binding describes Broadcom BCM4377 family PCIe-attached bluetooth chips
> > +  usually found in Apple machines. The Wi-Fi part of the chip is described in
> > +  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - pci14e4,5fa0 # BCM4377
> > +      - pci14e4,5f69 # BCM4378
> > +      - pci14e4,5f71 # BCM4387
> > +
> > +  reg:
> > +    description: PCI device identifier.
> 
> maxItems: X

And drop the description.

> 
> > +
> > +  brcm,board-type:
> > +    $ref: /schemas/types.yaml#/definitions/string
> > +    description: Board type of the Bluetooth chip. This is used to decouple
> > +      the overall system board from the Bluetooth module and used to construct
> > +      firmware and calibration data filenames.
> > +      On Apple platforms, this should be the Apple module-instance codename
> > +      prefixed by "apple,", e.g. "apple,atlantisb".
> > +    pattern: '^apple,.*'
> > +
> > +  brcm,taurus-cal-blob:
> > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > +    description: A per-device calibration blob for the Bluetooth radio. This
> > +      should be filled in by the bootloader from platform configuration
> > +      data, if necessary, and will be uploaded to the device.
> > +      This blob is used if the chip stepping of the Bluetooth module does not
> > +      support beamforming.
> 
> Isn't it:
> s/beamforming/beam forming/
> ?
> 
> > +
> > +  brcm,taurus-bf-cal-blob:
> > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > +    description: A per-device calibration blob for the Bluetooth radio. This
> > +      should be filled in by the bootloader from platform configuration
> > +      data, if necessary, and will be uploaded to the device.
> > +      This blob is used if the chip stepping of the Bluetooth module supports
> > +      beamforming.
> 
> Same here.
> 
> > +
> > +  local-bd-address: true
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - local-bd-address
> > +  - brcm,board-type
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    pcie {
> > +      #address-cells = <3>;
> > +      #size-cells = <2>;
> > +
> > +      bluetooth@0,1 {
> 
> The unit address seems to be different than reg.

Right, this says dev 0, func 1.

dtc can check this, but IIRC it would need 'device_type = "pci";' 
in the parent. So please add that, and verify you get a warning.

Rob
