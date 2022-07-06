Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFFF567C1A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 04:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiGFCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 22:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiGFCuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 22:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E078915A3E;
        Tue,  5 Jul 2022 19:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69791619A6;
        Wed,  6 Jul 2022 02:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A73C341C7;
        Wed,  6 Jul 2022 02:50:50 +0000 (UTC)
Date:   Tue, 5 Jul 2022 22:50:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: Re: [PATCH 04/13] tracing/brcm: Use the new __vstring() helper
Message-ID: <20220705225049.665db869@gandalf.local.home>
In-Reply-To: <202207061019.0zRrehFH-lkp@intel.com>
References: <20220705224749.622796175@goodmis.org>
        <202207061019.0zRrehFH-lkp@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 10:35:50 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Steven,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on rostedt-trace/for-next]
> [also build test WARNING on wireless-next/main wireless/main linus/master v5.19-rc5 next-20220705]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 


> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):

OK, let's look at all the warnings.

> 
>    In file included from include/trace/define_trace.h:102,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_get_offsets_brcmf_err':
> >> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]  

 1. "might be a candidate for 'gnu_printf' format attribute"

>      261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>       31 | TRACE_EVENT(brcmf_err,
>          | ^~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_get_offsets_brcmf_dbg':
> >> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]  

 2. "might be a candidate for 'gnu_printf' format attribute"

>      261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>       45 | TRACE_EVENT(brcmf_dbg,
>          | ^~~~~~~~~~~
>    In file included from include/trace/define_trace.h:102,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_err':
>    include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 3. "might be a candidate for 'gnu_printf' format attribute"

>      386 |         struct trace_event_raw_##call *entry;                           \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>       31 | TRACE_EVENT(brcmf_err,
>          | ^~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_dbg':
>    include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 4. "might be a candidate for 'gnu_printf' format attribute"

>      386 |         struct trace_event_raw_##call *entry;                           \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>       45 | TRACE_EVENT(brcmf_dbg,
>          | ^~~~~~~~~~~
>    In file included from include/trace/define_trace.h:103,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:133,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_err':
>    include/trace/perf.h:64:16: warning: function 'perf_trace_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 5. "might be a candidate for 'gnu_printf' format attribute"

>       64 |         struct hlist_head *head;                                        \
>          |                ^~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
>       31 | TRACE_EVENT(brcmf_err,
>          | ^~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_dbg':
>    include/trace/perf.h:64:16: warning: function 'perf_trace_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 6. "might be a candidate for 'gnu_printf' format attribute"

>       64 |         struct hlist_head *head;                                        \
>          |                ^~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:45:1: note: in expansion of macro 'TRACE_EVENT'
>       45 | TRACE_EVENT(brcmf_dbg,
>          | ^~~~~~~~~~~
> --
>    In file included from include/trace/define_trace.h:102,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'trace_event_get_offsets_brcms_dbg':
> >> include/trace/trace_events.h:261:16: warning: function 'trace_event_get_offsets_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]  

 7. "might be a candidate for 'gnu_printf' format attribute"

>      261 |         struct trace_event_raw_##call __maybe_unused *entry;            \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>       59 | TRACE_EVENT(brcms_dbg,
>          | ^~~~~~~~~~~
>    In file included from include/trace/define_trace.h:102,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'trace_event_raw_event_brcms_dbg':
>    include/trace/trace_events.h:386:16: warning: function 'trace_event_raw_event_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 8. "might be a candidate for 'gnu_printf' format attribute"


>      386 |         struct trace_event_raw_##call *entry;                           \
>          |                ^~~~~~~~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>       59 | TRACE_EVENT(brcms_dbg,
>          | ^~~~~~~~~~~
>    In file included from include/trace/define_trace.h:103,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:82,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
>                     from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'perf_trace_brcms_dbg':
>    include/trace/perf.h:64:16: warning: function 'perf_trace_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]

 9. "might be a candidate for 'gnu_printf' format attribute"

>       64 |         struct hlist_head *head;                                        \
>          |                ^~~~~~~~~~
>    include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>       40 |         DECLARE_EVENT_CLASS(name,                              \
>          |         ^~~~~~~~~~~~~~~~~~~
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:59:1: note: in expansion of macro 'TRACE_EVENT'
>       59 | TRACE_EVENT(brcms_dbg,
>          | ^~~~~~~~~~~
> 
> 
> vim +261 include/trace/trace_events.h
> 
> 55de2c0b5610cb include/trace/trace_events.h Masami Hiramatsu         2021-11-22  253  
> 091ad3658e3c76 include/trace/ftrace.h       Ingo Molnar              2009-11-26  254  #undef DECLARE_EVENT_CLASS
> 091ad3658e3c76 include/trace/ftrace.h       Ingo Molnar              2009-11-26  255  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
> d0ee8f4a1f5f3d include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13  256) static inline notrace int trace_event_get_offsets_##call(		\
> 62323a148fbeb0 include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13  257) 	struct trace_event_data_offsets_##call *__data_offsets, proto)	\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  258  {									\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  259  	int __data_size = 0;						\
> 114e7b52dee69c include/trace/ftrace.h       Filipe Brandenburger     2014-02-28  260  	int __maybe_unused __item_length;				\
> a7237765730a10 include/trace/trace_events.h Steven Rostedt (Red Hat  2015-05-13 @261) 	struct trace_event_raw_##call __maybe_unused *entry;		\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  262  									\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  263  	tstruct;							\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  264  									\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  265  	return __data_size;						\
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  266  }
> 7fcb7c472f455d include/trace/ftrace.h       Li Zefan                 2009-06-01  267  
> 

Really? 9 warnings about something that *MIGHT* be a candidate for
gnu_printf format attribute?  This is a macro that expanded into something
that could possibly use the printf format, but is nested deep in macro
magic.

Can we please shut this up?

Thanks,

-- Steve
