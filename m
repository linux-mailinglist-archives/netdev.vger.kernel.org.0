Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACC1CE970
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgELACx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELACw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:02:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D19C061A0C;
        Mon, 11 May 2020 17:02:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E64E120ED551;
        Mon, 11 May 2020 17:02:52 -0700 (PDT)
Date:   Mon, 11 May 2020 17:02:51 -0700 (PDT)
Message-Id: <20200511.170251.223893682017560321.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHES] uaccess-related stuff in net/*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200511044328.GP23230@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 17:02:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 11 May 2020 05:43:28 +0100

> 	Assorted uaccess-related work in net/*.  First, there's
> getting rid of compat_alloc_user_space() mess in MCAST_...
> [gs]etsockopt() - no need to play with copying to/from temporary
> object on userland stack, etc., when ->compat_[sg]etsockopt()
> instances in question can easly do everything without that.
> That's the first 13 patches.  Then there's a trivial bit in
> net/batman-adv (completely unrelated to everything else) and
> finally getting the atm compat ioctls into simpler shape.
> 
> 	Please, review and comment.  Individual patches in followups,
> the entire branch (on top of current net/master) is in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #uaccess.net

I have no problems with this series:

Acked-by: David S. Miller <davem@davemloft.net>
