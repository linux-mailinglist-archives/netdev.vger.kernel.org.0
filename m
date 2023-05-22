Return-Path: <netdev+bounces-4346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A5170C26A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB888280FC0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291AF14AAC;
	Mon, 22 May 2023 15:32:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD3314AAA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:32:19 +0000 (UTC)
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D054E0;
	Mon, 22 May 2023 08:32:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by domac.alu.hr (Postfix) with ESMTP id D265D6017E;
	Mon, 22 May 2023 17:32:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684769534; bh=RqvuOsJ8S7XdjoXvu70wev1e9QQK7l1N40NzkMAHzX8=;
	h=Date:From:Subject:To:Cc:From;
	b=LT5j5SjAGNIFjpZFPLIxMxTA8kJEM6iiS/Cx4UJNgNxQyU6aU2vmu5fC4bQTS/1S2
	 fqdEYzhR++jqx8rT5uU2u0j+waMJv9Th92bfHCd1AWZeXtjF/m8PCvHohjyjtemRFa
	 jPD++DKXZ8Y67dbSVXKImbjz3Dq/sUgYSxLClTtPQ7SLeaSvutlVGi93HaG3IUKwY5
	 hoad7FZ1SmRvoT9dcooE0T0S7n6Y0hH08hQ9Ud9Edr0QoPGKn8Go9K6+/mKnjmDlOU
	 QeAvYxWUAqPzHQnpy6JGj2tN/tgEp7BLYipxOc5uWYHtuTxDZPUiaJm0mAn4qvl1Do
	 eWTfXolOUaL4A==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
	by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cccNu_K_Opy5; Mon, 22 May 2023 17:32:12 +0200 (CEST)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
	by domac.alu.hr (Postfix) with ESMTPSA id 971516017C;
	Mon, 22 May 2023 17:32:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
	t=1684769532; bh=RqvuOsJ8S7XdjoXvu70wev1e9QQK7l1N40NzkMAHzX8=;
	h=Date:From:Subject:To:Cc:From;
	b=b2MBIAjoXrkkWbHzTTNiaL8Ybasp/aWQctqNzYBXy5Sdat2DFo2HG4enNPsO56KFl
	 jldM9PvrgPVvCHxV+VNf4JoqLlC9E3eD6eVflKp0V0WpxMWC8K9yXvu7wKmbjRgn+A
	 BDb69+8SFkxyrg00mceEXwoOVTov9duFzJyAxV06WjzQgruLqqrfaEHA/Lnj2CP0K0
	 nowm7CBa3qhHwOXGSlyWMHQ1ydOawOAIup9QWGUFafUvuGm9RYZIqUTzMESzJIrKb0
	 uquXjs5lmCu6xSSfp+EVWJlOhChF9k9ADeYaNEaSK8nYUFDeNZMslrvBWTr6JF4BuR
	 VbRR6eNJnjBSQ==
Message-ID: <edac34c9-190c-0d80-8d95-2f42971cc870@alu.unizg.hr>
Date: Mon, 22 May 2023 17:32:11 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, hr
From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [BUG] selftests: af_unix: unix:diag.c does not compile on AlmaLinux
 8.7
To: linux-kselftest@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On vanilla AlmaLinux 8.7 (CentOS fork) selftests/net/af_unix/diag_uid.c doesn't
compile out of the box, giving the errors:

make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
diag_uid.c:36:16: error: ‘UDIAG_SHOW_UID’ undeclared here (not in a function); did you mean ‘UDIAG_SHOW_VFS’?
   .udiag_show = UDIAG_SHOW_UID
                 ^~~~~~~~~~~~~~
                 UDIAG_SHOW_VFS
In file included from diag_uid.c:17:
diag_uid.c: In function ‘render_response’:
diag_uid.c:128:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
                             ^~~~~~~~~~~~~
../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
   __typeof__(_seen) __seen = (_seen); \
              ^~~~~
diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
   ^~~~~~~~~
diag_uid.c:128:28: note: each undeclared identifier is reported only once for each function it appears in
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
                             ^~~~~~~~~~~~~
../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
   __typeof__(_seen) __seen = (_seen); \
              ^~~~~
diag_uid.c:128:2: note: in expansion of macro ‘ASSERT_EQ’
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
   ^~~~~~~~~
make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1

