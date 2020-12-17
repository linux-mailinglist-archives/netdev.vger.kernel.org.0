Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB472DD6A2
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgLQRzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgLQRze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 12:55:34 -0500
Date:   Thu, 17 Dec 2020 09:54:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608227694;
        bh=0mW1wzMW7BB2MsUlXOLx9yg02heq+dhR7hgUdwhHH8w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBkgCx7yvO0bHnONKARbJ7GiQfmqTSVXBoBbsCsc4EiX9Z8au0OEG6Oqd52dror1U
         Tw6OBebaKygU1+7a60r6LMb+v1zmq2rJOL43c5KL844RnPFrgX71p+Nkumim3HPo47
         2goMSyn5RG+th27xA6hjCWuVy1vR4c5DOQzXfVz31x/qhnitxtZkGsJfz4xVdnlkfM
         84k3QlgCDL8nC+6MIbgWxqC6XmZ7fv69V+jnKpPGNyjnInCPF7qXq/M7m0RCTWjQEn
         p6kRYzdyuZDf6IU3Swee/EYsIk3fYf6h6W6uytUgds81+C6TnrLXURgt7m/evaYJU7
         Uc83oz5kksjrQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] Support setting lanes via ethtool
Message-ID: <20201217095453.00a919c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201217085717.4081793-1-danieller@mellanox.com>
References: <20201217085717.4081793-1-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 10:57:10 +0200 Danielle Ratson wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> Some speeds can be achieved with different number of lanes. For example,
> 100Gbps can be achieved using two lanes of 50Gbps or four lanes of
> 25Gbps. This patch set adds a new selector that allows ethtool to
> advertise link modes according to their number of lanes and also force a
> specific number of lanes when autonegotiation is off.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
