Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4E60FABF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbiJ0Oqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiJ0Oqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:46:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B801201A2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ccjk+Pf7OhKNvA92ZlBnbYUhmw4paMdL7ZYT5TAKiKg=; b=BMZ4Yz8HAJWJWD/PqgYVf5Cfn9
        kJ1SYIkEoJMoSsXXNTIWAXwWFOuLkaCTZR9vKhAlYdvt8PPqQtSDqTDeoEGQUviSVP5V2w3Hf/eMn
        Rl1p7RybQKSWSYTL0hoILxYyVU8GCRWkHtY22sWmCRWYx4dc8ioLJm7vLcQl7t77AtQMYeHUsATi+
        TH3OQVSRMhwrmpVojdNdO+PbBArAp2JWjcq11qnfzpd64u9495YrIrLryVw4/cyqaSZ7flnoaxsPr
        zXxUqB8DRK76jE94jNMpuOBU7V9UHi/bpCaAgJYsChSo0WI4/3KAwjR9+X2QsGUMA1KyAv+993Vsk
        TBBi3m0A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34976)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oo49K-0007AL-AW; Thu, 27 Oct 2022 15:46:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oo49I-0001db-Hp; Thu, 27 Oct 2022 15:46:24 +0100
Date:   Thu, 27 Oct 2022 15:46:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: sfp: convert register indexes from hex
 to decimal
Message-ID: <Y1qZwF4OB96WK1ye@shell.armlinux.org.uk>
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
 <E1oo2ou-00HFJg-6q@rmk-PC.armlinux.org.uk>
 <Y1qY+nwr4SzmyhhD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1qY+nwr4SzmyhhD@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 04:43:06PM +0200, Andrew Lunn wrote:
> On Thu, Oct 27, 2022 at 02:21:16PM +0100, Russell King (Oracle) wrote:
> > The register indexes in the standards are in decimal rather than hex,
> > so lets specify them in decimal in the header file so we can easily
> > cross-reference without converting between hex and decimal.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Makes sense, but i've not checked for typos. Did you see if the
> generated code remains identical?

I did and it does remain identical.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
