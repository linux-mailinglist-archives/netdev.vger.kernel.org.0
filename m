Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF8C45D38F
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhKYDWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346430AbhKYDUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:20:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4249460234;
        Thu, 25 Nov 2021 03:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637810262;
        bh=/eqF4lIxc2rV7wwWPFPONu8gGqSyQi3U1Rx7DHBuAfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=grU6xoucVGAPIwekmCvSsIl1tr6ZfmHZU2gX71QnZrMw7X3JBJitH/+oNBP3uuhY2
         IYfYfKYVHyXJxp+hoBo8Z2jvojVHT87llSXfOLL3PAKsZq0w1VmYBKkUpqsKgf5Oxr
         mHtwmqe5JAlhOrK6lHzsyjl8ssIzBWqnEU+/8hv2qZ7HQmhSUglOBgvsU14xNTo8Dz
         53aCqadK3fPOmu5w/ySK2/UZhSsbtfUXWqkvJM5zrt5Qd9df3jFZDgCCz2IIhU0Col
         igazJwlI+RnPupWMuFShmLFlVYW5stidkuUyNHmPmqKDa6zFkqY7PgcfSJggxhjwYA
         zJgP6Wfhr+Q1w==
Date:   Wed, 24 Nov 2021 19:17:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH net-next 1/3] net: prestera: acl: migrate to new vTCAM
 api
Message-ID: <20211124191741.3cc944b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1637686684-2492-2-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
        <1637686684-2492-2-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 18:58:00 +0200 Volodymyr Mytnyk wrote:
> +static inline bool
> +prestera_flow_block_is_bound(const struct prestera_flow_block *block)
> +{
> +	return block->ruleset_zero;
> +}

No static inlines in C sources, let the compiler decide.

Please fix all cases.
