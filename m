Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EC513743
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfEDESG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:18:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfEDESG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:18:06 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8ABBA14D85C74;
        Fri,  3 May 2019 21:17:52 -0700 (PDT)
Date:   Sat, 04 May 2019 00:17:49 -0400 (EDT)
Message-Id: <20190504.001749.585621906089996460.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V1 net 0/8] Bug fixes for ENA Ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501134710.8938-1-sameehj@amazon.com>
References: <20190501134710.8938-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:18:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Wed, 1 May 2019 16:47:02 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> Sameeh Jubran (8):
>   net: ena: fix swapped parameters when calling
>     ena_com_indirect_table_fill_entry
>   net: ena: fix: set freed objects to NULL to avoid failing future
>     allocations
>   net: ena: fix: Free napi resources when ena_up() fails
>   net: ena: fix incorrect test of supported hash function
>   net: ena: fix return value of ena_com_config_llq_info()
>   net: ena: improve latency by disabling adaptive interrupt moderation
>     by default
>   net: ena: fix ena_com_fill_hash_function() implementation
>   net: ena: gcc 8: fix compilation warning

Series applied.

Please provide a real commit message in your header posting next time,
rather than just the shortlog.

Thank you.
