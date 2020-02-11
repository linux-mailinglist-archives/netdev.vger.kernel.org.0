Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9278A158660
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 01:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgBKABV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 19:01:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:55744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbgBKABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 19:01:21 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1IzN-0001vO-7n; Tue, 11 Feb 2020 01:01:17 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1IzM-0009zZ-T8; Tue, 11 Feb 2020 01:01:16 +0100
Subject: Re: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Brendan Gregg <bgregg@netflix.com>, Jiri Olsa <jolsa@redhat.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <cover.1576629200.git.ethercflow@gmail.com>
 <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
 <51564b9e-35f0-3c73-1701-8e351f2482d7@iogearbox.net>
 <CABtjQmbh080cFr9e_V_vutb1fErRcCvw-bNNYeJHOcah-adFCA@mail.gmail.com>
 <20200116085943.GA270346@krava>
 <CAJN39ogSo=bEEydp7s34AjtDVwXxw7_hQFrARWE4NXQwRZxSxw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c27d3cc2-f846-8aa9-10fd-c2940e7605d1@iogearbox.net>
Date:   Tue, 11 Feb 2020 01:01:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJN39ogSo=bEEydp7s34AjtDVwXxw7_hQFrARWE4NXQwRZxSxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25720/Mon Feb 10 12:53:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 5:43 AM, Brendan Gregg wrote:
> On Thu, Jan 16, 2020 at 12:59 AM Jiri Olsa <jolsa@redhat.com> wrote:
>> On Fri, Dec 20, 2019 at 11:35:08AM +0800, Wenbo Zhang wrote:
>>>> [ Wenbo, please keep also Al (added here) in the loop since he was providing
>>>>     feedback on prior submissions as well wrt vfs bits. ]
>>>
>>> Get it, thank you!
>>
>> hi,
>> is this stuck on review? I'd like to see this merged ;-)
> 
> Is this still waiting on someone? I'm writing some docs on analyzing
> file systems via syscall tracing and this will be a big improvement.

It was waiting on final review/ACK from vfs folks, but given that didn't
happen so far :/, this series should get rebased for proceeding with merge.
