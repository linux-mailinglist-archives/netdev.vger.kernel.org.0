Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBBD2983AC
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418885AbgJYVZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgJYVZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 17:25:30 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2FF20658;
        Sun, 25 Oct 2020 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603661129;
        bh=EtfW4/Iciuw0y2z/YPtc5vjqf9hs6Pu4OhIOe6bEKMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbSynMQQLj92/Wa16GNy+k84G1QlnFH4sIf4q3yOwGqt8Xz7rLrQmk3VkaC8coitv
         MgVpZKS0plHsGp4OQKn6irmEjwvE/hml52wsGdZqPlfqKsPvuDJ0PMMtEZLJchH4gK
         69cXUjvgnhV4dQkYemN0kW6Vi+wFSvQaBk1edq8E=
Date:   Sun, 25 Oct 2020 14:25:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>
Subject: Re: [PATCH v5] net: macb: add support for high speed interface
Message-ID: <20201025142528.6730a637@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1603538289-28057-1-git-send-email-pthombar@cadence.com>
References: <1603538289-28057-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Oct 2020 13:18:09 +0200 Parshuram Thombare wrote:
> This patch adds support for 10GBASE-R interface to the linux driver for
> Cadence's ethernet controller.
> This controller has separate MAC's and PCS'es for low and high speed paths.
> High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
> implementation. However, since it doesn't support auto negotiation, linux
> driver is modified to support 10GBASE-R instead of USXGMII. 
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
> Changes between v4 and v5:
> 1. Correctly programming MAC bits mac_config.
> 
> Changes between v3 and v4:
> 1. Adapted new phylink pcs_ops for low speed PCS.
> 2. Moved high speed MAC configuration from pcs_config
>    to mac_config.
> 
> Changes between v2 and v3:
> 1. Replace USXGMII interface by 10GBASE-R interface.
> 2. Adapted new phylink pcs_ops for high speed PCS.
> 3. Added pcs_get_state for high speed PCS.

# Form letter - net-next is closed

We have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
