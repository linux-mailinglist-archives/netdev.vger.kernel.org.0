Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA23AA4026
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfH3WKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:10:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3WKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:10:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A991154FFB1A;
        Fri, 30 Aug 2019 15:10:07 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:10:07 -0700 (PDT)
Message-Id: <20190830.151007.2061002515426559119.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com, pengfeil@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: Re: [patch net-next] sched: act_vlan: implement stats_update
 callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829133842.13958-1-jiri@resnulli.us>
References: <20190829133842.13958-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 15:10:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 29 Aug 2019 15:38:42 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement this callback in order to get the offloaded stats added to the
> kernel stats.
> 
> Reported-by: Pengfei Liu <pengfeil@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
