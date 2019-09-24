Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9B5BCAAE
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441431AbfIXOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:55:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbfIXOzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:55:40 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9023C15172840;
        Tue, 24 Sep 2019 07:55:39 -0700 (PDT)
Date:   Tue, 24 Sep 2019 16:55:37 +0200 (CEST)
Message-Id: <20190924.165537.249424755771396934.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] skge: fix checksum byte order
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920161826.15942-1-sthemmin@microsoft.com>
References: <20190920161826.15942-1-sthemmin@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 07:55:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Fri, 20 Sep 2019 18:18:26 +0200

> From: Stephen Hemminger <stephen@networkplumber.org>
> 
> Running old skge driver on PowerPC causes checksum errors
> because hardware reported 1's complement checksum is in little-endian
> byte order.
> 
> Reported-by: Benoit <benoit.sansoni@gmail.com>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied and queued up for -stable.
