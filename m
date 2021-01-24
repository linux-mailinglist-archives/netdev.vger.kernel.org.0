Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA68301BC4
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAXMP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhAXMP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:15:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C8EC061573;
        Sun, 24 Jan 2021 04:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=itM1lqV8tTHXEiK1QO41a9srXnhnnvUeRYPjU5TfuJc=; b=lL225nziKixbbt0My9wJIoP3J
        hqVdkg+j5tmJroD+8T/XOGtR27pYmYZYxtiPjEsFtaVFVaGG1JN1LNPsn/h4de+lppTVT1jT2Nfxz
        WN/wi0Z0v6DTLAN0Ym7z4FZJ/vR6/SNqrqb4fq0ioaxYoa2eUcwlVXoFj2AyRj0puBvH+bz74DCXv
        Q6x2tHWs3e9CS6qJZkyMkTVgnKvpl1E8T9qs/Uma8WevL6sVdmjmGj0mdDWiUVwqMNdS8WLGQ3fIs
        iymSbidGw4Sv2TekPw4eipj8CxhydheDEPpKyr2xtzBZbrrmPsP8yOBucWDnbXnFwFLnoG9wnlesm
        OWEPdL9Gw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52096)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3eI2-0002L9-Oi; Sun, 24 Jan 2021 12:14:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3eHz-0001gD-GU; Sun, 24 Jan 2021 12:14:43 +0000
Date:   Sun, 24 Jan 2021 12:14:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 08/18] net: mvpp2: add FCA periodic timer
 configurations
Message-ID: <20210124121443.GU1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-9-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-9-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:43:57PM +0200, stefanc@marvell.com wrote:
> +/* Set Flow Control timer x140 faster than pause quanta to ensure that link
> + * partner won't send taffic if port in XOFF mode.

Can you explain more why 140 times faster is desirable here? Why 140
times and not, say, 10 times faster? Where does this figure come from,
and what is the reasoning? Is there a switch that requires it?

Also, spelling "traffic".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
