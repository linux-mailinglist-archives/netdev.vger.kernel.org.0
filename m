Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4EF368B6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfFFATw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:19:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:35100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfFFATw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:19:52 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYg8D-0006b8-Qe; Thu, 06 Jun 2019 02:19:49 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYg8D-000LUS-JF; Thu, 06 Jun 2019 02:19:49 +0200
Subject: Re: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, Andrey Ignatov <rdna@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
References: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
 <20190605235451.lqas2jgbur2sre4z@kafai-mbp.dhcp.thefacebook.com>
 <bcdc5ced-5bf0-a9c2-eeaf-01459e1d5b62@iogearbox.net>
 <CAADnVQ+nraxxKw8=ues8W3odoLx5JR3JwAjCqW3AA3W64XY77w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb3d69fb-214e-88ba-21c7-1ff4ae03b173@iogearbox.net>
Date:   Thu, 6 Jun 2019 02:19:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+nraxxKw8=ues8W3odoLx5JR3JwAjCqW3AA3W64XY77w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25471/Wed Jun  5 10:12:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2019 02:13 AM, Alexei Starovoitov wrote:
> On Wed, Jun 5, 2019 at 5:09 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>>>>  tools/bpf/bpftool/cgroup.c     |  5 ++++-
>>>>  tools/include/uapi/linux/bpf.h |  2 ++
>>> Should the bpf.h sync to tools/ be in a separate patch?
>>
>> I was thinking about it, but concluded for such small change, it's not
>> really worth it. If there's a strong opinion, I could do it, but I think
>> that 2-liner sync patch just adds noise.
> 
> it's not about the size. It breaks the sync of libbpf.
> we should really enforce user vs kernel to be separate patches.

Okay, I see. Fair enough, I'll split them in that case.

Thanks,
Daniel
