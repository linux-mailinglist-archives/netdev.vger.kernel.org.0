Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3773705FC
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhEAGrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 02:47:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:43466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231754AbhEAGrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 02:47:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619851552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVBYz21hZFVWl0rGf5AAOhNfDjOUFQtjK3wVvXDOuzA=;
        b=UWhaGL2weORb/atlMfIQZGvuOf8cWGH3HXrq9acnsEWgHo9YTlhpARKBRtWa6dtHg+Pzzk
        3gVS5JRJmygzbMRc0Y1OgVj1/+1H28SPLb99vl0OykrBVN9v8tjmJxgZ/RkbVVx7RphKMx
        cQTIOUFJ/2/D8ftAs9HULud1pJM3e6Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3CFDBAC1A;
        Sat,  1 May 2021 06:45:52 +0000 (UTC)
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
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
From:   Jiri Slaby <jslaby@suse.com>
Message-ID: <3d148516-0472-8f0a-085b-94d68c5cc0d5@suse.com>
Date:   Sat, 1 May 2021 08:45:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210430174723.GP15381@kitsune.suse.cz>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30. 04. 21, 19:47, Michal Suchánek wrote:
> CC another Jiri
> 
> On Tue, Apr 27, 2021 at 02:12:37PM +0200, Michal Suchánek wrote:
>> On Mon, Apr 26, 2021 at 09:16:36PM +0200, Jiri Olsa wrote:
>>> On Mon, Apr 26, 2021 at 06:03:19PM +0200, Jiri Olsa wrote:
>>>> On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 4/26/21 5:14 AM, Michal Suchánek wrote:
>>>>>> On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
>>>>>>> On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
>>>>>>>> On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
>>>>>>>>> On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
>>>>>>>>>> On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 4/23/21 6:05 AM, Michal Suchánek wrote:
>>>>>>>>>>>> Hello,
>>>>>>>>>>>>
>>>>>>>>>>>> I see this build error in linux-next (config attached).
>>>>>>>>>>>>
>>>>>>>>>>>> [ 4939s]   LD      vmlinux
>>>>>>>>>>>> [ 4959s]   BTFIDS  vmlinux
>>>>>>>>>>>> [ 4959s] FAILED unresolved symbol cubictcp_state
>>>>>>>>>>>> [ 4960s] make[1]: ***
>>>>>>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
>>>>>>>>>>>> vmlinux] Error 255
>>>>>>>>>>>> [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
>>>>
>>>> this one was reported by Jesper and was fixed by upgrading pahole
>>>> that contains the new function generation fixes (v1.19)
>>>>
>>>>>>>>>>>
>>>>>>>>>>> Looks like you have DYNAMIC_FTRACE config option enabled already.
>>>>>>>>>>> Could you try a later version of pahole?
>>>>>>>>>>
>>>>>>>>>> Is this requireent new?
>>>>>>>>>>
>>>>>>>>>> I have pahole 1.20, and master does build without problems.
>>>>>>>>>>
>>>>>>>>>> If newer version is needed can a check be added?
>>>>>>>>>
>>>>>>>>> With dwarves 1.21 some architectures are fixed and some report other
>>>>>>>>> missing symbol. Definitely an improvenent.
>>>>>>>>>
>>>>>>>>> I see some new type support was added so it makes sense if that type is
>>>>>>>>> used the new dwarves are needed.
>>>>>>>>
>>>>>>>> Ok, here is the current failure with dwarves 1.21 on 5.12:
>>>>>>>>
>>>>>>>> [ 2548s]   LD      vmlinux
>>>>>>>> [ 2557s]   BTFIDS  vmlinux
>>>>>>>> [ 2557s] FAILED unresolved symbol vfs_truncate
>>>>>>>> [ 2558s] make[1]: ***
>>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-kvmsmall-5.12.0/linux-5.12/Makefile:1213:
>>>>>>>> vmlinux] Error 255
>>>>>
>>>>> This is PPC64, from attached config:
>>>>>    CONFIG_PPC64=y
>>>>> I don't have environment to cross-compile for PPC64.
>>>>> Jiri, could you take a look? Thanks!
>>>>
>>>> looks like vfs_truncate did not get into BTF data,
>>>> I'll try to reproduce

_None_ of the functions are generated by pahole -J from debuginfo on 
ppc64. debuginfo appears to be correct. Neither pahole -J fs/open.o 
works correctly. collect_functions in dwarves seems to be defunct on 
ppc64... "functions" array is bogus (so find_function -- the bsearch -- 
fails). I didn't have more time to continue debugging. This is where I 
stopped.

regards,
-- 
js
suse labs
