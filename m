Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69AD7DFEB
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 18:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfHAQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 12:16:44 -0400
Received: from mail-eopbgr1310102.outbound.protection.outlook.com ([40.107.131.102]:7518
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727885AbfHAQQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 12:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWmCum1/CvPb77Su4/ORrNp01uEeh+sEHvkfXMoELVMx+oE1mfYGRBrU/HxcmK4TQ/eJ6QMH9jVOESyjTBx/6uF3LPBA+40zmSrYMy0Inpqh9X1PwTJImE5AWPlVdcnQ83E0w1Fkg8zDuiCNQwmXAZbk7fbwJbAyJYm5oSp76gvwLdyZ9frL1uJ81XpZ46nYUuhoMrmbkwwR8BHp8xeMoU0x2OrffEADlIpHRv1jejdQC5xkay9YzfYoqqiWRExO6BGbSIFXogU9WO8IonOj4NuDqlJVKOszy1hLIAnzHOV5/hstuQNE0c9zhy3sg4puRHKi0VOGwtGJq9rWtjGfag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/7Bp29L4cYlWioEx7CP1pg43dGk+nE7SkOmQ3BfUlI=;
 b=mceDIaqG+GfbOHmAFJKgryB8FyvIOHbk9MBnVLl9yeNLoRAA6kxpGu4c4PqtHCWEoocNmH2tk/4KMKieXq9XEgUHoyNdA9FkG39CofKhFArutKy4E5SLkqn2qmTl0EtC9fEm32igNLOyMwgD1nZj0WSVxCBNpjfl11Hr1RnoChXoZBza1R0UckLhcBp60wJih3ERTFbqYA/Q0R14qxirxNStGIj8aueq/oL/RbPRfTbSOyVapMd6EA0fb3VFKE07/sjMnr49n0qpGRu7Rik6wKJyi9o9OcHmYJYkgcTfkL6lXl8eP3dghIdS0pHnpcGC+2tKRrU26Xvdp33G4g5fTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/7Bp29L4cYlWioEx7CP1pg43dGk+nE7SkOmQ3BfUlI=;
 b=gDPsHP45Cx2KFMW5nq3UalwXvP5fV2U0yF85JOOcKcLhlDWIRYoPTAcivoaxP2bVp3px81MDFiZ6iYLL4h7FKo38FnOe4hRVyN9kW11/w2thwnqk65iez8ELN7KUwT5p94PUZ2im8QCG/4o69Oew1rt1cd3jW5Bs0/ZB6LkgiuE=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Thu, 1 Aug 2019 16:16:37 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Thu, 1 Aug 2019
 16:16:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 00/11] VSOCK: add vsock_test test suite
Thread-Topic: [PATCH v2 00/11] VSOCK: add vsock_test test suite
Thread-Index: AQHVSH1oyNMGwOsBlk2yUfB0Nho2J6bmd0rg
Date:   Thu, 1 Aug 2019 16:16:37 +0000
Message-ID: <PU1P153MB0169B265ECA51CB0AE1212DEBFDE0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190801152541.245833-1-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-01T16:16:34.7794498Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=1a9f8a58-5882-44cf-939e-d69466f2ea74;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:bd98:1395:3c14:560a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e7541f1-6fdd-428e-0e61-08d7169ba131
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0153;
x-ms-traffictypediagnostic: PU1P153MB0153:
x-microsoft-antispam-prvs: <PU1P153MB01535C72982EB1296915DDE6BFDE0@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(199004)(189003)(305945005)(102836004)(256004)(74316002)(14454004)(6246003)(478600001)(6506007)(229853002)(68736007)(53936002)(55016002)(9686003)(46003)(6436002)(476003)(11346002)(10290500003)(186003)(486006)(446003)(71200400001)(71190400001)(10090500001)(4744005)(8990500004)(2906002)(6116002)(2501003)(5660300002)(7696005)(81156014)(99286004)(81166006)(8676002)(7736002)(33656002)(76176011)(66556008)(66446008)(52536014)(8936002)(64756008)(76116006)(66946007)(22452003)(66476007)(25786009)(110136005)(316002)(86362001)(54906003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SVph8nurYgyy/7OHrFNrT4H/MT8tqvH3UucOUJelIy52UDI5kixK21ynV1jp35TlAKTXc7xoR9PdCX9xVucyHxdO9WTUZhW+D+iFUdL+qeCafO4uubcIEiM0/KndIXaTWss8GO15ZLHSPEaw4TYVnSxFfF8Oi8xmwgBqhtkM7xmo/qsUIMG6sw1iWruFFMKlUj43fJgFa7ojwox459HzaHd32AXP6BG+UbaZLi81B3h0Y4nhkAMPDTssh/KNPtfxWtKMzTGKBjbhYWZk+tW073vOxwmJHlqt/m7mTqDg7BK6KBqZLRDRCsMQFtDNfrTPs1n7zYY2pGye7Pn7ZGM8S7lsWRmfiaV6gPVnBluDdj7ezdLEvUPAmJX8bkJcU1168nFq+tIraNXcfEF90ccHVWGj++EBhX8IUqwAB2UXMvE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7541f1-6fdd-428e-0e61-08d7169ba131
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 16:16:37.2785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fMgBp0geK0pOeuLJK+kva/hN+cPXpVX2xUGBQ/7FpTlO8is92yBHw3SUNzMNPBTlkIMG0rkfgqYPR8TSwqiWcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Thursday, August 1, 2019 8:26 AM
>=20
> The vsock_diag.ko module already has a test suite but the core AF_VSOCK
> functionality has no tests.  This patch series adds several test cases th=
at
> exercise AF_VSOCK SOCK_STREAM socket semantics (send/recv,
> connect/accept,
> half-closed connections, simultaneous connections).
>=20
> Dexuan: Do you think can be useful to test HyperV?

Hi Stefano,
Thanks! This should be useful, though I have to write the Windows host side
code to use the test program(s). :-)

Thanks,
-- Dexuan
