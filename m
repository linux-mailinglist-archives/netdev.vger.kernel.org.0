Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E077E27107F
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgISVJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgISVJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:09:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33F2C0613CE;
        Sat, 19 Sep 2020 14:09:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C951611E3E4CE;
        Sat, 19 Sep 2020 13:52:18 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:09:02 -0700 (PDT)
Message-Id: <20200919.140902.1436451322594522440.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: microchip: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919023732.23656-1-zhengyongjun3@huawei.com>
References: <20200919023732.23656-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 13:52:19 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Sat, 19 Sep 2020 10:37:32 +0800

> `ret` is never used, so remove it.

You are not removing it:

> @@ -3053,7 +3053,7 @@ static int lan743x_pm_suspend(struct device *dev)
>  	/* Host sets PME_En, put D3hot */
>  	ret = pci_prepare_to_sleep(pdev);
>  
> -	return 0;
> +	return ret;
>  }

In fact, you are making it get used properly.

Please fix your commit message.
