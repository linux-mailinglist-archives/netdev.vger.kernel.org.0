Return-Path: <netdev+bounces-5045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7875370F868
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 493051C20DCC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BA718C01;
	Wed, 24 May 2023 14:15:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA617AD5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:15:39 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A0F11D;
	Wed, 24 May 2023 07:15:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 3AB9F60171;
	Wed, 24 May 2023 16:15:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684937732; bh=jX+U2qFkL9kOsl3dg0r8zNgfUzZNcOzw0PDQGkAamNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WUBXTR/QeyhHwgnNm5r9PJ08PA2rzdgAlfNohV9mnHMW66F+rg0dv1yrVcv68Wj3F
	 QLKiwDGgaElv61Ic0NPqI28uEQPIbW3fZjkW2QpAT76fRbB/y26oMUJFNdj8VFpq9+
	 G37RE/Hp314P9PiX4RsqKB4R2eq5DKjJoFAA//wgIYH6WEMhBDFVaQZ2G1Esln2afZ
	 LMPHp2Buc3KImvskb8zu/XQWGGdgsnBJE4v3JrFThSRosVoRWZu0zfGtzY7or8OGYb
	 zberJTyZXT/bnn0756FfXt5xCrxMuIzX/pQ6+8d+sJFdajCqZJ+dH4uYIEkhgbDkCu
	 1QaOmR6ot9eTg==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9N6Spi061kV4; Wed, 24 May 2023 16:15:29 +0200 (CEST)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
	by domac.alu.hr (Postfix) with ESMTPSA id A02346016E;
	Wed, 24 May 2023 16:15:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684937729; bh=jX+U2qFkL9kOsl3dg0r8zNgfUzZNcOzw0PDQGkAamNs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aa3ToDy02ohu1xgY1IJSmLT7oZGksuVgdPch5gQYpB2oMOrHuwOxAXyqsTGxReO9R
	 0yCvpf4aImJqhxZfQN/u/V7bN/stV7Sigf1Hbnf2PpvO2pK9XNLIt3bdRW6oNkqzZn
	 9e2+oCGCkhSn5VetrIgRHcq0sk3SHPclLVk0lpvowgd4xJASFgFRZKl4vNiALPSTe9
	 h1PMX5MMhxVpWyoAX0gmeqvm6n4rq2xU7zVG0fH/KQ6Ut6Ls09L40NnYa/B3dRXQkp
	 G1CsBzLlZBFHABcN0dLjirMPwZQEv5ok4iyrIeD4aQFe2BL37ROF2I6v+z4/Fgykiz
	 iFFns9Yzs2HVQ==
Message-ID: <29ae885c-cb7f-412a-43c7-22df8052831b@alu.unizg.hr>
Date: Wed, 24 May 2023 16:15:23 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [BUG] selftests: af_unix: unix:diag.c does not compile on
 AlmaLinux 8.7
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
References: <c993180f-22a8-130a-8487-74fbe4c81335@alu.unizg.hr>
 <20230522182623.67385-1-kuniyu@amazon.com>
Content-Language: en-US, hr
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230522182623.67385-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On 5/22/23 20:26, Kuniyuki Iwashima wrote:
>>>
>>> I launched AlmaLinux/RockyLinux 8.7 and 9.2 with images listed in the pages
>>> below.
>>>
>>>     https://wiki.almalinux.org/cloud/AWS.html#community-amis
>>>     https://rockylinux.org/cloud-images/
>>>
>>> The kernel versions in each image were :
>>>
>>>     8.7:
>>>     Alma  : 4.18.0-425.3.1.el8.x86_64
>>>     Rocky : 4.18.0-425.10.1.el8_7.x86_64
>>>
>>>     9.2:
>>>     Alma  : 5.14.0-284.11.1.el9_2.x86_64
>>>     Rocky : 5.14.0-284.11.1.el9_2.x86_64
>>>
>>> So, this is not a bug.  It's just because v4.18 does not support
>>> UNIX_DIAG_UID, which was introduced in v5.3.
>>>
>>> You should install 5.3+ kernel if you want to build the test.
>>>
>>> Thanks,
>>> Kuniyuki
>>
>> Hi, Kuniyuki,
>>
>> Good point. However, newer kernel won't save me from old /usr/include
>> headers, will it?
> 
> Sorry, I meant kernel and kernel-headers package that should be
> updated along with kernel.
> 
> You should use proper header files that match to the actual kernel
> version running on the machine.
> 
> 
>> I was actually testing the 6.4-rc3 on AlmaLinux 8.7, as it is my only
>> RHEL-based box ...
>>
>> What would then be the right action?
> 
> make headers_install ?

I would rather not to. For the installation to remain manageable,
preferably I'd have a kernel-devel RPM built.

