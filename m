Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBD695D01
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjBNIdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBNIdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:33:50 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF919031
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:33:46 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so10930591wmb.2
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ejEtMeBPAExp6t+VkmV02BN0b+eFcA/gZrz9wzLiQ7o=;
        b=n8HQN19AxeMJEOJUepEp44f87OkEuIvnINHRadawoYB7AXncgM0A42B4HxFHpaH28C
         InHrWqqU1ElMciZp3kyyl4rRVOP8otaTP9Yeisv9bQGrDAKOxfzt/b8riA3jk1B7fF1Z
         UKZks+QEBoMVvAsCRtEvPzUgWQWQSQkufNeN1YJdz4dHEqCe6I9d8kf8R/7sRU557gvU
         CHPlu2DBdmgFeMU+42kK8Xrw4T9cS9HNBiVeQoc+Np9fg2qEFs59vvid8ioYYm6aPVAo
         Zxq06nv14MCT19FHta3cqoqdkwZlnh3AqtsHFdyl56yPCByq4oVvErXI1Y+D9WTDLt0V
         Rw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ejEtMeBPAExp6t+VkmV02BN0b+eFcA/gZrz9wzLiQ7o=;
        b=os6gWrL5NIhdywHoX/c0jcFQUQ5yod66+C4CM5bInUuaHgGtwsokSIG8GqRYfIPFce
         KPPTYYkB0VxM1g26576IPkw1MDr3/8btMzI/YrzBIg6AeF1jQk2fX1NAiAxIx5TiIYgc
         /rVP4q3hWmnVteNj9D7UktZ83A6EJa5JgYKFtEV+URBucsZgUYGPBB371rZGRaw/EY+Y
         DBYGDA7lEc+D9jBFg4b4izzQK2x6T99h2HaQswRHnF7gd5JYr+ePrDhmCQH0Y8fm/5C3
         nUMsEJhzj7dd8vbT4ckc9UiorKDvtiDcUoY0pRPueo6ZsjNUveLfHOR8sePt9lQhoNdi
         b2MQ==
X-Gm-Message-State: AO0yUKXBlrt2oOxq4SL0opYdrsmQmaWMyNgCO5n4xC4MewctvHRdrAmX
        a2PdCya4mbz86NwPiCjVPh/cZoMRbmQGsdNu
X-Google-Smtp-Source: AK7set+A1fCoRJwiI7MCWml+SDJKG30LEP0RsDV/PHSNGYnlMV3CnQPGLlHbZbY8mBInF6MAprhLEQ==
X-Received: by 2002:a7b:c3d7:0:b0:3df:ef18:b0a1 with SMTP id t23-20020a7bc3d7000000b003dfef18b0a1mr1225722wmj.12.1676363625117;
        Tue, 14 Feb 2023 00:33:45 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id d1-20020adff841000000b002c5640f9bf9sm1106229wrq.85.2023.02.14.00.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 00:33:44 -0800 (PST)
Message-ID: <60928656-c565-773d-52e6-2142e997eee4@linaro.org>
Date:   Tue, 14 Feb 2023 09:33:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Content-Language: en-US
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
 <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2023 15:54, Neeraj Sanjay Kale wrote:
> Add binding document for NXP bluetooth chipsets attached
> over UART.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Resolved dt_binding_check errors. (Rob Herring)
> v2: Modified description, added specific compatibility devices, corrected indentations. (Krzysztof Kozlowski)
> v3: Modified description, renamed file (Krzysztof Kozlowski)
> ---
>  .../bindings/net/bluetooth/nxp,w8xxx-bt.yaml  | 44 +++++++++++++++++++

I don't think I proposed such filename.

>  MAINTAINERS                                   |  7 +++
>  2 files changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
> new file mode 100644
> index 000000000000..2685f6d5904f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/bluetooth/nxp-bluetooth.yaml#

Does not look like you tested the bindings. Please run `make
dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Bluetooth chips
> +
> +description:
> +  This binding describes UART-attached NXP bluetooth chips.
> +  These chips are dual-radio chips supporting WiFi and Bluetooth,
> +  except for iw612, which is a tri-radio chip supporting 15.4
> +  as well.
> +  The bluetooth works on standard H4 protocol over 4-wire UART.
> +  The RTS and CTS lines are used during FW download.
> +  To enable power save mode, the host asserts break signal
> +  over UART-TX line to put the chip into power save state.
> +  De-asserting break wakes-up the BT chip.
> +
> +maintainers:
> +  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,88w8987-bt
> +      - nxp,88w8997-bt
> +      - nxp,88w9098-bt
> +      - nxp,iw416-bt
> +      - nxp,iw612-bt
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    uart2 {

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Thank you.

> +        uart-has-rtscts;
> +        bluetooth {
> +          compatible = "nxp,iw416-bt";

Wrong indentation. Use 4 spaces for example indentation.


Best regards,
Krzysztof

