Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79678290973
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410585AbgJPQNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:13:54 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44735 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395449AbgJPQNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:13:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id e20so2859549otj.11;
        Fri, 16 Oct 2020 09:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3S6o6pCsqlpQRPyq0YIBMbpipy60d1/GQBn4kE8sQ4E=;
        b=bcwjTgkU7XyHDcXf5/rYd9ooU7udQIvLXJsgCJk5d2HRxbq1SphsJaouJ0EvXO4I0C
         jAdbeDYzXtKM229Kku6nM2J4mOVIiB8YDk2I14A1w3KXsb69UMgvL3Y4jgiqJ0Oo0ACr
         tEfxjceyy3E6Ixu0j9L69UsWZeiV56kr1BHukZFR21aj7ADKlPqJ7a1CszWW+vAdobEY
         0uEYKyUt8gYuzul4WYqXc1k4BCYttHIVVzAX8smeULjfiI7gCKMKCAR/SmLmzsJrKvIS
         RPGnUC94jlbVTtkQ2GSn3Z6Y3F0JgrD1bE5EeNr4lYfueidrb1QSKtUVFAP0aOqNoxyg
         k+LQ==
X-Gm-Message-State: AOAM531zbHliBblQGJVp6IbUF1HQdeQVvVKW7iS8Rjw8LqpvsrHohXWv
        40DqRKeOqLvLCifHEjO73w==
X-Google-Smtp-Source: ABdhPJy31GLp3Gq3wrThbltyY2aRjfcKdZPCwOmBriiR2Jq309ootzkq3phDe7FB4aNFH2VnXhA7VA==
X-Received: by 2002:a9d:127:: with SMTP id 36mr2811371otu.73.1602864832590;
        Fri, 16 Oct 2020 09:13:52 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h4sm1233579oot.45.2020.10.16.09.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:13:52 -0700 (PDT)
Received: (nullmailer pid 1508478 invoked by uid 1000);
        Fri, 16 Oct 2020 16:13:50 -0000
Date:   Fri, 16 Oct 2020 11:13:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: can: add can-controller.yaml
Message-ID: <20201016161350.GB1504381@bogus>
References: <20201016073315.16232-1-o.rempel@pengutronix.de>
 <20201016073315.16232-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016073315.16232-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 09:33:14AM +0200, Oleksij Rempel wrote:
> For now we have only node name as common rule for all CAN controllers
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/can/can-controller.yaml         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/can-controller.yaml b/Documentation/devicetree/bindings/net/can/can-controller.yaml
> new file mode 100644
> index 000000000000..185904454a69
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/can-controller.yaml
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license new bindings please.

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can-controller.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: CAN Controller Generic Binding
> +
> +maintainers:
> +  - Marc Kleine-Budde <mkl@pengutronix.de>
> +
> +properties:
> +  $nodename:
> +    pattern: "^can(@.*)?$"

additionalProperties: true

(This is the default, but it's going to be required after rc1 so the 
meta-schema can check for it and I can stop telling people to add it (in 
the false case)).
