Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2764AF0EA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiBIMHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBIMGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:06:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378BAC050CD3;
        Wed,  9 Feb 2022 03:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644406056; x=1675942056;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NGSesQuO1TkFrdjGkmTfRB4zx9VGkoV76GOJi87bu3w=;
  b=SbMdbxq3z6EL8Tk3Xe/a7bv0Q372DpLAi1gmqjbTAGmRgi132iw14nWb
   SJFiNI/BE0km24lK8O1ZjbAUXiDauQx4nNndLBJddpIlUZC0dE8N1Bb4m
   t48l8Zrt0nxLnFdkqAVp7Zz4wIFjSJo+e/A5/PsSX+4GWgFQej6+OS2OP
   je3etDl3QL4VNsZxzHI51vALJ7hVLA8Ac8J218Uujo73ZOefEK8DiF4AC
   2nFaW8bCJc4o0Yg1Skm91JxYRdP0jkYw9yOJhAkV6fYgOAYK7PjHcbjhZ
   ltiHB9mK6t1SiN2Q0jbze9+ifNX0DcqYR7EQtvoisJOgOTrDhPvwVWxoN
   Q==;
IronPort-SDR: WNfa+KzMaWtRn8hVQr/2q7GiBtU5X1zazxQ0MAgYKPWi68L6mUnGLSM61ZDRp7ddv0kVtvAq1H
 A6bQSD5u8GP4UtrUzfRcUAzjTxILBu1TtZTlfOBWF0XwXFqubJ9ZsNhRdDCpj6so7nemB24YuM
 NWpsXkqF6zDDOtML6JgTGfMDCQHi6Zh7JGOXVhN8zcEDm1jdgAsjmOApLs6j157lf9H0gRpkQz
 xP18rQvCOsgFF8qABQmT4dlNt3YJRZzkTKsA1ZVi0iTCYWehdn/E7QoRUiWSUvCxXZtMUQ+0JV
 QGAY4omMKXNCDVDyy3WGjYLv
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="148122096"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 04:27:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 04:27:34 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 9 Feb 2022 04:27:29 -0700
Message-ID: <2762670649daca77a367aaee44b6669142ce0f6d.camel@microchip.com>
Subject: Re: [PATCH v8 net-next 03/10] net: phy: Add support for LAN937x T1
 phy driver
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Wed, 9 Feb 2022 16:57:27 +0530
In-Reply-To: <YgJre2C9jpfMCXSZ@lunn.ch>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
         <20220207172204.589190-4-prasanna.vengateshan@microchip.com>
         <YgJre2C9jpfMCXSZ@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-08 at 14:09 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Mon, Feb 07, 2022 at 10:51:57PM +0530, Prasanna Vengateshan wrote:
> > Added support for Microchip LAN937x T1 phy driver. The sequence of
> > initialization is used commonly for both LAN87xx and LAN937x
> > drivers. The new initialization sequence is an improvement to
> > existing LAN87xx and it is shared with LAN937x.
> > 
> > Also relevant comments are added in the existing code and existing
> > soft-reset customized code has been replaced with
> > genphy_soft_reset().
> > 
> > access_ereg_clr_poll_timeout() API is introduced for polling phy
> > bank write and this is linked with PHYACC_ATTR_MODE_POLL.
> > 
> > Finally introduced function table for LAN937X_T1_PHY_ID along with
> > microchip_t1_phy_driver struct.
> 
> Hi Prasanna
> 
> That is a lot of changes in one patch.
> 
> I would suggest you make this a patch series of its own. It should be
> independent of the switch changes. And then you can break this patch
> up into a number of smaller patches.
> 
> Thanks
>         Andrew

Sure, i will submit as a seperate patch series and i will remove from this
patch. Thanks.

Prasanna V


