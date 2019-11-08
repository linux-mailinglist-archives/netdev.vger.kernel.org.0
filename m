Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F323EF3CA6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfKHASE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:18:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHASE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:18:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F173815385188;
        Thu,  7 Nov 2019 16:18:03 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:18:02 -0800 (PST)
Message-Id: <20191107.161802.72336779729550635.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: Remove one extra ktime_get_ns() from
 cookie_init_timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107195118.200387-1-edumazet@google.com>
References: <20191107195118.200387-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:18:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 11:51:18 -0800

> tcp_make_synack() already uses tcp_clock_ns(), and can pass
> the value to cookie_init_timestamp() to avoid another call
> to ktime_get_ns() helper.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
