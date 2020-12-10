Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ABA2D5018
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731838AbgLJBNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731518AbgLJBMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:12:50 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5332EC0613D6;
        Wed,  9 Dec 2020 17:12:10 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 03E404D259C1D;
        Wed,  9 Dec 2020 17:12:09 -0800 (PST)
Date:   Wed, 09 Dec 2020 17:12:09 -0800 (PST)
Message-Id: <20201209.171209.843821363873901586.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: cisco: enic: simplify the return
 vnic_cq_alloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209092031.20255-1-zhengyongjun3@huawei.com>
References: <20201209092031.20255-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 17:12:10 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 9 Dec 2020 17:20:31 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
