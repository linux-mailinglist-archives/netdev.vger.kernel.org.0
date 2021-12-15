Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6393E475F58
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 18:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbhLORah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 12:30:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235240AbhLOR3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 12:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IsKqA2tK3+7cyYJ4TiDcn9G0sUxGo7/dPh+Fqmbhh2U=; b=n+fIMXH2aiCaP4x9M8ednECZpm
        BzIH7qpVni+mmPDt3vtq98NUlxBrul6ZbtPwPzijFdR9zPbvbiWyNgpWrdwDIXmVC3sqfjYAck3tR
        gypZgOtONnZ5RbuIcVRNP+S6MlDTDCvad7tDA8qguoNjwg1ZOq/bpJI5SQh6f9Ps86Ek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxY5b-00Gffw-M2; Wed, 15 Dec 2021 18:29:15 +0100
Date:   Wed, 15 Dec 2021 18:29:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <Ybol6zHZQ12cViqm@lunn.ch>
References: <20211214233432.22580-1-kabel@kernel.org>
 <20211214233432.22580-3-kabel@kernel.org>
 <YbnJhI2Z3lwC3vF9@lunn.ch>
 <20211215182222.620606a0@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215182222.620606a0@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> and where (into which directory) should this serdes.yaml file go?
> 
> My idea was to put the properties into common PHY and then refer to
> them from other places, so for example this would be put into ethernet
> PHY binding:
> 
>   serdes-tx-amplitude-microvolt:
>     $ref: '/schemas/phy/phy.yaml#/properties/tx-amplitude-microvolt'

I don't know much about yaml. If that works, that is fine by me. But
we should probably check with Rob this is best practice.

   Andrew
