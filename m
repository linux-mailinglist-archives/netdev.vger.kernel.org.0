Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A709EEA7C5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfJ3X2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:28:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38582 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfJ3X2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 19:28:54 -0400
Received: by mail-ed1-f65.google.com with SMTP id d23so558691edr.5;
        Wed, 30 Oct 2019 16:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+24XCwnTFDCBoW4hF1216FJ7KR0Ap2KPs77lPcv6LTI=;
        b=d01SDI/6AOYdVlceGpy7zctYdOJmVK1FfXa3bDLUAS8FdNoHRYxW3UFMLIalQSR5sE
         a6rD5APUZ7rVb+gTnk4hblmDHtK5oSZmNfN8ZPPZ01dbufK5lvNHlxcIF96inVj0Vk8b
         oyemJ+L+C3Re2hhdnyk9k66GgVMDVPzUSZRLB1dG6SvGb/uSq2mGmesHRdsvHbMmJjQj
         HB5JBa/mMeWGbAq+g5ZaNb1FN58uadZQa3jf0QArcfJ+rWzDEKfDLqBPRDoZTzs6Cagh
         JOYt2Hx36ZkAQY4CD+UyEzwfS9gXinNuV9r8/aZKqh3mKzCm8rrNdusJD3KH0d1bOeB7
         DXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+24XCwnTFDCBoW4hF1216FJ7KR0Ap2KPs77lPcv6LTI=;
        b=cWvf0Zd+WHJUYB+PULrHugvtoe6oJb4qKc/f6QrbII3YjuttFFcwsCRg7OUOM6RdtV
         /nCYXvLmRO8e+s4BNVXY6UYZEcaXeN1Ngk6U3gr5VspG31Tf+viBuUY8PJxxYc1g1aUi
         A0APF45qZDXA5Y69wIlAWxsBXWFwVyI/naLcuG/kfPhSOQeGilkA26xHqcHKu0FdUD72
         PfhLbG9qUs0K2sA98G9MW2l79UZJ7Dx6gY2uDZkHsPQuIMtO60nTPfdKo9Rfu6IZ5ygG
         DW4F0JQBgGwKaN2MGJKSqV0xnNnT/TPsX7K/borGdJ3bQCMXpjcVj3q7yGDrGUwYj1pk
         p+yg==
X-Gm-Message-State: APjAAAV35ue/NOWB1uZWHbx//ghXuBM46ZMxFowjXURMeJozl9oZISrH
        An/Nq876Kc/ARhqL74GrcSr3LDBJ
X-Google-Smtp-Source: APXvYqzBk36HYQLTGOfKAZNpxuATidha1q1v50qS12/sNZIuQCMKRUXpPIrUdtSx5cspEdW8UL/u+A==
X-Received: by 2002:a50:f096:: with SMTP id v22mr2663214edl.149.1572478131764;
        Wed, 30 Oct 2019 16:28:51 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g43sm33546edb.14.2019.10.30.16.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 16:28:51 -0700 (PDT)
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-3-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <408bb56b-efe9-21c4-0177-2d433a7c20ce@gmail.com>
Date:   Wed, 30 Oct 2019 16:28:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030224251.21578-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 3:42 PM, Michael Walle wrote:
> Document the Atheros AR803x PHY bindings.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../bindings/net/atheros,at803x.yaml          | 58 +++++++++++++++++++
>  include/dt-bindings/net/atheros-at803x.h      | 13 +++++
>  2 files changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/atheros,at803x.yaml
>  create mode 100644 include/dt-bindings/net/atheros-at803x.h
> 
> diff --git a/Documentation/devicetree/bindings/net/atheros,at803x.yaml b/Documentation/devicetree/bindings/net/atheros,at803x.yaml
> new file mode 100644
> index 000000000000..60500fd90fd8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/atheros,at803x.yaml
> @@ -0,0 +1,58 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/atheros,at803x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Atheros AR803x PHY
> +
> +maintainers:
> +  - TBD
> +
> +description: |
> +  Bindings for Atheros AR803x PHYs
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  atheros,clk-out-frequency:
> +    description: Clock output frequency in Hertz.
> +    enum: [ 25000000, 50000000, 62500000, 125000000 ]
> +
> +  atheros,clk-out-strength:
> +    description: Clock output driver strength.
> +    enum: [ 0, 1, 2 ]
> +
> +  atheros,keep-pll-enabled:
> +    description: |
> +      If set, keep the PLL enabled even if there is no link. Useful if you
> +      want to use the clock output without an ethernet link.

This is more of a policy than a hardware description. Implementing this
has a PHY tunable, possibly as a form of auto-power down

> +    type: boolean
> +
> +  atheros,rgmii-io-1v8:
> +    description: |
> +      The PHY supports RGMII I/O voltages of 2.5V, 1.8V and 1.5V. By default,
> +      the PHY uses a voltage of 1.5V. If this is set, the voltage will changed
> +      to 1.8V.

will be changed?

This looks like a possibly dangerous configuration as it really can lead
to some good damage happening on the pins if there is an incompatible
voltage on the MAC and PHY side... of course, you have no way to tell
ahead of time other than by looking at the board schematics, lovely.

Does the PHY come up in some sort of super isolatation mode by default
at least?
-- 
Florian
