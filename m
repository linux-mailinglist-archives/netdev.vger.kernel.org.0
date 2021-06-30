Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BD03B8973
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhF3UFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:05:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhF3UFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=YbvyQILtKhBxvrREauCNK8Q00VQzzgUvHwdusdaNyJM=; b=VS
        yGBQopfDHVCUPjfY1pCUQEEL2C+qolJj2hk3D6NgsneoVJpqJKbemtzZMvpqsa0nqkTZGuFLKwmLf
        fxdy87LYrSdIzlJg9hWhFTS77WozJjU9ke11xmS8e2wh+H1NHgj1lXsI7IaRGgKT2F4WkXV7zt+rw
        IAcdGDlMo4pjhLE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygQ8-00Bh4m-NG; Wed, 30 Jun 2021 22:02:52 +0200
Date:   Wed, 30 Jun 2021 22:02:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/6] net: dsa: mv88e6xxx: enable .port_set_policy()
 on Topaz
Message-ID: <YNzN7ET4YLCPg7P5@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-2-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:03PM +0200, Marek Behún wrote:
> Commit f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
> introduced .port_set_policy() method with implementation for several
> models, but forgot to add Topaz, which can use the 6352 implementation.
> 
> Use the 6352 implementation of .port_set_policy() on Topaz.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
