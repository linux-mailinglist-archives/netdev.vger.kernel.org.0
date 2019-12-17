Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B4D12263E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfLQIFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:05:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:26948 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfLQIFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 03:05:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 00:05:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,324,1571727600"; 
   d="scan'208";a="217691035"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 17 Dec 2019 00:04:57 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ih7qi-0006Px-ST; Tue, 17 Dec 2019 16:04:56 +0800
Date:   Tue, 17 Dec 2019 16:03:58 +0800
From:   kbuild test robot <lkp@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kbuild-all@lists.01.org, Andrew Morton <akpm@linux-foundation.org>,
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
        John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC PATCH] mm/gup: try_pin_compound_head() can be static
Message-ID: <20191217080358.q3k57ta62txvip5h@4978f4969bb8>
References: <20191211025318.457113-24-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211025318.457113-24-jhubbard@nvidia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 8086d1c61970 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 038b71165a761..849a6f55938e6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -75,7 +75,7 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
  * @Return:	the compound head page, with ref appropriately incremented,
  * or NULL upon failure.
  */
-__must_check struct page *try_pin_compound_head(struct page *page, int refs)
+static __must_check struct page *try_pin_compound_head(struct page *page, int refs)
 {
 	struct page *head = try_get_compound_head(page,
 						  GUP_PIN_COUNTING_BIAS * refs);
