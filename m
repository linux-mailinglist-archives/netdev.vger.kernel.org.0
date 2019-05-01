Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1760210CAF
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 20:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfEAS3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 14:29:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEAS3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 14:29:55 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37D421263F1F3;
        Wed,  1 May 2019 11:29:53 -0700 (PDT)
Date:   Wed, 01 May 2019 14:29:48 -0400 (EDT)
Message-Id: <20190501.142948.1053446771181544161.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        andrew@lunn.ch, ilias.apalodimas@linaro.org, julia.lawall@lip6.fr,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: ethernet: ti: cpsw: Fix inconsistent
 IS_ERR and PTR_ERR in cpsw_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430015524.50997-1-yuehaibing@huawei.com>
References: <20190429143157.79035-1-yuehaibing@huawei.com>
        <20190430015524.50997-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 11:29:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 30 Apr 2019 01:55:24 +0000

> Fix inconsistent IS_ERR and PTR_ERR in cpsw_probe,
> The proper pointer to use is clk instead of mode.
> 
> This issue was detected with the help of Coccinelle.
> 
> Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v3: Fix commit log
> v2: add Fixes tag

Applied.
