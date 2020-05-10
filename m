Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1911CCBD3
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgEJPM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 11:12:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:37048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729124AbgEJPM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 11:12:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AFA29AC52;
        Sun, 10 May 2020 15:12:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4822F602CA; Sun, 10 May 2020 17:12:26 +0200 (CEST)
Date:   Sun, 10 May 2020 17:12:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v3 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200510151226.GI30711@lion.mk-sys.cz>
References: <20200509162851.362346-1-andrew@lunn.ch>
 <20200509162851.362346-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509162851.362346-7-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 06:28:47PM +0200, Andrew Lunn wrote:
> Provide infrastructure for PHY drivers to report the cable test
> results.  A netlink skb is associated to the phydev. Helpers will be
> added which can add results to this skb. Once the test has finished
> the results are sent to user space.
> 
> When netlink ethtool is not part of the kernel configuration stubs are
> provided. It is also impossible to trigger a cable test, so the error
> code returned by the alloc function is of no consequence.
> 
> v2:
> Include the status complete in the netlink notification message
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

It seems you applied the changes to ethnl_cable_test_alloc() suggested
in v2 review as part of patch 7 rather than here. I don't think it's
necessary to fix that unless there is some actual problem that would
require a resubmit.

Michal
