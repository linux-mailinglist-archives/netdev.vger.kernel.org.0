Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990812823AA
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgJCKnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 06:43:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:48952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgJCKm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 06:42:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 12058B2B6;
        Sat,  3 Oct 2020 10:42:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
Subject: ...
To:     David Miller <davem@davemloft.net>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        cleech@redhat.com, hch@lst.de, amwang@redhat.com,
        eric.dumazet@gmail.com, hare@suse.de, idryomov@gmail.com,
        jack@suse.com, jlayton@kernel.org, axboe@kernel.dk,
        lduncan@suse.com, michaelc@cs.wisc.edu,
        mskorzhinskiy@solarflare.com, philipp.reisner@linbit.com,
        sagi@grimberg.me, vvs@virtuozzo.com, vbabka@suse.com
References: <20201002082734.13925-1-colyli@suse.de>
 <20201002.152829.1002796270145913943.davem@davemloft.net>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <7dcb7b57-9313-0a78-0bf1-be799c0efa52@suse.de>
Date:   Sat, 3 Oct 2020 18:42:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002.152829.1002796270145913943.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/3 06:28, David Miller wrote:
> From: Coly Li <colyli@suse.de>
> Date: Fri,  2 Oct 2020 16:27:27 +0800
> 
>> As Sagi Grimberg suggested, the original fix is refind to a more common
>> inline routine:
>>     static inline bool sendpage_ok(struct page *page)
>>     {
>>         return  (!PageSlab(page) && page_count(page) >= 1);
>>     }
>> If sendpage_ok() returns true, the checking page can be handled by the
>> concrete zero-copy sendpage method in network layer.
> 
> Series applied.
> 
>> The v10 series has 7 patches, fixes a WARN_ONCE() usage from v9 series,
>  ...
> 
> I still haven't heard from you how such a fundamental build failure
> was even possible.
> 

Hi David,

Here is the detail steps how I leaked this uncompleted patch to you,
1) Add WARN_ONCE() as WARN_ON() to kernel_sendpage(). Maybe I was still
hesitating when I typed WARN_ONCE() on keyboard.
2) Generate the patches, prepare to post
3) Hmm, compiling failed, oh it is WARN_ONCE(). Yeah, WARN_ONCE() might
be more informative and better.
4) Modify to use WARN_ONCE() and compile and try, looks fine.
5) Re-generate the patches to overwrite the previous ones.
6) Post the patches.

The missing part was, before I post the patches, I should do rebase and
commit the change, but (interrupted by other stuffs) it skipped in my
mind. Although I regenerated the series but the change was not included.
The result was, uncompleted patch posted and the second-half change
still stayed in my local file.


> If the v9 patch series did not even compile, how in the world did you
> perform functional testing of these changes?
> 

Only 0002-net-add-WARN_ONCE-in-kernel_sendpage-for-improper-ze.patch was
tested in v9 series, other tests were done in previous versions.

> Please explain this to me, instead of just quietly fixing it and
> posting an updated series.


And not all the patches in the series were tested. Here is the testing
coverage of the series:

The following ones were tested and verified to break nothing and avoid
the mm corruption and panic,
0001-net-introduce-helper-sendpage_ok-in-include-linux-ne.patch
0002-net-add-WARN_ONCE-in-kernel_sendpage-for-improper-ze.patch
0003-nvme-tcp-check-page-by-sendpage_ok-before-calling-ke.patch
0006-scsi-libiscsi-use-sendpage_ok-in-iscsi_tcp_segment_m.patch

The following ones were not tested, due to complicated environment setup,
0005-drbd-code-cleanup-by-using-sendpage_ok-to-check-page.patch
0007-libceph-use-sendpage_ok-in-ceph_tcp_sendpage.patch

This patch I didn't explicitly test, due to lack of knowledge to modify
network code to trigger a buggy condition. It just went with other
tested patches,
0004-tcp-use-sendpage_ok-to-detect-misused-.sendpage.patch


Back to the built failure, I don't have excuse for leaking this
uncompleted version to you. Of cause I will try to avoid to
inefficiently occupy maintainer's time by such silly mess up.

Thanks for your review and the thorough maintenance.

Coly Li


