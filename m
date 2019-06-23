Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF204FC7E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFWPjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:39:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:39:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 996B4152F6947;
        Sun, 23 Jun 2019 08:39:30 -0700 (PDT)
Date:   Sun, 23 Jun 2019 08:39:30 -0700 (PDT)
Message-Id: <20190623.083930.762200013774329614.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V1 net-next] net: ena: Fix bug where ring allocation
 backoff stopped too late
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623071110.18687-1-sameehj@amazon.com>
References: <20190623071110.18687-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 08:39:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Sun, 23 Jun 2019 10:11:10 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> The current code of create_queues_with_size_backoff() allows the ring size
> to become as small as ENA_MIN_RING_SIZE/2. This is a bug since we don't
> want the queue ring to be smaller than ENA_MIN_RING_SIZE
> 
> In this commit we change the loop's termination condition to look at the
> queue size of the next iteration instead of that of the current one,
> so that the minimal queue size again becomes ENA_MIN_RING_SIZE.
> 
> Fixes: eece4d2ab9d2 ("net: ena: add ethtool function for changing io queue sizes")
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>

Applied, thank you.
