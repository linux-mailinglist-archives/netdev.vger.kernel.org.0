Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB99D674661
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjASWxW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Jan 2023 17:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjASWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:52:55 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91376A95A2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:35:18 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-150-wtFC9NvyNHatWG_8bqruuw-1; Thu, 19 Jan 2023 22:34:34 +0000
X-MC-Unique: wtFC9NvyNHatWG_8bqruuw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 19 Jan
 2023 22:34:33 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Thu, 19 Jan 2023 22:34:33 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tony Nguyen' <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: RE: [PATCH net-next 14/15] ice: Introduce local var for readability
Thread-Topic: [PATCH net-next 14/15] ice: Introduce local var for readability
Thread-Index: AQHZLE8S21tdpZCRDkevzrtyZTzfE66mUstA
Date:   Thu, 19 Jan 2023 22:34:33 +0000
Message-ID: <203fcd4954e14afbb9d21fcd27ac7458@AcuMS.aculab.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
 <20230119212742.2106833-15-anthony.l.nguyen@intel.com>
In-Reply-To: <20230119212742.2106833-15-anthony.l.nguyen@intel.com>
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

From: Tony Nguyen
> Sent: 19 January 2023 21:28
> 
> Based on previous feedback[1], introduce a local var to make things more
> readable.
> 
> [1] https://lore.kernel.org/netdev/20220315203218.607f612b@kicinski-fedora-
> pc1c0hjn.dhcp.thefacebook.com/
...
> -	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
> +	mutex_destroy(&hw->fdir_fltr_lock);

The 'uncrazy' version is:
	mutex_destroy(&pf->hw.fdir_fltr_lock);

No need for a local.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

