Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E79267AAC7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbjAYHVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjAYHVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:21:48 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B327A1CAD7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 23:21:46 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h16so16058384wrz.12
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 23:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L5SsXW4to4mQPbXFM5nkMuDOk8eQmviGW5rf64++fL4=;
        b=ReXrQx6+rZd+ZciRU8AIKVwUDWyt0g96lI2F24Jrg0Zs6X9cIdJZfGJV2yCpx/5XY7
         iZZu9uGsvLyipfpyr1O955bUmb4hgbxIdEkhf4/cUV7GQyiq81RzE6l5cGSUfLY5/5n1
         IAxnGHPQwhIIY8w0ct4ovDET3aRff6xtM+nQjO/oznmkc88eghKbsby3LOSdRqom3oSx
         sbab/0GpdW7Zi3GxEA0DiKdTiGoikHP1Xr87dXnzL+pGehfdN/C2nkn4xzPECbYdnCgM
         w0swEv/YelX2YfjZjJEnSNp/aS7C78b715s16PiKyZHOHIhw9D7akZGZIrg/wL+2vGIc
         woWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5SsXW4to4mQPbXFM5nkMuDOk8eQmviGW5rf64++fL4=;
        b=fFgPO6Ypo/W9XSHNADaQy7QsHXUubx1a+Iwc/l0SCbuXho3akEkNpWHCefNFcPm45W
         N5QZW+q0UN3wiDvXkw75aNBI7xG7OqHjgYQJrw7rlz2e42zeu30HGNK9EpFDEUe+2ou1
         LCgKgDgP9/DFSl81E56gflwXE1/+23h30xk3I0Ani/qMVvx3yNOi951mONGF4bWoRG5i
         3d8NWRT59TvNWzloRWOMrLIwaYPRBWQ9PBqnw/Eaa0Lir1xUYqSV9IgCJz+PPsFlOLU7
         gKnTJdZVyqAzPUM/YO1hdG4/kYAfDVFMemSpN5okZvEI6fQr6fULLoXxH4yHw4KRmihz
         6nHw==
X-Gm-Message-State: AO0yUKVaWlO3msDBsliaUtVJNEEHDYipsqspApt7KFkERbiBKA7DD9Xz
        eMBn4VYiGoklhj/lHYd6p2Ciig==
X-Google-Smtp-Source: AK7set9vGUZVulA4Aem9PqZS78x6dG0a3JhlM9N28Kzg/F8G9qkkuTMXiGXfU/94PRT1yjSPSbiQIw==
X-Received: by 2002:a5d:6549:0:b0:2bf:b5bd:8f60 with SMTP id z9-20020a5d6549000000b002bfb5bd8f60mr2462243wrv.61.1674631305087;
        Tue, 24 Jan 2023 23:21:45 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id s8-20020a5d69c8000000b002755e301eeasm3616993wrw.100.2023.01.24.23.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:21:44 -0800 (PST)
Message-ID: <fcf66269-459c-c7fc-82b7-73303bd67950@linaro.org>
Date:   Wed, 25 Jan 2023 08:21:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Content-Language: en-US
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230124174714.2775680-3-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/01/2023 18:47, Neeraj Sanjay Kale wrote:
> Add binding document for generic and legacy NXP bluetooth
> chipset.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
>  .../bindings/net/bluetooth/nxp-bluetooth.yaml | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> new file mode 100644
> index 000000000000..d6226838ab1c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml

format is vendor,compatible

> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/bluetooth/nxp-bluetooth.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes from both

> +
> +title: NXP Bluetooth chips
> +
> +description:
> +  This documents the binding structure and common properties for serial
> +  attached NXP Bluetooth devices.

Drop "This documents the binding structure and common properties"... and
replace everything with proper hardware description.

> +
> +maintainers:
> +  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,nxp-generic-bt-chip
> +      - nxp,nxp-legacy-bt-chip

These are wrong on multiple levels. Duplicated vendor prefix. Not
specific compatible. Fake compatible (non-existing device).

> +
> +  firmware-name:
> +    description:
> +      Specify firmware file name. If this property is not
> +      specified, it is fetched from the user-space config
> +      file nxp/bt_mod_para.conf
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    &uart1 {
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&pinctrl_uart1>;
> +      assigned-clocks = <&clk IMX8MM_CLK_UART1>;
> +      assigned-clock-parents = <&clk IMX8MM_SYS_PLL1_80M>;
> +      fsl,uart-has-rtscts;

Drop everything above except serial node.

> +      status = "okay";

Drop

> +      bluetooth {
> +              compatible = "nxp,nxp-generic-bt-chip";

Wrong indentation. It's 4-space.

> +      };
> +    };
> +  - |
> +    &uart2 {
> +      bluetooth {
> +              compatible = "nxp,nxp-generic-bt-chip";
> +              firmware-name = "uartuart_n61x_v1.bin"
> +      };
> +    };
> +  - |
> +    &uart3 {
> +      bluetooth {
> +              compatible = "nxp,nxp-legacy-bt-chip";
> +      };
> +    };
> +  - |
> +    &uart4 {
> +      bluetooth {
> +              compatible = "nxp,nxp-legacy-bt-chip";
> +              firmware-name = "uartuart8987_bt.bin"
> +      };

Drop all these above - they do not bring anything.

> +    };
> +
> +

Best regards,
Krzysztof

