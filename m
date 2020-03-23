Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852D518FE74
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgCWUJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:09:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51726 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCWUJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:09:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DE4515AD71CE;
        Mon, 23 Mar 2020 13:09:47 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:09:46 -0700 (PDT)
Message-Id: <20200323.130946.1354238320707238618.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leonro@mellanox.com
Subject: Re: [PATCH net-next] enetc: Remove unused variable 'enetc_drv_name'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319064637.45048-1-yuehaibing@huawei.com>
References: <20200319064637.45048-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 13:09:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 19 Mar 2020 14:46:37 +0800

> commit ed0a72e0de16 ("net/freescale: Clean drivers from static versions")
> leave behind this, remove it .
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
