Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D35E196A2
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 04:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEJCR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 22:17:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33556 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfEJCR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 22:17:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so2203034pgv.0;
        Thu, 09 May 2019 19:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=7VYa/MEIVczpQRsw/RIk5RlJQFeInzCPJlDSn6sQGlg=;
        b=JHERfb9ZyjPyresjl9aaDPqMeZKvF1FShLS/m/ky8TScHxGL7U+T41SIotnyVJS0fc
         2FY9A5LmqWxn+vAlqbZExhT5ldiYywh3m5zOkftJHULEpCBDnkrYZRBvY8luW212ft+G
         O/PuCodxHnAc/SfeVWA5WXoZxYTAb3XnFQ/qiBcwa2vu4bI4LgJ3AaCrxrQtlis8SZoI
         GwDZVz2OGO4rxbWJ0nv7sFZYIWKpr0jL9TKhWMC5Ozz8O3C1vXN572tv7HwaPPeNvK1R
         oOgAtAI3Ey6T4aktpOkNr65izSB/w+GrIhDbtTORx7rw4Zf+xDvBj2aaUxnX1tYEr/9H
         3K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=7VYa/MEIVczpQRsw/RIk5RlJQFeInzCPJlDSn6sQGlg=;
        b=Kple7zYfpo3XmEp24s1fBDHipAsYKiuYnJE/o/5KmI6WJ+tRvc7AWLyTKb2poVuYOu
         jy9RPmFMHuJPZgLXTqQ58c2PTPgWBqzC5jvM+AvDoE3zMLfC6pEjyUTTh9u+1pne8VMU
         ZvTRtzPzk5IW0+TXxyAlL8DDakz5y2roRODxLE2NCOGXNTOkoJUGmuJyuahPZd02iwgY
         71eZ8nWd8SF7QmNSZZZo+lQ/9udfY4GCT7ZPGiN4XxdeaIroyPU/f+fZruIpDYQBVu+z
         lE8bwlEU+UsZNO9OVBcdnSi1pW41/u8TQNrQiDIoIDLoLQbEtQk8zAWmKmX5UVpG24F4
         uZRQ==
X-Gm-Message-State: APjAAAWsWNGa7x9nksZQ9NIqdC2hjOud6tE97Ib70gVPz+SnJe1yXIRe
        2l99s6GpCuGej4NAhOQ5dMI=
X-Google-Smtp-Source: APXvYqyN1LffL7F3Fkqy7BlJsuFNIt6pIHf7nT4kRmDNyze3slWFemEJt1HD2iYXKotUMa8gsivQAA==
X-Received: by 2002:aa7:8b83:: with SMTP id r3mr10214828pfd.248.1557454677889;
        Thu, 09 May 2019 19:17:57 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::b86c])
        by smtp.gmail.com with ESMTPSA id l1sm4508118pgp.9.2019.05.09.19.17.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 19:17:57 -0700 (PDT)
Date:   Thu, 9 May 2019 19:17:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        shuah <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net
Subject: Re: [GIT PULL] Kselftest update for Linux 5.2-rc1
Message-ID: <20190510021750.bxjda2wbuj3hdml7@ast-mbp>
References: <9b434125-44b6-0e83-4f70-d1fd28752407@linuxfoundation.org>
 <20190509222043.b4zn32kuohduzzzr@ast-mbp>
 <dd983d42-d148-372d-3e57-b97c313d58b9@linuxfoundation.org>
 <28072ca5-f7c8-f16d-6881-aec3e8b61ae8@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28072ca5-f7c8-f16d-6881-aec3e8b61ae8@linuxfoundation.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 07:42:09PM -0600, Shuah Khan wrote:
