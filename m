Return-Path: <netdev+bounces-4384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DB670C4D0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0467A1C20B8D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F4C16435;
	Mon, 22 May 2023 18:01:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084B016414
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:01:28 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2A694;
	Mon, 22 May 2023 11:01:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id 4AC576017E;
	Mon, 22 May 2023 20:01:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684778483; bh=zKQaI+VGcHZCPJRRcEZ3alsSHYf+vBMuipguuphoeHw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=MxdZ+MEapjDS6n60VS46pmlICubyNep0lzUlIwjVQPlsAeHaCYP/fvjz0+ErMpUC7
	 CZhmPPovkegp1bUTNxpgWYXiC4YpcB/Te3OWatupelB9yHm/0Roh6rq4AzLNSR1u9R
	 LSAL1TvmV2N+yTCNlRIP3DVU+K7kPWamGSNkbeP1sjLBVgNrOzsU1Nf3ATurZvpH2N
	 CAan/HCpYclZW4LBlUoPgjtv3qsjzML1PzhVSkhDxXE7zMr+8Lrk4yaLByB5EP6uPh
	 6hf2FIlDY/Rwn6Z/YLwoeyOKy+yotRf9z4e5q8e1nDZvsLQKKhd2oLMEEVCr06M3J3
	 eIxYclnew3k9w==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ddnXJioSaAxz; Mon, 22 May 2023 20:01:20 +0200 (CEST)
Received: from [192.168.1.6] (unknown [77.237.113.62])
	by domac.alu.hr (Postfix) with ESMTPSA id 9A9BA6017C;
	Mon, 22 May 2023 20:01:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684778480; bh=zKQaI+VGcHZCPJRRcEZ3alsSHYf+vBMuipguuphoeHw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=QKCRoEKEgpc1UM/zZ1CUX3VuDgVlW7d2gxxIUKAhSlEpOY4595vU3F6UB9kucfn3a
	 pBen/ziuQpD6dv44U0WSI5i8lkARB4PLBYnCi3mXQZg4l7TfHokL4JzZ80NRG7HH4x
	 lw+CGhCQdVYr7ffAv09f3EJD8ZS5YKH+9RtEruxGS05d9hixLx2Vq72LPdJfhdBsMB
	 ZP5IMVhLaovzhNl5UrvllrJSezHpMG2dN1vXGsiypOHozjBugD/mjbe0XaZoXjwJRc
	 G72UTAQmh88bvrljl4mmyZaF5ETRPgzM7yv8k9uafGCfMtGV3nLysuKCQ+xXDz34cR
	 YawTTaQwf0t1w==
Message-ID: <c993180f-22a8-130a-8487-74fbe4c81335@alu.unizg.hr>
Date: Mon, 22 May 2023 20:01:14 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: [BUG] selftests: af_unix: unix:diag.c does not compile on
 AlmaLinux 8.7
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
References: <edac34c9-190c-0d80-8d95-2f42971cc870@alu.unizg.hr>
 <20230522162843.49731-1-kuniyu@amazon.com>
