Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC2E1982C7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgC3Rx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:53:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC3Rx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:53:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6633715C3E1E0;
        Mon, 30 Mar 2020 10:53:58 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:53:57 -0700 (PDT)
Message-Id: <20200330.105357.1533343794798331798.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     madalin.bucur@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dpaa_eth: Make dpaa_a050385_wa static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328030415.19044-1-yuehaibing@huawei.com>
References: <20200328030415.19044-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:53:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 28 Mar 2020 11:04:15 +0800

> Fix sparse warning:
> 
> drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2065:5:
>  warning: symbol 'dpaa_a050385_wa' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
