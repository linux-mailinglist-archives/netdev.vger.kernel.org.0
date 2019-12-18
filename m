Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A180125289
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfLRUC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:02:26 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39741 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRUC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:02:26 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so3922828oty.6;
        Wed, 18 Dec 2019 12:02:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lCmnk+e3mjZ7dqkfu+pk+SY2OjT2ufDgkeX0yklAEgY=;
        b=fKNE5iCH89h/KTriz6roYWScqFeWMP0oX3mw2DNxxZfORqgcYEq9cFI95/IVinrjhr
         PzCOnkryVh+gUIGS8BmdXBQdutHDTE9ByjrLPQmsD9ixD3fCC5Ia0p9pE34C/yq73I5q
         08O7e1qW5zhlRtYZh1f2YflijttlgePODcf4zSk4FYgR15UdOM5qZoS8BM7TqwPziDu3
         n/iFSt6DCggs5JYBxLJQmxLm84ab4xCfGebjW779rswqhL3dmWWwA2ADXRpBVGnzH0U/
         ZiCuBTzyMgBih/4T7JYhjnBaNNqqMqgMaa/X0t+EQNWCZ55xDSC7hMql7JbXTu1c6src
         uEzA==
X-Gm-Message-State: APjAAAWooJ8GSf97MN4BJNGfwDEnqo3Xe/t6Rm4OS0tayFHBzFlY8dgX
        uNjKRysFLDmXkXQehnw5BQ==
X-Google-Smtp-Source: APXvYqwkdmgyGQQMbO0R0qH+BwjO615U9NfrV287ftDD+CGe2pRxQUxR4bmfaRPQCxW6Ci/A/1c58g==
X-Received: by 2002:a9d:3d0a:: with SMTP id a10mr789175otc.327.1576699345228;
        Wed, 18 Dec 2019 12:02:25 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l7sm1145231oie.36.2019.12.18.12.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:02:24 -0800 (PST)
Date:   Wed, 18 Dec 2019 14:02:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 08/11] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20191218200224.GA25825@bogus>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f74e71626f6c9115ab9cf919cc8eaed10220ecb2.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 08:13:23AM -0800, Richard Cochran wrote:
> This patch add a new binding that allows non-PHY MII time stamping
> devices to find their buses.  The new documentation covers both the
> generic binding and one upcoming user.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../devicetree/bindings/ptp/ptp-ines.txt      | 35 ++++++++++++++++
>  .../devicetree/bindings/ptp/timestamper.txt   | 41 +++++++++++++++++++
>  2 files changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
>  create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-ines.txt b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
> new file mode 100644
> index 000000000000..4c242bd1ce9c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-ines.txt
> @@ -0,0 +1,35 @@
> +ZHAW InES PTP time stamping IP core
> +
> +The IP core needs two different kinds of nodes.  The control node
> +lives somewhere in the memory map and specifies the address of the
> +control registers.  There can be up to three port handles placed as
> +attributes of PHY nodes.  These associate a particular MII bus with a
> +port index within the IP core.
> +
> +Required properties of the control node:
> +
> +- compatible:		"ines,ptp-ctrl"
> +- reg:			physical address and size of the register bank
> +
> +Required format of the port handle within the PHY node:
> +
> +- timestamper:		provides control node reference and
> +			the port channel within the IP core
> +
> +Example:
> +
> +	tstamper: timestamper@60000000 {
> +		compatible = "ines,ptp-ctrl";
> +		reg = <0x60000000 0x80>;
> +	};
> +
> +	ethernet@80000000 {
> +		...
> +		mdio {
> +			...
> +			ethernet-phy@3 {
> +				...
> +				timestamper = <&tstamper 0>;
> +			};
> +		};
> +	};
> diff --git a/Documentation/devicetree/bindings/ptp/timestamper.txt b/Documentation/devicetree/bindings/ptp/timestamper.txt
> new file mode 100644
> index 000000000000..70d636350582
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/timestamper.txt
> @@ -0,0 +1,41 @@
> +Time stamps from MII bus snooping devices
> +
> +This binding supports non-PHY devices that snoop the MII bus and
> +provide time stamps.  In contrast to PHY time stamping drivers (which
> +can simply attach their interface directly to the PHY instance), stand
> +alone MII time stamping drivers use this binding to specify the
> +connection between the snooping device and a given network interface.
> +
> +Non-PHY MII time stamping drivers typically talk to the control
> +interface over another bus like I2C, SPI, UART, or via a memory mapped
> +peripheral.  This controller device is associated with one or more
> +time stamping channels, each of which snoops on a MII bus.
> +
> +The "timestamper" property lives in a phy node and links a time
> +stamping channel from the controller device to that phy's MII bus.
> +
> +Example:
> +
> +	tstamper: timestamper@10000000 {

unit-address needs a reg property.

> +		compatible = "ines,ts-ctrl";

Should be ines,ptp-ctrl?

> +	};
> +
> +	ethernet@20000000 {
> +		mdio {
> +			ethernet-phy@1 {
> +				timestamper = <&tstamper 0>;
> +			};
> +		};
> +	};
> +
> +	ethernet@30000000 {
> +		mdio {
> +			ethernet-phy@2 {
> +				timestamper = <&tstamper 1>;
> +			};
> +		};
> +	};
> +
> +In this example, time stamps from the MII bus attached to phy@1 will
> +appear on time stamp channel 0 (zero), and those from phy@2 appear on
> +channel 1.
> -- 
> 2.20.1
> 
