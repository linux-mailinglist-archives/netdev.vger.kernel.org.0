Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7485F3018
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJCMTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJCMTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:19:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2435238466
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HPqhoDmxKDeuqJnMS8oEBO9hVnvYDCP4vLsSwyLI12Y=; b=r/aWuVXkW9vsXRUtvEnF6n82gg
        PiX8OCtP2W4TX40+cX6CfXmxu/IDunJxdJzX/Y0G5G938sO53rqO9SQrf8LuZX5WyE/Mle3pr9UrN
        TNktGTroyD7WyH+BK9cXrpKFNXTrJpHd+n06fXlQ6C8tMpBlUpOF4d+sFHmTMB1Qo7/8kCL8PmoN9
        jSSHaqHYSHca37xOptZOQtQSmGsSCRifkFoooDb72uE+o59j2QbHnYvYtQJll7s0L/7E964DBix25
        xnFuRWfSBHkLwZY6euKnufFlwxrj/9olNsALda/YbXOy2XYMBnoXtRKyCY88HnE4HmSgqSKBFd3Pp
        H/iyK1vw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34564)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ofKPO-00075j-LJ; Mon, 03 Oct 2022 13:18:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ofKPL-0003PZ-SR; Mon, 03 Oct 2022 13:18:51 +0100
Date:   Mon, 3 Oct 2022 13:18:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
Message-ID: <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch>
 <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch>
 <20220930074546.0873af1d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930074546.0873af1d@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 07:45:46AM -0700, Jakub Kicinski wrote:
> Actually maybe there's something in DMTF, does PLDM have standard image
> format? Adding Jake. Not sure if PHYs would use it tho :S 

DMTF? PLDM?

> What's the interface that the PHY FW exposes? Ben H was of the opinion
> that we should just expose the raw mtd devices.. just saying..

Not all PHYs provide raw access to the firmware memory to the host; in
some cases, firmware memory access needs the PHY to be shutdown, and
programs loaded into the PHY to provide a "bridge" to program the
external firmware memory. I'm thinking about 88x3310 here - effectively
there it's write-only access via an intermediate program on the PHY,
and there's things like checksums etc.

So, exposing everything as a MTD sounds like a solution, but not all
PHYs provide such access. IMHO, if we say "everything must provide a
MTD" then we're boxing ourselves into a corner.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
