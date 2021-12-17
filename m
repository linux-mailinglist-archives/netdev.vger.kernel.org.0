Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521F947918F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbhLQQhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhLQQhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:37:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EBC061574;
        Fri, 17 Dec 2021 08:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04E36622DF;
        Fri, 17 Dec 2021 16:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7334C36AE1;
        Fri, 17 Dec 2021 16:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639759024;
        bh=3rsyDCxNqdZyZChLpYmmoZG8EklORqGHB9si1FmurpQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hem3G+6EDTxfoNqwnZfrgdhEH76jv6xY68F81p69xUVNDe6LscSwsADwGo+Ful/MZ
         Sn5HCdzGOhvr0CBPhFx4QtlNvJ7nk6MWFwL72Noa+38vhwGSZfe9hUc5ieHOV3KcXA
         Y81qNXWzShOBrrwimntpKDXeQ2kxH+08kAxmQwfmHo3sSNdcbNHPQS9ootwhB4cCvn
         ooJ9y20kBYyXEdSZQDABVBhgZTRvndE35sLwPRWInv0i60YWfKZAEl2TCNev75AO+y
         S8K1l7Sp9tmZYXK5AQ0rnRfE2bA5xlPElh+AGGsr5ctlJ9RyVWNTrPXeY75qaJS4X/
         yP3pkIz4xVtZw==
Date:   Fri, 17 Dec 2021 08:37:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>
Subject: Re: [PATCH net-next v6 0/9] net: lan966x: Add switchdev and vlan
 support
Message-ID: <20211217083702.54dadf3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211217121017.282481-1-horatiu.vultur@microchip.com>
References: <20211217121017.282481-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 13:10:08 +0100 Horatiu Vultur wrote:
> This patch series extends lan966x with switchdev and vlan support.
> The first patches just adds new registers and extend the MAC table to
> handle the interrupts when a new address is learn/forget.

Breaks allmodconfig build now.
