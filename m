Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D61B4189
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbfIPUG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:06:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732710AbfIPUGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:06:25 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F24B4153F5148;
        Mon, 16 Sep 2019 13:06:21 -0700 (PDT)
Date:   Mon, 16 Sep 2019 22:06:20 +0200 (CEST)
Message-Id: <20190916.220620.564607753604799412.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        sameehj@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net-next 00/11] net: ena: implement adaptive
 interrupt moderation using dim
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 13:06:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Mon, 16 Sep 2019 14:31:25 +0300

> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> In this patchset we replace our adaptive interrupt moderation
> implementation with the dim library implementation.
> The dim library showed great improvement in throughput, latency
> and CPU usage in different scenarios on ARM CPUs.
> This patchset also includes a few bug fixes to the parts of the
> old implementation of adaptive interrupt moderation that were left.
> 
> Changes from V1 patchset: 
> Removed stray empty lines from patches 01/11, 09/11.

Series applied.
