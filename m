Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AAC12B410
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 11:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfL0Krk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 05:47:40 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33854 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfL0Krk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 05:47:40 -0500
Received: by mail-pl1-f195.google.com with SMTP id x17so11598694pln.1;
        Fri, 27 Dec 2019 02:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xh6s+kG6tAG9qTrUepf8u2keTMCtOgTbyPfBGNFZV+g=;
        b=KA09z72J2E/wKA8KoesyIfvG3g78il0m0hRS9AYBvHJJX/XQFoftew/vYnHBGsVwkf
         6M52pJviiZ9OLGHcTUcPlWiv3GJr6mBfxIBzVJx+yPxErrBEZul6h/2DkoAY6xm8boKp
         mpRDsn3J5iFy5zJtbYZlTOJoNNak/Cxj0HaN5tyOBcPYHgKZjgmm0gM5J6Psi7FPtvuM
         Y/cW7Nkyy97nn84Yifs/S7UTgUeQkheYEx+Dtf3BqkNGffNz0/RIqGB4RDNE09aRfbnl
         kFnZDzlR4pC3BcB98ZLL0XOtdZL0pSFbT906/Kaj3T5nd9IvBidjdjaNNZzfi0mo8LAV
         fmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xh6s+kG6tAG9qTrUepf8u2keTMCtOgTbyPfBGNFZV+g=;
        b=BHFPmLzSLj4vqcScsqK2NbIykf8NRgDUZkJ5cmGY+fy9sP0baCATLgfexIITr040j+
         59ljcwUOUAKBIJqa+gMKQ/5kh72oapik4c5nC3d5LuxgdU/bV9jM18wVwVzZrmhVFI94
         eQ1U8gm2b+zy71KASfmOAlOQp3Maxw9gfVeUa7Eta1tSarmxRKwO64wOzYLrqK4lrLbp
         2w2bujt6PqkWbelrI2ZiEYBPg/bI7UbX3B4BD+x+sZtUTEMWFb+tdREi2mCGOo6/ameL
         dDE2t9W/1OfDYt6M7H2gUM8QxU/j4mPpiMQajnXfemiiHbwdn+NEyBZytZCI2cbVS8pv
         e5Fw==
X-Gm-Message-State: APjAAAUxuPiA1qpGxg/d722COjzUGAaN4HNix7Ay04bNIFV3aJBqWz/A
        b6NkEhgcLtBoh0g5F/WZdpSQ2OOGGTk=
X-Google-Smtp-Source: APXvYqzA554gljXLn5Iq8CJ6h02K5X5wTFsuXqC4AmgvE9j08cZuLXgkcQGSKRhqZ+pJtgYeMRj1sQ==
X-Received: by 2002:a17:90a:a416:: with SMTP id y22mr25648001pjp.114.1577443659340;
        Fri, 27 Dec 2019 02:47:39 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id l66sm37023222pga.30.2019.12.27.02.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 02:47:38 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B2548C0D74; Fri, 27 Dec 2019 07:47:35 -0300 (-03)
