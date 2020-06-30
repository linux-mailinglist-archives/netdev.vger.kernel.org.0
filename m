Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0839D20FDCA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgF3Uhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3Uhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:37:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031ADC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ycaImjanmYrAywGS9eoYMX5dyDGAKxV4uD344QY6OM0=; b=H+546Fi6PMnro7iQuts5FBnDs
        +DwxgILnGQhlMPCEu7gNk6gl4e6WlqCKoltHRRgD4HqEua7yZRgW9UDVF+1pk3R9qBYvxqmUHD9t+
        bNzgtDcB78J8fEmktFrK/Z8w5PbJ91X5Z6+N2yfcDFhTqhea2f/VTliJuoIco7vd0GRAke1xZNP34
        k7JFSh656lSw6uLOria94Cygtjw6BvZw3biZkg0Py2uhS8VQcX7GiE96ljg4aw+8Qlil7mknQ7pPB
        2BErZabDXaLQc14eSgJaUEGxqjtXCa9OYl/byFFCoqIhuIh9Ea1KCfDP30Cr8D4fypO7RFnrSNaqh
        56AfT4Xqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33688)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqN0o-0000zT-O8; Tue, 30 Jun 2020 21:37:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqN0n-0008UJ-QZ; Tue, 30 Jun 2020 21:37:49 +0100
Date:   Tue, 30 Jun 2020 21:37:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/3] Convert Broadcom SF2 to mac_link_up()
 resolved state
Message-ID: <20200630203749.GF1551@shell.armlinux.org.uk>
References: <20200630102751.GA1551@shell.armlinux.org.uk>
 <20200630.130532.649926398952677019.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630.130532.649926398952677019.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 01:05:32PM -0700, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Tue, 30 Jun 2020 11:27:51 +0100
> 
> > Convert Broadcom SF2 DSA support to use the newly provided resolved
> > link state via mac_link_up() rather than using the state in
> > mac_config().
> 
> Series applied with double newline in patch #3 fixed up.

Thanks David, I was going to send a series with that fixed up tomorrow.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
