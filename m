Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE32642C40
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502126AbfFLQ2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:28:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502106AbfFLQ2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:28:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D63981513DD28;
        Wed, 12 Jun 2019 09:28:43 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:28:43 -0700 (PDT)
Message-Id: <20190612.092843.1272050301746748492.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 Qdisc ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612071435.7367-1-vladbu@mellanox.com>
References: <20190612071435.7367-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:28:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Wed, 12 Jun 2019 10:14:35 +0300

> To remove rtnl lock dependency in tc filter update API when using ingress
> Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in ingress Qdisc_class_ops.
> 
> Ingress Qdisc ops don't require any modifications to be used without rtnl
> lock on tc filter update path. Ingress implementation never changes its
> q->block and only releases it when Qdisc is being destroyed. This means it
> is enough for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to
> hold ingress Qdisc reference while using it without relying on rtnl lock
> protection. Unlocked Qdisc ops support is already implemented in filter
> update path by unlocked cls API patch set.
> 
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
