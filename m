Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1B12AE9F
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLZUxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:53:07 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40458 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZUxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:53:07 -0500
Received: by mail-pl1-f194.google.com with SMTP id s21so8134825plr.7;
        Thu, 26 Dec 2019 12:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BOJ+Bp2lzNQCDSB58EIQw+u7Fr4FdhFaCkWUtMTHSYQ=;
        b=Ku53PuJ2iF6avdrKMDP+LKVP+v4MAydY1pH6gIAlmo0AoHXHgpJzDSlaROIR8gfG2P
         XH/7iOWFJ2kIHGQRWINLfxMHS/GR5EttXcr0m+jT945X+bs3BKXAQ/sHwd18cLaNedGK
         Rh4mr7JoSYtBAhpExbEpE+Yn3vLduCebObbWS+MIDjsyo6G3GOJwxVWH/qrwkUH8EW6y
         iPh7C1Srpc6EHP0zeiDiKZvafOgjE+/osMCf7iSjzmboN131Ls3JJScQfq9STzsu4ftz
         wD26IB5hA+V+Y7eNjljjTigRCJ+zct5jdNth8xreONpByaxVQ8X2wmnGyeN8fKaEsdx+
         XsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BOJ+Bp2lzNQCDSB58EIQw+u7Fr4FdhFaCkWUtMTHSYQ=;
        b=GNrYSyZTjogO7v8bAjxPfdm4aVljFMUkR6UO0nUuuQk09a3pEACGmluT4E3PhBM0o6
         61roXeXQMkxj8fLsaSstAyHTiqBexz1Ie6jD1kkLNHs9rDNVudY7Lg7pCoUBo5IOsXgy
         kwdFWJ0glWwMU4qZnmrbjfwsOJs83s9FO0mOqTbpNWDuUj3BNAz7rAsn/6qstSYBrR2/
         J0mpo/HSETiUDgc8uQW5vbpMMCfJp2eFlghtUoj6YxCCaGPQkF0EI+h3PjVJapgG8qFT
         NFBrL9iMhA7dS20dj7051Htw9Tr+zKVkNjh3mfGIlMAolrXkd7ZsmaX+MSNzc97LVMCM
         4XWA==
X-Gm-Message-State: APjAAAVREcfQNZf9iIKrDnsoqfEVk+XkCGZ3ikPmeUEuOTYv0CJYsGzG
        uc9vqc1h3ABnrpyyEbKcvQE=
X-Google-Smtp-Source: APXvYqxxl6JQuCCv5eOIh5svidWLVY54ARqSseMEAx/16KQUTTCj1jYqy0SOjPDr+HTUeQxoWdrg0g==
X-Received: by 2002:a17:902:a5c1:: with SMTP id t1mr24634844plq.87.1577393585746;
        Thu, 26 Dec 2019 12:53:05 -0800 (PST)
Received: from localhost.localdomain ([168.181.48.206])
        by smtp.gmail.com with ESMTPSA id a18sm2806659pjq.30.2019.12.26.12.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 12:53:05 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 23971C3750; Thu, 26 Dec 2019 17:53:02 -0300 (-03)
Date:   Thu, 26 Dec 2019 17:53:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin Kou <qdkevin.kou@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, davem@davemloft.net
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
Message-ID: <20191226205302.GH5058@localhost.localdomain>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226122917.431-1-qdkevin.kou@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 12:29:17PM +0000, Kevin Kou wrote:
> The original patch bringed in the "SCTP ACK tracking trace event"
> feature was committed at Dec.20, 2017, it replaced jprobe usage
> with trace events, and bringed in two trace events, one is
> TRACE_EVENT(sctp_probe), another one is TRACE_EVENT(sctp_probe_path).
> The original patch intended to trigger the trace_sctp_probe_path in
> TRACE_EVENT(sctp_probe) as below code,
> 
> +TRACE_EVENT(sctp_probe,
> +
> +	TP_PROTO(const struct sctp_endpoint *ep,
> +		 const struct sctp_association *asoc,
> +		 struct sctp_chunk *chunk),
> +
> +	TP_ARGS(ep, asoc, chunk),
> +
> +	TP_STRUCT__entry(
> +		__field(__u64, asoc)
> +		__field(__u32, mark)
> +		__field(__u16, bind_port)
> +		__field(__u16, peer_port)
> +		__field(__u32, pathmtu)
> +		__field(__u32, rwnd)
> +		__field(__u16, unack_data)
> +	),
> +
> +	TP_fast_assign(
> +		struct sk_buff *skb = chunk->skb;
> +
> +		__entry->asoc = (unsigned long)asoc;
> +		__entry->mark = skb->mark;
> +		__entry->bind_port = ep->base.bind_addr.port;
> +		__entry->peer_port = asoc->peer.port;
> +		__entry->pathmtu = asoc->pathmtu;
> +		__entry->rwnd = asoc->peer.rwnd;
> +		__entry->unack_data = asoc->unack_data;
> +
> +		if (trace_sctp_probe_path_enabled()) {
> +			struct sctp_transport *sp;
> +
> +			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
> +					    transports) {
> +				trace_sctp_probe_path(sp, asoc);
> +			}
> +		}
> +	),
> 
> But I found it did not work when I did testing, and trace_sctp_probe_path
> had no output, I finally found that there is trace buffer lock
> operation(trace_event_buffer_reserve) in include/trace/trace_events.h:
> 
> static notrace void							\
> trace_event_raw_event_##call(void *__data, proto)			\
> {									\
> 	struct trace_event_file *trace_file = __data;			\
> 	struct trace_event_data_offsets_##call __maybe_unused __data_offsets;\
> 	struct trace_event_buffer fbuffer;				\
> 	struct trace_event_raw_##call *entry;				\
> 	int __data_size;						\
> 									\
> 	if (trace_trigger_soft_disabled(trace_file))			\
> 		return;							\
> 									\
> 	__data_size = trace_event_get_offsets_##call(&__data_offsets, args); \
> 									\
> 	entry = trace_event_buffer_reserve(&fbuffer, trace_file,	\
> 				 sizeof(*entry) + __data_size);		\
> 									\
> 	if (!entry)							\
> 		return;							\
> 									\
> 	tstruct								\
> 									\
> 	{ assign; }							\
> 									\
> 	trace_event_buffer_commit(&fbuffer);				\
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
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
