Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53527154D26
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgBFUpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:45:40 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38343 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgBFUpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 15:45:39 -0500
Received: by mail-pj1-f68.google.com with SMTP id j17so494516pjz.3;
        Thu, 06 Feb 2020 12:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T1ngJTNlZxERh60vPjrLNV/Vk1r1+t/IfAuzUHqs6AE=;
        b=gxwGl/Tr463nIBcxt040C/p0Q/o+tybQ+E1tfZkmFMmqdIlosAbqLw3G9qj72KfkOB
         wo95ctoRVWkhi0BmC3wvYJk72Te615hYJfxWguGNxguNscrsY7NQmI+KKneOljTr//qz
         OfQBnrGC1AkRR5sVY751zx4vGqO8zwXhQRWbBniWpggOmEf5FegW7YtO2MFT4m24cuqs
         7+PO/GH7Chc852pDO54hh3R9YRX8XXh4Csrs3wD67ckPZ3BdVY5nHMMn6ZIb5YZZrkDB
         9fmpgE0GC0fk6AuqPvXrfN0t9D7gTCqa7mFiWDC4EE+h9+RS0Dh1iXMrYuasv4GzZ1Ni
         uXDQ==
X-Gm-Message-State: APjAAAVmaUL5YKoOZbH1tTBYnghIHLJjzPOF7KqdNao4TTLnAlFMJT35
        iXj1WHh6Aq5+CZ6ATcu10g==
X-Google-Smtp-Source: APXvYqznJpweiJKL3aDfMJ802+43g2YmmQmhHstj1DGetYn8bdZRWJosqYnLRb7RZxOqXbOSU/+waA==
X-Received: by 2002:a17:902:444:: with SMTP id 62mr5363236ple.209.1581021938443;
        Thu, 06 Feb 2020 12:45:38 -0800 (PST)
Received: from rob-hp-laptop (63-158-47-182.dia.static.qwest.net. [63.158.47.182])
        by smtp.gmail.com with ESMTPSA id a18sm271188pfl.138.2020.02.06.12.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:45:37 -0800 (PST)
Received: (nullmailer pid 8727 invoked by uid 1000);
        Thu, 06 Feb 2020 19:05:26 -0000
Date:   Thu, 6 Feb 2020 19:05:26 +0000
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        mark.rutland@arm.com, sriram.dash@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindinsg: net: can: Convert can-transceiver to
 json-schema
Message-ID: <20200206190526.GA29141@bogus>
References: <20200203150353.23903-1-benjamin.gaignard@st.com>
 <20200203150353.23903-2-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203150353.23903-2-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 03, 2020 at 04:03:52PM +0100, Benjamin Gaignard wrote:
> Convert can-transceiver property to json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  .../bindings/net/can/can-transceiver.txt           | 24 ----------------------
>  .../bindings/net/can/can-transceiver.yaml          | 23 +++++++++++++++++++++
>  2 files changed, 23 insertions(+), 24 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/can-transceiver.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.txt b/Documentation/devicetree/bindings/net/can/can-transceiver.txt
> deleted file mode 100644
> index 0011f53ff159..000000000000
> --- a/Documentation/devicetree/bindings/net/can/can-transceiver.txt
> +++ /dev/null
> @@ -1,24 +0,0 @@
> -Generic CAN transceiver Device Tree binding
> -------------------------------
> -
> -CAN transceiver typically limits the max speed in standard CAN and CAN FD
> -modes. Typically these limitations are static and the transceivers themselves
> -provide no way to detect this limitation at runtime. For this situation,
> -the "can-transceiver" node can be used.
> -
> -Required Properties:
> - max-bitrate:	a positive non 0 value that determines the max
> -		speed that CAN/CAN-FD can run. Any other value
> -		will be ignored.
> -
> -Examples:
> -
> -Based on Texas Instrument's TCAN1042HGV CAN Transceiver
> -
> -m_can0 {
> -	....
> -	can-transceiver {
> -		max-bitrate = <5000000>;
> -	};
> -	...
> -};
> diff --git a/Documentation/devicetree/bindings/net/can/can-transceiver.yaml b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
> new file mode 100644
> index 000000000000..73bb084a45a8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/can-transceiver.yaml
> @@ -0,0 +1,23 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/can-transceiver.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: CAN transceiver Bindings
> +
> +description: CAN transceiver generic properties bindings
> +
> +maintainers:
> +  - Rob Herring <robh@kernel.org>
> +
> +properties:
> +  can-transceiver:
> +    type: object

I think we want to drop this (or define $nodename) and then do:

can-transceiver:
  $ref: can-transceiver.yaml#

in the users.

> +
> +    properties:
> +      max-bitrate:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: a positive non 0 value that determines the max speed that
> +                     CAN/CAN-FD can run.
> +        minimum: 1
> -- 
> 2.15.0
> 
