Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CD7276060
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgIWSq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgIWSqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:46:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C07C0613CE;
        Wed, 23 Sep 2020 11:46:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 788CE13F4FF68;
        Wed, 23 Sep 2020 11:29:29 -0700 (PDT)
Date:   Wed, 23 Sep 2020 11:46:13 -0700 (PDT)
Message-Id: <20200923.114613.569123102343062009.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: microchip: Make `lan743x_pm_suspend`
 function return right value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923032140.16514-1-zhengyongjun3@huawei.com>
References: <20200923032140.16514-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 11:29:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Wed, 23 Sep 2020 11:21:40 +0800

> drivers/net/ethernet/microchip/lan743x_main.c: In function lan743x_pm_suspend:
> 
> `ret` is set but not used. In fact, `pci_prepare_to_sleep` function value should
> be the right value of `lan743x_pm_suspend` function, therefore, fix it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.