>> If it was a #define instead of enum, I'd probably work around and
>> exclude the test that doesn't fit the kernel, or the system call
>> would return -EINVAL?
>>
>> Including from the includes that came with the kernel might be
>> a solution:
>>
>> ../../../../../include/uapi/linux/unix_diag.h:44:	UNIX_DIAG_UID,
>>
>> Alas, when I try to include, I get these ugly errors:
>>
>> [marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ diag_uid.c
>> In file included from ../../../../../include/linux/build_bug.h:5,
>>                    from ../../../../../include/linux/bits.h:21,
>>                    from ../../../../../include/linux/capability.h:18,
>>                    from ../../../../../include/linux/netlink.h:6,
>>                    from diag_uid.c:8:
>> ../../../../../include/linux/compiler.h:246:10: fatal error:
>> asm/rwonce.h: No such file or directory
>>    #include <asm/rwonce.h>
>>             ^~~~~~~~~~~~~~
> 
> FWIW, this is provided by kernel-devel package.

Actually, what is provided is essentially the same as before:

[root@pc-mtodorov kernel]# rpm -q --fileprovide kernel-devel-6.3.3 | grep rwonce.h
/usr/src/kernels/6.3.3-100.fc37.x86_64/arch/x86/include/generated/asm/rwonce.h	
/usr/src/kernels/6.3.3-100.fc37.x86_64/include/asm-generic/rwonce.h	
[root@pc-mtodorov kernel]#

>> compilation terminated.
>> [marvin@pc-mtodorov af_unix]$ vi +246
>> ../../../../../include/linux/compiler.h
>> [marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
>> ../../../../../include/asm-generic/rwonce.h
>> [marvin@pc-mtodorov af_unix]$
>>
>> Minimum reproducer is:
>>
>> [marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ reproducer.c
>> In file included from ../../../../../include/linux/build_bug.h:5,
>>                    from ../../../../../include/linux/bits.h:21,
>>                    from ../../../../../include/linux/capability.h:18,
>>                    from ../../../../../include/linux/netlink.h:6,
>>                    from reproducer.c:5:
>> ../../../../../include/linux/compiler.h:246:10: fatal error:
>> asm/rwonce.h: No such file or directory
>>    #include <asm/rwonce.h>
>>             ^~~~~~~~~~~~~~
>> compilation terminated.
>> [marvin@pc-mtodorov af_unix]$
>>
>> [marvin@pc-mtodorov af_unix]$ nl reproducer.c
>>
>>        1	#define _GNU_SOURCE
>>        2	#include <linux/netlink.h>
>>
>> [marvin@pc-mtodorov af_unix]$
>>
>> Am I doing something very stupid right now, for actually I see
>>
>> #include <asm/rwonce.h>
>>
>> in "include/linux/compiler.h" 248L, 7843C
>>
>> while actual rwonce.h is in <asm-generic/rwonce.h>
>>
>> [marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
>> ../../../../../include/asm-generic/rwonce.h
>> [marvin@pc-mtodorov af_unix]$
>>
>> I must be doing something wrong, for I see that the kernel compiled
>> despite not having include/asm ?
>>
>> When looking at the invocations of rwonce.h in the kernel, they seem to
>> be equally spread between <asm-generic/rwonce.h> and <asm/rwonce.h> :
>>
>> [marvin@pc-mtodorov af_unix]$ grep --include="*.[ch]" -n -w rwonce.h -r ../../../../.. 2> /dev/null | less
>> ../../../../../arch/alpha/include/asm/rwonce.h:33:#include <asm-generic/rwonce.h>
>> ../../../../../arch/arm64/include/asm/rwonce.h:71:#include <asm-generic/rwonce.h>
>> ../../../../../arch/arm64/kvm/hyp/include/nvhe/spinlock.h:18:#include <asm/rwonce.h>
>> ../../../../../arch/s390/include/asm/rwonce.h:29:#include <asm-generic/rwonce.h>
>> ../../../../../arch/x86/include/generated/asm/rwonce.h:1:#include <asm-generic/rwonce.h>
>> ../../../../../include/asm-generic/barrier.h:18:#include <asm/rwonce.h>
>> ../../../../../include/kunit/test.h:29:#include <asm/rwonce.h>
>> ../../../../../include/linux/compiler.h:246:#include <asm/rwonce.h>
>>
>> I figured out I must be doing something wrong or the kernel otherwise
>> would not build for me.
>>
>> Eventually, the UNIX_DIAG_UID enum is used in only one place:
>>
>>           ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>
>> That particular test should fail in case of kernel older than 5.3.
> 
> We don't expect it to be run on older kernels in the first place.

Certainly.

>> However, I fell into a terrible mess where one thing breaks the other.
>>
>> I can't seem to make this work.
>>
>> Thanks,
>> Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia

