Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26BE29DE5F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbgJ1WTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731700AbgJ1WRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC7320791;
        Wed, 28 Oct 2020 00:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603844362;
        bh=ama+336Ygukz32DXwm4u8c4SpsM7WssbGHhQUQPnpOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s85IjftOb44KqTxijNnaFtDobixIEwdNWgdeHx57VzzebSF8o0WH9SfAiikf8ut0M
         sD1j3slCuur3SfaMi/US0E0vwzrw/j5lWzG17VQkhjluIXOskJyNAbwcMDdzGhF3p6
         QUoWPp6rZQ/DDL9poK/KdImEc+muAIGvXFxkHT+U=
Date:   Tue, 27 Oct 2020 17:19:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
Message-ID: <20201027171920.6c0ce156@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:29:45 +0100 Guillaume Nault wrote:
> TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
> packets. Such packets will thus require mpls_gso.ko for segmentation.
> 
> v2: Drop dependency on CONFIG_NET_MPLS_GSO in Kconfig (from Jakub and
>     David).
> 
> Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
