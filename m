Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183FF2A9DA1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 20:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgKFTMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 14:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgKFTMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 14:12:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D87B20882;
        Fri,  6 Nov 2020 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604689942;
        bh=jnT/1M/2OIZHrKtNfTZKIlQYDFtjEd8yQ76ovoBUrrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gNnxR0R002tfx6WejXiyre3s0wEPd+VFkE8NraYTIGX6Wft9MNDPtVfOhBbSq9ASD
         oZBna4Dv0kAEKurRYjB3kvuJzmQOup80Kp8LemSkmwB7qnFGOmBPBY6bkZfZTWkO87
         DRV1ht+C9D6MizHnUB2UxYLBkA3vsllBnuqk4OX8=
Date:   Fri, 6 Nov 2020 11:12:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/18] rtnetlink: Add RTNH_F_TRAP flag
Message-ID: <20201106111221.06e16716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104133040.1125369-6-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
        <20201104133040.1125369-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 15:30:27 +0200 Ido Schimmel wrote:
>  	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
>  	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
>  		*flags |= RTNH_F_OFFLOAD;
> +	if (nhc->nhc_flags & RTNH_F_TRAP)
> +		*flags |= RTNH_F_TRAP;

Out of curiosity - why use this if construct like OFFLOAD rather than
the more concise mask like ONLINK does? In fact looks like the mask
could just be extended there instead?
