Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF36276AF5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIXHif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:38:35 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17935 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgIXHie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:38:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6c4c9a0000>; Thu, 24 Sep 2020 00:36:58 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 07:38:14 +0000
Date:   Thu, 24 Sep 2020 10:38:10 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob.miller@broadcom.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <hanand@xilinx.com>,
        <mhabets@solarflare.com>, <eli@mellanox.com>,
        <amorenoz@redhat.com>, <maxime.coquelin@redhat.com>,
        <stefanha@redhat.com>, <sgarzare@redhat.com>
Subject: Re: [RFC PATCH 01/24] vhost-vdpa: fix backend feature ioctls
Message-ID: <20200924073810.GB170403@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-2-jasowang@redhat.com>
 <20200924071609.GA170403@mtl-vdi-166.wap.labs.mlnx>
 <042dc3f9-40f0-f740-7ffc-611d315bc150@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <042dc3f9-40f0-f740-7ffc-611d315bc150@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600933019; bh=+eY8+fXvngYj7XnYGCkUG8jrRpVijqI96ZMj1LGmxWE=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=WnvFZcXfAFVVIByiIYbR+uKmdmmTlMOmyJvEJc7hCQzIVGcGXGJpD+Dr8/YQNWcGg
         LOq+tR9i0Kn2gD+iaqawryJBcoNJcj0c+vW76jzqg3upQD2YeqCQTbXCK4MIWhA3PI
         lDpNIHqe+WIjBtzCHb/k1rKcunqeiKFw/mXkCAjFuMITzH1bgwKpaDH79HQmpfXH7q
         Pn93V4GsDH+6iYuiV3nRBeysiY2jNruBumG9wFHncs53dFH1sCAH3WhFhyjlvn6U8D
         RayV6/I9+AKyi4lgpDVV1YdjlCyRr+DTl2/pLDiZ4Y3TIj+SiMJrf2EHOamqFvw+0w
         biH0TccDh6mQA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 03:26:08PM +0800, Jason Wang wrote:
>=20
> On 2020/9/24 =E4=B8=8B=E5=8D=883:16, Eli Cohen wrote:
> > On Thu, Sep 24, 2020 at 11:21:02AM +0800, Jason Wang wrote:
> > > Commit 653055b9acd4 ("vhost-vdpa: support get/set backend features")
> > > introduces two malfunction backend features ioctls:
> > >=20
> > > 1) the ioctls was blindly added to vring ioctl instead of vdpa device
> > >     ioctl
> > > 2) vhost_set_backend_features() was called when dev mutex has already
> > >     been held which will lead a deadlock
> > >=20
> > I assume this patch requires some patch in qemu as well. Do you have
> > such patch?
> >=20
>=20
> It's this series: [PATCH 0/3] Vhost-vDPA: batch IOTLB updating.
>=20
> You were copied.
>=20

Right, I miss those.
Thanks.
