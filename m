Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE23553882C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 22:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiE3UUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiE3UUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 16:20:21 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964D75FF13;
        Mon, 30 May 2022 13:20:20 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvlsA-0007CU-7R; Mon, 30 May 2022 22:20:18 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvls9-000EjS-I2; Mon, 30 May 2022 22:20:17 +0200
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <20220527205611.655282-1-jolsa@kernel.org>
 <20220527205611.655282-3-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <58130008-a5e4-50e2-0706-e5edb4bfb5a8@iogearbox.net>
Date:   Mon, 30 May 2022 22:20:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220527205611.655282-3-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26557/Mon May 30 10:05:44 2022)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/22 10:56 PM, Jiri Olsa wrote:
> We want to store the resolved address on the same index as
> the symbol string, because that's the user (bpf kprobe link)
> code assumption.
> 
> Also making sure we don't store duplicates that might be
> present in kallsyms.
> 
> Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   kernel/trace/ftrace.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)

Steven / Masami, would be great to get an Ack from one of you before applying.

Thanks,
Daniel
