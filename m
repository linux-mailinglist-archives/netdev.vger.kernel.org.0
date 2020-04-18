Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69BC1AF4F2
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 22:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDRUbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 16:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726014AbgDRUbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 16:31:50 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFBAC061A0C;
        Sat, 18 Apr 2020 13:31:50 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id t3so6466834qkg.1;
        Sat, 18 Apr 2020 13:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=OTuUPzfRxANqtVwZOWyquS2L31/1qsaERPb/xgNgxL4=;
        b=MxtpfIa4SQHzMunTmjNSh0oH6zgMIlKO2Dw7ekeMFUzP8HCzRi0cdgkymLKt+Joc8F
         H4xGEVzEIzA40YOwoIP7BRscg5P0LKBu6rk+XZUXnJjblddKMujZGciSt/ym1cI7rOAb
         sGLPbvHPVvje5A9WKufJ2ouuWIIn7bIdX2Oxfy8CNAtZTk7H11Qaj0l2J17DV9MTexeP
         Mo7HtkQEtLeo4FzmQuG09hUZMUM/ZX6dDyQ6dtD4vbltw1+5vrlKwD8GT0TOcJrf1RUQ
         5eEBaqm2vD584hB2kogzFow0lxu1hQoPZqfvptJdGkn/0I2xSwuL8g9OSefGFpdZrVIa
         yDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=OTuUPzfRxANqtVwZOWyquS2L31/1qsaERPb/xgNgxL4=;
        b=LcBkXGQ0zEs9LBtRY0Oivb7lMbrBFreP8PO/N1m+eCvI7WFiC+ZCbHsHDe2aOq/4Y2
         wcVOTxfBBdPd+JU2wYJc/sN5aV9LG0AzkDzSxZu/DV0FSXf1Ku2rbCKnj3rInvxI2TTj
         FQWVNrbNtNImvkviksMvJfpoPL4JXiFSS1mYLZTN9xRd7WjJHVNLe8gLqceFvi3/i8xc
         x2pMIzrgiSXXrhkH2jB2XieJs1Kj5w8FfZoD/lcM1wLcAnKDFRHpbIuONP3IeRBIcX5Q
         1u/MBITtDm6u5D+2nCy/nPzHd/S8e/TGk9gd8pfqBpi0Li1fe7uriQU1cfMoQBDNQaqL
         YEnw==
X-Gm-Message-State: AGi0PubadxANbpYd47krqp2fuEyn0Z62l0VvLcIVhtQNYvfSgIIXtkFL
        k040OmajB9oicmCPKxBO25k=
X-Google-Smtp-Source: APiQypJXTlgGriW9burkWTwuYBMHnxZDsm+/kkrfoMk7IcZX4wVAbzkMW62LwNZntT5b/4Z5dBYrUg==
X-Received: by 2002:ae9:ef92:: with SMTP id d140mr8588033qkg.363.1587241909528;
        Sat, 18 Apr 2020 13:31:49 -0700 (PDT)
Received: from [10.103.140.49] (179-240-131-49.3g.claro.net.br. [179.240.131.49])
        by smtp.gmail.com with ESMTPSA id r128sm19605251qke.95.2020.04.18.13.31.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 13:31:48 -0700 (PDT)
Date:   Sat, 18 Apr 2020 17:31:38 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com> <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>
CC:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
From:   Arnaldo Melo <arnaldo.melo@gmail.com>
Message-ID: <B7DDCAA4-4431-414F-B494-77FF742F68E5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On April 18, 2020 1:05:36 PM GMT-03:00, Alexei Starovoitov <alexei=2Estaro=
voitov@gmail=2Ecom> wrote:
>On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
>> The printk family of functions support printing specific pointer
>types
>> using %p format specifiers (MAC addresses, IP addresses, etc)=2E  For
>> full details see Documentation/core-api/printk-formats=2Erst=2E
>>=20
>> This RFC patchset proposes introducing a "print typed pointer" format
>> specifier "%pT<type>"; the type specified is then looked up in the
>BPF
>> Type Format (BTF) information provided for vmlinux to support
>display=2E
>
>This is great idea! Love it=2E

