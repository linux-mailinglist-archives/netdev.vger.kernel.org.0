Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032DD48EE07
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiANQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243235AbiANQXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:23:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C8FC061574;
        Fri, 14 Jan 2022 08:23:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22FAE61F87;
        Fri, 14 Jan 2022 16:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75BDC36AE5;
        Fri, 14 Jan 2022 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642177390;
        bh=8EEtbq135Y0w2OjVUTuJBP80ewEFZkVxYRnAxWNG0eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G+MoEykL1Bzcf4w4AmXD+dX82/JB8pi55zC1aY+51movMZJ+fQNkqDJiNVLBeqaXK
         66h8mj10pJnEMsA6EcLsz7bK+9zrJr73Aknmr80Wk5g5sbyfRb+cbAIbZdEgLdqNWH
         3sgBSDZteg/GXq5TSfGLXRb/cimeHMgq17JkgyCsrAGc/fW4IMm5IjXknUz97qp1K/
         JQEW+Kpy21DFQOGvcGI7kypMT707B7HmAfLHT+lmSdicfoXklTmnuY2hgT+6OsaZOV
         bUZ69y/0FBYanLA3SOuetWFb6qZv7vva5S9whhT5I3vqFJheVnSKeItWWBiWkAE4WW
         BjIFhvUDzN1HQ==
Date:   Fri, 14 Jan 2022 08:23:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
Message-ID: <20220114082308.76a5cca5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAAd53p6rW7PcugY7okKsXybK2O=pS8qAhctMzsa-MEgJrKhEdg@mail.gmail.com>
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
        <20220114040755.1314349-2-kai.heng.feng@canonical.com>
        <20220113203523.310e13d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAAd53p6rW7PcugY7okKsXybK2O=pS8qAhctMzsa-MEgJrKhEdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 14:47:47 +0800 Kai-Heng Feng wrote:
> > Coincidentally the first Marvell flag appears dead, nobody sets it:
> >
> > $ git grep MARVELL_PHY_M1145_FLAGS_RESISTANCE
> > drivers/net/phy/marvell.c:      if (phydev->dev_flags & MARVELL_PHY_M1145_FLAGS_RESISTANCE) {
> > include/linux/marvell_phy.h:#define MARVELL_PHY_M1145_FLAGS_RESISTANCE  0x00000001
> > $
> >
> > unless it's read from DT under different name or something.  
> 
> It was introduced by 95d21ff4c645 without any user. Should we keep it?

Not unless someone explains that it's actually used somehow.

Please post a patch once net-next opens.
