Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA541CCBED
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 17:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgEJPQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 11:16:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:37696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgEJPQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 11:16:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 97708AC52;
        Sun, 10 May 2020 15:16:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 55BA4602CA; Sun, 10 May 2020 17:16:56 +0200 (CEST)
Date:   Sun, 10 May 2020 17:16:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 07/10] net: ethtool: Add helpers for
 reporting test results
Message-ID: <20200510151656.GJ30711@lion.mk-sys.cz>
References: <20200509162851.362346-1-andrew@lunn.ch>
 <20200509162851.362346-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509162851.362346-8-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 06:28:48PM +0200, Andrew Lunn wrote:
> The PHY drivers can use these helpers for reporting the results. The
> results get translated into netlink attributes which are added to the
> pre-allocated skbuf.
> 
> v3:
> Poison phydev->skb
> Return -EMSGSIZE when ethnl_bcastmsg_put() fails
> Return valid error code when nla_nest_start() fails
> Use u8 for results
> Actually put u32 length into message
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
