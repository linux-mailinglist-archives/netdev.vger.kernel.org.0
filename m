Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E128A852
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 22:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfHLUYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 16:24:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfHLUYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 16:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/NTZzRuh5YM7iqG3r/1tDHbzlb2JJh3pXnhOkhbOUYg=; b=3gFPkYZYsJJ9A7Ef6QMfh1EdcZ
        5f5KW990eBwIZqlrsLP+PMgroLTkOOfFcnKROaxk7ULT701obGNH7oh3e1DvivHgRU4F6xJyPpFGZ
        Wl345ZhoW1mlfY/1wh25Cqb5X1EaDGYDbQoA5p07ZF5lmWQ6LqmWIZljOCcZJMw0JhBw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxGs4-0003vQ-JM; Mon, 12 Aug 2019 22:24:48 +0200
Date:   Mon, 12 Aug 2019 22:24:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>
Subject: Re: [PATCH net] net: phy: consider AN_RESTART status when reading
 link status
Message-ID: <20190812202448.GA15047@lunn.ch>
References: <46efcf9f-0938-e017-706c-fb5a400f6fbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46efcf9f-0938-e017-706c-fb5a400f6fbb@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 09:20:02PM +0200, Heiner Kallweit wrote:
> After configuring and restarting aneg we immediately try to read the
> link status. On some systems the PHY may not yet have cleared the
> "aneg complete" and "link up" bits, resulting in a false link-up
> signal. See [0] for a report.
> Clause 22 and 45 both require the PHY to keep the AN_RESTART
> bit set until the PHY actually starts auto-negotiation.
> Let's consider this in the generic functions for reading link status.
> The commit marked as fixed is the first one where the patch applies
> cleanly.
> 
> [0] https://marc.info/?t=156518400300003&r=1&w=2
> 
> Fixes: c1164bb1a631 ("net: phy: check PMAPMD link status only in genphy_c45_read_link")
> Tested-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
