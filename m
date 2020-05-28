Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06671E6888
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405480AbgE1RRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:17:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:50168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405353AbgE1RRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 13:17:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 067E7ABB2;
        Thu, 28 May 2020 17:17:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 32B5960347; Thu, 28 May 2020 19:17:51 +0200 (CEST)
Date:   Thu, 28 May 2020 19:17:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Andrew Lunn <andrew@lunn.ch>,
        Amit Cohen <amitc@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
Message-ID: <20200528171751.jea5p5qxmeqsstdv@lion.mk-sys.cz>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <20200527213843.GC818296@lunn.ch>
 <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <87zh9stocb.fsf@mellanox.com>
 <20200528154010.GD840827@lunn.ch>
 <87r1v4t2yn.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1v4t2yn.fsf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 06:54:24PM +0200, Petr Machata wrote:
> In another e-mail you suggested this:
> 
>     Link detected: no (cable issue)
> 
> But if the link just silently falls back to 100Mbps, there would never
> be an opportunity for phy to actually report a down reason. So there
> probably is no way for the phy layer to make use of this particular
> down reason.

Perhaps we could use more general name than "link down reason", e.g.
"extended state", and it could be reported even if the link is still up
(if there is something to report).

Michal
