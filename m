Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927F6141A2
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfEERtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:49:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:49:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C11914DA7712;
        Sun,  5 May 2019 10:49:19 -0700 (PDT)
Date:   Sun, 05 May 2019 10:49:18 -0700 (PDT)
Message-Id: <20190505.104918.2058001310823108564.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     igor.russkikh@aquantia.com, dmitry.bogdanov@aquantia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: aquantia: Make aq_ndev_driver_name static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504095755.32556-1-yuehaibing@huawei.com>
References: <20190504095755.32556-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:49:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 4 May 2019 17:57:55 +0800

> Fix sparse warning:
> 
> drivers/net/ethernet/aquantia/atlantic/aq_main.c:26:12:
>  warning: symbol 'aq_ndev_driver_name' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
