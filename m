Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9199819007E
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgCWVh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:37:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:43552 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgCWVh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:37:58 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jGUlg-0003oL-3T; Mon, 23 Mar 2020 22:37:56 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jGUlf-000A07-SO; Mon, 23 Mar 2020 22:37:55 +0100
Subject: Re: [PATCH v2 bpf-next 0/2] bpf: Add bpf_sk_storage support to
 bpf_tcp_ca
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200320152055.2169341-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c7a5c73a-875f-4907-2a0a-9f6e21714f9c@iogearbox.net>
Date:   Mon, 23 Mar 2020 22:37:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320152055.2169341-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25760/Mon Mar 23 14:12:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 4:20 PM, Martin KaFai Lau wrote:
> This set adds bpf_sk_storage support to bpf_tcp_ca.
> That will allow bpf-tcp-cc to share sk's private data with other
> bpf_progs and also allow bpf-tcp-cc to use extra private
> storage if the existing icsk_ca_priv is not enough.
> 
> v2:
> - Move the sk_stg_map test immediately after connect() (Yonghong)
> - Use global linkage var in bpf_dctcp.c (Yonghong)
> 
> Martin KaFai Lau (2):
>    bpf: Add bpf_sk_storage support to bpf_tcp_ca
>    bpf: Add tests for bpf_sk_storage to bpf_tcp_ca
> 
>   net/ipv4/bpf_tcp_ca.c                         | 33 ++++++++++++++++
>   .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 39 +++++++++++++++----
>   tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 ++++++++
>   3 files changed, 80 insertions(+), 8 deletions(-)
> 

Applied, thanks!
