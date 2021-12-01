Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089F04644AB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345678AbhLAB77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:59:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345669AbhLAB76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 20:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=isYqJuMlihCuSnvWm4iCbTGnsWks1qOBMHPHEeG74ZE=; b=GKT1pIla99xOOCGYVJCYnNwamo
        HOtVXVRSQ4z/Vh/DIzgaJ68sob9V4c3UpX080NmTWzE4VFDj8BfP2AN3Dk6iwRw5KtEE5M1kCSAqh
        dU82oXLwgH4hIiyolBiy7KLl/3TJEAkC8k8iORJndAnY9C82tkEOG3V+dLpx5jU4vo5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msErJ-00FA9E-Qn; Wed, 01 Dec 2021 02:56:33 +0100
Date:   Wed, 1 Dec 2021 02:56:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        wells.lu@sunplus.com, vincent.shih@sunplus.com
Subject: Re: [PATCH net-next v3 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
Message-ID: <YabWUQdIP288U09d@lunn.ch>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-2-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638266572-5831-2-git-send-email-wellslutw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  nvmem-cells:
> +    items:
> +      - description: nvmem cell address of MAC address of 1st MAC
> +      - description: nvmem cell address of MAC address of 2nd MAC
> +
> +  nvmem-cell-names:
> +    description: names corresponding to the nvmem cells of MAC address
> +    items:
> +      - const: mac_addr0
> +      - const: mac_addr1

These are port properties, so put them in the port section.

Also, the name you should use is well defined, "mac-address".  See
nvmem_get_mac_address(). But you won't be able to use that helper
because it take dev, not an of node.

	Andrew
