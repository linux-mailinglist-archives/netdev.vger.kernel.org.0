Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA88821523A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 07:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgGFFeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 01:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgGFFeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 01:34:05 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 042A720715;
        Mon,  6 Jul 2020 05:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594013644;
        bh=zAogrBYxw6RYdyPkFKLlpj78zwDqFBSHU1pFHKojs40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bpk7S4g33st8LxG/91NLN2k1g19tGvCEAXYZphCaRPo8p/s3e4RIj++VW6rcrZKWY
         poDBNoV7Iz0pVr54WEXvIvu5ONXamT8ufdAE0zbBy+BRTLOlhx/4LKwkBR1azWYmMW
         9xq+BR+DFd8x85bpXkUg9Ekmfcp7+9jrfdiBCI6I=
Date:   Mon, 6 Jul 2020 08:34:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v1 0/4] RAW format dumps through RDMAtool
Message-ID: <20200706053401.GE207186@unreal>
References: <20200624104012.1450880-1-leon@kernel.org>
 <974f4012-d730-c44f-af2b-cb25797f2f47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <974f4012-d730-c44f-af2b-cb25797f2f47@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 12:14:38PM -0600, David Ahern wrote:
> On 6/24/20 4:40 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v1:
> >  * Kernel part was accepted, so this series has correct SHA for the
> >    kernel header update patch.
> >  * Aligned implementation to the final kernel solution of query
> >    interface.
> > v0:
> > https://lore.kernel.org/linux-rdma/20200520102539.458983-1-leon@kernel.org
> >
> > -----------------------------------------------------------------------------
> >
> > Hi,
> >
> > The following series adds support to get the RDMA resource data in RAW
> > format. The main motivation for doing this is to enable vendors to
> > return the entire QP/CQ/MR data without a need from the vendor to set
> > each field separately.
> >
>
> applied to iproute2-next. Thanks

Thanks

>
>
