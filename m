Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3D21C615
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgGKUS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgGKUS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:18:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3517BC08C5DE;
        Sat, 11 Jul 2020 13:18:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ch3so4062446pjb.5;
        Sat, 11 Jul 2020 13:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+W9lcpdbR+gbswF4mAEkwAjlZYQZEcdmRIB2Ky3Trb8=;
        b=AqDP0ZuHWk4mUmEuWDg++234B8G9w7n8pXLEcl6ZCwUmjfkfmvb6DHh04mLvxPCUI4
         PQvVBdI9Ll/YZ0DlLS5P21EIkmTZi7037EwpBm2ie9j7Lx11gqHIDyKS280iMhfP8ISp
         kWdLfAFVXi+k73KDoaCUI7AIuZ8xGlDTd07grS36YIjCCsYQU18s61vX8jjhf2UJJCPm
         BaWKkcEvd/NCZm+ujt/z+Tn0M3DlW3cAjU7jl2W0E2+NzcZgwRLc2LFij5dHebiXwM4H
         V7vm36+WyL1z3TRhYssmCCeS1t8ehSaBw+eLcLElGQbGJwpFYPbeT6N6S4tshvMAJBOG
         TYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+W9lcpdbR+gbswF4mAEkwAjlZYQZEcdmRIB2Ky3Trb8=;
        b=AOkSGQMI4mnFn0BzWivfmbnPkvqoPtzLGwnCdvSWPILFe7VjkNaYvD0sXOw1FtCAyP
         2sgexFBwQ9afCz1U3kdR+VgmzDWx7JMMvA9Uwo7oR/gPOAudD8WLpRwceinCbZiLOZ/u
         Enye4peOZqLoCiOWt8n0jQenxf4r6YzHvDcb4deOS6KkC+aFHAqWtBZkumTJBlgl7ry7
         mfgzBLWyL+odxl0MK4wZi2fPhJUGp1Xk+eOA3fmU+Nsmgs3+EKr6JggPZUnrXGx1ik7y
         E3q32a5NM7Xjelg3ko8+x54Xzrpb0LPiCHp0aNNi6uT30w82qUOPO9tKGZh/QA3SpO6w
         qRKA==
X-Gm-Message-State: AOAM530A8PYKSxH7sGBT1bLIj2Rbk/x3+ziCrxXDx973TECtIu7SZaC6
        lv7Qp+9vkTWRsi+3l4sBRG4=
X-Google-Smtp-Source: ABdhPJwJjmZXTes0CpNtictuio/y3kdHja0U879m+LcpdxXmVn886eMMdjDx4Y2jRmb6qvNU1dE3hA==
X-Received: by 2002:a17:90b:918:: with SMTP id bo24mr12695792pjb.191.1594498736693;
        Sat, 11 Jul 2020 13:18:56 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id m20sm10349179pfk.52.2020.07.11.13.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 13:18:55 -0700 (PDT)
Subject: Re: [PATCH v1 8/8] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-9-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <92b7dca3-f56d-ecb1-59c2-0981c2b99dad@gmail.com>
Date:   Sat, 11 Jul 2020 13:18:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710113611.3398-9-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../bindings/net/dsa/hellcreek.yaml           | 132 ++++++++++++++++++
>  1 file changed, 132 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> new file mode 100644
> index 000000000000..bb8ccc1762c8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> @@ -0,0 +1,132 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>

Don't you want to add yourself here as well?

> +
> +description:
> +  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
> +  the Pricision Time Protocol, Hardware Timestamping as well the Time Aware
> +  Shaper.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: hirschmann,hellcreek
> +
> +  reg:
> +    description:
> +      The physical base address and size of TSN and PTP memory base

You need to indicate how many of these cells are required.

> +
> +  reg-names:
> +    description:
> +      Names of the physical base addresses

Likewise.

> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 1

Humm, not sure about those, you do not expose a memory mapped interface
bus from this switch to another sub node.

> +
> +  leds:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^led@[0-9]+$":
> +          type: object
> +          description: Hellcreek leds
> +
> +          properties:
> +            reg:
> +              items:
> +                - enum: [0, 1]
> +              description: Led number
> +
> +            label:
> +              description: Label associated with this led
> +              $ref: /schemas/types.yaml#/definitions/string
> +
> +            default-state:
> +              items:
> +                enum: ["on", "off", "keep"]
> +              description: Default state for the led
> +              $ref: /schemas/types.yaml#/definitions/string
> +
> +          required:
> +            - reg

Can you reference an existing LED binding by any chance?
-- 
Florian
