Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A46C3CBD8F
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhGPUQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:16:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:39720 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhGPUQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 16:16:05 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m4UCf-0006dK-96; Fri, 16 Jul 2021 22:12:57 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m4UCe-000QgN-RO; Fri, 16 Jul 2021 22:12:56 +0200
Subject: Re: [PATCH v2 bpf-nxt] Documentation/bpf: Add heading and example for
 extensions in filter.rst
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "Roy, UjjaL" <royujjal@gmail.com>, Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, BPF <bpf@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
References: <royujjal@gmail.com> <20210712173723.1597-1-royujjal@gmail.com>
 <60ee2dc76ac1c_196e22088d@john-XPS-13-9370.notmuch>
 <CAADnVQJ=DoRDcVkaXmY3EmNdLoO7gq1mkJOn5G=00wKH8qUtZQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <80579c8d-ecdb-4334-9912-c04f75f7a6d3@iogearbox.net>
Date:   Fri, 16 Jul 2021 22:12:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ=DoRDcVkaXmY3EmNdLoO7gq1mkJOn5G=00wKH8qUtZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26234/Fri Jul 16 10:18:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/21 3:48 AM, Alexei Starovoitov wrote:
> On Tue, Jul 13, 2021 at 5:20 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>
>> Roy, UjjaL wrote:
>>> [1] https://www.kernel.org/doc/html/latest/bpf/
>>>
>>> Add new heading for extensions to make it more readable. Also, add one
>>> more example of filtering interface index for better understanding.
>>>
>>> Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>
>> Looks OK to me. I thought the original was readable without the header, but
>> if it helps someone seems easy enough to do.
>>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> I cannot figure out how to apply this patch, because I see:
> Applying: Documentation/bpf: Add heading and example for extensions in
> filter.rst
> fatal: empty ident name (for <>) not allowed
> 
> Any idea?

Same happened on my side. Maybe not sent via git-send-email(1)? Anyway, I've
applied manually meanwhile.
