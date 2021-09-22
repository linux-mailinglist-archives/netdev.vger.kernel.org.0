Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADD14143F1
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhIVIpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233349AbhIVIpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 04:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8301B61267;
        Wed, 22 Sep 2021 08:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632300218;
        bh=YTFdSl4to16Pi/CX0EYd+Fki7elCQyxBW/8jOHA95G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLGIKGesvSAf/dDWqUwTPFsyUPepS1DSFTjzVkHo5SlFNZBwDJQXBgAmbteAdsW7n
         m58zU+UJs3jhgqObB77qa05J4O4N9bGdt1uraM1QITJYK/Tn4GP7iFE6e+vd1kG993
         Xo0ziGVvnG+06RDiZfTDtkJ+7VZa/6r2S3S8KUx7c46yZSL1fAiiLD1SFKcDyY7B1B
         bNpnKSuknYHQBs2L0dclfvTxIAcHx/AbmIEzch3TqkXXxnlmLCi2VDy05NTgOBaNTx
         +TkCTfF469sS9PJL+OsfbxMp1cUwRLFuJF/JgLwsbtN7JyrtLrKpvgyI5I0wH9SVs/
         QhvBu5TUvHpQw==
Date:   Wed, 22 Sep 2021 11:43:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     jgg@nvidia.com, dledford@redhat.com, linux-rdma@vger.kernel.org,
        aharonl@nvidia.com, netao@nvidia.com,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 0/3] Optional counter statistics support
Message-ID: <YUrstuHiCmegk96w@unreal>
References: <20210921062726.79973-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921062726.79973-1-markzhang@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 09:27:23AM +0300, Mark Zhang wrote:
> ---------------------------------
> Kernel patch is not accepted yet.
> ---------------------------------

You need to add netdev and David to CC list and resubmit.

Thanks

> 
> Hi,
> 
> This is supplementary part of kernel series [1], which provides an
> extension to the rdma statistics tool that allows to set or list
> optional counters dynamically, using netlink.
> 
> Thanks
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg105567.html
> 
> Neta Ostrovsky (3):
>   rdma: Update uapi headers
>   rdma: Add stat "mode" support
>   rdma: Add optional-counters set/unset support
> 
>  man/man8/rdma-statistic.8             |  55 +++++
>  rdma/include/uapi/rdma/rdma_netlink.h |   3 +
>  rdma/stat.c                           | 327 ++++++++++++++++++++++++++
>  3 files changed, 385 insertions(+)
> 
> -- 
> 2.26.2
> 
