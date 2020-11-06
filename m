Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38C42A8CF7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 03:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgKFCc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 21:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgKFCc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 21:32:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58252075A;
        Fri,  6 Nov 2020 02:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604629975;
        bh=thdbS7abPuEJeJJKUg4NsgGJNqB+SjBm48UpesNADk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dyz+TMBQ+QVLjI/xJNmh2mY04YmUVyjCawVQ/rv++L2mPsjwHTpYh+WrwDREmVCOP
         Dq+3iAGxKDTKwhaU1d6fTbZAKpeuI1KumHD5L7buhyNYnWoZPkl74/Apuy7zRX8hmF
         paD+3nDTnQhwU0kpaZX8EUpZRLmI9pvKrCLAS4WA=
Date:   Thu, 5 Nov 2020 18:32:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [pull request][net-next v2 00/12] mlx5 updates 2020-11-03
Message-ID: <20201105183254.00dee895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 12:12:30 -0800 Saeed Mahameed wrote:
> This series makes some updates to mlx5 software steering.
> and some other misc trivial changes.
> 
> v1->v2:
>    - use %zu for size_t printk in patch 9.
> 
> For more information please see tag log below.
> 
> For the DR memory buddy allocator series, Yevgeny has updated
> the implementation according to Dave's request [1] and got rid of
> the bit array optimization and moved back to standard buddy
> allocator implementation.
> 
> [1] https://patchwork.ozlabs.org/project/netdev/patch/20200925193809.463047-2-saeed@kernel.org/
> 
> Please pull and let me know if there is any problem.

Pulled, thanks!
