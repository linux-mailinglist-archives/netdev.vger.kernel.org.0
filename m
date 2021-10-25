Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47138439FB3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhJYTXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhJYTWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBAE161106;
        Mon, 25 Oct 2021 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635189602;
        bh=IUJJpnmnvWOxzorv+mqAz0Onpo40LiJ1eNiKw4CMoR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q+K3m55XnG/MYIr84i+x6x7p9WVL8Beoezc46wmQlabSO6TiPbrSLXf0h20nVgKEP
         lS91MTgiQADMuJNEzoVXGkK5l+3YMTH4Kf3q/9afii2LdLINyf0kvEdqr8KXeeD5lS
         rEApclBWyrFKmxep2ZKFw3F4DKT92euHFJBkCo69MLXM8tQYs3ldFW0Yu2y1ig9xug
         7USIyWZtqOqLcvXn0ilSXgVnvFehYk0T65t5vwLr1I0yOax5u3VYfVcYx1uKWdaxOm
         T/Wg1yJ9pAMlGcYcAqpgdlK9IMn5stR7g4Qf7Y/rhUjec7AGAUzQPmoLX33k5Ose4b
         Jw6a3XMbFMkGg==
Date:   Mon, 25 Oct 2021 12:20:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org
Subject: Re: [net-next PATCH] net: convert users of bitmap_foo() to
 linkmode_foo()
Message-ID: <20211025122000.7da7eaaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXWrBZJGof6uIQnq@lunn.ch>
References: <20211022224104.3541725-1-sean.anderson@seco.com>
        <YXWrBZJGof6uIQnq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Oct 2021 20:50:45 +0200 Andrew Lunn wrote:
> On Fri, Oct 22, 2021 at 06:41:04PM -0400, Sean Anderson wrote:
> > This converts instances of
> > 	bitmap_foo(args..., __ETHTOOL_LINK_MODE_MASK_NBITS)
> > to
> > 	linkmode_foo(args...)  
> 
> It does touch a lot of files, but it does help keep the API uniform.
> 
> > I manually fixed up some lines to prevent them from being excessively
> > long. Otherwise, this change was generated with the following semantic
> > patch:  
> 
> How many did you fix?

Strange, I thought coccinelle does pretty well on checkpatch compliance.

> > Because this touches so many files in the net tree, you may want to
> > generate a new diff using the semantic patch above when you apply this.  
> 
> If it still applies cleanly, i would just apply it.

It seems to apply but does not build (missing include in mlx4?)

> Otherwise maybe Jakub could recreate it?

