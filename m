Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3318C422292
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhJEJp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbhJEJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 05:45:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FC5C06161C;
        Tue,  5 Oct 2021 02:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fv/eTlFhdwJO4aKyPVZQzN2g3Wxr+4+vdkJDkaI1jhE=; b=1TfSU7PNMuwf3g5JgAb2wO6Wt8
        Bs6bVYQE28iJhdlNKdKcRSg1D+TzuT0jie7meCtwv8jRiyerPcmtAHJZ6UCgi5G3gqv1kAoK12tU3
        oK0ppCxEHi6aU3RJ180kNehOYM6Ctnm4WitpWn2sm08aUGJ47d7I8TR2z3EqT6kqVwWJE6DXGckR7
        5jI9ft9s6VYktKKjPUb5AZG+nqcMM9wpjslcv4JPtGNggI6WSIEh62v8/1qScsDgP4TJXZ9ZKIrBp
        us71AtvDgNV0ZWDD05HBA2ZD0X5Q9aId9tBLYUWJBZMAUfqMmr6dFeE89mVO6jv+ioNS/uHAYRDG0
        uQlPVGTw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54944)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXgz2-00005a-HP; Tue, 05 Oct 2021 10:43:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXgz1-0008Mo-TK; Tue, 05 Oct 2021 10:43:35 +0100
Date:   Tue, 5 Oct 2021 10:43:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 04/16] net: phylink: Move phylink_set_pcs
 before phylink_create
Message-ID: <YVweRwtV+ScT4mIe@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-5-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-5-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:15PM -0400, Sean Anderson wrote:
> The new pcs-related functions in the next few commits fit better before
> phylink_create, so move phylink_set_pcs in preparation. No functional
> change intended.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
