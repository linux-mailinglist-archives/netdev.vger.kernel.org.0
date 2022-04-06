Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8749D4F67C3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbiDFRl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239571AbiDFRlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:41:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C68D1BFDCB;
        Wed,  6 Apr 2022 08:51:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 207A568AFE; Wed,  6 Apr 2022 17:50:57 +0200 (CEST)
Date:   Wed, 6 Apr 2022 17:50:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406155056.GA30433@lst.de>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com> <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com> <20220406142432.GF2120790@nvidia.com> <20220406151823.GG2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406151823.GG2120790@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
> > Oh, I didn't know about device_get_dma_attr()..

Which is completely broken for any non-OF, non-ACPI plaform.
