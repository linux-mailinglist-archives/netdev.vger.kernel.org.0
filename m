Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED26A251FAC
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHYTSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 15:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:18:15 -0400
X-Greylist: delayed 554 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Aug 2020 12:18:14 PDT
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAD4C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 12:18:14 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id A86DC7AAB; Tue, 25 Aug 2020 15:08:57 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org A86DC7AAB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1598382537;
        bh=I0JFe4GcFukORtxs5qTvSrfssxpDhIRhbmQB2ue9tqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W6yt2juzNqxepvsntjpyskouacsnozXgtL9HKNHfZtWsy34NrJO0c2mplutOKc0i0
         Z2gKZoDorkG9N/j2IEQ6G4jIN3M7bjjNzsl84RSPsuvMGV3fm5cujoE0rQo9G1ve7O
         9yGWIbiekyoCW6sFnotgo0q6lIvIyxjflv4MGQjE=
Date:   Tue, 25 Aug 2020 15:08:57 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH] net: sunrpc: delete repeated words
Message-ID: <20200825190857.GA1955@fieldses.org>
References: <20200823010738.4837-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823010738.4837-1-rdunlap@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applied, thanks.--b.

On Sat, Aug 22, 2020 at 06:07:38PM -0700, Randy Dunlap wrote:
> Drop duplicate words in net/sunrpc/.
> Also fix "Anyone" to be "Any one".
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: linux-nfs@vger.kernel.org
> ---
>  net/sunrpc/backchannel_rqst.c     |    2 +-
>  net/sunrpc/xdr.c                  |    2 +-
>  net/sunrpc/xprtrdma/svc_rdma_rw.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-next-20200821.orig/net/sunrpc/backchannel_rqst.c
> +++ linux-next-20200821/net/sunrpc/backchannel_rqst.c
> @@ -111,7 +111,7 @@ out_free:
>   * by the backchannel.  This function can be called multiple times
>   * when creating new sessions that use the same rpc_xprt.  The
>   * preallocated buffers are added to the pool of resources used by
> - * the rpc_xprt.  Anyone of these resources may be used used by an
> + * the rpc_xprt.  Any one of these resources may be used by an
>   * incoming callback request.  It's up to the higher levels in the
>   * stack to enforce that the maximum number of session slots is not
>   * being exceeded.
> --- linux-next-20200821.orig/net/sunrpc/xdr.c
> +++ linux-next-20200821/net/sunrpc/xdr.c
> @@ -658,7 +658,7 @@ EXPORT_SYMBOL_GPL(xdr_reserve_space);
>   * head, tail, and page lengths are adjusted to correspond.
>   *
>   * If this means moving xdr->p to a different buffer, we assume that
> - * that the end pointer should be set to the end of the current page,
> + * the end pointer should be set to the end of the current page,
>   * except in the case of the head buffer when we assume the head
>   * buffer's current length represents the end of the available buffer.
>   *
> --- linux-next-20200821.orig/net/sunrpc/xprtrdma/svc_rdma_rw.c
> +++ linux-next-20200821/net/sunrpc/xprtrdma/svc_rdma_rw.c
> @@ -137,7 +137,7 @@ static int svc_rdma_rw_ctx_init(struct s
>  }
>  
>  /* A chunk context tracks all I/O for moving one Read or Write
> - * chunk. This is a a set of rdma_rw's that handle data movement
> + * chunk. This is a set of rdma_rw's that handle data movement
>   * for all segments of one chunk.
>   *
>   * These are small, acquired with a single allocator call, and
