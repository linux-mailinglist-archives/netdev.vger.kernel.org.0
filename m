Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11362C354D
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKYARo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgKYARo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:17:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C489206E5;
        Wed, 25 Nov 2020 00:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606263463;
        bh=++ao4phKartVo5TX8b7aRxmvzqAQrtQUw+yUM+GR6tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXULVpnudIddTspDJ6i9yump2DLa4MaPxTjh/fWWrYuuz5BpQXjfx2VWVWYG/IT5G
         BRH+thSHmn7cKPMEeKM1vpf/RtslHMsXldoVEF7vSNhrfQpHAgdiuk2uMpn1Q5TOVR
         iqN9yOqAKRSzkUFFCc3E3ix+EUr6cyUcXVyxfkr8=
Date:   Tue, 24 Nov 2020 16:17:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/2] lan743x: clean up software_isr function
Message-ID: <20201124161742.795f326d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123191529.14908-1-TheSven73@gmail.com>
References: <20201123191529.14908-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 14:15:28 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> For no apparent reason, this function reads the INT_STS register, and
> checks if the software interrupt bit is set. These things have already
> been carried out by this function's only caller.
> 
> Clean up by removing the redundant code.
> 
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied both, thank you!
