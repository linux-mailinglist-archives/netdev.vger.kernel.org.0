Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3A7132706
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgAGNFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:05:39 -0500
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:59521
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726937AbgAGNFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:05:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PezCMXuVO1xq52nMgk2dWuGOHhfTP0AVyX/YTx8zExIKkS8yHocZj4I9WVxMWW8Gxd92+uI5BeHadgtReYgYqJ4cJXKwgwYyKNIejuAo2rzs6svBR2oJzLhhpksE8Swc1tsc7oZQbsmwlU9lEBnrJ+Xzq6cYnjjsYh9+BaqThDc/QVPOrwqECQHzA4slzOLmKolm7I121k/FD77j/xg1EFth6nKiHf2SDmFdooXWMem2c4h+cMKUX5y1b5SXxWqtCbhkneXgRKoqokrVE31HHUhYDArmd1rLfKMTwXLD/BCz9KBtmCDq4xjlILZvwgF+r9Bci1ja5LJoulwG8Yk5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUoeBKPkG14mZSzojFetdp818CFXZfx7O4XuDuxSfQQ=;
 b=ggMTZ/0/NZ46kLLQ12vVZ2aYWavRIwV3bR4YnRkjhony4N9np4OyBtVhHbJ2aDOUJ/bYzYQWD15lOrBDCoSUgBjsFAiD4nYaWbWObH3SNvvqIvUJx5swwBKg6St1n+jwO1c4bYYwZY37E4P6AahN6cJZ8acKbYlODHTntN3XAfbRlu1je3hg+C/5t7bufu1U1MCp7vA3v3heWhD4t6IdgVUdS4jpXCFgw3PP3vafrywymPJS7mvILCmEpavCCdOkPjwLrKrmOe6yEeA0aAyZatgSYbKqghjnc1svHEzXI1v4A0EYIOKlSGhYIo2ET/2W7ig3oZAyGnz7m68C9/xQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ch.abb.com; dmarc=pass action=none header.from=ch.abb.com;
 dkim=pass header.d=ch.abb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ch.abb.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUoeBKPkG14mZSzojFetdp818CFXZfx7O4XuDuxSfQQ=;
 b=l17yc0Fa4kS2+uyj4ZVcts6Xxwrw7B7axANKZl9Ae1tTQ7Yv0ktzD+eg7uULug6UwJYshCC4RoW+jJ0ABh1pA3w73xuimQ57OBlQ68b9dRd25mGQ9xKgkJJy0D20XJ8rFHhgDY5qRsx5hgJTFGMQQxlHTlZ5A+WDuObg2ZGBV2A=
Received: from AM0PR06MB5427.eurprd06.prod.outlook.com (20.178.23.156) by
 AM0PR06MB4307.eurprd06.prod.outlook.com (52.135.150.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 13:05:35 +0000
Received: from AM0PR06MB5427.eurprd06.prod.outlook.com
 ([fe80::bde5:65c9:a39a:23c4]) by AM0PR06MB5427.eurprd06.prod.outlook.com
 ([fe80::bde5:65c9:a39a:23c4%5]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 13:05:35 +0000
From:   Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "sux@loplof.de" <sux@loplof.de>
Subject: Freescale network device not activated on mpc8360 (kmeter1 board)
Thread-Topic: Freescale network device not activated on mpc8360 (kmeter1
 board)
Thread-Index: AQHVxVqfalFIjdyzCE+lQXaLrMtWbA==
Date:   Tue, 7 Jan 2020 13:05:35 +0000
Message-ID: <AM0PR06MB5427E4BDF8FB1BEC5DF3D45FB33F0@AM0PR06MB5427.eurprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matteo.ghidoni@ch.abb.com; 
x-originating-ip: [80.254.155.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 679a531e-9c09-4bf3-07e6-08d79372492d
x-ms-traffictypediagnostic: AM0PR06MB4307:
x-microsoft-antispam-prvs: <AM0PR06MB430704AD0F00BA6AB9A6C049B33F0@AM0PR06MB4307.eurprd06.prod.outlook.com>
x-abb-o365-outbound: ABBOUTBOUND1
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(53754006)(199004)(189003)(2906002)(66446008)(66476007)(66556008)(6506007)(54906003)(64756008)(33656002)(26005)(66946007)(5660300002)(316002)(7696005)(86362001)(186003)(4744005)(81156014)(9686003)(8676002)(44832011)(81166006)(8936002)(55016002)(52536014)(4326008)(71200400001)(478600001)(76116006)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4307;H:AM0PR06MB5427.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: ch.abb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v9ufTtakGChkw91i/n1uMtksOsn5aIBLCW4suvgYl5B1QoMN6GTrlqE9SngAl5wsEH/EfMACuhDmiShZ+ru4IbPtZmGAlHhyAeH2Zr88ac+SbbE/C5WP1cccvr/VC0tjlUUYQTXbt4ZD8X09j2GzmExxarx98TTOiSevvyZCuY/t1xvBkFZXzah+RhIY8MRu8WVZdil9oFXkg+4NfEeQoH4E/PUzE9VSg8HQk0hHTBxz24FV8dt2NuOl5H+gHF2z0o4SFmMtyMJiNhyL7qCl7tXaxxZ9is728nZSgkoiP+lS3Xp8pnKDk3nqL8hHJq+GozsX1YRbXpFh/RzxXU+9ZiSzn/PcF/5YKWW9BmT0QV81zbQMiGNb/Dhjs4UnT9hC+gh30VwB9wRentxIhBAzMPYkOOwrcLRgkCQEWRgm2mhAdiHNTIhNvy2aZ6oBCMs30XX/A9GoBszDHg1AH1QvZyT8COrLtuP5gTki2ZxBoByY2C6f/+iPDIVvY8v5Tvx+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ch.abb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679a531e-9c09-4bf3-07e6-08d79372492d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 13:05:35.8647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 372ee9e0-9ce0-4033-a64a-c07073a91ecd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOXXIyFvstWmrJv2XL4YVTHr4r0j7OMky+5riiql9t7TPqak0twtIVDWJ43bzsxnP7OoSZ/cDWYuQRt5TLOF+8Rk5fV3cxshB8J7A0YaO+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Hi all,=0A=
=0A=
With the introduction of the following patch, we are facing an issue with t=
he activation of the Freescale network device (ucc_geth driver) on our kmet=
er1 board based on a MPC8360:=0A=
=0A=
commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c=0A=
Author: Heiner Kallweit <hkallweit1@gmail.com>=0A=
Date:   Tue Sep 18 21:55:36 2018 +0200=0A=
=0A=
    net: linkwatch: add check for netdevice being present to linkwatch_do_d=
ev=0A=
=0A=
Based on my observations, just before trying to activate the device through=
 linkwatch_event, the controller wants to adjust the MAC configuration and =
in order to achieve this it detaches the device. This avoids the activation=
 of the net device.=0A=
=0A=
This is already happening with older versions (I checked with the v4.14.162=
) and also there the situation is the same, but without the additional chec=
k in the if condition the device is activated.=0A=
=0A=
I am currently working with the v5.4.8 kernel version, but the behavior rem=
ains the same also with the latest v5.5-rc4.=0A=
=0A=
Any idea how to solve this? Any help is appreciated.=0A=
=0A=
Regards,=0A=
Matteo=
