Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCF62654DE
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgIJWNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:13:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D87C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 15:13:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98F39135AC9B4;
        Thu, 10 Sep 2020 14:56:13 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:12:59 -0700 (PDT)
Message-Id: <20200910.151259.1530572233543296855.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V4 net-next 0/4] Enhance current features in ena driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910130713.26074-1-sameehj@amazon.com>
References: <20200910130713.26074-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 14:56:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Thu, 10 Sep 2020 13:07:09 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This series adds the following:
> * Exposes new device stats using ethtool.
> * Adds and exposes the stats of xdp TX queues through ethtool.
> 
> V3: Fix indentation in patches #3 and #4
> V2: Drop the need for casting stat_offset
> V1: Use unsigned long for pointer math instead of uintptr_t

Series applied, thank you.
