Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A44F2606D3
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgIGWLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:11:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:32838 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgIGWLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 18:11:40 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFPMB-000321-Rm; Tue, 08 Sep 2020 00:11:23 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFPMB-000Kx6-HZ; Tue, 08 Sep 2020 00:11:23 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     =?UTF-8?Q?Laura_Garc=c3=ada_Li=c3=a9bana?= <nevola@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <CAF90-WhWpiAPcpU81P3cPTUmRD-xGkuZ9GZA8Q3cPN7RQKhXeA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b1ae75ac-82b5-aa24-c59a-3988d94d6a10@iogearbox.net>
Date:   Tue, 8 Sep 2020 00:11:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF90-WhWpiAPcpU81P3cPTUmRD-xGkuZ9GZA8Q3cPN7RQKhXeA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25923/Mon Sep  7 15:37:02 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/20 1:18 PM, Laura García Liébana wrote:
> On Fri, Sep 4, 2020 at 11:14 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
[...]
> Something like this seems more trivial to me:
> 
> table netdev mytable {
>      chain mychain {
>          type filter hook egress device "eth0" priority 100; policy drop;
>          meta protocol != 0x419C accept
>      }
> }

Sure, different frontends, so what?! You could also wrap that code into a
simple a.out or have nft style syntax jit to bpf ...
