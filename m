Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5809D2D501A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbgLJBNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:13:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54740 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731830AbgLJBND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:13:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4CB0A4D259C1A;
        Wed,  9 Dec 2020 17:12:21 -0800 (PST)
Date:   Wed, 09 Dec 2020 17:12:20 -0800 (PST)
Message-Id: <20201209.171220.764529547748242337.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, madalin.bucur@nxp.com
Subject: Re: [PATCH net-next] net: freescale: dpaa: simplify the return
 dpaa_eth_refill_bpools()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209092107.20306-1-zhengyongjun3@huawei.com>
References: <20201209092107.20306-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 17:12:21 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 9 Dec 2020 17:21:07 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
