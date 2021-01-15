Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08082F7C44
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbhAONOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:14:52 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:44591 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731733AbhAONOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 08:14:52 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DHM8J2VJRz9txP4;
        Fri, 15 Jan 2021 14:14:08 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id uKmPQYagKGj1; Fri, 15 Jan 2021 14:14:08 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DHM8H75Cbz9txNX;
        Fri, 15 Jan 2021 14:14:07 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5C6B58B829;
        Fri, 15 Jan 2021 14:14:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id w2ZUaBsmi8E6; Fri, 15 Jan 2021 14:14:09 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9BAA88B81F;
        Fri, 15 Jan 2021 14:14:07 +0100 (CET)
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
To:     Lee Jones <lee.jones@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Durrant <paul@xen.org>, Kurt Kanzenbach <kurt@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Peter Cammaert <pc@denkart.be>,
        Paul Mackerras <paulus@samba.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Wei Liu <wei.liu@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Santiago Leon <santi_leon@yahoo.com>,
        xen-devel@lists.xenproject.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Daris A Nevil <dnevil@snmc.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Erik Stahlman <erik@vt.edu>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk@arm.linux.org.uk>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
 <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114083349.GI3975472@dell>
 <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114195422.GB3975472@dell> <20210115111823.GH3975472@dell>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <bc775cc3-fda3-0280-5f92-53058996f02f@csgroup.eu>
Date:   Fri, 15 Jan 2021 14:14:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115111823.GH3975472@dell>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 15/01/2021 à 12:18, Lee Jones a écrit :
> On Thu, 14 Jan 2021, Lee Jones wrote:
> 
>> On Thu, 14 Jan 2021, Jakub Kicinski wrote:
>>
>>> On Thu, 14 Jan 2021 08:33:49 +0000 Lee Jones wrote:
>>>> On Wed, 13 Jan 2021, Jakub Kicinski wrote:
>>>>
>>>>> On Wed, 13 Jan 2021 16:41:16 +0000 Lee Jones wrote:
>>>>>> Resending the stragglers again.
>>>>>>
>>>>>> This set is part of a larger effort attempting to clean-up W=1
>>>>>> kernel builds, which are currently overwhelmingly riddled with
>>>>>> niggly little warnings.
>>>>>>                                                                                                                   
>>>>>> v2:
>>>>>>   - Squashed IBM patches
>>>>>>   - Fixed real issue in SMSC
>>>>>>   - Added Andrew's Reviewed-by tags on remainder
>>>>>
>>>>> Does not apply, please rebase on net-next/master.
>>>>
>>>> These are based on Tuesday's next/master.
>>>
>>> What's next/master?
>>
>> I'm not sure if this is a joke, or not? :)
>>
>> next/master == Linux Next.  The daily merged repo where all of the
>> *-next branches end up to ensure interoperability.  It's also the
>> branch that is most heavily tested by the auto-builders to ensure the
>> vast majority of issues are ironed out before hitting Mainline.
>>
>>> This is net-next:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
>>
>> Looks like net-next gets merged into next/master:
>>
>> commit 452958f1f3d1c8980a8414f9c37c8c6de24c7d32
>> Merge: 1eabba209a17a f50e2f9f79164
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Thu Jan 14 10:35:40 2021 +1100
>>
>>      Merge remote-tracking branch 'net-next/master'
>>
>> So I'm not sure what it's conflicting with.
>>
>> Do you have patches in net-next that didn't make it into next/master
>> for some reason?
>>
>> I'll try to rebase again tomorrow.
>>
>> Hopefully I am able to reproduce your issue by then.
> 
> Okay so my development branch rebased again with no issue.

Rebasing is not same as patches application.

> 
> I also took the liberty to checkout net-next and cherry-pick the
> patches [0], which again didn't cause a problem.

Also normal, cherry-picking is not the same as applying a patch series.

> 
> I'm not sure what else to suggest.  Is your local copy up-to-date?

I guess so, I have the same problem as Jakub, see below. I had to use 'git am -3' to apply you 
series. As you can see, git falls back to 3 way merge for patch 1, which means your series is close 
to but not fully in sync with net-next.


[root@localhost linux-powerpc]# git remote -v
net-next	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git (fetch)
net-next	https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git (push)

[root@localhost linux-powerpc]# git checkout net-next/master -b net-next
Switched to a new branch 'net-next'

[root@localhost linux-powerpc]# git am /root/Downloads/Rid-W-1-warnings-in-Ethernet.patch
Applying: net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
error: patch failed: drivers/net/ethernet/smsc/smc91x.c:2192
error: drivers/net/ethernet/smsc/smc91x.c: patch does not apply
Patch failed at 0001 net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
hint: Use 'git am --show-current-patch' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

[root@localhost linux-powerpc]# git am --abort

[root@localhost linux-powerpc]# git am -3 /root/Downloads/Rid-W-1-warnings-in-Ethernet.patch
Applying: net: ethernet: smsc: smc91x: Fix function name in kernel-doc header
Using index info to reconstruct a base tree...
M	drivers/net/ethernet/smsc/smc91x.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/ethernet/smsc/smc91x.c
Applying: net: xen-netback: xenbus: Demote nonconformant kernel-doc headers
Applying: net: ethernet: ti: am65-cpsw-qos: Demote non-conformant function header
Applying: net: ethernet: ti: am65-cpts: Document am65_cpts_rx_enable()'s 'en' parameter
Applying: net: ethernet: ibm: ibmvnic: Fix some kernel-doc misdemeanours
Applying: net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
Applying: net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters


Christophe
