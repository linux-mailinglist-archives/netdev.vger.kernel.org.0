Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF78BFE27
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfI0E3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:29:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:11333 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfI0E3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 00:29:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 21:29:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,554,1559545200"; 
   d="scan'208";a="196598843"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.73])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Sep 2019 21:29:44 -0700
Date:   Fri, 27 Sep 2019 12:26:57 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190927042657.GA16052@___>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
 <996bcaa3-1b13-2520-5be4-8a8f9c8c71d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <996bcaa3-1b13-2520-5be4-8a8f9c8c71d6@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 11:51:35AM +0800, Jason Wang wrote:
> On 2019/9/27 上午11:46, Jason Wang wrote:
> > +
> > +static struct mdev_class_id id_table[] = {
> > +    { MDEV_ID_VHOST },
> > +    { 0 },
> > +};
> > +
> > +static struct mdev_driver vhost_mdev_driver = {
> > +    .name    = "vhost_mdev",
> > +    .probe    = vhost_mdev_probe,
> > +    .remove    = vhost_mdev_remove,
> > +    .id_table = id_table,
> > +};
> > +
> 
> 
> And you probably need to add MODULE_DEVICE_TABLE() as well.

Yeah, thanks!


> 
> Thanks
> 
