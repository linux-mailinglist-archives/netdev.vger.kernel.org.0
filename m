Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DDB28C4E0
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390465AbgJLWm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:52666 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731188AbgJLWm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:26 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kS6WD-0006Z3-GX; Tue, 13 Oct 2020 00:42:13 +0200
Received: from [2a02:1205:5048:a230:688e:a88c:2b15:ece2] (helo=pc-95.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kS6WD-0000aj-9M; Tue, 13 Oct 2020 00:42:13 +0200
Subject: Re: merge window is open. bpf-next is still open.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
References: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
 <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
 <20201013075016.61028eee@canb.auug.org.au>
 <20201012210307.byn6jx7dxmsxq7dt@ast-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb8b825f-6a40-3f88-02bd-b9bb93e0f6e3@iogearbox.net>
Date:   Tue, 13 Oct 2020 00:42:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201012210307.byn6jx7dxmsxq7dt@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25955/Mon Oct 12 15:49:06 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 11:03 PM, Alexei Starovoitov wrote:
> On Tue, Oct 13, 2020 at 07:50:16AM +1100, Stephen Rothwell wrote:
[...]
>> How about this: you create a for-next branch in the bpf-next tree and I
>> fetch that instead of your master branch.  What you do is always work
>> in your master branch and whenever it is "ready", you just merge master
>> into for-next and that is what linux-next works with (net-next still
>> merges your master branch as now).  So the for-next branch consists
>> only of consecutive merges of your master branch.
>>
>> During the merge window you do *not* merge master into for-next (and,
>> in fact, everything in for-next should have been merged into the
>> net-next tree anyway, right?) and then when -rc1 is released, you reset
>> for-next to -rc1 and start merging master into it again.
>>
>> This way the commit SHA1s are stable and I don't have to remember to
>> switch branches/trees every merge window (which I would forget
>> sometimes for sure :-)).
> 
> That is a great idea! I think that should work well for everyone.
> Let's do exactly that.
> Just pushed bpf-next/for-next branch.

+1, I like it as it keeps things simple & straight forward for contributors
and for linux-next as well.

Thanks,
Daniel
