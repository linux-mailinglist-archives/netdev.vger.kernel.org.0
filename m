Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414B85C9E3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGBHXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfGBHXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 03:23:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 919BBA3B5E;
        Tue,  2 Jul 2019 07:23:08 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 915B75D9D3;
        Tue,  2 Jul 2019 07:23:03 +0000 (UTC)
Subject: Re: INFO: task hung in vhost_init_device_iotlb
To:     Dmitry Vyukov <dvyukov@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     syzbot <syzbot+40e28a8bd59d10ed0c42@syzkaller.appspotmail.com>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        virtualization@lists.linux-foundation.org
References: <0000000000007e86fd058095533f@google.com>
 <20190129105957-mutt-send-email-mst@kernel.org>
 <CACT4Y+Yiz2NpDMNLSP+Z-qf9Swo56Yhb0CbmrUyPHojmMZzCAQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0d542a30-7122-aea7-07fe-b49dedcd9daf@redhat.com>
Date:   Tue, 2 Jul 2019 15:23:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Yiz2NpDMNLSP+Z-qf9Swo56Yhb0CbmrUyPHojmMZzCAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 02 Jul 2019 07:23:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/1/30 下午4:12, Dmitry Vyukov wrote:
> On Tue, Jan 29, 2019 at 5:06 PM Michael S. Tsirkin<mst@redhat.com>  wrote:
>> On Tue, Jan 29, 2019 at 01:22:02AM -0800, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    983542434e6b Merge tag 'edac_fix_for_5.0' of git://git.ker..
>>> git tree:       upstream
>>> console output:https://syzkaller.appspot.com/x/log.txt?x=17476498c00000
>>> kernel config:https://syzkaller.appspot.com/x/.config?x=505743eba4e4f68
>>> dashboard link:https://syzkaller.appspot.com/bug?extid=40e28a8bd59d10ed0c42
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>>
>>> Unfortunately, I don't have any reproducer for this crash yet.
>> Hmm nothing obvious below. Generic corruption elsewhere?
> Hard to say, a silent memory corruption is definitely possible.
> If there is nothing obvious let's wait, maybe syzbot will come up with
> a repro or we get more such hangs so that it will be possible to rule
> out flakes/corruptions.
>

It hasn't been reproduced for a while. We can invalid this and see if we 
can get it again.

So

#syz invalid

Thanks

