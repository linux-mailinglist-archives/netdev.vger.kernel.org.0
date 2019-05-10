Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338E61A2E0
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 20:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfEJSQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 14:16:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60433 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727453AbfEJSQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 14:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uFC+y3ZsLGupA5I1JlrkRkVbQ7hVyAZFCrpjLKH9AI4=; b=yOSTv0OiuyDMVvB44pRedqLQTE
        vsxq7GsXe/xTmAxMj+ywreVo9JDWPfQPaS/qbQyoQ8YneWPLk01Bb0yPnzoBeL3oyZULBirbeniJX
        Sl75FAZoWWjPl3aMZHfyq7Mf0tVm/9JEamPRcFtnw1PtoiXj4GYS1EBydlgqhurOHv4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPA4N-0004im-SX; Fri, 10 May 2019 20:16:31 +0200
Date:   Fri, 10 May 2019 20:16:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net 1/3] net: ethernet: add property "nvmem_macaddr_swap"
 to swap macaddr bytes order
Message-ID: <20190510181631.GE11588@lunn.ch>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 08:24:00AM +0000, Andy Duan wrote:
> ethernet controller driver call .of_get_mac_address() to get
> the mac address from devictree tree, if these properties are
> not present, then try to read from nvmem.
> 
> For example, read MAC address from nvmem:
> of_get_mac_address()
> 	of_get_mac_addr_nvmem()
> 		nvmem_get_mac_address()
> 
> i.MX6x/7D/8MQ/8MM platforms ethernet MAC address read from
> nvmem ocotp eFuses, but it requires to swap the six bytes
> order.
> 
> The patch add optional property "nvmem_macaddr_swap" to swap

Please use nvmem-macaddr-swap. It is very unusal to use _ in property
names.

	Andrew
