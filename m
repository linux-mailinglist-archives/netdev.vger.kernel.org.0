Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54F143DD3
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAUNTe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jan 2020 08:19:34 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55649 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:19:34 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00LDJKrP014884, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00LDJKrP014884
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jan 2020 21:19:21 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Tue, 21 Jan 2020 21:19:20 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 21:19:20 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Tue, 21 Jan 2020 21:19:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net 2/9] r8152: reset flow control patch when linking on for RTL8153B
Thread-Topic: [PATCH net 2/9] r8152: reset flow control patch when linking on
 for RTL8153B
Thread-Index: AQHV0FhJcCUlEIvyF0ab5Vs8olnDhKf0jRWAgAAB4YCAAInrgA==
Date:   Tue, 21 Jan 2020 13:19:19 +0000
Message-ID: <49ab41a04ecf40c3baeed36746166a98@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
         <1394712342-15778-340-Taiwan-albertk@realtek.com>
         <20200121.135439.1619270282552230019.davem@davemloft.net>
 <aba420a3be9272236795dbc14380991bbf72c657.camel@perches.com>
In-Reply-To: <aba420a3be9272236795dbc14380991bbf72c657.camel@perches.com>
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

Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, January 21, 2020 9:01 PM
> To: David Miller; Hayes Wang
[...]
> > >  static int rtl8153_enable(struct r8152 *tp)
> > >  {
> > > +     u32 ocp_data;
> > >       if (test_bit(RTL8152_UNPLUG, &tp->flags))
> > >               return -ENODEV;
> > >
> >
> > Please put an empty line after the local variable declarations.
> 
> Local scoping is generally better.
> 
> Perhaps declare ocp_data inside the if branch
> where it's used.

OK. I would move it.

Best Regards,
Hayes
