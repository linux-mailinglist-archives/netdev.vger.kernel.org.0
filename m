Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8704522736F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGUAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGUAE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:04:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ECCC061794;
        Mon, 20 Jul 2020 17:04:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3E8B11E8EC0C;
        Mon, 20 Jul 2020 16:47:42 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:04:26 -0700 (PDT)
Message-Id: <20200720.170426.1912395025653130693.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: add missed clk_disable_unprepare in
 bcmgenet_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595237794-11530-1-git-send-email-zhangchangzhong@huawei.com>
References: <1595237794-11530-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 16:47:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Mon, 20 Jul 2020 17:36:34 +0800

> The driver forgets to call clk_disable_unprepare() in error path after
> a success calling for clk_prepare_enable().
> 
> Fix to goto err_clk_disable if clk_prepare_enable() is successful.
> 
> Fixes: c80d36ff63a5 ("net: bcmgenet: Use devm_clk_get_optional() to get the clocks")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
