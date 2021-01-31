Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D7B309D29
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhAaOri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhAaOqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:46:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7282FC061574;
        Sun, 31 Jan 2021 06:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9b9yo1n9sRlMWrUad542cT8LS7C9jEYFRJcs1ywwN+k=; b=ME3XEEgB3H78Cw6yK3MtBjMo0
        h45DCW5TrMU1iDK7CyGfXIId7VTaCBoDu6+YR9z8UIDJx8ldfIpWwvdck+bYuWAIEbTvi4Hgkn78z
        kIrRzZWatEUeHQKAmXpKgJtL84dvA2A8uSbOp5zpOucmZXODQjzhm2og4cjL8urLc/N8boa0ptfZz
        SNCFUCIhirdgNFXxJScJiky1p8PH19O1RPjFLl0+LIuYab9o8zXTE/JpCsVDs6YLy5KqP9kbTTxEw
        DJ5AUNygV6lUjwXa1UOfvXGZKhbQTFBRLM3GgM3H6zHMy3ews4qR550a2G5zdPnNVGF/yuYXQeO9Y
        hyU/WVkEw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37374)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6Dyg-0002YG-Ld; Sun, 31 Jan 2021 14:45:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6Dye-00016J-Qv; Sun, 31 Jan 2021 14:45:24 +0000
Date:   Sun, 31 Jan 2021 14:45:24 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Message-ID: <20210131144524.GD1463@shell.armlinux.org.uk>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
 <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO6PR18MB38736602343EEDFB934ACE3EB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <CO6PR18MB3873FF66600BCD9E7E5A4FEDB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873FF66600BCD9E7E5A4FEDB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 02:23:20PM +0000, Stefan Chulski wrote:
> I still don't see all patches in https://patchwork.kernel.org/project/netdevbpf/list/?series=424949
> I would reduce patch series to 15 patches and repost again.

kernel.org email is currently broken for everyone due to the
spamcop.net RBL domain having expired. Please don't resend until
this has been resolved. The problem has been reported to a
kernel.org admin (John Hawley) and others via IRC.

If you didn't get bounce messages from the attempt to send to
kernel.org email addresses, your email server is broken.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
