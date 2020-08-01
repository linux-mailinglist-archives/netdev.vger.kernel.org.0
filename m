Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CB6235186
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgHAJlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 05:41:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB7C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 02:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TDVef6ZsHpwwgV3qmiBjuwSJZ1QCkwryfoVJNtuTdrs=; b=ecpxPOZ3cUA/0KXcVUd6vMUS/
        XY7nKl5O7YvmsY5zPFw43mIKEDUIovjW7vPKWe/rW4o1UEgKW3Fw1yoa/VAit5Do0vC7KE9t4ei8v
        22KpZtGu01PdAoj6bKbkAwQrJEUHZ0h7BxajiLc0rZYXt/cj+IlP8mkFFNW7yOVJHqbTxottVyNNr
        w+eg0JnYpi06qogw55LdET+ZqerOYBcSODlMJPUTR0/XQEJ+PfqdxJf1qUfi6PC0mL5VpNT0Etz4X
        AAlU+2lqF+Sqw6lX+2YwFhGR4rPZLMtJyq6PkwhwNP2avV/imNOScXa1KoeRtcYD644lKttE7qIN5
        W55uALi8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46876)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k1o1E-0008Kz-Kz; Sat, 01 Aug 2020 10:41:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k1o1E-0000IY-Ai; Sat, 01 Aug 2020 10:41:32 +0100
Date:   Sat, 1 Aug 2020 10:41:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Message-ID: <20200801094132.GH1551@shell.armlinux.org.uk>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
 <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
 <20200728130001.GB1712415@lunn.ch>
 <CADvVLtXVVfU3-U8DYPtDnvGoEK2TOXhpuE=1vz6nnXaFBA8pNA@mail.gmail.com>
 <20200731153119.GJ1712415@lunn.ch>
 <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvVLtUrZDGqwEPO_ApCWK1dELkUEjrH47s1CbYEYOH9XgZMRg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 09:52:52AM +0530, Vikas Singh wrote:
> Hi Andrew,
> 
> Please refer to the "fman" node under
> linux/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> I have two 10G ethernet interfaces out of which one is of fixed-link.

Please do not top post.

How does XGMII (which is a 10G only interface) work at 1G speed?  Is
what is in DT itself a hack because fixed-phy doesn't support 10G
modes?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
