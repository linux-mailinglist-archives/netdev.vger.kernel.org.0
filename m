Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAFC3A152
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfFHSyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:54:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfFHSyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:54:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qmV7MbtoebyxQtBVUltX1pGQDbPfRA3fdjy12Tf4mKw=; b=TtEsShW8/OI9fwRTthUB9JKgsE
        cMJIBzoYlykh5ONDKnMaaj23BNCNsYHAL6crVwWyvv/LQwal4xYO4ErncUbQQVnc1Sw7YXM+ac8G0
        bagqzmC6IPY04PjLIT0sh13OMrKjODQymDpnPIil9lfx1a4rPc2lEqNiROHZOBELXNOY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgUN-00069P-Jp; Sat, 08 Jun 2019 20:54:51 +0200
Date:   Sat, 8 Jun 2019 20:54:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: dsa: sja1105: Export the
 sja1105_inhibit_tx function
Message-ID: <20190608185451.GE22700@lunn.ch>
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608130344.661-4-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:03:43PM +0300, Vladimir Oltean wrote:
> This will be used to stop egress traffic in .phylink_mac_link_up.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
