Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECD1212EC3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgGBVYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGBVYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:24:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910A0C08C5C1;
        Thu,  2 Jul 2020 14:24:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A05D12841C5A;
        Thu,  2 Jul 2020 14:24:29 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:24:28 -0700 (PDT)
Message-Id: <20200702.142428.1638019124425781765.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     hulkci@huawei.com, kuba@kernel.org, sumit.semwal@linaro.org,
        zhongjiang@huawei.com, snelson@pensando.io,
        nikolay@cumulusnetworks.com, vaibhavgupta40@gmail.com,
        mst@redhat.com, jwi@linux.ibm.com, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH net-next] ksz884x: mark pcidev_suspend() as
 __maybe_unused
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702091810.4999-1-weiyongjun1@huawei.com>
References: <20200702091810.4999-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:24:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Thu, 2 Jul 2020 17:18:10 +0800

> In certain configurations without power management support, gcc report
> the following warning:
> 
> drivers/net/ethernet/micrel/ksz884x.c:7182:12: warning:
>  'pcidev_suspend' defined but not used [-Wunused-function]
>  7182 | static int pcidev_suspend(struct device *dev_d)
>       |            ^~~~~~~~~~~~~~
> 
> Mark pcidev_suspend() as __maybe_unused to make it clear.
> 
> Fixes: 64120615d140 ("ksz884x: use generic power management")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Applied.
