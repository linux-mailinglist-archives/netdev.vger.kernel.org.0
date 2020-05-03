Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF11C3039
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 01:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgECXBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 19:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgECXBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 19:01:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228DFC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 16:01:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27B0A1211C987;
        Sun,  3 May 2020 16:01:06 -0700 (PDT)
Date:   Sun, 03 May 2020 16:01:05 -0700 (PDT)
Message-Id: <20200503.160105.1764216961043543026.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V3 net-next 00/12] Enhance current features in ena
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 May 2020 16:01:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Sun, 3 May 2020 09:52:09 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> 
> Difference from v2:
> * dropped patch "net: ena: move llq configuration from ena_probe to ena_device_init()" 
> * reworked patch ""net: ena: implement ena_com_get_admin_polling_mode() to drop the prototype
> 
> Difference from v1:
> * reodered paches #01 and #02.
> * dropped adding Rx/Tx drops to ethtool in patch #08
> 
> V1:
> This patchset introduces the following:
> * minor changes to RSS feature
> * add total rx and tx drop counter
> * add unmask_interrupt counter for ethtool statistics
> * add missing implementation for ena_com_get_admin_polling_mode()
> * some minor code clean-up and cosmetics
> * use SHUTDOWN as reset reason when closing interface

Series applied, thank you.
