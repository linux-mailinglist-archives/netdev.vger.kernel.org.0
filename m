Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0319D2D5021
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbgLJBN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:13:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54780 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLJBNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:13:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C621A4D259C1C;
        Wed,  9 Dec 2020 17:12:59 -0800 (PST)
Date:   Wed, 09 Dec 2020 17:12:59 -0800 (PST)
Message-Id: <20201209.171259.2232951249223737115.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mcoquelin.stm32@gmail.com
Subject: Re: [PATCH net-next] net: stmmac: simplify the return
 dwmac5_rxp_disable()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209092325.20415-1-zhengyongjun3@huawei.com>
References: <20201209092325.20415-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 17:13:00 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 9 Dec 2020 17:23:25 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
