Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED58EFCA5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbfKELs2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Nov 2019 06:48:28 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:46054 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbfKELs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 06:48:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xA5Bm5ku025506, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xA5Bm5ku025506
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 5 Nov 2019 19:48:05 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Tue, 5 Nov
 2019 19:48:05 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Thread-Topic: [PATCH v2] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
Thread-Index: AQHVk7E2UAb+vVEL20O/iFfFubpdn6d8PDnA//+rqgCAAIxWcA==
Date:   Tue, 5 Nov 2019 11:48:04 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18F4F92@RTITMBSVM03.realtek.com.tw>
References: <20191105081526.4206-1-kai.heng.feng@canonical.com>
 <0835B3720019904CB8F7AA43166CEEB2F18F4E9E@RTITMBSVM03.realtek.com.tw>
 <193EF03A-1EF7-4604-BF3A-61201A78D724@canonical.com>
In-Reply-To: <193EF03A-1EF7-4604-BF3A-61201A78D724@canonical.com>
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
> Sent: Tuesday, November 05, 2019 7:18 PM
[...]
> >> 	} else {
> >> -		/* test for RTL8153-BND and RTL8153-BD */
> >> -		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> >> -		if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
> >> -			netif_dbg(tp, probe, tp->netdev,
> >> -				  "Invalid variant for MAC pass through\n");
> >> -			return -ENODEV;
> >> +		bypass_test = false;
> >> +		mac_obj_name = "\\_SB.AMAC";
> >> +		mac_obj_type = ACPI_TYPE_BUFFER;
> >> +		mac_strlen = 0x17;
> >> +	}
> >> +
> >> +	if (!bypass_test) {
> >
> > Maybe you could combine this with the "else" above.
> > Then, the variable "bypass_test" could be removed.
> 
> Ok, will do in V3.
> 
> > And the declaration of "ocp_data" could be moved after the "else".
> 
> Isn't putting declarations at the top of the function the preferred way?

I mean the ocp_data wouldn't be used out of the else,
so you could move the declaration to the inside of the else.

However, I don't think you have to send another patch for this.
Thanks.

Best Regards,
Hayes



