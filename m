Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C36290DCB
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgJPWhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgJPWhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 18:37:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C0520874;
        Fri, 16 Oct 2020 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602887872;
        bh=b2EGIKg3KP0GtQPo2F73WLvD38qjR51SW+fFm5/DFnE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZNLk6WVQnGcj+itxB3EwnJslgGvxlZ/vwTgLbHm1WDAVYIBMCFpZUhCLSsBQ7QS90
         pSp4yEakwcMP5kgixMbHJjXr3y0BPBAGsb3PFwuq2XSGF8ompPKqcoL86G8EUn91ot
         iJ4ddVLd9CU3T9vit7ODUaIOcJ22p1BHp1JO4lAQ=
Date:   Fri, 16 Oct 2020 15:37:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>,
        <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: Fix Aspeed ast2600 TX hang issue
Message-ID: <20201016153750.1c46de21@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014060632.16085-2-dylan_hung@aspeedtech.com>
References: <20201014060632.16085-1-dylan_hung@aspeedtech.com>
        <20201014060632.16085-2-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 14:06:32 +0800 Dylan Hung wrote:
> The new HW arbitration feature on Aspeed ast2600 will cause MAC TX to
> hang when handling scatter-gather DMA.  Disable the problematic feature
> by setting MAC register 0x58 bit28 and bit27.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>

Applied, thank you.
