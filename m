Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9D11744D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLISfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:35:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfLISe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:34:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 027911543BD2D;
        Mon,  9 Dec 2019 10:34:58 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:34:58 -0800 (PST)
Message-Id: <20191209.103458.2167030481856657930.davem@davemloft.net>
To:     netanel@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V1 net] net: ena: fix napi handler misbehavior when the
 napi budget is zero
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191208173026.25745-1-netanel@amazon.com>
References: <20191208173026.25745-1-netanel@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:34:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>
Date: Sun, 8 Dec 2019 17:30:26 +0000

> In netpoll the napi handler could be called with budget equal to zero.
> Current ENA napi handler doesn't take that into consideration.
> 
> The napi handler handles Rx packets in a do-while loop.
> Currently, the budget check happens only after decrementing the
> budget, therefore the napi handler, in rare cases, could run over
> MAX_INT packets.
> 
> In addition to that, this moves all budget related variables to int
> calculation and stop mixing u32 to avoid ambiguity
> 
> Signed-off-by: Netanel Belgazal <netanel@amazon.com>

Bug fixes need to have an appropriate Fixes: tag.

Please repost with that added, thank you.
