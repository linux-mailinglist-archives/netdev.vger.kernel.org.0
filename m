Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5410D8925C
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfHKPkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:40:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfHKPkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8ozBoqtYYvBTfGwvlCc0YKD6CWnEH6JBg0zCA/A1o78=; b=xX1kmb1Fza1kvfDtj+3d2dZCTr
        itkMDemvsldy/dV50rtbp8uIxtDHwNCeLk3j1Bhb8z9DdhtPpmp/2z6RVNPjhmJXcXTRdIldU9IGA
        6TRF0kiiGKxLK5qyvS6m5YYDeiW/n+ndujRYS2UPoNNfdt+x2/ljpjozVO7yVwOEgVL8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwpwv-0003vB-Fz; Sun, 11 Aug 2019 17:40:01 +0200
Date:   Sun, 11 Aug 2019 17:40:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] net: fixed_phy: set is_gigabit_capable
 member when needed
Message-ID: <20190811154001.GC14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
 <20190811150812.6780-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190811150812.6780-2-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 05:08:12PM +0200, Marek Behún wrote:
> The fixed_phy driver does not set the phydev->is_gigabit_capable member
> when the fixed_phy is gigabit capable.

Neither does any other PHY driver. It should be possible to tell if a
PHY supports 1G by looking at register values. If this does not work
for fixed_link, it means we are missing something in the emulation.
That is what we should be fixing.

Also, this change has nothing to do the lp_advertise, what you
previously said the problem was. At the moment, i don't get the
feeling you have really dug all the way down and really understand the
root causes.

     Andrew