The correct value is in <uapi/linux/unix_diag.h>:

include/uapi/linux/unix_diag.h:23:#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */

The fix is as follows:

---
  tools/testing/selftests/net/af_unix/diag_uid.c | 4 ++++
  1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/af_unix/diag_uid.c b/tools/testing/selftests/net/af_unix/diag_uid.c
index 5b88f7129fea..66d75b646d35 100644
--- a/tools/testing/selftests/net/af_unix/diag_uid.c
+++ b/tools/testing/selftests/net/af_unix/diag_uid.c
@@ -16,6 +16,10 @@

  #include "../../kselftest_harness.h"

+#ifndef UDIAG_SHOW_UID
+#define UDIAG_SHOW_UID         0x00000040      /* show socket's UID */
+#endif
+
  FIXTURE(diag_uid)
  {
         int netlink_fd;

--

However, this patch reveals another undefined value:

make[2]: Entering directory '/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix'
gcc     diag_uid.c  -o /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
In file included from diag_uid.c:17:
diag_uid.c: In function ‘render_response’:
diag_uid.c:132:28: error: ‘UNIX_DIAG_UID’ undeclared (first use in this function); did you mean ‘UNIX_DIAG_VFS’?
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
                             ^~~~~~~~~~~~~
../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
   __typeof__(_seen) __seen = (_seen); \
              ^~~~~
diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
   ^~~~~~~~~
diag_uid.c:132:28: note: each undeclared identifier is reported only once for each function it appears in
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
                             ^~~~~~~~~~~~~
../../kselftest_harness.h:707:13: note: in definition of macro ‘__EXPECT’
   __typeof__(_seen) __seen = (_seen); \
              ^~~~~
diag_uid.c:132:2: note: in expansion of macro ‘ASSERT_EQ’
   ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
   ^~~~~~~~~
make[2]: *** [../../lib.mk:147: /home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid] Error 1

Apparently, AlmaLinux 8.7 lacks this enum UNIX_DIAG_UID:

diff -u /usr/include/linux/unix_diag.h include/uapi/linux/unix_diag.h
--- /usr/include/linux/unix_diag.h	2023-05-16 13:47:51.000000000 +0200
+++ include/uapi/linux/unix_diag.h	2022-10-12 07:35:58.253481367 +0200
@@ -20,6 +20,7 @@
  #define UDIAG_SHOW_ICONS	0x00000008	/* show pending connections */
  #define UDIAG_SHOW_RQLEN	0x00000010	/* show skb receive queue len */
  #define UDIAG_SHOW_MEMINFO	0x00000020	/* show memory info of a socket */
+#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */

  struct unix_diag_msg {
  	__u8	udiag_family;
@@ -40,6 +41,7 @@
  	UNIX_DIAG_RQLEN,
  	UNIX_DIAG_MEMINFO,
  	UNIX_DIAG_SHUTDOWN,
+	UNIX_DIAG_UID,

  	__UNIX_DIAG_MAX,
  };

Now, this is a change in enums and there doesn't seem to an easy way out
here. (I think I saw an example, but I cannot recall which thread. I will do
more research.)

When I included

# gcc -I ../../../../include diag_uid.c

I've got the following error:

[marvin@pc-mtodorov linux_torvalds]$ cd tools/testing/selftests/net/af_unix/
[marvin@pc-mtodorov af_unix]$ gcc  -I ../../../../../include   diag_uid.c  -o 
/home/marvin/linux/kernel/linux_torvalds/tools/testing/selftests/net/af_unix/diag_uid
In file included from ../../../../../include/linux/build_bug.h:5,
                  from ../../../../../include/linux/bits.h:21,
                  from ../../../../../include/linux/capability.h:18,
                  from ../../../../../include/linux/netlink.h:6,
                  from diag_uid.c:8:
../../../../../include/linux/compiler.h:246:10: fatal error: asm/rwonce.h: No such file or directory
  #include <asm/rwonce.h>
           ^~~~~~~~~~~~~~
compilation terminated.
[marvin@pc-mtodorov af_unix]$

At this point I gave up, as it would be an overkill to change kernel system
header to make a test pass, and this probably wouldn't be accepted upsteam?

Hope this helps. (If we still want to build on CentOS/AlmaLinux/Rocky 8?)

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia

