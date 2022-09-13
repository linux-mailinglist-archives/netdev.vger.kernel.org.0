Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897725B7A72
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIMTDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiIMTCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:02:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A062384;
        Tue, 13 Sep 2022 12:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RK8HL1F3M1TdUKlkjzvVy3Mv1UGK5lskuBgs4dh2sRI=; b=0kyX9qxPF6heEV9PGyQXRhz4zt
        jwinzSE2M7041xLdAS2rgVJw+mXQcalx+8X+vy2yNXMP6rRZxotRtycGoEHhC6Ba68FGMoQUt6qZC
        0u8SOQuuq0OfoTNYyUm7zVaWihqfS4Mvwd8x5nywwqa7q6f9QRQesOwW8opQX+ZMfBcOjcLjgHRuh
        kBc3kbad56Ghn0c6fDUU7If1d9UkgFWuQC8acDoRBDJwi4LyjgOVyyBzhOY6yvGKRX48otdLgiHAi
        p2DZK+w+B1/dOH1QzDgo6GPuqzUSTlAYbhbGfbV0RWi61ehoV03wageHLD5Gs+Z4/NGCgf4RdpfB9
        b4E64dHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34304)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYBAK-0003QE-5E; Tue, 13 Sep 2022 20:01:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYBAJ-0000uI-Dm; Tue, 13 Sep 2022 20:01:47 +0100
Date:   Tue, 13 Sep 2022 20:01:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH 2/2] net: sfp: add quirk for FINISAR FTLF8536P4BCL SFP
 module
Message-ID: <YyDTmwSldZQCLoMb@shell.armlinux.org.uk>
References: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
 <20220913181009.13693-3-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913181009.13693-3-oleksandr.mazur@plvision.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 09:10:09PM +0300, Oleksandr Mazur wrote:
> The FINISAR FTLF8536P4BCL reports 25G & 100GBd SR in it's EEPROM,
> but supports only 1000base-X and 10000base-SR modes.
> 
> Add quirk to clear unsupported modes, and set only the ones that
> module actually supports: 1000base-X and 10000base-SR.

This description does not match what the patch is doing. I see no
modes being cleared.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
