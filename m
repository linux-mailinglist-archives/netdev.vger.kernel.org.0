Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A35184E7E
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgCMSUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:20:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34026 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMSUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:20:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id x3so8413955wmj.1;
        Fri, 13 Mar 2020 11:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bgr9HtYDjPQEiaomNGaCKVXY7DLMXZYNMH18vvVL9Ds=;
        b=uYEsjdwkugzHxaOzeF04EVI5V6ffzKZXDQnFoU7tKFotOIhM+YFaXVk5EnOfG6UIzR
         /01haEdF9PYSIAvo2e94ZWuZcZwMiD+6TRZSmRpCaYzmEFrLCSN/PfH+19KmGcrVOFVd
         mslfMZPtyYdDunZHS6na/d+MpQsHgNgvjljkbscJ/MnRkZs+TRrrlLBD9cEKBBYkMZkh
         DT/ypJhqqu5bafAFSeRlPQ6QKlbPqsoBDhqAZW7WVRP1KFcMdIlpESh0KxNL3IRXfSdA
         wUWKDcJMK1W5piJE71UvInTbmTRRyAlCpDMlMPLf98vyY+XjfKPf95BEIqJtp+JYXj6r
         8iZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Bgr9HtYDjPQEiaomNGaCKVXY7DLMXZYNMH18vvVL9Ds=;
        b=GwYPgA2vIl8cVPOq6Jy8p5F7axebB8NDimrlxHKNdIW3CRDfoB2G7I3CdmZ5loxn4Y
         BmHy2nCW7N6EHJwJ8R3jbgd/Yuriv9sNS3ut8QKz+W58L6h5YzqWucPXSUTaqYdXVDK8
         rge6JqXASQvUnmyXyNjAAPWJhq3Ebj5qP/uDJdeDiw3YzeerwHztQu0aPsse84LhgRyi
         AQvgeOtr/U74D4sSeHpmZLVUfpdi6gia6j+xFHQsrc+7+LGMqi/XwQFrsWLM2j9HyVKk
         B0iKWS682fcVn+6vcs4xnSrQoiFlau0yHgkQDZ4uQT+d573CqNjuEjo9GRNVkfalHuNF
         EJ8Q==
X-Gm-Message-State: ANhLgQ1sWbHnj/wybUeufVVt9ZpBPGlzoCeIuZMO0QDvBEcuj/YcayaE
        8FxyrY/NbFFmXxM53ogCcFy8uNf2
X-Google-Smtp-Source: ADFU+vtBpdU6k75abkZsClwB24c0qfQMb40/0bk12Hv1/Uz1+zi3bGTXEzbSbSV9QsgJQ/MPSrjzVA==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr11840274wmh.36.1584123640493;
        Fri, 13 Mar 2020 11:20:40 -0700 (PDT)
Received: from [10.230.30.195] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p8sm12154466wrw.19.2020.03.13.11.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 11:20:39 -0700 (PDT)
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch>
 <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com>
Date:   Fri, 13 Mar 2020 11:20:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2020 11:16 AM, Oleksij Rempel wrote:
> On Fri, Mar 13, 2020 at 07:10:56PM +0100, Andrew Lunn wrote:
>>>> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
>>>> new file mode 100644
>>>> index 000000000000..42be0255512b
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
>>>> @@ -0,0 +1,61 @@
>>>> +# SPDX-License-Identifier: GPL-2.0+
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>>> +
>>>> +title: NXP TJA11xx PHY
>>>> +
>>>> +maintainers:
>>>> +  - Andrew Lunn <andrew@lunn.ch>
>>>> +  - Florian Fainelli <f.fainelli@gmail.com>
>>>> +  - Heiner Kallweit <hkallweit1@gmail.com>
>>>> +
>>>> +description:
>>>> +  Bindings for NXP TJA11xx automotive PHYs
>>>> +
>>>> +allOf:
>>>> +  - $ref: ethernet-phy.yaml#
>>>> +
>>>> +patternProperties:
>>>> +  "^ethernet-phy@[0-9a-f]+$":
>>>> +    type: object
>>>> +    description: |
>>>> +      Some packages have multiple PHYs. Secondary PHY should be defines as
>>>> +      subnode of the first (parent) PHY.
>>>
>>>
>>> There are QSGMII PHYs which have 4 PHYs embedded and AFAICT they are
>>> defined as 4 separate Ethernet PHY nodes and this would not be quite a
>>> big stretch to represent them that way compared to how they are.
>>>
>>> I would recommend doing the same thing and not bend the MDIO framework
>>> to support the registration of "nested" Ethernet PHY nodes.
>>
>> Hi Florian
>>
>> The issue here is the missing PHY ID in the secondary PHY. Because of
>> that, the secondary does not probe in the normal way. We need the
>> primary to be involved to some degree. It needs to register it. What
>> i'm not so clear on is if it just needs to register it, or if these
>> sub nodes are actually needed, given the current code.
> 
> There are a bit more dependencies:
> - PHY0 is responsible for health monitoring. If some thing wrong, it may
>   shut down complete chip.
> - We have shared reset. It make no sense to probe PHY1 before PHY0 with
>   more controlling options will be probed
> - It is possible bat dangerous to use PHY1 without PHY0.

probing is a software problem though. If we want to describe the PHY
package more correctly, we should be using a container node, something
like this maybe:

phy-package {
	compatible = "nxp,tja1102";

	ethernet-phy@4 {
		reg = <4>;
	};

	ethernet-phy@5 {
		reg = <5>;
	};
};
-- 
Florian
