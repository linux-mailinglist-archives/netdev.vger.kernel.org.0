Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91C277E2C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgIYCra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 22:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIYCr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:47:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72A2C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 19:47:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6236B135F4C48;
        Thu, 24 Sep 2020 19:30:40 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:47:24 -0700 (PDT)
Message-Id: <20200924.194724.1517429040936253414.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [Patch net 0/2] net_sched: fix a UAF in tcf_action_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:30:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 22 Sep 2020 20:56:22 -0700

> This patchset fixes a use-after-free triggered by syzbot. Please
> find more details in each patch description.

Series applied and queued up for -stable, thanks Cong.
