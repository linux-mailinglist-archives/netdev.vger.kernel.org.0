Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FA66A09B
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbfGPCvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:51:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40274 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbfGPCvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:51:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so17922796qtn.7;
        Mon, 15 Jul 2019 19:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yZErbROM2VVb2DYbhf1qvTfxE9tFHSJiTJU7iwnRqzU=;
        b=qLDbyLF61NTuheT6jlkBiVZswXOTVaI8dY/Igg/2pduEO+8+WHB9eVULl+a+IOOABU
         VM97thx/H0rZzv7o8hXQnPMLX52qyidcAdLj1i4BY1h047+h9ZwsVtMG1hg+TklTBNAc
         kFatbrEym9mdhM4G55kAtH3oDKgWzBASRp4w8XCv4zvjHzmyS5mVDNczzVS1k3e/GQM+
         +EQJxtlupEQFdFUriN3Evr55VWshQpjXNc1uRdtjSDTZ/P1s9f4+/32+2lNT8GT22dfY
         kQNYTgD50QSqR3qegjBj1N2YcgGJx1t/s4H5sfBFYjWb1HaVeuFQV5xgbqpT8VMwYSKb
         ePAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yZErbROM2VVb2DYbhf1qvTfxE9tFHSJiTJU7iwnRqzU=;
        b=Xhx+x61RhSSQ5V3Oo+z5kK211HIrIC58aShWjk9ka2LbAwjetDJPrqzUYWhRaTYNmI
         FmqDJed4I+nkwl5JGRQSXPdaRFt0zNwGzQmbBHr94T/gdbBZILw4FbQcfYVLbRLcGf1w
         PlcJdax9r9J6PNv5x0oQ/0qCcNMcsmtMHb29v1EUxglNfpopbLccpChz7KI3OZ+yHdt2
         H8TWN2hsMSk3uP+4XMZql44UtA0OAaQ4Cqozw0TG29XTer4TQE2YAe4xAD7ae/+8rStz
         ois7rLrKDL8B80ECPhkuGsXQaIhCJUbKeDz23YIXzCo3JgW91aSmKMh+6n0sm9m2cyOq
         EzUQ==
X-Gm-Message-State: APjAAAVmXJpdTWlTSzl/iaD2bbJDrXbYl+iR1RpxScnUuLI+Pt6T20/s
        cWJCz/fEiOeHv+ll6czRMpM=
X-Google-Smtp-Source: APXvYqzQxLuadhwcbe2BI8TLAbrM2BpX1wvqd/8nPogvoqpfbXk0peqo3jY9CxnuUsuhl9okTX6upg==
X-Received: by 2002:ac8:2763:: with SMTP id h32mr21157340qth.350.1563245463548;
        Mon, 15 Jul 2019 19:51:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:fb15:23ad:df80:c177:921b])
        by smtp.gmail.com with ESMTPSA id q2sm8468473qkc.118.2019.07.15.19.51.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 19:51:02 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 3B189C18C6; Mon, 15 Jul 2019 23:51:00 -0300 (-03)
Date:   Mon, 15 Jul 2019 23:51:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: fix warning "NULL check before some freeing
 functions is not needed"
Message-ID: <20190716025100.GM3390@localhost.localdomain>
References: <20190716022002.GA19592@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716022002.GA19592@hari-Inspiron-1545>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 07:50:02AM +0530, Hariprasad Kelam wrote:
> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/sm_make_chunk.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ed39396..36bd8a6e 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2582,8 +2582,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  	case SCTP_PARAM_STATE_COOKIE:
>  		asoc->peer.cookie_len =
>  			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> -		if (asoc->peer.cookie)
> -			kfree(asoc->peer.cookie);
> +		kfree(asoc->peer.cookie);
>  		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>  		if (!asoc->peer.cookie)
>  			retval = 0;
> @@ -2648,8 +2647,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's random parameter */
> -		if (asoc->peer.peer_random)
> -			kfree(asoc->peer.peer_random);
> +		kfree(asoc->peer.peer_random);
>  		asoc->peer.peer_random = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_random) {
> @@ -2663,8 +2661,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  			goto fall_through;
>  
>  		/* Save peer's HMAC list */
> -		if (asoc->peer.peer_hmacs)
> -			kfree(asoc->peer.peer_hmacs);
> +		kfree(asoc->peer.peer_hmacs);
>  		asoc->peer.peer_hmacs = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_hmacs) {
> @@ -2680,8 +2677,7 @@ static int sctp_process_param(struct sctp_association *asoc,
>  		if (!ep->auth_enable)
>  			goto fall_through;
>  
> -		if (asoc->peer.peer_chunks)
> -			kfree(asoc->peer.peer_chunks);
> +		kfree(asoc->peer.peer_chunks);
>  		asoc->peer.peer_chunks = kmemdup(param.p,
>  					    ntohs(param.p->length), gfp);
>  		if (!asoc->peer.peer_chunks)
> -- 
> 2.7.4
> 
