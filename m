Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF643A0E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfFMPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:18:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732157AbfFMNG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IsgwPL9sN8Tzvsf189EMl7OpSIVj4EHu5in7ESrYKJo=; b=npMo5QfU+sYVsM+/npPMCuSVo6
        Jvo3+QbGhOTeRNbixOUe1AqruYsPIHK7W2k9iD+lVwEhs8Yiq5RjNVLbtXGiYY1LQGYT859uML0L0
        f9CEjCDw78rAq+KW2iTLBpY8nvjKDyNKC98WBAXJS4eMtXeOgqsOXytsTy20RBZf+m70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbPQo-00031g-3V; Thu, 13 Jun 2019 15:06:18 +0200
Date:   Thu, 13 Jun 2019 15:06:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC 00/13] Ethernet PHY cable test support
Message-ID: <20190613130618.GG23695@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
 <20190613095748.GA27054@microsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613095748.GA27054@microsemi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 03:28:04PM +0530, Raju Lakkaraju wrote:
> Hi Andrew,
> 
> Look like these patches are not create from "net-next" branch.

Correct. As the cover note says, they are dependent on the work by
Michal Kubecek implementing ethtool-nl. He is currently using an older
tree, or at least he was when i forked his code.

> Can you please share branch detail where i can apply patches and check the code
> flow?

Yes, i can push out a branch, later today.

     Andrew
