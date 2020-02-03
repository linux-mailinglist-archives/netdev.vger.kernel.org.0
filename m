Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2933151171
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgBCU6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:58:01 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53979 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgBCU6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:58:01 -0500
X-Originating-IP: 79.86.19.127
Received: from [192.168.0.12] (127.19.86.79.rev.sfr.net [79.86.19.127])
        (Authenticated sender: alex@ghiti.fr)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 10182E0004;
        Mon,  3 Feb 2020 20:57:55 +0000 (UTC)
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Anup Patel <anup@brainfault.org>,
        vincent.chen@sifive.com
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
 <20191216091343.23260-7-bjorn.topel@gmail.com>
 <3f6d3495-efdf-e663-2a84-303fde947a1d@ghiti.fr>
 <CAJ+HfNgOrx1D-tSxXsoZsMxZtHX-Ksdeg8bZFFPRPGChup4oFg@mail.gmail.com>
From:   Alex Ghiti <alex@ghiti.fr>
Message-ID: <881b35d6-23ce-fac3-23b8-cdd4d70fa106@ghiti.fr>
Date:   Mon, 3 Feb 2020 15:57:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNgOrx1D-tSxXsoZsMxZtHX-Ksdeg8bZFFPRPGChup4oFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/20 7:28 AM, Björn Töpel wrote:
> On Sun, 2 Feb 2020 at 14:37, Alex Ghiti <alex@ghiti.fr> wrote:
> [...]
>> I think it would be better to completely avoid this patch and the
>> definition of this
>> new zone by using the generic implementation if we had the patch
>> discussed here
>> regarding modules memory allocation (that in any case we need to fix
>> modules loading):
>>
>> https://lore.kernel.org/linux-riscv/d868acf5-7242-93dc-0051-f97e64dc4387@ghiti.fr/T/#m2be30cb71dc9aa834a50d346961acee26158a238
>>
> This patch is already upstream. I agree that when the module
> allocation fix is upstream, the BPF image allocation can be folded
> into the module allocation. IOW, I wont send any page table dumper
> patch for BPF memory.


Too late then :) I'll remove this zone with the patch regarding module
allocation.


>
> But keep in mind that the RV BPF JIT relies on having the kernel text
> within the 32b range (as does modules)


Yep, same constraints as for modules ;)

Thanks,

Alex


>
> Cheers,
> Björn
