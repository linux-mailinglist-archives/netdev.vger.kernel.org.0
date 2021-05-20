Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99F38B973
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhETWZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhETWZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 18:25:49 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF72C061574;
        Thu, 20 May 2021 15:24:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 437744F488CC2;
        Thu, 20 May 2021 15:24:25 -0700 (PDT)
Date:   Thu, 20 May 2021 15:24:21 -0700 (PDT)
Message-Id: <20210520.152421.1110528865195726730.davem@davemloft.net>
To:     olek2@wp.pl
Cc:     hauke@hauke-m.de, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lantiq: fix memory corruption in RX ring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210520184054.38477-1-olek2@wp.pl>
References: <20210520184054.38477-1-olek2@wp.pl>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 20 May 2021 15:24:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>
Date: Thu, 20 May 2021 20:40:54 +0200

> In a situation where memory allocation or dma mapping fails, an
> invalid address is programmed into the descriptor. This can lead
> to memory corruption. If the memory allocation fails, DMA should
> reuse the previous skb and mapping and drop the packet. This patch
> also increments rx drop counter.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>

Please repost this with an appropriate Fixes: tag, thank you.

