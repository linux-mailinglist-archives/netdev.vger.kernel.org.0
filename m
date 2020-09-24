Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28606277B6F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIXWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:03:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:48780 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:03:45 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZL3-0003yW-5q; Fri, 25 Sep 2020 00:03:41 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZL3-000O02-0f; Fri, 25 Sep 2020 00:03:41 +0200
Subject: Re: [PATCH bpf-next 5/6] bpf, selftests: use bpf_tail_call_static
 where appropriate
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <0c8a5df84b2f174412c252ad32734d3545947b31.1600967205.git.daniel@iogearbox.net>
 <20200924192508.GA34764@ranger.igk.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <600a91d1-bade-c46f-4dc9-24d31daceb55@iogearbox.net>
Date:   Fri, 25 Sep 2020 00:03:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200924192508.GA34764@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 9:25 PM, Maciej Fijalkowski wrote:
> On Thu, Sep 24, 2020 at 08:21:26PM +0200, Daniel Borkmann wrote:
>> For those locations where we use an immediate tail call map index use the
>> newly added bpf_tail_call_static() helper.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   tools/testing/selftests/bpf/progs/bpf_flow.c  | 12 ++++----
>>   tools/testing/selftests/bpf/progs/tailcall1.c | 28 +++++++++----------
>>   tools/testing/selftests/bpf/progs/tailcall2.c | 14 +++++-----
>>   tools/testing/selftests/bpf/progs/tailcall3.c |  4 +--
>>   .../selftests/bpf/progs/tailcall_bpf2bpf1.c   |  4 +--
>>   .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  6 ++--
>>   .../selftests/bpf/progs/tailcall_bpf2bpf3.c   |  6 ++--
>>   .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  6 ++--
>>   8 files changed, 40 insertions(+), 40 deletions(-)
> 
> One nit, while you're at it, maybe it would be good to also address the
> samples/bpf/sockex3_kern.c that is also using the immediate map index?

Sure, np, will add.
