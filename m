Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21641C9C0D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgEGUSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGUSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:18:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19781C05BD43;
        Thu,  7 May 2020 13:18:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E68C1195050E;
        Thu,  7 May 2020 13:18:34 -0700 (PDT)
Date:   Thu, 07 May 2020 13:18:34 -0700 (PDT)
Message-Id: <20200507.131834.1517984934609648952.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:18:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>
Date: Thu,  7 May 2020 19:50:10 +0800

> Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
> to simplify code, avoid redundant judgements.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Saeed, please pick this up.

Thank you.
