Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22806491F4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFQVGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:06:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFQVGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:06:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EA01151397AE;
        Mon, 17 Jun 2019 14:06:40 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:06:39 -0700 (PDT)
Message-Id: <20190617.140639.2221973922220817249.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com, eli@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: Re: [patch net-next] net: sched: cls_matchall: allow to delete
 filter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617160232.7599-1-jiri@resnulli.us>
References: <20190617160232.7599-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 14:06:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 17 Jun 2019 18:02:32 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently user is unable to delete the filter. See following example:
> $ tc filter add dev ens16np1 ingress pref 1 handle 1 matchall action drop
> $ tc filter show dev ens16np1 ingress
> filter protocol all pref 1 matchall chain 0
> filter protocol all pref 1 matchall chain 0 handle 0x1
>   in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1
> 
> $ tc filter del dev ens16np1 ingress pref 1 handle 1 matchall action drop
> RTNETLINK answers: Operation not supported
> 
> Implement tcf_proto_ops->delete() op and allow user to delete the filter.
> 
> Reported-by: Eli Cohen <eli@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks.
