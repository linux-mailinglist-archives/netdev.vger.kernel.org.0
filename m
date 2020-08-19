Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8BA24A96C
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHSWeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgHSWeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:34:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD6C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:34:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4531011E4576D;
        Wed, 19 Aug 2020 15:17:26 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:34:10 -0700 (PDT)
Message-Id: <20200819.153410.1590125578260765717.davem@davemloft.net>
To:     shayagr@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, sameehj@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V3 net 0/3] Bug fixes for ENA ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819172838.20564-1-shayagr@amazon.com>
References: <20200819172838.20564-1-shayagr@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:17:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayagr@amazon.com>
Date: Wed, 19 Aug 2020 20:28:35 +0300

> This series adds the following:
> - Fix undesired call to ena_restore after returning from suspend
> - Fix condition inside a WARN_ON
> - Fix overriding previous value when updating missed_tx statistic
> 
> v1->v2:
> - fix bug when calling reset routine after device resources are freed (Jakub)
> 
> v2->v3:
> - fix wrong hash in 'Fixes' tag

Series applied and queued up for -stable, thanks.
