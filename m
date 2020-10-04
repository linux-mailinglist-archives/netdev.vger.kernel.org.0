Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16B12827AD
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgJDAgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgJDAgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:36:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB1DC0613D0;
        Sat,  3 Oct 2020 17:36:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F0B711E3E4CB;
        Sat,  3 Oct 2020 17:20:01 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:36:48 -0700 (PDT)
Message-Id: <20201003.173648.767792137065746549.davem@davemloft.net>
To:     matthieu.baerts@tessares.net
Cc:     mathew.j.martineau@linux.intel.com, kuba@kernel.org,
        geliangtang@gmail.com, dcaratti@redhat.com, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: ADD_ADDRs with echo bit are smaller
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003153656.1224144-1-matthieu.baerts@tessares.net>
References: <20201003153656.1224144-1-matthieu.baerts@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:20:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat,  3 Oct 2020 17:36:56 +0200

> The MPTCP ADD_ADDR suboption with echo-flag=1 has no HMAC, the size is
> smaller than the one initially sent without echo-flag=1. We then need to
> use the correct size everywhere when we need this echo bit.
> 
> Before this patch, the wrong size was reserved but the correct amount of
> bytes were written (and read): the remaining bytes contained garbage.
> 
> Fixes: 6a6c05a8b016 ("mptcp: send out ADD_ADDR with echo flag")
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/95
> Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
> Acked-by: Geliang Tang <geliangtang@gmail.com>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied.
