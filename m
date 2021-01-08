Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835502EEC1F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbhAHEHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbhAHEHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:07:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1627C236F9;
        Fri,  8 Jan 2021 04:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610078821;
        bh=hNIaet/VRKcs68KnQeO+7vW1l8RNjwChxRtr95TaGbU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pZ9/DQtdNaSYTaBHHcWUzc+RZqwMsB6N6x0hzMhJ4jT5wICXv9gP4Mty1e+obmVjG
         vb9VPvq8c00obB7QTT7kirJXhbh9ZY+3ZG+x9P6FqRR7mdhhS3nlyohwtnlTkloPcg
         afmg3DHx/F/IlyhVyP8XXcflS7PQ0AP4GWhAkY5kFfZEjS9B5uAr4AGI37jZLz3DzN
         tF/pSIqVxCSAUJrM+QTzYker+QEyqYtl/iONHKWiJckgEH0AXhm9sNXffEOKG30e0f
         7Zv4987RL3/hinXw2Zx5JOLjWhaZbpiu3DvRrIXJFUlFzIue9kgE4ihWMdCfE9DPv8
         jOItMxJlO5TSw==
Message-ID: <40f4b41a1ddfb1bcafd24f7010c8fa8ff25c6656.camel@kernel.org>
Subject: Re: [net 05/11] net/mlx5e: Fix SWP offsets when vlan inserted by
 driver
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Thu, 07 Jan 2021 20:07:00 -0800
In-Reply-To: <20210107190820.5251c845@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210107202845.470205-1-saeed@kernel.org>
                <20210107202845.470205-6-saeed@kernel.org>
         <20210107190820.5251c845@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-07 at 19:08 -0800, Jakub Kicinski wrote:
> On Thu,  7 Jan 2021 12:28:39 -0800 Saeed Mahameed wrote:
> > +	if (skb_vlan_tag_present(skb) &&  ihs)
> 
> Double space.

Will address this in a net-next patch.

thanks!

