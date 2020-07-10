Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2052821BC0F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGJRU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 13:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgGJRU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 13:20:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E371C08C5DC;
        Fri, 10 Jul 2020 10:20:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j18so6934759wmi.3;
        Fri, 10 Jul 2020 10:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CTslM22q0MKSA0U9PdCo6J/XkE9XpWPlnxi+J3ZRicc=;
        b=XWt7oT8e76ADIb8R9axqcNZW1uceHZe8h3iZHLbu0UIXwcwB2dTpRNNHMxGMzfSR5P
         EIOYZvE1lC0saHw2R5TUWcwdtbxpeGGQVn3EHVnsX9Ka+ETfxyEJjE8MoPF5hGp1uX8W
         fIjt0POeXvKgMUIOLpIggrD6WSdj+e88Bz3P6tZej6FW8kcz/2QFgIfIQNmxSGG1KcAk
         NIOVEMaSM0Hw5e/I0XdIfapx+J+ZTOdftnbMnrfRts61DV+SxOpFYTKmvb2PD7P000BR
         Dv9hwJOC9R7eypvYSbtNdzTPYZABCj5IWcpdG4l3BTUd/6GTihH5o1pXbrAB0hSsbN5L
         c64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CTslM22q0MKSA0U9PdCo6J/XkE9XpWPlnxi+J3ZRicc=;
        b=FvRPRWlE+hf2ERXjsZCsaiKB25zaKSZW+hbnlog/6e+EI274ur5CGQuYFaRR06gxzh
         hkAtqiIhrD6DsputBm1yvEryfRLd4vKzvEozv2cJR+TqvrE8gOy6wa2G7r5NFiZgsqB0
         LQdK5EipBeqzFoivfXQ0CH1UMffPU6UQ4mQYczUpJllHbdiSZ4+1XAHZvbbfkBKPGNDh
         O/r6kZlkEox2Sf6K4noDvnMFZsuS371Q35mwje3rArBSA/W5wf0JLllgtTNi931Clp/n
         5EvkeOTK6oChq5aeRuPnksx8KuSGLiYwK3tjsEPuv7MxaTfmQD8xSEKOwG7hDmCPkP7j
         f67Q==
X-Gm-Message-State: AOAM533khnyNeUDD0SVoU9JO4UemZeWbuUU7Nbt5h8o03NDza8zDftDv
        LhRZlqKprqowTszN6PmBNW+3obIC
X-Google-Smtp-Source: ABdhPJx8BYkkqlPmZJQpzAiXIulgV+KgjQ6Y9dHSBwMcDvJoemAJkC4uDI+C2P/VYpV4GIgdSCtM+g==
X-Received: by 2002:a1c:5982:: with SMTP id n124mr6195728wmb.77.1594401655423;
        Fri, 10 Jul 2020 10:20:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f15sm9516655wmj.44.2020.07.10.10.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 10:20:54 -0700 (PDT)
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
To:     Rob Herring <robh@kernel.org>, Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200710090618.28945-1-kurt@linutronix.de>
 <20200710090618.28945-2-kurt@linutronix.de> <20200710164500.GA2775934@bogus>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c105489-42c5-b4ba-73b6-c3a858f646a6@gmail.com>
Date:   Fri, 10 Jul 2020 10:20:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710164500.GA2775934@bogus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 9:45 AM, Rob Herring wrote:
> On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
>> For future DSA drivers it makes sense to add a generic DSA yaml binding which
>> can be used then. This was created using the properties from dsa.txt. It
>> includes the ports and the dsa,member property.
>>
>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
>>  1 file changed, 80 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> new file mode 100644
>> index 000000000000..bec257231bf8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> @@ -0,0 +1,80 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Distributed Switch Architecture Device Tree Bindings
> 
> DSA is a Linuxism, right?

Not really, it is a Marvell term that describes their proprietary
switching protocol. Since then DSA within Linux expands well beyond just
Marvell switches, so the terms have been blurred a little bit.

> 
>> +
>> +maintainers:
>> +  - Andrew Lunn <andrew@lunn.ch>
>> +  - Florian Fainelli <f.fainelli@gmail.com>
>> +  - Vivien Didelot <vivien.didelot@gmail.com>
>> +
>> +description:
>> +  Switches are true Linux devices and can be probed by any means. Once probed,
> 
> Bindings are OS independent.
> 
>> +  they register to the DSA framework, passing a node pointer. This node is
>> +  expected to fulfil the following binding, and may contain additional
>> +  properties as required by the device it is embedded within.
> 
> Describe what type of h/w should use this binding.
> 
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^switch(@.*)?$"
>> +
>> +  dsa,member:
>> +    minItems: 2
>> +    maxItems: 2
>> +    description:
>> +      A two element list indicates which DSA cluster, and position within the
>> +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
>> +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
>> +      (single device hanging off a CPU port) must not specify this property
>> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>> +
>> +  ports:
>> +    type: object
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      "^port@[0-9]+$":
> 
> As ports and port are OF graph nodes, it would be better if we 
> standardized on a different name for these. I think we've used 
> 'ethernet-port' some.

Yes we did talk about that before, however when the original DSA binding
was introduced about 7 years ago (or maybe more recently, my memory
fails me now), "ports" was chosen as the encapsulating node. We should
be accepting both ethernet-ports and ports.

> 
>> +          type: object
>> +          description: DSA switch ports
>> +
>> +          allOf:
>> +            - $ref: ../ethernet-controller.yaml#
> 
> How does this and 'ethernet' both apply?

I think the intent here was to mean that some of the properties from the
Ethernet controller such as phy-mode, phy-handle, fixed-link also apply
here since the switch port is a simplified Ethernet MAC on a number of
counts.
-- 
Florian
