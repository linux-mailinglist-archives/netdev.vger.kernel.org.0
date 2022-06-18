Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4497755019A
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 03:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiFRBPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 21:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiFRBPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 21:15:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650CF6AA67
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 18:15:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y6so5474734pfr.13
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 18:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2Wicin66A5Ecw5eOHjSRw3gMf1e/v5xlB1s6rjFamVc=;
        b=rYxYQNnXCvLE4VkDuRntdBWtvRSy9Js0aFg2p7PC8AoRXwLqSP/VcXnFUB041aQM+Z
         Cr32BoNciIvWFGPNqDnK7+dLMMiii0j195J6SfzP5gqj+Th7Syj3gV9xjSTrjk4+j52R
         BuE485MDS3716u/H6iFT3/P7PmXu6SrRQOU/y23CI6AVDiBqO7tAzKdifXQehVcLPo+I
         4m/+uEHjUP4jyYxWVeBvHRwSxbGmHC3qJFDf0ZZfqCzJfPIXbdMlri+ZiC+3s3gMOG/U
         LrKqhRMR6EBTErEj1BmuWVGdvRiyLkpO4q/mbpMCGH5UY1Zl5qKSfMEGbolQniYIOl/9
         5+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Wicin66A5Ecw5eOHjSRw3gMf1e/v5xlB1s6rjFamVc=;
        b=5etDiDvtp1r+tsTqFXZFtjyCZOPPEMZyVVYtJfYBjkN9hA4NHqtyMzdLhQwhZFylPI
         rM6/hGUS02Lo1Njg1zQmjzcMs0fsZeFC1NropjOdD3Dc6/rnUfl7utxyb+O31FOcFyg1
         z3GJbEfwpsrViFJwRkFhb5pM+7uFTv+LCLWvS6gU5UfLZguv3S2S3KHyypZt5wwN3SAb
         fvveLYaJNV3HzcDohiwiH8OILZDFxBfeOkIhx1icu2EX+WW/6QbkeRhVvpyR5aHkHD6i
         16aznrxaNs9APyNPM+50nnAgJNw5nTJ7Qq5ZEd+QTmwxsTSxN+4H0hPXkED+n44WUn1u
         rdiA==
X-Gm-Message-State: AJIora+C+86325g4OHN79tSNm8/+Pfg/xtt3vAc8vVw+TNyfKILOn1Nf
        dsg4yWRCLDqoQwePxChP2m6RcQ==
X-Google-Smtp-Source: AGRyM1u5MsCZ5unrFNNSkRvF2SL6LwoHOZByCaW9oeRdELC6PITpnSRHbGHN4xDSAWSCZtviQKdPpg==
X-Received: by 2002:a63:6c42:0:b0:3fe:465:7a71 with SMTP id h63-20020a636c42000000b003fe04657a71mr11328301pgc.101.1655514950870;
        Fri, 17 Jun 2022 18:15:50 -0700 (PDT)
Received: from [172.31.235.92] ([216.9.110.6])
        by smtp.gmail.com with ESMTPSA id o1-20020a62f901000000b0052285857864sm4410468pfh.97.2022.06.17.18.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 18:15:50 -0700 (PDT)
Message-ID: <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
Date:   Fri, 17 Jun 2022 18:15:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220617203312.3799646-2-sean.anderson@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/06/2022 13:32, Sean Anderson wrote:
> This adds a binding for the SerDes module found on QorIQ processors. The
> phy reference has two cells, one for the first lane and one for the
> last. This should allow for good support of multi-lane protocols when
> (if) they are added. There is no protocol option, because the driver is
> designed to be able to completely reconfigure lanes at runtime.
> Generally, the phy consumer can select the appropriate protocol using
> set_mode. For the most part there is only one protocol controller
> (consumer) per lane/protocol combination. The exception to this is the
> B4860 processor, which has some lanes which can be connected to
> multiple MACs. For that processor, I anticipate the easiest way to
> resolve this will be to add an additional cell with a "protocol
> controller instance" property.
> 
> Each serdes has a unique set of supported protocols (and lanes). The
> support matrix is stored in the driver and is selected based on the
> compatible string. It is anticipated that a new compatible string will
> need to be added for each serdes on each SoC that drivers support is
> added for.
> 
> There are two PLLs, each of which can be used as the master clock for
> each lane. Each PLL has its own reference. For the moment they are
> required, because it simplifies the driver implementation. Absent
> reference clocks can be modeled by a fixed-clock with a rate of 0.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../bindings/phy/fsl,qoriq-serdes.yaml        | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
> new file mode 100644
> index 000000000000..4b9c1fcdab10
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
> @@ -0,0 +1,78 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/fsl,qoriq-serdes.yaml#

File name: fsl,ls1046a-serdes.yaml

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP QorIQ SerDes Device Tree Bindings

s/Device Tree Bindings//

> +
> +maintainers:
> +  - Sean Anderson <sean.anderson@seco.com>
> +
> +description: |
> +  This binding describes the SerDes devices found in NXP's QorIQ line of

Describe the device, not the binding, so wording "This binding" is not
appropriate.

> +  processors. The SerDes provides up to eight lanes. Each lane may be
> +  configured individually, or may be combined with adjacent lanes for a
> +  multi-lane protocol. The SerDes supports a variety of protocols, including up
> +  to 10G Ethernet, PCIe, SATA, and others. The specific protocols supported for
> +  each lane depend on the particular SoC.
> +
> +properties:

Compatible goes first.

> +  "#phy-cells":
> +    const: 2
> +    description: |
> +      The cells contain the following arguments.
> +
> +      - description: |

Not a correct schema. What is this "- description" attached to? There is
no items here...

> +          The first lane in the group. Lanes are numbered based on the register
> +          offsets, not the I/O ports. This corresponds to the letter-based
> +          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
> +          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
> +        minimum: 0
> +        maximum: 7
> +      - description: |
> +          Last lane. For single-lane protocols, this should be the same as the
> +          first lane.
> +        minimum: 0
> +        maximum: 7
> +
> +  compatible:
> +    enum:
> +      - fsl,ls1046a-serdes-1
> +      - fsl,ls1046a-serdes-2

Does not look like proper compatible and your explanation from commit
msg did not help me. What "1" and "2" stand for? Usually compatibles
cannot have some arbitrary properties encoded.

> +
> +  clocks:
> +    minItems: 2

No need for minItems.

> +    maxItems: 2
> +    description: |
> +      Clock for each PLL reference clock input.
> +
> +  clock-names:
> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      pattern: "^ref[0-1]$"

No, instead describe actual items with "const". See other examples.

> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - "#phy-cells"
> +  - compatible
> +  - clocks
> +  - clock-names
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    serdes1: phy@1ea0000 {
> +      #phy-cells = <2>;
> +      compatible = "fsl,ls1046a-serdes-1";
> +      reg = <0x0 0x1ea0000 0x0 0x2000>;
> +      clocks = <&clk_100mhz>, <&clk_156mhz>;
> +      clock-names = "ref0", "ref1";
> +    };
> +
> +...


Best regards,
Krzysztof
