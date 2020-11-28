Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702542C6E07
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732260AbgK1Azr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 19:55:47 -0500
Received: from www62.your-server.de ([213.133.104.62]:53678 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732191AbgK1AzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 19:55:04 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kioV9-0004XD-ON; Sat, 28 Nov 2020 01:54:11 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kioV9-0006Jr-Dx; Sat, 28 Nov 2020 01:54:11 +0100
Subject: Re: [PATCH] bpf: remove trailing semicolon in macro definition
To:     trix@redhat.com, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201127192734.2865832-1-trix@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d7168ec4-040c-851d-f294-709315d13a2f@iogearbox.net>
Date:   Sat, 28 Nov 2020 01:54:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201127192734.2865832-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26001/Fri Nov 27 14:45:56 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 8:27 PM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   include/trace/events/xdp.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index cd24e8a59529..65ffedf8386f 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -146,13 +146,13 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
>   );
>   
>   #define _trace_xdp_redirect(dev, xdp, to)		\
> -	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to);
> +	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
>   
>   #define _trace_xdp_redirect_err(dev, xdp, to, err)	\
>   	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to);
>   
>   #define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
> -	 trace_xdp_redirect(dev, xdp, to, 0, map, index);
> +	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
>   
>   #define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
>   	 trace_xdp_redirect_err(dev, xdp, to, err, map, index);
> 

This looks random, why those but not other locations ?

Thanks,
Daniel
