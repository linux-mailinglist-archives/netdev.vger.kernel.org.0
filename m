Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1867723F57D
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgHHA0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgHHA0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:26:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E13C061A28
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 17:26:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BEE41276E430;
        Fri,  7 Aug 2020 17:09:56 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:26:41 -0700 (PDT)
Message-Id: <20200807.172641.1534600180926439646.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix warn at shutdown time for unaccepted
 msk sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2458c1210f1a164c615e3aa3b9613b085a6c8326.1596819537.git.pabeni@redhat.com>
References: <2458c1210f1a164c615e3aa3b9613b085a6c8326.1596819537.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:09:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  7 Aug 2020 19:03:53 +0200

> With commit b93df08ccda3 ("mptcp: explicitly track the fully
> established status"), the status of unaccepted mptcp closed in
> mptcp_sock_destruct() changes from TCP_SYN_RECV to TCP_ESTABLISHED.
> 
> As a result mptcp_sock_destruct() does not perform the proper
> cleanup and inet_sock_destruct() will later emit a warn.
> 
> Address the issue updating the condition tested in mptcp_sock_destruct().
> Also update the related comment.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/66
> Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
> Fixes: b93df08ccda3 ("mptcp: explicitly track the fully established status")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Also applied, thank you.
