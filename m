Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571DE12B447
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 12:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfL0Lm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 06:42:59 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37053 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0Lm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 06:42:59 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so4819417pjb.2;
        Fri, 27 Dec 2019 03:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jJF8kjep67llZQuxPFi7LCBjoViRDyvzLEkS24n12TU=;
        b=bj+jLVWqUXXxClcRUoJfQcMnPb3MEfH4UXvidX5IV6gtADDRQfpJrUWOvKETS9T2Ls
         jtXBblo2OmmhFsiUpYO9neVKyxhFeeGHglI/gUJu3yDvKXuLkDZtCK51WXLTJrux/4NP
         rkAOXd4TDFJrAgiCfy/plAT5oO0+SvtyvXmCEbmaK+WeSlJe4/hDT1nlccJ44PnPg4/2
         Z3OiNOqyfTyYvggWbRPKVcrJ/iGw+9QYk7S+MSaG9CWQcX6R4qGNihP0lAy8GcwD9pJV
         nQhoMae/68KwVYChmSFO+AGaq0gy6r+L7F3TCFnoSNllkzDpKvsitMsGdmPWaQESfJXV
         Xb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jJF8kjep67llZQuxPFi7LCBjoViRDyvzLEkS24n12TU=;
        b=RL+zubxxdzs6pnCXQkgTjLWwQDYrQ3MsbX3V1QRICfyH49Tg68dPq9sZCfg6wgQw/Y
         sY5QWpt6kgM/rpktQd4SNW2FURHenH9BNVxSSC3Y/XHBZ/+48DnIPQ6UNgysxI5QBeoC
         5X0i9Ww9I3wPzyEWU0tiyZzHnSb6IXswMT45fdiGyi+qhW54Vg9m7KU5B/hj4Isbjwi6
         DCxfsaaUdhfm17ITuL/VppeBtJ9A9hGxFeSBr6+HRTXTEhLxsuCwSMt5AAIH5s37QMwb
         tsvRxsXW2XT6U8o0OfjOG+ajoYCUkvgYhc/bFHe4C6fGBdwhkUgELMHYFcwg4liIOYHf
         Rkmg==
X-Gm-Message-State: APjAAAVpYvNt0ZAcF5he1ugkrRK/aH7iOPiV7wrfW559/12u4fDEz/Ts
        Tb13sW2/eISZuFNbMR4+S7o=
X-Google-Smtp-Source: APXvYqzChT9lmaLTfOsvbl52twxil/yN6S6VxY7M48uIg6/8wNDvktYHObCYhTryHMTW/yD+XPo8Ew==
X-Received: by 2002:a17:902:bc45:: with SMTP id t5mr50590478plz.163.1577446978052;
        Fri, 27 Dec 2019 03:42:58 -0800 (PST)
Received: from ?IPv6:2408:8215:b21:57c1:d8e7:fc85:a755:1213? ([2408:8215:b21:57c1:d8e7:fc85:a755:1213])
        by smtp.gmail.com with ESMTPSA id f30sm37058851pga.20.2019.12.27.03.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 03:42:56 -0800 (PST)
