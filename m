Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773934182B2
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbhIYO1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 10:27:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233738AbhIYO1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 10:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GIoIFS8oysAVK606odyYm+NnfqhL/RtH/bn53TX3cfE=; b=HjJrUTCk9nfyUdYrqlQER55LNl
        bK2GVwXRCiVF31kumJrOs6gqHBB9/PeEy7NrtM+93p77z4KxBGYzcZd/+ztTlel9UkRm55pZnVzod
        d1irtnX0sGeuaFuLvHsE/w3/uvC0CvWl/pLbFP+c5opalejgRY1E0Vk3jnwAMDD0NweU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mU8cR-008DSx-Pv; Sat, 25 Sep 2021 16:25:35 +0200
Date:   Sat, 25 Sep 2021 16:25:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH net-next 0/5] brcm ASP 2.0 Ethernet controller
Message-ID: <YU8xX0fUWAoEnmRR@lunn.ch>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 02:44:46PM -0700, Justin Chen wrote:
> This patch set adds support for Broadcom's ASP 2.0 Ethernet controller.


Hi Justin

Does the hardware support L2 switching between the two ports? I'm just
wondering if later this is going to be modified into a switchdev
driver?

	Andrew
