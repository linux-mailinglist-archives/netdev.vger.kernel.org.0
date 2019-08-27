Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1949F5CD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfH0WGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:06:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfH0WGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:06:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEF0215363ED3;
        Tue, 27 Aug 2019 15:06:48 -0700 (PDT)
Date:   Tue, 27 Aug 2019 15:06:48 -0700 (PDT)
Message-Id: <20190827.150648.431923364610590177.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, itugrok@yahoo.com, jhs@mojatatu.com,
        jiri@resnulli.us
Subject: Re: [Patch net] net_sched: fix a NULL pointer deref in ipt action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190825170132.31174-1-xiyou.wangcong@gmail.com>
References: <20190825170132.31174-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 15:06:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Sun, 25 Aug 2019 10:01:32 -0700

> The net pointer in struct xt_tgdtor_param is not explicitly
> initialized therefore is still NULL when dereferencing it.
> So we have to find a way to pass the correct net pointer to
> ipt_destroy_target().
> 
> The best way I find is just saving the net pointer inside the per
> netns struct tcf_idrinfo, which could make this patch smaller.
> 
> Fixes: 0c66dc1ea3f0 ("netfilter: conntrack: register hooks in netns when needed by ruleset")
> Reported-and-tested-by: itugrok@yahoo.com
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
