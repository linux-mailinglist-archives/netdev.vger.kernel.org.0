Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F8FC0337
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfI0KPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfI0KPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 06:15:33 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7AE1614E04A26;
        Fri, 27 Sep 2019 03:15:31 -0700 (PDT)
Date:   Fri, 27 Sep 2019 12:15:29 +0200 (CEST)
Message-Id: <20190927.121529.168532780904459510.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net v3 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924155118.2488-1-vladbu@mellanox.com>
References: <20190924155118.2488-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 03:15:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Tue, 24 Sep 2019 18:51:15 +0300

> TC filter API unlocking introduced several new fine-grained locks. The
> change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
> APIs which need to obtain new mutex while holding sch tree spinlock. This
> series fixes affected Qdiscs by ensuring that cls API that became sleeping
> is only called outside of sch tree lock critical section.

Series applied.
