Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC94FE5464
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfJYTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:32:31 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33701 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJYTca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:32:30 -0400
Received: by mail-oi1-f194.google.com with SMTP id a15so2377864oic.0;
        Fri, 25 Oct 2019 12:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mXGKxFl6d9Tad1bXOR5KQzZcHvU397AW0AArFi6DfxM=;
        b=WVEnLj2o706lId/1UETsUawHM2H2f2qjEep5xS/nnW9Y++hm4UBhVxl993EH9EbfF/
         K7zV14M4qUT8YappXTAE0RR/90F2hVWrv8IHBzb+DjXgLy3Nd3/vcVQjMVWSzixcPQ77
         pRZQRiVLyPI92lFGlArtThV9DkiG38Jrb1RRRXGpYWmTdJ5AwFsAEtY+SGcyRRppKcai
         CXCjchzj5pEnbvoAQDw0WWt2O3McJr6kJZVfDSmoVm+Q4YzuHaJoojLTMvV4xZtn36Qd
         xN9ASpHsyopqsG2c1A5DyOVBsuyhfNTswGPLu6FU4Jljti5gV7X+eCXgailG7N4VYAre
         4gGA==
X-Gm-Message-State: APjAAAWv6XCa2hmZSTA3KxPlvsi5b8B0D8bMYkiUw8Z67zgWQ2zcEFz4
        mIh/XOu3uOsj+0z6G5VP6O/i38s=
X-Google-Smtp-Source: APXvYqz471H2Ocr7A2/odSeE1SFq90vFIedMYY4Lihx8KArdbgC7Ngmc9bPTrZmbPIh8cFpnZHPH3w==
X-Received: by 2002:aca:b841:: with SMTP id i62mr4248024oif.123.1572031949663;
        Fri, 25 Oct 2019 12:32:29 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t18sm990562otm.8.2019.10.25.12.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 12:32:29 -0700 (PDT)
Date:   Fri, 25 Oct 2019 14:32:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     vincent.cheng.xh@renesas.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, mark.rutland@arm.com,
        richardcochran@gmail.com
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Message-ID: <20191025193228.GA31398@bogus>
References: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 03:57:47PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add device tree binding doc for the IDT ClockMatrix PTP clock.
> 
> Co-developed-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
> 
> Changes since v2:
>  - As suggested by Rob Herring:
>    1. Replace with DT schema
>    2. Remove '-ptp' from compatible string
>    3. Replace wildcard 'x' with the part numbers.
> 
> Changes since v1:
>  - No changes
> ---
>  .../devicetree/bindings/ptp/ptp-idtcm.yaml         | 63 ++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> new file mode 100644
> index 0000000..d3771e0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> @@ -0,0 +1,63 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ptp/ptp-idtcm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: IDT ClockMatrix (TM) PTP Clock Device Tree Bindings
> +
> +maintainers:
> +  - Vincent Cheng <vincent.cheng.xh@renesas.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      # For System Synchronizer
> +      - idt,8a34000
> +      - idt,8a34001
> +      - idt,8a34002
> +      - idt,8a34003
> +      - idt,8a34004
> +      - idt,8a34005
> +      - idt,8a34006
> +      - idt,8a34007
> +      - idt,8a34008
> +      - idt,8a34009
> +      # For Port Synchronizer
> +      - idt,8a34010
> +      - idt,8a34011
> +      - idt,8a34012
> +      - idt,8a34013
> +      - idt,8a34014
> +      - idt,8a34015
> +      - idt,8a34016
> +      - idt,8a34017
> +      - idt,8a34018
> +      - idt,8a34019
> +      # For Universal Frequency Translator (UFT)
> +      - idt,8a34040
> +      - idt,8a34041
> +      - idt,8a34042
> +      - idt,8a34043
> +      - idt,8a34044
> +      - idt,8a34045
> +      - idt,8a34046
> +      - idt,8a34047
> +      - idt,8a34048
> +      - idt,8a34049
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +      I2C slave address of the device.
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    phc@5b {

ptp@5b

Examples are built now and this fails:

Documentation/devicetree/bindings/ptp/ptp-idtcm.example.dts:19.15-28: 
Warning (reg_format): /example-0/phc@5b:reg: property has invalid length (4 bytes) (#address-cells == 1, #size-cells == 1)

The problem is i2c devices need to be shown under an i2c bus node.

> +          compatible = "idt,8a34000";
> +          reg = <0x5b>;
> +    };
> -- 
> 2.7.4
> 
