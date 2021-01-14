Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093112F69A4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbhANSeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:34:10 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19134 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbhANSeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:34:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60008e790000>; Thu, 14 Jan 2021 10:33:29 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 18:33:29 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 18:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGfmcXWg3F1zdEuviqdk0M3AuVWKqBa7PKpHwLfGxMOVwQAOONL4DT/a+CU/wyt4qjLkrEs/hMbnILfkNpyO86FN4/U4EPVI49+lpf5ZQfVGUWZXHR6F1SXrHGQEvOm4IX4VX7qtrUvqhxcOBku1Q33DpxcCnG/u7pqZWQbSaSyVCROY/Y+lJsdsvlQ/cA6pt6SyQsuVGJGl/dYW3/aBrtm+zzMDS3YFfkv6nQbMnA71zG6VXaMg3DKVDvUQmzUVKKZ5tCGeIATJsTbh4kBDIpb4S5ZRwdNBq3PMlx2UawPJeqFDNSnmpQdx5s3i2YCM9fDRFYz/uqR4aPGzf+dSXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxDHB8eApzwmX2M4Cp63Jiy9vxa9p5kkzuCdqgjSHjA=;
 b=CJFh73rbfIqE5yILi1jS96/E+Dcnnpx5y2BNWV88XC4GXrVJva9iArGqcD1kVJ2rUu7i4ikll3seyhrKELWkIj7tos1eGjXirnWH8PK2ChoEQ1qTN3nJQIXeyZjdIcRKr5hn/zhz8UwW2UQSHfS/ibzvVKH3oQmb1h+w3AisCq18uuY9T1BL/84s9WK1EFpZPn1KWzMLnlxqQTSieRKzgU9Ukk253G3gTDjFO5FcJ/kK2uujG+66acLjTPn9O1I36TVgQTsZcwdxdgIFa6aB/aJl/bQAUMSSBSNJNKBuJitmPw9Da3e+dGwIsmDq1+chcckovb2EhivOgy3h2tMt+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3908.namprd12.prod.outlook.com (2603:10b6:a03:1ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 18:33:27 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 18:33:27 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Topic: [net-next V6 02/14] devlink: Introduce PCI SF port flavour and
 port attribute
Thread-Index: AQHW6eIwbq3q2BZokkO623Y7jeJLvqonZX4AgAACO8CAAAjxgIAAAm/A
Date:   Thu, 14 Jan 2021 18:33:27 +0000
Message-ID: <BY5PR12MB432265CFFCAB96BE314A905FDCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210113192730.280656-1-saeed@kernel.org>
        <20210113192730.280656-3-saeed@kernel.org>
        <20210114094230.67e8bef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220F26F558A6CFCE013876DCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210114102229.3ac56a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114102229.3ac56a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3ab225a-2d9a-477e-c5ca-08d8b8bae245
x-ms-traffictypediagnostic: BY5PR12MB3908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB39082182185E0BB38CADA460DCA80@BY5PR12MB3908.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0B78ZS3VuD04uBy6e1b4dm5fW/7L7vC52hBl2kVpIgIu/PvQVVzljh2X5iWCzVcBBxCC7lPBPbHvxV+Ywf5GX1D/NUFEPZsS7mzPgQT6efuyFOIHmjQIfe2O2G/sCY0OI27TMLK819pPX7ycmFRjIJnS7QfhVuK6L2os6RNEb8L8LNUcE/tll5T/sz0IFYXgeoRjXoUBQKUvRhgP5nfB9ESRQLhewH/U1wCjNACJLRq90kMD0OMtMFMYas0Jti6YPMMv3+4QGMXIdTMwwxzDSVnrJrAHX8ZdhkDctL/agXv8CDGVm7F9g+tJD+p3w4qDCN7Cri7OgLtJ3bDBKATcGGeslJlOVowBPZuUlQH762daqH6j5MvuaZq0IlcugCrBtE2dg4dzPqvFfF+L8stbpcnvwqiEARUNT3p9SGEZbwWxlrsaWo+BVlQaLQu6vc0AVKkJleI6sQlRnGvNucdvhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(186003)(26005)(107886003)(966005)(55016002)(6506007)(83380400001)(2906002)(9686003)(4326008)(71200400001)(5660300002)(66946007)(8676002)(7696005)(6916009)(316002)(86362001)(54906003)(478600001)(52536014)(66446008)(66556008)(76116006)(66476007)(64756008)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UcvFrqWjgJknsqlDu3gCRIlgyt0xy6LmGYKFFZzVqeZX149HBS2c8yDD5n8t?=
 =?us-ascii?Q?eHYBwIQVPAiBytEoM/xkd+lDDHgm6xGLWTY1SQrzHkotFW13vGb0ovdKAvts?=
 =?us-ascii?Q?G+LMuW+kI5I+iqsxdGK1pDt2gFhNik4e/osPN//zVQVYW0GUbDXmzBvDsYEx?=
 =?us-ascii?Q?ppx6Yzlgw1CgQlxXhsGrJj8sJjB7IooaXk2cbwuuJV3jAL8mCPVy3SKS2OFH?=
 =?us-ascii?Q?45MOnGnleaTmCd2OapMrM/mQZBxHLkwy5M1puO6dl6a64wLE7ScvkIBTHFVT?=
 =?us-ascii?Q?J60NPRo8GB25D0DiYyp1hwBRXeS0kLjU3TpSq26XnnWQs+iF7kh5Fxw3B6Ds?=
 =?us-ascii?Q?8BaL1vjaBz59pZPPLaQb6gkLeMqZf6KhK8KeKV+Wzr6l5Z/3T/OtlxY0izUk?=
 =?us-ascii?Q?08pL0RI955G9vIAwKXEbsJt6DO1N1m6Xb0V25jvZunl3lCRDWTmjEUN/4eM8?=
 =?us-ascii?Q?YKhTqguJeQcOWIaTojYDUiFsH4CrtN8yi42Uh9kmmD8ETwzuXWF3j9CJhWTY?=
 =?us-ascii?Q?LK/Yfmg9ln4FEtOWKHLZSJBd9db/r4HO+nwiK3fA8y3VJXfW0QYCOPOH8NUV?=
 =?us-ascii?Q?ZjbAb+Guj6S05Syuy7pJyKboE+2KOGjxn3Mhgi+tJ8Kqb3Vne5EyJvVqQ5R+?=
 =?us-ascii?Q?KjdPK3AUUWicwgo1wjVHQaGStytdJ0wojAkIohBtLRuGYDoedDBDZw0agEdM?=
 =?us-ascii?Q?c1t7oJNQ+PLPTNpVM1vbakrxfOdc+Aam/E2rHt1ltAKC0q8yV1J96zBAzevl?=
 =?us-ascii?Q?NsxyQDlcESXgvSY9HBf0z85uyHA9r3RxnlrfCy5joXbGzzPzCzCFFh/n9cuT?=
 =?us-ascii?Q?gcfCtDEF0d1i/B3DzfYdxyY4XO8SAdwdfKof4rZY391EouFY9ttl2T+O3Xtn?=
 =?us-ascii?Q?cADAuJBBiJigq3w9UVRy7sXISepe5xYi9uAALqjK0Cd+DXdI8YiRyMg6ps4M?=
 =?us-ascii?Q?whHpOpDfBfxeDi4IMnXO1Wio6TFVZe0Y9QAfeo3R4yo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ab225a-2d9a-477e-c5ca-08d8b8bae245
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 18:33:27.1740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXWEBvZ/3c/2/9gFaqxnRDOHMoEzHKjbRvqR00/QkSuVgCun9KoNaXYeOaDU83nRuYETugsAix2M+uHLqcEjPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3908
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610649209; bh=HxDHB8eApzwmX2M4Cp63Jiy9vxa9p5kkzuCdqgjSHjA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=FheVU4w2zS5fCLOHnfGWVVNHYoLN4ZkBEpA9Y5yzvU8aZ7ylChNhXgScb4xL5sNHW
         LKgMI/weW3P1eZcJM7+fUDQEHJMcyElGEOTwUDsVgGwuxAHKyGJbGd07EBVIoscenV
         Pqeqwxg3RkBw5N0YfOWF1DVYOmEuh6FxCvAU8J3WkCsh/0kytVMl9Bd21COcct/3VH
         IRnSHV4eaW3z+Q52wSw/tIE9G08kGaY89Iumi5TIRbk0Rsucvw4vsej18EnQoObkvG
         G0JrSQb6odQJ+VI8iaiau1J51Q02F33gNQjFbJ/jTbRh8RHDADo+DJZz5LoDnrv87K
         yIIze2NenfHmg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 14, 2021 11:52 PM
>=20
> On Thu, 14 Jan 2021 17:53:09 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Thursday, January 14, 2021 11:13 PM
> > >
> > > On Wed, 13 Jan 2021 11:27:18 -0800 Saeed Mahameed wrote:
> > > >  /**
> > > >   * struct devlink_port_attrs - devlink port object
> > > >   * @flavour: flavour of the port
> > > > @@ -114,6 +126,7 @@ struct devlink_port_attrs {
> > > >  		struct devlink_port_phys_attrs phys;
> > > >  		struct devlink_port_pci_pf_attrs pci_pf;
> > > >  		struct devlink_port_pci_vf_attrs pci_vf;
> > > > +		struct devlink_port_pci_sf_attrs pci_sf;
> > > >  	};
> > > >  };
> > >
> > > include/net/devlink.h:131: warning: Function parameter or member
> 'pci_sf'
> > > not described in 'devlink_port_attrs'
> > Wasn't reported till v5.
> > Can you please share, which script catches this? So that I can run next=
 time
> early.
>=20
> This is just scripts/kernel-doc from the tree.
>=20
Ok. Got it. This is helpful.
Will wait to gather other comments.
Otherwise better to do bulk conversion for all the below one in include/net=
/devlink.h apart from this SF one.

./scripts/kernel-doc -none include/net/devlink.h

include/net/devlink.h:217: warning: Function parameter or member 'field_id'=
 not described in 'devlink_dpipe_match'
include/net/devlink.h:232: warning: Function parameter or member 'field_id'=
 not described in 'devlink_dpipe_action'
include/net/devlink.h:275: warning: Function parameter or member 'match_val=
ues_count' not described in 'devlink_dpipe_entry'
include/net/devlink.h:320: warning: Function parameter or member 'list' not=
 described in 'devlink_dpipe_table'
include/net/devlink.h:339: warning: Function parameter or member 'actions_d=
ump' not described in 'devlink_dpipe_table_ops'
include/net/devlink.h:339: warning: Function parameter or member 'matches_d=
ump' not described in 'devlink_dpipe_table_ops'
include/net/devlink.h:339: warning: Function parameter or member 'entries_d=
ump' not described in 'devlink_dpipe_table_ops'
include/net/devlink.h:339: warning: Function parameter or member 'counters_=
set_update' not described in 'devlink_dpipe_table_ops'
include/net/devlink.h:339: warning: Function parameter or member 'size_get'=
 not described in 'devlink_dpipe_table_ops'
include/net/devlink.h:349: warning: Function parameter or member 'headers' =
not described in 'devlink_dpipe_headers'
include/net/devlink.h:349: warning: Function parameter or member 'headers_c=
ount' not described in 'devlink_dpipe_headers'
include/net/devlink.h:363: warning: Function parameter or member 'unit' not=
 described in 'devlink_resource_size_params'
include/net/devlink.h:404: warning: Function parameter or member 'occ_get' =
not described in 'devlink_resource'
include/net/devlink.h:404: warning: Function parameter or member 'occ_get_p=
riv' not described in 'devlink_resource'
include/net/devlink.h:477: warning: Function parameter or member 'id' not d=
escribed in 'devlink_param'
include/net/devlink.h:606: warning: Function parameter or member 'overwrite=
_mask' not described in 'devlink_flash_update_params'


> All the tests are here:
>=20
> https://github.com/kuba-moo/nipa/blob/master/tests/
