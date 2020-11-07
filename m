Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1F32AA749
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgKGRrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgKGRrW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:47:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F0312087E;
        Sat,  7 Nov 2020 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771241;
        bh=xmCqyQqVD30v06ykT8AoFEbRyIUdgEgssZ6h6vKLA/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rsGxhZ1i46O6fqO5vJczPJDHrAKsi+C8DD4s93+rSgAVuqOgDpgAB1RHsUI3onu4c
         RUcu/UaTqpr6Ucai8xyz/Kv765WtjeXSwDr8Dd8ALALY/H/oR2aFqlmNkvDHe6iepJ
         Jc2/ixI7V4Yf4y+JHnPTt+qY3Pa7DrK90eqhQPCc=
Date:   Sat, 7 Nov 2020 09:47:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 10/11] net: hns3: add ethtool priv-flag for
 EQ/CQ
Message-ID: <20201107094721.648db60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604730681-32559-11-git-send-email-tanhuazhong@huawei.com>
References: <1604730681-32559-1-git-send-email-tanhuazhong@huawei.com>
        <1604730681-32559-11-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 14:31:20 +0800 Huazhong Tan wrote:
> +static void hns3_update_cqe_mode(struct net_device *netdev, bool enable, bool is_tx)

Wrap this to 80 characters, please.
