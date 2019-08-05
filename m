Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090DF810BC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 06:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfHEEPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 00:15:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:41512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfHEEPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 00:15:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56732ACC1;
        Mon,  5 Aug 2019 04:15:29 +0000 (UTC)
Subject: Re: [PATCH v2 20/34] xen: convert put_page() to put_user_page*()
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     devel@driverdev.osuosl.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, devel@lists.orangefs.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        rds-devel@oss.oracle.com,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-21-jhubbard@nvidia.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <82afb221-52a2-b399-46f5-0ee1f21c3417@suse.com>
Date:   Mon, 5 Aug 2019 06:15:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190804224915.28669-21-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.19 00:49, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> This also handles pages[i] == NULL cases, thanks to an approach
> that is actually written by Juergen Gross.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> 
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: xen-devel@lists.xenproject.org
> ---
> 
> Hi Juergen,
> 
> Say, this is *exactly* what you proposed in your gup.patch, so
> I've speculatively added your Signed-off-by above, but need your
> approval before that's final. Let me know please...

Yes, that's fine with me.


Juergen
