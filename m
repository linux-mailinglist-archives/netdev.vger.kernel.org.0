Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1570516443
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiEALsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiEALsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:48:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D3565A2
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a0lEKeiNsASy6i76fZ5RSWOTdeDDX5s1xtOar6mCLag=; b=jI23rePGtqNLCUJVSGB51ZuY8L
        Lb1hIZcV4DsZ+fGVJKgu74gkz0JBrAlvyQ8Ga167b+FSYyG5COL4ltECD0WB74/bis3qAtYj+61U+
        bODM9+iFNCdPMfC6RV9BV3YXmBu98z0WAwSdSeL5ITD/TtsLpSLiz4L7e8szN3fBov9oz0K5OiyMU
        hNjbK59Q79JLdcINho/SO2LA9pDTZlbPPPUHNXZOri/QPdQCMMv2OXVEGkjGx7g/cHQvDRMCMc1qg
        fov/6wYJhHiym47vgvlykI2/+opd9coxmSZd78gJj8pXAKpHNAg4ZI/x/ancnjPGxyBsTt9lliANZ
        9vKjzvhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58480)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nl80G-0006EU-MI; Sun, 01 May 2022 12:44:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nl80F-0003si-GV; Sun, 01 May 2022 12:44:39 +0100
Date:   Sun, 1 May 2022 12:44:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marcin Wojtas <mw@semihalf.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Message-ID: <Ym5yp9Xt094ckexX@shell.armlinux.org.uk>
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
 <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
 <87czh1yn4x.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czh1yn4x.fsf@tarshish>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please trim so I don't have to waste my vital limited power reading
paging through lots of unnecessary text. Thanks.

On Thu, Apr 28, 2022 at 11:03:08PM +0300, Baruch Siach wrote:
> mv88x3310 f212a600.mdio-mii:02: Firmware version 0.3.10.0
> 
> This is a timing sensitive issue. Slight change in firmware code might
> be significant.

That should be new enough to avoid the firmware problem - and it seems
that 0.3.10.0 works fine on the Macchiatobin DS.

> One more detail that might be important is that the PHY firmware is
> loaded at run-time using this patch (rebased):
> 
>   https://lore.kernel.org/all/13177f5abf60215fb9c5c4251e6f487e4d0d7ff0.1587967848.git.baruch@tkos.co.il/

Hmm, I wonder what difference that makes...

Can you confirm the md5sum of your firmware please?
95180414ba23f2c7c2fabd377fb4c1df ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
