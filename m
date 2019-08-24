Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFE19C0A8
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfHXWPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:15:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbfHXWPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 18:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZfbBYaWAiwwF9+AL5e6CGbMishbNQO6q3Oqx0DLnByY=; b=bAJ+4g+8J9jXJudOhOfXObjw8L
        /d61ZLEFR32bZxLPK2TWNVDvxbeSDWitVxd+jDT4kZ8KHZLy5q1UbuZtXYhwXJiG6YkMZaUaVqxtw
        sw2bQT+VwDZvI/psNryZJi8My+BUdPgCbS8y+L2+d9+Le2lb9GheTPwchgIwAQsUSqXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1eJb-0003xa-7I; Sun, 25 Aug 2019 00:15:19 +0200
Date:   Sun, 25 Aug 2019 00:15:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     opensource@vdorst.com, sean.wang@mediatek.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        linux-mips@vger.kernel.org, frank-w@public-files.de
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK and
 add support for port 5
Message-ID: <20190824221519.GF8251@lunn.ch>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190822.162047.1140525762795777800.davem@davemloft.net>
 <20190823010928.GK13020@lunn.ch>
 <20190824.141803.1656753287804303137.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824.141803.1656753287804303137.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

65;5402;1cOn Sat, Aug 24, 2019 at 02:18:03PM -0700, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Fri, 23 Aug 2019 03:09:28 +0200
> 
> > That would be Russell.
> > 
> > We should try to improve MAINTAINER so that Russell King gets picked
> > by the get_maintainer script.
> 
> Shoule he be added to the mt7530 entry?

Hi David

No. I think we need a phylink entry. And then make use of the K: line
format to list keywords. I hope that even though changes like this
don't touch any files listed as being part of phylink, they will match
the keyword and pickup Russell.

I need to do some testing and see if this actually works.

  Andrew
