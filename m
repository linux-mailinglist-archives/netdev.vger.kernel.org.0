Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8B227B5DB
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgI1T73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgI1T73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 15:59:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1728FC061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 12:59:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D9FC1452F966;
        Mon, 28 Sep 2020 12:42:41 -0700 (PDT)
Date:   Mon, 28 Sep 2020 12:59:27 -0700 (PDT)
Message-Id: <20200928.125927.837371342738793940.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, vladbu@mellanox.com, dcaratti@redhat.com,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [Patch net] net_sched: remove a redundant goto chain check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928183103.28442-1-xiyou.wangcong@gmail.com>
References: <20200928183103.28442-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 12:42:41 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 28 Sep 2020 11:31:03 -0700

> All TC actions call tcf_action_check_ctrlact() to validate
> goto chain, so this check in tcf_action_init_1() is actually
> redundant. Remove it to save troubles of leaking memory.
> 
> Fixes: e49d8c22f126 ("net_sched: defer tcf_idr_insert() in tcf_action_init_1()")
> Reported-by: Vlad Buslov <vladbu@mellanox.com>
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you.
