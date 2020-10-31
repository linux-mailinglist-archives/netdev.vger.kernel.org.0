Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E082A123C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJaA5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaA5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:57:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B21206CB;
        Sat, 31 Oct 2020 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604105833;
        bh=986U1WT2eTEVzODFd0gdq4cGAXDe6PZrM3EnpbUmszc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yq2MLhjsts1DAWWm3hf2WQg+dUHPEb5Dn8Oijl9B5NkTlRoG/GeamZW9uF+Gl4GnT
         x8sJUCxB9lztjXA0DUZcLQvEV9YY7WGqIdetGcAHwdGAo5AlRAG3c0egovRSbDe6St
         AoRf5XJ1bmPQ8zj0JIjIvxAXNdf0mA+65iMkve8g=
Date:   Fri, 30 Oct 2020 17:57:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jiri@mellanox.com, idosch@idosch.org
Subject: Re: [PATCH v4 net-next] net: bridge: mcast: add support for raw L2
 multicast groups
Message-ID: <20201030175712.6431ac84@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028233831.610076-1-vladimir.oltean@nxp.com>
References: <20201028233831.610076-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 01:38:31 +0200 Vladimir Oltean wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Extend the bridge multicast control and data path to configure routes
> for L2 (non-IP) multicast groups.
> 
> The uapi struct br_mdb_entry union u is extended with another variant,
> mac_addr, which does not change the structure size, and which is valid
> when the proto field is zero.
> 
> To be compatible with the forwarding code that is already in place,
> which acts as an IGMP/MLD snooping bridge with querier capabilities, we
> need to declare that for L2 MDB entries (for which there exists no such
> thing as IGMP/MLD snooping/querying), that there is always a querier.
> Otherwise, these entries would be flooded to all bridge ports and not
> just to those that are members of the L2 multicast group.
> 
> Needless to say, only permanent L2 multicast groups can be installed on
> a bridge port.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
