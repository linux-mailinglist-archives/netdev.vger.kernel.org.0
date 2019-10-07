Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35E6CE3BF
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfJGNad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:30:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfJGNac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:30:32 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F85614049CBC;
        Mon,  7 Oct 2019 06:30:31 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:30:30 +0200 (CEST)
Message-Id: <20191007.153030.1870703252635689222.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V3 net-next 0/6] 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191006123328.24210-1-sameehj@amazon.com>
References: <20191006123328.24210-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:30:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Sun, 6 Oct 2019 15:33:22 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> 
> Difference from v2:
> * ethtool's set/get channels: Switched to using combined instead of
>   separate rx/tx
> * Fixed error handling in set_channels
> * Fixed indentation and cosmetic issues as requested by Jakub Kicinski
> 
> Difference from v1:
> * Dropped the print from patch 0002 - "net: ena: multiple queue creation
>   related cleanups" as requested by David Miller

Series applied.
