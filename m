Return-Path: <netdev+bounces-6943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADED9718ED1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 00:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35C831C20FAB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD523C0AD;
	Wed, 31 May 2023 22:52:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A7522621
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 22:52:28 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D8F133
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685573546; x=1717109546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rJPJyUbv8J06Rx5dCYW8hYO3aswPacKQ7VqKO5SoyXg=;
  b=R+PKY5Adc6KDEAC/GcnAHdrQDU/IJ7rCFk+VODKm3GHRTTPPE7a2kXSi
   ZB0HwbamSEtbC5EjZvJtYBQYjWqkmIuFqZbbqR9/apgU3tJdfvPUfEFgE
   MOm/tlkWwnmdt4hDAw93ctEyOsCpSirb9JJLbU9kaR51EMYBVeiXooZVu
   7d03o72khXUiCPghBMh7n2MX2v1qvmVbNUDutQW0sHWJ03LKgROHZDU/T
   uC/YSw8rus08F4+lUQjrSDj5oiwuuAyUwdwnALRKHXkeoxmC8pkdf5UeD
   0WdXQER9Fl4cR+hUcaMnx49PJAubIug+uL1JFehP5uhQPS6pRNAFoIreT
   g==;
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="227882237"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2023 15:52:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 31 May 2023 15:52:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 31 May 2023 15:52:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv7pg6FruKHupLa8wjEiR6R/ElEF0HiG4I/1lf4ZqdquevDmKBl6eza6hpgnfnkJyRjzSiW9cPv+nYyEFsWnJcBYSJtxJw4qjexGbWo9nnIGm35LyPCNW6tH5g+VB2lkz7TJHVwt/eHme7pv6wy9nAcXjOLssXy5Mm/7la5pgtT7VsDL6Zj2+H99J0jVjRd+EoZSaNsbmOfC5uXPJMgq2slaIDxm5ESAhsNwve8Qu9jvL8uUmPGHGemI2iWUyNiSDaxIMIcMzXXWnhbX6CJw9wPRUKorRdMiico84M004tZzEEEi0KlDfEQHL0jp1z0uov3qlE9bUeWipAbhO+KH7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpcOt3oK7uL7JiQU8TZR1ODmhIU7TSBuZVNykAjeDBg=;
 b=dUFF0ZNeZ6ddv/1wa7qeANuD0Prkgs9O097m354C6AGTAhBduoHvU7JRKkxCBE4qISvYSBw8I71p5+CIA8lccC7iDEZ6x1VAZKQp4Huw96HKFFRWoGKU1oTEuU5EIhMzzQSHy6pn0diVncy+bQuYmWOLrrtvAhEenzuv/NQFVBtZxahv1Lg5V9pi+cbHVDomAT26HYzUT+Z/M7NBF3Ok6zBJqOZrQVjV3gO6LwIeFKBT+H4Tv9q2a8bHFk4o2gRSpSCJPyqhWXOMKb1XmEKbjdDZNCqkpmmJSFPsn5KN2fiL6pA84PlbBPeQYUu9NH/ISRdZ5qXiYlJxP9kp7PXMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpcOt3oK7uL7JiQU8TZR1ODmhIU7TSBuZVNykAjeDBg=;
 b=MU7K7DMsLzu0uMFvKYLrILLX3tVdkGz8spUmpYJhbVQjonU/w+xAZ9E/XVqVvDydA2Lc9ulFlPugzzAlmVDKMHYkubbejMfVM6kE628wxJ9bTeB4Ff+bCh+x81xFEEleSvW4GfkeodMnBxgXoI948OJ62HGjzJZU62+jtmr6fGU=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 22:52:22 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::449c:459f:8f5d:1e46]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::449c:459f:8f5d:1e46%6]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 22:52:22 +0000
From: <Tristram.Ha@microchip.com>
To: <simon.horman@corigine.com>
CC: <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
	<netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Topic: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Thread-Index: AQHZkDwiffQVuCP3CUK1xQvBykSLHa9uJaWAgAbco/A=
Date: Wed, 31 May 2023 22:52:22 +0000
Message-ID: <BYAPR11MB35584E92C5EA85D79800528FEC489@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
 <ZHIMF8k+bYGosakh@corigine.com>
