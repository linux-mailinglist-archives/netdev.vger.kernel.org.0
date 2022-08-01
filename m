Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1231586DE7
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiHAPj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiHAPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:39:26 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D002A279;
        Mon,  1 Aug 2022 08:39:25 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id w16so5735415ilh.0;
        Mon, 01 Aug 2022 08:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=50cOczXCPH0lsQClqP+sr3sqPn4n1C8s/4thD9fgHTU=;
        b=5Xe1Oophi9dYEz9lTrZILsq46utzyn1IkkuxhQP4UQ5+wSlmnb8gbCO32uTww2DSjV
         mqmletHkarH/UhSua2cySrgJhkt6fW+yebML7Ha98OHshWZ11m5FkTGX3CPL1lhyDUwh
         0AGWcvOArp+YLzIEGMxSylImUyVaMonUe1hIdybAVPFXauD8PHfufYlp1EdmtZbsSvOA
         hBuZ3/ULzNoJkpMD3B8VvvFvfLSaWVX88rcITKsxIFnV6mDyl/NnP8fJB7aXBWh7a67s
         6HlIlMI3skh270uUAlrGlnD23RcBVDlvR1a0TcqW9PQmh5H6aV3NsR43fL993aABdBY8
         GB+A==
X-Gm-Message-State: ACgBeo0sU1E+6ylcgjz3o3VudXPLPSQwwbyd+Xkvc099WUUu9b6SYnUo
        4V7M1TXTiA87AskdOWXvQQ==
X-Google-Smtp-Source: AA6agR7ju5Fs55jq+PCYBmrlKdHUGFWx2/lR5ijKxxaC3y89nGYNuB/SdtKwX2ae3BTu7NsBh3Gokw==
X-Received: by 2002:a05:6e02:1bc7:b0:2de:5f6d:866b with SMTP id x7-20020a056e021bc700b002de5f6d866bmr3730348ilv.58.1659368364971;
        Mon, 01 Aug 2022 08:39:24 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id t11-20020a92c0cb000000b002dc2b20e9cfsm4891648ilf.1.2022.08.01.08.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 08:39:24 -0700 (PDT)
Received: (nullmailer pid 1066414 invoked by uid 1000);
        Mon, 01 Aug 2022 15:39:21 -0000
Date:   Mon, 1 Aug 2022 09:39:21 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sven Peter <sven@svenpeter.dev>
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
Subject: Re: [PATCH 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCI
 Bluetooth
Message-ID: <20220801153921.GC1031441-robh@kernel.org>
References: <20220801103633.27772-1-sven@svenpeter.dev>
 <20220801103633.27772-3-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801103633.27772-3-sven@svenpeter.dev>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 12:36:30PM +0200, Sven Peter wrote:
> These chips are combined Wi-Fi/Bluetooth radios which expose a
> PCI subfunction for the Bluetooth part.
> They are found in Apple machines such as the x86 models with the T2
> chip or the arm64 models with the M1 or M2 chips.
> 
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
>  .../bindings/net/brcm,bcm4377-bluetooth.yaml  | 77 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> new file mode 100644
> index 000000000000..afe6ecebd939
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
> @@ -0,0 +1,77 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Broadcom BCM4377 family PCI Bluetooth Chips
> +
> +allOf:
> +  - $ref: bluetooth-controller.yaml#
> +
> +maintainers:
> +  - Sven Peter <sven@svenpeter.dev>
> +
> +description:
> +  This binding describes Broadcom BCM4377 family PCI-attached bluetooth chips

s/PCI/PCIe/

> +  usually found in Apple machines. The Wi-Fi part of the chip is described in
> +  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - pci14e4,5fa0 # BCM4377
> +      - pci14e4,5f69 # BCM4378
> +      - pci14e4,5f71 # BCM4387
> +
> +  reg:
> +    description: PCI device identifier.
> +
> +  brcm,board-type:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Board type of the Bluetooth chip. This is used to decouple
> +      the overall system board from the Bluetooth module and used to construct
> +      firmware and calibration data filenames.
> +      On Apple platforms, this should be the Apple module-instance codename
> +      prefixed by "apple,", e.g. "apple,atlantisb".

pattern: '^apple,.*'

And when there's other known vendors we can add them.

Really, I'm not all that crazy about this property. 'firmware-name' 
doesn't work? Or perhaps this should just be a more specific compatible 
string.

> +
> +  brcm,taurus-cal-blob:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description: A per-device calibration blob for the Bluetooth radio. This
> +      should be filled in by the bootloader from platform configuration
> +      data, if necessary, and will be uploaded to the device.
> +      This blob is used if the chip stepping of the Bluetooth module does not
> +      support beamforming.
> +
> +  brcm,taurus-bf-cal-blob:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description: A per-device calibration blob for the Bluetooth radio. This
> +      should be filled in by the bootloader from platform configuration
> +      data, if necessary, and will be uploaded to the device.
> +      This blob is used if the chip stepping of the Bluetooth module supports
> +      beamforming.
> +
> +  local-bd-address: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - local-bd-address
> +  - brcm,board-type
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    pci0 {

pcie {

> +      #address-cells = <3>;
> +      #size-cells = <2>;
> +
> +      bluetooth@0,1 {
> +        compatible = "pci14e4,5f69";
> +        reg = <0x10100 0x0 0x0 0x0 0x0>;

reg should not have the bus number here as that is dynamic. So 0x100 for 
the 1st cell.

> +        brcm,board-type = "apple,honshu";
> +        /* To be filled by the bootloader */
> +        local-bd-address = [00 00 00 00 00 00];
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6d3bd9d2a8d..8965556bace8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1837,6 +1837,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
>  F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
>  F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
>  F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
> +F:	Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
>  F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
>  F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
>  F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
> -- 
> 2.25.1
> 
> 
