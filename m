Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B73994A2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfHVNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:12:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbfHVNMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 09:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gb/IZAOsEOV7ianBSQU8KrlIPx1wqBUpXRqIKwL9cn8=; b=RwEg+IdINuLAY9wh8UxYTxo2n+
        xragHMM6ABQryIFcWobUV8e4bs7WwyJiDIVcOUfPiOmxGqY8wM7B/tX4yQ1L9/yM0u0YsoQXjxF4y
        ET0Mwd7tzBLu5up1Kq24os2tvl96NAYsQXa9tsh9+HEKovFLFIdtvg5y5oBNbVgdNbaY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0mtO-0003sU-8L; Thu, 22 Aug 2019 15:12:42 +0200
Date:   Thu, 22 Aug 2019 15:12:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 04/10] net: dsa: mv88e6xxx: prefix hidden
 register macro names with MV88E6XXX_
Message-ID: <20190822131242.GF13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-5-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-5-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:18AM +0200, Marek Behún wrote:
> In order to be uniform with the rest of the driver, prepend hidden
> register macro names with the MV88E6XXX_ prefix.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

For the idea of the patch:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But it could be the actual patch is different if the code moves to
port.c/.h.

    Andrew
