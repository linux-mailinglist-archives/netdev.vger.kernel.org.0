Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239AA33D7DB
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhCPPmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhCPPlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:41:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BDFC06174A;
        Tue, 16 Mar 2021 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EIoRbxpiYKgv+aOp/kFhMyNN/lpqbQgyORK4t9vp8yw=; b=PSkFad6MJ4yRvaAejn6DlPgFi
        QHB8qPHNO7zU3WFPn4KgadPiAK2fsEJyV/hWwSx/EiXbW9pkBTqrm+aCsmRDoMB0eml6yk92bpFHu
        KbApAtsFIRjU5Q9usgT0frskkriXZCBxwufCfKkR2jgZBMtfcZy4FMJYndk7wK4G654NPGbi+LtQ8
        D0hBTE2IcdY5I/Afiqayt7wFmdJQZcfXEK76sCfBDMwV/0tXuUH/yFsDdnCtsu1ck8Usv9SKyMuJe
        GBSoMTmanW0rnehgfST7jpueMW4HBKxFvOu1IEjbtSF2hJwuS+4JLVkiRZ07L51Y0y3mdYP8+FU54
        22B0QwPJw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51362)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lMBp5-0001UA-AV; Tue, 16 Mar 2021 15:41:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lMBp3-0006MP-7p; Tue, 16 Mar 2021 15:41:29 +0000
Date:   Tue, 16 Mar 2021 15:41:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: Re: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Message-ID: <20210316154129.GO1463@shell.armlinux.org.uk>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
 <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 03:28:51PM +0000, Stefan Chulski wrote:
> No XDP doesn't require this. One of the use cases of the port reservation feature is the Marvell User Space SDK (MUSDK) which its latest code is publicly available here:
> https://github.com/MarvellEmbeddedProcessors/musdk-marvell
> You can find example use case for this application here:
> http://wiki.macchiatobin.net/tiki-index.php?page=MUSDK+Introduction

I really, really hope that someone has thought this through:

  Packet Processor I/O Interface (PPIO)

   The MUSDK PPIO driver provides low-level network interface API for
   User-Space network drivers/applications. The PPIO infrastrcuture maps
   Marvell's Packet Processor (PPv2) configuration space and I/O descriptors
   space directly to user-space memory. This allows user-space
   driver/application to directly process the packet processor I/O rings from
   user space, without any overhead of a copy operation.

I realy, really hope that you are not exposing the I/O descriptors to
userspace, allowing userspace to manipulate the physical addresses in
those descriptors, and that userspace is not dealing with physical
addresses.

If userspace has access to the I/O descriptors with physical addresses,
or userspace is dealing with physical addresses, then you can say
good bye to any kind of security on the platform. Essentially, in such
a scenario, the entire system memory becomes accessible to userspace,
which includes the kernel.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
