Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAA12733CA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgIUUqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIUUqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:46:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B499C061755;
        Mon, 21 Sep 2020 13:46:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 682281452DE96;
        Mon, 21 Sep 2020 13:29:19 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:46:05 -0700 (PDT)
Message-Id: <20200921.134605.1478788361081103401.davem@davemloft.net>
To:     miaoqinglang@huawei.com
Cc:     jiri@nvidia.com, idosch@nvidia.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mlxsw: spectrum_router: simplify the return
 expression of __mlxsw_sp_router_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921131041.92294-1-miaoqinglang@huawei.com>
References: <20200921131041.92294-1-miaoqinglang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:29:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Mon, 21 Sep 2020 21:10:41 +0800

> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Applied.
