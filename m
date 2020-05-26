Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80F1E3383
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404023AbgEZXMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:12:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:60358 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388915AbgEZXMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:12:13 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdijx-0001w7-Sg; Wed, 27 May 2020 01:12:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdijx-0002Ow-Ja; Wed, 27 May 2020 01:12:09 +0200
Subject: Re: [bpf-next PATCH v5 1/5] bpf, sk_msg: add some generic helpers
 that may be useful from sk_msg
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033903373.12355.15489763099696629346.stgit@john-Precision-5820-Tower>
 <48c47712-bba1-3f53-bbeb-8a7403dab6db@iogearbox.net>
 <5ecc4d3c78c9e_718d2b15b962e5b845@john-XPS-13-9370.notmuch>
 <CAEf4BzZ0b_UyxzyE-8+3oWSieutWov1UuVJ5Ugpn0yx8qeYNrA@mail.gmail.com>
 <5ecd8135d7ab4_35792ad4115a05b8d@john-XPS-13-9370.notmuch>
 <CAEf4Bzb7e=dpv7hP4SfLARpkDw1uTAeASRHEp9gBuK1Od=sqaA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <16c0e428-d8ff-3b76-6f38-69b6ae7dfa96@iogearbox.net>
Date:   Wed, 27 May 2020 01:12:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb7e=dpv7hP4SfLARpkDw1uTAeASRHEp9gBuK1Od=sqaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25824/Tue May 26 14:27:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 11:29 PM, Andrii Nakryiko wrote:
> On Tue, May 26, 2020 at 1:51 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>
>> Andrii Nakryiko wrote:
>>> On Mon, May 25, 2020 at 3:57 PM John Fastabend <john.fastabend@gmail.com> wrote:
>>>>
>>>> Daniel Borkmann wrote:
>>>>> On 5/24/20 6:50 PM, John Fastabend wrote:
>>>>>> Add these generic helpers that may be useful to use from sk_msg programs.
>>>>>> The helpers do not depend on ctx so we can simply add them here,
>>>>>>
>>>>>>    BPF_FUNC_perf_event_output
>>>>>>    BPF_FUNC_get_current_uid_gid
>>>>>>    BPF_FUNC_get_current_pid_tgid
>>>>>>    BPF_FUNC_get_current_comm
>>>>>
>>>>> Hmm, added helpers below are what you list here except get_current_comm.
>>>>> Was this forgotten to be added here?
>>>>
>>>> Forgot to update commit messages. I dropped it because it wasn't clear to
>>>> me it was very useful or how I would use it from this context. I figure we
>>>> can add it later if its needed.
>>>
>>> But it's also not harmful in any way and is in a similar group as
>>> get_current_pid_tgid. So let's add it sooner rather than later. There
>>> is no cost in allowing this, right?
>>>
>>
>> It shouldn't cost anything only thing is I have code that runs the other
>> three that has been deployed, at least into a dev environment, so I know
>> its useful and works.
>>
>> How about we push it as a follow up? I can add it and do some cleanups
>> on the CHECK_FAILs tonight.
> 
> Sure, no worries, works for me.

Ok, applied then, thanks!
