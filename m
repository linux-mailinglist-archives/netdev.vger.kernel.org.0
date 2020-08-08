Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4CE23F57B
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgHHAZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgHHAZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:25:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD683C061A28
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 17:25:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B69B11276E430;
        Fri,  7 Aug 2020 17:09:13 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:25:58 -0700 (PDT)
Message-Id: <20200807.172558.1135066576835187335.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: more stable diag self-tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <80f1f6d16da4542e825d9aca1949d6169d77104c.1596817814.git.pabeni@redhat.com>
References: <80f1f6d16da4542e825d9aca1949d6169d77104c.1596817814.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:09:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  7 Aug 2020 18:31:00 +0200

> During diag self-tests we introduce long wait in the mptcp test
> program to give the script enough time to access the sockets
> dump.
> 
> Such wait is introduced after shutting down one sockets end. Since
> commit 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state
> machine") if both sides shutdown the socket is correctly transitioned
> into CLOSED status.
> 
> As a side effect some sockets are not dumped via the diag interface,
> because the socket state (CLOSED) does not match the default filter, and
> this cause self-tests instability.
> 
> Address the issue moving the above mentioned wait before shutting
> down the socket.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/68
> Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
> Tested-and-acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
