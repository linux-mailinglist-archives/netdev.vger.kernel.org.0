Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC42733D8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgIUUtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgIUUtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:49:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF326C061755;
        Mon, 21 Sep 2020 13:49:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 505DD11E49F60;
        Mon, 21 Sep 2020 13:32:37 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:49:23 -0700 (PDT)
Message-Id: <20200921.134923.529028427401826879.davem@davemloft.net>
To:     miaoqinglang@huawei.com
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] chelsio: simplify the return expression of
 t3_ael2020_phy_prep()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921131005.91054-1-miaoqinglang@huawei.com>
References: <20200921131005.91054-1-miaoqinglang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:32:37 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Mon, 21 Sep 2020 21:10:05 +0800

> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Applied.
