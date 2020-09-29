Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCE027CE8B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgI2NIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgI2NIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:08:18 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5E3207F7;
        Tue, 29 Sep 2020 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601384897;
        bh=3tjkPJUHk0vIdiTXJbTZpw9XJLLtbUTpZ9AOyj/v2Hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ue+pIGoAM5E6ivb80pRUpU1lHpqEqJGsps+RQhYHJR0xfmpJSVG7hQOuNUklrIwm+
         xTwteuQf8cRm4sC56cKU+9YqnLOrjUSHhp8tOcSeniHRMisssHSFvC+7sWLQZMlY0m
         1Nd+E8wTjDTZ7X2lzu2CuG65IVmUh2l8r7ICQGgI=
Date:   Tue, 29 Sep 2020 08:13:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Fix potential null pointer dereference
Message-ID: <20200929131357.GA28922@embeddedor>
References: <20200925164913.GA18472@embeddedor>
 <25336478fe5bca68b6c7d2c37766a9f98f6c7ad1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25336478fe5bca68b6c7d2c37766a9f98f6c7ad1.camel@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 04:22:33PM -0700, Saeed Mahameed wrote:
> On Fri, 2020-09-25 at 11:49 -0500, Gustavo A. R. Silva wrote:
> > Calls to kzalloc() and kvzalloc() should be null-checked
> > in order to avoid any potential failures. In this case,
> > a potential null pointer dereference.
> > 
> > Fix this by adding null checks for _parse_attr_ and _flow_
> > right after allocation.
> > 
> > Addresses-Coverity-ID: 1497154 ("Dereference before null check")
> > Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes
> > structure")
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> > 
> 
> Applied to net-next-mlx5.

Thank you both. :)
--
Gustavo
