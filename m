Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E74AF77F
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbfIKIOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:14:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKIOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:14:32 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5640615567327;
        Wed, 11 Sep 2019 01:14:29 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:14:28 +0200 (CEST)
Message-Id: <20190911.101428.1457711904338692410.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     tsbogend@alpha.franken.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] net: sonic: replace dev_kfree_skb in
 sonic_send_packet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911013623.36897-1-maowenan@huawei.com>
References: <a48a6690-eeb4-91d2-bed8-439d14b63e2f@cogentembedded.com>
        <20190911013623.36897-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:14:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Wed, 11 Sep 2019 09:36:23 +0800

> sonic_send_packet will be processed in irq or non-irq 
> context, so it would better use dev_kfree_skb_any
> instead of dev_kfree_skb.
> 
> Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied.
