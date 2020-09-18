Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E632707E1
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIRVLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRVLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:11:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1674C0613CE;
        Fri, 18 Sep 2020 14:11:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E45B159CF670;
        Fri, 18 Sep 2020 13:54:46 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:11:32 -0700 (PDT)
Message-Id: <20200918.141132.678366062831598469.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com,
        zengweiliang.zengweiliang@huawei.com
Subject: Re: [PATCH net] hinic: fix sending pkts from core while self
 testing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918040938.20177-1-luobin9@huawei.com>
References: <20200918040938.20177-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:54:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Fri, 18 Sep 2020 12:09:38 +0800

> Call netif_tx_disable firstly before starting doing self-test to
> avoid sending packet from networking core and self-test packet
> simultaneously which may cause self-test failure or hw abnormal.
> 
> Fixes: 4aa218a4fe77 ("hinic: add self test support")
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied.
