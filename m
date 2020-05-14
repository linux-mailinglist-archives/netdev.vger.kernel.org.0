Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBB91D3EBC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgENULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbgENULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:11:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68DC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:11:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41691128D4B41;
        Thu, 14 May 2020 13:11:37 -0700 (PDT)
Date:   Thu, 14 May 2020 13:11:36 -0700 (PDT)
Message-Id: <20200514.131136.727728421563787294.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        jiri@mellanox.com
Subject: Re: [PATCH net-next 1/4] net: sched: introduce terse dump flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514114026.27047-2-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
        <20200514114026.27047-2-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:11:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 14 May 2020 14:40:23 +0300

> +static const u32 tca_dump_flags_allowed = TCA_DUMP_FLAGS_TERSE;
> +
> +static const struct nla_policy tcf_tfilter_dump_policy[TCA_MAX + 1] = {
> +	[TCA_DUMP_FLAGS] = NLA_POLICY_BITFIELD32(tca_dump_flags_allowed),
> +};

The compiler apparently dones't consider your NLA_POLICY_BITFIELD32()
argument constant as be kbuild robot.
