Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25142AFC21
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgKLBcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgKLAnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 19:43:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9750206A1;
        Thu, 12 Nov 2020 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605141796;
        bh=OqLTXFkxMQ3JSpj81BY4iQ+XCuz24lV6z7Z+/aRkrdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sguCUGJORzki8ftc+2G8r2JHMmf6C2IfaWC0noZnyWTOOkdYVbPCasDFadTIAlyrH
         hvULlN/6rv4HXrBHOIwv2gmKfUdCCMTlIqQJnR2X3RaEqwpEMKRUPre8qgwLZrKhVo
         rT366ZCDinVSIlAiIxjrt170UoLzDsB1xLYnBjbQ=
Date:   Wed, 11 Nov 2020 16:43:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: net: evaluate net.ipvX.conf.all.* sysctls
Message-ID: <20201111164314.50eff5d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107193515.1469030-1-vincent@bernat.ch>
References: <20201107193515.1469030-1-vincent@bernat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 20:35:12 +0100 Vincent Bernat wrote:
> Some per-interface sysctls are ignoring the "all" variant. This
> patchset fixes some of them when such a sysctl is handled as a
> boolean. This includes:
> 
>  - net.ipvX.conf.all.disable_policy
>  - net.ipvX.conf.all.disable_policy.disable_xfrm
>  - net.ipv4.conf.all.proxy_arp_pvlan
>  - net.ipvX.conf.all.ignore_routes_with_linkdown
> 
> Two sysctls are still ignoring the "all" variant as it wouldn't make
> much sense for them:
> 
>  - net.ipv4.conf.all.tag
>  - net.ipv4.conf.all.medium_id
> 
> Ideally, the "all" variant should be removed, but there is no simple
> alternative to DEVINET_SYSCTL_* macros that would allow one to not
> expose and "all" entry.

Applied to net-next, thanks.

Let's see if anyone complains..
