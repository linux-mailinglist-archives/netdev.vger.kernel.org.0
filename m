Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC34166865
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgBTUeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728400AbgBTUeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 15:34:06 -0500
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74D1C206F4;
        Thu, 20 Feb 2020 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582230845;
        bh=F9tVkLvbTtnyCTkxjsPTjMJF2s7fBBIXy1nkIivydXQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Fzojo25+IjDEp2m6iOVojDJPHo1QvMn9XtQv6ZtEtVPZLqeqdjjzoSAD8FkGHAyiX
         yDkB5RlnIycJb61BjYKdmDrtqZ7RzYGm9stKn5EdX7cdiZmQI808A89TXfm+LXKyHr
         M8/7HAVdNgbGyMGxU6dZrA8Zun5Q4883PBPRq8so=
Received: by mail-qv1-f43.google.com with SMTP id ff2so25860qvb.3;
        Thu, 20 Feb 2020 12:34:05 -0800 (PST)
X-Gm-Message-State: APjAAAV5+BXWy/nZNO9dqpOksAkjRBzsxxA3M57Ke/KWF9NncR9YiJYK
        JHaM4YlqP6D8CW4DPPLZCufEhOIcBe6X7hvBIw==
X-Google-Smtp-Source: APXvYqx+4CwZ75s6qSDd9JgmGRmqpP0rAn6pOTGXJvGi2Vh8/vYAfFs5IK72nq6EJz3ucmI1RAlM48zsSDdlraHZ1YI=
X-Received: by 2002:a05:6214:11ac:: with SMTP id u12mr27585073qvv.85.1582230844675;
 Thu, 20 Feb 2020 12:34:04 -0800 (PST)
MIME-Version: 1.0
References: <1582149375-25168-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1582149375-25168-1-git-send-email-min.li.xe@renesas.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 20 Feb 2020 14:33:53 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKpXRoN6Nn7B4gRyrVwrF-J63dSjBrtDYMgmZ4wXmEnNg@mail.gmail.com>
Message-ID: <CAL_JsqKpXRoN6Nn7B4gRyrVwrF-J63dSjBrtDYMgmZ4wXmEnNg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add device tree binding for IDT
 82P33 based PTP clock
To:     min.li.xe@renesas.com
Cc:     Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 3:56 PM <min.li.xe@renesas.com> wrote:
>
> From: Min Li <min.li.xe@renesas.com>
>
> Add device tree binding doc for the PTP clock based on IDT 82P33
> Synchronization Management Unit (SMU).
>
> Changes since v1:
>  - As suggested by Rob Herring:
>    1. Drop reg description for i2c
>    2. Replace i2c@1 with i2c
>    3. Add addtionalProperties: false

You copied my typo. Should be 'additionalProperties'

'make dt_binding_check' would have caught this for you. Please run it.

With that fixed,

Reviewed-by: Rob Herring <robh@kernel.org>

>
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  .../devicetree/bindings/ptp/ptp-idt82p33.yaml      | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
>
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
> new file mode 100644
> index 0000000..25806de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-idt82p33.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ptp/ptp-idt82p33.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: IDT 82P33 PTP Clock Device Tree Bindings
> +
> +description: |
> +  IDT 82P33XXX Synchronization Management Unit (SMU) based PTP clock
> +
> +maintainers:
> +  - Min Li <min.li.xe@renesas.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - idt,82p33810
> +      - idt,82p33813
> +      - idt,82p33814
> +      - idt,82p33831
> +      - idt,82p33910
> +      - idt,82p33913
> +      - idt,82p33914
> +      - idt,82p33931
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +addtionalProperties: false
> +
> +examples:
> +  - |
> +    i2c {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        phc@51 {
> +            compatible = "idt,82p33810";
> +            reg = <0x51>;
> +        };
> +    };
> --
> 2.7.4
>
