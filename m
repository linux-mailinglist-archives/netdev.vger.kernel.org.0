Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D912B4DE
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfL0NdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:33:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36668 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0NdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:33:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so14471952pgc.3;
        Fri, 27 Dec 2019 05:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QxA5SqsTWD1yfXg383i8MCZPV5Ex7TFJ83DrMqrjveY=;
        b=UYCFkY6T8wghVkfhz+CA+wHqte2EnNWSJfMRMQKq5dSynYy6ej7gcmNX0KgFfrDsA6
         D6z+YN2Vem4i9goKXZzS7rVuBj93y8Y0YxDq7Oyzajskkn7PHx8V0gu+KV7ihOXL9aRr
         oelGh+pTTDxtuCHTVevPoFijufquUKwUEaV/KJBLyFDF9VDYh7ENoImtyRQqzK5y4zpe
         8xWqh2EloqmFXwcASAENTIqL0vc2LQAjnEY57K9DaB6xmLTFXuYy4gRwusKgBwBEdhx6
         b5CliJR+MWYlE/00YdCM8ULM8Ql5EzGwuaAbMxePHJOO/a64joFv94jfROe1xhwj5QH/
         6u3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QxA5SqsTWD1yfXg383i8MCZPV5Ex7TFJ83DrMqrjveY=;
        b=oFL/0guKgEEeRPBtDQtiFpsDK+1oK4bfUy0Dmpzhl4wcwT9DU9NEgsPbgccUF/3EFO
         iGJ/FtIKbGTrJdmc2baQjehVKhSQAntWMB6A6S2HgJ78uxwbeE82taCy/Tsb+UQem57C
         Uen+788uLdecReH7L32Bokf88x34ucJlkWi8zWWiWJR6Vdh9dWrkUxQgYY2ov5n1LAl0
         Fof2zbgswwP4/joXYej/s2lLan1EcUawSeJPoS310MJJ/9qnMRdk8ymbM186xGlhmKMm
         gq75hFbj8JYcbYW/24YkeamfnDcI57xhRSQsGONURxBWWjAB8AtnPj/I+biKRwc0a6vz
         2rqw==
X-Gm-Message-State: APjAAAVpzRmsZ2YcIOS0xEy+W8BFx6LhSx7S6kOZxjzOSl7QAlXrT1PM
        ELn2CKXrxoVnPl6UBKXGerzPH8X6Na0=
X-Google-Smtp-Source: APXvYqxOszwT2fHt3U4ZbhFCmgxg3mhpRMXk+pDzi3VPq2fwF4n06CTbaOX5j1Sb2VwScoEmPf1dzA==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr52807072pfm.77.1577453591240;
        Fri, 27 Dec 2019 05:33:11 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id b8sm41685594pfr.64.2019.12.27.05.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 05:33:10 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 93596C0D74; Fri, 27 Dec 2019 10:33:07 -0300 (-03)
Date:   Fri, 27 Dec 2019 10:33:07 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCH net-next] sctp: add enabled check for path tracepoint
 loop.
Message-ID: <20191227133307.GP4444@localhost.localdomain>
References: <20191227131116.375-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227131116.375-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 01:11:16PM +0000, Kevin Kou wrote:
> sctp_outq_sack is the main function handles SACK, it is called very
> frequently. As the commit "move trace_sctp_probe_path into sctp_outq_sack"
> added below code to this function, sctp tracepoint is disabled most of time,
> but the loop of transport list will be always called even though the
> tracepoint is disabled, this is unnecessary.
> 
> +	/* SCTP path tracepoint for congestion control debugging. */
> +	list_for_each_entry(transport, transport_list, transports) {
> +		trace_sctp_probe_path(transport, asoc);
> +	}
> 
> This patch is to add tracepoint enabled check at outside of the loop of
> transport list, and avoid traversing the loop when trace is disabled,
> it is a small optimization.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Kevin.

Btw, I'm out for PTOs for the next 2 weeks. Probably won't be
reviewing patches during that.

> ---
>  net/sctp/outqueue.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index adceb22..83ddcfe 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1240,8 +1240,9 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
>  	transport_list = &asoc->peer.transport_addr_list;
>  
>  	/* SCTP path tracepoint for congestion control debugging. */
> -	list_for_each_entry(transport, transport_list, transports) {
> -		trace_sctp_probe_path(transport, asoc);
> +	if (trace_sctp_probe_path_enabled()) {
> +		list_for_each_entry(transport, transport_list, transports)
> +			trace_sctp_probe_path(transport, asoc);
>  	}
>  
>  	sack_ctsn = ntohl(sack->cum_tsn_ack);
> -- 
> 1.8.3.1
> 
