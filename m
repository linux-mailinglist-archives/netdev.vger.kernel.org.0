Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C822275226
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 09:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIWHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 03:09:12 -0400
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:31744
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726550AbgIWHJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 03:09:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFf7GU2FDVVnnY9sKS/cWwq2tf/CfPXVbQKNjwOfLb/5KEzer8GQmSS/JB1h01s1UIH+PHDeTa0IraXe1Fzwh1sUp7bYkD9MMA8e5W0WNWSl5slSbKaoYasOMak/oY8O5eSlcrQ2iBzYKff4hDBQyPGQBuzdGu6eVGGzdJnPMmYlfPwVPGfiUi1dD3GIsRSWEaBGWhS1hoKO9YZzIMkit51XgJqhIIYAkQDtmPvDPLqW8sgOzKNdW22jk4YVVvAYGRMLx/y8Iia4c2o1o4BquvbBk4OTgOVAAK4uQK9+4AjsV+qlmoPRNJ6oEEKMAr6zEdHmZp4qWA52Rm0ae8KERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIvZRZ3JDfDF+9gvJdKWgb97LoYMpBwQZ6pvtMMTtHo=;
 b=hPk4RkNDbhzR9fSc8mZGJF4UgO4UDjg7T6D7PMmY+bHyl8j++xUaL7OVCeZYwZt+bye8QKm5fZ+dn8oPVcNHyQ4ltaga5maQoa9RgbYjOPGnWjE+YJUPNVCzN6i30kT2+0z07qg2dSWZiVoS3u/OmB0Em8oNO7g8QQVBwLLjY6bJh/tlyoWS4seDLSM++njTQPWC68fEJrXV9uTdMugTqyiNVMOQxBMSlGlISXd1h1VHqbS5vKp5OG0v8O9s5h/hGgsSRShi6VHa6z8Upw2RqeqE96k2oDpz3Vcjm+Ye4ZGjwBk3jkU8saDm7TrCRUh52swFGrswOJwi5IheWL8R6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIvZRZ3JDfDF+9gvJdKWgb97LoYMpBwQZ6pvtMMTtHo=;
 b=bLt4iQWKfgRRjRlcP6kBj87ic0AGc8CfBlL2Q2BVUWtPbKO60UhZY9C/0EwOxpUnCAH2k0YNPGi1FhAVWBJOhqelp4ZaZjLdKCH9VeH1XACLqcCNXnupsijZBjBvL0RbN5EstNHrZnQzDoSRjpi6FNdSOCV8xCbBpzQvoncrZY0=
