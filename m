Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2485C27F41A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgI3VVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730338AbgI3VVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:21:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90481C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:21:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9208A13C6ADA9;
        Wed, 30 Sep 2020 14:05:01 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:21:48 -0700 (PDT)
Message-Id: <20200930.142148.1134782126816389752.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, edumazet@google.com
Subject: Re: [PATCH net-next 0/2] tcp: exponential backoff in tcp_send_ack()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930125457.1579469-1-eric.dumazet@gmail.com>
References: <20200930125457.1579469-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:05:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Sep 2020 05:54:55 -0700

> We had outages caused by repeated skb allocation failures in tcp_send_ack()
> 
> It is time to add exponential backoff to reduce number of attempts.
> Before doing so, first patch removes icsk_ack.blocked to make
> room for a new field (icsk_ack.retry)

Series applied, thanks Eric.
