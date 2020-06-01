Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA91EAEAF
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgFAS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbgFASAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:00:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC1CC05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:00:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9732611D69C3B;
        Mon,  1 Jun 2020 11:00:45 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:00:44 -0700 (PDT)
Message-Id: <20200601.110044.945252928135960732.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of
 cycle
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601062946.160954-1-Jason@zx2c4.com>
References: <20200601062946.160954-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:00:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon,  1 Jun 2020 00:29:45 -0600

> This is a series of 1, and the sole patch inside of it has justification
> regarding that patch itself. But I thought I'd mention in the cover
> letter that this is being sent right at the tail end of the net-next
> cycle, before you close it tomorrow afternoon, so that when net-next
> subsequently opens up, this patch has already made it to net, and we
> don't have any hassles with merges. I realize that in general this isn't
> the type of patch anyone really likes because of the merge hassle, but I
> think the timing is right for it, and WireGuard is still young enough
> that this should be still pretty easily possible.

This is going to make nearly every -stable backport not apply cleanly,
which is a severe burdon for everyone having to maintain stable trees.

I'm not applying this, sorry Jason.
