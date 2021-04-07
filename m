Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65846357437
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355219AbhDGS0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355210AbhDGS0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 14:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8343961132;
        Wed,  7 Apr 2021 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617819986;
        bh=EJLHkhjrdLmYIH01W+0RTbuR1bz5DIOEy/LQjp4HXFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qK1s4nEAnQ396ZHGeroCv7/+fQxYu15xy9NTS3RK8QdHTfXKNa1js7O1Mk+YCwyEU
         m16/t/C9RCSyfJVdrgqytDk/C8oi5gn3Y65mhj0mTmYB+zSD5b536XuNI8wH7h2IkQ
         MPNC/stth5ROwHzvHMzu55wDoRMWribMIEH5mZGkkkN59Qtx4YjONNSNPkK0+b1RUQ
         bsHTCRmx2RGSbZDQ59+5LGZFJD6AsZtegqzIuJdcnMepA2b5jdpjtvPLFHH9rlZ4y7
         MgUr0bIQ5Y8jKsUSCU6BsReKJR42r8cCY5S4TzghKbpj8bC7jjPArgOCGbnCCOPLrl
         BGuYfemYTxD3g==
Date:   Wed, 7 Apr 2021 11:26:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove the new_ifindex argument from
 dev_change_net_namespace
Message-ID: <20210407112625.1b4ad324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407064051.248174-1-avagin@gmail.com>
References: <20210407064051.248174-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Apr 2021 23:40:51 -0700 Andrei Vagin wrote:
> Here is only one place where we want to specify new_ifindex. In all
> other cases, callers pass 0 as new_ifindex. It looks reasonable to add a
> low-level function with new_ifindex and to convert
> dev_change_net_namespace to a static inline wrapper.
> 
> Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
