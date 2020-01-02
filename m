Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C612E4A5
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgABJ7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:59:24 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38751 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgABJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:59:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id u2so5140480wmc.3;
        Thu, 02 Jan 2020 01:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cw6UL0jDxARsyZX1Q3ptkwgsU/4KTz5YgH+9OaaJGrU=;
        b=vdVnfe+ym+uowHfXU+MvgDD3QNDJdan6N2tuNwCrdRYnE6vZHo7Jl6Gcduf14+iNg+
         Xyn4Z9vb9GbRs/zCzQmPbqjxcAwHQL9nryVq3Sn0KbHZugjICAYOgzbMtBaqccnBX9TM
         G1Mh3IVimvApA5McqL1jDNdoi37NvUdsltbwU7YazOkgJ5a/jYRrrKjBsyreufgX/jo5
         1t23bkrT0WDsZPiQ08ZSHgHuiAD/V759iy6HjFhvvOb7z9ovnPSzkpLbSfT/ufTvjY/5
         eiC2XPB7taSgASowSjU4XxXsFOTB6sK7xFPW+wXlYPUPfSR2QxQcjvvwadS/ejQkf40M
         DplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cw6UL0jDxARsyZX1Q3ptkwgsU/4KTz5YgH+9OaaJGrU=;
        b=lON7B2cidHSxrV+i0W2qGarvJHIyPX8AiI9XweX8IryMOQwWPu+ozg6qYKpS3Pd7BO
         UOoZGBOWyO4grqZpoldXMcKxj0dFN5RLN2Us+3TmwdplImbftj5K+m+51yMHx3rCjtxt
         pKdtd/lBp9eqqmoOZkxWWHj13MPb4/lKwHEBM8SB2Ww49fdzC76TIOkUu52zfbiktwAQ
         m3qIS4mYe5eJE2aGfHR/bwgQr2EwrVMKmtKRmX96HDnji8uCPV7KTUyWg3E6KgGbyclU
         VMdSFTe+GwWjAxS5CfC0nL/BamMfeYpK69om3masd/l8vVkwT2h/ErBn8mDwmdsJ5qAp
         /Csg==
X-Gm-Message-State: APjAAAUxfwXW175cmpQVG1AKR7B9xiFfVz8WAvVEepdlH3Kop/pQSUSe
        CkwK6hjPkONrGQahF0SZy44=
X-Google-Smtp-Source: APXvYqx6cTFHd62bApOtF4rWy+dq9iVYEY4c+Q8PY0hhcGH6eixOdgrfMVgCAy6NfOCyzxMVDITDYA==
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr13512801wmb.174.1577959162170;
        Thu, 02 Jan 2020 01:59:22 -0800 (PST)
Received: from [192.168.8.147] (195.171.185.81.rev.sfr.net. [81.185.171.195])
        by smtp.gmail.com with ESMTPSA id c2sm55327319wrp.46.2020.01.02.01.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 01:59:21 -0800 (PST)
Subject: Re: stable-rc-4.19.93-rc1/4e040169e8b7 : kernel panic RIP:
 0010:__inet_lookup_listener
To:     Michal Kubecek <mkubecek@suse.cz>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
References: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
 <20200102092611.GB22327@unicorn.suse.cz>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <58db59fd-34c5-d25c-3146-572c1e9cd29b@gmail.com>
