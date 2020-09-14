Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C55E269692
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgINU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgINU2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:28:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA04C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 13:28:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9B3212778047;
        Mon, 14 Sep 2020 13:11:48 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:28:34 -0700 (PDT)
Message-Id: <20200914.132834.559855888563837718.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 00/13] mptcp: introduce support for real
 multipath xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1599854632.git.pabeni@redhat.com>
References: <cover.1599854632.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:11:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 14 Sep 2020 10:01:06 +0200

> This series enable MPTCP socket to transmit data on multiple subflows
> concurrently in a load balancing scenario.
> 
> First the receive code path is refactored to better deal with out-of-order
> data (patches 1-7). An RB-tree is introduced to queue MPTCP-level out-of-order
> data, closely resembling the TCP level OoO handling.
> 
> When data is sent on multiple subflows, the peer can easily see OoO - "future"
> data at the MPTCP level, especially if speeds, delay, or jitter are not
> symmetric.
> 
> The other major change regards the netlink PM, which is extended to allow
> creating non backup subflows in patches 9-11.
> 
> There are a few smaller additions, like the introduction of OoO related mibs,
> send buffer autotuning and better ack handling.
> 
> Finally a bunch of new self-tests is introduced. The new feature is tested
> ensuring that the B/W used by an MPTCP socket using multiple subflows matches
> the link aggregated B/W - we use low B/W virtual links, to ensure the tests
> are not CPU bounded.
> 
> v1 -> v2:
>   - fix 32 bit build breakage
>   - fix a bunch of checkpatch issues

Looks good, series applied, thanks Paolo.
