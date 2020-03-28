Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9C0196823
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 18:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgC1RZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 13:25:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:60624 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgC1RZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 13:25:42 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIFDD-0003pU-L8; Sat, 28 Mar 2020 18:25:35 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIFDD-000Jxf-B1; Sat, 28 Mar 2020 18:25:35 +0100
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Joe Stringer <joe@wand.net.nz>, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20200327042556.11560-1-joe@wand.net.nz>
 <20200327184621.67324727o5rtu42p@kafai-mbp>
 <CAOftzPjv8rcP7Ge59fc4rhy=BR2Ym1=G3n3fvi402nx61zLf-Q@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7e58a449-16a1-0cbd-f133-7d612a82fae1@iogearbox.net>
Date:   Sat, 28 Mar 2020 18:25:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAOftzPjv8rcP7Ge59fc4rhy=BR2Ym1=G3n3fvi402nx61zLf-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25765/Sat Mar 28 14:16:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 10:05 PM, Joe Stringer wrote:
> On Fri, Mar 27, 2020 at 11:46 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
>>> Introduce a new helper that allows assigning a previously-found socket
>>> to the skb as the packet is received towards the stack, to cause the
[...]
>>> Changes since v1:
>>> * Replace the metadata_dst approach with using the skb->destructor to
>>>    determine whether the socket has been prefetched. This is much
>>>    simpler.
>>> * Avoid taking a reference on listener sockets during receive
>>> * Restrict assigning sockets across namespaces
>>> * Restrict assigning SO_REUSEPORT sockets
>>> * Fix cookie usage for socket dst check
>>> * Rebase the tests against test_progs infrastructure
>>> * Tidy up commit messages
>> lgtm.
>>
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> Thanks for the reviews!
> 
> I've rolled in the current nits + acks into the branch below, pending
> any further feedback. Alexei, happy to respin this on the mailinglist
> at some point if that's easier for you.
> 
> https://github.com/joestringer/linux/tree/submit/bpf-sk-assign-v3+

Please send the updated series to the list with Martin's ACK retained, so
that we can process the series through our patchwork scripts wrt formatting,
tags etc (please also make sure it's rebased).

Thanks,
Daniel
