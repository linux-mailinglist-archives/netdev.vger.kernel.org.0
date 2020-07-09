Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8363821A899
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgGIUHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:07:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:49774 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgGIUHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:07:09 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtcp1-00018j-Ig; Thu, 09 Jul 2020 22:07:07 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtcp1-000L3z-D7; Thu, 09 Jul 2020 22:07:07 +0200
Subject: Re: [PATCH v2 bpf 0/2] bpf: net: Fixes in sk_user_data of
 reuseport_array
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200709061057.4018499-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f84a5aeb-9040-f7dc-d4ed-63bd6d764878@iogearbox.net>
Date:   Thu, 9 Jul 2020 22:07:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709061057.4018499-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 8:10 AM, Martin KaFai Lau wrote:
> This set fixes two issues on sk_user_data when a sk is added to
> a reuseport_array.
> 
> The first patch is to avoid the sk_user_data being copied
> to a cloned sk.  The second patch avoids doing bpf_sk_reuseport_detach()
> on sk_user_data that is not managed by reuseport_array.
> 
> Since the changes are mostly related to bpf reuseport_array, so it is
> currently tagged as bpf fixes.
> 
> v2:
> - Avoid ~3UL (Andrii)
> 
> Martin KaFai Lau (2):
>    bpf: net: Avoid copying sk_user_data of reuseport_array during
>      sk_clone
>    bpf: net: Avoid incorrect bpf_sk_reuseport_detach call
> 
>   include/net/sock.h           |  3 ++-
>   kernel/bpf/reuseport_array.c | 14 ++++++++++----
>   2 files changed, 12 insertions(+), 5 deletions(-)
> 

Applied, thanks!
