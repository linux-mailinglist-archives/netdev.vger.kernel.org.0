Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810544685DA
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245292AbhLDPPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 10:15:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236002AbhLDPPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 10:15:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tk/UqSNzICTCyklEj06uzagFaWHZBnaPByLqiCpPEh8=; b=L61e0AiozsAIdFBUauvAEIiDbV
        uK0AgSSdx9G/n7kKFtPwWz3tjjtX3Wn3L47QxkJhL0R5pO43+C5QSD+LBQnWJea4pe6olZtfx4/q0
        dZhhTIR1DxD/TVXCUrurZF7y2hI5bH+ZTiJjfSM4/bE8BUrPMFFBJ/fQhMsT2AAdWyNA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mtWhe-00FVjc-2u; Sat, 04 Dec 2021 16:11:54 +0100
Date:   Sat, 4 Dec 2021 16:11:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <YauFOgy6tjH+kf3J@lunn.ch>
References: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 05:13:27PM +0800, Yinbo Zhu wrote:
> The do_mdio_entry was responsible for generating a phy alias configure
> that according to the phy driver's mdio_device_id, before apply this
> patch, which alias configure is like "alias mdio:000000010100000100001
> 1011101????", it doesn't match the phy_id of mdio_uevent, because of
> the phy_id was a hexadecimal digit and the mido uevent is consisit of
> phy_id with the char 'p', the uevent string is different from alias.
> Add this patch that mdio alias configure will can match mdio uevent.
> 
> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
> ---
> Change in v4:
> 		Add following explain information.

Adding an explanation will not stop the regression happening. You will
continue to get a NACK while your change causes a regression. Please
do not post again until you have addressed the regression.

   Andrew
