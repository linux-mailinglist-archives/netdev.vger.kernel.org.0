Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41FC4AA63C
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379207AbiBED3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:29:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34234 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiBED3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:29:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 197C9B8398B;
        Sat,  5 Feb 2022 03:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5D6C340E8;
        Sat,  5 Feb 2022 03:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644031747;
        bh=96n4lk0fYCEUv5Djyt+ub2VQXb8EMCuxCr5QtGkGfy4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tOzc7oLGRtT0dplZA2phDPe9MhYUFjMgPy4pLRVk9p7Anw35w/IJYc0zVJw3AIBOc
         EsuaMcLqu6CgJsmCUXQ7adSxFOfryyxiAB7gP9sQ6cgpbjNHxsi45R7I/OkV2Ll5EP
         4gIDnF+Zh36D+lz2WtwkgrdHpoYjNwZXoqnkBVJ7TDFys037l0uhMwLDHAMQf/vSGq
         fnLz+WA84hbIlrDg8EgrAmMkdCz8X3R6wpLbZzWCiXmEgG7jRmhGKZqzolA4Zr1qaP
         9t/2fTmZAj7+EJbH4krj0vcktTe9EeCPha5+EryCvp7CpmK9cL9GwQUzmi2tsNpv8v
         0UEDzOYkuF9iQ==
Date:   Fri, 4 Feb 2022 19:29:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 net-next 00/10] net: dsa: microchip: DSA driver
 support for LAN937x switch
Message-ID: <20220204192906.15a0e6e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 23:14:50 +0530 Prasanna Vengateshan wrote:
> LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch  
> compliant with the IEEE 802.3bw-2015 specification. The device  
> provides 100 Mbit/s transmit and receive capability over a single 
> Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision 
> of KSZ series switch. This series of patches provide the DSA driver  
> support for Microchip LAN937X switch and it configures through  
> SPI interface. 

Please CC the driver's maintainer, woojung.huh@microchip.com on the next
version.
