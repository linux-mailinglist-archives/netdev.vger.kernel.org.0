Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2295F41DB
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 13:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiJDLTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 07:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiJDLTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 07:19:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A209B00
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 04:19:36 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g1so20622874lfu.12
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 04:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=A6XWKxs2Jpf+nDr2Vc3Rkr+Qr/XH1f1qA7BAxLgKido=;
        b=cqvLdXqsagr5kcaewhfqkJeswzQsOsCweQYXWMcDtw8/jJOKAeWrzeV0MiRG92Tk5c
         Iid+d3NnsW0DRv2zLdSbKWciFbLjMEU8R5NsIvTF5ZTqh/gROVrtTHeIteNJOP0rvAyz
         4pEeNAzL8+WAH0FiH6ConPczbi5+BI/TGJTPA5d59wWDh0qeEVBwAvWj7cTLxxG3ZEgQ
         Pz0OMRWVLFNSsFEmeu5UvJc653p1QVupmaVXwkQopYcxxEyyLRFcPkA3zLknuqRg1fLJ
         5qOQoE3e+oUMah33fJsVepDT4BBT2jxGHJkdPIufs1JmyW80/W6vYTeBsEkXFJycTG/y
         yezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=A6XWKxs2Jpf+nDr2Vc3Rkr+Qr/XH1f1qA7BAxLgKido=;
        b=2Psbtkp5fIn2/1pfHA79zmd44M/meBbqLBFONy/qqHCTZliqR9inrY9IuHyKHmXgun
         HF3DUg7fC7Toa3ZsmSrvfb1+xZ0QChHDM2FghmuJYq/tcOrodh1tuj6hzNdHkctmlFKR
         53getpdoaINq7MZXfgDsQvJ6j0qVcVDSSOcbOQA2qNTUCqsoECDgLUAS5faSzfShSB+7
         UnHYBU3eUR4eJMCw42YEryRNLv76l4dERPSIy6un7oHY6x1GfyFZm3qIWfCfTQQOzMgh
         1u2MhGG2tZ7AHeRXNaBiR6/NGuWS86y4Qy+PjwQAdTHWL3OcIbSXrnoEK3S8+ICgN7L5
         Yy/A==
X-Gm-Message-State: ACrzQf1p3Iq2DPEBjBxZH6H7H8WDCrTxjAUM5FnB1n+nCGyPs+YzWboI
        t/MhJ2PVvBbuDKRfbskvaHpuMg==
X-Google-Smtp-Source: AMsMyM71ILvW++ziuI+MGJfwyGaej1nG2FBbgL4boFT0iAbsyH0SMVvWJ/EYJrCjNb1qjSnx+x4HHg==
X-Received: by 2002:a05:6512:b08:b0:4a1:d704:fc59 with SMTP id w8-20020a0565120b0800b004a1d704fc59mr8345629lfu.629.1664882374764;
        Tue, 04 Oct 2022 04:19:34 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g19-20020ac25393000000b0049944ab6895sm1877001lfh.260.2022.10.04.04.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 04:19:34 -0700 (PDT)
Message-ID: <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
Date:   Tue, 4 Oct 2022 13:19:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220926002928.2744638-13-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/09/2022 02:29, Colin Foster wrote:
> The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
> system, which currently supports the four internal copper phys.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>     * Remove "currently supported" verbage
>         The Seville and Felix 9959 all list their supported modes following
>         the sentence "The following PHY interface types are supported".
>         During V2, I had used "currently supported" to suggest more interface
>         modes are around the corner, though this had raised questions.
> 
>         The suggestion was to drop the entire sentence. I did leave the
>         modified sentence there because it exactly matches the other two
>         supported products.
> 
> v2
>     * New patch
> 
> ---
>  .../bindings/net/dsa/mscc,ocelot.yaml         | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> index 8d93ed9c172c..49450a04e589 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> @@ -54,9 +54,22 @@ description: |
>        - phy-mode = "1000base-x": on ports 0, 1, 2, 3
>        - phy-mode = "2500base-x": on ports 0, 1, 2, 3
>  
> +  VSC7412 (Ocelot-Ext):
> +
> +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> +    processor that natively support Linux. Additionally, all four devices
> +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> +    driver is for the external control portion.
> +
> +    The following PHY interface types are supported:
> +
> +      - phy-mode = "internal": on ports 0, 1, 2, 3
> +
>  properties:
>    compatible:
>      enum:
> +      - mscc,vsc7512-switch
>        - mscc,vsc9953-switch
>        - pci1957,eef0
>  
> @@ -258,3 +271,49 @@ examples:
>              };
>          };
>      };
> +  # Ocelot-ext VSC7512
> +  - |
> +    spi {
> +        soc@0 {

soc in spi is a bit confusing.

Does it even pass the tests? You have unit address but no reg.

> +            compatible = "mscc,vsc7512";


> +            #address-cells = <1>;
> +            #size-cells = <1>;
> +
> +            ethernet-switch@0 {
> +                compatible = "mscc,vsc7512-switch";
> +                reg = <0 0>;

0 is the address on which soc bus?

> +
> +                ethernet-ports {
> +                    #address-cells = <1>;
> +                    #size-cells = <0>;
> +
> +                    port@0 {
> +                        reg = <0>;
> +                        label = "cpu";
> +                        ethernet = <&mac_sw>;
> +                        phy-handle = <&phy0>;
> +                        phy-mode = "internal";
> +                    };
> +
> +                    port@1 {
> +                        reg = <1>;
> +                        label = "swp1";
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy1>;
> +                    };
> +
> +                    port@2 {
> +                        reg = <2>;
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy2>;
> +                    };
> +
> +                    port@3 {
> +                        reg = <3>;
> +                        phy-mode = "internal";
> +                        phy-handle = <&phy3>;
> +                    };

How is this example different than previous one (existing soc example)?
If by compatible and number of ports, then there is no much value here.

> +                };
> +            };
> +        };
> +    };

Best regards,
Krzysztof

