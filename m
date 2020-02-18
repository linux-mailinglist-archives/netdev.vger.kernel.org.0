Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA041620F2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBRGdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:33:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgBRGdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 01:33:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03AD115B48536;
        Mon, 17 Feb 2020 22:33:22 -0800 (PST)
Date:   Mon, 17 Feb 2020 22:33:20 -0800 (PST)
Message-Id: <20200217.223320.1107717283396960655.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ena: remove set but not used variable
 'hash_key'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218062154.3724-1-yuehaibing@huawei.com>
References: <20200218062154.3724-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 22:33:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 18 Feb 2020 14:21:54 +0800

> drivers/net/ethernet/amazon/ena/ena_com.c: In function ena_com_hash_key_allocate:
> drivers/net/ethernet/amazon/ena/ena_com.c:1070:50:
>  warning: variable hash_key set but not used [-Wunused-but-set-variable]
> 
> commit 6a4f7dc82d1e ("net: ena: rss: do not allocate key when not supported")
> introduced this, but not used, so remove it.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
