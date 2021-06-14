Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF93A696C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhFNO7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbhFNO7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:59:03 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255F0C061574;
        Mon, 14 Jun 2021 07:57:00 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id 99C036210; Mon, 14 Jun 2021 10:56:59 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 99C036210
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1623682619;
        bh=Nig4SRLFwGTkSDjGzkaXTrnIYKCs+LArMeR6OvYivBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QnqBevZr597BwRamPTMics1AmDeLp4Mh2JrqVI8lYIk0rPPxsNS9IN5faX6TaZGPC
         BiLI2cuRLMytAyyXZEQOPpATQ12RASHYhw8cGv3yJoH6uqJjgWSAzy9rWea74C6woj
         UFLWJS2ReEAjN+kAvQRTrcgrU6gh6zhZKZaNqY9A=
Date:   Mon, 14 Jun 2021 10:56:59 -0400
From:   "J . Bruce Fields" <bfields@fieldses.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rpc: remove redundant initialization of variable status
Message-ID: <20210614145659.GA13304@fieldses.org>
References: <20210613140652.75190-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613140652.75190-1-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, applied.--b.

On Sun, Jun 13, 2021 at 03:06:52PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable status is being initialized with a value that is never
> read, the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index 6dff64374bfe..a81be45f40d9 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -1275,7 +1275,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
>  	long long ctxh;
>  	struct gss_api_mech *gm = NULL;
>  	time64_t expiry;
> -	int status = -EINVAL;
> +	int status;
>  
>  	memset(&rsci, 0, sizeof(rsci));
>  	/* context handle */
> -- 
> 2.31.1
