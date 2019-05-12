Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5371AA08
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 04:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfELCjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 22:39:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfELCjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 22:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t9+15b9L3WwJK64wLn97JnO9IQrrXO3ji9GV4lJbcYk=; b=GEzfP1XWEKzcNlXvLhAr7tABew
        JgsCTUuKlqa1g3XFRD7NPteZdqUsDOUtffUxer6zIOzJcL99qG+We/BUIrOQtdt6rZBxcitski6fT
        HDfBYavu1oebOhDIAR9KqgQ+l9Rtg8ZoXJdJgA1LTMvLKOrW7wUmebDd82e3ByQJkYPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPeOh-00007d-83; Sun, 12 May 2019 04:39:31 +0200
Date:   Sun, 12 May 2019 04:39:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 3/3] net: dsa: Remove the now unused
 DSA_SKB_CB_COPY() macro
Message-ID: <20190512023931.GM4889@lunn.ch>
References: <20190511201447.15662-1-olteanv@gmail.com>
 <20190511201447.15662-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190511201447.15662-4-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 11:14:47PM +0300, Vladimir Oltean wrote:
> It's best to not expose this, due to the performance hit it may cause
> when calling it.
> 
> Fixes: b68b0dd0fb2d ("net: dsa: Keep private info in the skb->cb")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
