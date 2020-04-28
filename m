Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EE51BCA7C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbgD1StN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730911AbgD1StM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 14:49:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80BA206A1;
        Tue, 28 Apr 2020 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099752;
        bh=7JNHiBIIBF6nBVtNd2tj4B4ihq3wa/COFTfVnM8d+bI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X/Cbla9bkQeX3pAWWk2Bj/CFct7MIUbQJeJJPqwzVKzUyG2pSSDjjEwpX23QTlJ4w
         Wy14pBDSCpFw8puGMPF+pXn2LF/7q8lUxFWlueBnuMq3MiwcwfowT1igM8CyvsGcX/
         VKnU3ThtVRL2Nj5Owzdg6FCz39YUaDTD57wLcCJE=
Date:   Tue, 28 Apr 2020 11:49:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>
Subject: Re: [PATCH net-next] net: hns3: adds support for reading module
 eeprom info
Message-ID: <20200428114910.7cc5182e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1588075105-52158-1-git-send-email-tanhuazhong@huawei.com>
References: <1588075105-52158-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 19:58:25 +0800 Huazhong Tan wrote:
> From: Yonglong Liu <liuyonglong@huawei.com>
> 
> This patch adds support for reading the optical module eeprom
> info via "ethtool -m".
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> index 4d9c85f..8364e1b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> @@ -12,6 +12,16 @@ struct hns3_stats {
>  	int stats_offset;
>  };
>  
> +#define HNS3_MODULE_TYPE_QSFP		0x0C
> +#define HNS3_MODULE_TYPE_QSFP_P		0x0D
> +#define HNS3_MODULE_TYPE_QSFP_28	0x11
> +#define HNS3_MODULE_TYPE_SFP		0x03

Could you use the SFF8024_ID_* defines from sfp.h here as well?

Otherwise looks good to me!
