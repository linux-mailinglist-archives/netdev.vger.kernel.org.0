Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A02F24E6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbfKGCF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:05:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbfKGCF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 21:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jj9KSI1jFK/p0M5xA7t/pXLUI5OVBnGlX/68JSi8S8w=; b=VcO8U3Hqt+q9++/P9d7Z3L5Ooy
        qncjjXdE/JrHAEUYiq1plbaIxKKo0SGzWYMKrsVJ6l1zRYbQKFqGkdwq7SEKe58OgjS3fT4FLkbxL
        Zi0EfgFV/Oz6QzGOY04GbaW5iAtfCrLpbLt6an9mLmnfCocA8GKMHKKnqv2g2+cf0/Ds=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSXBM-0002m8-H5; Thu, 07 Nov 2019 03:05:56 +0100
Date:   Thu, 7 Nov 2019 03:05:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 6/6] net: phy: at803x: remove config_init for AR9331
Message-ID: <20191107020556.GF8978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc>
 <20191106223617.1655-7-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106223617.1655-7-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 11:36:17PM +0100, Michael Walle wrote:
> According to its datasheet, the internal PHY doesn't have debug
> registers nor MMDs. Since config_init() only configures delays and
> clocks and so on in these registers it won't be needed on this PHY.
> Remove it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
