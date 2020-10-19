Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C929302E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbgJSVG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:06:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732457AbgJSVG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:06:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUcMo-002YRt-LF; Mon, 19 Oct 2020 23:06:54 +0200
Date:   Mon, 19 Oct 2020 23:06:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019210654.GV139700@lunn.ch>
References: <20201019204913.467287-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019204913.467287-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 02:49:13PM -0600, Robert Hancock wrote:
> The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 81E1111 PHY
> with a modified PHY ID, and by default does not have 1000BaseX
> auto-negotiation enabled, which is not generally desirable with Linux
> networking drivers.

I could be wrong, but i thought phylink used SGMII with copper SFPs,
so that 10/100 works as well as 1G. So why is 1000BaseX an issue?
Do you have a MAC which cannot do SGMII, only 1000BaseX?

   Andrew
