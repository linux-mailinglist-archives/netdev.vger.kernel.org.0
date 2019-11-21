Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4A7104F97
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKUJtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:49:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:38294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfKUJtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 04:49:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A829AE39;
        Thu, 21 Nov 2019 09:49:10 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0C6121E47FC; Thu, 21 Nov 2019 10:49:08 +0100 (CET)
Date:   Thu, 21 Nov 2019 10:49:08 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v7 02/24] mm/gup: factor out duplicate code from four
 routines
Message-ID: <20191121094908.GB18190@quack2.suse.cz>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-3-jhubbard@nvidia.com>
 <20191121080356.GA24784@lst.de>
 <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <852f6c27-8b65-547b-89e0-e8f32a4d17b9@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 21-11-19 00:29:59, John Hubbard wrote:
> On 11/21/19 12:03 AM, Christoph Hellwig wrote:
> > Otherwise this looks fine and might be a worthwhile cleanup to feed
> > Andrew for 5.5 independent of the gut of the changes.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Thanks for the reviews! Say, it sounds like your view here is that this
> series should be targeted at 5.6 (not 5.5), is that what you have in mind?
> And get the preparatory patches (1-9, and maybe even 10-16) into 5.5?

Yeah, actually I feel the same. The merge window is going to open on Sunday
and the series isn't still fully baked and happily sitting in linux-next
(and larger changes should really sit in linux-next for at least a week,
preferably two, before the merge window opens to get some reasonable test
coverage).  So I'd take out the independent easy patches that are already
reviewed, get them merged into Andrew's (or whatever other appropriate
tree) now so that they get at least a week of testing in linux-next before
going upstream.  And the more involved bits will have to wait for 5.6 -
which means let's just continue working on them as we do now because
ideally in 4 weeks we should have them ready with all the reviews so that
they can be picked up and integrated into linux-next.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
