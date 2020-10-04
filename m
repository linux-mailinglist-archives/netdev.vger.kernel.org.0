Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3A1282AAE
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgJDMqh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 4 Oct 2020 08:46:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55342 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgJDMqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 08:46:36 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-47-qFJxgmO8NUGEup_ozz1NHg-1; Sun, 04 Oct 2020 13:46:32 +0100
X-MC-Unique: qFJxgmO8NUGEup_ozz1NHg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 4 Oct 2020 13:46:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 4 Oct 2020 13:46:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ido Schimmel' <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "ayal@nvidia.com" <ayal@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next v2] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Thread-Topic: [RFC PATCH net-next v2] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Thread-Index: AQHWmjeZDLJ97O2AFE+A2C6BJXvEbamHY8+g
Date:   Sun, 4 Oct 2020 12:46:31 +0000
Message-ID: <07b469aea4494fdeb11f4915459540a4@AcuMS.aculab.com>
References: <20201004101707.2177320-1-idosch@idosch.org>
In-Reply-To: <20201004101707.2177320-1-idosch@idosch.org>
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

From: Ido Schimmel
> Sent: 04 October 2020 11:17
> 
> With the ioctl interface, when autoneg is enabled, but without
> specifying speed, duplex or link modes, the advertised link modes are
> set to the supported link modes by the ethtool user space utility.
...
> Fix this incompatibility problem by introducing a new flag in the
> ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> the flag is to indicate to the kernel that it needs to be compatible
> with the legacy ioctl interface. A patch to the ethtool user space
> utility will make sure the flag is always set.

You need to do that the other way around.
You can't assume the kernel and application are updated
at the same time.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

