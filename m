Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE53376D17
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhEGXAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGXAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 19:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D8B610F7;
        Fri,  7 May 2021 22:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620428341;
        bh=EjaHRROIeemYNbn77Pcte5aTCvn8P3OM7tTx1UAOp1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tvJcBkMrJuu5FYbRT36vJ1S/10S5qy3WqKCjXuvnD4TKkkJA36b+qP8AXbb8a0P7y
         BgdPGsIj0WX9zA/34AgtdcSNMHlcTE+1xhFJBcSJQB3cibdxL6BNA27p+WeyBDNkDV
         +LDAs7aZgRWE9NXXUEBiCZwk6OgWngAvb1cW3vxr+bH7x/8ILoQE6rhGmg3uzLheBl
         g5WuX9TCyDrxLNzVGPLNuPh3y2dKqjSL8ocSH6kvbFv/Nmbh5e5lu4DDTrqII4rMtf
         uC4LR226PoqOBE2OgmiJBHRtXHFqlGO+ukX5Ib0qwGmWcjk7HzX/09AQQ0re/NceLB
         akI8YPuTeWUCA==
Date:   Fri, 7 May 2021 15:59:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     meijusan <meijusan@163.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit set
 in iphdr
Message-ID: <20210507155900.43cd8200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210506145905.3884-1-meijusan@163.com>
References: <20210506145905.3884-1-meijusan@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 May 2021 22:59:05 +0800 meijusan wrote:
> ip frag with the iphdr flags reserved bit set,via router,ip frag reasm or
> fragment,causing the reserved bit is reset to zero.
> 
> Keep reserved bit set is not modified in ip frag  defrag or fragment.
> 
> Signed-off-by: meijusan <meijusan@163.com>

Could you please provide more background on why we'd want to do this?
Preferably with references to relevant (non-April Fools' Day) RFCs.
