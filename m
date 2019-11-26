Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB210A3CC
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfKZSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:04:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKZSEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:04:02 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C88E914C1F352;
        Tue, 26 Nov 2019 10:04:01 -0800 (PST)
Date:   Tue, 26 Nov 2019 10:03:59 -0800 (PST)
Message-Id: <20191126.100359.1113194587721845602.davem@davemloft.net>
To:     john.rutherford@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix link name length check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126025255.22305-1-john.rutherford@dektech.com.au>
References: <20191126025255.22305-1-john.rutherford@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 10:04:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: john.rutherford@dektech.com.au
Date: Tue, 26 Nov 2019 13:52:55 +1100

> From: John Rutherford <john.rutherford@dektech.com.au>
> 
> In commit 4f07b80c9733 ("tipc: check msg->req data len in
> tipc_nl_compat_bearer_disable") the same patch code was copied into
> routines: tipc_nl_compat_bearer_disable(),
> tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().
> The two link routine occurrences should have been modified to check
> the maximum link name length and not bearer name length.
> 
> Fixes: 4f07b80c9733 ("tipc: check msg->reg data len in tipc_nl_compat_bearer_disable")
> Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
