Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36707269310
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgINRYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgINRXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:23:48 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA618C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:23:47 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e11so9320347wme.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0hSns9sLLool+A+lxPFi24bZQIv2n6NsxCtF1ZjcZM0=;
        b=tQJkkljgT+5MctoBuw4qL2k52RbokpIzeebJ1n17i2GJRiWVRDCflislAOGhyomihN
         DNO8q70uhKgGZ/4SKfanpHQtl2Ki2mL1ZRbYLH53otK1Ykph6bQisEXaoK3HKoa5Zpda
         3KLe9wk6ViyLvKgPQOzXOdZmGNekonKOXBzOHM2Si00IDzNTrPwCO+/ZZ08UMcotAYDN
         FiyBjltWmVAbvID9RNImECsWMv/SYWuCspjWWYSlmbyNnVPM9f7Wj4cxEv3A8qIqi3BJ
         BiwefzqaZsuBUHu8iy/2erp1n0o9+X4vXtejhqQykSvfMqTikQ10WBLB1XxoDQJzDaIy
         h0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0hSns9sLLool+A+lxPFi24bZQIv2n6NsxCtF1ZjcZM0=;
        b=gWFqQ0C4f7LHksH8RNA8kGnnUy5IhsWxvku5t7NlNSMqsl2rFTSB/dv3kxiarRUOO6
         snZ67+ndyf+qW8v8dtmTPtnvy5mxn31nFCYHykgluIQuSctcKpNS0ygo+DQAUM7TqSJ9
         bGLn68toZSY66/JRiIc3heANd0KDWVNQn4jPhkGWzy7nz9h32guzpAUcK+ME14Fruw9y
         Jl8dOQdOgtVffKh1wx52VsL22SzNwAkcVMmCbK4mn4mDNMExVkWYmDYrQzXxcTG4WSG5
         sp2t4hRDePkLl/d9rOzEPOInw8PViYlqDznJiB82W7byIQEb3kXjUBlbyJsJ/lE65bBu
         ygFg==
X-Gm-Message-State: AOAM5320nDgGUWZAlrTx3PauKKGmT6SSkd+4qg77o0sBuk5VT/wnDejO
        kactrcUnbzcSqJkCmUNqmKmGPA==
X-Google-Smtp-Source: ABdhPJzpKlBs6vl5lU73tbbYur4EKrQgasZ6ODcgNnsncL0bVzxQq7Ge/Wn/79gs1QoJ840OUBxDfA==
X-Received: by 2002:a7b:cd8b:: with SMTP id y11mr440960wmj.172.1600104226243;
        Mon, 14 Sep 2020 10:23:46 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.117])
        by smtp.gmail.com with ESMTPSA id v17sm21651717wrr.60.2020.09.14.10.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 10:23:45 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpftool: fix build failure
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
References: <20200914061206.2625395-1-yhs@fb.com>
 <b942625c-7140-0a57-337e-3a95020cfa99@isovalent.com>
 <1ab672c7-f333-f953-16ec-49e9099b39d7@fb.com>
 <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <c8c33847-9ca6-5b81-ef03-02ce382acfb6@isovalent.com>
Date:   Mon, 14 Sep 2020 18:23:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:82.0) Gecko/20100101
 Thunderbird/82.0a1
