Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AB2A5C10
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgKDBkJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Nov 2020 20:40:09 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53261 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgKDBkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 20:40:09 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A41dqJW3023388, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A41dqJW3023388
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 4 Nov 2020 09:39:52 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.34) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 4 Nov 2020 09:39:52 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 4 Nov 2020 09:39:52 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 4 Nov 2020 09:39:52 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Subject: RE: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for RTL8153
Thread-Topic: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Thread-Index: AQHWrmwDnKDexsPDxUiMgOTBbfR/C6mx0pMAgAJFC4CAAKdeAIAA5pyAgABwkoCAASNjcA==
Date:   Wed, 4 Nov 2020 01:39:52 +0000
Message-ID: <db4c6b3b30284206a6f131e922760e1e@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-388-Taiwan-albertk@realtek.com>
        <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <dc7fd1d4d1c544e8898224c7d9b54bda@realtek.com>
        <20201102114718.0118cc12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201103093241.GA79239@kroah.com>
 <20201103081535.7e92a495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103081535.7e92a495@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 4, 2020 12:16 AM
[...]
> > So no, please do not create such a common file, it is not needed or a
> > good idea.
> 
> I wouldn't go that far, PCI subsystem just doesn't want everyone to add
> IDs to the shared file unless there is a reason.
> 
>  *	Do not add new entries to this file unless the definitions
>  *	are shared between multiple drivers.
> 
> Which seems quite reasonable. But it is most certainly your call :)

Do I have to resend this patch?

Best Regards,
Hayes


