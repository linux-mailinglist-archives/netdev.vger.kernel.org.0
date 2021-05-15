Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956E9381956
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEOOYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 10:24:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41788 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhEOOYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 10:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xozNellK473pCX0wLB9ECuthkCmJf67PDvYFkBr1G00=; b=JlwfhTbgiSzX/E5F7iZBv/z5U7
        3cfY3TCuft2wudZ08JzUF9l80YknviJYiK5v6jKGHF3PoBoaCyZZzP6PkoGRoxPCRDufe4r7XUbtl
        jHrGoZ/ukzvvbexaJKuHHjOC2uISw18o2Gf6Y24zXcLa6JGpLtI46YwEZEomm2sO2NyA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhvCQ-004KpE-4v; Sat, 15 May 2021 16:23:26 +0200
Date:   Sat, 15 May 2021 16:23:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH 03/34] net: atheros: atl1e: Fix wrong function name in
 comments
Message-ID: <YJ/ZXntyT3j55QwO@lunn.ch>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-4-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621076039-53986-4-git-send-email-shenyang39@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 06:53:28PM +0800, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c:367: warning: expecting prototype for atl1e_set_mac(). Prototype was for atl1e_set_mac_addr() instead
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c:796: warning: expecting prototype for atl1e_setup_mem_resources(). Prototype was for atl1e_setup_ring_resources() instead
> 
> Cc: Chris Snook <chris.snook@gmail.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
