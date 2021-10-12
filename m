Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ECA42A966
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhJLQaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhJLQaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 962D160C4A;
        Tue, 12 Oct 2021 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634056084;
        bh=k+1sY1vwJi/tGmXl/EVIbKWGcM4SSN0gogzZEGv3jw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mCTL2bX8Gxw3eOyZXV51ZYXxD32H9l+utuv/hL98IhQSV3aNsPsS37hv/jFpf3fgx
         FVwJyT09heIeCBUciInOMGvQCajrYo6oDv/ba1fYQRGMKNUu4X3Ptph1R/WS3lp9V+
         25KD5oHIiL0Dmw0qdiUa6vmu4Asbh5wMAkSPVHs0/S5CGua93QcpMJj+7Ln206umXd
         bdWmLPu8VxaZjwgeSU03QSqG5YZBfxdefXKMSUmWnR54p/g0719UeeGnKSxYZ/ZeOv
         7ppRgMIP+5yyBTy3lnZ1EzKx/kr552sChXUYxAldDN0IN6S8IDG5fcZyvOGENB2WyG
         hvqR6ImFv1kdA==
Date:   Tue, 12 Oct 2021 09:28:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211012092802.3d44b0ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012134127.11761-5-huangguangbin2@huawei.com>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
        <20211012134127.11761-5-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 21:41:25 +0800 Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add two new parameters ringparam_ext and extack for
> .get_ringparam and .set_ringparam to extend more ring params
> through netlink.

A few more warnings to fix:

drivers/net/ethernet/micrel/ksz884x.c:6329: warning: Function parameter or member 'extack' not described in 'netdev_get_ringparam'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:280: warning: Function parameter or member 'extack' not described in 'pch_gbe_get_ringparam'
drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c:304: warning: Function parameter or member 'extack' not described in 'pch_gbe_set_ringparam'
