Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD24229F5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhJEOEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:04:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235946AbhJEOEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lk6JWB2KOp3ewiwXACvmReryVSjhtXfoVoFaRHFT30w=; b=1I4waaUYVzC6dE9DSzMJMIjfwX
        uknVZVZeHPWi4TCzm5Wv1IS30qID6nFWTox0MJfhEEWQBdsI1VT9tlMhg+Cms5O7WTZIwhTGdwE7p
        RuYj0EazVFHe9mYzGVfZUUVLlHCOt8FPA0RsPf8/340HweKC0nqSsJQTfeKflB/NtwJw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXl1U-009hb1-0Z; Tue, 05 Oct 2021 16:02:24 +0200
Date:   Tue, 5 Oct 2021 16:02:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yanfei Xu <yanfei.xu@windriver.com>,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 28/40] net: mdiobus: Fix memory leak in
 __mdiobus_register
Message-ID: <YVxa7w8JWOMPOQsp@lunn.ch>
References: <20211005135020.214291-1-sashal@kernel.org>
 <20211005135020.214291-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005135020.214291-28-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 09:50:07AM -0400, Sasha Levin wrote:
> From: Yanfei Xu <yanfei.xu@windriver.com>
> 
> [ Upstream commit ab609f25d19858513919369ff3d9a63c02cd9e2e ]
> 
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.

Hi Sasha

https://lkml.org/lkml/2021/10/4/1427

Please don't backport for any stable kernel.

	Andrew
