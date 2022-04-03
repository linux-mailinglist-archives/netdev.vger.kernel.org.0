Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2AE4F0BB7
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359732AbiDCSV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 14:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbiDCSV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 14:21:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9995E344C6;
        Sun,  3 Apr 2022 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5ohYKcgKZ2/0EAdVX+I+Wzm2AaPoOlaq+IWFL6pfwpQ=; b=LR/O85uJNRIIKZEItCvutlR0IS
        kKyzjDGEsuWAknGSMUQvRObCZ3t8iZNyzShEkjEkTvYy0G9ttUE1jlIqsrGhfdtv0/ZyUhVa1UEd0
        bEYxCKLsRXL0AhuaYO5tx0OMaZhrAOb7TbzIt68gkavnHZHqRiJmfI4SJnNHM57tJwSfxNW7hmhbH
        tHhP1TWGHyxjpRjoQ9DrvIneBr7vTR9+XTNA2yNlZ6FrmXvIae6lZCZEg2UWRg1Gk4cSLGiNVn7Ug
        ZJcpcpcMB2WEGjhJMxe+WetQ9cucdcmKX39lXIoYZuxhoG3fIougXZLGUY/MX7IGt+QjkuHdPzbeD
        ja6DwIHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58108)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nb4pN-00082E-BE; Sun, 03 Apr 2022 19:19:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nb4pK-0002Tl-21; Sun, 03 Apr 2022 19:19:50 +0100
Date:   Sun, 3 Apr 2022 19:19:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pali@kernel.org, kabel@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH] net: phy: marvell: add 88E1543 support
Message-ID: <YknlRh7MLgLllb9q@shell.armlinux.org.uk>
References: <20220403172936.3213998-1-stijn@linux-ipv6.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403172936.3213998-1-stijn@linux-ipv6.be>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Apr 03, 2022 at 08:29:36PM +0300, Stijn Tintel wrote:
> Add support for the Marvell Alaska 88E1543 PHY used in the WatchGuard
> Firebox M200 and M300.

Looking at the IDs, this PHY should already be supported - reporting as
an 88E1545. Why do you need this patch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
