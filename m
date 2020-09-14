Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BC12696E2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgINUnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgINUnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 16:43:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA82C06174A;
        Mon, 14 Sep 2020 13:43:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3781912793E55;
        Mon, 14 Sep 2020 13:27:03 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:43:49 -0700 (PDT)
Message-Id: <20200914.134349.2168616259804526399.davem@davemloft.net>
To:     zhangchangzhong@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: pxa168_eth: remove unused variable
 'retval' int pxa168_eth_change_mtu()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600089552-22368-1-git-send-email-zhangchangzhong@huawei.com>
References: <1600089552-22368-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 13:27:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>
Date: Mon, 14 Sep 2020 21:19:12 +0800

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/ethernet/marvell/pxa168_eth.c:1190:6: warning:
>  variable 'retval' set but not used [-Wunused-but-set-variable]
>  1190 |  int retval;
>       |      ^~~~~~
> 
> Function pxa168_eth_change_mtu() always return zero, so variable 'retval'
> is redundant, just remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied.
