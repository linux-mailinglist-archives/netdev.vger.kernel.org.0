Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F821D96
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbfEQSlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:41:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfEQSlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:41:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4710F13F18517;
        Fri, 17 May 2019 11:41:15 -0700 (PDT)
Date:   Fri, 17 May 2019 11:41:14 -0700 (PDT)
Message-Id: <20190517.114114.617879749254144661.davem@davemloft.net>
To:     hujunwei4@huawei.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, mingfangsen@huawei.com,
        zhoukang7@huawei.com, mousuanming@huawei.com
Subject: Re: [PATCH] tipc: fix modprobe tipc failed after switch order of
 device registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <efa87f26-8766-ac92-ccaa-23a6992bd32a@huawei.com>
References: <efa87f26-8766-ac92-ccaa-23a6992bd32a@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 May 2019 11:41:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hujunwei <hujunwei4@huawei.com>
Date: Fri, 17 May 2019 19:27:34 +0800

> From: Junwei Hu <hujunwei4@huawei.com>
> 
> Error message printed:
> modprobe: ERROR: could not insert 'tipc': Address family not
> supported by protocol.
> when modprobe tipc after the following patch: switch order of
> device registration, commit 7e27e8d6130c
> ("tipc: switch order of device registration to fix a crash")
> 
> Because sock_create_kern(net, AF_TIPC, ...) is called by
> tipc_topsrv_create_listener() in the initialization process
> of tipc_net_ops, tipc_socket_init() must be execute before that.
> 
> I move tipc_socket_init() into function tipc_init_net().
> 
> Fixes: 7e27e8d6130c
> ("tipc: switch order of device registration to fix a crash")
> Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
> Reported-by: Wang Wang <wangwang2@huawei.com>
> Reviewed-by: Kang Zhou <zhoukang7@huawei.com>
> Reviewed-by: Suanming Mou <mousuanming@huawei.com>

Applied.
