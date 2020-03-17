Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3DD187DDC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 11:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCQKK7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Mar 2020 06:10:59 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:52531 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgCQKK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 06:10:59 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-253-m8c9lr4xM2eSzCLFFXrRRA-1; Tue, 17 Mar 2020 10:10:53 +0000
X-MC-Unique: m8c9lr4xM2eSzCLFFXrRRA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 17 Mar 2020 10:10:53 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 17 Mar 2020 10:10:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>,
        "wei.zheng@vivo.com" <wei.zheng@vivo.com>
CC:     "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "yeyunfeng@huawei.com" <yeyunfeng@huawei.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "info@metux.net" <info@metux.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@vivo.com" <kernel@vivo.com>,
        "wenhu.wang@vivo.com" <wenhu.wang@vivo.com>
Subject: RE: [PATCH] net: vxge: fix wrong __VA_ARGS__ usage
Thread-Topic: [PATCH] net: vxge: fix wrong __VA_ARGS__ usage
Thread-Index: AQHV+97YYm2kZGPR3k6KR+yWy8keoqhMkFUA
Date:   Tue, 17 Mar 2020 10:10:53 +0000
Message-ID: <e61d7621d4ac4b909fda59f234d587fa@AcuMS.aculab.com>
References: <20200316142354.95201-1-wei.zheng@vivo.com>
 <20200316.150416.703162062113777580.davem@davemloft.net>
In-Reply-To: <20200316.150416.703162062113777580.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > printk in macro vxge_debug_ll uses __VA_ARGS__ without "##" prefix,
> > it causes a build error when there is no variable
> > arguments(e.g. only fmt is specified.).
> >
> > Signed-off-by: Zheng Wei <wei.zheng@vivo.com>
> 
> Does this even happen right now?  Anyways, applied.

I thought most of the compilers removed the lurking ','
using some heristic.

A safer alternative is to include the 'fmt' in the ...
then there is always one argument.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

