Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EDC4683A8
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384500AbhLDJl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384475AbhLDJl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:41:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111AC061751;
        Sat,  4 Dec 2021 01:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZfgkZaoeAbjocXh68VUCcA3XUaMm8jyJokJ0ggqvz3o=; b=n8rwSW0Q2C/dkpMhANAwBacOTb
        7dbPul/kntExtNtWAGkY1f68pLmUeT4HsOaClFtZIAtuOeStyg7ImCn1i6oEmrGpZEDCOD41x+2Z/
        tn8mJvqAGUZvNoF7qE1fkaUAiaAWyozrlpXr3mdjVwA2YeHIPf8kXL2DbV35oIxtnoSgubPBdm0Dp
        lcLug4pKHk4hgJc438CHuPU6v2Tm+8776FAtTTpSQ8xxZtRVwiHXIUnrrHDSS6fSsQKZvG+zzBnVq
        /k2JqFXVkZMMfhKyA5X+qdpqSRgs1GKHJQ81ai1p25r5VnSG0txd3ERSiTj9EsiDGDLvf7wEALCap
        hhAf/Vzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56046)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtRUw-0003Br-Tu; Sat, 04 Dec 2021 09:38:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtRUw-0002IP-5r; Sat, 04 Dec 2021 09:38:26 +0000
Date:   Sat, 4 Dec 2021 09:38:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <Yas3Ehu4Lzkzp33B@shell.armlinux.org.uk>
References: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 05:13:27PM +0800, Yinbo Zhu wrote:
> The do_mdio_entry was responsible for generating a phy alias configure
> that according to the phy driver's mdio_device_id, before apply this
> patch, which alias configure is like "alias mdio:000000010100000100001
> 1011101????", it doesn't match the phy_id of mdio_uevent, because of
> the phy_id was a hexadecimal digit and the mido uevent is consisit of
> phy_id with the char 'p', the uevent string is different from alias.
> Add this patch that mdio alias configure will can match mdio uevent.
> 
> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>


NAK.


> ---
> Change in v4:
> 		Add following explain information.
> 
> Hi Russell King ,
> 
> 
> I had given you  feedback lots of times, but it may be mail list server issue, you don't accept my mail,
> 
> and I don't get your mail, then I add that what i want explain in v1 patch for your v1 patch comment, 
> 
> you can check. then for v3 patch that is for rework commit inforation accorting , just , I notice you
> 
> have a comment in v2, but i dont' accept your mail. and I give you explain as follows:
> 
> 
> > No. I think we've been over the reasons already. It _will_ break
> > existing module loading.
> 
> > If I look at the PHY IDs on my Clearfog board:
> 
> > /sys/bus/mdio_bus/devices/f1072004.mdio-mii:00/phy_id:0x01410dd1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:00/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:01/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:02/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:03/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:04/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:0f/phy_id:0x01410ea1
> 
> > and then look at the PHY IDs that the kernel uses in the drivers, and
> > thus will be used in the module's alias tables.
> 
> > #define MARVELL_PHY_ID_88E1510          0x01410dd0
> > #define MARVELL_PHY_ID_88E1540          0x01410eb0
> > #define MARVELL_PHY_ID_88E1545          0x01410ea0
> 
> > These numbers are different. This is not just one board. The last nibble
> > of the PHY ID is generally the PHY revision, but that is not universal.
> > See Atheros PHYs, where we match the entire ID except bit 4.
> 
> > You can not "simplify" the "ugly" matching like this. It's the way it is
> > for good reason. Using the whole ID will _not_ cause a match, and your
> > change will cause a regression.
> 
> On my platform, I can find following, stmmac-xx that is is mac name, it represent this platform has two mac 
> controller, it isn't phy, but it's sub dir has phy id it is phy silicon id, and devices name is set by mdio bus,
> then, you said that "where we match the entire ID except bit 4." I think marvell it is special, and you can have 
> look other phy,e.g. motorcomm phy, that phy mask is 0x00000fff or 0x0000ffff or ther, for different phy silicon, 
> that phy maskit is not same, and that phy mask it isn't device property, you dont't get it from register, and mdio
>  bus for phy register a device then mdiobus_scan will get phy id that phy id it is include all value, and don't has 
> mask operation. then phy uevent must use phy_id that from phy register and that uevent doesn't include phy mask, if
> uevent add phy mask, then you need  define a phy mask. if you have mature consideration, you will find that definition
> phy mask it isn't appropriate, if you define it in mac driver, because  mac can select different phy, if you define it
>  in dts, then phy driver is "of" type, mdio_uevent will doesn't be called. if you ask phy_id & phy_mask as a phy uevent,
>  I think it is no make sense, e.g. 88e1512 and 88e1510 that has different "phy revision" so that phy silicon has difference, 
> and uevent should be unique. If you have no other opinion on the above view, Back to this patch, that phy id of uevent
> need match phy alias configure, so alis configure must use phy id all value.
> 
> In addition, Even if you hadn't  consided what I said above, you need to know one thing, uevent match alias that must be full
>  matching. not Partial matching. I said it a long time ago.  why you think Binary digit and "?" can match dev uevent,   
> according my code analysis and test analysis that  any platform and any mdio phy device is all fail that be matched if that
>  phy driver module and phy dev was use uevent-alias mechanism
> 
> [root@localhost ~]# cat /sys/bus/mdio/devices/stmmac-19\:00/phy_id 
> 0x01410dd1
> [root@localhost ~]# 
> [root@localhost ~]# cat /sys/bus/mdio/devices/stmmac-18\:00/phy_id 
> 0x01410dd1
> [root@localhost ~]# 
> 
> Thanks,
> BRs,
> Yinbo Zhu.
> 
> 
>  include/linux/mod_devicetable.h |  2 ++
>  scripts/mod/file2alias.c        | 17 +----------------
>  2 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index ae2e75d..7bd23bf 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -595,6 +595,8 @@ struct platform_device_id {
>  	kernel_ulong_t driver_data;
>  };
>  
> +#define MDIO_ANY_ID (~0)
> +
>  #define MDIO_NAME_SIZE		32
>  #define MDIO_MODULE_PREFIX	"mdio:"
>  
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 49aba86..63f3149 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1027,24 +1027,9 @@ static int do_platform_entry(const char *filename,
>  static int do_mdio_entry(const char *filename,
>  			 void *symval, char *alias)
>  {
> -	int i;
>  	DEF_FIELD(symval, mdio_device_id, phy_id);
> -	DEF_FIELD(symval, mdio_device_id, phy_id_mask);
> -
>  	alias += sprintf(alias, MDIO_MODULE_PREFIX);
> -
> -	for (i = 0; i < 32; i++) {
> -		if (!((phy_id_mask >> (31-i)) & 1))
> -			*(alias++) = '?';
> -		else if ((phy_id >> (31-i)) & 1)
> -			*(alias++) = '1';
> -		else
> -			*(alias++) = '0';
> -	}
> -
> -	/* Terminate the string */
> -	*alias = 0;
> -
> +	ADD(alias, "p", phy_id != MDIO_ANY_ID, phy_id);
>  	return 1;
>  }
>  
> -- 
> 1.8.3.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
