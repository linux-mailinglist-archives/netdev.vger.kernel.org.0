Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA628F90C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbgJOTCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:02:15 -0400
Received: from www62.your-server.de ([213.133.104.62]:45596 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgJOTCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:02:13 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kT8Vu-00019f-VQ; Thu, 15 Oct 2020 21:02:10 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kT8Vu-000DmG-OL; Thu, 15 Oct 2020 21:02:10 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
References: <20201014043638.3770558-1-songliubraving@fb.com>
 <20201015042928.hvluj5xbz3qxqq6r@ast-mbp.dhcp.thefacebook.com>
 <5A67779B-B40B-46D4-8863-A804E20FD43C@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1bc18cef-0a73-7a8e-0293-483f9775be26@iogearbox.net>
Date:   Thu, 15 Oct 2020 21:02:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5A67779B-B40B-46D4-8863-A804E20FD43C@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25958/Thu Oct 15 15:56:23 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/20 7:50 AM, Song Liu wrote:
>> On Oct 14, 2020, at 9:29 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>> On Tue, Oct 13, 2020 at 09:36:38PM -0700, Song Liu wrote:
>>> Fix the following error when compiling selftests/bpf
>>>
>>> progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
>>>
>>> pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
>>> error by renaming pids_cgrp_id as pids_cgroup_id.
>>>
>>> Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
>>> tools/testing/selftests/bpf/progs/profiler.inc.h | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
>>> index 00578311a4233..b554c1e40b9fb 100644
>>> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
>>> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
>>> @@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_node* node)
>>> 	}
>>> }
>>>
>>> -int pids_cgrp_id = 1;
>>> +int pids_cgroup_id = 1;
>>
>> I would prefer to try one of three options that Andrii suggested.
> 
> Ah, I missed that email (because of vger lag, I guess). Just verified
> Andrii's version works.

Pls either you or Andrii respin in that case.
