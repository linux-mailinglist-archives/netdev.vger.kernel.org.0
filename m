Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7715B100500
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfKRMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:01:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:37358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726706AbfKRMBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 07:01:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8AF37AFB0;
        Mon, 18 Nov 2019 12:01:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id F053C1E4B0B; Mon, 18 Nov 2019 11:30:49 +0100 (CET)
Date:   Mon, 18 Nov 2019 11:30:49 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 13/24] mm/process_vm_access: set FOLL_PIN via
 pin_user_pages_remote()
Message-ID: <20191118103049.GH17319@quack2.suse.cz>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-14-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191115055340.1825745-14-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 14-11-19 21:53:29, John Hubbard wrote:
> Convert process_vm_access to use the new pin_user_pages_remote()
> call, which sets FOLL_PIN. Setting FOLL_PIN is now required for
> code that requires tracking of pinned pages.
> 
> Also, release the pages via put_user_page*().
> 
> Also, rename "pages" to "pinned_pages", as this makes for
> easier reading of process_vm_rw_single_vec().
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  mm/process_vm_access.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
