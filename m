Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF542A1243
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJaA72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaA71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:59:27 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091CD2087E;
        Sat, 31 Oct 2020 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604105967;
        bh=cVlkYBQn4AVUKpo9IrkEihc7Z9GmAo1XSN3I3NkOHfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W/hL/Fpon9IaclV9nSVJhHw0iiobWpti0PMBQihqHSX3+X7/iD2bkD3UGNzyQ2A93
         NFLbxqRMAW87SHo6rR1eMtEaHHvsXeUB3c0fNXpFZQh6lLeeXXOwr/zTCqBYOjOT1z
         BWHoWIbbT5XzigepQJ2RRgCQ3dBgWVnTvqZbryV0=
Date:   Fri, 30 Oct 2020 17:59:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bridge: explicitly convert between mdb
 entry state and port group flags
Message-ID: <20201030175926.5e30a1e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028234815.613226-1-vladimir.oltean@nxp.com>
References: <20201028234815.613226-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 01:48:15 +0200 Vladimir Oltean wrote:
> When creating a new multicast port group, there is implicit conversion
> between the __u8 state member of struct br_mdb_entry and the unsigned
> char flags member of struct net_bridge_port_group. This implicit
> conversion relies on the fact that MDB_PERMANENT is equal to
> MDB_PG_FLAGS_PERMANENT.
> 
> Let's be more explicit and convert the state to flags manually.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
