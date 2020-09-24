Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A8276554
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgIXAny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:43:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7F7C0613CE;
        Wed, 23 Sep 2020 17:43:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0577611E58429;
        Wed, 23 Sep 2020 17:27:05 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:43:52 -0700 (PDT)
Message-Id: <20200923.174352.634025554486458032.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, zengweiliang.zengweiliang@huawei.com
Subject: Re: [PATCH net] hinic: fix wrong return value of mac-set cmd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922112643.15726-1-luobin9@huawei.com>
References: <20200922112643.15726-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:27:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Tue, 22 Sep 2020 19:26:43 +0800

> It should also be regarded as an error when hw return status=4 for PF's
> setting mac cmd. Only if PF return status=4 to VF should this cmd be
> taken special treatment.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Bug fixes require a proper Fixes: tag.

Please resubmit with the corrected, thank you.
