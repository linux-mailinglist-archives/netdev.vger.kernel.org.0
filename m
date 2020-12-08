Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192622D2045
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 02:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgLHBp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 20:45:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgLHBp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 20:45:29 -0500
Date:   Mon, 7 Dec 2020 17:44:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607391888;
        bh=SmicLbUaMpJtksPZtVtQabCTL1SRejCgPBVmW4ePtkw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LcMpgcYE+L2DOOuckfAp+Nwyd+U9fYXQcP9hepIP9nGXMiXRoZcLWJ+eMPX+9lkJ3
         HdkL4BT1sKOKiW5mDRF7qhVbUNzbHY4qdAijmV9V0Fi+0M0i2KVdiv7HWZU8FgDOMc
         HOoS0wk0IpbiI9rpMbdtbq6uMNNnq9w5sRrcnUYGdjfsLhpL1ual2x1gOveTYTLUQ/
         G2PzA6ViPFwmuEdlEAFxhWumEuHnXCn/pzIyO7bbEecFvnCrZsrL1xIaNJWupe/MAa
         dTSNIaQ33ZldIyLk4qJmDrFYItChY7hC3KpFxAZPAaGvtMl8Xm27La/PjciN9ilIcn
         HRvXxonKCMv8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, kbuild-all@lists.01.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201207174447.4c31ed7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAFSKS=OOU5jKcHVfmXEHUjd87BeNUcbhjy2z3rU9U8AGr-Q8pQ@mail.gmail.com>
References: <20201207220355.8707-3-george.mccollister@gmail.com>
        <202012080829.sTB6QzCz-lkp@intel.com>
        <CAFSKS=OOU5jKcHVfmXEHUjd87BeNUcbhjy2z3rU9U8AGr-Q8pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 18:47:19 -0600 George McCollister wrote:
> On Mon, Dec 7, 2020 at 6:40 PM kernel test robot <lkp@intel.com> wrote:
> >    drivers/net/dsa/xrs700x/xrs700x.c:511:3: error: 'const struct dsa_switch_ops' has no member named 'get_stats64'  
> 
> This patch depends on "net: dsa: add optional stats64 support" being
> merged first:
> https://lore.kernel.org/netdev/20201204145624.11713-2-o.rempel@pengutronix.de/

Please post as RFC in the future if you have dependencies. The repost
once dependencies are in the tree, so build bots can do their job.
