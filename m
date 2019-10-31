Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8749EA888
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfJaBI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:08:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfJaBI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:08:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 287E414EB5D6E;
        Wed, 30 Oct 2019 18:08:26 -0700 (PDT)
Date:   Wed, 30 Oct 2019 18:08:25 -0700 (PDT)
Message-Id: <20191030.180825.592258061800796198.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH net-next v2 0/8] Control action percpu counters
 allocation by netlink flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030140907.18561-1-vladbu@mellanox.com>
References: <20191030140907.18561-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 18:08:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Wed, 30 Oct 2019 16:08:59 +0200

> In order to allow configuring action counters allocation type at
> runtime, implement following changes:
> 
> - Implement helper functions to update the action counters and use them
>   in affected actions instead of updating counters directly. This steps
>   abstracts actions implementation from counter types that are being
>   used for particular action instance at runtime.
> 
> - Modify the new helpers to use percpu counters if they were allocated
>   during action initialization and use regular counters otherwise.
> 
> - Extend action UAPI TCA_ACT space with TCA_ACT_FLAGS field. Add
>   TCA_ACT_FLAGS_NO_PERCPU_STATS action flag and update
>   hardware-offloaded actions to not allocate percpu counters when the
>   flag is set.
 ...

I like both how this is implemented and how the patch series was split
up.

Series applied, thank you.
