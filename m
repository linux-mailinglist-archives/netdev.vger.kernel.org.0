Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0380C08F2
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfI0PwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 11:52:13 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40873 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfI0PwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 11:52:13 -0400
Received: by mail-oi1-f196.google.com with SMTP id k9so5594746oib.7;
        Fri, 27 Sep 2019 08:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=2JNqIZKp6GqxqA7xiR7ISWAW++PU7T0DhHZ/3EtL4cQ=;
        b=s9VnHW/sZvyPiYUEub1njioKpkZ+qK5A0l6+04mXxmiLY6turXUd/ay9FPSTM4kOPt
         tEBbbNQSO6VoifGsiKWni1gOjBFIjpD2ETEhgO/9eSbA3Rr3yjsfxXKgibps+F2rL02s
         Lfc423tOcWdRJmBHBmyYRV49F3i1T2eNNOaTxphIzzcTdkNKpr5raz4jtZ4yDevmtN8v
         jGEFPhnXYqiQwzoOfVKAKWsRPw+WFFZaKqiGujSVRtVVJFqvqsOa8rj1GSUyO+3RWZ2Z
         uXgNijGc6f2qhkTgXlUd0utJfytI/deOJEdwwok51na5r7D4GgKJ5lfo1JfAb8taw06R
         sSRQ==
X-Gm-Message-State: APjAAAWZA2IkegYg0hlWbpobzxY4VfUh3rvtqlDNVB8/7EALNf78pUmB
        BGEbNidAOMWhLd5BHRQ1Jg==
X-Google-Smtp-Source: APXvYqwUkPVaNYBNV/wwzcYD7UQU3P+NQOQwaNA+XYQu/35BFJLFbNs4+K5GY50f1cp7tE2YuyBgGw==
X-Received: by 2002:aca:6057:: with SMTP id u84mr7898632oib.29.1569599532015;
        Fri, 27 Sep 2019 08:52:12 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r26sm1692866oij.46.2019.09.27.08.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 08:52:11 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:52:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v8 2/7] nfc: pn532: Add uart phy docs and rename it
Message-ID: <20190927155209.GA6261@bogus>
References: <20190919091645.16439-1-poeschel@lemonage.de>
 <20190919091645.16439-2-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919091645.16439-2-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:16:39AM +0200, Lars Poeschel wrote:
> This adds documentation about the uart phy to the pn532 binding doc. As
> the filename "pn533-i2c.txt" is not appropriate any more, rename it to
> the more general "pn532.txt".
> This also documents the deprecation of the compatible strings ending
> with "...-i2c".
> 
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v8:
> - Update existing binding doc instead of adding a new one:
>   - Add uart phy example
>   - Add general "pn532" compatible string
>   - Deprecate "...-i2c" compatible strings
>   - Rename file to a more general filename
> - Intentionally drop Rob's Reviewed-By as I guess this rather big change
>   requires a new review
> 
> Changes in v7:
> - Accidentally lost Rob's Reviewed-By
> 
> Changes in v6:
> - Rebased the patch series on v5.3-rc5
> - Picked up Rob's Reviewed-By
> 
> Changes in v4:
> - Add documentation about reg property in case of i2c
> 
> Changes in v3:
> - seperate binding doc instead of entry in trivial-devices.txt
> 
>  .../devicetree/bindings/net/nfc/pn532.txt     | 46 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn533-i2c.txt | 29 ------------
>  2 files changed, 46 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/pn532.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn533-i2c.txt

In the future, use '-M' option (I recommend making this the default).

> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/pn532.txt b/Documentation/devicetree/bindings/net/nfc/pn532.txt
> new file mode 100644
> index 000000000000..f0591f160bee
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/pn532.txt
> @@ -0,0 +1,46 @@
> +* NXP Semiconductors PN532 NFC Controller
> +
> +Required properties:
> +- compatible: Should be
> +    - "nxp,pn532" Place a node with this inside the devicetree node of the bus
> +                  where the NFC chip is connected to.
> +                  Currently the kernel has phy bindings for uart and i2c.
> +    - "nxp,pn532-i2c" (DEPRECATED) only works for the i2c binding.
> +    - "nxp,pn533-i2c" (DEPRECATED) only works for the i2c binding.

No more pm533 support?

> +
> +Required properties if connected on i2c:
> +- clock-frequency: I²C work frequency.
> +- reg: for the I²C bus address. This is fixed at 0x24 for the PN532.
> +- interrupts: GPIO interrupt to which the chip is connected

UART attached case has no irq? I guess it could just start sending 
data...

> +
> +Optional SoC Specific Properties:
> +- pinctrl-names: Contains only one value - "default".
> +- pintctrl-0: Specifies the pin control groups used for this controller.
> +
> +Example (for ARM-based BeagleBone with PN532 on I2C2):
> +
> +&i2c2 {
> +
> +
> +	pn532: pn532@24 {

nfc@24

> +
> +		compatible = "nxp,pn532";
> +
> +		reg = <0x24>;
> +		clock-frequency = <400000>;
> +
> +		interrupt-parent = <&gpio1>;
> +		interrupts = <17 IRQ_TYPE_EDGE_FALLING>;
> +
> +	};
> +};
> +
> +Example (for PN532 connected via uart):
> +
> +uart4: serial@49042000 {
> +        compatible = "ti,omap3-uart";
> +
> +        pn532: nfc {
> +                compatible = "nxp,pn532";
> +        };
> +};
