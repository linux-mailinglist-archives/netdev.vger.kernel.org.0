Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A82381959
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 16:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhEOO0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 10:26:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231795AbhEOO0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 10:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p/OLxTmHXbKpgDdMoyvE1uiUVU0OJKRzTY1r1Lq8Vec=; b=x29SjRZiJlBOM5bvp71SE8gzMP
        4dKbyH+2Q7rUsNxypYygxgJytwit7Mmv4ssY5aUiB9V9SpUyRZtj6ip8MWRJRh9tWevapdPCG7XJM
        bFRT3DbkajUxnUIYH8gtKUKx1rioXvN0nl3lydinM6Qcj8MjL5MratwisS6jfJ3H3WEo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhvES-004Kqq-Qn; Sat, 15 May 2021 16:25:32 +0200
Date:   Sat, 15 May 2021 16:25:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH 04/34] net: atheros: atl1x: Fix wrong function name in
 comments
Message-ID: <YJ/Z3NM+sbz581D6@lunn.ch>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-5-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621076039-53986-5-git-send-email-shenyang39@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 06:53:29PM +0800, Yang Shen wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/ethernet/atheros/atlx/atl1.c:1020: warning: expecting prototype for atl1_setup_mem_resources(). Prototype was for atl1_setup_ring_resources() instead
> 
> Cc: Chris Snook <chris.snook@gmail.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