21st century finally! 8-)

>> The above potential use cases hint at a potential reply to
>> a reasonable objection that such typed display should be
>> solved by tracing programs, where the in kernel tracing records
>> data and the userspace program prints it out=2E  While this
>> is certainly the recommended approach for most cases, I
>> believe having an in-kernel mechanism would be valuable
>> also=2E
>
>yep=2E This is useful for general purpose printk=2E
>The only piece that must be highlighted in the printk documentation
>that unlike the rest of BPF there are zero safety guarantees here=2E
>The programmer can pass wrong pointer to printk() and the kernel _will_
>crash=2E
>
>>   struct sk_buff *skb =3D alloc_skb(64, GFP_KERNEL);
>>=20
>>   pr_info("%pTN<struct sk_buff>", skb);
>
>why follow "TN" convention?
>I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
>equally easy to parse=2E
>
>> =2E=2E=2Egives us:
>>=20
>>
>{{{=2Enext=3D00000000c7916e9c,=2Eprev=3D00000000c7916e9c,{=2Edev=3D000000=
00c7916e9c|=2Edev_scratch=3D0}}|=2Erbnode=3D{=2E__rb_parent_color=3D0,
>
>This is unreadable=2E
>I like the choice of C style output, but please format it similar to
>drgn=2E Like:
>*(struct task_struct *)0xffff889ff8a08000 =3D {
>	=2Ethread_info =3D (struct thread_info){
>		=2Eflags =3D (unsigned long)0,
>		=2Estatus =3D (u32)0,
>	},
>	=2Estate =3D (volatile long)1,
>	=2Estack =3D (void *)0xffffc9000c4dc000,
>	=2Eusage =3D (refcount_t){
>		=2Erefs =3D (atomic_t){
>			=2Ecounter =3D (int)2,
>		},
>	},
>	=2Eflags =3D (unsigned int)4194560,
>	=2Eptrace =3D (unsigned int)0,
>
>I like Arnaldo's idea as well, but I prefer zeros to be dropped by
>default=2E

That's my preference as well, it's just I feel ashamed of not participatin=
g in this party as much as I feel I should, so I was just being overly caut=
ious in my suggestions=2E

'perf trace'  zaps any zero syscall arg out of the way by default, so that=
's my preference, sure=2E

 - Arnaldo

>Just like %d doesn't print leading zeros by default=2E
>"%p0<struct sk_buff>" would print them=2E
>
>> The patches are marked RFC for several reasons
>>=20
>> - There's already an RFC patchset in flight dealing with BTF dumping;
>>=20
>> https://www=2Espinics=2Enet/lists/netdev/msg644412=2Ehtml
>>=20
>>   The reason I'm posting this is the approach is a bit different=20
>>   and there may be ways of synthesizing the approaches=2E
>
>I see no overlap between patch sets whatsoever=2E
>Why do you think there is?
>
>> - The mechanism of vmlinux BTF initialization is not fit for purpose
>>   in a printk() setting as I understand it (it uses mutex locking
>>   to prevent multiple initializations of the BTF info)=2E  A simple
>>   approach to support printk might be to simply initialize the
>>   BTF vmlinux case early in boot; it only needs to happen once=2E
>>   Any suggestions here would be great=2E
>> - BTF-based rendering is more complex than other printk() format
>>   specifier-driven methods; that said, because of its generality it
>>   does provide significant value I think
>> - More tests are needed=2E
>
>yep=2E Please make sure to add one to selftest/bpf as well=2E
>bpf maintainers don't run printk tests as part of workflow, so
>future BTF changes will surely break it if there are no selftests/bpf=2E
>
>Patch 2 isn't quite correct=2E Early parse of vmlinux BTF does not
>compute
>resolved_ids to save kernel memory=2E The trade off is execution time vs
>kernel
>memory=2E I believe that saving memory is more important here, since
>execution is
>not in critical path=2E There is __get_type_size()=2E It should be used i=
n
>later
>patches instead of btf_type_id_size() that relies on pre-computed
>resolved_sizes and resolved_ids=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