Subject: Re: [PATCHv2 net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, davem@davemloft.net
References: <20191227080034.1323-1-qdkevin.kou@gmail.com>
 <20191227104735.GO4444@localhost.localdomain>
From:   Kevin Kou <qdkevin.kou@gmail.com>
Message-ID: <9348606c-7701-1863-3edf-820421082f2c@gmail.com>
Date:   Fri, 27 Dec 2019 19:42:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101
 Thunderbird/72.0
MIME-Version: 1.0
In-Reply-To: <20191227104735.GO4444@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/27 18:47, Marcelo Ricardo Leitner wrote:
> On Fri, Dec 27, 2019 at 08:00:34AM +0000, Kevin Kou wrote:
>> The original patch bringed in the "SCTP ACK tracking trace event"
>> feature was committed at Dec.20, 2017, it replaced jprobe usage
>> with trace events, and bringed in two trace events, one is
>> TRACE_EVENT(sctp_probe), another one is TRACE_EVENT(sctp_probe_path).
>> The original patch intended to trigger the trace_sctp_probe_path in
>> TRACE_EVENT(sctp_probe) as below code,
>>
>> +TRACE_EVENT(sctp_probe,
>> +
>> +       TP_PROTO(const struct sctp_endpoint *ep,
>> +                const struct sctp_association *asoc,
>> +                struct sctp_chunk *chunk),
>> +
>> +       TP_ARGS(ep, asoc, chunk),
>> +
>> +       TP_STRUCT__entry(
>> +               __field(__u64, asoc)
>> +               __field(__u32, mark)
>> +               __field(__u16, bind_port)
>> +               __field(__u16, peer_port)
>> +               __field(__u32, pathmtu)
>> +               __field(__u32, rwnd)
>> +               __field(__u16, unack_data)
>> +       ),
>> +
>> +       TP_fast_assign(
>> +               struct sk_buff *skb = chunk->skb;
>> +
>> +               __entry->asoc = (unsigned long)asoc;
>> +               __entry->mark = skb->mark;
>> +               __entry->bind_port = ep->base.bind_addr.port;
>> +               __entry->peer_port = asoc->peer.port;
>> +               __entry->pathmtu = asoc->pathmtu;
>> +               __entry->rwnd = asoc->peer.rwnd;
>> +               __entry->unack_data = asoc->unack_data;
>> +
>> +               if (trace_sctp_probe_path_enabled()) {
>> +                       struct sctp_transport *sp;
>> +
>> +                       list_for_each_entry(sp, &asoc->peer.transport_addr_list,
>> +                                           transports) {
>> +                               trace_sctp_probe_path(sp, asoc);
>> +                       }
>> +               }
>> +       ),
>>
>> But I found it did not work when I did testing, and trace_sctp_probe_path
>> had no output, I finally found that there is trace buffer lock
>> operation(trace_event_buffer_reserve) in include/trace/trace_events.h:
>>
>> static notrace void                                                     \
>> trace_event_raw_event_##call(void *__data, proto)                       \
>> {                                                                       \
>>          struct trace_event_file *trace_file = __data;                   \
>>          struct trace_event_data_offsets_##call __maybe_unused __data_offsets;\
>>          struct trace_event_buffer fbuffer;                              \
>>          struct trace_event_raw_##call *entry;                           \
>>          int __data_size;                                                \
>>                                                                          \
>>          if (trace_trigger_soft_disabled(trace_file))                    \
>>                  return;                                                 \
>>                                                                          \
>>          __data_size = trace_event_get_offsets_##call(&__data_offsets, args); \
>>                                                                          \
>>          entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>>                                   sizeof(*entry) + __data_size);         \
>>                                                                          \
>>          if (!entry)                                                     \
>>                  return;                                                 \
>>                                                                          \
>>          tstruct                                                         \
>>                                                                          \
>>          { assign; }                                                     \
>>                                                                          \
>>          trace_event_buffer_commit(&fbuffer);                            \
>> }
>>
>> The reason caused no output of trace_sctp_probe_path is that
>> trace_sctp_probe_path written in TP_fast_assign part of
>> TRACE_EVENT(sctp_probe), and it will be placed( { assign; } ) after the
>> trace_event_buffer_reserve() when compiler expands Macro,
>>
>>          entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>>                                   sizeof(*entry) + __data_size);         \
>>                                                                          \
>>          if (!entry)                                                     \
>>                  return;                                                 \
>>                                                                          \
>>          tstruct                                                         \
>>                                                                          \
>>          { assign; }                                                     \
>>
>> so trace_sctp_probe_path finally can not acquire trace_event_buffer
>> and return no output, that is to say the nest of tracepoint entry function
>> is not allowed. The function call flow is:
>>
>> trace_sctp_probe()
>> -> trace_event_raw_event_sctp_probe()
>>   -> lock buffer
>>   -> trace_sctp_probe_path()
>>     -> trace_event_raw_event_sctp_probe_path()  --nested
>>     -> buffer has been locked and return no output.
>>
>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
>> and trigger sctp_probe_path_trace in sctp_outq_sack.
>>
>> After this patch, you can enable both events individually,
>>    # cd /sys/kernel/debug/tracing
>>    # echo 1 > events/sctp/sctp_probe/enable
>>    # echo 1 > events/sctp/sctp_probe_path/enable
>>
>> Or, you can enable all the events under sctp.
>>
>>    # echo 1 > events/sctp/enable
>>
>> v1->v2:
>>   -add trace_sctp_probe_path_enabled check to avoid traversing the
>>    transport list when the tracepoint is disabled as Marcelo's suggestion.
> 
> Oh, nice, thanks for taking the time to add it back.
> 
> Dave already applied your v1, so you actually need an incremental
> patch now :-)
> 

Thank you for your guidance, Marcelo. I will create the incremental 
patch soon. :-)

>>
>> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
>> ---
>>   include/trace/events/sctp.h | 9 ---------
>>   net/sctp/outqueue.c         | 7 +++++++
>>   2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/trace/events/sctp.h b/include/trace/events/sctp.h
>> index 7475c7b..d4aac34 100644
>> --- a/include/trace/events/sctp.h
>> +++ b/include/trace/events/sctp.h
>> @@ -75,15 +75,6 @@
>>   		__entry->pathmtu = asoc->pathmtu;
>>   		__entry->rwnd = asoc->peer.rwnd;
>>   		__entry->unack_data = asoc->unack_data;
>> -
>> -		if (trace_sctp_probe_path_enabled()) {
>> -			struct sctp_transport *sp;
>> -
>> -			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
>> -					    transports) {
>> -				trace_sctp_probe_path(sp, asoc);
>> -			}
>> -		}
>>   	),
>>   
>>   	TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
>> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
>> index 0dab62b..83ddcfe 100644
>> --- a/net/sctp/outqueue.c
>> +++ b/net/sctp/outqueue.c
>> @@ -36,6 +36,7 @@
>>   #include <net/sctp/sctp.h>
>>   #include <net/sctp/sm.h>
>>   #include <net/sctp/stream_sched.h>
>> +#include <trace/events/sctp.h>
>>   
>>   /* Declare internal functions here.  */
>>   static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn);
>> @@ -1238,6 +1239,12 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
>>   	/* Grab the association's destination address list. */
>>   	transport_list = &asoc->peer.transport_addr_list;
>>   
>> +	/* SCTP path tracepoint for congestion control debugging. */
>> +	if (trace_sctp_probe_path_enabled()) {
>> +		list_for_each_entry(transport, transport_list, transports)
>> +			trace_sctp_probe_path(transport, asoc);
>> +	}
>> +
>>   	sack_ctsn = ntohl(sack->cum_tsn_ack);
>>   	gap_ack_blocks = ntohs(sack->num_gap_ack_blocks);
>>   	asoc->stats.gapcnt += gap_ack_blocks;
>> -- 
>> 1.8.3.1
>>
