Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1E58DEC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0W0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:26:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:47700 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0W0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:26:04 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcq3-0005kW-R6; Fri, 28 Jun 2019 00:25:55 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgcq3-000Rce-LN; Fri, 28 Jun 2019 00:25:55 +0200
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20190627080521.5df8ccfc@canb.auug.org.au>
 <20190626221347.GA17762@tower.DHCP.thefacebook.com>
 <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
 <20190627114536.09c08f5d@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <134f90ff-13f8-b7c1-9693-2f2649245c38@iogearbox.net>
Date:   Fri, 28 Jun 2019 00:25:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190627114536.09c08f5d@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/27/2019 03:45 AM, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 26 Jun 2019 16:36:50 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Jun 26, 2019 at 3:14 PM Roman Gushchin <guro@fb.com> wrote:
>>>
>>> On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote:  
>>>>
>>>> In commit
>>>>
>>>>   12771345a467 ("bpf: fix cgroup bpf release synchronization")
>>>>
>>>> Fixes tag
>>>>
>>>>   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
>>>>
>>>> has these problem(s):
>>>>
>>>>   - Subject has leading but no trailing parentheses
>>>>   - Subject has leading but no trailing quotes
>>>>
>>>> Please don't split Fixes tags across more than one line.  
>>>
>>> Oops, sorry.
>>>
>>> Alexei, can you fix this in place?
>>> Or should I send an updated version?  
>>
>> I cannot easily do it since -p and --signoff are incompatible flags.
>> I need to use -p to preserve merge commits,
>> but I also need to use --signoff to add my sob to all
>> other commits that were committed by Daniel
>> after your commit.
>>
>> Daniel, can you fix Roman's patch instead?
>> you can do:
>> git rebase -i -p  12771345a467^
>> fix Roman's, add you sob only to that one
>> and re-push the whole thing.

(Fixed in bpf-next.)
