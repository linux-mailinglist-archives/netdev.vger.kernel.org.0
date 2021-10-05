Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C258F422727
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhJEM5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:57:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhJEM5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r1inBQbntbFbZTvWjjIjZyUyCCR8WjN2IDFyJuNjN/w=; b=SVq79QN9PPO1mtbvKNrRv4kKrL
        MczaPdOLvC8gI/tPisXqYVsOQbgkYSmdKmTaQOMaF5Qe3XHjWVL9TiyWP92hdr4arm7boou8rYYXL
        lmjL96wTW0qgZrqO5bKwCK+GJD4NHrrjCC+8uo/8KXWKDhzZnMLjR6FOW4dxQogxwkik=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXjyi-009h06-CS; Tue, 05 Oct 2021 14:55:28 +0200
Date:   Tue, 5 Oct 2021 14:55:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v1 2/4] ARM: mvebu_v7_defconfig: enable mtd physmap
Message-ID: <YVxLQCztl+/ZBTuG@lunn.ch>
References: <20211005060334.203818-1-marcel@ziswiler.com>
 <20211005060334.203818-3-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005060334.203818-3-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:03:32AM +0200, Marcel Ziswiler wrote:
> Enable CONFIG_MTD_PHYSMAP which is nowadays required for
> CONFIG_MTD_PHYSMAP_OF.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
