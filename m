Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6202E371184
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 08:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhECGMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 02:12:48 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:33345 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhECGMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 02:12:47 -0400
Received: by mail-ed1-f46.google.com with SMTP id b17so1942843ede.0;
        Sun, 02 May 2021 23:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u6dllkfTunOmmWDlfdYLQPlhXcmW/nhP0re3VgLHi0A=;
        b=jDSMUfI8NTtT+j1QpJp26a3hx/sZUCgQIpXFs1CjL0bNPp3dyh1MxOtqNi6NInX/Tg
         HdPDb3XbFVBe4JcxhkKMi+IHkGW9H7KFGSLxH32mtoyyuVjDn8d942TswljNKP2jbVuE
         jvJAGo5ShM6pBF+O7nLVUfrWwYeGpnKqEo7oaoTe33iUcVY3AQrQPbkSBtSw7Mq1o6bM
         Oh655AZLgiY3MpU+M3m5HD9WhqSXVgkGNfZ30gTdEf8XPf240BdMPDB1WXJTj3gy6wY6
         7U3UKhnjwYXWiQfy4JKoIhLur698z0UuHdNfd3xRnnZAMCQEKb+OQRdR7eAU3bsNFiOt
         +cJw==
X-Gm-Message-State: AOAM533TVUi0oTf5C3ZORonITUgBkuJCX8k2uw/XJ4fnWGrzLCcNTPn2
        LNC1EbRLrhA2Wp9Xu4nfwYc=
X-Google-Smtp-Source: ABdhPJwujS7TKACTBSJsGznqtoH6PAnWwtS/tVhuGvBvHrh9s48flAss/rGF3MYieOY1O+/CbbRWMQ==
X-Received: by 2002:aa7:c789:: with SMTP id n9mr18514262eds.352.1620022312298;
        Sun, 02 May 2021 23:11:52 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id r15sm7525253edp.62.2021.05.02.23.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 23:11:51 -0700 (PDT)
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
From:   Jiri Slaby <jirislaby@kernel.org>
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com> <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava> <20210427121237.GK6564@kitsune.suse.cz>
 <20210430174723.GP15381@kitsune.suse.cz>
 <3d148516-0472-8f0a-085b-94d68c5cc0d5@suse.com>
Message-ID: <6c14f3c8-7474-9f3f-b4a6-2966cb19e1ed@kernel.org>
Date:   Mon, 3 May 2021 08:11:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <3d148516-0472-8f0a-085b-94d68c5cc0d5@suse.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01. 05. 21, 8:45, Jiri Slaby wrote:
> On 30. 04. 21, 19:47, Michal Suchánek wrote:
>> CC another Jiri
>>
>> On Tue, Apr 27, 2021 at 02:12:37PM +0200, Michal Suchánek wrote:
>>> On Mon, Apr 26, 2021 at 09:16:36PM +0200, Jiri Olsa wrote:
>>>> On Mon, Apr 26, 2021 at 06:03:19PM +0200, Jiri Olsa wrote:
>>>>> On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 4/26/21 5:14 AM, Michal Suchánek wrote:
>>>>>>> On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
>>>>>>>> On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
>>>>>>>>> On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
>>>>>>>>>> On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
>>>>>>>>>>> On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 4/23/21 6:05 AM, Michal Suchánek wrote:
>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>
>>>>>>>>>>>>> I see this build error in linux-next (config attached).
>>>>>>>>>>>>>
>>>>>>>>>>>>> [ 4939s]   LD      vmlinux
>>>>>>>>>>>>> [ 4959s]   BTFIDS  vmlinux
>>>>>>>>>>>>> [ 4959s] FAILED unresolved symbol cubictcp_state
>>>>>>>>>>>>> [ 4960s] make[1]: ***
>>>>>>>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277: 
>>>>>>>>>>>>>
>>>>>>>>>>>>> vmlinux] Error 255
>>>>>>>>>>>>> [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
>>>>>
>>>>> this one was reported by Jesper and was fixed by upgrading pahole
>>>>> that contains the new function generation fixes (v1.19)
>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Looks like you have DYNAMIC_FTRACE config option enabled 
>>>>>>>>>>>> already.
>>>>>>>>>>>> Could you try a later version of pahole?
>>>>>>>>>>>
>>>>>>>>>>> Is this requireent new?
>>>>>>>>>>>
>>>>>>>>>>> I have pahole 1.20, and master does build without problems.
>>>>>>>>>>>
>>>>>>>>>>> If newer version is needed can a check be added?
>>>>>>>>>>
>>>>>>>>>> With dwarves 1.21 some architectures are fixed and some report 
>>>>>>>>>> other
>>>>>>>>>> missing symbol. Definitely an improvenent.
>>>>>>>>>>
>>>>>>>>>> I see some new type support was added so it makes sense if 
>>>>>>>>>> that type is
>>>>>>>>>> used the new dwarves are needed.
>>>>>>>>>
>>>>>>>>> Ok, here is the current failure with dwarves 1.21 on 5.12:
>>>>>>>>>
>>>>>>>>> [ 2548s]   LD      vmlinux
>>>>>>>>> [ 2557s]   BTFIDS  vmlinux
>>>>>>>>> [ 2557s] FAILED unresolved symbol vfs_truncate
>>>>>>>>> [ 2558s] make[1]: ***
>>>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-kvmsmall-5.12.0/linux-5.12/Makefile:1213: 
>>>>>>>>>
>>>>>>>>> vmlinux] Error 255
>>>>>>
>>>>>> This is PPC64, from attached config:
>>>>>>    CONFIG_PPC64=y
>>>>>> I don't have environment to cross-compile for PPC64.
>>>>>> Jiri, could you take a look? Thanks!
>>>>>
>>>>> looks like vfs_truncate did not get into BTF data,
>>>>> I'll try to reproduce
> 
> _None_ of the functions are generated by pahole -J from debuginfo on 
> ppc64. debuginfo appears to be correct. Neither pahole -J fs/open.o 
> works correctly. collect_functions in dwarves seems to be defunct on 
> ppc64... "functions" array is bogus (so find_function -- the bsearch -- 
> fails).

It's not that bogus. I forgot an asterisk:
> #0  find_function (btfe=0x100269f80, name=0x10024631c "stream_open") at /usr/src/debug/dwarves-1.21-1.1.ppc64/btf_encoder.c:350
> (gdb) p (*functions)@84
> $5 = {{name = 0x7ffff68e0922 ".__se_compat_sys_ftruncate", addr = 75232, size = 72, sh_addr = 65536, generated = false}, {
>     name = 0x7ffff68e019e ".__se_compat_sys_open", addr = 80592, size = 216, sh_addr = 65536, generated = false}, {
>     name = 0x7ffff68e0076 ".__se_compat_sys_openat", addr = 80816, size = 232, sh_addr = 65536, generated = false}, {
>     name = 0x7ffff68e0908 ".__se_compat_sys_truncate", addr = 74304, size = 100, sh_addr = 65536, generated = false}, {
...
>     name = 0x7ffff68e0808 ".stream_open", addr = 65824, size = 72, sh_addr = 65536, generated = false}, {
...
>     name = 0x7ffff68e0751 ".vfs_truncate", addr = 73392, size = 544, sh_addr = 65536, generated = false}}

The dot makes the difference, of course. The question is why is it 
there? I keep looking into it. Only if someone has an immediate idea...

thanks,
-- 
js
suse labs
