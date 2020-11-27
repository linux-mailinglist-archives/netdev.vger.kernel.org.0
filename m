Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6047E2C6CC0
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 21:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgK0U53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 15:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbgK0Ux0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 15:53:26 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5026F2223D;
        Fri, 27 Nov 2020 20:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606510372;
        bh=fA6BeuFD5oyyP5wjr3eiwdD8EAbpd24W7Vpd0iS8iQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JViVtJPhtnwj/qmSlX1GNob+QbExO+i6gvfVlQsfiWm6OXFTrpp+DSmwiUagq5e55
         axJStRDi2OvOho/U/Wc+AsTNkXsshdqlybUUyD1+qXuOnKLOSffvjqBp1/s+XDeceT
         ph/3CEK17cjN7XTxzCp9tIwPCC9RUWvd7Z+bjfAA=
Date:   Fri, 27 Nov 2020 12:52:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 1/7] net: hns3: add support for RX completion
 checksum
Message-ID: <20201127125251.7d25bb1a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606466842-57749-2-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
        <1606466842-57749-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 16:47:16 +0800 Huazhong Tan wrote:
> In some cases (for example ip fragment), hardware will
> calculate the checksum of whole packet in RX, and setup
> the HNS3_RXD_L2_CSUM_B flag in the descriptor, so add
> support to utilize this checksum.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14:    expected restricted __sum16 [usertype] csum
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2810:14:    got unsigned int
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14: warning: invalid assignment: |=
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14:    left side has type restricted __sum16
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:2812:14:    right side has type unsigned int
