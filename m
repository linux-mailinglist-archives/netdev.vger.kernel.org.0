Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4D56B96AB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjCNNpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjCNNpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:45:18 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6813E8480E;
        Tue, 14 Mar 2023 06:42:22 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeb5a.dynamic.kabel-deutschland.de [95.90.235.90])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3796961CC457B;
        Tue, 14 Mar 2023 13:03:54 +0100 (CET)
Message-ID: <e1b0452c-4068-deba-4773-14006fd32c2a@molgen.mpg.de>
Date:   Tue, 14 Mar 2023 13:03:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v10 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Content-Language: en-US
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-3-neeraj.sanjaykale@nxp.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230313144028.3156825-3-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Neeraj,


Thank you for your patch.

Am 13.03.23 um 15:40 schrieb Neeraj Sanjay Kale:
> Add binding document for NXP bluetooth chipsets attached over UART.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> v2: Resolved dt_binding_check errors. (Rob Herring)
> v2: Modified description, added specific compatibility devices, corrected
> indentations. (Krzysztof Kozlowski)
> v3: Modified description, renamed file (Krzysztof Kozlowski)
> v4: Resolved dt_binding_check errors, corrected indentation.
> (Rob Herring, Krzysztof Kozlowski)
> v5: Corrected serial device name in example. (Krzysztof Kozlowski)
> ---
>   .../net/bluetooth/nxp,88w8987-bt.yaml         | 46 +++++++++++++++++++
>   MAINTAINERS                                   |  6 +++
>   2 files changed, 52 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> new file mode 100644
> index 000000000000..b913ca59b489
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> @@ -0,0 +1,46 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Bluetooth chips
> +
> +description:
> +  This binding describes UART-attached NXP bluetooth chips.
> +  These chips are dual-radio chips supporting WiFi and Bluetooth.
> +  The bluetooth works on standard H4 protocol over 4-wire UART.
> +  The RTS and CTS lines are used during FW download.
> +  To enable power save mode, the host asserts break signal
> +  over UART-TX line to put the chip into power save state.
> +  De-asserting break wakes-up the BT chip.

The verb is spelled with a space: wakes up the BT chip.

You seem to break the line whenever a sentence ends. Is that intentional?

> +
> +maintainers:
> +  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,88w8987-bt
> +      - nxp,88w8997-bt
> +
> +  fw-init-baudrate:
> +    description:
> +      Chip baudrate after FW is downloaded and initialized.
> +      This property depends on the module vendor's
> +      configuration. If this property is not specified,
> +      115200 is set as default.
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    serial {
> +        bluetooth {
> +            compatible = "nxp,88w8987-bt";
> +            fw-init-baudrate = <3000000>;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 32dd41574930..030ec6fe89df 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
>   S:	Maintained
>   F:	mm/zswap.c
>   
> +NXP BLUETOOTH WIRELESS DRIVERS
> +M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
> +M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
> +
>   THE REST
>   M:	Linus Torvalds <torvalds@linux-foundation.org>
>   L:	linux-kernel@vger.kernel.org
