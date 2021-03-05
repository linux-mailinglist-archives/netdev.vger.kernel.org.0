Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386B132DE4F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhCEA2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 19:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhCEA2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 19:28:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6559BC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 16:28:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bj7so810493pjb.2
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 16:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J4AKE+g34bDz2SzF2l7p1C+2gIH0nYgaYl8eOSvbSmw=;
        b=hTy0SQaWWaJk/Em3pV2dt35MfnOfRBczwDnStrID5JGnTTXSmCyfiNt5hN7yp7oDvK
         BCwNOsEoZ0vMmybz6PWWmdfvvmTv/el2YOHe9fEdaSwTtI1Eb24GGeKIibHdid76CPzP
         sLARM7NnQvLw4oRMCyAHESQKKe3SeWuF5gC824dkdwYD1PriN2i+8a4M2M1+CBO9WRjQ
         +Nuk5djXYV/XA/4RQ7Zp37C2IL+vzfv2emOpYAd8hifI7BWUHozyZCVaMWhoLFQquCOT
         ef6sDQONXKU3dcH56pNwM9/Vi3PFTY5WUHK3HP99vHDqvZ67ViKbbksg8Fppxwn/wNg7
         G9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J4AKE+g34bDz2SzF2l7p1C+2gIH0nYgaYl8eOSvbSmw=;
        b=NjRt9MAdI4jSRn8redJgBm0kMhuJXZXVXzVYPdjJogKi72RFd8xqqq/F+8PYm9k/GX
         C27sl8cwKW1fLhczqJfssjgHESRr99SncesvG9POUyhIWcKBV4w8haIWiBWhpaAMAuml
         taH8HKzaM92JtVbD4qfkglFc+DH/uc7mHgecEMc3VPd7s24OQWegSn7PKBKtpS1FBZv+
         ADMAs0S5OCfjM5Cc/DSee5YjFscHf3KdwwSTxMg2mZTU0QoY8Em/2MdwuyLL+QblPumR
         Idav5fyepWbcPmQRnad74czfBlUzAFB9E4he/k2g2umHD50s8oXwEyh5dpcjxGsyZ6Sb
         PZrA==
X-Gm-Message-State: AOAM5331PX8ETa7uOKx34b35HTKF1MidUGmussTtpI5jOVhWvHS3XgJd
        ppb3PDC4qcnxRtNgcTddjR7JyxEbhss=
X-Google-Smtp-Source: ABdhPJy65CjdUkqz08VC/manmJVzh3hgEwPefPCSbydrvue/WtqtFgmPt+NASeBbfJiSxvIBzHKoVA==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr7267666pjs.119.1614904104457;
        Thu, 04 Mar 2021 16:28:24 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t17sm489247pgk.25.2021.03.04.16.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 16:28:23 -0800 (PST)
Subject: Re: stmmac driver timeout issue
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8a996459-fc77-2e98-cc0c-91defffc7f29@gmail.com>
Date:   Thu, 4 Mar 2021 16:28:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/21 5:14 AM, Joakim Zhang wrote:
> 
> Hello Andrew, Hello Jakub,
> 
> You may can give some suggestions based on your great networking knowledge, thanks in advance!
> 
> I found that add vlan id hw filter (stmmac_vlan_rx_add_vid) have possibility timeout when accessing VLAN Filter registers during ifup/ifdown stress test, and restore vlan id hw filter (stmmac_restore_hw_vlan_rx_fltr) always timeout when access VLAN Filter registers. 
> 
> My hardware is i.MX8MP (drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c, RGMII interface, RTL8211FDI-CG PHY), it needs fix mac speed(imx_dwmac_fix_speed), it indirectly involved in phylink_link_up. After debugging, if phylink_link_up is called later than adding vlan id hw filter, it will report timeout, so I guess we need fix mac speed before accessing VLAN Filter registers. Error like below:
> 	[  106.389879] 8021q: adding VLAN 0 to HW filter on device eth1
> 	[  106.395644] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLAN_Tag_Filter
> 	[  108.160734] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full - flow control rx/tx   ->->-> which means accessing VLAN Filter registers before phylink_link_up is called.
> 
> Same case when system resume back, 
> 	[ 1763.842294] imx-dwmac 30bf0000.ethernet eth1: configuring for phy/rgmii-id link mode
> 	[ 1763.853084] imx-dwmac 30bf0000.ethernet eth1: No Safety Features support found
> 	[ 1763.853186] imx-dwmac 30bf0000.ethernet eth1: Timeout accessing MAC_VLAN_Tag_Filter
> 	[ 1763.873465] usb usb1: root hub lost power or was reset
> 	[ 1763.873469] usb usb2: root hub lost power or was reset
> 	[ 1764.090321] PM: resume devices took 0.248 seconds
> 	[ 1764.257381] OOM killer enabled.
> 	[ 1764.260518] Restarting tasks ... done.
> 	[ 1764.265229] PM: suspend exit
> 	===============================
> 	suspend 12 times
> 	===============================
> 	[ 1765.887915] imx-dwmac 30bf0000.ethernet eth1: Link is Up - 100Mbps/Full - flow control rx/tx  ->->-> which means accessing VLAN Filter registers before phylink_link_up is called.
> 
> My question is that some MAC controllers need RXC clock from RGMII interface to reset DAM or access to some registers. If there is any way to ensure phylink_link_up is invoked synchronously when we need it. I am not sure this timeout caused by a fix mac speed is needed before accessing VLAN Filter registers, is there ang hints, thanks a lot! We have another board i.MX8DXL which don't need fix mac speed attach to AR8031 PHY, can't reproduce this issue.

Every Ethernet controller is different, but you can see that we
struggled to fix a similar problem where we need the RXC from the PHY
for the MAC to complete its reset side reset with GENET, it took several
iterations to get there:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=88f6c8bf1aaed5039923fb4c701cab4d42176275
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=612eb1c3b9e504de24136c947ed7c07bc342f3aa
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6b6d017fccb4693767d2fcae9ef2fd05243748bb
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3a55402c93877d291b0a612d25edb03d1b4b93ac
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1f515486275a08a17a2c806b844cca18f7de5b34

This driver uses PHYLIB (hardware is no longer developed and will not
receive updates to support different PCS), but maybe you can glean some
idea on how to solve this?
-- 
Florian
