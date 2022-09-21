Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FEF5BF80C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiIUHpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIUHpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:45:24 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F2E7754D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:45:21 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id c7so5902121ljm.12
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9movZw0O/E24Sq9jjEpuz0M8OZ4ZSE7oi+Dy0RWuqOo=;
        b=VMU6hCT7GCWwiZCBIeb+Mg3XIWHqqAR6yyE4/9BHRE9RQg+Zh69VvedDsW4w9USQTd
         jWwYJvJbr/oTsHYcirsEo127/KVSV0MKPi51pyl3Ke1m+GBcyVsIF8M8AdGQJTfgmNim
         Fh2g2TyTvrNJOj2oEE3VocyZQ7UV2d/HnI0p2DFVrRkoXmBVfVK0i2mZa5+uZyVXN2Mk
         fKfg/HHTJ1YaUPi8pnsAWEfLQA2DPpCahA9JvagTPnNiomPrjFDRxmyr1dd30bCb0iJW
         cGRrNI95sWG6/blpYKWVEEnheRudSScpEF9fg5qELa7gMpo3zAT0tyqckmtwGuDWRRai
         gXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9movZw0O/E24Sq9jjEpuz0M8OZ4ZSE7oi+Dy0RWuqOo=;
        b=1w4TGL55hpQQbqy4Q7xF0vBJ3+F+p6HmT0KvXCcu+LiDOjGchAqYiqHTadsgZ+yh1e
         w5SS2TskqAsV7WbshXegxWZmW71mBJqDOs79QzzE3KWELiOkmb7M8kZiPHq8LPjVxLcr
         8Do0WHUEFV4UlySBG+QqcFirRDZtjhFstGQpkqDsJjGZBauMcrCJ/KEf47HwscPNgouU
         X/u7uY/X425vRepb+bR6L1KFWiw/MJpe4h/TqZhG4zQkTCWEntVSIV/rqco8IVd+HH7a
         jTRL2VypCNmqgHp7ia1tkBNSWtZlwXpYPPRSCNVtDTRLd68Ji9OhdDWxlADViynnWg1C
         BIfA==
X-Gm-Message-State: ACrzQf1bAtyuLr2g2NmLrXJ6PQq8utLIBdm1MDcSye6WMz/yYecPFd51
        AIHXxUfP2Ti1BBPaUtembbRDiA==
X-Google-Smtp-Source: AMsMyM7uSr9MZ8LVijuV2GTgPXryOCIqDkI2Cp+7R+GqxQnA+G0aJnSDW9s5Y+iMsoOUTcOrduqZ6g==
X-Received: by 2002:a05:651c:1257:b0:26c:4e3b:6d98 with SMTP id h23-20020a05651c125700b0026c4e3b6d98mr4961428ljh.492.1663746319843;
        Wed, 21 Sep 2022 00:45:19 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z18-20020a19f712000000b0049adbc24b99sm329885lfe.24.2022.09.21.00.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 00:45:19 -0700 (PDT)
Message-ID: <d179f987-6d3b-449f-8f48-4ab0fff43227@linaro.org>
Date:   Wed, 21 Sep 2022 09:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC V2 PATCH 2/3] dt-bindings: net: xilinx_axienet: Introduce
 dmaengine binding support
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        michal.simek@amd.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@xilinx.com,
        git@amd.com
References: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
 <20220920055703.13246-3-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220920055703.13246-3-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 07:57, Sarath Babu Naidu Gaddam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> The axiethernet driver will now use dmaengine framework to communicate
> with dma controller IP instead of built-in dma programming sequence.
> 
> To request dma transmit and receive channels the axiethernet driver uses
> generic dmas, dma-names properties. It deprecates axistream-connected
> property, remove axidma reg and interrupt properties from the ethernet
> node. Just to highlight that these DT changes are not backward compatible
> due to major driver restructuring/cleanup done in adopting the dmaengine
> framework.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> Changes in V2:
> - None.
> ---
>  .../devicetree/bindings/net/xlnx,axiethernet.yaml  |   39 ++++++++++++--------
>  1 files changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> index 780edf3..1dc1719 100644
> --- a/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> +++ b/Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml
> @@ -14,10 +14,8 @@ description: |
>    offloading TX/RX checksum calculation off the processor.
>  
>    Management configuration is done through the AXI interface, while payload is
> -  sent and received through means of an AXI DMA controller. This driver
> -  includes the DMA driver code, so this driver is incompatible with AXI DMA
> -  driver.
> -
> +  sent and received through means of an AXI DMA controller using dmaengine
> +  framework.
>  
>  allOf:
>    - $ref: "ethernet-controller.yaml#"
> @@ -36,19 +34,13 @@ properties:
>  
>    reg:
>      description:
> -      Address and length of the IO space, as well as the address
> -      and length of the AXI DMA controller IO space, unless
> -      axistream-connected is specified, in which case the reg
> -      attribute of the node referenced by it is used.
> -    maxItems: 2
> +      Address and length of the IO space.
> +    maxItems: 1
>  
>    interrupts:
>      description:
> -      Can point to at most 3 interrupts. TX DMA, RX DMA, and optionally Ethernet
> -      core. If axistream-connected is specified, the TX/RX DMA interrupts should
> -      be on that node instead, and only the Ethernet core interrupt is optionally
> -      specified here.
> -    maxItems: 3
> +      Ethernet core interrupt.
> +    maxItems: 1
>  
>    phy-handle: true
>  
> @@ -109,6 +101,7 @@ properties:
>        for the AXI DMA controller used by this device. If this is specified,
>        the DMA-related resources from that device (DMA registers and DMA
>        TX/RX interrupts) rather than this one will be used.
> +    deprecated: true
>  
>    mdio: true
>  
> @@ -118,12 +111,24 @@ properties:
>        and "phy-handle" should point to an external PHY if exists.
>      $ref: /schemas/types.yaml#/definitions/phandle
>  
> +  dmas:
> +    items:
> +      - description: TX DMA Channel phandle and DMA request line number
> +      - description: RX DMA Channel phandle and DMA request line number
> +
> +  dma-names:
> +    items:
> +      - const: tx_chan0
> +      - const: rx_chan0
> +
>  required:
>    - compatible
>    - interrupts
>    - reg
>    - xlnx,rxmem
>    - phy-handle
> +  - dmas
> +  - dma-names
>  
>  additionalProperties: false
>  
> @@ -132,11 +137,13 @@ examples:
>      axi_ethernet_eth: ethernet@40c00000 {
>        compatible = "xlnx,axi-ethernet-1.00.a";
>        interrupt-parent = <&microblaze_0_axi_intc>;
> -      interrupts = <2>, <0>, <1>;
> +      interrupts = <1>;

This looks like an ABI break. How do you handle old DTS? Oh wait... you
do not handle it at all.


Best regards,
Krzysztof
