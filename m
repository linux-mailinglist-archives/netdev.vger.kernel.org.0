Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363D713B96F
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgAOGTZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 01:19:25 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:59415 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgAOGTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:19:25 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00F6J4nI010830, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00F6J4nI010830
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 15 Jan 2020 14:19:05 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Wed, 15 Jan 2020 14:19:04 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 14:19:04 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 15 Jan 2020 14:19:04 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Prashant Malani <pmalani@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        "Mario Limonciello" <mario.limonciello@dell.com>,
        David Chen <david.chen7@dell.com>,
        "open list:USB NETWORKING DRIVERS" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Topic: [PATCH] r8152: Add MAC passthrough support to new device
Thread-Index: AQHVypTrvWsj1nE3Z02rCzrvB8fQNKfrP9uQ
Date:   Wed, 15 Jan 2020 06:19:04 +0000
Message-ID: <383516f7b54247bda694bf2a999e68f7@realtek.com>
References: <20200114044127.20085-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200114044127.20085-1-kai.heng.feng@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng [mailto:kai.heng.feng@canonical.com]
> Sent: Tuesday, January 14, 2020 12:41 PM
[...]
>  	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO &&
> -	    le16_to_cpu(udev->descriptor.idProduct) == 0x3082)
> +	    (le16_to_cpu(udev->descriptor.idProduct) == 0x3082 ||
> +	     le16_to_cpu(udev->descriptor.idProduct) == 0xa387))

How about using
switch (le16_to_cpu(udev->descriptor.idProduct)) {
...
}

>  		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
> 
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial
> &&
> --
> 2.17.1


Best Regards,
Hayes


