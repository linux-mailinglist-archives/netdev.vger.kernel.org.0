Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E354213B5D1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgANX3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgANX3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 18:29:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76F8C24679;
        Tue, 14 Jan 2020 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579044570;
        bh=k4eU69C07g5/9QQrVCph8KAUUUUEi8RmXHDj6/HO/Ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gu0y5RtywBnxt/5MHNzmIuAGL99UYOUTR4MOUoFz/V8A0XNK0I0bw+ID9QXrLG+b9
         4yxWu1bIpxAgRKCCzCYPru9Le6et10vSO5ADJMjyl++hjxh7tjrdlkd5kSXYwv5i4H
         zD3MC1qTDzqpxI561Q50RCSE3Ph+HIgvwbWCQkns=
Date:   Tue, 14 Jan 2020 15:29:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?ISO-8859-1?Q?J=E9r?= =?ISO-8859-1?Q?=F4me?= Glisse 
        <jglisse@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 00/22] mm/gup: prereqs to track dma-pinned pages:
 FOLL_PIN
Message-Id: <20200114152929.807fecabfe2258ae2707a88b@linux-foundation.org>
In-Reply-To: <9d7f3c1a-6020-bdec-c513-80c5399e55d7@nvidia.com>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
        <2a9145d4-586e-6489-64e4-0c54f47afaa1@nvidia.com>
        <9d7f3c1a-6020-bdec-c513-80c5399e55d7@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 12:15:08 -0800 John Hubbard <jhubbard@nvidia.com> wrote:

> > 
> > Hi Andrew and all,
> > 
> > To clarify: I'm hoping that this series can go into 5.6.
> > 
> > Meanwhile, I'm working on tracking down and solving the problem that Leon
> > reported, in the "track FOLL_PIN pages" patch, and that patch is not part of
> > this series.
> > 
> 
> Hi Andrew and all,
> 
> Any thoughts on this?

5.6 is late.  But it was in -mm before (briefly) and appears to be
mature and well-reviewed.

I'll toss it in there and shall push it into -next hopefully today. 
Let's decide 2-3 weeks hence.

