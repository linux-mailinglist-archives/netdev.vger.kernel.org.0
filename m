Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7331D7E92
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgERQdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgERQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:33:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658C4207D8;
        Mon, 18 May 2020 16:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589819591;
        bh=e1nutUo+bt/dwDVowCltfxhY9z//j/ZMRT5xFzOJLUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BmWvNJRqfdhpBPwaCNDz/EPYcYhJ/UMz6fFMXu8U7Vd2b5zTAKkMruSIbABj3QRhU
         XXOl5gU9j/ULnkx3OJS03vHY0Ev/hjBdjFdzU0nz2eiMKfa8n/0Ra1YbDO1ZKUEYxZ
         SqaQKbp5P7E062+/dgtKpBsouO22VL2txHW48uHM=
Date:   Mon, 18 May 2020 09:33:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V6 18/20] net: ks8851: Implement Parallel bus operations
Message-ID: <20200518093309.5550c399@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200517003354.233373-19-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
        <20200517003354.233373-19-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 May 2020 02:33:52 +0200 Marek Vasut wrote:
> Implement accessors for KS8851-16MLL/MLLI/MLLU parallel bus variant of
> the KS8851. This is based off the ks8851_mll.c , which is a driver for
> exactly the same hardware, however the ks8851.c code is much higher
> quality. Hence, this patch pulls out the relevant information from the
> ks8851_mll.c on how to access the bus, but uses the common ks8851.c
> code. To make this patch reviewable, instead of rewriting ks8851_mll.c,
> ks8851_mll.c is removed in a separate subsequent patch.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Please test build with W=1

drivers/net/ethernet/micrel/ks8851_par.c:64:13: warning: context imbalance in 'ks8851_lock_par' - wrong count at exit
drivers/net/ethernet/micrel/ks8851_par.c:78:13: warning: context imbalance in 'ks8851_unlock_par' - unexpected unlock
