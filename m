Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840313A863F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFOQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:21:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:33444 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhFOQVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 12:21:20 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltBmO-0000nN-J5; Tue, 15 Jun 2021 18:19:08 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltBmO-000637-9d; Tue, 15 Jun 2021 18:19:08 +0200
Subject: Re: [PATCH v8 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, edumazet@google.com
Cc:     andrii@kernel.org, ast@kernel.org, benh@amazon.com,
        bpf@vger.kernel.org, davem@davemloft.net, kafai@fb.com,
        kuba@kernel.org, kuni1840@gmail.com, linux-kernel@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, ycheng@google.com
References: <CANn89iLxZxGXaVxLkxTkmNPF7XZdb8DKGMBFuMJLBdtrJRbrsA@mail.gmail.com>
 <20210615160330.19729-1-kuniyu@amazon.co.jp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f28c2bda-e37d-7119-210e-80ee63369003@iogearbox.net>
Date:   Tue, 15 Jun 2021 18:19:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210615160330.19729-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 6:03 PM, Kuniyuki Iwashima wrote:
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Tue, 15 Jun 2021 17:35:10 +0200
>> On Sat, Jun 12, 2021 at 2:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>>>
>>> Changelog:
>>>   v8:
>>>    * Make reuse const in reuseport_sock_index()
>>>    * Don't use __reuseport_add_sock() in reuseport_alloc()
>>>    * Change the arg of the second memcpy() in reuseport_grow()
>>>    * Fix coding style to use goto in reuseport_alloc()
>>>    * Keep sk_refcnt uninitialized in inet_reqsk_clone()
>>>    * Initialize ireq_opt and ipv6_opt separately in reqsk_migrate_reset()
>>>
>>>    [ This series does not include a stats patch suggested by Yuchung Cheng
>>>      not to drop Acked-by/Reviewed-by tags and save reviewer's time. I will
>>>      post the patch as a follow up after this series is merged. ]
>>
>> For the whole series.
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> I greatly appreciate your review.

+1, applied, thanks everyone!
