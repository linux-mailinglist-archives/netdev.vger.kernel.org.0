Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9405D2CF137
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgLDPt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgLDPtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 10:49:53 -0500
Date:   Fri, 4 Dec 2020 10:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607096952;
        bh=Ow4G56Wm/9Nfwmkt+etIYtnevqjnp+bk9nlnFoU8UQk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=RQjC41VglvvhGwAWU6XRMSSSMnzpp3JOxd1JNCylOQy/kEvUZ/ewOpyE/wOqQW/7j
         878hxCTLNSyKUEwvhP2o5iMZhV6F/W385j25+TYB/QZlSyrDcFDoYe0rgky3hMcZ/P
         Nspyf5ZojFO6emRkgFk9EeTs/eGl6Km4CtSDUo55DCdJh1xlIRobP9bnqaHpnGlsvQ
         4TMZgz2q7uNKvG3exf/XFGcNg+7tXIby71tbnOypYg4j4+erSHdVGjPaDmkBXDFxXN
         ICWQyjSwysK+pQXANGOHy6hLAsiPnYnR3u4UiD59Fj+QIoSr52SNzsJ+5WH4vYhD2/
         XjdW17iIoYZ9Q==
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
Message-ID: <20201204154911.GZ643756@sasha-vm>
References: <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <20201130173832.GR643756@sasha-vm>
 <238cbdd1-dabc-d1c1-cff8-c9604a0c9b95@redhat.com>
 <9ec7dff6-d679-ce19-5e77-f7bcb5a63442@oracle.com>
 <4c1b2bc7-cf50-4dcd-bfd4-be07e515de2a@redhat.com>
 <20201130235959.GS643756@sasha-vm>
 <6c49ded5-bd8f-f219-0c51-3500fd751633@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6c49ded5-bd8f-f219-0c51-3500fd751633@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 09:27:28AM +0100, Paolo Bonzini wrote:
>On 01/12/20 00:59, Sasha Levin wrote:
>>
>>It's quite easy to NAK a patch too, just reply saying "no" and it'll be
>>dropped (just like this patch was dropped right after your first reply)
>>so the burden on maintainers is minimal.
>
>The maintainers are _already_ marking patches with "Cc: stable".  That 

They're not, though. Some forget, some subsystems don't mark anything,
some don't mark it as it's not stable material when it lands in their
tree but then it turns out to be one if it sits there for too long.

>(plus backports) is where the burden on maintainers should start and 
>end.  I don't see the need to second guess them.

This is similar to describing our CI infrastructure as "second
guessing": why are we second guessing authors and maintainers who are
obviously doing the right thing by testing their patches and reporting
issues to them?

Are you saying that you have always gotten stable tags right? never
missed a stable tag where one should go?

-- 
Thanks,
Sasha
