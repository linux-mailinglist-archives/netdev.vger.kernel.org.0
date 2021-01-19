Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B852FC1B8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404192AbhASU4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbhASU4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F3F22CE3;
        Tue, 19 Jan 2021 20:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611089754;
        bh=ehM9/aWfc36BuvioXgfbLzzGCQsk1IJccnxxkvBqxs0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WhlHEDYq9hHU1BYJtwyB9Cf0qnncKUwUXVsHTbEWlyn33tX1HhCCCz0oN5BghsUGM
         0CLtDd0Trr/RrOSxDrVgyIx1z77y9nzw1neH1jsGoYI/MdM5lEaSa8jD+fz6E+ii7x
         AmwLq3WXgStR3ecDL/GOvILXlByHRlrKZg9sFeTbtDAXKKcIszltO7H7J8DTVNRQBr
         mfC9yGcARbf9sT/r9QAPjsvlWpT2NXzSchKNzapXlS84uCq0bO2KTr1pXmjfyUQW6Z
         GWlouct6jx4KpuSWhOXEFnWKdVTHLcjepwtfu88uuQZxrrcY0oKMoYgJK552s+86YP
         arWAbvHWV5YTw==
Date:   Tue, 19 Jan 2021 12:55:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] nexthop: Use a dedicated policy for
 nh_valid_dump_req()
Message-ID: <20210119125552.4815bc6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
References: <cover.1610978306.git.petrm@nvidia.org>
        <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 15:05:24 +0100 Petr Machata wrote:
> +	if (tb[NHA_GROUPS])
> +		*group_filter = true;
> +	if (tb[NHA_FDB])
> +		*fdb_filter = true;

nla_get_flag()
