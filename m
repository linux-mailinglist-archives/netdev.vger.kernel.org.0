Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C03239753C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhFAOTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFAOTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:19:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800C4C061574;
        Tue,  1 Jun 2021 07:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pYuoXpehqLzyZ3pH+QsdnfFqkhLiBGCB8wzijudRl7I=; b=Hboa5vFvlz19kz9IvLQ269gM2
        VQ5ISmnouMfMM1Fyj7MZfwXqcc0OAflXlHKeT4YzBBEQRa/j7zEAJ0gRQqI/xkQrWbQGBEt1Dt866
        488ivUswZBJKDkAT82fv1nPsRymZJok+PaKwxE2/9z9DRIcu6nFr4bqsgilZEXTG725naCMYzTHc2
        npHRsKV3i5QFKL4cJ5xqBQ65ZXGX34dlbwXf+Y3nZG68DPrXpIrrfIvuPRlcSPNRJQmoqlv8wCzgX
        Q0VWXyEclQWHD4wzGQTlUq+y/QouMLVuzHZMLVNL6saOxLA0gDpq56IrBY/SIiSPF+2gZ1PHr2FI2
        x/1HJKkvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44580)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lo5DC-0004C2-Ft; Tue, 01 Jun 2021 15:17:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lo5D9-0000C2-0m; Tue, 01 Jun 2021 15:17:39 +0100
Date:   Tue, 1 Jun 2021 15:17:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, narmstrong@baylibre.com,
        khilman@baylibre.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-amlogic@lists.infradead.org,
        opendmb@gmail.com, f.fainelli@gmail.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com
Subject: Re: [PATCH net-next] net: mdio: Fix spelling mistakes
Message-ID: <20210601141738.GA30436@shell.armlinux.org.uk>
References: <20210601141859.4131776-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601141859.4131776-1-zhengyongjun3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 10:18:59PM +0800, Zheng Yongjun wrote:
> informations  ==> information
> typicaly  ==> typically
> derrive  ==> derive
> eventhough  ==> even though

If you're doing this, then please also change "hz" to "Hz". The unit of
frequency is the latter, not the former. Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
