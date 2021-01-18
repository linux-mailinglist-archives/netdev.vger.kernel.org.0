Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA55E2FAD53
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbhARWaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbhARWam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 17:30:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A9B122CAD;
        Mon, 18 Jan 2021 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611009001;
        bh=AB2pnIpG2vO9SbQwThxOJlZMOhzUueP38fYONle5nu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EkyqWWx9ZGxBf0F4H8YcVO2dGD3h6JWFvj2coy1jElnmxt9Fg6LLu7CWVXB4hVZLF
         I97vcgMowDUHoODCHw61V/DHHOvBP9JTMFPtv573RXoFAWyM4fXdi5Mg2jDWdEXYcX
         aeBMPMq2MPTzKrawbrplt7MIOS77jFOXzZFinNsloFMNhKVqfWKg9PgWDLm8YpqKfk
         H2NncMISVU/E9YJLthCEz5nHvNdyqfgqhgP64ejLXK0XMi+QI+U1zojSiljKQ0dIBi
         4fFl1rC84kj5UnQhLFPGh+/hX2TwWAOsUcx8yKAnR65KcXoreXVgHbwdK8g7nHUOpA
         dfuk1XmkAljZA==
Date:   Mon, 18 Jan 2021 14:30:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        <menglong8.dong@gmail.com>
Cc:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v4 net-next] net: bridge: check vlan with
 eth_type_vlan() method
Message-ID: <20210118143000.0a534525@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ffce5e21-fdd2-cb2b-6957-7454aea9c665@nvidia.com>
References: <20210117080950.122761-1-dong.menglong@zte.com.cn>
        <ffce5e21-fdd2-cb2b-6957-7454aea9c665@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 13:55:11 +0200 Nikolay Aleksandrov wrote:
> On 17/01/2021 10:09, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> > 
> > Replace some checks for ETH_P_8021Q and ETH_P_8021AD with
> > eth_type_vlan().
> > 
> > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied, thanks!
