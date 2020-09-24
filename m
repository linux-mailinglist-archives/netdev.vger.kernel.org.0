Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1357527651A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgIXAch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:32:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BC0C0613CE;
        Wed, 23 Sep 2020 17:32:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE80211E5845E;
        Wed, 23 Sep 2020 17:15:48 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:32:35 -0700 (PDT)
Message-Id: <20200923.173235.1213061924568928589.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com, kuba@kernel.org,
        tanhuazhong@huawei.com, moyufeng@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: hns3: Constify static structs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921225517.105265-1-rikard.falkeborn@gmail.com>
References: <20200921225517.105265-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:15:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Tue, 22 Sep 2020 00:55:17 +0200

> A number of static variables were not modified. Make them const to allow
> the compiler to put them in read-only memory. In order to do so,
> constify a couple of input pointers as well as some local pointers.
> This moves about 35Kb to read-only memory as seen by the output of the
> size command.
> 
> Before:
>    text    data     bss     dec     hex filename
>  404938  111534     640  517112   7e3f8 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge.ko
> 
> After:
>    text    data     bss     dec     hex filename
>  439499   76974     640  517113   7e3f9 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge.ko
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Applied.