> On 5/9/19 4:40 PM, Shuah Khan wrote:
> > On 5/9/19 4:20 PM, Alexei Starovoitov wrote:
> > > On Mon, May 06, 2019 at 10:56:56AM -0600, Shuah Khan wrote:
> > > > Hi Linus,
> > > > 
> > > > Please pull the following Kselftest update for Linux 5.2-rc1
> > > > 
> > > > This Kselftest update for Linux 5.2-rc1 consists of
> > > > 
> > > > - fixes to seccomp test, and kselftest framework
> > > > - cleanups to remove duplicate header defines
> > > > - fixes to efivarfs "make clean" target
> > > > - cgroup cleanup path
> > > > - Moving the IMA kexec_load selftest to selftests/kexec work from
> > > >    Mimi Johar and Petr Vorel
> > > > - A framework to kselftest for writing kernel test modules addition
> > > >    from Tobin C. Harding
> > > > 
> > > > diff is attached.
> > > > 
> > > > thanks,
> > > > -- Shuah
> > > > 
> > > > 
> > > > ----------------------------------------------------------------
> > > > The following changes since commit
> > > > 15ade5d2e7775667cf191cf2f94327a4889f8b9d:
> > > > 
> > > >    Linux 5.1-rc4 (2019-04-07 14:09:59 -1000)
> > > > 
> > > > are available in the Git repository at:
> > > > 
> > > >    git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> > > > tags/linux-kselftest-5.2-rc1
> > > > 
> > > > for you to fetch changes up to d917fb876f6eaeeea8a2b620d2a266ce26372f4d:
> > > > 
> > > >    selftests: build and run gpio when output directory is the src dir
> > > > (2019-04-22 17:02:26 -0600)
> > > > 
> > > > ----------------------------------------------------------------
> > > > linux-kselftest-5.2-rc1
> > > > 
> > > > This Kselftest update for Linux 5.2-rc1 consists of
> > > > 
> > > > - fixes to seccomp test, and kselftest framework
> > > > - cleanups to remove duplicate header defines
> > > > - fixes to efivarfs "make clean" target
> > > > - cgroup cleanup path
> > > > - Moving the IMA kexec_load selftest to selftests/kexec work from
> > > >    Mimi Johar and Petr Vorel
> > > > - A framework to kselftest for writing kernel test modules addition
> > > >    from Tobin C. Harding
> > > > 
> > > > ----------------------------------------------------------------
> > > > Kees Cook (3):
> > > >        selftests/seccomp: Handle namespace failures gracefully
> > > >        selftests/harness: Add 30 second timeout per test
> > > >        selftests/ipc: Fix msgque compiler warnings
> > > > 
> > > > Mathieu Desnoyers (1):
> > > >        rseq/selftests: Adapt number of threads to the number of
> > > > detected cpus
> > > > 
> > > > Mimi Zohar (9):
> > > >        selftests/kexec: move the IMA kexec_load selftest to
> > > > selftests/kexec
> > > >        selftests/kexec: cleanup the kexec selftest
> > > >        selftests/kexec: define a set of common functions
> > > >        selftests/kexec: define common logging functions
> > > >        selftests/kexec: define "require_root_privileges"
> > > >        selftests/kexec: kexec_file_load syscall test
> > > >        selftests/kexec: check kexec_load and kexec_file_load are enabled
> > > >        selftests/kexec: make kexec_load test independent of IMA
> > > > being enabled
> > > >        selftests/kexec: update get_secureboot_mode
> > > > 
> > > > Petr Vorel (1):
> > > >        selftests/kexec: Add missing '=y' to config options
> > > > 
> > > > Po-Hsu Lin (1):
> > > >        selftests/efivarfs: clean up test files from test_create*()
> > > > 
> > > > Roman Gushchin (1):
> > > >        selftests: cgroup: fix cleanup path in
> > > > test_memcg_subtree_control()
> > > > 
> > > > Sabyasachi Gupta (4):
> > > >        selftest/x86/mpx-dig.c: Remove duplicate header
> > > >        selftest/timers: Remove duplicate header
> > > >        selftest/rseq: Remove duplicate header
> > > >        selftest/gpio: Remove duplicate header
> > > > 
> > > > Shuah Khan (2):
> > > >        selftests: fix headers_install circular dependency
> > > 
> > > Shuah,
> > > 
> > > the commit 8ce72dc32578 ("selftests: fix headers_install circular
> > > dependency")
> > > broke our build/test workflow, since it added:
> > >    ifneq ($(KBUILD_OUTPUT),)
> > >            OUTPUT := $(KBUILD_OUTPUT)
> > >    else
> > > 
> > > which means that all of selftests/bpf artifacts are now going into
> > > main build directory cluttering it with all sorts of .o, generated files
> > > and executables.
> > > The end result is humans and scripts can no longer find tests.
> 
> bpf build fails with the above commit. However, even without it, I am
> seeing bpf objects going to tools/testing/selftests/bpf
> 
> I reverted the commit and ran your use-case:
> 
> export KBUILD_OUTPUT=/tmp/kselftest_bpf
> cd tools/testing/selftests/bpf/
> make
> ./test_verifier
> 
> I see bpf objects in tools/testing/selftests/bpf/ and I can run the
> test.
> 
> What am I missing? The only way ./test_verifier would work is if
> test_verifier is in tools/testing/selftests/bpf/

That's the point. All artifacts should be in tools/testing/selftests/bpf/
if 'make' was done there regardless of KBUILD_OUTPUT.

> I am curious what you are actually seeing with this commit?
> 
> With the 8ce72dc32578
> 
> What I see is - if KBUILD_OUTPUT directory is missing, then the make
> just fails and the following diff fixes that problem:

KBUILD_OUTPUT is a valid dir where kernel build goes.

> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 098dd0065fb1..074ce7d26a9d 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -13,6 +13,7 @@ ifeq (0,$(MAKELEVEL))
>                 DEFAULT_INSTALL_HDR_PATH := 1
>         endif
>      endif
> +$(shell mkdir -p $(OUTPUT))

makefile should not create the dir this automatically.

>  endif
>  selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
> 
> 
> Now when I run
> 
> cd tools/testing/selftests/bpf/
> make
> ./test_verifier
> 
> bpf objects end up in /tmp/kselftest_bpf
> 
> which is what should happen when KBUILD_OUPUT is set.

No. KBUILD_OUPUT must be ignored while building selftests/bpf.
Just like it's ignored when samples/bpf/ are build.
People do 'cd samples/bpf; make; run stuff'
and they do the same 'cd .../selftests/bpf; make; run'

