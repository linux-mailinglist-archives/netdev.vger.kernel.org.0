Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66BE2997
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406776AbfJXEiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:38:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41944 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJXEiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:38:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF00914B7ED68;
        Wed, 23 Oct 2019 21:38:17 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:38:17 -0700 (PDT)
Message-Id: <20191023.213817.2144073595809552973.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: lan78xx: remove set but not used
 variable 'event'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023073626.33956-1-yuehaibing@huawei.com>
References: <20191023073626.33956-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 21:38:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 23 Oct 2019 15:36:26 +0800

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/usb/lan78xx.c:3995:6: warning:
>  variable event set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
