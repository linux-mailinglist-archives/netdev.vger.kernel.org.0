Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E47D1CC49B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgEIUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgEIUsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 16:48:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37C820731;
        Sat,  9 May 2020 20:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589057298;
        bh=kKsukZbTR7/vPdeWAXGzu8JeIRo0zQgu6EijWZzW5G8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uudwYEOrKtjYobuKqPG61W5KpZteJVZBm/Z4yKXxWnonVwx5i3IGeqmNwFd9/IANU
         aoq3Pu1YkiTPtbJNnRNsEYh/ECDNvhHYk42WCCjaVb5gLU+9vuUkyuR/yg5aP6TzmD
         gA4eBn2E40Ps/baBSuCHv2oLJZ6T6BU1D66XiD7Q=
Date:   Sat, 9 May 2020 13:48:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 3/5] net: hns3: provide .get_cmdq_stat
 interface for the client
Message-ID: <20200509134816.534860ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589016461-10130-4-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
        <1589016461-10130-4-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 17:27:39 +0800 Huazhong Tan wrote:
> This patch provides a new interface for the client to query
> whether CMDQ is ready to work.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> index 5602bf2..7506cab 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
> @@ -552,6 +552,7 @@ struct hnae3_ae_ops {
>  	int (*set_vf_mac)(struct hnae3_handle *handle, int vf, u8 *p);
>  	int (*get_module_eeprom)(struct hnae3_handle *handle, u32 offset,
>  				 u32 len, u8 *data);
> +	bool (*get_cmdq_stat)(struct hnae3_handle *handle);
>  };

I don't see anything in this series using this new interface, why is it
added now?
