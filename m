Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B7A67CB0
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfGNCXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:23:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfGNCXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:23:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B7D614051854;
        Sat, 13 Jul 2019 19:23:46 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:23:44 -0700 (PDT)
Message-Id: <20190713.192344.1454771658469437265.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/2] net sched: update skbedit action for
 batched events operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
References: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:23:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri, 12 Jul 2019 18:21:59 -0400

> Add get_fill_size() routine used to calculate the action size
> when building a batch of events.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Please add an appropriate Fixes: tag, and also when you respin this provide the
required "[PATCH 0/N] " header posting explaining what the series is doing at
a high level, how it is doing it, and why it is doing it that way.

Thank you.
