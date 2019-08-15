Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FA28EB99
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfHOMgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:36:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOMgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=97y3ZsRoubOjqu+htEOW1koBAJg5K7XKVQrKOa1Pnzs=; b=LmGm2pphMrn1ja1KJpIgN6nWFU
        uUJKjCjJf/n3MAiWTOPSYyGxyE4qeiniTvY17RKmYiBcoDiqgZgDrXqaMGYShDF7liRPKZuJQPQ+q
        SmqVlODqKy0CIFzBGjMGzs66FNOkxHq4T9UP1fPitv8LT6v6l+AiinEYhXzmg632mP6w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyEz0-0008Em-VI; Thu, 15 Aug 2019 14:35:58 +0200
Date:   Thu, 15 Aug 2019 14:35:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] r8169: use the generic EEE management
 functions
Message-ID: <20190815123558.GA31172@lunn.ch>
References: <4a6878bf-344e-2df5-df00-b80c7c0982d1@gmail.com>
 <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5a137b1-d9d3-070c-55a1-938d6b77bdbc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 11:47:33AM +0200, Heiner Kallweit wrote:
> Now that the Realtek PHY driver maps the vendor-specific EEE registers
> to the standard MMD registers, we can remove all special handling and
> use the generic functions phy_ethtool_get/set_eee.

Hi Heiner

I think you should also add a call the phy_init_eee()?

  Andrew
