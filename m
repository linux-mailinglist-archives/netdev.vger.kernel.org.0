Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B869D406A1A
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 12:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhIJKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 06:24:29 -0400
Received: from verein.lst.de ([213.95.11.211]:47760 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhIJKYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 06:24:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BEA7067357; Fri, 10 Sep 2021 12:23:06 +0200 (CEST)
Date:   Fri, 10 Sep 2021 12:23:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Hamza Mahfooz <someguy@effective-light.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20210910102306.GA13863@lst.de>
References: <20210518125443.34148-1-someguy@effective-light.com> <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
> PS, it might not hurt to rate limit/_once this somehow to avoid a runtime 
> problem if it starts to trigger.

Yes, that might be a good idea.  Care to prepare a patch?
