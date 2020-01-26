Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF748149C13
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 18:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAZRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 12:22:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgAZRWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 12:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qnIMSjcqDL2K9c3AdhE+8p9BMs9D8IoS43Vb9H7YFTo=; b=MZxVNI5xOLjAhpa6fFpqJGH8o0
        ueW06q/ejZCc/dd8vIbxTMWFqDsn6km2vcUI1BKlGhC+lCOb6xpVeDzJa8tdALeHvxfYAvnD1Zsla
        dJCjZ2lsm175sa/Hk+qge84ghOHvV9JJMPIqd2cC4YoCOgUjtqb3EOZbUBnfjOTRrR3I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivlcO-0002OO-G6; Sun, 26 Jan 2020 18:22:40 +0100
Date:   Sun, 26 Jan 2020 18:22:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aya Levin <ayal@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Message-ID: <20200126172240.GL18311@lunn.ch>
References: <20200125051039.59165-1-saeedm@mellanox.com>
 <20200125051039.59165-12-saeedm@mellanox.com>
 <20200125114037.203e63ca@cakuba>
 <20200125210550.GH18311@lunn.ch>
 <3648a1a9-8bf5-1823-03a3-61dd0431cf1e@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3648a1a9-8bf5-1823-03a3-61dd0431cf1e@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The LL-FEC  is defined in the document titled "Low Latency Reed Solomon
> Forward Error Correction", in https://25gethernet.org/

Please add this to the commit message.

Thanks
	Andrew
