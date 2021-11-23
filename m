Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3093459A25
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhKWCiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:38:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhKWCiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 21:38:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD426601FF;
        Tue, 23 Nov 2021 02:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637634914;
        bh=Q+gMjAAqRPAhRJd3mBWEmSAhD+o2dt4HfWbxbRO1PIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iNYMSgPUNjv8T5e2Il+Cai5wz1HluBSRAHIWodxcGTgZP1m5wq8V/qcqmjGJ3jjAs
         J0DSnSnrNZaSaSHjmfO30MY1hTQJ5kYS7dcVs3XCGGZW24FhPOCG1wlL4tQHYdYxTh
         MkJSch90zLpSPRTIps4/nDWMacdbXaUuyn7KLyOcn5+ZvMUL7Pv21O4AZZ7l0j+Y4y
         awntr9K0y/upI/xOW4eudIkPUXbxc1kjej3YtIH08EmpVwxwHxqHsEYKuJ/yT+QfhJ
         /XN4ZQoxjX9qC07dYtvkAGRnM62Jju/AiHpnhlZoJ9Folj0npEeZfWtEN+NCjST7To
         NyQyI4IWFV1pQ==
Date:   Mon, 22 Nov 2021 18:35:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH net] r8169: fix incorrect mac address assignment
Message-ID: <20211122183513.0a3f76f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1100ed0d-7618-f6d6-d762-4c0c6ae6ef40@gmail.com>
References: <1100ed0d-7618-f6d6-d762-4c0c6ae6ef40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 22:35:33 +0100 Heiner Kallweit wrote:
> The original changes brakes MAC address assignment on older chip
> versions (see bug report [0]), and it brakes random MAC assignment.
> 
> is_valid_ether_addr() requires that its argument is word-aligned.
> Add the missing alignment to array mac_addr.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=215087
> 
> Fixes: 1c5d09d58748 ("ethernet: r8169: use eth_hw_addr_set()")
> Reported-by: Richard Herbert <rherbert@sympatico.ca>
> Tested-by: Richard Herbert <rherbert@sympatico.ca>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
