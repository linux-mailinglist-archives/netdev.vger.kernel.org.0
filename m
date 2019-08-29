Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7DFA0ECD
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 03:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfH2BI0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Aug 2019 21:08:26 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41192 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfH2BI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 21:08:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7T18IoE016184, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7T18IoE016184
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 09:08:19 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Thu, 29 Aug 2019 09:08:17 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v4 0/2] r8152: fix side effect
Thread-Topic: [PATCH net v4 0/2] r8152: fix side effect
Thread-Index: AQHVXaACVYgMyul7K0KKECR6PdUP2KcQrDCAgACk2oA=
Date:   Thu, 29 Aug 2019 01:08:16 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D9DBB@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
        <1394712342-15778-323-Taiwan-albertk@realtek.com>
 <20190828.161735.1528060932193718727.davem@davemloft.net>
In-Reply-To: <20190828.161735.1528060932193718727.davem@davemloft.net>
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

David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, August 29, 2019 7:18 AM
[...]
> > v4:
> > Add Fixes tag for both patch #1 and #2.
> 
> I applied v3, sorry.
> 
> I think it is OK as I will backport things to v5.2 -stable anyways.

Thanks.

Best Regards,
Hayes


