Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B32CFF02
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgLEU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 15:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLEU7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 15:59:42 -0500
Date:   Sat, 5 Dec 2020 15:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607201941;
        bh=74iRxwmFnt99WWNxEo0C+m2cD1/u91IB6ixYgd0wOdM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z374KlqjZe4kc1SSbgtmFHMGfwkeRIYFWhpyCggp3buV5fZ3gQKevOLwV0PL0AsKz
         DqifZT9toGw7/e8w1JJjGqyPEPCf57Gt2crZKgKjOLwCVwhaYYUTK+YBs9WXPCyBs1
         8ZoKJL+QMOmwBs80astNJFETR4tTsMW911W/kngpuJHFVxyib8G7JNAwQad+46s+oG
         len+BF3J3eDwtuSpOEFe+WLElNxHk6b5RzvMz2i5Q5tVEUQfJFF4Bq6umIUD63Fcgo
         QcZOsE6wdpzD+K5+6GcsTW568xzhrqAjnBxzxs1PYhUa/RX/FuaJA+j77EY5N/8xcG
         lDsicw86itMqw==
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <20201205205900.GD643756@sasha-vm>
References: <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
 <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
 <20201130235959.GS643756@sasha-vm>
 <6c49ded5-bd8f-f219-0c51-3500fd751633@redhat.com>
 <20201204154911.GZ643756@sasha-vm>
 <d071d714-3ebd-6929-3f3b-c941cce109f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d071d714-3ebd-6929-3f3b-c941cce109f8@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 06:08:13PM +0100, Paolo Bonzini wrote:
>On 04/12/20 16:49, Sasha Levin wrote:
>>On Fri, Dec 04, 2020 at 09:27:28AM +0100, Paolo Bonzini wrote:
>>>On 01/12/20 00:59, Sasha Levin wrote:
>>>>
>>>>It's quite easy to NAK a patch too, just reply saying "no" and it'll be
>>>>dropped (just like this patch was dropped right after your first reply)
>>>>so the burden on maintainers is minimal.
>>>
>>>The maintainers are _already_ marking patches with "Cc: stable".  
>>>That
>>
>>They're not, though. Some forget, some subsystems don't mark anything,
>>some don't mark it as it's not stable material when it lands in their
>>tree but then it turns out to be one if it sits there for too long.
>
>That means some subsystems will be worse as far as stable release 
>support goes.  That's not a problem:
>
>- some subsystems have people paid to do backports to LTS releases 
>when patches don't apply; others don't, if the patch doesn't apply the 
>bug is simply not fixed in LTS releases

Why not? A warning mail is originated and folks fix those up. I fixed a
whole bunch of these myself for subsystems I'm not "paid" to do so.

>- some subsystems are worse than others even in "normal" releases :)

Agree with that.

>>>(plus backports) is where the burden on maintainers should start 
>>>and end.  I don't see the need to second guess them.
>>
>>This is similar to describing our CI infrastructure as "second
>>guessing": why are we second guessing authors and maintainers who are
>>obviously doing the right thing by testing their patches and reporting
>>issues to them?
>
>No, it's not the same.  CI helps finding bugs before you have to waste 
>time spending bisecting regressions across thousands of commits.  The 
>lack of stable tags _can_ certainly be a problem, but it solves itself 
>sooner or later when people upgrade their kernel.

If just waiting with fixing issues is ok until a user might "eventually"
upgrade is acceptable then why bother with a stable tree to begin with?

-- 
Thanks,
Sasha
