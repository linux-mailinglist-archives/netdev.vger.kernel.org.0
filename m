Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C1F361D55
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241765AbhDPJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhDPJaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:30:23 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC3BC061574;
        Fri, 16 Apr 2021 02:29:58 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a25so17028693ljm.11;
        Fri, 16 Apr 2021 02:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EOc1bwxC6MKPmosPl3ffeJ/6SfN279KUE69TnWHU0ss=;
        b=s5d68P/PQl5vprP/ICd6OM3nrCK1H9PQTPwFWFnMZ8S48h0B55uZyi8ovtcvUNDxfu
         1AjpibeFJmBpnA2DLI+sJEWJ2iHNWTVPxCLnX/oRt/M6kREzZ/K6D5XA6D4E+NnngVBc
         YEESLi4tXRZvITaCJ05QjwFeD3owxRGadCMK5HDmWnsGFxtUv/Nczs475Ua15KD9pXrF
         RYmSbV1EBFdo8Mq8nJ/KDaxjaPUxdOuJDSml7ijKexUxPs+OA+fhniNqebRnM+NKOng9
         tUj+78sxsjlBBxrKYCP+5PyZO07v9rgm736axyUhkDpu/CzUGDIcNLhU0iVYCDq/n0nO
         nACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=EOc1bwxC6MKPmosPl3ffeJ/6SfN279KUE69TnWHU0ss=;
        b=FwP0VpW+JRwG4jrpa8N0L7a5juaa6eKO1e9JphZSJ0TYnTj/8jrWgiDc6CJ9aNYsCU
         bf1p45dinXbhTjq4qI2MAoAAQSIlwux4BbF3zfxOs/H0RxZrMyGRiSs8cpE+P6P2NOW7
         +6/y6cd/IJYtJVgTrJ44azzyALZFTzqs9eIlkpZ8fzu3gG1VESmAj3Hwku7p6vBbbhdd
         35pIulIEj9Krl34mb2Uy5qx729NVmZD7eOpqMb/eZOfg+chfHivSLGZXNTuyW+fBSeQE
         S2MX2P7gQvEdDN6XpNlYA+VXB5bgsN5bhg7H0OxHkVIfWbcnFVxR6bXTzl690w+GZvsr
         i3zg==
X-Gm-Message-State: AOAM533cGHXxH1Ip0P4+pWuCdkN9Is5rI9p4e3dzIrmtV762feTrWXyI
        7JoFuzg/pRbjBg4pSEwtstgqI1mTWNI=
X-Google-Smtp-Source: ABdhPJwYr98g8ShAGDtcqQqP87agx0zpaoGCQFr1JAjL0nuzvb2W+q+fpddzBAVe6wmp/G8kXzSaBA==
X-Received: by 2002:a2e:8559:: with SMTP id u25mr2057691ljj.282.1618565397056;
        Fri, 16 Apr 2021 02:29:57 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.80.250])
        by smtp.gmail.com with ESMTPSA id d15sm934021lfn.117.2021.04.16.02.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 02:29:56 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT
 bindings for IDT 79RC3243x SoCs
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
 <20210416085207.63181-11-tsbogend@alpha.franken.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <ca4d9975-c153-94c9-dec8-bf9416c76b45@gmail.com>
Date:   Fri, 16 Apr 2021 12:29:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416085207.63181-11-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2021 11:52, Thomas Bogendoerfer wrote:

> Add device tree bindings for ethernet controller integrated into
> IDT 79RC3243x SoCs.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>   .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
>   1 file changed, 74 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> new file mode 100644
> index 000000000000..3697af5cb66f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> @@ -0,0 +1,74 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: IDT 79rc3243x Ethernet controller
> +
> +description: Ethernet controller integrated into IDT 79RC3243x family SoCs
> +
> +maintainers:
> +  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: idt,3243x-emac
> +
> +  reg:
> +    maxItems: 3
> +
> +  reg-names:
> +    items:
> +      - const: korina_regs
> +      - const: korina_dma_rx
> +      - const: korina_dma_tx
> +
> +  interrupts:
> +    items:
> +      - description: RX interrupt
> +      - description: TX interrupt
> +
> +  interrupt-names:
> +    items:
> +      - const: korina_rx
> +      - const: korina_tx
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: mdioclk
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +
> +    ethernet@60000 {
> +        compatible = "idt,3243x-emac";
> +
> +        reg = <0x60000 0x10000>,
> +              <0x40000 0x14>,
> +              <0x40014 0x14>;
> +        reg-names = "korina_regs",
> +                    "korina_dma_rx",
> +                    "korina_dma_tx";
> +
> +        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;

    You use this prop, yet don't describe it?

> +        interrupt-names = "korina_rx", "korina_tx";
> +
> +        clocks = <&iclk>;
> +        clock-names = "mdioclk";
> +    };

MBR, Sergei
