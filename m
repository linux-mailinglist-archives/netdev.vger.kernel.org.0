Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E50C46E0CF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhLICUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhLICUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:20:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC25C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 18:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0F51B8236F
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E030C00446;
        Thu,  9 Dec 2021 02:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639016234;
        bh=VIzsgzZCTsd+Gwmw3lvRgRRG0Zclu8RGaTxiuMrehvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AaQ9isjJYw48jOmg4BfkEpmXxITLzJZoJedS2MBfONIdfmW/rhF/1or+K18VmxXu+
         pHqlD3UTBrNFZ8nDfq8TLANKUSba9HRz4YbaEHyUXEJovrkqkDm6Qmv9PtEasKZuLs
         NUBAFDWCn1Y0eJDzX+N3R5wtoIbddV+d4ubPKqLiaLMlZzJZ+tYwob80JzvNuj0nU3
         eP4naqqHWTPN+D+V8e8b0iOnZTawAChqy9i9F026hvydWv4mu1FvXBmmfD/ZI74zEf
         OKmmfYl7zGmgW/DTkrPnTGWLk6xFhn4j1yz6PH7zMYLE2MdmX0x01XwJwLNOFNS0x9
         3k4MddGxw/ugw==
Date:   Wed, 8 Dec 2021 18:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <davem@davemloft.net>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/6] net: lan966x: Add switchdev and vlan
 support
Message-ID: <20211208181712.37c41155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
References: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 13:48:32 +0100 Horatiu Vultur wrote:
> This patch series extends lan966x with switchdev and vlan support.
> The first patches just adds new registers and extend the MAC table to
> handle the interrupts when a new address is learn/forget.
> The last 2 patches adds the vlan and the switchdev support.

Anyone willing to venture a review?
