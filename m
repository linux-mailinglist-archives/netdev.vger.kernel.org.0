Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28F31982CA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbgC3RyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:54:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC3RyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:54:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58DC215C3E1E5;
        Mon, 30 Mar 2020 10:54:04 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:54:03 -0700 (PDT)
Message-Id: <20200330.105403.320116364701708266.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: ena: Make some functions static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200328030620.22328-1-yuehaibing@huawei.com>
References: <20200328030620.22328-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:54:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 28 Mar 2020 11:06:20 +0800

> Fix sparse warnings:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:460:6: warning: symbol 'ena_xdp_exchange_program_rx_in_range' was not declared. Should it be static?
> drivers/net/ethernet/amazon/ena/ena_netdev.c:481:6: warning: symbol 'ena_xdp_exchange_program' was not declared. Should it be static?
> drivers/net/ethernet/amazon/ena/ena_netdev.c:1555:5: warning: symbol 'ena_xdp_handle_buff' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
