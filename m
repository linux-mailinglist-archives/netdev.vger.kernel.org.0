Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E39C27D239
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgI2PLm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 11:11:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:42748 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728492AbgI2PLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:11:41 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-28-peFoqWncPGeZcDYPQGIbZQ-1; Tue, 29 Sep 2020 16:11:37 +0100
X-MC-Unique: peFoqWncPGeZcDYPQGIbZQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 29 Sep 2020 16:11:36 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 29 Sep 2020 16:11:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kai-Heng Feng' <kai.heng.feng@canonical.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
Thread-Topic: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
Thread-Index: AQHWlnJo3jkmQwoppkWC/w40eQtvY6l/uKNw
Date:   Tue, 29 Sep 2020 15:11:36 +0000
Message-ID: <f8bd6a07276a4289b102118a132bd793@AcuMS.aculab.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200928083658.8567-1-kai.heng.feng@canonical.com>
 <469c71d5-93ac-e6c7-f85c-342b0df78a45@intel.com>
 <30761C6B-28B8-4464-8615-55EF3E090E07@canonical.com>
 <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
 <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
In-Reply-To: <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hope we finally have proper ME support under Linux?

How about a way to disable it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

