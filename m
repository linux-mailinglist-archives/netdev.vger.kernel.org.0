Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4182ACA1A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgKJBLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:11:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:11:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 517DA206D8;
        Tue, 10 Nov 2020 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604970690;
        bh=VIZZlsx0jAouiq3t1QoP1KOVqGLlr6W8TTq9SFQmF3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZDdpsC4f8aqGBsvCk04lvbv0d6EX6OwnUZQ8Kn2DH/eYK5s0qyuLyqh/40P72GSHj
         gO0NKtOZBSE+OKHVkTt1hcu6PVLpjT418GiUss1boJKJbeEDnWiUS4IxsIZOA1W48X
         DFJ4X+AOo3vhe5aICWqcYtc919Zb/8mpCVdi7sGE=
Date:   Mon, 9 Nov 2020 17:11:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <nikolay@nvidia.com>, <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] bridge: mrp: Use hlist_head instead of
 list_head for mrp
Message-ID: <20201109171129.6b156947@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106215049.1448185-1-horatiu.vultur@microchip.com>
References: <20201106215049.1448185-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 22:50:49 +0100 Horatiu Vultur wrote:
> Replace list_head with hlist_head for MRP list under the bridge.
> There is no need for a circular list when a linear list will work.
> This will also decrease the size of 'struct net_bridge'.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Applied, thanks!
