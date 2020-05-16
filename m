Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5451E1D640F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgEPUv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgEPUv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:51:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300D4C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 13:51:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA3C119445C1;
        Sat, 16 May 2020 13:51:26 -0700 (PDT)
Date:   Sat, 16 May 2020 13:51:26 -0700 (PDT)
Message-Id: <20200516.135126.783678623237967089.davem@davemloft.net>
To:     cpaasch@apple.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net
Subject: Re: [PATCH net-next] mptcp: Use 32-bit DATA_ACK when possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514155303.14360-1-cpaasch@apple.com>
References: <20200514155303.14360-1-cpaasch@apple.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:51:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>
Date: Thu, 14 May 2020 08:53:03 -0700

> RFC8684 allows to send 32-bit DATA_ACKs as long as the peer is not
> sending 64-bit data-sequence numbers. The 64-bit DSN is only there for
> extreme scenarios when a very high throughput subflow is combined with a
> long-RTT subflow such that the high-throughput subflow wraps around the
> 32-bit sequence number space within an RTT of the high-RTT subflow.
> 
> It is thus a rare scenario and we should try to use the 32-bit DATA_ACK
> instead as long as possible. It allows to reduce the TCP-option overhead
> by 4 bytes, thus makes space for an additional SACK-block. It also makes
> tcpdumps much easier to read when the DSN and DATA_ACK are both either
> 32 or 64-bit.
> 
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

Applied, thanks.
