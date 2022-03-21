Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEA54E2CC7
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350539AbiCUPtE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Mar 2022 11:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349115AbiCUPtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:49:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63829606C0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 08:47:37 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-246-Ub5TnyEPOam9cnZmzS-F3A-2; Mon, 21 Mar 2022 15:47:34 +0000
X-MC-Unique: Ub5TnyEPOam9cnZmzS-F3A-2
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 21 Mar 2022 15:47:28 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 21 Mar 2022 15:47:28 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Lobakin' <alexandr.lobakin@intel.com>,
        Wan Jiabing <wanjiabing@vivo.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: use min() to make code cleaner in
 ice_gnss
Thread-Topic: [Intel-wired-lan] [PATCH] ice: use min() to make code cleaner in
 ice_gnss
Thread-Index: AQHYPRqWSkYKaVGfxkysTLMqXUCuZazJ+yGQ
Date:   Mon, 21 Mar 2022 15:47:28 +0000
Message-ID: <ff90ebe7eed741829dc03b2bf92a41f7@AcuMS.aculab.com>
References: <20220318094629.526321-1-wanjiabing@vivo.com>
 <8822dfa2-bdb8-fceb-e920-94afb50881e8@intel.com>
 <20220321115412.844440-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220321115412.844440-1-alexandr.lobakin@intel.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Use `min_t(typeof(bytes_left), ICE_MAX_I2C_DATA_SIZE)` to avoid
> this. Plain definitions are usually treated as `unsigned long`
> unless there's a suffix (u, ull etc.).

I suspect they are 'int'.
And the compiler will convert to 'unsigned int' in any
arithmetic.
And the 'signed v unsigned' compare warning is supressed
to integer constants.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

