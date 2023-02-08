Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8250768F0F0
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjBHOhn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Feb 2023 09:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjBHOhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:37:42 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAB1E2B2
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:37:36 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-285-CCJm7qh4OPWJR4mgPmXp4w-1; Wed, 08 Feb 2023 14:37:33 +0000
X-MC-Unique: CCJm7qh4OPWJR4mgPmXp4w-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.45; Wed, 8 Feb
 2023 14:37:32 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.045; Wed, 8 Feb 2023 14:37:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Simon Horman' <simon.horman@corigine.com>,
        Alexandra Winter <wintera@linux.ibm.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
Subject: RE: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
Thread-Topic: [PATCH net-next 4/4] s390/qeth: Convert sprintf/snprintf to
 scnprintf
Thread-Index: AQHZOwraK1QTWCBVLECBV6pybcO3eq7FHqew
Date:   Wed, 8 Feb 2023 14:37:32 +0000
Message-ID: <63c6825fc2c94ad19ac7de93a6f151f6@AcuMS.aculab.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
 <20230206172754.980062-5-wintera@linux.ibm.com>
 <Y+JxcPOJiRl0qMo1@corigine.com>
In-Reply-To: <Y+JxcPOJiRl0qMo1@corigine.com>
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
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman
> Sent: 07 February 2023 15:43
...
> However, amongst other usages of the return value,
> those callers also check for a return < 0 from this function.
> Can that occur, in the sprintf or scnprintf case?

That rather depends on what happens with calls like:
	snprintf(NULL, 0, "*%s%*s", MAX_INT, "", MAX_INT, "");

That is a whole bag of worms you don't want to put your hand into.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

