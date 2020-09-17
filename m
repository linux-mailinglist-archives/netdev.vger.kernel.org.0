Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707C126D005
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIQAiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQAiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:38:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47666C06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:38:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86CE313C788A3;
        Wed, 16 Sep 2020 17:21:24 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:38:10 -0700 (PDT)
Message-Id: <20200916.173810.1493576519339155196.davem@davemloft.net>
To:     luwei32@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        gustavoars@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: hns: kerneldoc fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916020428.86299-1-luwei32@huawei.com>
References: <20200916020428.86299-1-luwei32@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:21:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>
Date: Wed, 16 Sep 2020 10:04:28 +0800

> Fix some parameter description or spelling mistakes.
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>

Applied, thank you.
