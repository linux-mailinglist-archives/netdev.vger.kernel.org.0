Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD54E4997
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 00:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238828AbiCVXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 19:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiCVXQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 19:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934212655A;
        Tue, 22 Mar 2022 16:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A44761142;
        Tue, 22 Mar 2022 23:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097FEC340ED;
        Tue, 22 Mar 2022 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647990907;
        bh=pBrqpyLtYd4UIYjhiSpOvd/QUc5BWeFThh4yI2ezz8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lx56S2c8R7VXgElUlzYFgMyufCqxevzyQ0sDb7jP7soNXWhdXSw3LPaqbdHLxbU7w
         P28FnLnbXBJ4+ZNcfffqJTsR7iGflexpC8FGV3/eGMMadQ6/ZAQjZirCwF2Cxrt9AD
         1gnz9BvhZM2Cz9obG31UYnTL4+ASJWShmfXnk+snUJ+bqp44KWidsanyQ1TCT9ClTa
         Bu5FVDcHSNBIrLS5BdVXlKpDpsuFaSCrwHxO/TaLrzjLGv3L0Sa3ayG4A8v/M1mW1S
         cTYWaKyfMQ95LYw8sr6rHUcRytP2vflxcHrUKe3ZbXKH6e9qnz7OsBL6BTOyfsB5OK
         KN9lykvUQ0vsg==
Date:   Tue, 22 Mar 2022 16:15:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>,
        <pabeni@redhat.com>
Subject: Re: [PATCH v10 net-next 00/10] net: dsa: microchip: DSA driver
 support for LAN937x switch
Message-ID: <20220322161506.252e008c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
References: <20220322195455.703921-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 01:24:45 +0530 Prasanna Vengateshan wrote:
> LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch  
> compliant with the IEEE 802.3bw-2015 specification. The device  
> provides 100 Mbit/s transmit and receive capability over a single 
> Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision 
> of KSZ series switch. This series of patches provide the DSA driver  
> support for Microchip LAN937X switch and it configures through  
> SPI interface. 
> 
> This driver shares some of the functions from KSZ common 
> layer. 

net-next is closed during the merge window. You can continue code review
by posing RFC patches but you'll have to repost for merging once
5.18-rc1 has been tagged.
