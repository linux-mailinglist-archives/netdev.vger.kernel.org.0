Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397EF245DDE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHQH06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgHQH0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 03:26:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32952C061388;
        Mon, 17 Aug 2020 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ENDZdFTFMP4MXXNT0RXU3KDrnfZ3NWaAyvVDe6qM4Gs=; b=2B3fM0bpIfwoFU5vu4gISsf1b
        UEdO6kUch4ZmjHfhWFuCJD69H9gPNsEFAkM9917dQcfFX71Bqwqm26zLLWc8FrYroLSp8kip9wB33
        zjpj1kLr1cKY0YN2DOECKMpYxTsMT7WWJPjvnXAd6VK5YLiYHgxXTsLbV0p3sT0goEGVFLU8N03Rx
        0krGgP35FWvUCX1qra8Q6/31zHz8vy+u/WJopp8iRGis11T+BI65A4rciv/4ljW7/7gcM9sJJYqvz
        d4Gt//57//aIZVSfIxQ8e6qhZM10UsLMHPV/3nuPVXG6+5T5e21VP8a8yljJ7oTgs9VQ2qbwKxwAa
        pI/mxwqrg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53550)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k7ZXQ-0006hi-LA; Mon, 17 Aug 2020 08:26:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k7ZXN-0000DD-KV; Mon, 17 Aug 2020 08:26:33 +0100
Date:   Mon, 17 Aug 2020 08:26:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] phylink: <linux/phylink.h>: fix function prototype
 kernel-doc warning
Message-ID: <20200817072633.GX1551@shell.armlinux.org.uk>
References: <20200816222549.379-1-rdunlap@infradead.org>
 <20200816.211451.1874573780407600816.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816.211451.1874573780407600816.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 09:14:51PM -0700, David Miller wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Sun, 16 Aug 2020 15:25:49 -0700
> 
> > Fix a kernel-doc warning for the pcs_config() function prototype:
> > 
> > ../include/linux/phylink.h:406: warning: Excess function parameter 'permit_pause_to_mac' description in 'pcs_config'
> > 
> > Fixes: 7137e18f6f88 ("net: phylink: add struct phylink_pcs")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> There's no definition of this function anywhere.  Maybe just remove all of
> this?

This is kerneldoc documentation for the PCS methods - there's no other
way to document the method parameters than to use "fake" function
prototypes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
