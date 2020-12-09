Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96352D37AC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgLIAZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731905AbgLIAZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:25:46 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E058C061793;
        Tue,  8 Dec 2020 16:25:06 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 734004D248DBF;
        Tue,  8 Dec 2020 16:25:05 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:25:05 -0800 (PST)
Message-Id: <20201208.162505.787520856422751498.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx4: simplify the return expression of
 mlx4_init_cq_table()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208135543.11820-1-zhengyongjun3@huawei.com>
References: <20201208135543.11820-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:25:05 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 21:55:43 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
