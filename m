Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F4F3B30EE
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFXOIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:08:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:57574 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:07:59 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwPz6-0006Zz-65; Thu, 24 Jun 2021 16:05:36 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lwPz5-000JT6-UK; Thu, 24 Jun 2021 16:05:35 +0200
Subject: Re: [PATCH bpf-next v2 4/4] bpf: more lenient bpf_skb_net_shrink()
 with BPF_F_ADJ_ROOM_FIXED_GSO
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
References: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
 <20210617000953.2787453-1-zenczykowski@gmail.com>
 <20210617000953.2787453-4-zenczykowski@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <919e8f26-4b82-9d4c-8973-b2ab2b4bc5bf@iogearbox.net>
Date:   Thu, 24 Jun 2021 16:05:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210617000953.2787453-4-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26211/Thu Jun 24 13:04:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 2:09 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> This is to more closely match behaviour of bpf_skb_change_proto()
> which now does not adjust gso_size, and thus thoretically supports
> all gso types, and does not need to set SKB_GSO_DODGY nor reset
> gso_segs to zero.
> 
> Something similar should probably be done with bpf_skb_net_grow(),
> but that code scares me.

Took in all except this one, would be good to have a complete solution for
both bpf_skb_net_{shrink,grow}(). If you don't have the cycles, I'll look
into it.

Thanks,
Daniel
