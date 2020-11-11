Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BE02AE55B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbgKKBNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKKBNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:13:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A665121D46;
        Wed, 11 Nov 2020 01:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605057194;
        bh=16HYItG66V6WU6c8Fdsuoluq41PtqwCa8Bv4xeZylqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JtN9dD0rF8ioMSqxieYhOX4Mr+CeKMan82/WjchZ9p/arWP7hUmdGCmiLeZFhddxc
         4Em1rQ7s2BGmpre8+UdEjk8U817DN3ceiKhYiY6DQXEsSKijGrRx9FnXWHeKrgNuVN
         NqjUuzP86XY32cEikSUSSJJIulzQeNoux9ieZgXo=
Date:   Tue, 10 Nov 2020 17:13:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 01/11] net: hns3: add support for
 configuring interrupt quantity limiting
Message-ID: <20201110171312.66a031a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604892159-19990-2-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
        <1604892159-19990-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:22:29 +0800 Huazhong Tan wrote:
> +	if (rx_vector->tx_group.coal.ql_enable)
                       ^^^^^^^^

Is this supposed to be rx_group, not tx?

> +		hns3_set_vector_coalesce_rx_ql(rx_vector,
> +					       rx_vector->rx_group.coal.int_ql);
