Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71711EFCB4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 12:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfKELwe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Nov 2019 06:52:34 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:46145 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbfKELwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 06:52:34 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xA5BqJ5B025801, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xA5BqJ5B025801
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 5 Nov 2019 19:52:19 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Tue, 5 Nov
 2019 19:52:18 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Thread-Topic: [PATCH v3] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
Thread-Index: AQHVk8up3tLg++9LrkuOAqEJxsNBoqd8cdxA
Date:   Tue, 5 Nov 2019 11:52:17 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18F4FA0@RTITMBSVM03.realtek.com.tw>
References: <20191105112452.13905-1-kai.heng.feng@canonical.com>
In-Reply-To: <20191105112452.13905-1-kai.heng.feng@canonical.com>
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
> Sent: Tuesday, November 05, 2019 7:25 PM
> To: davem@davemloft.net; oliver@neukum.org
> Cc: Hayes Wang; linux-usb@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Kai-Heng Feng
> Subject: [PATCH v3] r8152: Add macpassthru support for ThinkPad Thunderbolt
> 3 Dock Gen 2
> 
> ThinkPad Thunderbolt 3 Dock Gen 2 is another docking station that uses
> RTL8153 based USB ethernet.
> 
> The device supports macpassthru, but it failed to pass the test of -AD,
> -BND and -BD. Simply bypass these tests since the device supports this
> feature just fine.
> 
> Also the ACPI objects have some differences between Dell's and Lenovo's,
> so make those ACPI infos no longer hardcoded.
> 
> BugLink: https://bugs.launchpad.net/bugs/1827961
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes


