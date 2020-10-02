Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82565280C17
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbgJBBq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBBq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:46:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8701C0613D0;
        Thu,  1 Oct 2020 18:46:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA5791285D1B0;
        Thu,  1 Oct 2020 18:29:39 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:46:26 -0700 (PDT)
Message-Id: <20201001.184626.136765913718934240.davem@davemloft.net>
To:     jingxiangfeng@huawei.com
Cc:     kuba@kernel.org, luc.vanoostenryck@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] caif_virtio: Remove redundant initialization of
 variable err
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930012954.1355-1-jingxiangfeng@huawei.com>
References: <20200930012954.1355-1-jingxiangfeng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:29:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Wed, 30 Sep 2020 09:29:54 +0800

> After commit a8c7687bf216 ("caif_virtio: Check that vringh_config is not
> null"), the variable err is being initialized with '-EINVAL' that is
> meaningless. So remove it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>

Applied to net-next.
