Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A89418E6D
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfEIQuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:50:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfEIQuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:50:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9367114D0873D;
        Thu,  9 May 2019 09:50:15 -0700 (PDT)
Date:   Thu, 09 May 2019 09:50:15 -0700 (PDT)
Message-Id: <20190509.095015.756311298864539257.davem@davemloft.net>
To:     wangkefeng.wang@huawei.com
Cc:     yana.esina@aquantia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hulkci@huawei.com
Subject: Re: [PATCH] net: aquantia: fix undefined
 devm_hwmon_device_register_with_info reference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509153235.103441-1-wangkefeng.wang@huawei.com>
References: <20190509153235.103441-1-wangkefeng.wang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:50:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Date: Thu, 9 May 2019 23:32:35 +0800

> drivers/net/ethernet/aquantia/atlantic/aq_drvinfo.o: In function `aq_drvinfo_init':
> aq_drvinfo.c:(.text+0xe8): undefined reference to `devm_hwmon_device_register_with_info'
> 
> Fix it by using #if IS_REACHABLE(CONFIG_HWMON).
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Applied.

It's a shame there isn't a dummy inline of this helper defined when HWMON is unset.
