Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300D92C6CBE
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 21:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgK0Uz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 15:55:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbgK0Uxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 15:53:43 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DA322240;
        Fri, 27 Nov 2020 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606510423;
        bh=0Ugo/FksixhuBJSrurI1NOLLgw+KKK3Y9/cFh1zOdjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1m3wDx7PdSt78Z1pazOEYefRW98Azsa+JZWsc9/W/0YDfPk4dHHvlzFBTndN6aHcG
         iJrpEoij2URwyTRoaFtT2E4a+ilfDxp6VtZYAS+tm6ne1cs5BwNqBSJaHWRiO/IG6V
         bTrOLrk/D512mmzXwda05vmZYdgpZjmJwgO+w4oM=
Date:   Fri, 27 Nov 2020 12:53:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 5/7] net: hns3: add more info to
 hns3_dbg_bd_info()
Message-ID: <20201127125342.05daa45a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606466842-57749-6-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
        <1606466842-57749-6-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 16:47:20 +0800 Huazhong Tan wrote:
> Since TX hardware checksum and RX completion checksum have been
> supported now, so add related information in hns3_dbg_bd_info().
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22:    expected restricted __sum16 [usertype] csum
drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:266:22:    got unsigned int
drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22: warning: invalid assignment: |=
drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22:    left side has type restricted __sum16
drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:268:22:    right side has type unsigned int
