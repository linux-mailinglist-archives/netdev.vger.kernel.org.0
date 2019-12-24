Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB48212A1A9
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 14:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfLXNQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 08:16:47 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36142 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfLXNQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 08:16:47 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so10771222pfb.3;
        Tue, 24 Dec 2019 05:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bstnB/1EaO4qRs/zLzG2aa8xc4+tYmGgwMZkMsaHh6Y=;
        b=mf2+MEe7S1Q+dTmA7wH2GBn1w7RFViKeZHWq7NvpOXTA4q/4qkOFnpiL9bdF4iMMNW
         aWySAN2n9Vp3/iiRAd7Cm4UxUEZ52/Xz3XtKBd+2nHQix4iEruF6cOfU/9YKa3wZHpTw
         ou4+BoZ29CJYIDajIOfjl3B1FOtWhDILcaH8OSiWh3ZZiLsgDbxwR9FlEm9D7+wfGAU8
         porPbaWDmAlApR0ae8W5yRPxFY36WxZCsDbJO9LFpdfmSQFbw76rFVBtc2SQfIQAfgpB
         wINoR32fHywI6jo/jZDQDzkUPlV4um/ZHN5n1+HxiX3iO5TT19s1MbUUBtlqKXfbHMtd
         iJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bstnB/1EaO4qRs/zLzG2aa8xc4+tYmGgwMZkMsaHh6Y=;
        b=WROVzCFVvuJ79k/x4TZJJnUzcLafYwv9XDZ/jmMhPMe62aWqA4m2jIVqqZdqw85Uho
         9X0Lw/VVVs0w+Qn8/Sl8UXrE1emSBzzeThD6VM940Wak4JsLkIwT16Jdci+cyVMQlvzL
         hIg98hSZxEAf0+ou6WS/odE79ROj+DTlviD7pgG8QiDibYIbV7Iwvb0cHgvFqQXFRuDk
         p9TXYNzQwpJSILKe6lG5m4/t8FkW9/WlZIUsfYhEkSPz4UzYA3cjK3t6fOx93tCz92++
         M0JUieD6eqe4C/jX5rO+0/GC8mx9QH8UdxpQWiVhkCafKCbImU4AFjQU+PP6K6viYBR4
         VbVg==
X-Gm-Message-State: APjAAAV/L6F1RifePoko28h87wEIz9FMLALQxSpnbcIcqfJ87aE1A8xD
        0rny+6f1O22OXosyxyOhhZxpTOEo9a+svA==
X-Google-Smtp-Source: APXvYqyGRwzmuUQoGYqaqi7K0ihlue1fJ1soX1uNKOR7dv0poUiCn4R1G+IwmGDuhCGpQA5cMcAzSw==
X-Received: by 2002:aa7:9af1:: with SMTP id y17mr37843934pfp.21.1577193406768;
        Tue, 24 Dec 2019 05:16:46 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id x65sm29819959pfb.171.2019.12.24.05.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 05:16:45 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CD9FEC1890; Tue, 24 Dec 2019 10:16:42 -0300 (-03)
Date:   Tue, 24 Dec 2019 10:16:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCH v2] sctp: do trace_sctp_probe after SACK validation and
 check
Message-ID: <20191224131642.GG5058@localhost.localdomain>
References: <20191224104040.511-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224104040.511-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 10:40:40AM +0000, Kevin Kou wrote:
> The function sctp_sf_eat_sack_6_2 now performs the Verification
> Tag validation, Chunk length validation, Bogu check, and also
> the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> this patch is to do the trace_sctp_probe after the chunk sanity
> tests, but keep doing trace if the SACK received is out of order,
> for the out-of-order SACK is valuable to congestion control
> debugging.
> 
> v1->v2:
>  - keep doing SCTP trace if the SACK is out of order as Marcelo's
>    suggestion.

Thanks, but you generated the v2 on top of v1. You need to generate
the patch as if v1 didn't get applied (because it is not going in).

For future reference, if it would be a follow-up, then it wouldn't be
a "v2"..

And you need to explicit tag the patch with 'net' or 'net-next',
indicating which tree you target. net is for fixes, net-next for
cleanups/new features. net-next is good here.

Thanks,
Marcelo

> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index b4a54df..d302a78 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3298,6 +3298,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	chunk->subh.sack_hdr = sackh;
>  	ctsn = ntohl(sackh->cum_tsn_ack);
>  
> +	/* If Cumulative TSN Ack beyond the max tsn currently
> +	 * send, terminating the association and respond to the
> +	 * sender with an ABORT.
> +	 */
> +	if (TSN_lte(asoc->next_tsn, ctsn))
> +		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
> +
> +	trace_sctp_probe(ep, asoc, chunk);
> +
>  	/* i) If Cumulative TSN Ack is less than the Cumulative TSN
>  	 *     Ack Point, then drop the SACK.  Since Cumulative TSN
>  	 *     Ack is monotonically increasing, a SACK whose
> @@ -3311,15 +3320,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  		return SCTP_DISPOSITION_DISCARD;
>  	}
>  
> -	/* If Cumulative TSN Ack beyond the max tsn currently
> -	 * send, terminating the association and respond to the
> -	 * sender with an ABORT.
> -	 */
> -	if (!TSN_lt(ctsn, asoc->next_tsn))
> -		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
> -
> -	trace_sctp_probe(ep, asoc, chunk);
> -
>  	/* Return this SACK for further processing.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>  
> -- 
> 1.8.3.1
> 
