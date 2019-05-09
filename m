Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0751952B
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 00:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfEIWUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 18:20:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39999 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfEIWUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 18:20:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so1802708plr.7;
        Thu, 09 May 2019 15:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z1YADLv+X+eTaFOCPRPMkyVNxJwrl9u02E65BW40D5k=;
        b=lcbJ3zLpdbWPY6o2RCZ4AodP4ic2pzULnGi7IghozPpmKe1z1o67yEB9TIsnQngizS
         KQgXLqZNB7Ae2D6QTJeoIIqZefMYGYF5wjyAxNmtBeh5ZS633Cqonxv8mDbqMMjSRZDR
         KNS33bTuluL5H/WFj/xZ8RngtzSlE+Lf1/8paQYrrVKmxaXOoWm8NnMgpEKH6ztlYaad
         PI4+UUj4as/Xt/f8FdwsSAi1UFvM6iDeS4eALzNNvTEt665rIfZ0LHkKzXP0zOrqi6Dg
         e2TU2/pqcloLVkFbFoZh4bIvUClKXvQke538xFqKLidb8EG8zEgLTojfB0qEVQCKzKrw
         6t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z1YADLv+X+eTaFOCPRPMkyVNxJwrl9u02E65BW40D5k=;
        b=gaD0DqIqvzADPn5ow3Y2Y7MOgJCBDoj2xHvIJUPKu15jkqzcBIYwRaCzjikkhtLLW6
         DhDE4CsOqs7VVSaKTrH+4DrA1YPNECR4Ofqn6c4GOJkb5DMkg1EBbv9+lW4H8TQyye0z
         ZNe6n3OmBuI0nT7gj2h+VDStHZi7YRSTH5lZtVOPxj7lTlbePnzR0rsJjpvRCNDuRuAa
         SyivS4b2wKowzGNc9fZ8Ykeh1Wqbrf/LYilDUdoHPAmENeSyGagc3nlNvHYMZfb1BNg9
         C4nXo/tJnAko/7pH08LdYjuVGF6xF2qJzW+v0MlTt17vgFwmMN+eHe9q7TbUWcBU+0GO
         MQiA==
X-Gm-Message-State: APjAAAWnMa10DlnkpuJGs2gIqRTCzVdV9nM5p/HYVgeClmcufFi4z7iD
        juabw0K+Wm3AKrjb4Coub9k=
X-Google-Smtp-Source: APXvYqzSmVmq4+FqBEl/cq1bHlnhsA+wSlbzzJZ/8v9nTieYPU4Ln2SpEjRuNj0P80hXDrqRQNAbHg==
X-Received: by 2002:a17:902:8bca:: with SMTP id r10mr8481101plo.67.1557440449042;
        Thu, 09 May 2019 15:20:49 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::bc44])
        by smtp.gmail.com with ESMTPSA id o71sm8197898pfi.174.2019.05.09.15.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 15:20:47 -0700 (PDT)
