Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD843D663
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhJ0WPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:15:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:35308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhJ0WPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:15:55 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfrAh-0007Np-NP; Thu, 28 Oct 2021 00:13:23 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfrAh-00060c-GK; Thu, 28 Oct 2021 00:13:23 +0200
Subject: Re: pull-request: bpf 2021-10-26
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20211026201920.11296-1-daniel@iogearbox.net>
 <87bl3a9lc5.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <07334aca-9b58-fdae-0de9-43d44e087d76@iogearbox.net>
Date:   Thu, 28 Oct 2021 00:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87bl3a9lc5.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26335/Wed Oct 27 10:28:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/21 12:03 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> The following pull-request contains BPF updates for your *net* tree.
>>
>> We've added 12 non-merge commits during the last 7 day(s) which contain
>> a total of 23 files changed, 118 insertions(+), 98 deletions(-).
> 
> Hi Daniel
> 
> Any chance we could also get bpf merged into bpf-next? We'd like to use
> this fix:
> 
>> 1) Fix potential race window in BPF tail call compatibility check,
>> from Toke Høiland-Jørgensen.

Makes sense! I presume final net tree PR before merge win might go out today
or tomorrow (Jakub/David?) and would get fast-fwd'ed into net-next after that
as well, which means we get the current batch for bpf-next out by then. By
that we'd have mentioned commit in bpf-next after re-sync.

> in the next version of the XDP multi-buf submission without creating
> merge conflicts. Or is there some other way we can achieve this without
> creating more work for you? :)
> 
> -Toke
> 
