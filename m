Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2532CC614
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbgLBS7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgLBS7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 13:59:02 -0500
Date:   Wed, 2 Dec 2020 10:58:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606935501;
        bh=yvhG9As0ugVrlQH2ZtEwu3RCC53UGXCTlG2fbqdLak0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=E2yKYRRUWkkxGaT8q699ztt1k3rCvAQQvDvQ941y6VyUL+ZZ9MWc3a+Xd8HJ1Eo/0
         WfGKrEsWKGLDIdg5P3dI1nJDJLl6RhxchFq6NJo9C7xl8jei3gArpT+in4Hoz0chs+
         Fz++gNw2v8crpq84IgZk/Vys028Ta1KOZ9f3Ga9C58qxftDzeVfpBcIZ3sH8y3gc1p
         47Gikj1qcdUObs6cbu5DzGWgZq+0DOgAy6XknPFd5of4l6Z0cl7Pqg4gNHC8SkTCUw
         cwwD1gTtXFMulTvTlaa4WBKtCYMWSPjkfBO+w7rA5g/jRdu+d5PwltvlAR5O006xaz
         Wu8D7+hgDGEfg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201202105820.4de653a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com>
        <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 10:13:54 +0100 Tobias Waldekranz wrote:
> Monitor the following events and notify the driver when:
> 
> - A DSA port joins/leaves a LAG.
> - A LAG, made up of DSA ports, joins/leaves a bridge.
> - A DSA port in a LAG is enabled/disabled (enabled meaning
>   "distributing" in 802.3ad LACP terms).
> 
> Each LAG interface to which a DSA port is attached is represented by a
> `struct dsa_lag` which is globally reachable from the switch tree and
> from each associated port.
> 
> When a LAG joins a bridge, the DSA subsystem will treat that as each
> individual port joining the bridge. The driver may look at the port's
> LAG pointer to see if it is associated with any LAG, if that is
> required. This is analogue to how switchdev events are replicated out
> to all lower devices when reaching e.g. a LAG.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Any idea where this is coming from?

net/dsa/slave.c: note: in included file:
net/dsa/dsa_priv.h:194:31: error: incompatible types in comparison expression (different address spaces):
net/dsa/dsa_priv.h:194:31:    struct net_device [noderef] __rcu *
net/dsa/dsa_priv.h:194:31:    struct net_device *
