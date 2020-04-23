Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD5A1B5305
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgDWDPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgDWDPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:15:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C976C03C1AA;
        Wed, 22 Apr 2020 20:15:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w2so3230122edx.4;
        Wed, 22 Apr 2020 20:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cxsx7utk7++1Wvv+Y9Ze+APMY5I4SIalD834TlR6uYg=;
        b=hh6jrlt/msqEqx/ARg0lwpjPhcrympZFisWyBBcykRn/+/HhwXcmfEoY2+YP0u47Yq
         Ud3Y5H54K6EPPJwtcLKPc24tNAHeqRBtw79NcFeUJXfMmNIitS6HiHImGzZkF8ygibOQ
         V2GzTew3BWfa7bzFp25BIGaPgse/Xfbkc9Y+5mk4GXui256E2GC0zm5BIPGEbCHyeAZQ
         eEcervtyqY2rOVsu3sJ8edjDHO18QZQR4XO4yQsPpsdgQKJQD5Vkcg4AO8SSjJ14ic/X
         K6i9uNeSfc/lxEUKDn50xsur7nXLQD4ty1bushKSMAv67GBHldpaCbEk7n4O6Ttzreux
         7y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cxsx7utk7++1Wvv+Y9Ze+APMY5I4SIalD834TlR6uYg=;
        b=NEnC+f0QP4H04ABCpbOzN0al4ejUyUB+dk2ID1nU9/BD+lcOMcXvZTL8X387NcCrTh
         inm3lGzhBcu5QsXySbpyAhzdKbK0o7cjsrYpSBbRYX1AELO8F8fvfJiahUp7TFe4Io3y
         1m4k+oUF8Invv4xh+t9h/DOT4naQeBWoYt5s8b542KBosAQfkJ2NHaB0uRBra2myTu+N
         uIxYGNl+Sr657voYRY5Fd2dqjNRHPT5VdVhEaDvhvmNpFWdI597YHWRwSAoEdPERQTvd
         5X2s0iLJiLdqRLowK1wpoeKipwVJ83Cwp9TNKD7Hl35bhsm57tWtEsg7KbJpozNiVmll
         XWSw==
X-Gm-Message-State: AGi0PuZYSomBCg5P4Vo2t8/Y5MEyDkEPrJ1SBtYc8QHanLlYXJxPGlBJ
        YupSvEqCV9t6apIfuOviU5Dqs/A6
X-Google-Smtp-Source: APiQypJRHUysfsJxvtHghejmUkPFpdgYm2y6xvPxt/EEgHyVePhNxUknpC3IaLtoXtO311aSaLdSOg==
X-Received: by 2002:a50:85c4:: with SMTP id q4mr1082462edh.147.1587611746367;
        Wed, 22 Apr 2020 20:15:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id dk19sm187042edb.66.2020.04.22.20.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:15:45 -0700 (PDT)
Subject: Re: [PATCH net-next v5 1/4] dt-bindings: net: phy: Add support for
 NXP TJA11xx
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
 <20200422092456.24281-2-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b47f742d-e79a-11c8-6d39-db27dced28b8@gmail.com>
Date:   Wed, 22 Apr 2020 20:15:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422092456.24281-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2020 2:24 AM, Oleksij Rempel wrote:
> Document the NXP TJA11xx PHY bindings.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>   .../devicetree/bindings/net/nxp,tja11xx.yaml  | 61 +++++++++++++++++++
>   1 file changed, 61 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> new file mode 100644
> index 0000000000000..42be0255512b3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP TJA11xx PHY
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>

I would have expected to have you listed as a maintainer of this 
binding, but fair enough.

> +
> +description:
> +  Bindings for NXP TJA11xx automotive PHYs
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +patternProperties:
> +  "^ethernet-phy@[0-9a-f]+$":
> +    type: object
> +    description: |
> +      Some packages have multiple PHYs. Secondary PHY should be defines as

should be defined as a subnode.
-- 
Florian
