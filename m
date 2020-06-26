Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F220BAB1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgFZUyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:54:17 -0400
Received: from smtp4.emailarray.com ([65.39.216.22]:35305 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZUyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:54:17 -0400
Received: (qmail 99814 invoked by uid 89); 26 Jun 2020 20:54:15 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 26 Jun 2020 20:54:15 -0000
Date:   Fri, 26 Jun 2020 13:54:12 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: the XSK buffer pool needs be to reverted
Message-ID: <20200626205412.xfe4lywdbmh3kmri@bsd-mbp>
References: <20200626074725.GA21790@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626074725.GA21790@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 09:47:25AM +0200, Christoph Hellwig wrote:
>
> Note that this is somewhat urgent, as various of the APIs that the code
> is abusing are slated to go away for Linux 5.9, so this addition comes
> at a really bad time.

Could you elaborate on what is upcoming here?


Also, on a semi-related note, are there limitations on how many pages
can be left mapped by the iommu?  Some of the page pool work involves
leaving the pages mapped instead of constantly mapping/unmapping them.

On a heavily loaded box with iommu enabled, it seems that quite often
there is contention on the iova_lock.  Are there known issues in this
area?
-- 
Jonathan
