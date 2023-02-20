Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6767A69C55C
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjBTG3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBTG3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:29:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A1CA0B;
        Sun, 19 Feb 2023 22:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gaG5ps+Fq+JpHHZ4QTsrAg+Y1DV+1ITKQ7RbMwlrD9A=; b=MCkB4ps8N6BRRSu6x8/riWH6Q4
        mA5DPJLVsKQKuKeN9khA8PjrbHG6UiTUn9CTjYUaEDFKrNKkblqK7B4OYGDswg/eVWeDLsrvPojts
        hGy5rb42WmsGMn5VF/pWqLL3j/1cd1qOpO8hM95uNDIEqm+N/UflpZKvcO++5aX/lBOM9KZnsQpoO
        mZka/f9RVlps1Em0Ah9Q8Y2FdCzyEMa0S4uP+f8O042DQOHpSTsTSIu0LhTff4GqYltwFLYlwEtkJ
        hqmSx7gUn35ZHrg1fBGFXKZd/2q/+PTWq+wkW9PuWvNp3HdhV4wW6X7EMyTkW2Xoa4g+b58qwtoK6
        oe2xVUjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pTzft-0039Ra-8O; Mon, 20 Feb 2023 06:29:21 +0000
Date:   Sun, 19 Feb 2023 22:29:21 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v3 vfio 0/7] pds vfio driver
Message-ID: <Y/MTQZ53nVYMw9jI@infradead.org>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 12:39:01AM -0800, Brett Creeley wrote:
> This is a draft patchset for a new vendor specific VFIO driver
> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> (DSC). This driver is device type agnostic and live migration is
> supported as long as the underlying SR-IOV VF supports live migration
> on the DSC. This driver is a client of the newly introduced pds_core
> driver, which the latest version can be referenced at:

Just as a broken clock:  non-standard nvme live migration is not
acceptable.  Please work with the NVMe technical workning group to
get this feature standardized.  Note that despite various interested
parties on linux lists I've seen exactly zero activity from the
(not so) smart nic vendors active there.
