Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA974301E53
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 20:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhAXTEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 14:04:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6034 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbhAXTEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 14:04:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600dc4810000>; Sun, 24 Jan 2021 11:03:29 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Jan
 2021 19:03:28 +0000
Date:   Sun, 24 Jan 2021 21:03:25 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alan Perry <alanp@snowmoose.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] rdma.8: Add basic description for users unfamiliar
 with rdma
Message-ID: <20210124190325.GE5038@unreal>
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
 <20201223081918.GF3128@unreal>
 <7e80d241-d33c-8bb2-08a5-cdc11f2a3e80@snowmoose.com>
 <20210124063126.GD4742@unreal>
 <297f2af6-d85e-1adb-51b9-aa9bf17c99b8@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <297f2af6-d85e-1adb-51b9-aa9bf17c99b8@snowmoose.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611515009; bh=hWSgi1efvRtYeHyzd5eMgNhEl0F1lwatV1tm3MHDGsI=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:X-Originating-IP:X-ClientProxiedBy;
        b=B7LWVo/Zm2U4QRcPQwougGotw+re7iZv9jK8nimn9ZBP8F8KYfC4f3qt4ILvW68rC
         lLZm2CbYSePUYZAr0mNV5EV2rxeqAU0Ca68ptL/Ezekyl7djMH/Iao+cWMxn7H+0gJ
         CkyzC8SLWkyzaLYKkeWmlHDqKOnnKHlGfNPAI12KvJ+i/LG0EqSOm+yxHpoa0Ol5Gh
         Docz/UgkQ0k+S09TsZwj71rsxR9MXWakm1F7sdjY7xOodk6v8X6H+44keSoRJ/RUFC
         t4v0lYzvESwnerOWZQ3dT4GIzzfXzu7Xt5fL9IXXZ2VIrpapcOIRMWCoih3+eS0vds
         L+b48TYELH4+w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 10:09:55AM -0800, Alan Perry wrote:
>
> Add a description section with basic info about the rdma command for user=
s
> unfamiliar with it.
>
> Signed-off-by: Alan Perry <alanp@snowmoose.com>
> ---
> =A0 man/man8/rdma.8 | 9 ++++++++-
> =A0 1 file changed, 8 insertion(+), 1 deletion(-)
> diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
> index c9e5d50d..66ef9902 100644
> --- a/man/man8/rdma.8
> +++ b/man/man8/rdma.8
> @@ -1,4 +1,4 @@
> -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
> +.TH RDMA 8 "24 Jan 2021" "iproute2" "Linux"
> =A0.SH NAME
> =A0rdma \- RDMA tool
> =A0.SH SYNOPSIS
> @@ -29,6 +29,13 @@ rdma \- RDMA tool
> =A0\fB\-j\fR[\fIson\fR] }
> =A0\fB\-p\fR[\fIretty\fR] }
>
> +.SH DESCRIPTION
> +.B rdma
> +is a tool for querying and setting the configuration for RDMA-capable
> +devices. Remote direct memory access (RDMA) is the ability of accessing
> +(reading, writing) memory on a remote machine without interrupting the
> +processing of the CPU(s) on that system.
> +
> =A0.SH OPTIONS
>
> =A0.TP

Please send patch with git send-email and not as reply.
Also don't forget to add my Acked-by, use [PATCH iproute2-next] in the
title and add Changelog under "---".

Thanks

>
> On 1/23/21 10:31 PM, Leon Romanovsky wrote:
> > On Thu, Jan 21, 2021 at 01:32:42PM -0800, Alan Perry wrote:
> > >
> > > On 12/23/20 12:19 AM, Leon Romanovsky wrote:
> > > > On Tue, Dec 22, 2020 at 08:47:51PM -0800, Alan Perry wrote:
> > > > > Add a description section with basic info about the rdma command =
for users
> > > > > unfamiliar with it.
> > > > >
> > > > > Signed-off-by: Alan Perry <alanp@snowmoose.com>
> > > > > ---
> > > > >    man/man8/rdma.8 | 6 +++++-
> > > > >    1 file changed, 5 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
> > > > > index c9e5d50d..d68d0cf6 100644
> > > > > --- a/man/man8/rdma.8
> > > > > +++ b/man/man8/rdma.8
> > > > > @@ -1,4 +1,4 @@
> > > > > -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
> > > > > +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
> > > > >    .SH NAME
> > > > >    rdma \- RDMA tool
> > > > >    .SH SYNOPSIS
> > > > > @@ -29,6 +29,10 @@ rdma \- RDMA tool
> > > > >    \fB\-j\fR[\fIson\fR] }
> > > > >    \fB\-p\fR[\fIretty\fR] }
> > > > >
> > > > > +.SH DESCRIPTION
> > > > > +.B rdma
> > > > > +is a tool for querying and setting the configuration for RDMA, d=
irect
> > > > > memory access between the memory of two computers without use of =
the
> > > > > operating system on either computer.
> > > > > +
> > > > Thanks, it is too close to the Wikipedia description that can be wr=
itten
> > > > slightly differently (without "two computers"), what about the foll=
owing
> > > > description from Mellanox site?
> > > >
> > > > "is a tool for querying and setting the configuration for RDMA-capa=
ble
> > > > devices. Remote direct memory access (RDMA) is the ability of acces=
sing
> > > > (read, write) memory on a remote machine without interrupting the p=
rocessing
> > > > of the CPU(s) on that system."
> > > >
> > > > Thanks,
> > > > Acked-by: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > I noticed that the rdma man page has not been changed. I am unfamilia=
r with
> > > the process. Should I have submitted an updated patch with the altern=
ate
> > > wording after this exchange?
> > Yes, please.
> >
> > Thanks
> >
> > > alan
