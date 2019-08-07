Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90F8459A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfHGHVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:21:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:56011 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfHGHU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 03:20:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 00:19:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,356,1559545200"; 
   d="scan'208";a="176880179"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga003.jf.intel.com with ESMTP; 07 Aug 2019 00:19:32 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 9980B202CC; Wed,  7 Aug 2019 10:20:07 +0300 (EEST)
Date:   Wed, 7 Aug 2019 10:20:07 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     john.hubbard@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH v3 11/41] media/v4l2-core/mm: convert put_page() to
 put_user_page*()
Message-ID: <20190807072007.GG21370@paasikivi.fi.intel.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
 <20190807013340.9706-12-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807013340.9706-12-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 06:33:10PM -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
