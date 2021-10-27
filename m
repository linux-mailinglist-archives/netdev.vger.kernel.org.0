Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB91343C1F9
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 07:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhJ0FEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 01:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhJ0FED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 01:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA6F60F21;
        Wed, 27 Oct 2021 05:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635310898;
        bh=ScikVqsTCfRD6JWXtfHR67HfEXH2xij3yqgufDqjVx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KJmXoaUez2bmv0tlcoxYpAjrTWIeFEusSmBahzIW9Ika9UNc7hBIiO7GyxEcNDR+t
         ErQnc8lk7rfzJ1QU+JHtFU2VPSdhsG1FZkt/MVwiksdIQEI1s0K4SWYxQrymr1op7a
         CE1+MnMOBe57/5Npe2lP4niQmcJisCVK1gcSckl0=
Date:   Wed, 27 Oct 2021 07:01:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <YXjdLy4FL1CA0D45@kroah.com>
References: <20211026193717.2657-1-manishc@marvell.com>
 <YXhfe1+HMyPJECJ3@kroah.com>
 <BY3PR18MB461222692845B97A5624E88DAB849@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB461222692845B97A5624E88DAB849@BY3PR18MB4612.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:30:34PM +0000, Manish Chopra wrote:
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Wednesday, October 27, 2021 1:35 AM
> > To: Manish Chopra <manishc@marvell.com>
> > Cc: kuba@kernel.org; netdev@vger.kernel.org; stable@vger.kernel.org; Ariel
> > Elior <aelior@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> > malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> > <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> > linux-l2@marvell.com
> > Subject: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Tue, Oct 26, 2021 at 12:37:16PM -0700, Manish Chopra wrote:
> > > Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> > > firmware file to linux-firmware.git tree. This new firmware addresses
> > > few important issues and enhancements as mentioned below -
> > >
> > > - Support direct invalidation of FP HSI Ver per function ID, required for
> > >   invalidating FP HSI Ver prior to each VF start, as there is no VF
> > > start
> > > - BRB hardware block parity error detection support for the driver
> > > - Fix the FCOE underrun flow
> > > - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> > >
> > > This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.
> > >
> > > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the stable kernel
> > tree.  Please read:
> >     https://urldefense.proofpoint.com/v2/url?u=https-
> > 3A__www.kernel.org_doc_html_latest_process_stable-2Dkernel-
> > 2Drules.html&d=DwIBAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=bMTgx2X48QVXyXO
> > EL8ALyI4dsWoR-m74c5n3d-
> > ruJI8&m=ty09KAp_t8LlTicBDOtEO7pxmxWrH0D0JgMAieGU5RA&s=2fheQ69qq4l
> > tmmFzYYyaQXTj7naqE87MTdo3bL9sJYY&e=
> > for how to do this properly.
> > 
> > </formletter>
> 
> Hello Greg,
> 
> This patch set is mainly meant for net-next.git, can you please tell about the issue more specifically ?
> Do you mean that I should not have Cced stable here ? is that the problem ?

Please read the link I sent you for how to properly get patches accepted
into the stable kernel trees, it should answer this question for you.

thanks,

greg k-h
