Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4469C2D2B0
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfE2AKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:10:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE2AKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:10:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2217103D40EF;
        Tue, 28 May 2019 17:10:22 -0700 (PDT)
Date:   Tue, 28 May 2019 17:10:22 -0700 (PDT)
Message-Id: <20190528.171022.1815285028396063349.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: cls: Remove unnessesary check in
 mvpp2_ethtool_cls_rule_ins
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527134646.21804-1-yuehaibing@huawei.com>
References: <20190527134646.21804-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:10:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 27 May 2019 21:46:46 +0800

> Fix smatch warning:
> 
> drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c:1236
>  mvpp2_ethtool_cls_rule_ins() warn: unsigned 'info->fs.location' is never less than zero.
> 
> 'info->fs.location' is u32 type, never less than zero.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This doesn't apply to net-next.