Date:   Thu, 9 May 2019 15:20:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        shuah <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net
Subject: Re: [GIT PULL] Kselftest update for Linux 5.2-rc1
Message-ID: <20190509222043.b4zn32kuohduzzzr@ast-mbp>
References: <9b434125-44b6-0e83-4f70-d1fd28752407@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b434125-44b6-0e83-4f70-d1fd28752407@linuxfoundation.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 10:56:56AM -0600, Shuah Khan wrote:
> Hi Linus,
> 
> Please pull the following Kselftest update for Linux 5.2-rc1
> 
> This Kselftest update for Linux 5.2-rc1 consists of
> 
> - fixes to seccomp test, and kselftest framework
> - cleanups to remove duplicate header defines
> - fixes to efivarfs "make clean" target
> - cgroup cleanup path
> - Moving the IMA kexec_load selftest to selftests/kexec work from
>   Mimi Johar and Petr Vorel
> - A framework to kselftest for writing kernel test modules addition
>   from Tobin C. Harding
> 
> diff is attached.
> 
> thanks,
> -- Shuah
> 
> 
> ----------------------------------------------------------------
> The following changes since commit 15ade5d2e7775667cf191cf2f94327a4889f8b9d:
> 
>   Linux 5.1-rc4 (2019-04-07 14:09:59 -1000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> tags/linux-kselftest-5.2-rc1
> 
> for you to fetch changes up to d917fb876f6eaeeea8a2b620d2a266ce26372f4d:
> 
>   selftests: build and run gpio when output directory is the src dir
> (2019-04-22 17:02:26 -0600)
> 
> ----------------------------------------------------------------
> linux-kselftest-5.2-rc1
> 
> This Kselftest update for Linux 5.2-rc1 consists of
> 
> - fixes to seccomp test, and kselftest framework
> - cleanups to remove duplicate header defines
> - fixes to efivarfs "make clean" target
> - cgroup cleanup path
> - Moving the IMA kexec_load selftest to selftests/kexec work from
>   Mimi Johar and Petr Vorel
> - A framework to kselftest for writing kernel test modules addition
>   from Tobin C. Harding
> 
> ----------------------------------------------------------------
> Kees Cook (3):
>       selftests/seccomp: Handle namespace failures gracefully
>       selftests/harness: Add 30 second timeout per test
>       selftests/ipc: Fix msgque compiler warnings
> 
> Mathieu Desnoyers (1):
>       rseq/selftests: Adapt number of threads to the number of detected cpus
> 
> Mimi Zohar (9):
>       selftests/kexec: move the IMA kexec_load selftest to selftests/kexec
>       selftests/kexec: cleanup the kexec selftest
>       selftests/kexec: define a set of common functions
>       selftests/kexec: define common logging functions
>       selftests/kexec: define "require_root_privileges"
>       selftests/kexec: kexec_file_load syscall test
>       selftests/kexec: check kexec_load and kexec_file_load are enabled
>       selftests/kexec: make kexec_load test independent of IMA being enabled
>       selftests/kexec: update get_secureboot_mode
> 
> Petr Vorel (1):
>       selftests/kexec: Add missing '=y' to config options
> 
> Po-Hsu Lin (1):
>       selftests/efivarfs: clean up test files from test_create*()
> 
> Roman Gushchin (1):
>       selftests: cgroup: fix cleanup path in test_memcg_subtree_control()
> 
> Sabyasachi Gupta (4):
>       selftest/x86/mpx-dig.c: Remove duplicate header
>       selftest/timers: Remove duplicate header
>       selftest/rseq: Remove duplicate header
>       selftest/gpio: Remove duplicate header
> 
> Shuah Khan (2):
>       selftests: fix headers_install circular dependency

Shuah,

the commit 8ce72dc32578 ("selftests: fix headers_install circular dependency")
broke our build/test workflow, since it added:
  ifneq ($(KBUILD_OUTPUT),)
          OUTPUT := $(KBUILD_OUTPUT)
  else

which means that all of selftests/bpf artifacts are now going into
main build directory cluttering it with all sorts of .o, generated files
and executables.
The end result is humans and scripts can no longer find tests.

For now I hacked it as:
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 5979fdc4f36c..caecec7aebde 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -6,12 +6,8 @@ ifeq (0,$(MAKELEVEL))
     ifneq ($(O),)
        OUTPUT := $(O)
     else
-       ifneq ($(KBUILD_OUTPUT),)
-               OUTPUT := $(KBUILD_OUTPUT)
-       else
-               OUTPUT := $(shell pwd)
-               DEFAULT_INSTALL_HDR_PATH := 1
-       endif
+       OUTPUT := $(shell pwd)
+       DEFAULT_INSTALL_HDR_PATH := 1
     endif
 endif

bpf developers are doing "cd tools/testing/selftests/bpf; make; ./test_verifier; ..."
while KBUILD_OUTPUT is also set.
I don't quite get this 'circular dependency' issue that your commit suppose to address
but please fix it differently, so bpf developer's workflow is restored and buildbots work again.
People and scripts depend on it.
It's even described in Documentation/bpf/bpf_devel_QA.rst

Thanks

