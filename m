Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89EE2DA61F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgLOCQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgLOCQb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:31 -0500
Date:   Mon, 14 Dec 2020 18:15:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998549;
        bh=x6Jepcwui9w7+y0mUDCKGKpZYi/QMQ3PRhwL9AvtwC0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lxlgVKFo3LFGnr+AmngcOXWBUXt4/jMvq+hzDWJ8IcFus4Mnvrk4R66NPA2ZenMFD
         46BpNWqDIsQfsAs7VRRjJP6BSqQLVi6x3WwiXZS717fwf5ObfNx3rTR1JD8iuzTu+P
         f0kYPXqYFfW8GqwzuS+z+B9VwDahcIcFnATpPb+tLuL+VTsK2GulKgLrk371V3BTRz
         8/ooZREkN+o3Ni82675TWwlsq3JU6IOMCtffybo28rO4FccImdCFDcZYIScp4j/sIA
         SioLjB/TXdB62nCHwUcOHzHrx+0X+8s3voPmSSiTjn2IsaVJrcVONJSmZ5JR9MYDMa
         wrYxVFq6S12NA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: don't set non-existing
 learn2all bit for 6220/6250
Message-ID: <20201214181548.5eaea143@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201210110645.27765-1-rasmus.villemoes@prevas.dk>
References: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
        <20201210110645.27765-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 12:06:44 +0100 Rasmus Villemoes wrote:
> The 6220 and 6250 switches do not have a learn2all bit in global1, ATU
> control register; bit 3 is reserverd.
> 
> On the switches that do have that bit, it is used to control whether
> learning frames are sent out the ports that have the message_port bit
> set. So rather than adding yet another chip method, use the existence
> of the ->port_setup_message_port method as a proxy for determining
> whether the learn2all bit exists (and should be set).
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Applied.
