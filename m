Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E7236FAF0
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhD3MxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:53:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhD3MxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 08:53:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcScp-001oTE-Ov; Fri, 30 Apr 2021 14:52:07 +0200
Date:   Fri, 30 Apr 2021 14:52:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 4/4] net: hns3: disable phy loopback setting in
 hclge_mac_start_phy
Message-ID: <YIv9d9CHvWAtbqJE@lunn.ch>
References: <1619773582-17828-1-git-send-email-tanhuazhong@huawei.com>
 <1619773582-17828-5-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619773582-17828-5-git-send-email-tanhuazhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 05:06:22PM +0800, Huazhong Tan wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> If selftest and reset are performed at the same time, the phy
> loopback setting may be still in enable state after the reset,
> and device cannot link up. So fix this issue by disabling phy
> loopback before phy_start().

This sounds like a generic problem, not specific to your
driver. Please look at solving this within phy_start().

	Andrew
