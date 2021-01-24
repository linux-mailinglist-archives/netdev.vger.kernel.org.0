Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172AB301A38
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 07:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbhAXGgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 01:36:22 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3333 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbhAXGgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 01:36:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600d153c0000>; Sat, 23 Jan 2021 22:35:40 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Jan
 2021 06:35:39 +0000
Date:   Sun, 24 Jan 2021 08:31:26 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alan Perry <alanp@snowmoose.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH] rdma.8: Add basic description for users unfamiliar with
 rdma
Message-ID: <20210124063126.GD4742@unreal>
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
 <20201223081918.GF3128@unreal>
 <7e80d241-d33c-8bb2-08a5-cdc11f2a3e80@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7e80d241-d33c-8bb2-08a5-cdc11f2a3e80@snowmoose.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611470140; bh=LnzCWKv1uyNSGIZKSz9gWGmnTbh/MQQvn+aoq62HUMI=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=Qqa1LEOZm3Y/9TMDNIhY6u+ACNwEqlXCYzk2XIzL9Jx/MVDkj1/Bq6xlBDMea+7rm
         A+iAYZq2y8Row/cclfhKnELzSOS7tMNF2J4uCIoDdz1wrBfgE5sB4simbz5kE/zSJR
         MNpqL58rZ9v2l78BiRvcGckADUM5hYojPSi+o5atZ6tH+KY5xF9UH/fpGw++MwsAB+
         e6qhgeQyTtXbFKs/PO2WVn7BZecruq9IpDye7IhEYupg+MVNqUKG59NVyNj/PRib2L
         fqF+aZvywFG3K2AmgGyLTQ84v9pQGm0PosuT8fe/mvutpDUL7ezizy2el7wZ5h7aFs
         0OQ5t7LZbKklg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 01:32:42PM -0800, Alan Perry wrote:
>
>
> On 12/23/20 12:19 AM, Leon Romanovsky wrote:
> > On Tue, Dec 22, 2020 at 08:47:51PM -0800, Alan Perry wrote:
> > > Add a description section with basic info about the rdma command for users
> > > unfamiliar with it.
> > >
> > > Signed-off-by: Alan Perry <alanp@snowmoose.com>
> > > ---
> > >   man/man8/rdma.8 | 6 +++++-
> > >   1 file changed, 5 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
> > > index c9e5d50d..d68d0cf6 100644
> > > --- a/man/man8/rdma.8
> > > +++ b/man/man8/rdma.8
> > > @@ -1,4 +1,4 @@
> > > -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
> > > +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
> > >   .SH NAME
> > >   rdma \- RDMA tool
> > >   .SH SYNOPSIS
> > > @@ -29,6 +29,10 @@ rdma \- RDMA tool
> > >   \fB\-j\fR[\fIson\fR] }
> > >   \fB\-p\fR[\fIretty\fR] }
> > >
> > > +.SH DESCRIPTION
> > > +.B rdma
> > > +is a tool for querying and setting the configuration for RDMA, direct
> > > memory access between the memory of two computers without use of the
> > > operating system on either computer.
> > > +
> >
> > Thanks, it is too close to the Wikipedia description that can be written
> > slightly differently (without "two computers"), what about the following
> > description from Mellanox site?
> >
> > "is a tool for querying and setting the configuration for RDMA-capable
> > devices. Remote direct memory access (RDMA) is the ability of accessing
> > (read, write) memory on a remote machine without interrupting the processing
> > of the CPU(s) on that system."
> >
> > Thanks,
> > Acked-by: Leon Romanovsky <leonro@nvidia.com>
> >
>
> I noticed that the rdma man page has not been changed. I am unfamiliar with
> the process. Should I have submitted an updated patch with the alternate
> wording after this exchange?

Yes, please.

Thanks

>
> alan
