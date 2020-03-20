Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D5F18D245
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgCTPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:01:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:50940 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:01:47 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJ9R-0004Ty-AF; Fri, 20 Mar 2020 16:01:33 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJ9Q-000LQU-Ua; Fri, 20 Mar 2020 16:01:32 +0100
Subject: Re: [PATCH bpf-next 1/2] bpf: tcp: Fix unused function warnings
To:     Yonghong Song <yhs@fb.com>, YueHaibing <yuehaibing@huawei.com>,
        lmb@cloudflare.com, jakub@cloudflare.com, john.fastabend@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrii.nakryiko@gmail.com
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <20200320023426.60684-1-yuehaibing@huawei.com>
 <20200320023426.60684-2-yuehaibing@huawei.com>
 <d18a19a0-f147-03ad-b8a5-4b502199cd72@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <71161d44-da82-b4ae-ee9e-8291d9d03021@iogearbox.net>
Date:   Fri, 20 Mar 2020 16:01:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d18a19a0-f147-03ad-b8a5-4b502199cd72@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25757/Fri Mar 20 14:13:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 5:21 AM, Yonghong Song wrote:
> On 3/19/20 7:34 PM, YueHaibing wrote:
>> If BPF_STREAM_PARSER is not set, gcc warns:
>>
>> net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
>> net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
>> net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
>>
>> Moves the unused functions into the #ifdef
> 
> Maybe explicit "into the #ifdef CONFIG_BPF_STREAM_PARSER"?
> 
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: f747632b608f ("bpf: sockmap: Move generic sockmap hooks from BPF TCP")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
>> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Both applied and addressed feedback from Yonghong, thanks!
