Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5791E311C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404384AbgEZVXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404259AbgEZVXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 17:23:34 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCB220870;
        Tue, 26 May 2020 21:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590528213;
        bh=eBpBQ6E1wdEbK85zMkV9Qr2NLcku0iEgiYihxgdzhqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NSgOlMSr1OkgSbe/oEqrSX2ozVqJAEokYa0D/akAJL1MsoVPUwOHaZ6gK4ZFFX7RL
         okSmO5perC2ZjUy/7kNq7cHDofPVqTtumf/Wg+yhFRiNBeFHHTq7s5wcmCW15l26Xc
         cfgXHnJYFfwxWuY2EA1cijZK+VzswG7MMcfUEg1U=
Date:   Tue, 26 May 2020 14:23:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@mellanox.com,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] crypto/chtls: IPv6 support for inline TLS
Message-ID: <20200526142332.24a398b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200525174447.3756-1-vinay.yadav@chelsio.com>
References: <20200525174447.3756-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 May 2020 23:14:47 +0530 Vinay Kumar Yadav wrote:
> Extends support to IPv6 for Inline TLS server.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

I don't think we want to take this TOE stuff further.

Please cc TCP folks on patches like this.

> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 413b3425ac66..456cb6648c05 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2110,6 +2110,7 @@ struct proto tcpv6_prot = {
>  #endif
>  	.diag_destroy		= tcp_abort,
>  };
> +EXPORT_SYMBOL(tcpv6_prot);
>  
>  /* thinking of making this const? Don't.
>   * early_demux can change based on sysctl.

