Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A055442274F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhJENHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:07:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhJENHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GjSw70UXArEHRQSHVBHoPAYrTU+PZTUZHzIDM8YnLPc=; b=OhpLmBSdICkgEyNuofNjis7duX
        jxlY5aNa1IpRqsEWFjqmb+61waOfeLwzsEnJF4v2beuEsdV/ngEpRtunNDcmcDwqNX+8qjWJhqx5N
        fjMfLSNN+OnsXe37Jix3RiAt+EUTQPrvf7Ek4PyPIS6+M4sGwBq/aEpwhwaUD5hgTvtE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXk8D-009h5c-9r; Tue, 05 Oct 2021 15:05:17 +0200
Date:   Tue, 5 Oct 2021 15:05:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: Re: [PATCH v1 4/4] ARM: dts: mvebu: add device tree for netgear
 gs110emx switch
Message-ID: <YVxNjc0LrYp4SXtP@lunn.ch>
References: <20211005060334.203818-1-marcel@ziswiler.com>
 <20211005060334.203818-5-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005060334.203818-5-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		mdio {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			switch0phy0: switch0phy0@1 {
> +				reg = <0x1>;
> +			};

> +
> +			port@1 {
> +				label = "lan1";
> +				phy-handle = <&switch0phy0>;
> +				reg = <1>;
> +			};

You numbering of the phy labels is a bit confusing here. Both the port
and the PHY use reg=<1>. So i would use the label

switch0phy1: switch0phy1@1 

     Andrew
