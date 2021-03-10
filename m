Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4665B333881
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhCJJQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232176AbhCJJQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:16:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247FD64F67;
        Wed, 10 Mar 2021 09:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615367773;
        bh=4F4UviQ0MAwWWHGmRaFTU410NI5y3UWsDtvwcmlSP2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rPmwTLlrtWTu2qQuhPhBH52pvWiMC67U6RLHUy5jFd6s5KV5WISTGY82LshD7IroU
         P3CGm/60n76YpIAvfRAj4De7EnEiyj45rrhpMhyVwoo3FJVJYIiuVve5WeXS6PfN+v
         vucVqHnGJ36woeUDu2CljqJKgqdNTCYVcKmF5pVjbUaTtoStsfD9iRndJSbcJP46/D
         ykkfDHqnuDiZfFKDOPT+KNVS3zkiddTsGadEMt7Haio1eSHWVhlykg5DHC3BD2sOqy
         GW784CMMmtKIZFv5qqzkMPK4LkB6lCMisjNCFnXNx9r4WNbzrtfvVZ02ExxIC/5RC/
         sWzWsne7OPVqg==
Date:   Wed, 10 Mar 2021 11:16:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/6] vDPA/ifcvf: remove the version number string
Message-ID: <YEiOWd9jXHnw4b11@unreal>
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-5-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310090052.4762-5-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 05:00:50PM +0800, Zhu Lingshan wrote:
> This commit removes the version number string, using kernel
> version is enough.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 2 --
>  1 file changed, 2 deletions(-)
>

I already added my ROB, but will add again.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
