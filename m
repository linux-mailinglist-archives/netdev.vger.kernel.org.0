Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376F724C85B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgHTXQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:16:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96701C061385;
        Thu, 20 Aug 2020 16:16:33 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2BB41287513B;
        Thu, 20 Aug 2020 15:59:46 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:16:32 -0700 (PDT)
Message-Id: <20200820.161632.849309747746025139.davem@davemloft.net>
To:     alex.dewar90@gmail.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qed: Remove unnecessary cast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820174725.823353-1-alex.dewar90@gmail.com>
References: <20200820174725.823353-1-alex.dewar90@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:59:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>
Date: Thu, 20 Aug 2020 18:47:25 +0100

> In qed_rdma_destroy_cq() the result of dma_alloc_coherent() is cast from
> void* unnecessarily. Remove cast.
> 
> Issue identified with Coccinelle.
> 
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>

Applied to net-next, thanks.
