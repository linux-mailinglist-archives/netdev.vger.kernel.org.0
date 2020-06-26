Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B60E20ABBC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgFZFNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:13:19 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:32225
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgFZFNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 01:13:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQ0yXt3DxSaDKDgm6e8dGEDUE+iPKd9ISqMKLEKfSmxbVvvY7WoUCPoP2Mc7Kdj3zBn+beLAk77RxNNeC3aHd7rRdLPqB8OBdiG9N0MztCFovwWHcNXcNLLXphTjAtbIi6YvZ06DKUdZT616OGjVuTbyPWUJcGnFHsaR/NyCMhQyX1/wZmUBdX9KCu9+51elig4o70GeP+uSZOZBRcrp873dUpzgNDk6OgNMTNz2y6k5GN9b2EKgZWNmCMQpPGEQ2jlJVEpW+bks9QhDKI5JF1GKYEQkqd2NKGGDCamCQwrYn0VAdRrWkswJtLZq9ziBnOr3OTfPjW0/FNjrWjVcVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvPWw3lN1OQuix/bnLWwd1hMQoUgF5jYYwKRp+L65wE=;
 b=OxK10VHPfr/EX3moCuMIC74P1FgXwKQDjCQ1EZJM59d6Vrx4ggrC25U91Upv1eL3s7u9WLWFbGTjX7TvmpnK4cn3R4MqilaQso/QIuMbH2wruj1kjm4LMKYeApQ1CnVEOPI2+03IizBMcKZW5edodn98diun0ApFfGcsNV2+acEK2IKmJdY7Vr1UDbVi5/zwf9B7KRLHMSEJcMCgoUAmOivGgTDJ4dHkd4ReUh79TwkAK0huKXgjOjm+WoBVfWwqqnSNLTK9bpWKZur8wtrsZ/Zf4RbHPdQnLIAfJU1CivCImhOcbBxlLxjG8n8QgHlkhGv64Nwm8kSCgVeNdP/fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvPWw3lN1OQuix/bnLWwd1hMQoUgF5jYYwKRp+L65wE=;
 b=QOHHNReFtjbTDsJuH+39fxCtYsbos9LTgIJWOUVzfHt1GgoA9Dn0jfmcYCqms4uuaHbIyU0VcUr75HWlCmspim5GNDSKLbaroPfad/d97HQHxpegPyR32V0pLwQedShap5sT3/uFdM8Bb5EW26wNzUzO8RG4rr9Hoc5UHAT8Th0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4628.eurprd05.prod.outlook.com (2603:10a6:208:ae::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 05:13:15 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 05:13:15 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>
Subject: RE: [PATCH iproute2-next 0/4] devlink: Support get,set mac address of
 a port function
Thread-Topic: [PATCH iproute2-next 0/4] devlink: Support get,set mac address
 of a port function
Thread-Index: AQHWSUtS0T3BXoXDzkGg9cvwqSd2dajqXg+g
Date:   Fri, 26 Jun 2020 05:13:15 +0000
Message-ID: <AM0PR05MB4866887EA8E214F9B21C04B0D1930@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200623104425.2324-1-parav@mellanox.com>
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [122.172.101.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f80ecabc-29c0-4114-22db-08d8198fa198
x-ms-traffictypediagnostic: AM0PR05MB4628:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB462840218AF4B6E5D60AEADCD1930@AM0PR05MB4628.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rJ4R8yNoc2W370NmyY5ReClKrMk7T4WcvXCqaKDhtkYXyz1ZoDeFAkO+/zZk/hY1mYgHuUtP5ejCSbH4Ol4CVEZ76D25zNkNyih/jCUNan+RJavORUX0FjlKd/ArgB29V6SmHTG5yatuTYCSB70uSpxpUhZwFia3kxJddlOwnl63pkS3SLF2zO9HfG+JagRmUpwjaUTYUOF2SAZ2s8h2T8NLABnJ2RytibrS0UbNMegUUk5pLBeDqLu9srmdgGgtuGEx4rqPqKldXHFB2POqWm2eYZeIROvFMIvm+9gtDlARYr/Me+OZfY8t4RAse2rV//AAmGFQXNLIeEZf8G1Bsu8VPcAB/XqlJSHaL93fmj/zv+pfuEw0WUVGtcxTk/y3gtPq0toO9EocS67fxPJTlT70k0baImoBnVuX3RJLeltEZc1lSZlRUSyrifPQq9zTwBQMY60U+v6u7PbyNo7lZC8YR0KiqRlWjEPcgDXQOXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(9686003)(6916009)(83380400001)(8936002)(316002)(966005)(2906002)(71200400001)(55016002)(52536014)(6506007)(4326008)(54906003)(64756008)(478600001)(26005)(7696005)(33656002)(66446008)(66556008)(66476007)(8676002)(76116006)(86362001)(5660300002)(66946007)(186003)(142933001)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m5AM295JLkOcAT6vsLTS82Tv6D0b8Fi93uVHqxpDJ71dxVtTAvoJymAxYCoicOSWKmbR7LJzKuw/vFvhFUzFOaERzMSilR1AmNQeyRuuaFMByO6kCUO7gqIZzKW+Cml1z/LjbKqF0K5G+Lp8l/HCjssBzrH2v38mUVhl8eG0IavEFrQLXAri5AuFFZGv8qQZMlBznlywIg37nmm80FXxCalZ5dfjY1W0cd3EJOrJzmfJgHeIZqrjt/txOk4H/3r4GrkltTyega1Ii+mMr+ZJyVK4nNUYAvVbvW3CzE2DUQinnCRLxHk0P9iFWlB+8HlyEbWqkPd4mUm/K35MdgfdbP5UhGiJw1iu+mfa+1VvfQmip8oO2DyzptNoZwNnGLNpCE9gO8yUkAPGLHvDSb9uB6cVSJGUEaOvkwGZIeOB7mNMZutbsPsAtoZvl73QuuJuc6XE1O4gRAKsPcDeccoCN/374h996vIBP5wDY1waiJZKGLLO8EvQZbH8UoQH0JMZ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80ecabc-29c0-4114-22db-08d8198fa198
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 05:13:15.4255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbnp2+Tb1yTa8k1AVOHCRczqtAS3fQf3YiyRBki0IEnuKPo7cowIqli81bGAAQRIAZd7u6XIU1F4TBBNloUaAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4628
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> From: Parav Pandit <parav@mellanox.com>
> Sent: Tuesday, June 23, 2020 4:14 PM
>=20
> Currently ip link set dev <pfndev> vf <vf_num> <param> <value> has few be=
low
> limitations.
>=20
> 1. Command is limited to set VF parameters only.
> It cannot set the default MAC address for the PCI PF.
>=20
> 2. It can be set only on system where PCI SR-IOV is supported.
> In smartnic based system, eswitch of a NIC resides on a different embedde=
d cpu
> which has the VF and PF representors for the SR-IOV support on a host sys=
tem in
> which this smartnic is plugged-in.
>=20
> 3. It cannot setup the function attributes of sub-function described in d=
etail in
> comprehensive RFC [1] and [2].
>=20
> This series covers the first small part to let user query and set MAC add=
ress
> (hardware address) of a PCI PF/VF which is represented by devlink port.
>=20
> Patch summary:
> Patch-1 Sync kernel header
> Patch-2 Move devlink port code at start to reuse
> Patch-3 Extends port dump command to query additional port function
> attribute(s)
> Patch-4 Enables user to set port function hardware address
>=20
> [1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
> [2] https://marc.info/?l=3Dlinux-netdev&m=3D158555928517777&w=3D2
>=20

Did you get a chance to review this short series?



> Parav Pandit (4):
>   Update kernel headers
>   devlink: Move devlink port code at start to reuse
>   devlink: Support querying hardware address of port function
>   devlink: Support setting port function hardware address
>=20
>  devlink/devlink.c            | 378 ++++++++++++++++++++++++-----------
>  include/uapi/linux/devlink.h |  12 ++
>  2 files changed, 269 insertions(+), 121 deletions(-)
>=20
> --
> 2.25.4

