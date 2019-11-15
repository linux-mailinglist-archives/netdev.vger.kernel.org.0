Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF89FE642
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKOUOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:14:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfKOUOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:14:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E4B1214E0DA63;
        Fri, 15 Nov 2019 12:14:15 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:14:15 -0800 (PST)
Message-Id: <20191115.121415.1822375480431062908.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     f.fainelli@gmail.com, jiri@mellanox.com, geert+renesas@glider.be,
        jakub.kicinski@netronome.com, gospo@broadcom.com,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] cnic: Fix Kconfig warning without MMU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114090219.38344-1-yuehaibing@huawei.com>
References: <20191114090219.38344-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:14:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 14 Nov 2019 17:02:19 +0800

> If MMU is not set, Kconfig warning this:
> 
> WARNING: unmet direct dependencies detected for UIO
>   Depends on [n]: MMU [=n]
>   Selected by [y]:
>   - CNIC [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n)
> 
> Make CNIC depend on UIO instead of select it to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

This makes no sense, if you need MMU then guard on MMU.

UIO is for userspace device drivers, and not something that CNIC
requires.
