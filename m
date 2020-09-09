Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3089C263556
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgIISC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbgIISCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:02:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B2C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:02:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A511712953C99;
        Wed,  9 Sep 2020 10:45:30 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:02:16 -0700 (PDT)
Message-Id: <20200909.110216.1831685438155742332.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V3 net-next 0/4] Enhance current features in ena driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909064627.30104-1-sameehj@amazon.com>
References: <20200909064627.30104-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 10:45:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Wed, 9 Sep 2020 06:46:23 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This series adds the following:
> * Exposes new device stats using ethtool.
> * Adds and exposes the stats of xdp TX queues through ethtool.
> 
> V2: Drop the need for casting stat_offset
> V1: Use unsigned long for pointer math instead of uintptr_t

Please respin with the alignment problem Jakub pointed out fixed,
thank you.
