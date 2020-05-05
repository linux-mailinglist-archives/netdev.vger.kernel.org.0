Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44221C63E3
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgEEW2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:28:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:52696 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgEEW2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:28:12 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jW62s-0000io-2Z; Wed, 06 May 2020 00:28:10 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jW62r-0003Ww-RJ; Wed, 06 May 2020 00:28:09 +0200
Subject: Re: [PATCH 0/2] sockmap, fix for some error paths with helpers
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <56c4d993-d237-c822-f7a7-bdb408f1b5dc@iogearbox.net>
Date:   Wed, 6 May 2020 00:28:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25803/Tue May  5 14:19:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 7:21 PM, John Fastabend wrote:
> In these two cases sk_msg layout was getting confused with some helper
> sequences.
> 
> I found these while cleaning up test_sockmap to do a better job covering
> the different scenarios. Those patches will go to bpf-next and include
> tests that cover these two cases.
> 
> ---
> 
> John Fastabend (2):
>        bpf: sockmap, msg_pop_data can incorrecty set an sge length
>        bpf: sockmap, bpf_tcp_ingress needs to subtract bytes from sg.size
> 
> 
>   include/linux/skmsg.h |    1 +
>   net/core/filter.c     |    2 +-
>   net/ipv4/tcp_bpf.c    |    1 -
>   3 files changed, 2 insertions(+), 2 deletions(-)
> 
> --
> Signature
> 

Applied to bpf, thanks!
