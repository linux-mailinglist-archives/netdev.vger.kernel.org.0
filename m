Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77845B2AA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhKXDdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239950AbhKXDdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:33:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEA4B60E8E;
        Wed, 24 Nov 2021 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637724613;
        bh=OPcDILzyn0XeIQ+YP3FJZKRJqafIC+6w8ZnqrHLOJuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YcGkJVnDxBzqWd7Zt1GKw9L6P5FHJQAbZBs89zRPmIPSqm6BuOAmgEtj5Os4u9uvF
         bbFPUVdOdE8dBQ906Q6hHwAYi0su/saHt1s5fWIepG28+gM53yOZv0sAWWCkBV5A1c
         F4/28CmwddklZUxUwGee4LKSrr8+MmVKRMyliXEUYySO7c2P1n86E19+IPFYz5bu3k
         SJiV0V6dg++KDAdCAO7DI6VALUyD81x+E5ukUJUtNEpngyKMdGWpo3wt7mHIxlHOmp
         /alonhnVNj//2cPZv+J1L7en8+Ym519yuMSPIcWF4tAfPTlum9XJ5GLX0YHuatKvMH
         +opqzinemoS4Q==
Date:   Tue, 23 Nov 2021 19:30:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: lan966x: add the basic lan966x
 driver
Message-ID: <20211123193011.12cde5da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123135517.4037557-3-horatiu.vultur@microchip.com>
References: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
        <20211123135517.4037557-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 14:55:13 +0100 Horatiu Vultur wrote:
> #include <asm/memory.h>

drivers/net/ethernet/microchip/lan966x/lan966x_main.c:3:10: fatal error: 'asm/memory.h' file not found
#include <asm/memory.h>
         ^~~~~~~~~~~~~~

Is this arch-specific? What do you need it for?
