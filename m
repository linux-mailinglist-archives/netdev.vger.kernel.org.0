Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0A45DCCB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351170AbhKYPE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:04:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245692AbhKYPC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gqwm+WwSBdhNa5k1gRBsMXc4iKnVFzc7Y348LHychwQ=; b=l6DFNbzi1OgF0eyyCHA2Jl+BT+
        Dj7hzZY7cIQOmtRjSAzCRNCrAo/MVLjkP25Gd9/mArpepnceU8KbAHpbB/Y9BUM1qlgUeb9wbexPv
        jdnn5BgA+4Cil8bCyFQ4917ejNf+yvsbX6iP1gBd+zN7zj/F7vc5hANWlwY+Z3KxrbEE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqGDO-00EcOp-PF; Thu, 25 Nov 2021 15:59:10 +0100
Date:   Thu, 25 Nov 2021 15:59:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: lan966x: add port module support
Message-ID: <YZ+kvpCmWomKNr9l@lunn.ch>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
 <20211123135517.4037557-4-horatiu.vultur@microchip.com>
 <YZ59hpDWjNjvx5kP@lunn.ch>
 <20211125092638.7b2u75zdv2ulekmo@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125092638.7b2u75zdv2ulekmo@soft-dev3-1.localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If I undestood you correctly I have tried to do the following:
> 
> struct lan966x_ifh {
>     __be32 timestamp;
>     __be32 bypass : 1;
>     __be32 port : 3;
>     ...
> };
> 
> But then I start to get errors from sparse:
> 
> error: invalid bitfield specifier for type restricted __be32.

Maybe look at struct iphdr. It has bitfields for the header length and
the IP version.

    Andrew
