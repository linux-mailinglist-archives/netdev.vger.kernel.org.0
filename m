Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F353C36E5B5
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhD2HPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232317AbhD2HPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 03:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD2B6044F;
        Thu, 29 Apr 2021 07:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619680461;
        bh=pEjAAXTJtM5lG+/3g71KXjc9BM0UM5w7cbM2jxaGX20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nijl5v8H9AGOx/FWut2g9l+JovgJU4bYuD+g9KEI5m1jmcpj79F02haXEDZov81zC
         vF7dE5+8k04Qh8hO1IZaonrv/rT3a7oh3JYa2+AGVAUuQ/bAOV8JobgToQYqf17B0Q
         epDhTUIK/XvgNko1oCNybK6gWbyhJK7gBACEwiK7Khb/4kPq+xkr/hEPblJrufRaO3
         5/odekBJhQE0BALjQr3ua9u0Ar2RTCKJkUw/jX4Q+mmO2m14S0nea2WD+HeG+s8iZN
         K35uWR7ozpOBq1jKBemyHScdE6DwACGj71Bddivs5BPsiQ4mGF56+l6Bs7/YmEFILm
         FKDXJcymY0hUA==
Date:   Thu, 29 Apr 2021 10:12:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     David Ahern <dsahern@gmail.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH iproute2-next v2 2/2] rdma: Add copy-on-fork to get sys
 command
Message-ID: <YIpcZzOG/z2sbn/q@unreal>
References: <20210429064803.58458-1-galpress@amazon.com>
 <20210429064803.58458-3-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429064803.58458-3-galpress@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 09:48:03AM +0300, Gal Pressman wrote:
> The new attribute indicates that the kernel copies DMA pages on fork,
> hence fork support through madvise and MADV_DONTFORK is not needed.
> 
> If the attribute is not reported (expected on older kernels),
> copy-on-fork is disabled.
> 
> Example:
> $ rdma sys
> netns shared copy-on-fork on
> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/sys.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
