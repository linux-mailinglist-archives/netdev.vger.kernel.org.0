Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF865EBCAE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiI0IEh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 04:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiI0IEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:04:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6485B6018
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:59:14 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mtapsc-2-TbeEpqk4Pl6H61nb9fZ9VQ-1; Tue, 27 Sep 2022 08:58:37 +0100
X-MC-Unique: TbeEpqk4Pl6H61nb9fZ9VQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 27 Sep
 2022 08:58:35 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Tue, 27 Sep 2022 08:58:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sean Anderson' <seanga2@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 07/13] sunhme: Convert FOO((...)) to FOO(...)
Thread-Topic: [PATCH net-next v2 07/13] sunhme: Convert FOO((...)) to FOO(...)
Thread-Index: AQHYz7ig+qNCRawu/kW9+5ipsBz0Rq3y7U4Q
Date:   Tue, 27 Sep 2022 07:58:35 +0000
Message-ID: <9412f706a4934d218019d74c5f4b74ae@AcuMS.aculab.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
 <20220924015339.1816744-8-seanga2@gmail.com>
In-Reply-To: <20220924015339.1816744-8-seanga2@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Anderson
> Sent: 24 September 2022 02:54
> 
> With the power of variadic macros, double parentheses are unnecessary.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
> Changes in v2:
> - sumhme -> sunhme
> 
>  drivers/net/ethernet/sun/sunhme.c | 272 +++++++++++++++---------------
>  1 file changed, 136 insertions(+), 136 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 7d6825c573a2..77a2a192f2ce 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -134,17 +134,17 @@ static __inline__ void tx_dump_log(void)
>  #endif
> 
>  #ifdef HMEDEBUG
> -#define HMD(x)  printk x
> +#define HMD printk

That probably ought to be:
	#define HMD(...) printk(__VA_ARGS__)

(and followed through all the other patches)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

