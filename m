Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4A49362E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 09:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347782AbiASIWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 03:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbiASIWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 03:22:38 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD8EC061574;
        Wed, 19 Jan 2022 00:22:38 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 3E8C21F44337
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642580556;
        bh=QAiGrnVKHtXCjw/54yKAb5LW6GftwIG4hgUhexVMISE=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=JohVKnqdhrmr88zSpbdIWeVwW3aFTlZUvzKGmFDgndI5DqkPMsRlz8Z96jPFtiiX0
         /VEFcHN1Eot2dnhZuuSiUQllmiUfT5+mkD2gM9mGlWWnt1S2TWLtumObED/Mhq+GZC
         drcqHoTPrLauJseDOSsl5GxyC9Z+5+eERpBMq8Bd8JUkW0mJtwjMu3/2RgHxvwIEq7
         pRFVMWddEY5sgUzcHQEEhqNbl+1xFwhtiaRVInPGfFIsYEl9C64wAmYfBTtq3Y70q4
         J4Nie9+0qLfZyJTtQbBjtMgMjJgl+Nejt2uzZGLnRgV9etJ+3P7+6JzE2pyXUQcM67
         8uQ3p0Sofitbg==
Message-ID: <ccae1b7a-4888-ca86-9610-89fd4f3d714d@collabora.com>
Date:   Wed, 19 Jan 2022 13:22:26 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     usama.anjum@collabora.com, kernel@collabora.com
Subject: Re: [PATCH 08/10] selftests: mptcp: Add the uapi headers include
 variable
Content-Language: en-US
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
References: <20220118112909.1885705-1-usama.anjum@collabora.com>
 <20220118112909.1885705-9-usama.anjum@collabora.com>
 <4d60a170-53d7-3f9f-fa48-34d6c4020346@tessares.net>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <4d60a170-53d7-3f9f-fa48-34d6c4020346@tessares.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthieu,

Thank you for putting details below.

On 1/19/22 2:47 AM, Matthieu Baerts wrote:
> Hi Muhammad,
> 
> On 18/01/2022 12:29, Muhammad Usama Anjum wrote:
>> Out of tree build of this test fails if relative path of the output
>> directory is specified. Remove the un-needed include paths and use
>> KHDR_INCLUDES to correctly reach the headers.
> 
> Thank you for looking at that!
> 
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>>  tools/testing/selftests/net/mptcp/Makefile | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
>> index 0356c4501c99..fed6866d3b73 100644
>> --- a/tools/testing/selftests/net/mptcp/Makefile
>> +++ b/tools/testing/selftests/net/mptcp/Makefile
>> @@ -1,9 +1,8 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  
>> -top_srcdir = ../../../../..
> 
> Removing this line breaks our CI validating MPTCP selftests. That's
> because this "top_srcdir" variable is needed in the "lib.mk" file which
> is included at the end of this Makefile.
> 
> But that's maybe a misuse from our side. Indeed to avoid compiling
> binaries and more from the VM, our CI does that as a preparation job
> before starting the VM and run MPTCP selftests:
> 
>   $ make O=(...) INSTALL_HDR_PATH=(...)/kselftest/usr headers_install
>   $ make O=(...) -C tools/testing/selftests/net/mptcp
> 
> From the VM, we re-use the same source directory and we can start
> individual tests without having to compile anything else:
> 
>   $ cd tools/testing/selftests/net/mptcp
>   $ ./mptcp_connect.sh
> 
> We want to do that because some scripts are launched multiple times with
> different parameters.
> 
> With your modifications, we can drop the headers_install instruction but
> we need to pass new parameters to the last 'make' command:
> 
>   $ make O=(...) top_srcdir=../../../../.. \
>                  KHDR_INCLUDES=-I(...)/usr/include \
>          -C tools/testing/selftests/net/mptcp
> 
> Or is there a better way to do that?
> Can we leave the definition of "top_srcdir" like it was or did we miss
> something else?
> 
It seems like I've missed this use cases where people can build only one
individual test. It is not my intention to break individual test builds.
I shouldn't be fixing one thing while breaking something else. I'll
update these patches such that individual tests are also build-able. For
this to happen, I'll just add $(KHDR_INCLUDES) to the build flags while
leaving everything else intact. I'll send a V2.

>>  KSFT_KHDR_INSTALL := 1
>>  
>> -CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
>> +CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g $(KHDR_INCLUDES)
>>  
>>  TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
>>  	      simult_flows.sh mptcp_sockopt.sh
> 
> Note: I see there is a very long recipients list. If my issue is not
> directly due to your modifications, we can probably continue the
> discussion with a restricted audience.
> 
> Cheers,
> Matt
