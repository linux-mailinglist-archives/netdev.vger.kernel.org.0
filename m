Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E13B8981
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhF3UKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:10:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233798AbhF3UKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=+lfeVqGE/2TbjYsQifq1XfHF/xxdzMYu9uljjwCWz7A=; b=lg
        GimFgUPofpLa84+S7O3sUBniBZQdBw7ZiV2zFyxnDuOSwQeHCOLA8csFpEsQuTSqSZ6bJWsB2lYKn
        /e/jj+DDVEgYWWzRmionpHSnWcpbai1By5Bajkj/2ZfIfGfGFvlJr5QIEbQSrUPQ9aGkMy8DNTe31
        eNwtUWSJyKuMw8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygUy-00Bh81-GH; Wed, 30 Jun 2021 22:07:52 +0200
Date:   Wed, 30 Jun 2021 22:07:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 3/6] net: dsa: mv88e6xxx: enable .rmu_disable() on
 Topaz
Message-ID: <YNzPGOSvw8iqvRqs@lunn.ch>
References: <20210630174308.31831-1-kabel@kernel.org>
 <20210630174308.31831-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210630174308.31831-4-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 07:43:05PM +0200, Marek Behún wrote:
> Commit 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")
> introduced .rmu_disable() method with implementation for several models,
> but forgot to add Topaz, which can use the Peridot implementation.
> 
> Use the Peridot implementation of .rmu_disable() on Topaz.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: 9e5baf9b36367 ("net: dsa: mv88e6xxx: add RMU disable op")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
