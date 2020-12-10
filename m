Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765972D502F
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgLJBMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:12:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54716 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgLJBMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:12:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 240FA4D259C1C;
        Wed,  9 Dec 2020 17:11:48 -0800 (PST)
Date:   Wed, 09 Dec 2020 17:11:47 -0800 (PST)
Message-Id: <20201209.171147.1935200551789292498.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: emulex: benet: simplify the return
 expression of be_if_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209091957.20203-1-zhengyongjun3@huawei.com>
References: <20201209091957.20203-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 17:11:48 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 9 Dec 2020 17:19:57 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
