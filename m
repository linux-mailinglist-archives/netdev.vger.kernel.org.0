Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC17D411
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfHADu1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 31 Jul 2019 23:50:27 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51915 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHADu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 23:50:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x713oNq1011577, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x713oNq1011577
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 1 Aug 2019 11:50:23 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0439.000; Thu, 1 Aug 2019 11:50:23 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kevin Lo <kevlo@kevlo.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] r8152: fix typo in register name
Thread-Topic: [PATCH net] r8152: fix typo in register name
Thread-Index: AQHVSBnx4tIb950KqkiLftgBqq9xpKblpvVg
Date:   Thu, 1 Aug 2019 03:50:21 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18CD97D@RTITMBSVM03.realtek.com.tw>
References: <20190801032938.GA22256@ns.kevlo.org>
In-Reply-To: <20190801032938.GA22256@ns.kevlo.org>
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

> From: Kevin Lo [mailto:kevlo@kevlo.org]
> Sent: Thursday, August 01, 2019 11:30 AM
> To: Hayes Wang
> Cc: netdev@vger.kernel.org
> Subject: [PATCH net] r8152: fix typo in register name
> 
> It is likely that PAL_BDC_CR should be PLA_BDC_CR.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes


