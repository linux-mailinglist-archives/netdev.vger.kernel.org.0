Return-Path: <netdev+bounces-4389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA9C70C521
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6646C1C20B69
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D978168A7;
	Mon, 22 May 2023 18:26:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2111643D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:26:48 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE03FF;
	Mon, 22 May 2023 11:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684780007; x=1716316007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TN+AgCP/bHW488bJILVSuMyzFoXkjUpCxtNqMftfP0c=;
  b=tniRZjYJfniXVVnsddiWobQWt6DW+8MimAQA2SI3//3FkEZW46I8MaMR
   UPLkMlAe7XrozM87fEyuYA2G9SlxBbIxA2TkjnnrIpDSiZ95NIoACzXEj
   KmdGfXzhNX/ecmKfJyjUuOpW9G3vQPK3okfrREb8MYFb0pI4VfWyJ3KwL
   U=;
X-IronPort-AV: E=Sophos;i="6.00,184,1681171200"; 
   d="scan'208";a="340639418"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 18:26:39 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 9DFFE80C72;
	Mon, 22 May 2023 18:26:35 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 18:26:34 +0000
Received: from 88665a182662.ant.amazon.com.com (10.119.123.82) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 18:26:32 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <mirsad.todorovac@alu.unizg.hr>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <shuah@kernel.org>
Subject: Re: [BUG] selftests: af_unix: unix:diag.c does not compile on AlmaLinux 8.7
Date: Mon, 22 May 2023 11:26:23 -0700
Message-ID: <20230522182623.67385-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <c993180f-22a8-130a-8487-74fbe4c81335@alu.unizg.hr>
References: <c993180f-22a8-130a-8487-74fbe4c81335@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.119.123.82]
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Date: Mon, 22 May 2023 20:01:14 +0200
> On 5/22/23 18:28, Kuniyuki Iwashima wrote:
> > From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
> > Date: Mon, 22 May 2023 17:32:11 +0200
> >> Hi,
> >>
> >> On vanilla AlmaLinux 8.7 (CentOS fork) selftests/net/af_unix/diag_uid.c doesn't
> >> compile out of the box, giving the errors:
> >>
> >> make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
> >> gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
> >> diag_uid.c:36:16: error: ‘UDIAG_SHOW_UID’ undeclared here (not in a function); did you mean ‘UDIAG_SHOW_VFS’?
> >>     .udiag_show = UDIAG_SHOW_UID
> >>                   ^~~~~~~~~~~~~~
> >>                   UDIAG_SHOW_VFS
> >> In file included from diag_uid.c:17:
> >> diag_uid.c: In function ‘render_response’:
> >> diag_uid.c:128:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>                               ^~~~~~~~~~~~~
> >> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
> >>     __typeof__(_seen) __seen = (_seen); \
> >>                ^~~~~
> >> diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>     ^~~~~~~~~
> >> diag_uid.c:128:28: note: each undeclared identifier is reported only once for each function it appears in
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>                               ^~~~~~~~~~~~~
> >> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
> >>     __typeof__(_seen) __seen = (_seen); \
> >>                ^~~~~
> >> diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>     ^~~~~~~~~
> >> make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1
> >>
> >> The correct value is in <uapi/linux/unix_diag.h>:
> >>
> >> include/uapi/linux/unix_diag.h:23:#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
> >>
> >> The fix is as follows:
> >>
> >> ---
> >>    tools/testing/selftests/net/af_unix/diag_uid.c | 4 ++++
> >>    1 file changed, 4 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/net/af_unix/diag_uid.c b/tools/testing/selftests/net/af_unix/diag_uid.c
> >> index 5b88f7129fea..66d75b646d35 100644
> >> --- a/tools/testing/selftests/net/af_unix/diag_uid.c
> >> +++ b/tools/testing/selftests/net/af_unix/diag_uid.c
> >> @@ -16,6 +16,10 @@
> >>
> >>    #include "../../kselftest_harness.h"
> >>
> >> +#ifndef UDIAG_SHOW_UID
> >> +#define UDIAG_SHOW_UID         0x00000040      /* show socket's UID */
> >> +#endif
> >> +
> >>    FIXTURE(diag_uid)
> >>    {
> >>           int netlink_fd;
> >>
> >> --
> >>
> >> However, this patch reveals another undefined value:
> >>
> >> make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
> >> gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
> >> In file included from diag_uid.c:17:
> >> diag_uid.c: In function ‘render_response’:
> >> diag_uid.c:132:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>                               ^~~~~~~~~~~~~
> >> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
> >>     __typeof__(_seen) __seen = (_seen); \
> >>                ^~~~~
> >> diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>     ^~~~~~~~~
> >> diag_uid.c:132:28: note: each undeclared identifier is reported only once for each function it appears in
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>                               ^~~~~~~~~~~~~
> >> ../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
> >>     __typeof__(_seen) __seen = (_seen); \
> >>                ^~~~~
> >> diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
> >>     ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> >>     ^~~~~~~~~
> >> make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1
> >>
> >> Apparently, AlmaLinux 8.7 lacks this enum UNIX_DIAG_UID:
> >>
> >> diff -u /usr/include/linux/unix_diag.h include/uapi/linux/unix_diag.h
> >> --- /usr/include/linux/unix_diag.h	2023-05-16 13:47:51.000000000 +0200
> >> +++ include/uapi/linux/unix_diag.h	2022-10-12 07:35:58.253481367 +0200
> >> @@ -20,6 +20,7 @@
> >>    #define UDIAG_SHOW_ICONS	0x00000008	/* show pending connections */
> >>    #define UDIAG_SHOW_RQLEN	0x00000010	/* show skb receive queue len */
> >>    #define UDIAG_SHOW_MEMINFO	0x00000020	/* show memory info of a socket */
> >> +#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
> >>
> >>    struct unix_diag_msg {
> >>    	__u8	udiag_family;
> >> @@ -40,6 +41,7 @@
> >>    	UNIX_DIAG_RQLEN,
> >>    	UNIX_DIAG_MEMINFO,
> >>    	UNIX_DIAG_SHUTDOWN,
> >> +	UNIX_DIAG_UID,
> >>
> >>    	__UNIX_DIAG_MAX,
> >>    };
> >>
> >> Now, this is a change in enums and there doesn't seem to an easy way out
> >> here. (I think I saw an example, but I cannot recall which thread. I will do
> >> more research.)
> >>
> >> When I included
> >>
> >> # gcc -I ../../../../include diag_uid.c
> >>
> >> I've got the following error:
> >>
> >> [marvin@pc-mtodorov linux_torvalds]$ cd tools/testing/selftests/net/af_unix/
> >> [marvin@pc-mtodorov af_unix]$ gcc  -I ../../../../../include   diag_uid.c  -o
> >> /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
> >> In file included from ../../../../../include/linux/build_bug.h:5,
> >>                    from ../../../../../include/linux/bits.h:21,
> >>                    from ../../../../../include/linux/capability.h:18,
> >>                    from ../../../../../include/linux/netlink.h:6,
> >>                    from diag_uid.c:8:
> >> ../../../../../include/linux/compiler.h:246:10: fatal error: asm/rwonce.h: No such file or directory
> >>    #include <asm/rwonce.h>
> >>             ^~~~~~~~~~~~~~
> >> compilation terminated.
> >> [marvin@pc-mtodorov af_unix]$
> >>
> >> At this point I gave up, as it would be an overkill to change kernel system
> >> header to make a test pass, and this probably wouldn't be accepted upsteam?
> >>
> >> Hope this helps. (If we still want to build on CentOS/AlmaLinux/Rocky 8?)
> > 
> > I launched AlmaLinux/RockyLinux 8.7 and 9.2 with images listed in the pages
> > below.
> > 
> >    https://wiki.almalinux.org/cloud/AWS.html#community-amis
> >    https://rockylinux.org/cloud-images/
> > 
> > The kernel versions in each image were :
> > 
> >    8.7:
> >    Alma  : 4.18.0-425.3.1.el8.x86_64
> >    Rocky : 4.18.0-425.10.1.el8_7.x86_64
> > 
> >    9.2:
> >    Alma  : 5.14.0-284.11.1.el9_2.x86_64
> >    Rocky : 5.14.0-284.11.1.el9_2.x86_64
> > 
> > So, this is not a bug.  It's just because v4.18 does not support
> > UNIX_DIAG_UID, which was introduced in v5.3.
> > 
> > You should install 5.3+ kernel if you want to build the test.
> > 
> > Thanks,
> > Kuniyuki
> 
> Hi, Kuniyuki,
> 
> Good point. However, newer kernel won't save me from old /usr/include
> headers, will it?

Sorry, I meant kernel and kernel-headers package that should be
updated along with kernel.

You should use proper header files that match to the actual kernel
version running on the machine.


> I was actually testing the 6.4-rc3 on AlmaLinux 8.7, as it is my only
> RHEL-based box ...
> 
> What would then be the right action?

make headers_install ?


> If it was a #define instead of enum, I'd probably work around and
> exclude the test that doesn't fit the kernel, or the system call
> would return -EINVAL?
> 
> Including from the includes that came with the kernel might be
> a solution:
> 
> ../../../../../include/uapi/linux/unix_diag.h:44:	UNIX_DIAG_UID,
> 
> Alas, when I try to include, I get these ugly errors:
> 
> [marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ diag_uid.c
> In file included from ../../../../../include/linux/build_bug.h:5,
>                   from ../../../../../include/linux/bits.h:21,
>                   from ../../../../../include/linux/capability.h:18,
>                   from ../../../../../include/linux/netlink.h:6,
>                   from diag_uid.c:8:
> ../../../../../include/linux/compiler.h:246:10: fatal error:
> asm/rwonce.h: No such file or directory
>   #include <asm/rwonce.h>
>            ^~~~~~~~~~~~~~

FWIW, this is provided by kernel-devel package.


> compilation terminated.
> [marvin@pc-mtodorov af_unix]$ vi +246
> ../../../../../include/linux/compiler.h
> [marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
> ../../../../../include/asm-generic/rwonce.h
> [marvin@pc-mtodorov af_unix]$
> 
> Minimum reproducer is:
> 
> [marvin@pc-mtodorov af_unix]$ gcc -I ../../../../../include/ reproducer.c
> In file included from ../../../../../include/linux/build_bug.h:5,
>                   from ../../../../../include/linux/bits.h:21,
>                   from ../../../../../include/linux/capability.h:18,
>                   from ../../../../../include/linux/netlink.h:6,
>                   from reproducer.c:5:
> ../../../../../include/linux/compiler.h:246:10: fatal error:
> asm/rwonce.h: No such file or directory
>   #include <asm/rwonce.h>
>            ^~~~~~~~~~~~~~
> compilation terminated.
> [marvin@pc-mtodorov af_unix]$
> 
> [marvin@pc-mtodorov af_unix]$ nl reproducer.c
> 
>       1	#define _GNU_SOURCE
>       2	#include <linux/netlink.h>
> 
> [marvin@pc-mtodorov af_unix]$
> 
> Am I doing something very stupid right now, for actually I see
> 
> #include <asm/rwonce.h>
> 
> in "include/linux/compiler.h" 248L, 7843C
> 
> while actual rwonce.h is in <asm-generic/rwonce.h>
> 
> [marvin@pc-mtodorov af_unix]$ find ../../../../../include -name rwonce.h
> ../../../../../include/asm-generic/rwonce.h
> [marvin@pc-mtodorov af_unix]$
> 
> I must be doing something wrong, for I see that the kernel compiled
> despite not having include/asm ?
> 
> When looking at the invocations of rwonce.h in the kernel, they seem to
> be equally spread between <asm-generic/rwonce.h> and <asm/rwonce.h> :
> 
> [marvin@pc-mtodorov af_unix]$ grep --include="*.[ch]" -n -w rwonce.h -r ../../../../.. 2> /dev/null | less
> ../../../../../arch/alpha/include/asm/rwonce.h:33:#include <asm-generic/rwonce.h>
> ../../../../../arch/arm64/include/asm/rwonce.h:71:#include <asm-generic/rwonce.h>
> ../../../../../arch/arm64/kvm/hyp/include/nvhe/spinlock.h:18:#include <asm/rwonce.h>
> ../../../../../arch/s390/include/asm/rwonce.h:29:#include <asm-generic/rwonce.h>
> ../../../../../arch/x86/include/generated/asm/rwonce.h:1:#include <asm-generic/rwonce.h>
> ../../../../../include/asm-generic/barrier.h:18:#include <asm/rwonce.h>
> ../../../../../include/kunit/test.h:29:#include <asm/rwonce.h>
> ../../../../../include/linux/compiler.h:246:#include <asm/rwonce.h>
> 
> I figured out I must be doing something wrong or the kernel otherwise
> would not build for me.
> 
> Eventually, the UNIX_DIAG_UID enum is used in only one place:
> 
>          ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
> 
> That particular test should fail in case of kernel older than 5.3.

We don't expect it to be run on older kernels in the first place.


> 
> However, I fell into a terrible mess where one thing breaks the other.
> 
> I can't seem to make this work.
> 
> Thanks,
> Mirsad

