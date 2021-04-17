Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FAD362F24
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 12:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhDQKUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 06:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhDQKUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 06:20:00 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E2CC061574;
        Sat, 17 Apr 2021 03:19:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x20so18318017lfu.6;
        Sat, 17 Apr 2021 03:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yP0+tXJppEoVKPFPyIZF13u7hO0z5tpvlrY6orlnmJ8=;
        b=p3qriIIzAFlcTYskj/a064wvn8X7Swo9IwasmmisihorVMHxdEkGrfRTUtKsPjnIub
         SZ7aVJ9ddHrZfWSl1MFdvZicVV+pTxQ4t4YgBiEDIs9JFoax7OJLTEXahSlw7nbFwaCP
         /uB2OEhmmYIQoHnMctcQVcaHFPArOVbN7FvSDgfAuwoW+eia3wCw4zToZe5towrcMwoX
         vN3FxRirnv3/onaBDaGjEhEaiC6vEExe79YvCfzt7ueVgAxl6JqjCEnfQXry4MvrAX8D
         MgWzMFR6a+okpJuBvZiSkGgo14z8wrxh+1F18WFb+kFk8PgQPqj11AhmB+6+xAgRUx4e
         WG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yP0+tXJppEoVKPFPyIZF13u7hO0z5tpvlrY6orlnmJ8=;
        b=Fp7IL+/C2FgCrsHDJPPchtZOiYFm/c1cgFWvYsv961u2PuSm5Uj7jC5wlWjdSDO1AE
         ZplJbVwD5AE5bw4bAZF+HhSrAiI3ovVQ02yK6H+kVe6nGtfoMOqqe94Yd1HBUG4ww+b1
         o7nIQUQP6aqOXPp3ueLm9/Jko5M8pDgkFXBqF/cT+QApj987CBIXE4aO4IQAP54VvFBK
         +ehDiojOZZbNL7G7rr3g9dknvbT3YLLT14us0M4EbW+ZkrydHNDQVPxTh+l6tnT5Iwyr
         ONugVQeLTfnlH54o6xwcTks8ZPmsRB6Rg5FN2cIXGrqq/NmAwmEhdrAVvJjpnKSpWSAK
         BCgg==
X-Gm-Message-State: AOAM530B1tlrjgWZbidlTHa607hJPCwajYvbSJ/yPUpa9tk9iQq0U3R5
        KmLq7ECzyHCFtxMhtBDCgwaFwXihsTs=
X-Google-Smtp-Source: ABdhPJximB+q9Luq+jysIIMqTIgqVm6o3QzfxROAMSheAI1BCcFwqZrbRm/6BK7UehcAvVjOMFGezw==
X-Received: by 2002:a19:ee16:: with SMTP id g22mr5991709lfb.513.1618654770870;
        Sat, 17 Apr 2021 03:19:30 -0700 (PDT)
Received: from [192.168.1.100] ([178.176.78.168])
        by smtp.gmail.com with ESMTPSA id v24sm1246492lfp.195.2021.04.17.03.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 03:19:30 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT
 bindings for IDT 79RC3243x SoCs
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
 <20210416085207.63181-11-tsbogend@alpha.franken.de>
 <ca4d9975-c153-94c9-dec8-bf9416c76b45@gmail.com>
 <20210416133536.GA10451@alpha.franken.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <eb85c151-cb22-9fff-13e1-3c26c8d76ab4@gmail.com>
Date:   Sat, 17 Apr 2021 13:19:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416133536.GA10451@alpha.franken.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2021 16:35, Thomas Bogendoerfer wrote:
> On Fri, Apr 16, 2021 at 12:29:46PM +0300, Sergei Shtylyov wrote:
>> On 16.04.2021 11:52, Thomas Bogendoerfer wrote:
>>
>>> Add device tree bindings for ethernet controller integrated into
>>> IDT 79RC3243x SoCs.
>>>
>>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>> ---
>>>    .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
>>>    1 file changed, 74 insertions(+)
>>>    create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
>>> new file mode 100644
>>> index 000000000000..3697af5cb66f
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
>>> @@ -0,0 +1,74 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: IDT 79rc3243x Ethernet controller
>>> +
>>> +description: Ethernet controller integrated into IDT 79RC3243x family SoCs
>>> +
>>> +maintainers:
>>> +  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>> +
>>> +allOf:
>>> +  - $ref: ethernet-controller.yaml#
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: idt,3243x-emac
>>> +
>>> +  reg:
>>> +    maxItems: 3
>>> +
>>> +  reg-names:
>>> +    items:
>>> +      - const: korina_regs
>>> +      - const: korina_dma_rx
>>> +      - const: korina_dma_tx
>>> +
>>> +  interrupts:
>>> +    items:
>>> +      - description: RX interrupt
>>> +      - description: TX interrupt
>>> +
>>> +  interrupt-names:
>>> +    items:
>>> +      - const: korina_rx
>>> +      - const: korina_tx
>>> +
>>> +  clocks:
>>> +    maxItems: 1
>>> +
>>> +  clock-names:
>>> +    items:
>>> +      - const: mdioclk
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - reg-names
>>> +  - interrupts
>>> +  - interrupt-names
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +
>>> +    ethernet@60000 {
>>> +        compatible = "idt,3243x-emac";
>>> +
>>> +        reg = <0x60000 0x10000>,
>>> +              <0x40000 0x14>,
>>> +              <0x40014 0x14>;
>>> +        reg-names = "korina_regs",
>>> +                    "korina_dma_rx",
>>> +                    "korina_dma_tx";
>>> +
>>> +        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;
>>
>>     You use this prop, yet don't describe it?
> 
> that's just interrupt-parent and interrupts in one statement. And since

    I know. :-) Yet you don't mention it, making the "interrupts" prop 
mandatory instead. And as both interrupt parents are the same here, it does 
not even seem justified...

> make dt_binding_check didn't complained I thought that's good this way.
> Rob, do I need to describe interrupts-extended as well ?
> 
> I could change that to interrupt-parent/interrupts as the driver no
> longer uses dma under/overrun interrupts, which have a different
> interrupt-parent.

    In DT, we describe the hardware,  not the driver's capabilities.

> Thomas.

MBR, Sergei

