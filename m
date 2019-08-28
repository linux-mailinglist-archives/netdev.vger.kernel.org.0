Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E939A0C6F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfH1Vep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbfH1Veo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 17:34:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1BBA2A09B4;
        Wed, 28 Aug 2019 21:34:44 +0000 (UTC)
Received: from x1.home (ovpn-116-131.phx2.redhat.com [10.3.116.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3A5319D7A;
        Wed, 28 Aug 2019 21:34:31 +0000 (UTC)
Date:   Wed, 28 Aug 2019 15:34:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     jiri@mellanox.com, kwankhede@nvidia.com, cohuck@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
Message-ID: <20190828153431.36c37232@x1.home>
In-Reply-To: <20190828152544.16ba2617@x1.home>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190827191654.41161-1-parav@mellanox.com>
        <20190827191654.41161-2-parav@mellanox.com>
        <20190828152544.16ba2617@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 28 Aug 2019 21:34:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 15:25:44 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 27 Aug 2019 14:16:50 -0500
> Parav Pandit <parav@mellanox.com> wrote:
> >  module_init(mdev_init)
> > diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> > index 7d922950caaf..cf1c0d9842c6 100644
> > --- a/drivers/vfio/mdev/mdev_private.h
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -33,6 +33,7 @@ struct mdev_device {
> >  	struct kobject *type_kobj;
> >  	struct device *iommu_device;
> >  	bool active;
> > +	const char *alias;

Nit, put this above active to avoid creating a hole in the structure.
Thanks,

Alex