Date:   Thu, 2 Jan 2020 01:59:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102092611.GB22327@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/2/20 1:26 AM, Michal Kubecek wrote:
> On Thu, Jan 02, 2020 at 12:24:35PM +0530, Naresh Kamboju wrote:
>> Results from Linaro’s test farm.
>> Regressions on arm64, arm, x86_64, and i386.
>>
>> While running LTP syscalls accept* test cases on stable-rc-4.19 branch kernel.
>> This report log extracted from qemu_x86_64.
>>
>> metadata:
>>   git branch: linux-4.19.y
>>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>   git commit: 4e040169e8b7f4e1c50ceb0f6596015ecc67a052
>>   git describe: v4.19.92-112-g4e040169e8b7
>>   make_kernelversion: 4.19.93-rc1
>>   kernel-config:
>> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-4.19/396/config
>>
>> Crash log,
>>
>> BUG: unable to handle kernel paging request at 0000000040000001
>> [   23.578222] PGD 138f25067 P4D 138f25067 PUD 0
>> er run is 0h 15m[   23.578222] Oops: 0000 [#1] SMP NOPTI
>> [   23.578222] CPU: 1 PID: 2216 Comm: accept02 Not tainted 4.19.93-rc1 #1
>> [   23.578222] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS 1.12.0-1 04/01/2014
>> [   23.578222] RIP: 0010:__inet_lookup_listener+0x12d/0x300
>>  00s
>> [ts t_buffe r 23.578222] Code: 18 48 85 db 0f 84 fe 00 00 00 48 83 eb
>> 68 0f 84 f4 00 00 00 0f b7 75 d0 44 8b 55 10 45 89 f1 45 31 ff 31 c0
>> 45 89 de 89 75 b0 <4c> 3b 63 30 75 43 66 44 3b 6b 0e 75 3c 0f b6 73 13
>> 40 f6 c6 20 75
>> [   23.578222] RSP: 0018:ffff9e0dbba83c38 EFLAGS: 00010206
>> [   23.578222] RAX: ffff9e0db6ff8a80 RBX: 000000003fffffd1 RCX: 0000000000000000
>> [   23.578222] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 00000000ffffffff
>> [   23.578222] RBP: ffff9e0dbba83c88 R08: 000000000100007f R09: 0000000000000000
>> [   23.578222] R10: 000000000100007f R11: 0000000000000000 R12: ffffffffbeb2fe40
>> [   23.578222] R13: 000000000000d59f R14: 0000000000000000 R15: 0000000000000006
>> [   23.578222] FS:  00007fbb30e57700(0000) GS:ffff9e0dbba80000(0000)
>> knlGS:0000000000000000
>> [   23.578222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   23.578222] CR2: 0000000040000001 CR3: 000000013276c000 CR4: 00000000003406e0
>> [   23.578222] Call Trace:
>> [   23.578222]  <IRQ>
>> [   23.578222]  tcp_v4_rcv+0x4fe/0xc80
>> [   23.578222]  ip_local_deliver_finish+0xaf/0x390
>> [   23.578222]  ip_local_deliver+0x1a1/0x200
>> [   23.578222]  ? ip_sublist_rcv+0x420/0x420
>> [   23.578222]  ip_rcv_finish+0x88/0xd0
>> s.c:55: INFO: Te[   23.578222]  ip_rcv+0x142/0x200
>> [   23.578222]  ? ip_rcv_finish_core.isra.18+0x4e0/0x4e0
>> st is[ us ing guar  23.578222]  ? process_backlog+0x6d/0x230
>> [   23.578222]  __netif_receive_skb_one_core+0x57/0x80
>> ded [bu ffe rs
>>  ac2c3.578222]  __netif_receive_skb+0x18/0x60
>> [   23.578222]  process_backlog+0xd4/0x230
>> [   23.578222]  net_rx_action+0x13e/0x420
>> [   23.578222]  ? __do_softirq+0x9b/0x426
>> [   23.578222]  __do_softirq+0xc7/0x426
>> [   23.578222]  ? ip_finish_output2+0x255/0x660
>> [   23.578222]  do_softirq_own_stack+0x2a/0x40
>> [   23.578222]  </IRQ>
>> [   23.578222]  do_softirq.part.19+0x4d/0x60
>> [   23.578222]  __local_bh_enable_ip+0xd9/0xf0
>> [   23.578222]  ip_finish_output2+0x27e/0x660
>> [   23.578222]  ip_finish_output+0x235/0x370
>> [   23.578222]  ? ip_finish_output+0x235/0x370
>> [   23.578222]  ip_output+0x76/0x250
>> [   23.578222]  ? ip_fragment.constprop.50+0x80/0x80
>> [   23.578222]  ip_local_out+0x3f/0x70
>> [   23.578222]  __ip_queue_xmit+0x1ea/0x5f0
>> [   23.578222]  ? __lock_is_held+0x5a/0xa0
>> [   23.578222]  ip_queue_xmit+0x10/0x20
>> [   23.578222]  __tcp_transmit_skb+0x57c/0xb60
>> [   23.578222]  tcp_connect+0xccd/0x1030
>> [   23.578222]  tcp_v4_connect+0x515/0x550
>> [   23.578222]  __inet_stream_connect+0x249/0x390
>> [   23.578222]  ? __local_bh_enable_ip+0x7f/0xf0
>> [   23.578222]  inet_stream_connect+0x3b/0x60
>> [   23.578222]  __sys_connect+0xa3/0x120
>> [   23.578222]  ? kfree+0x203/0x240
>> [   23.578222]  ? syscall_trace_enter+0x1e3/0x350
>> [   23.578222]  ? trace_hardirqs_off_caller+0x22/0xf0
>> [   23.578222]  ? do_syscall_64+0x17/0x1a0
>> [   23.578222]  ? lockdep_hardirqs_on+0xef/0x180
>> [   23.578222]  ? do_syscall_64+0x17/0x1a0
>> [   23.578222]  __x64_sys_connect+0x1a/0x20
>> [   23.578222]  do_syscall_64+0x55/0x1a0
>> [   23.578222]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [   23.578222] RIP: 0033:0x7fbb31a1c927
>> [   23.578222] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48
>> 83 ec 10 e8 0b f9 ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00
>> 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 45 f9 ff ff
>> 8b 44
> 
> In __inet_lookup_listener(), we need to replace
> 
> 	sk_for_each_rcu(sk, &ilb->head) 
> 
> by
> 
> 	sk_nulls_for_each_rcu(sk2, node, &ilb->nulls_head)
> 
> This loop was eliminated in mainline 5.0-rc1 by commit d9fbc7f6431f
> ("net: tcp: prefer listeners bound to an address"). I'll have to check
> if there are more places in stable-4.14 and stable-4.19 which also need
> to be updated.

Thanks for looking at this.

> 
> This also makes me think... AFAICS, since commit d9fbc7f6431f, only the
> (addr,port) hashtable is used for listener lookup and the traditional
> port only hashtable is only used to iterate through all listening
> sockets for netlink dumps and /proc/net/tcp. Maybe we could switch these
> two also to the (addr,port) hashtable and keep only one listener
> hashtable.

Yes, this seems something we can do, thanks.

