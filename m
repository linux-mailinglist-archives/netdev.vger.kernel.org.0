Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C816BE3F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfGQO2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:28:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20591 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfGQO2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:28:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C24C6308FBAC;
        Wed, 17 Jul 2019 14:28:52 +0000 (UTC)
Received: from redhat.com (ovpn-125-71.rdu2.redhat.com [10.10.125.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0320719C68;
        Wed, 17 Jul 2019 14:28:45 +0000 (UTC)
Date:   Wed, 17 Jul 2019 10:28:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: Re: [PATCH V3 00/15] Packed virtqueue support for vhost
Message-ID: <20190717102824-mutt-send-email-mst@kernel.org>
References: <20190717105255.63488-1-jasowang@redhat.com>
 <20190717070100-mutt-send-email-mst@kernel.org>
 <af066030-96f1-4a8d-4864-7b6b903477a6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af066030-96f1-4a8d-4864-7b6b903477a6@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 17 Jul 2019 14:28:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 08:27:28PM +0800, Jason Wang wrote:
> 
> On 2019/7/17 下午7:02, Michael S. Tsirkin wrote:
> > On Wed, Jul 17, 2019 at 06:52:40AM -0400, Jason Wang wrote:
> > > Hi all:
> > > 
> > > This series implements packed virtqueues which were described
> > > at [1]. In this version we try to address the performance regression
> > > saw by V2. The root cause is packed virtqueue need more times of
> > > userspace memory accesssing which turns out to be very
> > > expensive. Thanks to the help of 7f466032dc9e ("vhost: access vq
> > > metadata through kernel virtual address"), such overhead cold be
> > > eliminated. So in this version, we can see about 2% improvement for
> > > packed virtqueue on PPS.
> > Great job, thanks!
> > Pls allow a bit more review time than usual as this is a big patchset.
> > Should be done by Tuesday.
> > -next material anyway.
> 
> 
> Sure, just to confirm, I think this should go for your vhost tree?.
> 
> Thanks

I think this makes sense, yes.
