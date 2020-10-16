Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F04290B15
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390932AbgJPSGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390346AbgJPSGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 14:06:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB27208E4;
        Fri, 16 Oct 2020 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602871575;
        bh=Vli47nNjtY5fZHZADjA9pxWX0Qf/0maCObhcVFYPCU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dZ/91qCNP0NXefgL+ZXCyyHZWaL3k7CiPq5x6vYz1TLFjWK3jQvT6DslphjUDEpsr
         cU7sSYJh4U0CuBgEzJo1leZ5Hu3n4C3GYMbSvZFRCzHngDQg1y1x3oeTPvipikvRwN
         RkzY6RO40fMRCTVCbZSfP0JD4lx/88zarSc9u8C4=
Date:   Fri, 16 Oct 2020 11:06:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        hemantk@codeaurora.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v6 2/3] net: Add mhi-net driver
Message-ID: <20201016110613.77c3efc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602840007-27140-2-git-send-email-loic.poulain@linaro.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
        <1602840007-27140-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 11:20:07 +0200 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Thanks for the changes, looks much nicer.

Unfortunately we already sent a PR for 5.10 and therefore net-next 
is closed for new drivers and features.

Please repost when in reopens after 5.10-rc1 is cut.
