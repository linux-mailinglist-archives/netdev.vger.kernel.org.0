Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA6B19B0
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 10:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387517AbfIMIg1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Sep 2019 04:36:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:44650 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387424AbfIMIg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 04:36:27 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-157-rwvhcf0CP16io7Sqh1YU_w-1; Fri, 13 Sep 2019 09:36:23 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 13 Sep 2019 09:36:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 13 Sep 2019 09:36:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Topic: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Thread-Index: AQHVZuRCrtt5derbnkaX0GdcwfdxAKck5i9wgAE3h4CAABM4AIACeq2egAChsYA=
Date:   Fri, 13 Sep 2019 08:36:22 +0000
Message-ID: <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
 <20190912225154.GF3499@localhost.localdomain>
In-Reply-To: <20190912225154.GF3499@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: rwvhcf0CP16io7Sqh1YU_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 12 September 2019 23:52
...
> Here it is more visible. If net->...ps_retrans is disabled, remaining
> fields (currently just this one, but as we are extending it now, we
> have to think about the possibility of more as well) will be ignored,
> we and we may not want that.

The only real way to add additional fields is to change the name
of the structure - that way recompiled programs still work.

You could require that programs zero the entire structure - but
that is difficult to verify.
And, in this case, it seems that the default has to be 0xffff
rather than 0 - which is, in itself, horrid.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

