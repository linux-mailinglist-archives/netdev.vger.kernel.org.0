Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A5F3022F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE3Srq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:47:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3Srq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:47:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C820B14D99F74;
        Thu, 30 May 2019 11:47:45 -0700 (PDT)
Date:   Thu, 30 May 2019 11:47:45 -0700 (PDT)
Message-Id: <20190530.114745.2009412497795778923.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: mvpp2: cls: Remove unnessesary check
 in mvpp2_ethtool_cls_rule_ins
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529025906.17452-1-yuehaibing@huawei.com>
References: <20190527134646.21804-1-yuehaibing@huawei.com>
        <20190529025906.17452-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:47:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 29 May 2019 10:59:06 +0800

> Fix smatch warning:
> 
> drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c:1236
>  mvpp2_ethtool_cls_rule_ins() warn: unsigned 'info->fs.location' is never less than zero.
> 
> 'info->fs.location' is u32 type, never less than zero.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: rework patch based net-next

Applied.