In-Reply-To: <ZHIMF8k+bYGosakh@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3558:EE_|DS0PR11MB7788:EE_
x-ms-office365-filtering-correlation-id: 1b3dc1a2-b799-4994-83a8-08db6229b1f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2kbofJgkJmadfaExPbVo/s6vtYvD5did5W7Olqzfrx/7x0b14PyF7WPbULKd3FnQeA9kqffYaLmwOTuOWuk51Nz4h+OWjhdCckNGBzRcTZY7NveRHL8x343ZCBCeKLsX3Yp87RXzBXY+tDiEKX1eK6uEk8JXXvtj2FENfBtQ0hMNoP6bfQECiyqVDW5n9mdsY+A4ljUFPUuogFKqKhKN4mKgJGdUBeTPVft8NiSqf9OerXN5UdLmoudIh2rCBEzHQ0I22+Uk8p/Sh+j5GhqreOsqati30AqdI6tZ/d2c1X9tlikro+epj9uBcQnDz0TTNvOi7+8J3bJQhlC6naUI7r+s6PwNyZaqz9rpPhO/9jjxc1x6fck+/CrXqLLLUIPSC8Uy/DOkEtL7KdnfZVbKkRk+wE6t4497OHXHtiYYmJa4EK/X/pgdCSn+7bcnOpBTK8jkdbpcUxyRHZvVzWVAjT6LexzbS1TuXi117xsqV8EAACFHBURGayUpo8cszVn8+NljS8IIXD5hlN4OqSpQwytUUv9EOwT1EWOJJMkHAURoncZ5/33b+wE47v/qpOEuz+Zq2xH/Ta6dn5Y0A85yXioD7I4z5wAtnb9F2wNsyeUJWDNvinFI+X8k2dr0ZLr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(2906002)(83380400001)(38070700005)(33656002)(86362001)(38100700002)(122000001)(55016003)(8936002)(8676002)(107886003)(5660300002)(52536014)(6916009)(4326008)(316002)(71200400001)(66946007)(66556008)(76116006)(64756008)(66476007)(66446008)(41300700001)(7696005)(6506007)(26005)(186003)(9686003)(54906003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mIFDIPmP1tdDZ/vvuZiRdSlbwpYDV2eRAzpWx+MnUPnMTjlYHrykuIhOqaMA?=
 =?us-ascii?Q?InNjN1C2O9Y6avZxf1YbnfJYXFZeeFXhSMd4vSy9Xlze+XGOqWQm8jwpwMcT?=
 =?us-ascii?Q?oAkrWYhhDxwHat1IHzZL889V3SvAhPwS9r0cbCCBp2KuBaGXKms9fH76OpNN?=
 =?us-ascii?Q?9sjA5CA6YzeIG9hTs5TNJ5NOY1DXX4yorZaodXNGbZ/tzx9nzvwPNR/onj3H?=
 =?us-ascii?Q?rTPAHv5+IQO//MB08hO3gx9WF9z8u8fAMSe3w6c6W26XcEaxZjD9W1M9XPSs?=
 =?us-ascii?Q?aEwtxqQRhdzg7se/InrI6wuFTLHkTW84YyoYpLks1a2utxMIVtFTg5dSGwn3?=
 =?us-ascii?Q?h+P3U1mjGyrxktMF1aa9tmd461UJKucqRewnCK0iTgI4KTabsw3q3B9hFJaE?=
 =?us-ascii?Q?ThbicFWN4wjiDTW+AthjOwWjfjtqlyvJ5IToYagt3bb/YeN5Ytkri7EmdV08?=
 =?us-ascii?Q?sQFpEMcL+lKWkFq25cskY+gu4gKJkZqDs14MvHxE27LAl7oWYU7t479gSbL1?=
 =?us-ascii?Q?Dg+dDyLBDat3EGFjATnltRANuqDIQ9SODpZxvsWcUNiVgHE26N7ppmjOAV5e?=
 =?us-ascii?Q?TmNqsCfQ/2I79FOOb4MwZGDlwVQr80vH74zkJxSqwCetTyDxZQeuy1xIxvwm?=
 =?us-ascii?Q?WKZdCf2ZorGgVlD9Ghzjzltg2Qxsdfj2lXPR3Ib9A1lFOANqWeI4sGcjAi/u?=
 =?us-ascii?Q?SYOPNAGXXJrEiRccQZOx/Aco7R+IwoGcWet7NalqgkeKvxaHqu41iJ78uFrn?=
 =?us-ascii?Q?/Gr4LrnNgljXf5I4JjUjQu+m7RoSvYyFIIWQgLKIzI9FedudI/y3oG6djxqt?=
 =?us-ascii?Q?culhn75fuSTE5od+1tAm+DPz4EWkHFdCbhXZfBBa/NrlIiaUE/KslV3wogii?=
 =?us-ascii?Q?LPRJNDjo5ToGQo3MXDoO5pw8+c08c2i64ci35vJjiQ/ZqZwIAqK7jlFzijQo?=
 =?us-ascii?Q?Sydw2iE+kvmeTBZ0u89ue9LXYguIHcLYWJteX75A2xDtn+aLVnjoRuhqY7Qm?=
 =?us-ascii?Q?LYNOlcx2pfumDzL8qtN9y+yN+scZEBJX/8COKyeNCVuu/ldA577W3YUkgpg1?=
 =?us-ascii?Q?JqCafZyBCSiFbPGgAqWe53OpaTgrhy4heoHhbLs55x6sLF7fpxPmjoMrbB/H?=
 =?us-ascii?Q?b8z/P8BzpVYjC+qojW8bxFCODYZXQzRpWuWfYJ7KffRrIq/q/wmolGu9gDUL?=
 =?us-ascii?Q?LXAeGmdZ0kTRdueThGI20BEdmLNToXt3yDOQ8ERXbBIJFezdNIQBOXyO6pF5?=
 =?us-ascii?Q?uqXcyKGk8NwDUcM2xJeqk0z1UHJvzI7P/1NJq4/aOrYwPjEaM5RLKfuFd7i9?=
 =?us-ascii?Q?zIsABdAKchofAhQ/lZNnclih2qtH62aBptRJ3dCDbU4SeJn+QJIEU4S4TA6y?=
 =?us-ascii?Q?uvBnsqjkSGrbmZh6LC6v4KLRk/YpZ3a07PCggcjmUe/wuOWqoyyjsOFVqyYB?=
 =?us-ascii?Q?CyXM47yesai9RPzrXWkdn3aFbnzh8IJXQR1hK76TxDq7xhBQeMv7nV9VOUZR?=
 =?us-ascii?Q?4ohxiEyFhU6hPkTkwPOR+Mrmsye93gNAQTEAcxEEGd9rOE1SxqWOo/0d8w+W?=
 =?us-ascii?Q?UV1dsAnWEmrmxqKCGELgTPjaSCW6rf1TO4scXlTy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3dc1a2-b799-4994-83a8-08db6229b1f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 22:52:22.1906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ecSZaRHyybMktsnqL2CHiPnCSuLWZCO1/AZEzeaUivrwiT78oypwQZ/BYSx7dDoy/tXFqp/LYUf76KozQq7o0O+pXHNTb1UkfDiFqVtT2NA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > +     if (wol->wolopts & WAKE_ARP) {
> > +             const u8 *ip_addr =3D
> > +                     ((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_add=
ress);
>=20
> Hi Tristram,
>=20
> Sparse seems unhappy about this:
>=20
> .../smsc.c:449:27: warning: cast removes address space '__rcu' of express=
ion
>=20

This will be fixed with in_dev_get() and rcu_dereference().

> > +             /* Try to match IPv6 Neighbor Solicitation. */
> > +             if (ndev->ip6_ptr) {
> > +                     struct list_head *addr_list =3D
> > +                             &ndev->ip6_ptr->addr_list;
>=20
> And this:
>=20
> .../smsc.c:485:38: warning: incorrect type in initializer (different addr=
ess spaces)
> .../smsc.c:485:38:    expected struct list_head *addr_list
> .../smsc.c:485:38:    got struct list_head [noderef] __rcu *
> .../smsc.c:449:45: warning: dereference of noderef expression
>=20
> Please make sure that patches don't intoduce new warnings with W=3D1 C=3D=
1 builds.

This will be fixed with in6_dev_get().

> > +#define MII_LAN874X_PHY_PME1_SET             (2<<13)
> > +#define MII_LAN874X_PHY_PME2_SET             (2<<11)
>=20
> nit: Maybe GENMASK is appropriate here.
>      If not, please consider spaces around '<<'

Will update.


