Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23026235415
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgHASxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 14:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgHASxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 14:53:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E41C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 11:53:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9963C1284FF79;
        Sat,  1 Aug 2020 11:36:29 -0700 (PDT)
Date:   Sat, 01 Aug 2020 11:53:14 -0700 (PDT)
Message-Id: <20200801.115314.504388544316990261.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: fix syncookie build error on UP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200801143959.211300-1-fw@strlen.de>
References: <20200801143959.211300-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Aug 2020 11:36:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sat,  1 Aug 2020 16:39:59 +0200

> kernel test robot says:
> net/mptcp/syncookies.c: In function 'mptcp_join_cookie_init':
> include/linux/kernel.h:47:38: warning: division by zero [-Wdiv-by-zero]
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> 
> I forgot that spinock_t size is 0 on UP, so ARRAY_SIZE cannot be used.
> 
> Fixes: 9466a1ccebbe54 ("mptcp: enable JOIN requests even if cookies are in use")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