Received: from BYAPR05MB4839.namprd05.prod.outlook.com (2603:10b6:a03:42::13)
 by BYAPR05MB5653.namprd05.prod.outlook.com (2603:10b6:a03:1a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.11; Wed, 23 Sep
 2020 07:09:09 +0000
Received: from BYAPR05MB4839.namprd05.prod.outlook.com
 ([fe80::4cec:47f6:a0be:8304]) by BYAPR05MB4839.namprd05.prod.outlook.com
 ([fe80::4cec:47f6:a0be:8304%6]) with mapi id 15.20.3391.025; Wed, 23 Sep 2020
 07:09:09 +0000
From:   Abdul Anshad Azeez <aazees@vmware.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC:     "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: Performance regressions in networking & storage benchmarks in
 Linux kernel 5.8
Thread-Topic: Performance regressions in networking & storage benchmarks in
 Linux kernel 5.8
Thread-Index: AQHWkLxv33yBR7j1VE2lVgq0lG/dkKl0hMqAgAFKF7s=
Date:   Wed, 23 Sep 2020 07:09:09 +0000
Message-ID: <BYAPR05MB4839B5A2091ABE8AF2D8F87BA6380@BYAPR05MB4839.namprd05.prod.outlook.com>
References: <BYAPR05MB4839189DFC487A1529D6734CA63B0@BYAPR05MB4839.namprd05.prod.outlook.com>,<87h7rqaw8u.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87h7rqaw8u.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [183.82.217.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a74d1df8-5e77-4d5d-f459-08d85f8f910c
x-ms-traffictypediagnostic: BYAPR05MB5653:
x-microsoft-antispam-prvs: <BYAPR05MB5653E8BEEE58BF9BFEB397ABA6380@BYAPR05MB5653.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: shPa3M9aHlaiObORuKOm9PeQyOBB7bxRdwD88OZGgMZXt/pVvfHINROu0QecN2zHyVkWaOms9voZImuKOctyqvpSKAhSWJK0p0KlfdIjPHk+0QKMYbnUDZEyQ9TWJ+cKSNMKCiyJ2blVZxks+xJa0rjQmpCwCFl8ronpWlyAbqGYwXriduKIjciu96xk2MEkrjFKGWAr6nv6nRtHbyXyx4iYmfsGJ388BMOZaW2ATCrIXaK2O/c8oxsW0YxtYdh7pMLP+ME40Tg1QYIqF0cRQeI601mtsoexOGF1cyJHxPD6ln3NnBQlrbDssQ3kD0jAffqjDrI15EXSRNg3V61PAPNtlNXv8ljtRUH6PgU/hWE1SqUUH+2hP1UdabjkO/D1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB4839.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(53546011)(316002)(86362001)(26005)(6506007)(478600001)(7696005)(5660300002)(83380400001)(33656002)(2906002)(55016002)(9686003)(66476007)(186003)(64756008)(8676002)(76116006)(66946007)(4326008)(8936002)(71200400001)(66446008)(91956017)(110136005)(66556008)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0wLvUhzO/79Ykt0mprz1j/uvO5FXaONgvoNmOSCAJYSMeRtQQBiAgu6Br0dR46812654SH9KQJAMEtrh6c+OlsV7kGPrqRJgpccZnYVeo7u2iV8uHKioxS77c6j0hAmZypv0x/xJysXAEdaNJOrKtgGLgOjDIxKliMcZKweV7cfk2W76ri95ZVLD+6zTNBvBQkgsIt+Lb9xsPwP2ETuVQyP1wl7XyDky6j1Sn+0vdj6pdbgFrXNGiMLgP3M0zfkT4zG/QNa/7Kx5eohtjIb/5gSRe6wOqU5juh/V4S8UsX25aq4QqUEaRgYiDlObQHMsDWSVMxf9EyALs33FvLF9DkFZrG7RgC25zfQ3EQ34yk23CeImqeUnCqI5rfJNnCKXuyLMNPGABCc3SPkDS3rjIiW+ZF/8UxncGoNkeCfvfgZeLcRJuYWQQlrfU7xLsjhw65HNlwirdotRjp4m5DDjwUjYL5F+UPv2LtX5aFd5Uz21nv9Rj3C/bpUHRzpyLpZPeLZwxP/qOG8pn/FtkFlhKrw6blvdC69ivI5rxrpqGdPLMGauKgxoEQMGET0zF3SyfhxupdBbxY/FwTdWaXvhlP4qJwyRk7OLgGj37dhLofjNoM+WGqhbr7WoEi1y4pL0AVyUUqtYXYRyIqx4Fy8mEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB4839.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a74d1df8-5e77-4d5d-f459-08d85f8f910c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 07:09:09.0143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Me7KX6whOV1j1/o2/aBTVhL/5+lygkL4oWYa2nH3TV8gue3NEj+Lt9r5pPh8S83538jHbTZJ1/Y9XkrmI8j8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Thomas,=0A=
=0A=
Thank you very much for your comments.=0A=
=0A=
Since the performance regressions were fixed when we tested version 5.9-rc4=
, we =0A=
were not reporting it as an issue and our intention was just to share this =
as an=0A=
 information only.=0A=
=0A=
Thanks,=0A=
Abdul Anshad A=0A=
=0A=
=0A=
From: Thomas Gleixner <tglx@linutronix.de>=0A=
Sent: Tuesday, September 22, 2020 04:55 PM=0A=
To: Abdul Anshad Azeez <aazees@vmware.com>; linux-kernel@vger.kernel.org <l=
inux-kernel@vger.kernel.org>; x86@kernel.org <x86@kernel.org>; netdev@vger.=
kernel.org <netdev@vger.kernel.org>; linux-fsdevel@vger.kernel.org <linux-f=
sdevel@vger.kernel.org>=0A=
Cc: rostedt@goodmis.org <rostedt@goodmis.org>=0A=
Subject: Re: Performance regressions in networking & storage benchmarks in =
Linux kernel 5.8 =0A=
=A0=0A=
Abdul,=0A=
=0A=
On Tue, Sep 22 2020 at 08:51, Abdul Anshad Azeez wrote:=0A=
> Part of VMware's performance regression testing for Linux Kernel upstream=
 rele=0A=
> ases we compared Linux kernel 5.8 against 5.7. Our evaluation revealed pe=
rform=0A=
> ance regressions mostly in networking latency/response-time benchmarks up=
 to 6=0A=
> 0%. Storage throughput & latency benchmarks were also up by 8%.=0A=
> In order to find the fix commit, we bisected again between 5.8 and 5.9-rc=
4 and=0A=
>=A0 identified that regressions were fixed from a commit made by the same =
author =0A=
> Thomas Gleixner, which unbreaks the interrupt affinity settings - "e027ff=
fff79=0A=
> 9cdd70400c5485b1a54f482255985(x86/irq: Unbreak interrupt affinity setting=
)".=0A=
>=0A=
> We believe these findings would be useful to the Linux community and want=
ed to=0A=
>=A0 document the same.=0A=
=0A=
thanks for letting us know, but the issue is known already and the fix=0A=
has been backported to the stable kernel version 5.8.6 as of Sept. 3rd.=0A=
=0A=
Please always check the latest stable version.=0A=
=0A=
Thanks,=0A=
=0A=
=A0=A0=A0=A0=A0=A0=A0 tglx=
