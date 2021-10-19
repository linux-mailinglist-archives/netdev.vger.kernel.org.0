Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6B7433651
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhJSMvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:51:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235717AbhJSMvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WL+AhJ29oQhp/ABSxCpfNEGXC6M38yZhnHP80vHki3U=; b=YIBORPbrg/8KLOQvRTkSCGmHfT
        OO6DKNUo9ditLnFIr5HbOTDqtWgtAR1OjDrsOy/vI6PnVfv5i25XMcyKHkKzkvGEcj8eYwtTHiwdY
        GptHrDVuoG7ahLYmm9sE4f7nUaSsoXWdugpmhz25wRjueviZwrU462F3NKYbba11LfLE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcoXv-00B4qW-96; Tue, 19 Oct 2021 14:48:47 +0200
Date:   Tue, 19 Oct 2021 14:48:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     kuba@kernel.org, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <YW6+r9u2a9k6wKF+@lunn.ch>
References: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 09:03:43AM +0300, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add firmware (FW) version 4.0 support for Marvell Prestera
> driver. This FW ABI will be compatible with future Prestera
> driver versions and features.
> 
> The previous FW support is dropped due to significant changes
> in FW ABI, thus this version of Prestera driver will not be
> compatible with previous FW versions.

So we are back to breaking any switch already deployed using the
driver with the older firmware. Bricks in broom closets, needing
physical access to fix them. Was nothing learnt from the upgrade from
v2 to v3 with its ABI breakage and keeping backwards support for one
version? Do you see other vendors making ABI breaking changes to there
firmware?

Why would anybody decide to use Marvell, when you can use Microchip
devices an avoid all these problems?

	Andrew
