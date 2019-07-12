Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89321672C6
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfGLPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:51:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:54090 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfGLPvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:51:21 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxpO-0002Kk-Ih; Fri, 12 Jul 2019 17:51:18 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlxpO-000VXF-Cl; Fri, 12 Jul 2019 17:51:18 +0200
Subject: Re: [PATCH v2 bpf-next 0/3] fix BTF verification size resolution
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20190711065307.2425636-1-andriin@fb.com>
 <0143c2e9-ac0d-33de-3019-85016d771c76@fb.com>
 <bf74b176-9321-c175-359d-4c5cf58a72b4@iogearbox.net>
 <CAEf4BzY-7MLt8hvBqMMdhpAq3ih_KFjgWitN3TSf74FypeAPRw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2618db68-7b2c-1e0c-708b-0af1e046025d@iogearbox.net>
Date:   Fri, 12 Jul 2019 17:51:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY-7MLt8hvBqMMdhpAq3ih_KFjgWitN3TSf74FypeAPRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 05:42 PM, Andrii Nakryiko wrote:
> On Fri, Jul 12, 2019 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 07/12/2019 08:03 AM, Yonghong Song wrote:
>>> On 7/10/19 11:53 PM, Andrii Nakryiko wrote:
>>>> BTF size resolution logic isn't always resolving type size correctly, leading
>>>> to erroneous map creation failures due to value size mismatch.
>>>>
>>>> This patch set:
>>>> 1. fixes the issue (patch #1);
>>>> 2. adds tests for trickier cases (patch #2);
>>>> 3. and converts few test cases utilizing BTF-defined maps, that previously
>>>>     couldn't use typedef'ed arrays due to kernel bug (patch #3).
>>>>
>>>> Patch #1 can be applied against bpf tree, but selftest ones (#2 and #3) have
>>>> to go against bpf-next for now.
>>>
>>> Why #2 and #3 have to go to bpf-next? bpf tree also accepts tests,
>>> AFAIK. Maybe leave for Daniel and Alexei to decide in this particular case.
>>
>> Yes, corresponding test cases for fixes are also accepted for bpf tree, thanks.
> 
> Thanks for merging, Daniel! My thinking was that at the time I posted
> patch set, BTF-defined map tests weren't yet merged into bpf, so I
> assumed it has to go against bpf-next.

Not yet merged given the minor change needed resulting from Yonghong's feedback.

Thanks,
Daniel
