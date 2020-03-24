Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDDA919046D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCXEUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:20:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXEUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:20:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 701E71571F9CA;
        Mon, 23 Mar 2020 21:20:09 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:20:08 -0700 (PDT)
Message-Id: <20200323.212008.1786774265459415637.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netlink: check for null extack in cookie helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320234650.E3383E0FD3@unicorn.suse.cz>
References: <20200320234650.E3383E0FD3@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:20:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sat, 21 Mar 2020 00:46:50 +0100 (CET)

> Unlike NL_SET_ERR_* macros, nl_set_extack_cookie_u64() and
> nl_set_extack_cookie_u32() helpers do not check extack argument for null
> and neither do their callers, as syzbot recently discovered for
> ethnl_parse_header().
> 
> Instead of fixing the callers and leaving the trap in place, add check of
> null extack to both helpers to make them consistent with NL_SET_ERR_*
> macros.
> 
> v2: drop incorrect second Fixes tag
> 
> Fixes: 2363d73a2f3e ("ethtool: reject unrecognized request flags")
> Reported-by: syzbot+258a9089477493cea67b@syzkaller.appspotmail.com
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks Michal.
