Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44F63985FD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhFBKLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhFBKLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 06:11:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA667C061574;
        Wed,  2 Jun 2021 03:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nPmfDu3O74mL+IcHu+Wc9SQ6GHgafd370qmEKo52PsM=; b=gy17awE98yI8P6+rFtZfMfLX+
        xwQFH96xRbCtJb0s7Yr5+NPXcMlLOHUHIbd06D/m+NXDyRVhJr52Boihz5gyjmyN5m72MNsQCZCVi
        enFKkziJdCPfYiXEx9gA8VuQPLcRmpyJJw1aL3ZJk3mbVXikptjsO87wgjUMGRQ0oN11lABVkWPHq
        kHzPDWd9V2FimfPAHAC6p+s70mnCtmFeINrZpQn65Q6fQNwwhfoE7Eyo8zZc0cb8He0YC1EadUbbT
        sVbrDrKwpukZQwKRwWzWPRNcWqsocUHunzGKyPtuTkbEAHBvnzTFpPVBAkeYMzvbMGDz5SLxx+DCa
        6iDkOFH4w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44606)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1loNox-0000wZ-I1; Wed, 02 Jun 2021 11:09:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1loNox-00011W-AM; Wed, 02 Jun 2021 11:09:55 +0100
Date:   Wed, 2 Jun 2021 11:09:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     Joe Perches <joe@perches.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH net-next] net: mdio:
 Fix a typo
Message-ID: <20210602100955.GA1350@shell.armlinux.org.uk>
References: <20210602063914.89177-1-zhengyongjun3@huawei.com>
 <76fd35fe623867c3be3f93b51d5d3461a2eabed9.camel@perches.com>
 <264010307fb24b0193cfd451152bd71d@huawei.com>
 <20210602100749.GC30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602100749.GC30436@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 11:07:49AM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 02, 2021 at 07:43:19AM +0000, zhengyongjun wrote:
> > Russell King told me to do so...  Did I understand it wrong?  
> > But from your opinion, I think "Hz" is more appropriate :)
> 
> Sadly, you understood wrong. I requested to change from hz to Hz.

... which is odd, because you did the correct thing in your v2 spelling
fix patch posted previously.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
