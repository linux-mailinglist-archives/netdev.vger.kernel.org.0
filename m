Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307BE417E84
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbhIYAGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 20:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIYAGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 20:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C997610F7;
        Sat, 25 Sep 2021 00:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632528307;
        bh=PV0m8/mNhWOkqLynIUjRpnCW/bG3D80ZQ3VDxnH04pg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tOqzemfgl3T4JxRVmUTeZHMGI8pq8ThVAVZW9TBrKQ9da1lsg8invGwGVHLIqMHtT
         r6c7NfAOlCCS5KW1NBLDMDUCyR9MhWt+vThhpsfxYRRTXDW5Q2qdrrPj0ch0a4cW7U
         Hu9iUoqHiVLgAxgqH9FbXLxUXKm/7X+Aw/azF+B9aVSj1bqkEH4T+PlaHnOGYJT+dz
         c/TJYzHyvL8A0PNE+oowZdT370TB8toboVn3coHd4RxNSQh4mccD7Q2+4tHIeBXKWJ
         eFLyTbExAYaRJd11J+zmdlOWM6YwjSievIPgdhhjORrVY7r+f6F+IWENuieOOmRbON
         fKW6bEAgzjJkg==
Date:   Fri, 24 Sep 2021 17:05:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        =?UTF-8?B?UmFmYcWCIE1p?= =?UTF-8?B?xYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: Re: [PATCH net-next 3/5] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20210924170505.6e62e32f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
        <1632519891-26510-4-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 14:44:49 -0700 Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Please clean up checkpatch --strict and make W=1 C=1 build 
of the new driver.
