Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53096264A7
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiKKWdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbiKKWdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:33:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DDF532C4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+yl5rA4VN4nRclevK05XLn57nQof4kGkLjMGHSupeTY=; b=iUuROgoQMoyKIVsZV1a2AGh6qT
        oXPsxDEAX0Q+WrYLPMofRLogLIgDaaMtlC3ti5vNZUn7FXG66eTxHdHjkeVSQkjfOC1dznv4iBM9Q
        IQAh0AkqdgPqLjjvDP7ipf3FmTTtwM7wQrAAkm+VBBAn8bNH24XSYxN5+gagd95eum45VtBclChpL
        fUcPu6ICuU8+Jb4mJqs/u0Y8ecgkEBneT5Gil5gTFvZAvfqQAONtzBp+Me7gT7pf9ShYt0zjXF6r4
        JsRSwHIZvHAXoHu2LbXnds3wcblasPbhN8rojAWVUDHSlPPaKi5gP9hzZlw5cu/88O9jkjbTu0Xh/
        39aYWchQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35222)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1otcaC-0007Cs-Ts; Fri, 11 Nov 2022 22:33:08 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1otcaA-0007uy-Tk; Fri, 11 Nov 2022 22:33:06 +0000
Date:   Fri, 11 Nov 2022 22:33:06 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: status of rate adaptation
Message-ID: <Y27Nopmvmwlz6KGw@shell.armlinux.org.uk>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 04:54:40PM -0500, Sean Anderson wrote:
> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
> should support it. I'm not sure if the aquantia driver is set up for it.

mvpp2 doesn't support USXGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
