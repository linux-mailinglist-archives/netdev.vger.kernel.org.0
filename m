Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9E102CB
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfD3Wve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:51:34 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35149 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfD3Wvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 18:51:33 -0400
Received: by mail-ot1-f67.google.com with SMTP id g24so8900781otq.2;
        Tue, 30 Apr 2019 15:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3hmHPTgV/bi1eZA1TKy2C+Ms5iNmeogSof6Y1DoOt64=;
        b=ftCh8Kjiu4WSchjQKeW/SwicMc/oqBMKKJbbhnYPJ+8EZqB1YETPl9x6VPpmZwqRi3
         DPeNdCffBnPw3Wk0UZtlxyeTaJu6OX6WbwMNKR6m1j/MiFfHwJGvLhps3A2PBHDcmdrn
         dRzUxqgx2fZLHQ0crg2N/ss7MwxkNAgHOvYXloS8GuRDDMroMMFRS32UO31fhfLYzGg6
         xkZppSYQKgkZJPb1XiRcbG3nZxAc2j1pyo/Iu8dSSIsUA8mleYU0jS2A7SCDBaYI+xPQ
         F8xuJXRbDyiZUgPgAeHuD5hOWygi1fXGP3JOnepP/YTgLTVywjYmIQiyhXRFrv8/3IUT
         XMCw==
X-Gm-Message-State: APjAAAVDaYPDNwXqBwoKhIWf0kt99t10bUJQdNkLlW6jRW98icfeQPY3
        w4KvpDvz25Ds7aU2rk2waw==
X-Google-Smtp-Source: APXvYqzCvqmsBL7hdv+MANoijnliQcs7gcB/JlqgrpY74V90wibJ6XokQDyfNO5RXAHNGjOAnjvGmQ==
X-Received: by 2002:a05:6830:2106:: with SMTP id i6mr1714548otc.146.1556664691778;
        Tue, 30 Apr 2019 15:51:31 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 3sm10756189oti.45.2019.04.30.15.51.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Apr 2019 15:51:30 -0700 (PDT)
Date:   Tue, 30 Apr 2019 17:51:30 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dt-bindings: net: add qca,ar71xx.txt documentation
Message-ID: <20190430225130.GA10771@bogus>
References: <20190422064046.2822-1-o.rempel@pengutronix.de>
 <20190422064046.2822-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190422064046.2822-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 22, 2019 at 08:40:44AM +0200, Oleksij Rempel wrote:
> Add binding documentation for Atheros/QCA networking IP core used
> in many routers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/qca,ar71xx.txt    | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.txt b/Documentation/devicetree/bindings/net/qca,ar71xx.txt
> new file mode 100644
> index 000000000000..56abf224de2c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qca,ar71xx.txt
> @@ -0,0 +1,44 @@

Needs some title and info about what this h/w is.

> +Required properties:
> +- compatible:	Should be "qca,<soc>-eth". Currently support compatibles are:
> +		qca,ar7100-eth - Atheros AR7100
> +		qca,ar7240-eth - Atheros AR7240
> +		qca,ar7241-eth - Atheros AR7241
> +		qca,ar7242-eth - Atheros AR7242
> +		qca,ar9130-eth - Atheros AR9130
> +		qca,ar9330-eth - Atheros AR9330
> +		qca,ar9340-eth - Atheros AR9340
> +		qca,qca9530-eth - Qualcomm Atheros QCA9530
> +		qca,qca9550-eth - Qualcomm Atheros QCA9550
> +		qca,qca9560-eth - Qualcomm Atheros QCA9560
> +
> +- reg : Address and length of the register set for the device
> +- interrupts : Should contain eth interrupt
> +- phy-mode : See ethernet.txt file in the same directory

Is there a subset of valid modes?

> +- clocks: the clock used by the core
> +- clock-names: the names of the clock listed in the clocks property. These are
> +	"mdio".

Seems strange that's the only clock.

> +- resets: Should contain phandles to the reset signals
> +- reset-names: Should contain the names of reset signal listed in the resets
> +		property. These are "mac" and "mdio"
> +
> +Optional properties:
> +- phy-handle : phandle to the PHY device connected to this device.
> +- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
> +  Use instead of phy-handle.
> +
> +Optional subnodes:
> +- mdio : specifies the mdio bus, used as a container for phy nodes
> +  according to phy.txt in the same directory
> +
> +Example:
> +
> +ethernet@1a000000 {
> +	compatible = "qca,ar9330-eth";
> +	reg = <0x1a000000 0x200>;
> +	interrupts = <5>;
> +	resets = <&rst 13>, <&rst 23>;
> +	reset-names = "mac", "mdio";
> +	clocks = <&pll ATH79_CLK_MDIO>;
> +	clock-names = "mdio";
> +	phy-mode = "gmii";
> +};
> -- 
> 2.20.1
> 
