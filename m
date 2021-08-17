Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDB43EED9C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbhHQNmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239955AbhHQNmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 09:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD3D60FBF;
        Tue, 17 Aug 2021 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207606;
        bh=sEyoYkgf+LK3AB8PmeLeHrmxFSc+SRKOIWZbv+8dyeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DkwmgfolEyDi9xhFXhBIjo56UqXglcCX9LFIsU7QWCRIPD2sFjpFvpwE1p2PRtCvW
         R4bTCUxUeqZq37K74D1POWKXPsLN4/AzkA0X66pvV1UeAg2XSTeumHW/yeyvziQijN
         A8dQup3msDjEKxeWN+j2zKyL43d792LGaejvvA5ZVSPwWQoxnoo85Fgu4f73WTrRwy
         ph3oAh+0hXVK5KW4tKIJiBunphVPhiM3hkha4MYQg6xcU3gmxHPUBEKeQQGqSwP5Bf
         hDphuxMqw/LjU31s+l0qHcbufqsymK7EQohzf7ScasdkhzSkseU/2PRe5AMFi3XPRh
         pUH1TC9eBeS3A==
Date:   Tue, 17 Aug 2021 06:40:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
Message-ID: <20210817064003.00733801@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
        <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 10:36:05 +0800 Yufeng Mo wrote:
>  include/linux/ethtool.h                            | 16 ++++++++++--
>  net/ethtool/coalesce.c                             | 29 ++++++++++++++++++----
>  net/ethtool/ioctl.c                                | 15 ++++++++---
>  net/ethtool/netlink.h                              |  2 +-

I'd move changes to these files to the first patch, otherwise 
they're hard to find in all the driver modifications.
