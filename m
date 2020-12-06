Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452BA2CFFE6
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLFAQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:16:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgLFAQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 19:16:42 -0500
Date:   Sat, 5 Dec 2020 16:15:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607213761;
        bh=V3AMJr6e21BhxDmdXK9ouQFiTqIuQi8cALP2iAJnfDM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqzfQKvk/OYU0dDv48GiQdTpJwxYpTk3RA5s+GIYgBeeAgEPAXcOoF7iyLkCwDdmu
         1zs19S3rYUA5gy3bq74kj+Q59Xsbo5+Qt91xZEBeJfKzAlqOD+27Ne4LJpDcKAzhRF
         253Nzjq8kMd/wa6ZF60J90G1O3tKXJ0l3ud06hgUGH6OIpa/rrhtnAsgANKIkSdEbN
         yUzZwYNOzFm2fkVHWgSP1jUG36YPEOxIZBrypdEl/qxfoIarmhtTSDi1/b9QRSOZ2s
         KJvVtSj1s4aj77OJVg/G76nQR+vrn5PU1OczY7ZZorC7qhU+6BTXgTMJXXN7BSbOeO
         CBHe05cccjGig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V4 net-next 7/9] net: ena: introduce XDP redirect
 implementation
Message-ID: <20201205161559.3c817842@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607083875-32134-8-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
        <1607083875-32134-8-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 14:11:13 +0200 akiyano@amazon.com wrote:
> +	case XDP_REDIRECT:
> +		xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> +		xdp_stat = &rx_ring->rx_stats.xdp_redirect;
> +		break;

Don't you have to check if xdp_do_redirect() returned an error or not?

You should CC XDP maintainers on the XDP patches.
