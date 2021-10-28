Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1643E4B5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhJ1PQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhJ1PQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205286121F;
        Thu, 28 Oct 2021 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635434025;
        bh=GoROrymvQ28gp7nmJQSQKcjU789/FbiSRvCXEDdxlhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eYEYzGE1YyZLUAAEtWGoHAZC15f0cXJGgU7w7w4xXLPaCAzCb3+NpgMXV1by4P60v
         UozltDqlAEP1HhNsW5h1QEtYsAsUgzx0ksVggfTg4AMPWCfeQSZimFVPSmVvdolitE
         qN3FjfqS4SeQ+IKLlAzyFT1knY0SJ2WZaChM4GrWZ+5fY0uZUAs2Q+OUA3FtzQoE4Y
         BfPp6FHe9tCI5ObI168GQe87ppaPvfe+g8aP45qN9/AB5PwkyhIiNY5BVKkc7MenUS
         MoPCQMGE1/W3D9FgkMHUgZSKyvBBHH1xT3AGFYvlcx7S8mxYvhyLsgNEISSwzZjho4
         eg9q4p8GzPCSw==
Date:   Thu, 28 Oct 2021 08:13:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Message-ID: <20211028081344.2e6e9415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028150315.19270-1-yuiko.oshino@microchip.com>
References: <20211028150315.19270-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 11:03:15 -0400 Yuiko Oshino wrote:
> Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performance on some platforms.
> Tested on x86 PC with EVB-LAN7430.
> The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved from 817 Mbps to 936 Mbps.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

You seem to be posting performance optimizations as fixes.
800Mbps is not "broken" for a 1G interface. Please remove 
the Fixes tag and re-post this with [PATCH net-next].

Thank you!
