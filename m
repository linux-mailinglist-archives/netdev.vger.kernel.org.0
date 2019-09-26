Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF47BF424
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfIZNhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:37:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:27835 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfIZNhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:37:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 06:37:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="364730259"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.73])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2019 06:37:11 -0700
Date:   Thu, 26 Sep 2019 21:34:23 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190926133423.GA15574@___>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
 <20190926091945-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190926091945-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:26:22AM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 26, 2019 at 09:14:39PM +0800, Tiwei Bie wrote:
> > > 4. Does device need to limit max ring size?
> > > 5. Does device need to limit max number of queues?
> > 
> > I think so. It's helpful to have ioctls to report the max
> > ring size and max number of queues.
> 
> Also, let's not repeat the vhost net mistakes, let's lock
> everything to the order required by the virtio spec,
> checking status bits at each step.
> E.g.:
> 	set backend features
> 	set features
> 	detect and program vqs
> 	enable vqs
> 	enable driver
> 
> and check status at each step to force the correct order.
> e.g. don't allow enabling vqs after driver ok, etc

Got it. Thanks a lot!

Regards,
Tiwei

> 
> -- 
> MST
