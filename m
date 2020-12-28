Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93312E6C69
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgL1Wzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgL1Ujr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 15:39:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC7C5222B3;
        Mon, 28 Dec 2020 20:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609187947;
        bh=VTWjReRS4Z3OBvORpv7OORcjw+MCvDX/NCFz7CoDXW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y23hlb09w0/oRIEHJpjilrTMMORnC6qmkyLC4jxkcp6YcWlpxOUcGVUOfwaKeiBl1
         wUCLoLHUkWmbutS2FWw4qGTiLqMeOmyQBIQeXsL/8yAZUDdpCgYACLTW2hP1kHmds8
         PZW/BaxOTU4C3glzebGFNSLrC/+mdG8urrFXmMX5QijMPTtp8ipFDf0pXw5JGh/6Az
         cw2cnfnEVpI7vyYDn5FLTOc67Vry3Np6zEjbWg/C/I+RoK0YH4elaiZiv7niS54D8s
         Lcvog+wj+cE3FpGejE1ZCExsqoA/hYzN8rPYsKD/6NbzjKfT1ZV1A/s0etGcfALlBZ
         ycmM9nBREEkgg==
Date:   Mon, 28 Dec 2020 12:39:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] bcm63xx_enet: major makeover of driver
Message-ID: <20201228123906.69b929e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 22:24:15 +0800 Sieng Piaw Liew wrote:
> This patch series aim to improve the bcm63xx_enet driver by integrating the
> latest networking features, i.e. batched rx processing, BQL, build_skb, etc.
> 
> The newer enetsw SoCs are found to be able to do unaligned rx DMA by adding
> NET_IP_ALIGN padding which, combined with these patches, improved packet
> processing performance by ~50% on BCM6328.
> 
> Older non-enetsw SoCs still benefit mainly from rx batching. Performance
> improvement of ~30% is observed on BCM6333.
> 
> The BCM63xx SoCs are designed for routers. As such, having BQL is beneficial
> as well as trivial to add.

Hopefully we can get some reviews now, but for inclusion in the tree
you'll need to repost once net-next opens (should happen in the next
few days):

http://vger.kernel.org/~davem/net-next.html
