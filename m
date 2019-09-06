Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEBAB8A0
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405024AbfIFM6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:58:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404923AbfIFM6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 08:58:54 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB08F152F5302;
        Fri,  6 Sep 2019 05:58:51 -0700 (PDT)
Date:   Fri, 06 Sep 2019 14:58:50 +0200 (CEST)
Message-Id: <20190906.145850.790073310868935027.davem@davemloft.net>
To:     zhongjiang@huawei.com
Cc:     kvalo@codeaurora.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] nfp: Drop unnecessary continue in
 nfp_net_pf_alloc_vnics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567568784-9669-3-git-send-email-zhongjiang@huawei.com>
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
        <1567568784-9669-3-git-send-email-zhongjiang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 05:58:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>
Date: Wed, 4 Sep 2019 11:46:23 +0800

> Continue is not needed at the bottom of a loop.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Applied to net-next.
