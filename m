Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB4C3B8988
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhF3UL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:11:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233899AbhF3UL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=4yuEVx93lk9AcucL1zKeMEv4pzyg/8OENPWfy0rGE/w=; b=jD
        44bXYTgzdbnsJAyVlDRV1j1qi428PJLRea/5RFa/2tC7ruHf0nv/YccQ4rsamBvjW8NyoOBFm/wOO
        w4Ywgu3q6gNKLZKZ9/c5YRnzeDwBtGd4maRjd7BqvFszv21HHcKN3rOdPE63g2jEKdIgzEkMge5gi
        pQKeadpmassAdV8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygW0-00Bh96-PI; Wed, 30 Jun 2021 22:08:56 +0200
Date:   Wed, 30 Jun 2021 22:08:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 5/6] net: dsa: mv88e6xxx: enable SerDes RX stats for
 Topaz
Message-ID: <YNzPWH+u1ma6Bh8Y@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:07PM +0200, Marek Behún wrote:
> Commit 0df952873636a ("mv88e6xxx: Add serdes Rx statistics") added
> support for RX statistics on SerDes ports for Peridot.
> 
> This same implementation is also valid for Topaz, but was not enabled
> at the time.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 0df952873636a ("mv88e6xxx: Add serdes Rx statistics")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
