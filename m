Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACAF2D5140
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgLJDWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:22:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33736 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgLJDWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:22:19 -0500
X-Greylist: delayed 10092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 22:22:19 EST
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1DD224D259C1A;
        Wed,  9 Dec 2020 19:21:37 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:21:37 -0800 (PST)
Message-Id: <20201209.192137.2195377933879164590.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net/mlx4: simplify the return expression
 of mlx4_init_cq_table()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209012002.18766-1-zhengyongjun3@huawei.com>
References: <20201209012002.18766-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:21:38 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 9 Dec 2020 09:20:02 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
