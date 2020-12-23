Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9606C2E248C
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 07:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgLXGFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 01:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgLXGFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 01:05:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149C922AAA;
        Thu, 24 Dec 2020 06:04:27 +0000 (UTC)
Date:   Wed, 23 Dec 2020 10:19:18 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Alan Perry <alanp@snowmoose.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] rdma.8: Add basic description for users unfamiliar with
 rdma
Message-ID: <20201223081918.GF3128@unreal>
References: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb358848-49a8-1a8e-3919-c07b6aa3d21d@snowmoose.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 08:47:51PM -0800, Alan Perry wrote:
> Add a description section with basic info about the rdma command for users
> unfamiliar with it.
>
> Signed-off-by: Alan Perry <alanp@snowmoose.com>
> ---
>  man/man8/rdma.8 | 6 +++++-
>  1 file changed, 5 insertion(+), 1 deletion(-)
>
> diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
> index c9e5d50d..d68d0cf6 100644
> --- a/man/man8/rdma.8
> +++ b/man/man8/rdma.8
> @@ -1,4 +1,4 @@
> -.TH RDMA 8 "28 Mar 2017" "iproute2" "Linux"
> +.TH RDMA 8 "22 Dec 2020" "iproute2" "Linux"
>  .SH NAME
>  rdma \- RDMA tool
>  .SH SYNOPSIS
> @@ -29,6 +29,10 @@ rdma \- RDMA tool
>  \fB\-j\fR[\fIson\fR] }
>  \fB\-p\fR[\fIretty\fR] }
>
> +.SH DESCRIPTION
> +.B rdma
> +is a tool for querying and setting the configuration for RDMA, direct
> memory access between the memory of two computers without use of the
> operating system on either computer.
> +

Thanks, it is too close to the Wikipedia description that can be written
slightly differently (without "two computers"), what about the following
description from Mellanox site?

"is a tool for querying and setting the configuration for RDMA-capable
devices. Remote direct memory access (RDMA) is the ability of accessing
(read, write) memory on a remote machine without interrupting the processing
of the CPU(s) on that system."

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
