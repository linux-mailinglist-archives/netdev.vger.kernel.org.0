Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFA43E8C5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJ1TIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 15:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhJ1TH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 15:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6BC60F38;
        Thu, 28 Oct 2021 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635447932;
        bh=jqN5CJSNCjfWPZWoiwK5QywvlV0nHRyIzylfePgq9kA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ikD1WZptNVr8h4YQPUV/rQdI8wZ3V/6ZuPPmvsGlP4vsvX/gjvNLAAVCiQjdLXwal
         IHZHHlNnLGmg/slU2TdhFsYJEybxigsZO8xsb2+KPu/j6lt7uQdHs1Ph2cUPxA5aK1
         KD56BXRE7IdxEhrjrtdmz0E9LVxRrupcV5FHL6C1wbtsoQ6PE58FgoG8E7VHhNBnsG
         m7PaKxcKDkoA9ZHhEw3s3ylibQe7GheieU9iE40NawOxrQxLLi06Dwa2eg8FGs9+yl
         WON0e3p7tfE+fwdPUQtRGjIL4S3jyQXyu4n5ldHQNpglkPpYOPJOXbZ+vaZLn/Sk1X
         4Lk0T9RqnYBqA==
Date:   Thu, 28 Oct 2021 12:05:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 net-next 00/10] net: dsa: microchip: DSA driver
 support for LAN937x switch
Message-ID: <20211028120531.5fd5a599@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 22:11:01 +0530 Prasanna Vengateshan wrote:
> LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch  
> compliant with the IEEE 802.3bw-2015 specification. The device  
> provides 100 Mbit/s transmit and receive capability over a single 
> Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision 
> of KSZ series switch. This series of patches provide the DSA driver  
> support for Microchip LAN937X switch and it configures through  
> SPI interface. 

Doesn't apply cleanly after 788050256c41 ("net: phy: microchip_t1: add
cable test support for lan87xx phy") got merged. You'll need to rebase.
