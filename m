Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474EC1FD84B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgFQWEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgFQWEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:04:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DB3C06174E;
        Wed, 17 Jun 2020 15:04:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4E661297CA0E;
        Wed, 17 Jun 2020 15:04:31 -0700 (PDT)
Date:   Wed, 17 Jun 2020 15:04:30 -0700 (PDT)
Message-Id: <20200617.150430.707659814683399868.davem@davemloft.net>
To:     gustavoars@kernel.org
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
Subject: Re: [PATCH] liquidio: Replace vmalloc_node + memset with
 vzalloc_node and use array_size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615211855.GA32663@embeddedor>
References: <20200615211855.GA32663@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 15:04:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Mon, 15 Jun 2020 16:18:55 -0500

> Use vzalloc/vzalloc_node instead of the vmalloc/vzalloc_node and memset.
> 
> Also, notice that vzalloc_node() function has no 2-factor argument form
> to calculate the size for the allocation, so multiplication factors need
> to be wrapped in array_size().
> 
> This issue was found with the help of Coccinelle and, audited and fixed
> manually.
> 
> Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Applied to net-next, thanks.
