Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1462AE62F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbgKKCKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgKKCKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 21:10:34 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374E821D91;
        Wed, 11 Nov 2020 02:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605060633;
        bh=ZuE0JnTTvKWJ/NKhSx+6dXST8n7/KdV/Gmr1SEHMabM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ekp714TCByAciNz9UANyFwt4CMeyTeVzsRJYD1Kj8X1HLAAtw3gdRCTDZ3EaZ4JSQ
         UHhx91eCMpjXrzxny/qekpMA2h8j+1UWxOteb2KENsny0/vh63B7dDTwESKSS/QQqV
         F1dPZaVIAIYxcBABsBmMVX0bkLujX6OE+8Jy05J0=
Date:   Tue, 10 Nov 2020 18:10:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net v2 0/2] net/iucv: fixes 2020-11-09
Message-ID: <20201110181032.55e4a320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109075706.56573-1-jwi@linux.ibm.com>
References: <20201109075706.56573-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 08:57:04 +0100 Julian Wiedmann wrote:
> Hi Jakub,
> 
> please apply the following patch series to netdev's net tree.
> 
> One fix in the shutdown path for af_iucv sockets. This is relevant for
> stable as well.
> Also sending along an update for the Maintainers file.
> 
> v1 -> v2: use the correct Fixes tag in patch 1 (Jakub)

Applied, and queued, thanks!
