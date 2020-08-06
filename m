Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364A223DC93
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgHFQxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:53:50 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44898 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729352AbgHFQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:53:48 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so30458443qtp.11;
        Thu, 06 Aug 2020 09:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SgCMlkNPygbvmU3HrFba/PxFp5hi1G153yx66x79hj0=;
        b=HroBpKqx6ctcuV9YTTXncCgaO4RMC+jUUvb3ClR+fLkKyM1HtydHkoItAgNbPIJte9
         VEP3+8bgdRRxUlDNOXy72q7DhFzlhDU3WhsK+iit7K0mdgeLt2hU9Km7I3cqhoCXN+eZ
         FQM+gKYVBACgLgwA5JJcVp7hQgC7jXa3fXcztIg/otfJDL+UfOuFw+b90XFjeEEt0fGw
         5NT1yETrUfJ6jXcAPR7m5XJSWVo6eZ6yO2EPwnzrC0Qot/4P5wz5G9JDt64lbC8RV2oQ
         xBiH4AwV95oWyl1/5/zjG6NqhIrsWrwAghCDdpmTEw8D3CHQDh8IptRC0veCkLo1TM8s
         Z3Cg==
X-Gm-Message-State: AOAM5311svnm+AQltet0wHOEjArVA5UUN3MdbXF6xC6pURY1aGUPNXt1
        gcqcU3SVp65vuEfQ0lrU6CvYnBs=
X-Google-Smtp-Source: ABdhPJzPkEr9rf/8BLhAY46DOssPh7LKZIJw6TequaQtxXBjF1VpMWpsZbUoIIIX/G8kSI9FFjY1+w==
X-Received: by 2002:a05:6638:419:: with SMTP id q25mr12491976jap.85.1596725027758;
        Thu, 06 Aug 2020 07:43:47 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id m13sm2133599iov.35.2020.08.06.07.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:43:47 -0700 (PDT)
Received: (nullmailer pid 829322 invoked by uid 1000);
        Thu, 06 Aug 2020 14:43:45 -0000
Date:   Thu, 6 Aug 2020 08:43:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     pisa@cmp.felk.cvut.cz
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net, wg@grandegger.com,
        davem@davemloft.net, mark.rutland@arm.com, c.emde@osadl.org,
        armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com
Subject: Re: [PATCH v4 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
Message-ID: <20200806144345.GA822372@bogus>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
 <701442883f2b439637ff84544745725bdee7bcf8.1596408856.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <701442883f2b439637ff84544745725bdee7bcf8.1596408856.git.pisa@cmp.felk.cvut.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 08:34:50PM +0200, pisa@cmp.felk.cvut.cz wrote:
> From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> 
> The device-tree bindings for open-source CAN FD IP core
> which design started at Department of Measurement
> at Faculty of Electrical Engineering
> of Czech Technical University in Prague.
> The IP core main author is Ondrej Ille who continues
> on the core development even after finishing the studies.
> 
> The CTU CAN FD IP core main repository
> 
>   https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core
> 
> The list of related CAN bus projects which we participate in
> 
>    http://canbus.pages.fel.cvut.cz/
> 
> The commit text again to make checkpatch happy.
> 
> Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> ---
>  .../devicetree/bindings/net/can/ctu,ctucanfd.yaml  | 70 ++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> new file mode 100644
> index 000000000000..b74bfc951062
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> @@ -0,0 +1,70 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/ctu,ctucanfd.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: CTU CAN FD Open-source IP Core Device Tree Bindings
> +
> +description: |
> +  Open-source CAN FD IP core developed at the Czech Technical University in Prague
> +
> +  The core sources and documentation on project page
> +    [1] sources : https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core
> +    [2] datasheet : https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf
> +
> +  Integration in Xilinx Zynq SoC based system together with
> +  OpenCores SJA1000 compatible controllers
> +    [3] project : https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top
> +  Martin Jerabek dimploma thesis with integration and testing
> +  framework description
> +    [4] PDF : https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf
> +
> +maintainers:
> +  - Pavel Pisa <pisa@cmp.felk.cvut.cz>
> +  - Ondrej Ille <ondrej.ille@gmail.com>
> +  - Martin Jerabek <martin.jerabek01@gmail.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - const: ctu,ctucanfd
> +          - const: ctu,canfd-2

The order is supposed to be be most specific compatible first, but this 
seems backwards given 'ctu,ctucanfd' alone is allowed.

> +      - const: ctu,ctucanfd
> +
> +  reg:
> +    description:
> +      mapping into bus address space, offset and size

No need to describe common properties unless you have something specific 
to this device to say.

> +    maxItems: 1
> +
> +  interrupts:
> +    description: |
> +      interrupt source. For Zynq SoC system, format is <(is_spi) (number) (type)>
> +      where is_spi defines if it is SPI (shared peripheral) interrupt,
> +      the second number is translated to the vector by addition of 32
> +      on Zynq-7000 systems and type is IRQ_TYPE_LEVEL_HIGH (4) for Zynq.

That's all outside the scope of this binding.

> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      phandle of reference clock (100 MHz is appropriate
> +      for FPGA implementation on Zynq-7000 system).
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    ctu_can_fd_0: can@43c30000 {
> +      compatible = "ctu,ctucanfd";
> +      interrupts = <0 30 4>;
> +      clocks = <&clkc 15>;
> +      reg = <0x43c30000 0x10000>;
> +    };
> -- 
> 2.11.0
> 
