Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA1BDD7C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391358AbfIYL5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:57:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfIYL5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:57:11 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CBE0154EC89A;
        Wed, 25 Sep 2019 04:57:09 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:57:07 +0200 (CEST)
Message-Id: <20190925.135707.1497165124050393808.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     claudiu.manoil@nxp.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] gianfar: Make reset_gfar static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923061603.37064-1-yuehaibing@huawei.com>
References: <20190923061603.37064-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:57:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Mon, 23 Sep 2019 14:16:03 +0800

> Fix sparse warning:
> 
> drivers/net/ethernet/freescale/gianfar.c:2070:6:
>  warning: symbol 'reset_gfar' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
