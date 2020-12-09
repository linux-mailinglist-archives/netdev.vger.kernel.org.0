Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698F72D379C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgLIAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731086AbgLIAZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:25:13 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B3C0613CF;
        Tue,  8 Dec 2020 16:24:32 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 778774D249B43;
        Tue,  8 Dec 2020 16:24:32 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:24:32 -0800 (PST)
Message-Id: <20201208.162432.198903386189245459.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     pshelar@ovn.org, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: openvswitch: conntrack: simplify the
 return expression of ovs_ct_limit_get_default_limit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208121353.9353-1-zhengyongjun3@huawei.com>
References: <20201208121353.9353-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:24:32 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 20:13:53 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
