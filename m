Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5373B43A219
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhJYTpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236782AbhJYTlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 515AE610C8;
        Mon, 25 Oct 2021 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635190589;
        bh=lUErjuWAOOXNbGbm6mu5ozvHcVzsAR+ypXi/b/arWOE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WYGr+gTTRD8BpOrX4VkpI3k2gLuM8sPlmsAC3lQZ8cXy51Po+/qjnJQEKVtyiD99b
         6Gcfuv88Pf5aS0GQuz51BOG/Tc4XRaF3xAtgqSBx8rvLwG116ZOls8FnmYRGJD84au
         a87aXAV4Ri2SZjoRmq5Jxu2WYQmXjbUWq5QAcSAz53JZVqdeA61LCkr3FNDMoNSqPa
         yOLk8VZLWNeqaSAvsGNA4sYp9yZfmEui8G8+XCCpLWsFDC2kFZowxnymxQUbC5L/F4
         kmQR+EzZFNur3wE//53J4Uc8midhOPrcqql1JgUGiD7GiBZkm99tUFoN/t8c5d/a+p
         CUOJwHZK01QZg==
Date:   Mon, 25 Oct 2021 12:36:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org
Subject: Re: [net-next PATCH] net: convert users of bitmap_foo() to
 linkmode_foo()
Message-ID: <20211025123628.66814a20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <de2f09e8-6f3b-7d6b-03ba-770c603e2f92@seco.com>
References: <20211022224104.3541725-1-sean.anderson@seco.com>
        <YXWrBZJGof6uIQnq@lunn.ch>
        <20211025122000.7da7eaaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <de2f09e8-6f3b-7d6b-03ba-770c603e2f92@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 15:26:15 -0400 Sean Anderson wrote:
> >> How many did you fix?  
> >
> > Strange, I thought coccinelle does pretty well on checkpatch compliance.  
> 
> It does, but the problem is there is no obvious place to break
> 
> 	long_function_name(another_long_function_name(and_some_variable)))
> 
> without introducing a variable.

Makes sense now.

> >> If it still applies cleanly, i would just apply it.  
> >
> > It seems to apply but does not build (missing include in mlx4?)  
> 
> Hmm. I tried to determine if the correct headers were included, but it
> looks like there was an error there. In any case, it seems like David
> fixed it up when he applied it.

Ah, you're right! He noted:

    Add missing linux/mii.h include to mellanox. -DaveM

I thought this was not applied since it was marked as "Not applicable"
in patchwork. Let me fix that to say "Accepted".
