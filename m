Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9C19C382
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgDBOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:01:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBOBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:01:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9A63128A133D;
        Thu,  2 Apr 2020 07:01:45 -0700 (PDT)
Date:   Thu, 02 Apr 2020 07:01:45 -0700 (PDT)
Message-Id: <20200402.070145.1146009613887902250.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     nishadkamdar@gmail.com, nico@fluxnic.net, masahiroy@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gakula@marvell.com
Subject: Re: [PATCH net] net: cavium: Fix build errors due to 'imply
 CAVIUM_PTP'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402132344.37864-1-yuehaibing@huawei.com>
References: <20200402132344.37864-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 07:01:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 2 Apr 2020 21:23:44 +0800

> If CAVIUM_PTP is m and THUNDER_NIC_VF is y, build fails:
> 
> drivers/net/ethernet/cavium/thunder/nicvf_main.o: In function 'nicvf_remove':
> nicvf_main.c:(.text+0x1f0): undefined reference to 'cavium_ptp_put'
> drivers/net/ethernet/cavium/thunder/nicvf_main.o: In function `nicvf_probe':
> nicvf_main.c:(.text+0x557c): undefined reference to 'cavium_ptp_get'
> 
> THUNDER_NIC_VF imply CAVIUM_PTP, which allow the config now,
> Use IS_REACHABLE() to avoid the vmlinux link error for this case.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: def2fbffe62c ("kconfig: allow symbols implied by y to become m")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
