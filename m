Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8ABC9693
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 04:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfJCCD5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 22:03:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:43541 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfJCCD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 22:03:56 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9323r0R007321, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9323r0R007321
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 3 Oct 2019 10:03:53 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Thu, 3 Oct
 2019 10:03:52 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next] r8152: Add identifier names for function pointers
Thread-Topic: [PATCH net-next] r8152: Add identifier names for function
 pointers
Thread-Index: AQHVeWXNzrpZgHvMJkGzPL+J096QNqdIKCHQ
Date:   Thu, 3 Oct 2019 02:03:51 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18E612E@RTITMBSVM03.realtek.com.tw>
References: <20191002210933.122122-1-pmalani@chromium.org>
In-Reply-To: <20191002210933.122122-1-pmalani@chromium.org>
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

Prashant Malani [mailto:pmalani@chromium.org]
> Sent: Thursday, October 03, 2019 5:10 AM
> To: Hayes Wang
> Cc: grundler@chromium.org; netdev@vger.kernel.org; nic_swsd; Prashant
> Malani
> Subject: [PATCH net-next] r8152: Add identifier names for function pointers
> 
> Checkpatch throws warnings for function pointer declarations which lack
> identifier names.
> 
> An example of such a warning is:
> 
> WARNING: function definition argument 'struct r8152 *' should
> also have an identifier name
> 739: FILE: drivers/net/usb/r8152.c:739:
> +               void (*init)(struct r8152 *);
> 
> So, fix those warnings by adding the identifier names.
> 
> While we are at it, also fix a character limit violation which was
> causing another checkpatch warning.
> 
> Change-Id: Idec857ce2dc9592caf3173188be1660052c052ce
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

