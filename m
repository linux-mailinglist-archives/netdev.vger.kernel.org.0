Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A94520BD1B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgFZXWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:22:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F595C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 16:22:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49E72127580FD;
        Fri, 26 Jun 2020 16:22:32 -0700 (PDT)
Date:   Fri, 26 Jun 2020 16:22:31 -0700 (PDT)
Message-Id: <20200626.162231.1590461076613614486.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org,
        edumazet@google.com
Subject: Re: [PATCH net-next v2 0/4] mptcp: refactor token container
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1593192442.git.pabeni@redhat.com>
References: <cover.1593192442.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 16:22:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 26 Jun 2020 19:29:58 +0200

> Currently the msk sockets are stored in a single radix tree, protected by a
> global spin_lock. This series moves to an hash table, allocated at boot time,
> with per bucker spin_lock - alike inet_hashtables, but using a different key:
> the token itself.
> 
> The above improves scalability, as write operations will have a far later chance
> to compete for lock acquisition, allows lockless lookup, and will allow
> easier msk traversing - e.g. for diag interface implementation's sake.
> 
> This also introduces trivial, related, kunit tests and move the existing in
> kernel's one to kunit.
> 
> v1 -> v2:
>  - fixed a few extra and sparse warns

Series applied, thanks Paolo.
