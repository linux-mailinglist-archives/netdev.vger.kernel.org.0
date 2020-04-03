Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01DE19CDFE
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390291AbgDCA7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:59:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389574AbgDCA7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:59:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35A5512748FDE;
        Thu,  2 Apr 2020 17:59:01 -0700 (PDT)
Date:   Thu, 02 Apr 2020 17:59:00 -0700 (PDT)
Message-Id: <20200402.175900.1675015382136960413.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH] net: openvswitch: use hlist_for_each_entry_rcu instead
 of hlist_for_each_entry
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585168044-102049-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1585168044-102049-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 17:59:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Thu, 26 Mar 2020 04:27:24 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The struct sw_flow is protected by RCU, when traversing them,
> use hlist_for_each_entry_rcu.
> 
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied.
