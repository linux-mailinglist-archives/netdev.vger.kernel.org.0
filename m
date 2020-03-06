Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518C817BC5C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCFMJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgCFMJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 07:09:23 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023532072D;
        Fri,  6 Mar 2020 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583496563;
        bh=Epw/1SBsSOcELjkwZa4Cji7Sf1ohOwhNEBKQO2bk1rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yWlw4QewSUZWWIWqLR7LY7l0fbg8NJmPxldvDIQ4iDCKkO+ek42QVSiiLc2T9V2F7
         X2fstykUL6kqIxEhNvO+oNFtKxwZvABAeRAaCuhNXDNYMWjmRV+HKRf0UmSfAP/vHG
         QMUychz/x5eID+rlbaONerBCwhNxa8nasLeSoXGQ=
Date:   Fri, 6 Mar 2020 14:09:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, linux-um@lists.infradead.org,
        dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        edumazet@google.com, jasowang@redhat.com, mkubecek@suse.cz,
        hayeswang@realtek.com, doshir@vmware.com, pv-drivers@vmware.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, merez@codeaurora.org,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] RDMA/ipoib: reject unsupported coalescing
 params
Message-ID: <20200306120918.GQ184088@unreal>
References: <20200306010602.1620354-1-kuba@kernel.org>
 <20200306010602.1620354-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306010602.1620354-3-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 05:05:57PM -0800, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
