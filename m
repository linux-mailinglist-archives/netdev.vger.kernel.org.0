Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342ED3A150
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfFHSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:52:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfFHSww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qMZnWqTicxN8AVyHgMIo3z+fzsvo3ha8FKlvQREYTe4=; b=xsS2JaF5euS+Q3SarTY8ReyREo
        OqKn7su2K/L0qe1jlSvLB+kY80EK3nmu/Om9TgUCX4iTgR6ZCFC7R3I0nhy5ya36gexZyXuIx9T6r
        Km3YTOdwLJiG0SqCnt7cBIGxr+3y6eplZvOAB34V1wreo2BSznwb4I6jCaM2bhzO8X7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgSR-00066o-9U; Sat, 08 Jun 2019 20:52:51 +0200
Date:   Sat, 8 Jun 2019 20:52:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: dsa: sja1105: Use
 SPEED_{10,100,1000,UNKNOWN} macros
Message-ID: <20190608185251.GC22700@lunn.ch>
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608130344.661-2-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:03:41PM +0300, Vladimir Oltean wrote:
> This is a cosmetic patch that replaces the link speed numbers used in
> the driver with the corresponding ethtool macros.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
