Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC0045D13E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhKXXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234177AbhKXXdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:33:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3004A60F55;
        Wed, 24 Nov 2021 23:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796643;
        bh=DxCqlQ+PoiA3QcJG5He3IJe+Kxv7xSxe+Xw210sQzLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PhodRkdh7DMAbGdeIweJgBiONkJCN7Qe6O39enhhUkX5HJZ4QQjmBZq0iyyejDWvA
         9HwuL7VAlhjWyRcgN9D3m4OE5keHOBASONtRpaDzVT5eOoEU3W/111ClA18j4vLzLl
         IkTtXKqcnkjLX3E191RxVxgsyCgsPIzIdVg6groO1ohyB/x/Wv55OfRKvT3hXaR96A
         penOf/4rmItfC3Doe06vOWX+ClBEn7w8qx/BaEKqZadRYjVsI50jJlPcUFhs2rgD2M
         iHuh7pJNaNnzsGB4GdHGUQ2x9EQXhn+7vdEvjwgfQxZtDQ37OfWvYrrlL2zny9ZNV3
         w1HyvEsYb6T9A==
Date:   Wed, 24 Nov 2021 15:30:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-aspeed@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@aj.id.au>, <joel@jms.id.au>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH] net:phy: Fix "Link is Down" issue
Message-ID: <20211124153042.54d164dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 14:10:57 +0800 Dylan Hung wrote:
> Subject: [PATCH] net:phy: Fix "Link is Down" issue

Since there will be v2, please also add a space between net: and phy:.
