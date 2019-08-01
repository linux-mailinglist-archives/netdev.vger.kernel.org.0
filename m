Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3D17E0E4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbfHARQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:16:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfHARQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:16:12 -0400
Received: from localhost (c-24-22-75-21.hsd1.or.comcast.net [24.22.75.21])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DBC5153F514A;
        Thu,  1 Aug 2019 10:16:11 -0700 (PDT)
Date:   Thu, 01 Aug 2019 13:16:11 -0400 (EDT)
Message-Id: <20190801.131611.1311620526429851961.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     timur@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: qcom/emac: use
 devm_platform_ioremap_resource() to simplify code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801123430.41672-1-yuehaibing@huawei.com>
References: <20190801123430.41672-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 10:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 1 Aug 2019 20:34:30 +0800

> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
