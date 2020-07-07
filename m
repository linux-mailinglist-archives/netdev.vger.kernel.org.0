Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1004B217BFE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgGGX7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:59:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:44756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbgGGX7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 19:59:42 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsxUx-0000AD-47; Wed, 08 Jul 2020 01:59:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsxUw-000QOe-U1; Wed, 08 Jul 2020 01:59:38 +0200
Subject: Re: [PATCH bpf-next v2 0/4] samples: bpf: refactor BPF map test with
 libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20200707184855.30968-1-danieltimlee@gmail.com>
 <CAEf4BzY1JQcq6LBpwjSi8XwK_7+ktwz53ZR4vk=imLQkZn1xXA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ddd88ae0-c546-3b5e-e494-5fc888da9ee8@iogearbox.net>
Date:   Wed, 8 Jul 2020 01:59:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY1JQcq6LBpwjSi8XwK_7+ktwz53ZR4vk=imLQkZn1xXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25866/Tue Jul  7 15:47:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 9:01 PM, Andrii Nakryiko wrote:
> On Tue, Jul 7, 2020 at 11:49 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>>
>> There have been many changes in how the current bpf program defines
>> map. The development of libbbpf has led to the new method called
>> BTF-defined map, which is a new way of defining BPF maps, and thus has
>> a lot of differences from the existing MAP definition method.
>>
>> Although bpf_load was also internally using libbbpf, fragmentation in
>> its implementation began to occur, such as using its own structure,
>> bpf_load_map_def, to define the map.
>>
>> Therefore, in this patch set, map test programs, which are closely
>> related to changes in the definition method of BPF map, were refactored
>> with libbbpf.
>>
>> ---
> 
> For the series:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks everyone!
