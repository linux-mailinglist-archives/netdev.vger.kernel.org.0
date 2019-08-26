Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850689D2C5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbfHZPaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:30:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728965AbfHZPaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kAHW+kOmK6fLXUCF/KHfYUc9Kn2L35s8LPXMyaepik4=; b=0U2+DkrAslAEzpBZntfx8RZRQg
        7zncWf3zNv8iEHmeaFHP0vVCJ8uUYSRn9rcWhI3Ztc+rTDyaCDTbHolbMBNB9INaZplzU/ibqCCi9
        yWseC28BtqMsSSzCFPzRNX25CrMPLY8fSK5lNmxy2jN3PjY4pAB74VtQSqxcS2tSzV6Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2GwQ-0004cW-1Y; Mon, 26 Aug 2019 17:29:58 +0200
Date:   Mon, 26 Aug 2019 17:29:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 4/6] net: dsa: mv88e6xxx: simplify SERDES
 code for Topaz and Peridot
Message-ID: <20190826152958.GD2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-5-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826122109.20660-5-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:07PM +0200, Marek Behún wrote:
> By adding an additional serdes_get_lane implementation (for Topaz), we
> can merge the implementations of other SERDES functions (powering and
> IRQs). We can skip checking port numbers, since the serdes_get_lane()
> methods inform if there is no lane on a port or if the lane cannot be
> used for given cmode.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
