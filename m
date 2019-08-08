Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D485D63
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbfHHIw5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 04:52:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34321 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfHHIw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 04:52:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x788qqvi016329, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x788qqvi016329
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 8 Aug 2019 16:52:53 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 8 Aug
 2019 16:52:51 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and rx_max_agg_num dynamically
Thread-Topic: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
Thread-Index: AQHVTEjAduvqUw50CkySh6Q/0oky4abuKLuAgALKe5A=
Date:   Thu, 8 Aug 2019 08:52:51 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D0D8E@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-294-albertk@realtek.com>
 <20190806151007.75a8dd2c@cakuba.netronome.com>
In-Reply-To: <20190806151007.75a8dd2c@cakuba.netronome.com>
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

Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> Sent: Wednesday, August 07, 2019 6:10 AM
[...]
> On Tue, 6 Aug 2019 19:18:04 +0800, Hayes Wang wrote:
> > Let rx_frag_head_sz and rx_max_agg_num could be modified dynamically
> > through the sysfs.
> >
> > Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> Please don't expose those via sysfs. Ethtool's copybreak and descriptor
> count should be applicable here, I think.

Excuse me again.
I find the kernel supports the copybreak of Ethtool.
However, I couldn't find a command of Ethtool to use it.
Do I miss something?

Best Regards,
Hayes

