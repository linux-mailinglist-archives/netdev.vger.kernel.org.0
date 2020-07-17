Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC304224461
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgGQTkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgGQTkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:40:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87082C0619D2;
        Fri, 17 Jul 2020 12:40:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF29011E4591F;
        Fri, 17 Jul 2020 12:40:09 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:40:09 -0700 (PDT)
Message-Id: <20200717.124009.223867297363163990.davem@davemloft.net>
To:     chenweilong@huawei.com
Cc:     kuba@kernel.org, jiri@mellanox.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net] rtnetlink: Fix memory(net_device) leak when
 ->newlink fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200715125810.59760-1-chenweilong@huawei.com>
References: <20200715125810.59760-1-chenweilong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:40:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>
Date: Wed, 15 Jul 2020 20:58:10 +0800

> When vlan_newlink call register_vlan_dev fails, it might return error
> with dev->reg_state = NETREG_UNREGISTERED. The rtnl_newlink should
> free the memory. But currently rtnl_newlink only free the memory which
> state is NETREG_UNINITIALIZED.
 ...
> Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>

Applied and queued up for -stable, thanks.
