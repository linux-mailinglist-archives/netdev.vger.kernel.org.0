Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18991C7B6E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgEFUoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726093AbgEFUoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:44:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8962CC061A0F;
        Wed,  6 May 2020 13:44:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A3C91210A3F3;
        Wed,  6 May 2020 13:44:10 -0700 (PDT)
Date:   Wed, 06 May 2020 13:44:09 -0700 (PDT)
Message-Id: <20200506.134409.803201874191126476.davem@davemloft.net>
To:     zou_wei@huawei.com
Cc:     grygorii.strashko@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: ethernet: ti: Use PTR_ERR_OR_ZERO() to
 simplify code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588733698-33746-1-git-send-email-zou_wei@huawei.com>
References: <1588733698-33746-1-git-send-email-zou_wei@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:44:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Samuel Zou <zou_wei@huawei.com>
Date: Wed, 6 May 2020 10:54:58 +0800

> Fixes coccicheck warning:
> 
> drivers/net/ethernet/ti/am65-cpts.c:1017:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>

Applied to net-next, thank you.