Date:   Fri, 27 Dec 2019 07:47:35 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCHv2 net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
Message-ID: <20191227104735.GO4444@localhost.localdomain>
References: <20191227080034.1323-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227080034.1323-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 08:00:34AM +0000, Kevin Kou wrote:
> The original patch bringed in the "SCTP ACK tracking trace event"
> feature was committed at Dec.20, 2017, it replaced jprobe usage
> with trace events, and bringed in two trace events, one is
> TRACE_EVENT(sctp_probe), another one is TRACE_EVENT(sctp_probe_path).
> The original patch intended to trigger the trace_sctp_probe_path in
> TRACE_EVENT(sctp_probe) as below code,
> 
> +TRACE_EVENT(sctp_probe,
> +
> +       TP_PROTO(const struct sctp_endpoint *ep,
> +                const struct sctp_association *asoc,
> +                struct sctp_chunk *chunk),
> +
> +       TP_ARGS(ep, asoc, chunk),
> +
> +       TP_STRUCT__entry(
> +               __field(__u64, asoc)
> +               __field(__u32, mark)
> +               __field(__u16, bind_port)
> +               __field(__u16, peer_port)
> +               __field(__u32, pathmtu)
> +               __field(__u32, rwnd)
> +               __field(__u16, unack_data)
> +       ),
> +
> +       TP_fast_assign(
> +               struct sk_buff *skb = chunk->skb;
> +
> +               __entry->asoc = (unsigned long)asoc;
> +               __entry->mark = skb->mark;
> +               __entry->bind_port = ep->base.bind_addr.port;
> +               __entry->peer_port = asoc->peer.port;
> +               __entry->pathmtu = asoc->pathmtu;
> +               __entry->rwnd = asoc->peer.rwnd;
> +               __entry->unack_data = asoc->unack_data;
> +
> +               if (trace_sctp_probe_path_enabled()) {
> +                       struct sctp_transport *sp;
> +
> +                       list_for_each_entry(sp, &asoc->peer.transport_addr_list,
> +                                           transports) {
> +                               trace_sctp_probe_path(sp, asoc);
> +                       }
> +               }
> +       ),
> 
> But I found it did not work when I did testing, and trace_sctp_probe_path
> had no output, I finally found that there is trace buffer lock
> operation(trace_event_buffer_reserve) in include/trace/trace_events.h:
> 
> static notrace void                                                     \
> trace_event_raw_event_##call(void *__data, proto)                       \
> {                                                                       \
>         struct trace_event_file *trace_file = __data;                   \
>         struct trace_event_data_offsets_##call __maybe_unused __data_offsets;\
>         struct trace_event_buffer fbuffer;                              \
>         struct trace_event_raw_##call *entry;                           \
>         int __data_size;                                                \
>                                                                         \
>         if (trace_trigger_soft_disabled(trace_file))                    \
>                 return;                                                 \
>                                                                         \
>         __data_size = trace_event_get_offsets_##call(&__data_offsets, args); \
>                                                                         \
>         entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>                                  sizeof(*entry) + __data_size);         \
>                                                                         \
>         if (!entry)                                                     \
>                 return;                                                 \
>                                                                         \
>         tstruct                                                         \
>                                                                         \
>         { assign; }                                                     \
>                                                                         \
>         trace_event_buffer_commit(&fbuffer);                            \
> }
> 
> The reason caused no output of trace_sctp_probe_path is that
> trace_sctp_probe_path written in TP_fast_assign part of
> TRACE_EVENT(sctp_probe), and it will be placed( { assign; } ) after the
> trace_event_buffer_reserve() when compiler expands Macro,
> 
>         entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>                                  sizeof(*entry) + __data_size);         \
>                                                                         \
>         if (!entry)                                                     \
>                 return;                                                 \
>                                                                         \
>         tstruct                                                         \
>                                                                         \
>         { assign; }                                                     \
> 
> so trace_sctp_probe_path finally can not acquire trace_event_buffer
> and return no output, that is to say the nest of tracepoint entry function
> is not allowed. The function call flow is:
> 
> trace_sctp_probe()
> -> trace_event_raw_event_sctp_probe()
>  -> lock buffer
>  -> trace_sctp_probe_path()
>    -> trace_event_raw_event_sctp_probe_path()  --nested
>    -> buffer has been locked and return no output.
> 
> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
> and trigger sctp_probe_path_trace in sctp_outq_sack.
> 
> After this patch, you can enable both events individually,
>   # cd /sys/kernel/debug/tracing
>   # echo 1 > events/sctp/sctp_probe/enable
>   # echo 1 > events/sctp/sctp_probe_path/enable
> 
> Or, you can enable all the events under sctp.
> 
>   # echo 1 > events/sctp/enable
> 
> v1->v2:
>  -add trace_sctp_probe_path_enabled check to avoid traversing the
>   transport list when the tracepoint is disabled as Marcelo's suggestion.

Oh, nice, thanks for taking the time to add it back.

Dave already applied your v1, so you actually need an incremental
patch now :-)

> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  include/trace/events/sctp.h | 9 ---------
>  net/sctp/outqueue.c         | 7 +++++++
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/events/sctp.h b/include/trace/events/sctp.h
> index 7475c7b..d4aac34 100644
> --- a/include/trace/events/sctp.h
> +++ b/include/trace/events/sctp.h
> @@ -75,15 +75,6 @@
>  		__entry->pathmtu = asoc->pathmtu;
>  		__entry->rwnd = asoc->peer.rwnd;
>  		__entry->unack_data = asoc->unack_data;
> -
> -		if (trace_sctp_probe_path_enabled()) {
> -			struct sctp_transport *sp;
> -
> -			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
> -					    transports) {
> -				trace_sctp_probe_path(sp, asoc);
> -			}
> -		}
>  	),
>  
>  	TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 0dab62b..83ddcfe 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -36,6 +36,7 @@
>  #include <net/sctp/sctp.h>
>  #include <net/sctp/sm.h>
>  #include <net/sctp/stream_sched.h>
> +#include <trace/events/sctp.h>
>  
>  /* Declare internal functions here.  */
>  static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn);
> @@ -1238,6 +1239,12 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
>  	/* Grab the association's destination address list. */
>  	transport_list = &asoc->peer.transport_addr_list;
>  
> +	/* SCTP path tracepoint for congestion control debugging. */
> +	if (trace_sctp_probe_path_enabled()) {
> +		list_for_each_entry(transport, transport_list, transports)
> +			trace_sctp_probe_path(transport, asoc);
> +	}
> +
>  	sack_ctsn = ntohl(sack->cum_tsn_ack);
>  	gap_ack_blocks = ntohs(sack->num_gap_ack_blocks);
>  	asoc->stats.gapcnt += gap_ack_blocks;
> -- 
> 1.8.3.1
> 
