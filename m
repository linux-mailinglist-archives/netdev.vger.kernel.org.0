Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB6A2E7784
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 10:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgL3Jp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 04:45:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10094 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgL3Jp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 04:45:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fec4c0e0000>; Wed, 30 Dec 2020 01:44:46 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 30 Dec 2020 09:44:23 +0000
Date:   Wed, 30 Dec 2020 11:44:19 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>, <eli@mellanox.com>, <lingshan.zhu@intel.com>,
        <rob.miller@broadcom.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [PATCH 07/21] vdpa: multiple address spaces support
Message-ID: <20201230094419.GA5241@mtl-vdi-166.wap.labs.mlnx>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-8-jasowang@redhat.com>
 <20201229072832.GA195479@mtl-vdi-166.wap.labs.mlnx>
 <e8b9dabb-ae78-1c84-b5f3-409bec3e8255@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e8b9dabb-ae78-1c84-b5f3-409bec3e8255@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609321486; bh=T+aNJlqaQjEa7ixZd49BALMpmAXvQ08gOshCZHVK8wk=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=JvWpAQBNoX9k7KYlTy49CChU3oIracyLFt9BYagykfw2FaKWDLM5YUVEQ6iIYjUCr
         Wynwc02+9A7HdwMCA9zF/gPzdZEU0KRa5D3CaL55FkEyR6PUMstbHA2zHuvpd67keo
         zKdk+Yimd52B2MuRh9hX++nD8a4W9V0dHXl1Zlq54iDFYNx3RiM9mlBZ6z59rgDAh8
         JaIpCk43jwiOdszgVBWwc40HWKUkjJqY1zgN0k7wPUb1vsUDcE4kfyouQZE6bu+/3g
         2sZ6aXhU7YJurbiclqNQK1c5Lg3rRnxCuwa76t2owEjMFI16Qq+V/4TROdXBfa0vPl
         ZI5ASd2VtHo7A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 12:04:30PM +0800, Jason Wang wrote:
>=20
> On 2020/12/29 =E4=B8=8B=E5=8D=883:28, Eli Cohen wrote:
> > > @@ -43,6 +43,8 @@ struct vdpa_vq_state {
> > >    * @index: device index
> > >    * @features_valid: were features initialized? for legacy guests
> > >    * @nvqs: the number of virtqueues
> > > + * @ngroups: the number of virtqueue groups
> > > + * @nas: the number of address spaces
> > I am not sure these can be categorised as part of the state of the VQ.
> > It's more of a property so maybe we can have a callback to get the
> > properties of the VQ?
>=20
>=20
> Or maybe there's a misunderstanding of the patch.
>=20

Yes, I misinterpreted the hunk. No issue here.

> Those two attributes belongs to vdpa_device instead of vdpa_vq_state
> actually.
>=20
> Thanks
>=20
