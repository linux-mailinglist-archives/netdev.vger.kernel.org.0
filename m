Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917AB64D6B7
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 07:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiLOGz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 01:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOGz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 01:55:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73D226B;
        Wed, 14 Dec 2022 22:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z8/kTwz2+ktXLMnu+Phx+YApswCrQeo9fl9/pjn0Ymg=; b=tvK2zUa/ZXwjq3iYn9zLgncjv2
        6C5FnGwAmzV2Ya95sq/5ueg7S8Mo3mokEaIQX5e0d8GvgGp5nho9OCDOm93EsAm94774o1c9POj6l
        Qs9LwbYBBrA1e6gmp/hKs+PiY37RuyOQvUyrePgaSZ8SHmiv2LEH9EzvPttSp2gTPKfig89PVdpTM
        VreQ6GHrlMQ/tqrbolvr/MXIqO07lGe3caybQ6YBB3iQbUhGNrWJgmDjGXM0QWgibS8LG6ReENhs6
        /eCanItrnfNnHmYpHi5OPHN9RpXf67dz3rHivdrgtjRd9yac7daMZGsEvaZXBgNtUDtE6PGvKtWF7
        R0lcBpkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p5i9L-006ybq-Or; Thu, 15 Dec 2022 06:55:23 +0000
Date:   Wed, 14 Dec 2022 22:55:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [RFC PATCH v2 vfio 0/7] pds vfio driver
Message-ID: <Y5rE26OcSnoZbqzn@infradead.org>
References: <20221214232136.64220-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214232136.64220-1-brett.creeley@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 03:21:29PM -0800, Brett Creeley wrote:
> This is a first draft patchset for a new vendor specific VFIO driver for
> use with the AMD/Pensando Distributed Services Card (DSC). This driver
> (pds_vfio) is a client of the newly introduced pds_core driver.

Hi Brett,

just as said last time and completely ignored by you:  any nvme live
migration needs to be standardized in the NVMe technical working group
before it can be merged in Linux.
