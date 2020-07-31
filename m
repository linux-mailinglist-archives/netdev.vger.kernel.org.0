Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4DC234EA4
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgGaXgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgGaXgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:36:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C21FC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 16:36:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2C9711D69C3E;
        Fri, 31 Jul 2020 16:19:47 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:36:30 -0700 (PDT)
Message-Id: <20200731.163630.1075703198403106507.davem@davemloft.net>
To:     liujian56@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: The error lable position is corrected
 in ct_init_module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730081428.35904-1-liujian56@huawei.com>
References: <20200730081428.35904-1-liujian56@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:19:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>
Date: Thu, 30 Jul 2020 16:14:28 +0800

> From: liujian <liujian56@huawei.com>
> 
> Exchange the positions of the err_tbl_init and err_register labels in
> ct_init_module function.
> 
> Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
> Signed-off-by: liujian <liujian56@huawei.com>

Applied, thank you.
