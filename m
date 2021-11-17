Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B79455093
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhKQWga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:36:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:51022 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbhKQWga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:36:30 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnTUb-0008nM-IJ; Wed, 17 Nov 2021 23:33:25 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mnTUb-000RY3-AB; Wed, 17 Nov 2021 23:33:25 +0100
Subject: Re: [PATCH 1/1] Documentation: Add minimum pahole version
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <YZPQ6+u2wTHRfR+W@kernel.org>
 <CAEf4BzbOnpL-=2Xi1DOheUtzc-JG5FmHqdvs4B_+0OeaCTgY=w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <df39b24d-7813-c6fb-a9eb-a5c199e002d0@iogearbox.net>
Date:   Wed, 17 Nov 2021 23:33:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbOnpL-=2Xi1DOheUtzc-JG5FmHqdvs4B_+0OeaCTgY=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26356/Wed Nov 17 10:26:25 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 7:21 PM, Andrii Nakryiko wrote:
> On Tue, Nov 16, 2021 at 7:40 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
>>
>> A report was made in https://github.com/acmel/dwarves/issues/26 about
>> pahole not being listed in the process/changes.rst file as being needed
>> for building the kernel, address that.
>>
>> Link: https://github.com/acmel/dwarves/issues/26
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Andrii Nakryiko <andrii@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: bpf@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>> ---
>>   Documentation/process/changes.rst | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
>> index e35ab74a0f804b04..c45f167a1b6c02a4 100644
>> --- a/Documentation/process/changes.rst
>> +++ b/Documentation/process/changes.rst
>> @@ -35,6 +35,7 @@ GNU make               3.81             make --version
>>   binutils               2.23             ld -v
>>   flex                   2.5.35           flex --version
>>   bison                  2.0              bison --version
>> +pahole                 1.16             pahole --version
>>   util-linux             2.10o            fdformat --version
>>   kmod                   13               depmod -V
>>   e2fsprogs              1.41.4           e2fsck -V
>> @@ -108,6 +109,14 @@ Bison
>>   Since Linux 4.16, the build system generates parsers
>>   during build.  This requires bison 2.0 or later.
>>
>> +pahole:
>> +-------
>> +
>> +Since Linux 5.2 the build system generates BTF (BPF Type Format) from DWARF in
>> +vmlinux, a bit later from kernel modules as well, if CONFIG_DEBUG_INFO_BTF is
> 
> I'd probably emphasize a bit more that pahole is required only if
> CONFIG_DEBUG_INFO_BTF is selected by moving "If CONFIG_DEBUG_INFO_BTF
> is selected, " to the front. But either way looks good.

+1, I presume Jonathan will later pick up the v2?

> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
>> +selected.  This requires pahole v1.16 or later. It is found in the 'dwarves' or
>> +'pahole' distro packages or from https://fedorapeople.org/~acme/dwarves/.
>> +
>>   Perl
>>   ----
>>
>> --
>> 2.31.1
>>

