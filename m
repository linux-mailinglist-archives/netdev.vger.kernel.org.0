Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F6412A81F
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLYNHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 08:07:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40966 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYNHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 08:07:24 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so11975277pfw.8;
        Wed, 25 Dec 2019 05:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f4msYejz1CgfAS0PDopXbv0VGp58pQs3AmFecyIJFjU=;
        b=t7uNaJqE3eC76oMV8xP1AQ+7MeUTc5YaIsmt1NG5QhrKyYp3hH4ZyncqME8c/q7pWZ
         RZoXkYcKuPePN8pc5oDnkCT4bgO8Ek0/ymYv2SD/TS7YP59vxtpXmsVYbI8Om28JJsAt
         O0JHxZVniXfA7d4C+D/lrYYqBpSkB5CkkyO5E9LeF2+j8zWy5HMpl8sPpPqKatxO+2Eh
         urIt9+NsiIoUAUoGWS9uZkHpQGCZggPnn2MgeVRmXvSSs+DDhxB+cdKlxOQ8j9nAbHpo
         0tFiTIa0c6+Wfv2PHs5bCDbgfUszFflPotmi2b4n+BBHSJgIXldyLBVr1yJXCpx9NTEU
         S9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f4msYejz1CgfAS0PDopXbv0VGp58pQs3AmFecyIJFjU=;
        b=EYlzI9E5UIfwQe3/a1GHY6wxBAI8FD7GsCK04iPMajzx0fw6CbhYUllkXDC3JOOUZP
         2+Z3C8bhvoDU/wBlcZz5SNJUYKiR+Uu8D/FpTr0eQ4vMw40Bt14lHXPwcn2JqOMkHTNs
         BCvEjUuh3TB0j6VZnAgG/B1c4Kea6CW0IdimyckKXFjf74sklv4DqeDHuOR1ZxFptXTm
         CSKhn6qz1BmtOC+i4nv1XmUFISu35A1Ct9Zy16VSr1sG0mLHSVHymsBTetaBMaTUrHnV
         EKcrBKMWiedRi8xIrfhrlb28GhE5uC35svSCdtn7K6cdQLe56yBf+C6L7OSR7bq39FOe
         X0KQ==
X-Gm-Message-State: APjAAAXWO7JZkSBeYs897Aqs9MeWXyU0qXbCB83UNVsN6IZANWmVYoHj
        yAMnqjIb3pe5NPfnP+nd7an3ClBv9CA=
X-Google-Smtp-Source: APXvYqya+SVU33XUkWn6lmNJRrPJyOBODquBxyjiPHSKDUCz0nLX8t40deArAAKynwbzIMvLEmnYJw==
X-Received: by 2002:aa7:8699:: with SMTP id d25mr43247453pfo.139.1577279244019;
        Wed, 25 Dec 2019 05:07:24 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id j17sm5201897pfa.28.2019.12.25.05.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 05:07:23 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 62CC4C1BD3; Wed, 25 Dec 2019 10:07:20 -0300 (-03)
Date:   Wed, 25 Dec 2019 10:07:20 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCHv3 net-next] sctp: do trace_sctp_probe after SACK
 validation and check
Message-ID: <20191225130720.GM4444@localhost.localdomain>
References: <20191225082725.1251-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225082725.1251-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 08:27:25AM +0000, Kevin Kou wrote:
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
> v2->v3:
>  - regenerate the patch as v2 generated on top of v1, and add
>    'net-next' tag to the new one as Marcelo's comments.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Kevin.

> ---
>  net/sctp/sm_statefuns.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 42558fa..748e3b1 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3281,8 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	struct sctp_sackhdr *sackh;
>  	__u32 ctsn;
>  
> -	trace_sctp_probe(ep, asoc, chunk);
> -
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
>  
> @@ -3299,6 +3297,15 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
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
> @@ -3312,13 +3319,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
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
>  	/* Return this SACK for further processing.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>  
> -- 
> 1.8.3.1
> 
