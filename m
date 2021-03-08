Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6233312D2
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCHQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhCHQDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 11:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9875065210;
        Mon,  8 Mar 2021 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615219424;
        bh=PBmEbgMiN3pUGiaxEnpqYz1pmhYI5EG78UjJ+zTCa34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NcWexvUdUGzNuljFAKt4fG1oCKJyzBczFAtB8+g0gDNqIo3suCYS8hcUyItWj1WgC
         YE5J1Wauy0loF0JQdDbudC7sEd5zCV6eYhEgKTgzx4mCxoCQD3iFCWNyrxqDP68Y1c
         MTSoyBck2RU5OWWsFfNAxjmXsvp9+7iiGnQrB8dkBh3sG1cS78DUNEbYCf3Oc3oWbL
         D3JBQ15AywqQuZ4fJyWciTSGIMZz7xhkzC4/4seW7Kog0XWj0ChEDFzah/mjXVROSo
         XylHnTySjGqGDAdgnlbBsHBNVmDcjr7z69oEMKc66j/TxKyeJcRK91KTmHZ1GedeC1
         4XTqKpPLor6ZQ==
Date:   Mon, 8 Mar 2021 18:03:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/4] vDPA/ifcvf: remove the version number string
Message-ID: <YEZK3JF1hdSvfIzi@unreal>
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-5-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308083525.382514-5-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 04:35:25PM +0800, Zhu Lingshan wrote:
> This commit removes the version number string, using kernel
> version is enough.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 2 --
>  1 file changed, 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
