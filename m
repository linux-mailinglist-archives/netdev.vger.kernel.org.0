Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D5E3A151
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfFHSxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:53:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfFHSxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bJ3IyJDKlBwy+Be6tl51gFFVyZnJUpD20LLYUmdugkE=; b=vg99DXg9SKMLsvPaT08nwO7ZwS
        /sif9pb3ofFF+cCAxkiRIpPLtUzf+8Tdb/533WxIPEkd1llPm5SitL3j3XxfPbiLOT5lfc6/1Cl/3
        RBdEaGCmvUxOkbGwfktJehLElWmm0SSxbgcxEGiOLkuhIwjuCPhQoB4RAUay+C78epoI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgTC-000687-2S; Sat, 08 Jun 2019 20:53:38 +0200
Date:   Sat, 8 Jun 2019 20:53:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: sja1105: Update some comments
 about PHYLIB
Message-ID: <20190608185338.GD22700@lunn.ch>
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608130344.661-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:03:42PM +0300, Vladimir Oltean wrote:
> Since the driver is now using PHYLINK exclusively, it makes sense to
> remove all references to it and replace them with PHYLINK.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