Content-Language: en-US
In-Reply-To: <20230522162843.49731-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/22/23 18:28, Kuniyuki Iwashima wrote:
> From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
> Date: Mon, 22 May 2023 17:32:11 +0200
>> Hi,
>>
>> On vanilla AlmaLinux 8.7 (CentOS fork) selftests/net/af_unix/diag_uid.c doesn't
>> compile out of the box, giving the errors:
>>
>> make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
>> gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
>> diag_uid.c:36:16: error: ‘UDIAG_SHOW_UID’ undeclared here (not in a function); did you mean ‘UDIAG_SHOW_VFS’?
>>     .udiag_show = UDIAG_SHOW_UID
>>                   ^~~~~~~~~~~~~~
>>                   UDIAG_SHOW_VFS
>> In file included from diag_uid.c:17:
>> diag_uid.c: In function ‘render_response’:
>> diag_uid.c:128:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>                               ^~~~~~~~~~~~~
>> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
>>     __typeof__(_seen) __seen = (_seen); \
>>                ^~~~~
>> diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>     ^~~~~~~~~
>> diag_uid.c:128:28: note: each undeclared identifier is reported only once for each function it appears in
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>                               ^~~~~~~~~~~~~
>> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
>>     __typeof__(_seen) __seen = (_seen); \
>>                ^~~~~
>> diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>     ^~~~~~~~~
>> make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1
>>
>> The correct value is in <uapi/linux/unix_diag.h>:
>>
>> include/uapi/linux/unix_diag.h:23:#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
>>
>> The fix is as follows:
>>
>> ---
>>    tools/testing/selftests/net/af_unix/diag_uid.c | 4 ++++
>>    1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/testing/selftests/net/af_unix/diag_uid.c b/tools/testing/selftests/net/af_unix/diag_uid.c
>> index 5b88f7129fea..66d75b646d35 100644
>> --- a/tools/testing/selftests/net/af_unix/diag_uid.c
>> +++ b/tools/testing/selftests/net/af_unix/diag_uid.c
>> @@ -16,6 +16,10 @@
>>
>>    #include "../../kselftest_harness.h"
>>
>> +#ifndef UDIAG_SHOW_UID
>> +#define UDIAG_SHOW_UID         0x00000040      /* show socket's UID */
>> +#endif
>> +
>>    FIXTURE(diag_uid)
>>    {
>>           int netlink_fd;
>>
>> --
>>
>> However, this patch reveals another undefined value:
>>
>> make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
>> gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
>> In file included from diag_uid.c:17:
>> diag_uid.c: In function ‘render_response’:
>> diag_uid.c:132:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>                               ^~~~~~~~~~~~~
>> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
>>     __typeof__(_seen) __seen = (_seen); \
>>                ^~~~~
>> diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>     ^~~~~~~~~
>> diag_uid.c:132:28: note: each undeclared identifier is reported only once for each function it appears in
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>                               ^~~~~~~~~~~~~
>> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
>>     __typeof__(_seen) __seen = (_seen); \
>>                ^~~~~
>> diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
>>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
>>     ^~~~~~~~~
>> make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1
>>
>> Apparently, AlmaLinux 8.7 lacks this enum UNIX_DIAG_UID:
>>
>> diff -u /usr/include/linux/unix_diag.h include/uapi/linux/unix_diag.h
>> --- /usr/include/linux/unix_diag.h	2023-05-16 13:47:51.000000000 +0200
>> +++ include/uapi/linux/unix_diag.h	2022-10-12 07:35:58.253481367 +0200
>> @@ -20,6 +20,7 @@
>>    #define UDIAG_SHOW_ICONS	0x00000008	/* show pending connections */
>>    #define UDIAG_SHOW_RQLEN	0x00000010	/* show skb receive queue len */
>>    #define UDIAG_SHOW_MEMINFO	0x00000020	/* show memory info of a socket */
>> +#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
>>
>>    struct unix_diag_msg {
>>    	__u8	udiag_family;
>> @@ -40,6 +41,7 @@
>>    	UNIX_DIAG_RQLEN,
>>    	UNIX_DIAG_MEMINFO,
>>    	UNIX_DIAG_SHUTDOWN,
>> +	UNIX_DIAG_UID,
>>
>>    	__UNIX_DIAG_MAX,
>>    };
>>
>> Now, this is a change in enums and there doesn't seem to an easy way out
>> here. (I think I saw an example, but I cannot recall which thread. I will do
>> more research.)
>>
>> When I included
>>
>> # gcc -I ../../../../include diag_uid.c
>>
>> I've got the following error:
>>
>> [marvin@pc-mtodorov linux_torvalds]$ cd tools/testing/selftests/net/af_unix/
>> [marvin@pc-mtodorov af_unix]$ gcc  -I ../../../../../include   diag_uid.c  -o
>> /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
>> In file included from ../../../../../include/linux/build_bug.h:5,
>>                    from ../../../../../include/linux/bits.h:21,
>>                    from ../../../../../include/linux/capability.h:18,
>>                    from ../../../../../include/linux/netlink.h:6,
>>                    from diag_uid.c:8:
>> ../../../../../include/linux/compiler.h:246:10: fatal error: asm/rwonce.h: No such file or directory
>>    #include <asm/rwonce.h>
>>             ^~~~~~~~~~~~~~
>> compilation terminated.
>> [marvin@pc-mtodorov af_unix]$
>>
>> At this point I gave up, as it would be an overkill to change kernel system
>> header to make a test pass, and this probably wouldn't be accepted upsteam?
>>
>> Hope this helps. (If we still want to build on CentOS/AlmaLinux/Rocky 8?)
> 
> I launched AlmaLinux/RockyLinux 8.7 and 9.2 with images listed in the pages
> below.
> 
>    https://wiki.almalinux.org/cloud/AWS.html#community-amis
>    https://rockylinux.org/cloud-images/
> 
> The kernel versions in each image were :
> 
>    8.7:
>    Alma  : 4.18.0-425.3.1.el8.x86_64
>    Rocky : 4.18.0-425.10.1.el8_7.x86_64
> 
>    9.2:
>    Alma  : 5.14.0-284.11.1.el9_2.x86_64
>    Rocky : 5.14.0-284.11.1.el9_2.x86_64
> 
> So, this is not a bug.  It's just because v4.18 does not support
> UNIX_DIAG_UID, which was introduced in v5.3.
> 
> You should install 5.3+ kernel if you want to build the test.
> 
> Thanks,
> Kuniyuki

Hi, Kuniyuki,

Good point. However, newer kernel won't save me from old /usr/include
headers, will it?

I was actually testing the 6.4-rc3 on AlmaLinux 8.7, as it is my only
RHEL-based box ...

What would then be the right action?

If it was a #define instead of enum, I'd probably work around and
exclude the test that doesn't fit the kernel, or the system call
would return -EINVAL?

Including from the includes that came with the kernel might be
a solution:

../../../../../include/uapi/linux/unix_diag.h:44:	UNIX_DIAG_UID,

Alas, when I try to include, I get these ugly errors:

[marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ diag_uid.c
In file included from ../../../../../include/linux/build_bug.h:5,
                  from ../../../../../include/linux/bits.h:21,
                  from ../../../../../include/linux/capability.h:18,
                  from ../../../../../include/linux/netlink.h:6,
                  from diag_uid.c:8:
../../../../../include/linux/compiler.h:246:10: fatal error:
asm/rwonce.h: No such file or directory
  #include <asm/rwonce.h>
           ^~~~~~~~~~~~~~
compilation terminated.
[marvin@pc-mtodorov af_unix]$ vi +246
../../../../../include/linux/compiler.h
[marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
../../../../../include/asm-generic/rwonce.h
[marvin@pc-mtodorov af_unix]$

Minimum reproducer is:

[marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ reproducer.c
In file included from ../../../../../include/linux/build_bug.h:5,
                  from ../../../../../include/linux/bits.h:21,
                  from ../../../../../include/linux/capability.h:18,
                  from ../../../../../include/linux/netlink.h:6,
                  from reproducer.c:5:
../../../../../include/linux/compiler.h:246:10: fatal error:
asm/rwonce.h: No such file or directory
  #include <asm/rwonce.h>
           ^~~~~~~~~~~~~~
compilation terminated.
[marvin@pc-mtodorov af_unix]$

[marvin@pc-mtodorov af_unix]$ nl reproducer.c

      1	#define _GNU_SOURCE
      2	#include <linux/netlink.h>

[marvin@pc-mtodorov af_unix]$

Am I doing something very stupid right now, for actually I see

#include <asm/rwonce.h>

in "include/linux/compiler.h" 248L, 7843C

while actual rwonce.h is in <asm-generic/rwonce.h>

[marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
../../../../../include/asm-generic/rwonce.h
[marvin@pc-mtodorov af_unix]$

I must be doing something wrong, for I see that the kernel compiled
despite not having include/asm ?

When looking at the invocations of rwonce.h in the kernel, they seem to
be equally spread between <asm-generic/rwonce.h> and <asm/rwonce.h> :

[marvin@pc-mtodorov af_unix]$ grep --include="*.[ch]" -n -w rwonce.h -r ../../../../.. 2> /dev/null | less
../../../../../arch/alpha/include/asm/rwonce.h:33:#include <asm-generic/rwonce.h>
../../../../../arch/arm64/include/asm/rwonce.h:71:#include <asm-generic/rwonce.h>
../../../../../arch/arm64/kvm/hyp/include/nvhe/spinlock.h:18:#include <asm/rwonce.h>
../../../../../arch/s390/include/asm/rwonce.h:29:#include <asm-generic/rwonce.h>
../../../../../arch/x86/include/generated/asm/rwonce.h:1:#include <asm-generic/rwonce.h>
../../../../../include/asm-generic/barrier.h:18:#include <asm/rwonce.h>
../../../../../include/kunit/test.h:29:#include <asm/rwonce.h>
../../../../../include/linux/compiler.h:246:#include <asm/rwonce.h>

I figured out I must be doing something wrong or the kernel otherwise
would not build for me.

Eventually, the UNIX_DIAG_UID enum is used in only one place:

         ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);

That particular test should fail in case of kernel older than 5.3.

However, I fell into a terrible mess where one thing breaks the other.

I can't seem to make this work.

Thanks,
Mirsad

