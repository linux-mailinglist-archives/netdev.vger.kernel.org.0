Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F6E20FDE1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgF3Ukw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgF3Ukw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:40:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4D9C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:40:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A61761277F87D;
        Tue, 30 Jun 2020 13:40:51 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:40:50 -0700 (PDT)
Message-Id: <20200630.134050.1991646116770207251.davem@davemloft.net>
To:     ysseung@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [PATCH net-next v2] tcp: call tcp_ack_tstamp() when not fully
 acked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630164933.2571340-1-ysseung@google.com>
References: <20200630164933.2571340-1-ysseung@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:40:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yousuk Seung <ysseung@google.com>
Date: Tue, 30 Jun 2020 09:49:33 -0700

> When skb is coalesced tcp_ack_tstamp() still needs to be called when not
> fully acked in tcp_clean_rtx_queue(), otherwise SCM_TSTAMP_ACK
> timestamps may never be fired. Since the original patch series had
> dependent commits, this patch fixes the issue instead of reverting by
> restoring calls to tcp_ack_tstamp() when skb is not fully acked.
> 
> Fixes: fdb7eb21ddd3 ("tcp: stamp SCM_TSTAMP_ACK later in tcp_clean_rtx_queue()")
> Signed-off-by: Yousuk Seung <ysseung@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Applied, thank you.
