Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF82619640
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 03:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfEJBmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 21:42:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46103 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfEJBmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 21:42:12 -0400
Received: by mail-io1-f65.google.com with SMTP id q21so22965iog.13
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 18:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YjvQjrdVS12KY32f62rBMl2y5YxKM5lRaU2cGrqTrlY=;
        b=iQXPM6HlBuCAcDh6qqvlr1iMhuawK9DDIaZJgwlFecOZTdaFhUEEopeiLjTqGdYcey
         Ei+XzihcT61RgeaYzQI8ihN+pomcyT6VgWelpRhqjGfxYGBOnwKt2lEKYPta21DiotKo
         tEMsFOnNMbCGKNObds/QESqwLjvSTa0J4C/wc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YjvQjrdVS12KY32f62rBMl2y5YxKM5lRaU2cGrqTrlY=;
        b=pMYLe5vUsHUTt8KpRDNr0roULCza610SQXPS5NQPMKUlga6/ClwsjRgfXqQeGSFtEv
         L5vz0a3nLW3qmVVwRfyFWCp2YTETmN0n3WpuPWciytoyDaYVYT47yPBRBsjuZX7+J70u
         FDAsNll+shRvSjGxcG8wcplVDD99MG/3+EBuvnxHxaMub5A3q3YJsAIZ/vXIlSRr4sD/
         ocmo5l8Z4iDGz7m89vzeVIoJWFnPx4l64SLwWU4ZMBXDZPrLQZiZtVDePO/0US9wHiAN
         u7PM2fZsds/KaiUuTxFxemHmL/goJHbXq7iVxZ0RpgZ0oHfWrrC8iYzuJyYa24BmYMdZ
         TNRg==
X-Gm-Message-State: APjAAAUQDlaU5aCwGzyARGFhKxBArOYoas+hcrkONYtjHSLwEHVhfmTO
        wTqcsBCJzOp9QEsjiyT/hP7ULxPVxBA=
X-Google-Smtp-Source: APXvYqzYZc7zA5KXM4nSFp5KXYZWaf+8QXVrppBmQYFU7NPIxJ+f773wIi+yyx89xJfucyYfyuz+4A==
X-Received: by 2002:a5d:9d4f:: with SMTP id k15mr5260994iok.100.1557452531643;
        Thu, 09 May 2019 18:42:11 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m25sm1796887iti.24.2019.05.09.18.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 18:42:10 -0700 (PDT)
Subject: Re: [GIT PULL] Kselftest update for Linux 5.2-rc1
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        shuah <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, Shuah Khan <skhan@linuxfoundation.org>
References: <9b434125-44b6-0e83-4f70-d1fd28752407@linuxfoundation.org>
 <20190509222043.b4zn32kuohduzzzr@ast-mbp>
 <dd983d42-d148-372d-3e57-b97c313d58b9@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <28072ca5-f7c8-f16d-6881-aec3e8b61ae8@linuxfoundation.org>
