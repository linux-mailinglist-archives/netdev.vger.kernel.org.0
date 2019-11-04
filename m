Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C7AEE823
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbfKDTSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:18:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbfKDTSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:18:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02727151D3D76;
        Mon,  4 Nov 2019 11:18:52 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:18:52 -0800 (PST)
Message-Id: <20191104.111852.941272299166797826.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        ndagan@amazon.com, shayagr@amazon.com
Subject: Re: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572868728-5211-3-git-send-email-akiyano@amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
        <1572868728-5211-3-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:18:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Mon, 4 Nov 2019 13:58:48 +0200

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Current default non-adaptive tx interrupt moderation interval is 196 us.
> This commit sets it to 0, which is much more sensible as a default value.
> It can be modified using ethtool -C.
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

I do not agree that turning TX interrupt moderation off completely is
a more sensible default value.

Maybe a much smaller value, but turning off the coalescing delay
completely is a bit much.
