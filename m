Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF62324C604
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgHTTBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgHTTBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:01:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B46EC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44670128107CD;
        Thu, 20 Aug 2020 11:44:21 -0700 (PDT)
Date:   Thu, 20 Aug 2020 12:01:06 -0700 (PDT)
Message-Id: <20200820.120106.2151140810197277815.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org,
        rdunlap@infradead.org
Subject: Re: [PATCH net] sfc: fix build warnings on 32-bit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <187ef73f-09ed-8c45-540f-85fb1714e887@solarflare.com>
References: <187ef73f-09ed-8c45-540f-85fb1714e887@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 11:44:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Thu, 20 Aug 2020 11:47:19 +0100

> Truncation of DMA_BIT_MASK to 32-bit dma_addr_t is semantically safe,
>  but the compiler was warning because it was happening implicitly.
> Insert explicit casts to suppress the warnings.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thanks.
