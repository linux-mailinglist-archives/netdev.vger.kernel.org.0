Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6315317E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBENNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:13:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgBENNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:13:11 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A943158E27EA;
        Wed,  5 Feb 2020 05:13:10 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:13:08 +0100 (CET)
Message-Id: <20200205.141308.466024249056448186.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us
Subject: Re: [Patch net] net_sched: fix a resource leak in
 tcindex_set_parms()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204191012.22501-1-xiyou.wangcong@gmail.com>
References: <20200204191012.22501-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:13:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue,  4 Feb 2020 11:10:12 -0800

> Jakub noticed there is a potential resource leak in
> tcindex_set_parms(): when tcindex_filter_result_init() fails
> and it jumps to 'errout1' which doesn't release the memory
> and resources allocated by tcindex_alloc_perfect_hash().
> 
> We should just jump to 'errout_alloc' which calls
> tcindex_free_perfect_hash().
> 
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