Date:   Thu, 9 May 2019 19:42:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dd983d42-d148-372d-3e57-b97c313d58b9@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/19 4:40 PM, Shuah Khan wrote:
> On 5/9/19 4:20 PM, Alexei Starovoitov wrote:
>> On Mon, May 06, 2019 at 10:56:56AM -0600, Shuah Khan wrote:
>>> Hi Linus,
>>>
>>> Please pull the following Kselftest update for Linux 5.2-rc1
>>>
>>> This Kselftest update for Linux 5.2-rc1 consists of
>>>
>>> - fixes to seccomp test, and kselftest framework
>>> - cleanups to remove duplicate header defines
>>> - fixes to efivarfs "make clean" target
>>> - cgroup cleanup path
>>> - Moving the IMA kexec_load selftest to selftests/kexec work from
>>>    Mimi Johar and Petr Vorel
>>> - A framework to kselftest for writing kernel test modules addition
>>>    from Tobin C. Harding
>>>
>>> diff is attached.
>>>
>>> thanks,
>>> -- Shuah
>>>
>>>
>>> ----------------------------------------------------------------
>>> The following changes since commit 
>>> 15ade5d2e7775667cf191cf2f94327a4889f8b9d:
>>>
>>>    Linux 5.1-rc4 (2019-04-07 14:09:59 -1000)
>>>
>>> are available in the Git repository at:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
>>> tags/linux-kselftest-5.2-rc1
>>>
>>> for you to fetch changes up to d917fb876f6eaeeea8a2b620d2a266ce26372f4d:
>>>
>>>    selftests: build and run gpio when output directory is the src dir
>>> (2019-04-22 17:02:26 -0600)
>>>
>>> ----------------------------------------------------------------
>>> linux-kselftest-5.2-rc1
>>>
>>> This Kselftest update for Linux 5.2-rc1 consists of
>>>
>>> - fixes to seccomp test, and kselftest framework
>>> - cleanups to remove duplicate header defines
>>> - fixes to efivarfs "make clean" target
>>> - cgroup cleanup path
>>> - Moving the IMA kexec_load selftest to selftests/kexec work from
>>>    Mimi Johar and Petr Vorel
>>> - A framework to kselftest for writing kernel test modules addition
>>>    from Tobin C. Harding
>>>
>>> ----------------------------------------------------------------
>>> Kees Cook (3):
>>>        selftests/seccomp: Handle namespace failures gracefully
>>>        selftests/harness: Add 30 second timeout per test
>>>        selftests/ipc: Fix msgque compiler warnings
>>>
>>> Mathieu Desnoyers (1):
>>>        rseq/selftests: Adapt number of threads to the number of 
>>> detected cpus
>>>
>>> Mimi Zohar (9):
>>>        selftests/kexec: move the IMA kexec_load selftest to 
>>> selftests/kexec
>>>        selftests/kexec: cleanup the kexec selftest
>>>        selftests/kexec: define a set of common functions
>>>        selftests/kexec: define common logging functions
>>>        selftests/kexec: define "require_root_privileges"
>>>        selftests/kexec: kexec_file_load syscall test
>>>        selftests/kexec: check kexec_load and kexec_file_load are enabled
>>>        selftests/kexec: make kexec_load test independent of IMA being 
>>> enabled
>>>        selftests/kexec: update get_secureboot_mode
>>>
>>> Petr Vorel (1):
>>>        selftests/kexec: Add missing '=y' to config options
>>>
>>> Po-Hsu Lin (1):
>>>        selftests/efivarfs: clean up test files from test_create*()
>>>
>>> Roman Gushchin (1):
>>>        selftests: cgroup: fix cleanup path in 
>>> test_memcg_subtree_control()
>>>
>>> Sabyasachi Gupta (4):
>>>        selftest/x86/mpx-dig.c: Remove duplicate header
>>>        selftest/timers: Remove duplicate header
>>>        selftest/rseq: Remove duplicate header
>>>        selftest/gpio: Remove duplicate header
>>>
>>> Shuah Khan (2):
>>>        selftests: fix headers_install circular dependency
>>
>> Shuah,
>>
>> the commit 8ce72dc32578 ("selftests: fix headers_install circular 
>> dependency")
>> broke our build/test workflow, since it added:
>>    ifneq ($(KBUILD_OUTPUT),)
>>            OUTPUT := $(KBUILD_OUTPUT)
>>    else
>>
>> which means that all of selftests/bpf artifacts are now going into
>> main build directory cluttering it with all sorts of .o, generated files
>> and executables.
>> The end result is humans and scripts can no longer find tests.

bpf build fails with the above commit. However, even without it, I am
seeing bpf objects going to tools/testing/selftests/bpf

I reverted the commit and ran your use-case:

export KBUILD_OUTPUT=/tmp/kselftest_bpf
cd tools/testing/selftests/bpf/
make
./test_verifier

I see bpf objects in tools/testing/selftests/bpf/ and I can run the
test.

What am I missing? The only way ./test_verifier would work is if
test_verifier is in tools/testing/selftests/bpf/

I am curious what you are actually seeing with this commit?

With the 8ce72dc32578

What I see is - if KBUILD_OUTPUT directory is missing, then the make
just fails and the following diff fixes that problem:

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 098dd0065fb1..074ce7d26a9d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -13,6 +13,7 @@ ifeq (0,$(MAKELEVEL))
                 DEFAULT_INSTALL_HDR_PATH := 1
         endif
      endif
+$(shell mkdir -p $(OUTPUT))
  endif
  selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))


Now when I run

cd tools/testing/selftests/bpf/
make
./test_verifier

bpf objects end up in /tmp/kselftest_bpf

which is what should happen when KBUILD_OUPUT is set.

But now ./test_verifier won't work, because it isn't in the
cd tools/testing/selftests/bpf/

Could it be that with  commit 8ce72dc32578, bpf objects are ending
up in the KBUILD_OUPUT dir and ./test_verifier won't work because
your workflow is looking for it in tools/testing/selftests/bpf/?

If this is the case, then the workfolow will be to run the
test_verifier from KBUILD_OUPUT dir.

I am trying understand the problem so I can fix it. I know I need
the above diff.


thanks,
-- Shuah