MIME-Version: 1.0
In-Reply-To: <ca0b4c63-5632-f8a0-9669-975d1119c1e6@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2020 17:54, Yonghong Song wrote:
> 
> 
> On 9/14/20 9:46 AM, Yonghong Song wrote:
>>
>>
>> On 9/14/20 1:16 AM, Quentin Monnet wrote:
>>> On 14/09/2020 07:12, Yonghong Song wrote:
>>>> When building bpf selftests like
>>>>    make -C tools/testing/selftests/bpf -j20
>>>> I hit the following errors:
>>>>    ...
>>>>    GEN     
>>>> /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-gen.8
>>>>
>>>>    <stdin>:75: (WARNING/2) Block quote ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:71: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:85: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:57: (WARNING/2) Block quote ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:66: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:109: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:175: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    <stdin>:273: (WARNING/2) Literal block ends without a blank line;
>>>> unexpected unindent.
>>>>    make[1]: ***
>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-perf.8]
>>>> Error 12
>>>>    make[1]: *** Waiting for unfinished jobs....
>>>>    make[1]: ***
>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-iter.8]
>>>> Error 12
>>>>    make[1]: ***
>>>> [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/Documentation/bpftool-struct_ops.8]
>>>> Error 12
>>>>    ...
>>>>
>>>> I am using:
>>>>    -bash-4.4$ rst2man --version
>>>>    rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>>>>    -bash-4.4$
>>>>
>>>> Looks like that particular version of rst2man prefers to have a
>>>> blank line
>>>> after literal blocks. This patch added block lines in related .rst
>>>> files
>>>> and compilation can then pass.
>>>>
>>>> Cc: Quentin Monnet <quentin@isovalent.com>
>>>> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE
>>>> ALSO" sections in man pages")
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>
>>>
>>> Hi Yonghong, thanks for the fix! I didn't see those warnings on my
>>> setup. For the record my rst2man version is:
>>>
>>>     rst2man (Docutils 0.16 [release], Python 3.8.2, on linux)
>>>
>>> Your patch looks good, but instead of having blank lines at the end of
>>> most files, could you please check if the following works?
>>
>> Thanks for the tip! I looked at the generated output again. My above
>> fix can silent the warning, but certainly not correct.
>>
>> With the following change, I captured the intermediate result of the
>> .rst file.
>>
>>   ifndef RST2MAN_DEP
>>          $(error "rst2man not found, but required to generate man pages")
>>   endif
>> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
>> $(RST2MAN_OPTS) > $@
>> +       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | tee
>> /tmp/tt | rst2man $(RST2MAN_OPTS) > $@
>>
>> With below command,
>>     make clean && make bpftool-cgroup.8
>> I can get the new .rst file for bpftool-cgroup.
>>
>> At the end of file /tmp/tt (changed bpftool-cgroup.rst), I see
>>
>>      ID       AttachType      AttachFlags     Name
>> \n SEE ALSO\n========\n\t**bpf**\ (2),\n\t**bpf-helpers**\
>> (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>> (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>> (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>> (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>> (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>> (8),\n\t**bpftool-struct_ops**\ (8)\n
>>
>> This sounds correct if we rst2man can successfully transforms '\n'
>> or '\t' to proper encoding in the man page.
>>
>> Unfortunately, with my version of rst2man, I got
>>
>> .IP "System Message: WARNING/2 (<stdin>:, line 146)"
>> Literal block ends without a blank line; unexpected unindent.
>> .sp
>> n SEE
>> ALSOn========nt**bpf**(2),nt**bpf\-helpers**(7),nt**bpftool**(8),nt**bpftool\-btf**(8),nt**bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bpftool\-link**(8),nt**bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftool\-prog**(8),nt**bpftool\-struct_ops**(8)n
>>
>> .\" Generated by docutils manpage writer.
>>
>> The rst2man simply considered \n as 'n'. The same for '\t' and
>> this caused the issue.
>>
>> I did not find a way to fix the problem https://www.google.com/url?q=https://zoom.us/j/94864957378?pwd%3DbXFRL1ZaRUxTbDVKcm9uRitpTXgyUT09&sa=D&source=calendar&ust=1600532408208000&usg=AOvVaw3SJ0i8oz4ZM-GRb7hYkrYlyet.
> 
> The following change works for me.
> 
> @@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
>  ifndef RST2MAN_DEP
>         $(error "rst2man not found, but required to generate man pages")
>  endif
> -       $(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man
> $(RST2MAN_OPTS) > $@
> +       $(QUIET_GEN)( cat $< ; echo -e $(call see_also,$<) ) | rst2man
> $(RST2MAN_OPTS) > $@
> 
>  clean: helpers-clean
>         $(call QUIET_CLEAN, Documentation)
> -bash-4.4$
> 
> I will send revision 2 shortly.

Thanks Yonghong, but this does not work on my setup :/. The version of
echo which is called on my machine from the Makefile does not seem to
interpret the "-e" option and writes something like "-e\nSEE ALSO",
which causes rst2man to complain.

I suspect the portable option here would be printf, even though Andrii
had some concerns that we could pass a format specifier through the file
names [0].

Would this work on your setup?

	$(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man...

Would that be acceptable?

[0]
https://lore.kernel.org/bpf/ca595fd6-e807-ac8e-f15f-68bfc7b7dbc4@isovalent.com/T/#m01bb298fd512121edd5e77a26ed5382c0c53939e

Quentin
