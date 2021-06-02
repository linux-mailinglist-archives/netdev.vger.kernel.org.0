Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27D4399104
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFBRBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230440AbhFBRBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 13:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6036D61C4F;
        Wed,  2 Jun 2021 16:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622653175;
        bh=/DlKQAn9jgZNeqiph2JGkn0Eaxg3/yb4+PhBtaYi4Yo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L2XZI0boSfiZ+mEzdavJ+DkI9BHS7uWRMHlhlo4vNArqNpV0D+Vlfdh6Y7WdCsRe6
         ccG29GMRPVBrTwDZ5iu3FHbnXKIxqWCqYOL0EAxW6Fn3nESa759VLP5FXWnUV95QPq
         Az+ZW4AwjIffRNlAOqW2dhtJGBaVGVgwnLoCPiANkr/30dCa3AW4Qu056GWW+OTiGG
         qXtVlt0e1jTWLQW51X8LGUniKZizGzYffbMeDWF+R406A8QEZ+eHf1gR2hlPxKKY/+
         1JJgtzddBTjkcFJYcg3+l4sq2hfDFJ2nDMnDjaJ6hjoEwkTesZA/W8OjxXP3mKoYrI
         D4KmoFM1Khiow==
Date:   Wed, 2 Jun 2021 09:59:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next v3 0/8] Introduce conntrack offloading to the
 nfp driver
Message-ID: <20210602095934.7ba62812@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
References: <20210602115952.17591-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Jun 2021 13:59:44 +0200 Simon Horman wrote:
> This is the first in a series of patches to offload conntrack
> to the nfp. The approach followed is to flatten out three
> different flow rules into a single offloaded flow. The three
> different flows are:
> 
> 1) The rule sending the packet to conntrack (pre_ct)
> 2) The rule matching on +trk+est after a packet has been through
>    conntrack. (post_ct)
> 3) The rule received via callback from the netfilter (nft)
> 
> In order to offload a flow we need a combination of all three flows, but
> they could be added/deleted at different times and in different order.

Acked-by: Jakub Kicinski <kuba@kernel.org>
