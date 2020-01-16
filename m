Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6310713DC01
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgAPNbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgAPNbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:31:38 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4048207E0;
        Thu, 16 Jan 2020 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579181498;
        bh=crblO558LGiGCWytSCUuU11G0Dyhp4d0qeM7544ApqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TlffI7oLh12zrTDkNF+oi214C9rfqLFPmOqF43dh47yQxdqzHTfLkEr3FhPE/87em
         NWATxms/hlOpXG1dz7HBZjRkuYebQ5NbWFMf5L62WUvmdFFvI4NZcXwgmabEF4SvAs
         lSpJdGzxams3UqMhc3QPQWhgDycKhQVrbmA9nCVQ=
Date:   Thu, 16 Jan 2020 05:31:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hongbo Yao <yaohongbo@huawei.com>
Cc:     <chenzhou10@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 -next] drivers/net: netdevsim depends on INET
Message-ID: <20200116053137.4b9f9ff9@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200116131404.169423-1-yaohongbo@huawei.com>
References: <20200116131404.169423-1-yaohongbo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 21:14:04 +0800, Hongbo Yao wrote:
> If CONFIG_INET is not set and CONFIG_NETDEVSIM=y.
> Building drivers/net/netdevsim/fib.o will get the following error:
> 
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_hw_flags_set':
> fib.c:(.text+0x12b): undefined reference to `fib_alias_hw_flags_set'
> drivers/net/netdevsim/fib.o: In function `nsim_fib4_rt_destroy':
> fib.c:(.text+0xb11): undefined reference to `free_fib_info'
> 
> Correct the Kconfig for netdevsim.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 48bb9eb47b270("netdevsim: fib: Add dummy implementation for FIB offload")

Looks better :) Still missing a space between the hash and the bracket,
but:

Acked-by: Jakub Kicinski <kuba@kernel.org>

While at it - does mlxsw have the same problem by any chance?
