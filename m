Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729F426E978
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgIQX2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQX2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:28:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245DAC06174A;
        Thu, 17 Sep 2020 16:28:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A7871365D728;
        Thu, 17 Sep 2020 16:12:05 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:28:51 -0700 (PDT)
Message-Id: <20200917.162851.869838593390218662.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: Remove unused function
 qdisc_queue_drop_head()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916141629.24032-1-yuehaibing@huawei.com>
References: <20200916141629.24032-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:12:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 16 Sep 2020 22:16:29 +0800

> It is not used since commit a09ceb0e0814 ("sched: remove qdisc->drop")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
