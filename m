Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A485673FAE
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjASRO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjASROu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:14:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7C95D12C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PwG0JnLVV+c9tj3/Xfs6MdkrrBOI8WGMkfKN4ddYF+s=; b=na2UDrhcemmPPPSxaLSWZAE8bu
        MPuCtOw306K6AlireNWMr3LDp/WzQi0GyNykZqY085irflP0a2iJNP01HSvkghBnWU3jnzCSY1cx8
        sxaGI14+3ZhFmFPUXgx2awsVafLB2wlmbxnv7uZp7qnN1a+PHiDyhUJj4NGJKNZL4SSmJsCZiAHFI
        hQhvxnFDEG/pxOf6fAepJb67oXvtVz9KwQ9S1SWvG0yofztGpOJI479CTxdLfX+6t9VeE/WVpGbpy
        USk/uI+IxXZU2gQ3L04ugDODmPDddsxG1jT3ghmX6p3vYY9qxtQ90zYKl9XPm5URDB+WJ0aiqldR1
        Qf+9UrLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36208)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIYUt-0004iU-SD; Thu, 19 Jan 2023 17:14:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIYUo-0000eC-VX; Thu, 19 Jan 2023 17:14:38 +0000
Date:   Thu, 19 Jan 2023 17:14:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net 3/3] net: mediatek: sgmii: fix duplex configuration
Message-ID: <Y8l6ftzqhAZVjghH@shell.armlinux.org.uk>
References: <20230119171248.3882021-1-bjorn@mork.no>
 <20230119171248.3882021-4-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230119171248.3882021-4-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 06:12:48PM +0100, Bjørn Mork wrote:
> This bit is cleared for full duplex and set for half duplex.
> Rename the macro to avoid confusion.
> 
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
