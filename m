Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D38B374E97
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 06:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhEFEdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 00:33:00 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:46034 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhEFEc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 00:32:59 -0400
Received: by mail-wr1-f51.google.com with SMTP id h4so4065033wrt.12;
        Wed, 05 May 2021 21:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V2lcLfMTGJiyEqYeRbot3a2OI4+wF/M882hXYStDYPs=;
        b=mQD5oln9ok1f5sy1+2wq1Is15mtn0T3muR43ICkPX7gY0nXpCOcoxFXvq2lc52CkSu
         ZlzFXf4FPK5PQJDKC5S/I9qaUxNWGpW4LVBmt5+h1yIpVTPYcBbU6B9FmCsuCSw1+z7F
         NjhNkoq3vn15p2RY38xaRe0/JgqhbnHdBpg9zOR58RaeH/38rP3PwIi0vRLfRp6MIF9V
         Yx1dWyPNmHL1NJiPNPAWsuPJHxlOc2VBoCA8HiCIK7jR/Ghy6p3ZerDczrOY/atwTVyS
         3nYvClfWmuj1fwAjJTWPgEmOEbo8R5PkuMrMkDra6B0NCsJo2y37c7aTbGwlm6Rl7A9B
         tG5Q==
X-Gm-Message-State: AOAM5311xhSLN1O2qsIqKYz+bHwKLq+h6LdfdTm2wl9tW7mdkUjwTsxQ
        XfY0yYAdSKgPVcKv1rBzMTk=
X-Google-Smtp-Source: ABdhPJx2S8lpO1atjb4O5lzwVjqcxznBhWn19wfgGaPP6EY3xlMdHMkEduODnBIz4BXOUEopPW4J2g==
X-Received: by 2002:a05:6000:102:: with SMTP id o2mr2427265wrx.337.1620275519618;
        Wed, 05 May 2021 21:31:59 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id l22sm7749332wmq.28.2021.05.05.21.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 21:31:58 -0700 (PDT)
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
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com> <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava> <20210505135612.GZ6564@kitsune.suse.cz>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <5a225970-32a2-1617-b264-bc40a2179618@kernel.org>
Date:   Thu, 6 May 2021 06:31:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210505135612.GZ6564@kitsune.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05. 05. 21, 15:56, Michal Suchánek wrote:
> On Mon, Apr 26, 2021 at 09:16:36PM +0200, Jiri Olsa wrote:
>> On Mon, Apr 26, 2021 at 06:03:19PM +0200, Jiri Olsa wrote:
>>> On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
>>>>
>>>>
>>>> On 4/26/21 5:14 AM, Michal Suchánek wrote:
>>>>> On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
>>>>>> On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
>>>>>>> On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
>>>>>>>> On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
>>>>>>>>> On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 4/23/21 6:05 AM, Michal Suchánek wrote:
>>>>>>>>>>> Hello,
>>>>>>>>>>>
>>>>>>>>>>> I see this build error in linux-next (config attached).
>>>>>>>>>>>
>>>>>>>>>>> [ 4939s]   LD      vmlinux
>>>>>>>>>>> [ 4959s]   BTFIDS  vmlinux
>>>>>>>>>>> [ 4959s] FAILED unresolved symbol cubictcp_state
>>>>>>>>>>> [ 4960s] make[1]: ***
>>>>>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
>>>>>>>>>>> vmlinux] Error 255
>>>>>>>>>>> [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
>>>
>>> this one was reported by Jesper and was fixed by upgrading pahole
>>> that contains the new function generation fixes (v1.19)
> 
> It needs pahole 1.21 here, 1.19 was not sufficient. Even then it
> regressed again after 5.12 on arm64:

Could you try against devel:tools? I've removed the ftrace filter from 
dwarves there (sr#890247 to factory).

>    LD      vmlinux
> ld: warning: -z relro ignored
>    BTFIDS  vmlinux
> FAILED unresolved symbol cubictcp_state
> make[1]: *** [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12.0.13670.g5e321ded302d/linux-5.12-13670-g5e321ded302d/Makefile:1196: vmlinux] Error 255
> make: *** [../Makefile:215: __sub-make] Error 2
> 
> Any idea what might be wrong with arm64?


-- 
js
suse labs
