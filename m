Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3950A5C9DC
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfGBHSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfGBHSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 03:18:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C61FB5AFE3;
        Tue,  2 Jul 2019 07:18:32 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89E275C28D;
        Tue,  2 Jul 2019 07:18:27 +0000 (UTC)
Subject: Re: Reminder: 2 open syzbot bugs in vhost subsystem
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Hillf Danton <hdanton@sina.com>, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190702051707.GF23743@sol.localdomain>
 <e2da1124-52c3-84ff-77ce-deb017711138@redhat.com>
 <20190702053223.GA27702@sol.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <984f559f-3cfd-cfa5-c37f-272beb58aae1@redhat.com>
Date:   Tue, 2 Jul 2019 15:18:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702053223.GA27702@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 02 Jul 2019 07:18:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/2 下午1:32, Eric Biggers wrote:
> On Tue, Jul 02, 2019 at 01:24:43PM +0800, Jason Wang wrote:
>>> --------------------------------------------------------------------------------
>>> Title:              INFO: task hung in vhost_init_device_iotlb
>>> Last occurred:      125 days ago
>>> Reported:           153 days ago
>>> Branches:           Mainline and others
>>> Dashboard link:     https://syzkaller.appspot.com/bug?id=cb1ea8daf03a5942c2ab314679148cf6e128ef58
>>> Original thread:    https://lkml.kernel.org/lkml/0000000000007e86fd058095533f@google.com/T/#u
>>>
>>> Unfortunately, this bug does not have a reproducer.
>>>
>>> The original thread for this bug received 2 replies; the last was 152 days ago.
>>>
>>> If you fix this bug, please add the following tag to the commit:
>>>       Reported-by: syzbot+40e28a8bd59d10ed0c42@syzkaller.appspotmail.com
>>>
>>> If you send any email or patch for this bug, please consider replying to the
>>> original thread.  For the git send-email command to use, or tips on how to reply
>>> if the thread isn't in your mailbox, see the "Reply instructions" at
>>> https://lkml.kernel.org/r/0000000000007e86fd058095533f@google.com
>>>
>> Can syzbot still reproduce this issue?
> Apparently not, as it last occurred 125 days ago.
>
> That doesn't necessarily mean the bug isn't still there, though.
>
> But if you (as a person familiar with the code) think it's no longer valid or
> not actionable, you can invalidate it.
>
> - Eric


Thanks for the hint.

Let me try to invalidate it in the original thread.


