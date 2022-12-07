Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85E6454C9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLGHn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLGHny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:43:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0202AE0;
        Tue,  6 Dec 2022 23:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xo+BLb2JS7fOXM8liyCnCOcGBhHYcrzFV4Ex4WwEERc=; b=v9A1DfRlD5TiNLtWDRXF+Knm/N
        jSTXdq4l2PUGJm8b3038Beq4PCYlXJ84qv7cm1Gs70opVZoWbbEUXdkpYZq4vFxQdEUKH6C/ef0zL
        wyIT5yGyhbjQ9d3K3s7FsO47d3JASSkYzySG+8kasnoDlAgXrwcZXW/uzhpfcIg3Sb+E2D0IqIpWY
        inZR3tQhTziTq77rRgIJ6qZ4Ypl33KxFxxB8S7ihPyAuGmwPXGlRJ10AgJG8XAjJHqUG8QU2LMW0Z
        O8GJnRHnG24tUkVwEgXV7+KYgt8pUMYFbyM7Pye/Cf32FWogka2qhYxVWM5QeWHIUG1UpvAR28TS3
        cKcPty7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2p5t-00ECz6-CM; Wed, 07 Dec 2022 07:43:53 +0000
Date:   Tue, 6 Dec 2022 23:43:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [RFC PATCH vfio 0/7] pds vfio driver
Message-ID: <Y5BEOXKKAjVzyBVI@infradead.org>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:06:58PM -0800, Brett Creeley wrote:
> AMD/Pensando already supports a NVMe VF device (1dd8:1006) in the
> Distributed Services Card (DSC). This patchset adds the new pds_vfio
> driver in order to support NVMe VF live migration.

If you want NVMe live migration, please work with the nvme technical
working group to standardize it.  We will not add support for a
gazillion incompatible and probably broken concepts of this.
