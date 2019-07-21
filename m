Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B426F4CC
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfGUSuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:50:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfGUSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:50:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A74F115259C92;
        Sun, 21 Jul 2019 11:50:31 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:50:31 -0700 (PDT)
Message-Id: <20190721.115031.949321647637070719.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: verify that q!=NULL before
 setting q->flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190721144412.2783-1-vladbu@mellanox.com>
References: <20190721144412.2783-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:50:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Sun, 21 Jul 2019 17:44:12 +0300

> In function int tc_new_tfilter() q pointer can be NULL when adding filter
> on a shared block. With recent change that resets TCQ_F_CAN_BYPASS after
> filter creation, following NULL pointer dereference happens in case parent
> block is shared:
 ...
> Verify that q pointer is not NULL before setting the 'flags' field.
> 
> Fixes: 3f05e6886a59 ("net_sched: unset TCQ_F_CAN_BYPASS when adding filters")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
