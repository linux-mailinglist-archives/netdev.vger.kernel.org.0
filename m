Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 696A612807C
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfLTQSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:18:01 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34869 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTQSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:18:01 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so48001pfo.2;
        Fri, 20 Dec 2019 08:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AqkgzktUk7nsSLM/WAVDti6Aflq7wK5MTqZ2lh/ZIII=;
        b=E3ngOCH4+SL4XA6LQr2XXpt8CEw4OsC4BwMvz9V8vqB5U0z/6UcKklx8sLc3sNExMH
         GtjEP/t5weYM3zN14IHA0HihpqxCQiCcV5EnrSAvF+bEY76fBzVfvA76S3oFuKmJNcdb
         PvVRhU+6qwKESf5lbvPshTzNIYhPy8q9pTm3K6+fLc4eyB/0AHNRExDii8osHS5mOMb+
         BnkClbcg83CJVP1rHwok/Lnpxt0Pjzlbz9N3P4dsDkLnY9Qo64dzAMDqgmRZEEsBjnBH
         y9tljtfFWwaXZ3ZEwC7wiEMtXSkqRGgiDugBa9zbttpoiGsJIQ0LVXoPaPI68sTZCbJM
         kY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AqkgzktUk7nsSLM/WAVDti6Aflq7wK5MTqZ2lh/ZIII=;
        b=B6I5yCdYUm/rh9nE+3rXbLHTlyBM30unM1bhyXFRlT9otREaeGwJ1wOCijqCUUM/Ts
         UgWcYkFQoUiZwKUKlscGK7ga6zmrQffov8iQIvpju7mByz8AjziwCB0x0aTNrtZIfNzn
         SbtERQE1AvQpk9/W7k9GD8oItEqgmpiyGevUiaR+qD6Xq/HrDeUqmaOSXMQTVuxXpkMv
         z0nKRK+5zSqDRb01po8whc8TLJlQEckkF7IJ0Vs3czLJByROF8l3ploduqRn62YyA1J9
         BVy1X9YJJPD0RIBi0ylRh4z9FQ2HoM7F3wv80xKkF3IvrW04ylyEFzYO780M58PkKf9S
         6QAw==
X-Gm-Message-State: APjAAAUdwrhXmnCZ5o0mixmmcA2f8SiGVMgeOQQyIqnWiHebyCosCch6
        ekuem27HIShVK1torR2BzRg=
X-Google-Smtp-Source: APXvYqy4SOv1qzQ7lBfnjpE+QlCZbQ3RDwk1EnvAKPtPfBtw8osJz0TIReDLfMZ96mFI3Fd4XiFcQw==
X-Received: by 2002:a62:cec3:: with SMTP id y186mr16642630pfg.129.1576858680592;
        Fri, 20 Dec 2019 08:18:00 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:b9c8:9c5e:a64b:e068:9fbd])
        by smtp.gmail.com with ESMTPSA id k60sm11472356pjh.22.2019.12.20.08.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 08:17:59 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E8497C161F; Fri, 20 Dec 2019 13:17:56 -0300 (-03)
Date:   Fri, 20 Dec 2019 13:17:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: do trace_sctp_probe after SACK validation and check
Message-ID: <20191220161756.GE5058@localhost.localdomain>
References: <20191220044703.88-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220044703.88-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 04:47:03AM +0000, Kevin Kou wrote:
> The function sctp_sf_eat_sack_6_2 now performs
> the Verification Tag validation, Chunk length validation, Bogu check,
> and also the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> This patch is to do the trace_sctp_probe after the necessary check
> and validation to SACK.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  net/sctp/sm_statefuns.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 42558fa..b4a54df 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -3281,7 +3281,6 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	struct sctp_sackhdr *sackh;
>  	__u32 ctsn;
>  
> -	trace_sctp_probe(ep, asoc, chunk);
>  
>  	if (!sctp_vtag_verify(chunk, asoc))
>  		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> @@ -3319,6 +3318,8 @@ enum sctp_disposition sctp_sf_eat_sack_6_2(struct net *net,
>  	if (!TSN_lt(ctsn, asoc->next_tsn))
>  		return sctp_sf_violation_ctsn(net, ep, asoc, type, arg, commands);
>  
> +	trace_sctp_probe(ep, asoc, chunk);
> +

Moving it here will be after the check against ctsn_ack_point, which
could cause duplicated SACKs to be missed from the log.

Yes, from the sender-side CC we don't care about it (yet), but it
helps to spot probably avoidable retransmissions.

I think this is cleaning up the noise too much. I can agree with
moving it to after the chunk sanity tests, though.

>  	/* Return this SACK for further processing.  */
>  	sctp_add_cmd_sf(commands, SCTP_CMD_PROCESS_SACK, SCTP_CHUNK(chunk));
>  
> -- 
> 1.8.3.1
> 
