Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD12B2733D3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgIUUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgIUUsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:48:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D1EC061755;
        Mon, 21 Sep 2020 13:48:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6957911E49F60;
        Mon, 21 Sep 2020 13:31:22 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:48:09 -0700 (PDT)
Message-Id: <20200921.134809.552418047802346376.davem@davemloft.net>
To:     miaoqinglang@huawei.com
Cc:     claudiu.manoil@nxp.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] enetc: simplify the return expression of
 enetc_vf_set_mac_addr()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921131026.91790-1-miaoqinglang@huawei.com>
References: <20200921131026.91790-1-miaoqinglang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:31:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Mon, 21 Sep 2020 21:10:26 +0800

> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Applied.
