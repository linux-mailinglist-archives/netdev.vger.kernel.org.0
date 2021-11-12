Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F022A44EC32
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhKLRxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:53:40 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:43694 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhKLRxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:53:39 -0500
Received: from c-24-16-8-193.hsd1.wa.comcast.net ([24.16.8.193] helo=srivatsab-a02.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mlahI-0006py-1E; Fri, 12 Nov 2021 12:50:44 -0500
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
To:     Jakub Kicinski <kuba@kernel.org>, Joe Perches <joe@perches.com>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, amakhalov@vmware.com,
        sdeep@vmware.com, virtualization@lists.linux-foundation.org,
        keerthanak@vmware.com, srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        srivatsa@csail.mit.edu
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
 <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
 <20211110173935.45a9f495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d7f3fec79287a149d6edc828583a771c84646b42.camel@perches.com>
 <20211111055554.4f257fd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <fd9df647-4c1a-b4fb-159b-4876bc5cd0b6@csail.mit.edu>
Date:   Fri, 12 Nov 2021 09:50:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211111055554.4f257fd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Resending since my previous reply didn't reach the mailing lists. ]

On 11/11/21 5:55 AM, Jakub Kicinski wrote:
> On Wed, 10 Nov 2021 21:19:53 -0800 Joe Perches wrote:
>> On Wed, 2021-11-10 at 17:39 -0800, Jakub Kicinski wrote:
>>> On Wed, 10 Nov 2021 12:09:06 -0800 Srivatsa S. Bhat wrote:  
>>>>  DRM DRIVER FOR VMWARE VIRTUAL GPU
>>>> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
>>>>  M:	Zack Rusin <zackr@vmware.com>
>>>> +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
>>>>  L:	dri-devel@lists.freedesktop.org
>>>>  S:	Supported
>>>>  T:	git git://anongit.freedesktop.org/drm/drm-misc  
>>>
>>> It'd be preferable for these corporate entries to be marked or
>>> otherwise distinguishable so that we can ignore them when we try 
>>> to purge MAINTAINERS from developers who stopped participating.
>>>
>>> These addresses will never show up in a commit tag which is normally
>>> sign of inactivity.  
>>
>> Funny.
>>
>> The link below is from over 5 years ago.
>>
>> https://lore.kernel.org/lkml/1472081625.3746.217.camel@perches.com/
>>
>> Almost all of those entries are still in MAINTAINERS.
>>
>> I think the concept of purging is a non-issue.
> 
> I cleaned networking in January and intend to do it again in 2 months.
> See:
> 
> 054c4610bd05 MAINTAINERS: dccp: move Gerrit Renker to CREDITS
> 4f3786e01194 MAINTAINERS: ipvs: move Wensong Zhang to CREDITS
> 0e4ed0b62b5a MAINTAINERS: tls: move Aviad to CREDITS
> c41efbf2ad56 MAINTAINERS: ena: remove Zorik Machulsky from reviewers
> 5e62d124f75a MAINTAINERS: vrf: move Shrijeet to CREDITS
> 09cd3f4683a9 MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
> 93089de91e85 MAINTAINERS: altx: move Jay Cliburn to CREDITS
> 8b0f64b113d6 MAINTAINERS: remove names from mailing list maintainers
> 
I'm assuming the purging is not totally automated, is it? As long as
the entries are informative to a human reader, it should be possible
to skip the relevant ones when purging inactive entries.

I believe this patch makes the situation better than it is currently
(at least for the human reader), by marking lists without public
read-access in a format that is more appropriate. In the future, we
could perhaps improve on it to ease automation too, but for now I
think it is worthwhile to merge this change (unless there are strong
objections or better alternatives that everyone agrees on).

Regards,
Srivatsa
