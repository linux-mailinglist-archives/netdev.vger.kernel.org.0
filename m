Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FC2DA478
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgLNX66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 18:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbgLNX64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 18:58:56 -0500
Date:   Mon, 14 Dec 2020 15:58:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607990295;
        bh=u5+5HPnS2qf72zZwmoJnAF3jnFpn+3XxHpCoeEORnXM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ROAl7hNc6db8ULHch2mfg9J8DSGFIl55HH+k7uTRkvOxND4kCF6RPrtTWwbgBeF22
         bSo0mtxevRNpQ0zQaDNn42hkdsUnglwJTo3vjISUgdqcm9HzMMj/4RSwkieWZcd1hw
         /nehTKca8g5JdwJt3gVPaW82ICKQYG36spApmTdc4UklvK0xlHOpaW85hTAiY5GRan
         8pPmQAzQtPPSF1JjBBr/UwIU1Q8jvWVaMaAtci9ecCcDIwRkJPIzCRPnw4YkdIQNRd
         xyauQVIIZr/VQT0D5qXHxAi8WmZfX5GQRBNYJ83anSM7HM21Fp9s1ZZdABKzvjageG
         NeA/uXCJbd+XQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasyl Gomonovych <gomonovych@gmail.com>
Cc:     tariqt@nvidia.com, joe@perches.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
Message-ID: <20201214155814.03ac9925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214103008.14783-1-gomonovych@gmail.com>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201214103008.14783-1-gomonovych@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 11:30:08 +0100 Vasyl Gomonovych wrote:
> It is fix for semantic patch warning available in
> scripts/coccinelle/misc/boolinit.cocci
> Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
> 
> Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>

Looks like it doesn't apply to net-next, please respin based on:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
