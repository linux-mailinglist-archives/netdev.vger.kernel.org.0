Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC857857B4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389677AbfHHBkd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Aug 2019 21:40:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56818 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389044AbfHHBkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:40:32 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x781eRGZ001209, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x781eRGZ001209
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 8 Aug 2019 09:40:27 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0439.000; Thu, 8 Aug 2019 09:40:26 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and rx_max_agg_num dynamically
Thread-Topic: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
Thread-Index: AQHVTEjAduvqUw50CkySh6Q/0oky4abuKLuAgAEYyLD//9tQAIABWhmg
Date:   Thu, 8 Aug 2019 01:40:25 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D099A@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-294-albertk@realtek.com>
        <20190806151007.75a8dd2c@cakuba.netronome.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D06C5@RTITMBSVM03.realtek.com.tw>
 <20190807144346.00005d2b@gmail.com>
In-Reply-To: <20190807144346.00005d2b@gmail.com>
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

Maciej Fijalkowski [mailto:maciejromanfijalkowski@gmail.com]
> Sent: Wednesday, August 07, 2019 8:44 PM
[...]
> > Excuse me.
> > I find struct ethtool_tunable for ETHTOOL_RX_COPYBREAK.
> > How about the descriptor count?
> 
> Look how drivers implement ethtool's set_ringparam ops.

I would check it. Thanks.


Best Regards,
Hayes


