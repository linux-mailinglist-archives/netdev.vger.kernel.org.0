Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFF174CA5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391656AbfGYLOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388791AbfGYLOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 07:14:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABACE21901;
        Thu, 25 Jul 2019 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053257;
        bh=waVczpwrh6pnIoFCpGlxFz7cDpHgzuXb/1ydQioMguo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSoggm/2P6WTNJIke3rmcCIrRUszI+WPd2hVnjsG/6bamaGdunKS9ApcZ18291LuM
         z4n7cR04pDwpU0F9fmP1Mp1GBKZtteDW961BnQL3yENIvM+tE3+3lULQaJ5KyhdLIb
         HgV2/LXYbIVMpbrR9D05M111z/h33mJ4GlsiXmg4=
Date:   Thu, 25 Jul 2019 13:14:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     yuehaibing@huawei.com, bpoirier@suse.com,
        devel@driverdev.osuosl.org, GR-Linux-NIC-Dev@marvell.com,
        manishc@marvell.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] qlge: Fix build error without CONFIG_ETHERNET
Message-ID: <20190725111414.GB30958@kroah.com>
References: <20190724130126.53532-1-yuehaibing@huawei.com>
 <20190724.141202.10100086363454182.davem@davemloft.net>
 <20190724.141228.454330962921320879.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724.141228.454330962921320879.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 02:12:28PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 24 Jul 2019 14:12:02 -0700 (PDT)
> 
> > From: YueHaibing <yuehaibing@huawei.com>
> > Date: Wed, 24 Jul 2019 21:01:26 +0800
> > 
> >> Now if CONFIG_ETHERNET is not set, QLGE driver
> >> building fails:
> >> 
> >> drivers/staging/qlge/qlge_main.o: In function `qlge_remove':
> >> drivers/staging/qlge/qlge_main.c:4831: undefined reference to `unregister_netdev'
> >> 
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Fixes: 955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/staging/qlge/")
> >> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > 
> > I'll let Greg take this.
> 
> Actually, I take that back.
> 
> Since the move to staging happened in my tree I will take this ;-)

Thanks.  If you want to push that "move" to Linus soon, I can then take
any cleanup patches that show up for this driver, otherwise feel free to
ignore them until 5.4-rc1.

thanks,

greg k-h
