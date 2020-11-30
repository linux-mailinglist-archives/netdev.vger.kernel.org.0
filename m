Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25FD2C8B39
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgK3RfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387505AbgK3RfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 12:35:22 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D8CB2073C;
        Mon, 30 Nov 2020 17:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606757681;
        bh=h2mSOc2MjK1hNd7ubl8zDnNrESM0nN8QfNkIPSrKIa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jKH2vtu1zUtn2pkTnBJ4leZjTZuVbtifI7BhDN0kQoHRtp/8o8jcHF4U44pyZJV7D
         y/OXSpHnu5n22jmRnXSU1EHgA5m940y+BZOCAvLPvrJwWEfkTV6suDAlJWMl6SbEQy
         TMurzywftHn3Nk/p/t7zid4fYfpQSaJcyZZLh2q0=
Date:   Mon, 30 Nov 2020 12:34:40 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
Message-ID: <20201130173440.GQ643756@sasha-vm>
References: <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <X8TzeoIlR3G5awC6@kroah.com>
 <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
 <X8T6RWHOhgxW3tRK@kroah.com>
 <8809319f-7c5b-1e85-f77c-bbc3f22951e4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8809319f-7c5b-1e85-f77c-bbc3f22951e4@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 03:00:13PM +0100, Paolo Bonzini wrote:
>On 30/11/20 14:57, Greg KH wrote:
>>>Every patch should be "fixing a real issue"---even a new feature.  But the
>>>larger the patch, the more the submitters and maintainers should be trusted
>>>rather than a bot.  The line between feature and bugfix_sometimes_  is
>>>blurry, I would say that in this case it's not, and it makes me question how
>>>the bot decided that this patch would be acceptable for stable (which AFAIK
>>>is not something that can be answered).
>>I thought that earlier Sasha said that this patch was needed as a
>>prerequisite patch for a later fix, right?  If not, sorry, I've lost the
>>train of thought in this thread...
>
>Yeah---sorry I am replying to 22/33 but referring to 23/33, which is 
>the one that in my opinion should not be blindly accepted for stable 
>kernels without the agreement of the submitter or maintainer.

But it's not "blindly", right? I've sent this review mail over a week
ago, and if it goes into the queue there will be at least two more
emails going out to the author/maintainers.

During all this time it gets tested by various entities who do things
that go beyond simple boot testing.

I'd argue that the backports we push in the stable tree sometimes get
tested and reviewed better than the commits that land upstream.

-- 
Thanks,
Sasha
