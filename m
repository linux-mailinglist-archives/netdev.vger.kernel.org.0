Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48FD2B4A2F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgKPP7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbgKPP7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:59:20 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C9AC20A8B;
        Mon, 16 Nov 2020 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605542360;
        bh=rgkh+lLMDpZDsdCUV06ZkL5Vht6RSAzwdxFtmRPXx2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=McgTkb7jnwNKOUq/OiaDIJ1PWafMsF0ev8KRwLHgkFNbgk9Rj5S+j/f1ROOpDXUKV
         ruxvOrLf2DYa54e2p87HtZH4pSxK+be56+HXUx48UA83xfDXouBTMxgY1vOz6DgowU
         F/BUNbScNFI21joagneHO+mcVWZtsD3HUfymICis=
Date:   Mon, 16 Nov 2020 07:59:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove nr_frags argument from
 rtl_tx_slots_avail
Message-ID: <20201116075919.7add7001@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <34cdb172-c5d5-fb18-dd15-e502a5c23966@gmail.com>
References: <34cdb172-c5d5-fb18-dd15-e502a5c23966@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 21:55:32 +0100 Heiner Kallweit wrote:
> The only time when nr_frags isn't SKB_MAX_FRAGS is when entering
> rtl8169_start_xmit(). However we can use SKB_MAX_FRAGS also here
> because when queue isn't stopped there should always be room for
> MAX_SKB_FRAGS + 1 descriptors.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Looks like this depended on the patch I just applied, please try avoid
this sort of dependencies, the bot can't test this.

Now the prerequisite is applied please resend.
