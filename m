Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F958F951
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 04:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfHPC71 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Aug 2019 22:59:27 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52971 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfHPC70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 22:59:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7G2xI8R019537, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7G2xI8R019537
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 10:59:18 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Fri, 16 Aug
 2019 10:59:17 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Topic: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Index: AQHVUnqNDBLFc1N41kCW+rl5DeKpGqb8LWmAgADnKaA=
Date:   Fri, 16 Aug 2019 02:59:16 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D43A3@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <20190815.135851.1942927063321516679.davem@davemloft.net>
In-Reply-To: <20190815.135851.1942927063321516679.davem@davemloft.net>
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
> Sent: Friday, August 16, 2019 4:59 AM
[...]
> Theoretically, yes.
> 
> But do you have actual performance numbers showing this to be worth
> the change?
> 
> Always provide performance numbers with changes that are supposed to
> improve performance.

On x86, they are almost the same.
Tx/Rx: 943/943 Mbits/sec -> 945/944

For arm platform,
Tx/Rx: 917/917 Mbits/sec -> 933/933
Improve about 1.74%.

Best Regards,
Hayes


