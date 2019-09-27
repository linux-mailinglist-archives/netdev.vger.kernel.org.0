Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29735C00A6
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfI0IHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:07:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:1691 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfI0IHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:07:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 01:07:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,554,1559545200"; 
   d="scan'208";a="201940621"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.73])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2019 01:06:58 -0700
Date:   Fri, 27 Sep 2019 16:04:10 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927080410.GA22568@___>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
 <20190927045438.GA17152@___>
 <49bb0777-3761-3737-8e5b-568957f9a935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49bb0777-3761-3737-8e5b-568957f9a935@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 03:14:42PM +0800, Jason Wang wrote:
> On 2019/9/27 下午12:54, Tiwei Bie wrote:
> > > > +
> > > > +		/*
> > > > +		 * In vhost-mdev, userspace should pass ring addresses
> > > > +		 * in guest physical addresses when IOMMU is disabled or
> > > > +		 * IOVAs when IOMMU is enabled.
> > > > +		 */
> > > A question here, consider we're using noiommu mode. If guest physical
> > > address is passed here, how can a device use that?
> > > 
> > > I believe you meant "host physical address" here? And it also have the
> > > implication that the HPA should be continuous (e.g using hugetlbfs).
> > The comment is talking about the virtual IOMMU (i.e. iotlb in vhost).
> > It should be rephrased to cover the noiommu case as well. Thanks for
> > spotting this.
> 
> 
> So the question still, if GPA is passed how can it be used by the
> virtio-mdev device?

Sorry if I didn't make it clear..
Of course, GPA can't be passed in noiommu mode.


> 
> Thanks
> 
