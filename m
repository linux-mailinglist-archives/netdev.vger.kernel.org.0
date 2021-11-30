Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED7463A79
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhK3PrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:47:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50488 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhK3PrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:47:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8420DCE1A48
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BDDC53FC1;
        Tue, 30 Nov 2021 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638287028;
        bh=4pIR7O2oXR7SyIEa9rM6Wp0FRuDxYRnQ+HyU9kPdp5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nqxx14/VK4zAUb7pkAYC39uvZXxXpCM0PgbH0FqVkqw8yPlsmI+ORnzh9iebosu7R
         FYEJE+R1HPT/X2pIem+h+XIb4gm0Ek2Gmh7bq44wDR8cddjFAOFKizfwrR5HqLycyi
         9BodJcZW8PEl3zu/20MjuEMBPbDxGE+BKXsIzDw6wGTIK6I45ARofipyJyhReD1boR
         KcU53/xDaxRL73EpWs9uyPM9mEZ/ej5xwBL1GjeKfmRX+uKmIs2EHLTpuaqXlxfxf2
         iXhsTIFgK1C0wWY12zokFampvwD/GYJZngP7PUODwx+z9vhZRtzkMC2oCQe5r8W49+
         JShf+EiH1P/kg==
Date:   Tue, 30 Nov 2021 16:43:43 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 3/5] net: dsa: support use of
 phylink_generic_validate()
Message-ID: <20211130164343.18a89a96@thinkpad>
In-Reply-To: <E1ms2ta-00ECJH-6c@rmk-PC.armlinux.org.uk>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
        <E1ms2ta-00ECJH-6c@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 13:10:06 +0000
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Support the use of phylink_generic_validate() when there is no
> phylink_validate method given in the DSA switch operations and
> mac_capabilities have been set in the phylink_config structure by the
> DSA switch driver.
>=20
> This gives DSA switch drivers the option to use this if they provide
> the supported_interfaces and mac_capabilities, while still giving them
> an option to override the default implementation if necessary.
>=20
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
