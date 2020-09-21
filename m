Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C892273465
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgIUUyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgIUUyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:54:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76338C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 13:54:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 611E111E49F60;
        Mon, 21 Sep 2020 13:37:52 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:54:38 -0700 (PDT)
Message-Id: <20200921.135438.767104917629097643.davem@davemloft.net>
To:     shayagr@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, sameehj@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net-next 0/7] Update license and polish ENA driver
 code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921083742.6454-1-shayagr@amazon.com>
References: <20200921083742.6454-1-shayagr@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:37:52 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>
Date: Mon, 21 Sep 2020 11:37:35 +0300

> This series adds the following:
> - Change driver's license into SPDX format
> - Capitalize all log prints in ENA driver
> - Fix issues raised by static checkers
> - Improve code readability by adding functions, fix spelling
>   mistakes etc.
> - Update driver's documentation
> 
> Changed from previous version:
> v1->v2: dropped patch that transforms pr_* log prints into dev_* prints

Series applied, thank you.
