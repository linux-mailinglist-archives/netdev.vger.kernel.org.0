Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0CC282779
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 01:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgJCX5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 19:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgJCX5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 19:57:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30913C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 16:57:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA32411E3E4CA;
        Sat,  3 Oct 2020 16:40:59 -0700 (PDT)
Date:   Sat, 03 Oct 2020 16:57:46 -0700 (PDT)
Message-Id: <20201003.165746.2206446768818933186.davem@davemloft.net>
To:     ycheng@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH net-next] tcp: account total lost packets properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001210518.92495-1-ycheng@google.com>
References: <20201001210518.92495-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:41:00 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Thu,  1 Oct 2020 14:05:18 -0700

> The retransmission refactoring patch
> 686989700cab ("tcp: simplify tcp_mark_skb_lost")
> does not properly update the total lost packet counter which may
> break the policer mode in BBR. This patch fixes it.
> 
> Fixes: 686989700cab ("tcp: simplify tcp_mark_skb_lost")
> Reported-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you.
