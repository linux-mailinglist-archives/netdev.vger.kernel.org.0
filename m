Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253882A40AF
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgKCJvv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Nov 2020 04:51:51 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39084 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgKCJvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:51:51 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A39pdfM7015066, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A39pdfM7015066
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 3 Nov 2020 17:51:39 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Tue, 3 Nov 2020 17:51:38 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Tue, 3 Nov 2020 17:51:38 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Subject: RE: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for RTL8153
Thread-Topic: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Thread-Index: AQHWrmwDnKDexsPDxUiMgOTBbfR/C6mx0pMAgAJFC4CAAKdeAIAA5pyAgACKw6A=
Date:   Tue, 3 Nov 2020 09:51:38 +0000
Message-ID: <47091014a31c41d5a0d329c49f6cdafa@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
 <1394712342-15778-388-Taiwan-albertk@realtek.com>
 <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <dc7fd1d4d1c544e8898224c7d9b54bda@realtek.com>
 <20201102114718.0118cc12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201103093241.GA79239@kroah.com>
In-Reply-To: <20201103093241.GA79239@kroah.com>
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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, November 3, 2020 5:33 PM
[...]
> There is a reason, it's a nightmare to maintain and handle merges for,
> just don't do it.
> 
> Read the comments at the top of the pci_ids.h file if you are curious
> why we don't even do this for PCI device ids anymore for the past 10+
> years.
> 
> So no, please do not create such a common file, it is not needed or a
> good idea.

Oops. I have sent it.
