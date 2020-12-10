Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3FF2D6983
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393975AbgLJVQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393914AbgLJVQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:16:05 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D463C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 13:15:25 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 223694D2ED6E7;
        Thu, 10 Dec 2020 13:15:25 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:15:24 -0800 (PST)
Message-Id: <20201210.131524.1199625128133217949.davem@davemloft.net>
To:     arjunroy.kdev@gmail.com
Cc:     netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next] tcp: correctly handle increased zerocopy args
 struct size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210191603.963856-1-arjunroy.kdev@gmail.com>
References: <20201210191603.963856-1-arjunroy.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:15:25 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy.kdev@gmail.com>
Date: Thu, 10 Dec 2020 11:16:03 -0800

> From: Arjun Roy <arjunroy@google.com>
> 
> A prior patch increased the size of struct tcp_zerocopy_receive
> but did not update do_tcp_getsockopt() handling to properly account
> for this.
> 
> This patch simply reintroduces content erroneously cut from the
> referenced prior patch that handles the new struct size.
> 
> Fixes: 18fb76ed5386 ("net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied.
