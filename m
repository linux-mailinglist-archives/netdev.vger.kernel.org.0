Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13F46DD4
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFOCeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:34:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:34:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C75E013E919BB;
        Fri, 14 Jun 2019 19:34:07 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:34:07 -0700 (PDT)
Message-Id: <20190614.193407.464864156424103215.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, daniel@iogearbox.net
Subject: Re: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 clsact Qdisc ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613161205.2689-1-vladbu@mellanox.com>
References: <20190613161205.2689-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:34:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 13 Jun 2019 19:12:05 +0300

> To remove rtnl lock dependency in tc filter update API when using clsact
> Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in clsact Qdisc_class_ops.
> 
> Clsact Qdisc ops don't require any modifications to be used without rtnl
> lock on tc filter update path. Implementation never changes its q->block
> and only releases it when Qdisc is being destroyed. This means it is enough
> for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to hold clsact
> Qdisc reference while using it without relying on rtnl lock protection.
> Unlocked Qdisc ops support is already implemented in filter update path by
> unlocked cls API patch set.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
