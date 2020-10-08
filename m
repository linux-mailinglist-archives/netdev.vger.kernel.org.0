Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE0287AB2
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgJHRLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgJHRLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 13:11:22 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F359CC061755;
        Thu,  8 Oct 2020 10:11:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c6so3064926plr.9;
        Thu, 08 Oct 2020 10:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EOYicgUsFit2YuXUNX1feYICq5X1t9Y2Kmoz+KbAL6o=;
        b=tjwcFz3SePHRE3S/gxCFm2TPerEHRp0oLbG3dg4cFAgVdxYzRe07KWx7afl/Om+XRg
         teIXOsPQh5YNMBukrWIoxw1oT61cQ9LwViHsIF5IjWnfTkbpIA5aNhq1HCX5+DM81gas
         8BZAqEE3v2UZqtpctnUAplhp6Dx7OEpan6yZY7i0QmuT6EOYek7CosXCtUaQlH5Q3veD
         0uW44eRljrx6L0CWYrYo+D++czLp7/wy2TU+LUKBaSsI6GVKZMY7P9cGTRjf4fV7q0Jf
         1RYJbcEjVpMeIlp+TKAYatv/2hKJtbEkfhc0SmKOLlSd6HTEVCyZNgBRiKUxYaLpOzUM
         OfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EOYicgUsFit2YuXUNX1feYICq5X1t9Y2Kmoz+KbAL6o=;
        b=iOPuq5/rvfp92eKya6dmwp+SyK+bv+QpIGOiltLa5MBn2qBMlg8nFTrAdRJd9BjLk0
         hR/gzC1l8asYhX213N8pulRHhykyf0vwmNkCYM5N9J84lFS3zLYi9DxLo/YMu858wY2/
         6J6kMWKIn0yzCyTXjzs17+Sdgjd+3xaYBz6sd55BCMUXG/SweLI4dNmd0bjxwq7ODpjk
         TSau6naOUCxkC9oGRlxNPA7tL+VOIGf7Ff3IgeGpnWpyXpLkioCqMeR95VliV8tvPK1G
         VevVtE98GbeVcZ4XVmyAKkZAVhBRkHlTNsPEZAfgZTP99T0COONHOC/XiYwEdYBgTmBu
         0+yQ==
X-Gm-Message-State: AOAM532/GLc2l8DsXSabG6KqEzsn0uahbO+XdGVhLljI7lH+NYUIXJLB
        unm0KJM5uyuiPybCEXeEOkeavx1pWr3B0A==
X-Google-Smtp-Source: ABdhPJyjtFTvpt+uLlbkgEwJqL9hW2N1sOr5pXsfgEbRpb6LSNQ/1LZWGCMfXgsm58Cal8BcQ/94gg==
X-Received: by 2002:a17:902:a509:b029:d0:cb2d:f26e with SMTP id s9-20020a170902a509b02900d0cb2df26emr8370822plq.7.1602177080919;
        Thu, 08 Oct 2020 10:11:20 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gi20sm7623359pjb.28.2020.10.08.10.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 10:11:20 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201008162347.5290-1-dmurphy@ti.com>
 <20201008162347.5290-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b704d919-b665-04e7-39bf-fadd5bc35ecf@gmail.com>
Date:   Thu, 8 Oct 2020 10:11:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008162347.5290-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/2020 9:23 AM, Dan Murphy wrote:
> The DP83TD510 is a 10M single twisted pair Ethernet PHY
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>   .../devicetree/bindings/net/ti,dp83td510.yaml | 70 +++++++++++++++++++
>   1 file changed, 70 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> new file mode 100644
> index 000000000000..0f0eac77a11a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> @@ -0,0 +1,70 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2020 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83td510.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83TD510 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, RMII and
> +  RGMII interfaces.
> +
> +  Specifications about the Ethernet PHY can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83td510e.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  tx-fifo-depth:
> +    description: |
> +       Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 nibble
> +       depths. The valid nibble depths are 4, 5, 6 and 8.
> +    default: 5
> +
> +  rx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the RX internal delay
> +       for the PHY.  The internal delay for the PHY is fixed to 30ns relative
> +       to receive data.
> +
> +  tx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the TX internal delay
> +       for the PHY.  The internal delay for the PHY has a range of -4 to 4ns
> +       relative to transmit data.

Those two properties are already defined as part of 
Documentation/devicetree/bindings/net/ethernet-phy.yaml, so you can 
reference that binding, too.

> +
> +  ti,master-slave-mode:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    default: 0
> +    description: |
> +      Force the PHY to be configured to a specific mode.
> +      Force Auto Negotiation - 0
> +      Force Master mode at 1v p2p - 1
> +      Force Master mode at 2.4v p2p - 2
> +      Force Slave mode at 1v p2p - 3
> +      Force Slave mode at 2.4v p2p - 4

If you accept different values you should be indicating which values are 
supported with an enumeration.
-- 
Florian
