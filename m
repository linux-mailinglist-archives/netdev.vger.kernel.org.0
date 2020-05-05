Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D1D1C603F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgEESkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgEESkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:40:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC83C061A0F;
        Tue,  5 May 2020 11:40:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54842127F71E5;
        Tue,  5 May 2020 11:40:20 -0700 (PDT)
Date:   Tue, 05 May 2020 11:40:19 -0700 (PDT)
Message-Id: <20200505.114019.2162064780956586287.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: Remove Comparison to bool in
 bnx2x_dcb.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505074400.21658-1-yanaijie@huawei.com>
References: <20200505074400.21658-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:40:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Tue, 5 May 2020 15:44:00 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1548:17-31: WARNING:
> Comparison to bool
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1148:16-24: WARNING:
> Comparison to bool
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1158:30-38: WARNING:
> Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
