Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2BADF041
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfJUOqZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Oct 2019 10:46:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:55809 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbfJUOqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:46:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-194-8mmcC7mCPo2YOUBN4MF_Xw-1; Mon, 21 Oct 2019 15:46:21 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 21 Oct 2019 15:46:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 21 Oct 2019 15:46:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yunsheng Lin' <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "mmanning@vyatta.att-mail.com" <mmanning@vyatta.att-mail.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when
 setting initial MTU
Thread-Topic: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when
 setting initial MTU
Thread-Index: AQHViAshdgiBu05N4kSdJcAPfvn0KKdlLGIQ
Date:   Mon, 21 Oct 2019 14:46:20 +0000
Message-ID: <8f07f4aad98e44358b92e1e340df131f@AcuMS.aculab.com>
References: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 8mmcC7mCPo2YOUBN4MF_Xw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin
> Sent: 21 October 2019 13:26
> Currently the MTU of vlan netdevice is set to the same MTU
> of the lower device, which requires the underlying device
> to handle it as the comment has indicated:
> 
> 	/* need 4 bytes for extra VLAN header info,
> 	 * hope the underlying device can handle it.
> 	 */
> 	new_dev->mtu = real_dev->mtu;
> 
> Currently most of the physical netdevs seems to handle above
> by reversing 2 * VLAN_HLEN for L2 packet len.

s/reverse/reserve/g

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

