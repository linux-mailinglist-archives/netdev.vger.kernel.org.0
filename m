Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B395A77E4
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiHaHqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiHaHpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:45:35 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D263D7B7A0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:45:21 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bq23so18784008lfb.7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ouTFxY93nE4Z9QkhFZSLBKekqYyiBXQP19HgDhyZHSU=;
        b=KaH7MCXXGQGzFH3dRW0/Fv7P3w2fHAmtPvJFEJm8HRZTM7oPKNxSNuqnLws54cFdz2
         JJbSZe8FWP7wO+KfbvOdXyFVA4wSNxKYi27qCwXtuG1rVbEyDnnYT5SVwk+nVNo81PFm
         CJ7NBXtdCA5607gVeIVUC/chvc/oEX1EQ7Vl+1Lk3nd1xAglRlrqwBsW37MmJgqCps1B
         sewjrGFON/2R+WugFtQksVIEnAt5MCSCAsKLJuMEhEbW8gtpiUqnNcwzdHe5SE5WPJli
         dV7mrnvhlOfRfQIF50u9qmQm5Jp83VE4LhdQT2XLVJoCCS8p0fQV9fNsG/+vel5iApuB
         TALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ouTFxY93nE4Z9QkhFZSLBKekqYyiBXQP19HgDhyZHSU=;
        b=octKFz1tnJxQgTgwVn9n+Hi78y1XAM2i6G/2ykVM3OxwlC4CG1f608uWdeekJR7SoZ
         wF7WW+nvFafWInxRCVB65eyjMVDHJONBnGMNc6hWL4H3is/FobyZiug6di8Rb0io0MMv
         7svJaim3d3EAroBGnQqWgz9KUy2rD8F2CzU/UvSaCba++ZdsXQZGTT8v7ojqjFxGEUFy
         auqVaz5IfGxZgxS4g0GI9MWWeHr/PNlv3SYnHcdaAPWJpEZfuh960cepAZnuQIK9zyph
         vqroKZbO20bjwtTkLHLTPyGW1afLtQdB1T2ppjnuDbhQVjyWCbGivJAxZiTwCkmwz5Bw
         NlmA==
X-Gm-Message-State: ACgBeo0aeeisWUZ0uZ5sx5g3GYfIVihSyJ8L+Xw/8rJFGolevh16DgBI
        r7xbtdGCxSRtevW6RVk2XMV0/A==
X-Google-Smtp-Source: AA6agR7DzXu8IZaFW+OBdsWSDmCTnpWerpKoskVDkUfL/4niQUo3xpWIrSAl2jDIzTuo0en6kWFeyw==
X-Received: by 2002:a05:6512:2354:b0:48a:e29b:2bb4 with SMTP id p20-20020a056512235400b0048ae29b2bb4mr9582773lfu.435.1661931920194;
        Wed, 31 Aug 2022 00:45:20 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id f12-20020a05651c02cc00b00261800f0e02sm53144ljo.26.2022.08.31.00.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 00:45:19 -0700 (PDT)
Message-ID: <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
Date:   Wed, 31 Aug 2022 10:45:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 09/14] dt-bindings: nvmem: add YAML schema for the sl28
 vpd layout
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-10-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220825214423.903672-10-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 00:44, Michael Walle wrote:
> Add a schema for the NVMEM layout on Kontron's sl28 boards.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../nvmem/layouts/kontron,sl28-vpd.yaml       | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
> new file mode 100644
> index 000000000000..e4bc2d9182db
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
> @@ -0,0 +1,52 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/layouts/kontron,sl28-vpd.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NVMEM layout of the Kontron SMARC-sAL28 vital product data
> +
> +maintainers:
> +  - Michael Walle <michael@walle.cc>
> +
> +description:
> +  The vital product data (VPD) of the sl28 boards contains a serial
> +  number and a base MAC address. The actual MAC addresses for the
> +  on-board ethernet devices are derived from this base MAC address by
> +  adding an offset.
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: kontron,sl28-vpd
> +      - const: user-otp
> +
> +  serial-number:
> +    type: object

You should define the contents of this object. I would expect this to be
uint32 or string. I think you also need description, as this is not
really standard field.

> +
> +  base-mac-address:

Fields should be rather described here, not in top-level description.

> +    type: object

On this level:
    additionalProperties: false

> +
> +    properties:
> +      "#nvmem-cell-cells":
> +        const: 1
> +

I also wonder why you do not have unit addresses. What if you want to
have two base MAC addresses?

> +required:
> +  - compatible

Other fields are I guess required? At least serial-number should be always?

> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +      otp-1 {

Messed up indentation (use 4 spaces). Generic node name "otp".

> +          compatible = "kontron,sl28-vpd", "user-otp";
> +
> +          serial_number: serial-number {

What's the point of the empty node?

> +          };
> +
> +          base_mac_address: base-mac-address {
> +              #nvmem-cell-cells = <1>;
> +          };
> +      };
> +
> +...


Best regards,
Krzysztof
