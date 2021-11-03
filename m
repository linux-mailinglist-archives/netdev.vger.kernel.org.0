Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665464448F8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhKCTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:33:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhKCTdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 15:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cDxZEgsBvG6iig5CDrhw19H0EN2SLZIC0/Kvs9EyApA=; b=gmj0V+SP7kqiQv7v5WyFuUgR2i
        u2SrW66hYSLro8AtOX4Q8eBA91/DmHcrq58DDst+cyJr5hJkIYBzo6uAxrkXrChrZHQBkNjsPOqom
        uQc38i7Bzau6+1adeo4bAjPmOaSqnuDjtX3yCgtnhhDxiQv3nS7OaBlybSqsSjYIQ0fE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1miLyD-00CX8c-Dv; Wed, 03 Nov 2021 20:30:49 +0100
Date:   Wed, 3 Nov 2021 20:30:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYLjaYCQHzqBzN1l@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> config NET_VENDOR_SUNPLUS
> 	bool "Sunplus devices"
> 	default y
> 	depends on ARCH_SUNPLUS

Does it actually depend on ARCH_SUNPLUS? What do you make use of?

Ideally, you want it to also build with COMPILE_TEST, so that the
driver gets build by 0-day and all the other build bots.

> 	---help---
> 	  If you have a network (Ethernet) card belonging to this
> 	  class, say Y here.
> 
> 	  Note that the answer to this question doesn't directly
> 	  affect the kernel: saying N will just cause the configurator
> 	  to skip all the questions about Sunplus cards. If you say Y,
> 	  you will be asked for your specific card in the following
> 	  questions.
> 
> if NET_VENDOR_SUNPLUS
> 
> config SP7021_EMAC
> 	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
> 	depends on ETHERNET && SOC_SP7021

Does it actually depend on SOC_SP7021 to build?

     Andrew
