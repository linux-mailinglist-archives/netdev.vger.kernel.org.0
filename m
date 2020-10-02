Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699F4281E6B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJBWfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:35:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFC2C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:35:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 648B011E48E28;
        Fri,  2 Oct 2020 15:18:28 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:35:15 -0700 (PDT)
Message-Id: <20201002.153515.522963285806177264.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, mptcp@lists.01.org
Subject: Re: [PATCH net] tcp: fix syn cookied MPTCP request socket leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <867cc806e4dfeb200e84b37addff2e2847f44c0e.1601635086.git.pabeni@redhat.com>
References: <867cc806e4dfeb200e84b37addff2e2847f44c0e.1601635086.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:18:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  2 Oct 2020 12:39:44 +0200

> If a syn-cookies request socket don't pass MPTCP-level
> validation done in syn_recv_sock(), we need to release
> it immediately, or it will be leaked.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/89
> Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
> Reported-and-tested-by: Geliang Tang <geliangtang@gmail.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you.
