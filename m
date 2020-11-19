Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566882B8994
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKSB11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbgKSB10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:27:26 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0BD6246C0;
        Thu, 19 Nov 2020 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605749246;
        bh=ruN/fazh+ZYXqMcXIkuyqUm+o6MpFy89SaMV9Dvmj1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xc/MwMP1ZlJjtBAKv6iZ4/uyWGRy4F1dwSc1dAaklacTGNCz+aFLdMHvOX9rbmv/J
         x/s/m9LDoNwvsfSJ15cvxJJx3X5a8myn3Sa5+MaHqiZz3kb/amskLkx1LY3PWrmosD
         sOvfwpHl/Tvx7uNaN0bnB7DXzMc6czWQmL4uYFRg=
Date:   Wed, 18 Nov 2020 17:27:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        bridge@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: bridge: replace struct br_vlan_stats with
 pcpu_sw_netstats
Message-ID: <20201118172724.3c8e0092@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <04d25c3d-c5f6-3611-6d37-c2f40243dae2@gmail.com>
References: <04d25c3d-c5f6-3611-6d37-c2f40243dae2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 21:25:42 +0100 Heiner Kallweit wrote:
> Struct br_vlan_stats duplicates pcpu_sw_netstats (apart from
> br_vlan_stats not defining an alignment requirement), therefore
> switch to using the latter one.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
