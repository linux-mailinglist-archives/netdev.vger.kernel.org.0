Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F273C80
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404932AbfGXUJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:09:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392434AbfGXUJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:09:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB1081543073F;
        Wed, 24 Jul 2019 13:09:28 -0700 (PDT)
Date:   Wed, 24 Jul 2019 13:09:28 -0700 (PDT)
Message-Id: <20190724.130928.1854327585456756387.davem@davemloft.net>
To:     ebiggers@kernel.org
Cc:     eric.dumazet@gmail.com, dvyukov@google.com, netdev@vger.kernel.org,
        fw@strlen.de, i.maximets@samsung.com, edumazet@google.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724183710.GF213255@gmail.com>
References: <20190724163014.GC673@sol.localdomain>
        <20190724.111225.2257475150626507655.davem@davemloft.net>
        <20190724183710.GF213255@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 13:09:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Wed, 24 Jul 2019 11:37:12 -0700

> We can argue about what words to use to describe this situation, but
> it doesn't change the situation itself.

And we should argue about those words because it matters to humans and
effects how they feel, and humans ultimately fix these bugs.

So please stop with the hyperbole.

Thank you.
