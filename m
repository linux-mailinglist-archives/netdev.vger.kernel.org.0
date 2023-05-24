Return-Path: <netdev+bounces-4869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CF770EE7E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD4F2280FCF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A363D6D;
	Wed, 24 May 2023 06:51:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF41FB9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:51:29 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F691BD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684911085; x=1716447085;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M0Fu7DWDd93cYNI+pw6HWvdyfeHktsSU/cZEMZ+POiI=;
  b=YC7gYtphXS+9W/3U7fR7zkD0bKMJPapJORqB+xDs//4jKPx+BU6UUU2A
   5ymasa9A9eHer7zFh/lrj1w1Pf6gHSvPFZCq9oLrUHQDl5C/mxywaU7O9
   B6VlGpXvGEe/E/Ga4kKyfK7Dtv23llqr5HZokqFI+JzbJm3IuOwm6PZr3
   dDZYWQ08NXWpWV49FaDa9pnT/atToW2WURL79TLfqV5+fbSoThHGTtZIE
   rI6sB/hLcCKhxEygJqmYupNWzr2EMMg97URJDP74dINtjJyGTmIUUVpgO
   /2dwfQvb5vG9R6rKwpxZrd6M4KAbDIDgTZNYNaxDv6fOemSkEXnEoun/r
   w==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="226743442"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:51:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:51:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 23 May 2023 23:51:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoJtu+nQOVWARtSf2mYfvhBvo844a8cVmy2vZYt4GVRyt2/O1/joz5xR9bQl041oervpkMbIvNdnwjo6MBVz2JP9da6W/ZxzLHXgYg1JR6ymVUlNI1aR/vT7f1Kty+x3LouxbPsnKkg6nRGKQ96+08KmfzRm0nbpZzpMKgBW9/4H8yZfABP0nHTlb5WBww5u5h+wXp8aQCztHTRWlHDsMBzywCOtsTOgIR4NeOXntVURE5PFKLAygbPxKOTKzTQ4gsS7TtW9cXijTocdXL17ipEBiQCCyjAEWxz0et/85Zf9PIv1bl5l9ieQwS+wUqFJim7nCwQHZxnJR2nlnXeajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMfhmog6G52IyPh6nVEjXGc7f9WEcu02Z2ZDdKV11SA=;
 b=eGl5itFhTSoMUCJbJdryHEZJ7FsV3RVpyU71irxG3jPyZAf/7rmzaPyDwRzvo660uyl0EZSq4mqKooMPWCtv0j40nLhshXEgo+9VlPo5dsWvR1cfdNXbqlpAeYX6PPwwyYLlsPEJhrbNu0f6vzvmeyydMIHIBRVU0EA35VfSKy79412U/DZlATMfJWQlNcW6oc1BoY4TF3+ONnuN53UKvNLfZVOmaABYC78dT5BMt8hXDiDUH/McxLY5+/GNdQW0oxBM6S8xZh3QkXaVStFP5kVYRsa/4gWfGz3h1+OjdC3t/JAv7YYZ61TetahYt2dozhKRe72pmD9g0ElcQEoFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMfhmog6G52IyPh6nVEjXGc7f9WEcu02Z2ZDdKV11SA=;
 b=bL47GgmaHvxkJ6F2EajAGBEBdlljA1B7TL1UWlk9nqV6Y4iYl7l/dGn+mAPRteJVqZ87um6Zz/Sa+50NsVXvTC/pz8saqishwWsYeN3TPs1TCV51qNIAnR2Aa+DdX9GVDz4NrcbpbKZUXenUXtf9mwM24hdOGYEBhtvDtTMWQ+Y=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SN7PR11MB7139.namprd11.prod.outlook.com (2603:10b6:806:2a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 06:51:22 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:51:22 +0000
From: <Daniel.Machon@microchip.com>
To: <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 6/9] dcb: rewr: add new dcb-rewr subcommand
Thread-Topic: [PATCH iproute2-next 6/9] dcb: rewr: add new dcb-rewr subcommand
Thread-Index: AQHZjN0OZe2LvLoFyUOP0NNDoatD7K9oD3iAgADvGYA=
Date: Wed, 24 May 2023 06:51:21 +0000
Message-ID: <ZG2z6XlAEUu3B4yg@DEN-LT-70577>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-6-83adc1f93356@microchip.com>
 <874jo3575i.fsf@nvidia.com>
In-Reply-To: <874jo3575i.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SN7PR11MB7139:EE_
x-ms-office365-filtering-correlation-id: 82ecd149-bdbe-434c-f2c8-08db5c2348e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zSGE81qIdhmtmScCSr1FtRX99A3CTLR+Ljm7oER+5QcklWODHYZxj69n/BHgDdum/LAei75Z1sfMaD5ndQF6/w5BZwsfZxQy+EDb8uiK+mGCMqGi+nxY6jIKkyhf4vGRof5vaLaU4ZWRGrMZT6paoWsZ8B/+WAtMojUZkIlQv8eOeQhr9PZPql4Vx8vfFrmBOBBXSsyqWT1fvGla9PSmcxtiZMbqNSuwME7lw8SHpma3ia8JzJXDcW1TX3LKG5dEYUyDvHY/EjpfOCLnM1LVFpbmc8La9zDfiK0oKeDyuyhtzYotZZK7r7QgmDCM4iBU6hWf97r1JEbF8jjfru1qHnvitn4mgk5CzWbpBF4U7GFpOZij3yLLXKxKoo5KjwHjTTpHWkXwAm+KXUFCI0fZ8EC/+HwU3inUw1O6KRH38m0YchrU9g7lLHzREOZBiAuDW+TgaI2afL09WlUgK5NK6CDoYT8h1QFZxVjc4+KYOS4+LU/XkTb3eWOz2c7ZanYR7Ow2SC7rojhCbczU4Q57BqxgYLv3Mm9Hu6prpEpuC4X3X7ov0lnfIp6ziogec+kU1p5l7T1i9ooas2DZJ7HmCu5IAX5mCbvJlV9z9PDMQjFNjdMAwRDMzMSayWvA419S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199021)(9686003)(83380400001)(122000001)(6512007)(26005)(38100700002)(6506007)(107886003)(30864003)(186003)(2906002)(478600001)(71200400001)(316002)(4326008)(76116006)(66476007)(64756008)(6916009)(66556008)(66446008)(91956017)(66946007)(38070700005)(41300700001)(86362001)(6486002)(33716001)(5660300002)(8676002)(8936002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jtrneWCgwx7YWyg7xt5TsBja47+uvyVfkfBUBpdbc+y/9zhH50jY1cEDLEWa?=
 =?us-ascii?Q?nVQ3FvH1dT6TxYTXMd2chaaqT53a7HeUcsrH4g7ummcgFvfbJXC0EW+KpEqi?=
 =?us-ascii?Q?y1/ERgIQoEXuirE/omQWwBWzYtyyxcFjsoe+YMfYXsY3c6DnWMGvlchcSRBd?=
 =?us-ascii?Q?WUcPmhaRMxt3Cy64x8CSpu8rHm8owBpvuNnBJj4wGUcNcUnHz0GsbdFRcv0B?=
 =?us-ascii?Q?H08aFnExad+76lcAgU6Cin5FfWHCws6kVOcJQUQz6BcFyuxmDoASy6j0fFWZ?=
 =?us-ascii?Q?dy7zYMxOVR0uqo4LeTm4tGU/9TaDt0ys2/y47m0nVD44AHLXli78grBNQALN?=
 =?us-ascii?Q?ukN9N8st/9jQaOK4/tqgIXFq0v2loSEQO4sdX1u62PKOYHBalgFCvB/F61dC?=
 =?us-ascii?Q?Ind4wRc+oJyVylcfmKMuYn83DG2R9WLYFvrDJQJtoHk5cXrgQvcusDYtj1T+?=
 =?us-ascii?Q?Oz5+2hyc+Z/J9iDn3S/i1ofnr7uQ31wSuRjseUYUGUNmNLRZo+EMqmB3QoLd?=
 =?us-ascii?Q?MyaTMa3hWa+HMNv01YyJ3OYsHcy5b4QmWVHx2gnZF5TWhq+mHwtRUMBrooys?=
 =?us-ascii?Q?RHqQzEp2RmSp5esiAjp4MeESviVAriS6gIpAuQyewTfC+KYVt3BAH8+dueyC?=
 =?us-ascii?Q?PbiiuzUTZMmrf74VNDQPeWlFAU9cBTSInPZjrLN3G/dEtxJyUnVI7n+Jv9bQ?=
 =?us-ascii?Q?o0j5I3gyT8Gjg8Gsa9odY5gjQ9fPwBjPN6h+jdX9yv/WcYcWGUqWT53+bnq6?=
 =?us-ascii?Q?TGuoQXc8F+C34AhWuwqpUOc3/qWI1UxW+6hcnzs3XqtrI9dc3HQXs04LCgmD?=
 =?us-ascii?Q?0Pzjnn0fwRgI8+MJvm8J/r2/kgTy7SUHpSXC+I6IHAlPWAd5VXUp8g1tKdhp?=
 =?us-ascii?Q?6YlqRUy6cCVQfFL4Q4n2U/xtvEAFbwXW4cashrxmGnapD1QB/sTA0u9UXxg1?=
 =?us-ascii?Q?5CJTyWPr6bVJ+JpLp8mMEKdPT+5LfjJ5n4pWWL3W02hkYCvR2WCduD7PX0bO?=
 =?us-ascii?Q?bKt/3THlX1/p9ut14oCSXTlqmG84RWfLRsOXCmUM3MZTXnLlUrSSseYO20yH?=
 =?us-ascii?Q?LNiSMrDI5LrZkZ14CbhtlTb2dISW05+wGeT173Jp3ZdNgHDwH2mOsM2bgKiJ?=
 =?us-ascii?Q?yCG9/dEldT6BxJyS67e5bnVTXZ1U1MBh+DFzTfFLic8PFLnWJYKghn16YzWa?=
 =?us-ascii?Q?isMABVhjUmujQyfiMIDYhGGqYI3LiNlrLy/G50RMkOZ7VlAl41DcXkacOtY1?=
 =?us-ascii?Q?gth6zzT10/sXDrcSihvk4p4T5rN/nxXvtcb8pep27+anFFGekQJvOXSLAB3f?=
 =?us-ascii?Q?JvFoqc1MnVNMOcs/zQO+jU6eFngjXH3EpFdYCs6JyfcLvw5bbloKrRaylVF6?=
 =?us-ascii?Q?IZ54/q0S9tq2Nb7Oti58633pV8sZgOzoAuX6FFSH2n/mg/4ZOgPHBNRiImap?=
 =?us-ascii?Q?VLGwdfjFG/v1C4WOB4sz5bEBfrp9QlaSakgkMXirHmTQElmmw8Fi3y5kmF/5?=
 =?us-ascii?Q?Ligj6XJahflwBlzeLEAmPE8xA97t3ZD3IFZHjP5lN37ufvbLb06EjXe8y5Wd?=
 =?us-ascii?Q?vq+vG3UdtKDJBr9pH7UVSslML6GWprSac6FUAZJw47m0Vi4b1Wnq8/kXFhPR?=
 =?us-ascii?Q?2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2959314432AB8B4698C850D0662CAE3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ecd149-bdbe-434c-f2c8-08db5c2348e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 06:51:21.9385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: apX7Z0Ta8TGqVxUOkipb6Qr8rH7j1SF8a/g8yEcWfV+mWG+zr/nkrYILJzEoeQGNsuVFBGnFapWvBkNNfG/TpBbart3HZu0LXZiF0u+eq+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7139
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > Add a new subcommand 'rewr' for configuring the in-kernel DCB rewrite
> > table. The rewr-table of the kernel is similar to the APP-table, and so
> > is this new subcommand. Therefore, much of the existing bookkeeping cod=
e
> > from dcb-app, can be reused in the dcb-rewr implementation.
> >
> > Initially, only support for configuring PCP and DSCP-based rewrite has
> > been added.
>=20
> That's reasonable.

Good :)

>=20
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  dcb/Makefile   |   3 +-
> >  dcb/dcb.c      |   4 +-
> >  dcb/dcb.h      |   3 +
> >  dcb/dcb_app.h  |   1 +
> >  dcb/dcb_rewr.c | 332 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  5 files changed, 341 insertions(+), 2 deletions(-)
> >
> > diff --git a/dcb/Makefile b/dcb/Makefile
> > index dd41a559a0c8..10794c9dc19f 100644
> > --- a/dcb/Makefile
> > +++ b/dcb/Makefile
> > @@ -8,7 +8,8 @@ DCBOBJ =3D dcb.o \
> >           dcb_ets.o \
> >           dcb_maxrate.o \
> >           dcb_pfc.o \
> > -         dcb_apptrust.o
> > +         dcb_apptrust.o \
> > +         dcb_rewr.o
> >  TARGETS +=3D dcb
> >  LDLIBS +=3D -lm
> >
> > diff --git a/dcb/dcb.c b/dcb/dcb.c
> > index 9b996abac529..fe0a0f04143d 100644
> > --- a/dcb/dcb.c
> > +++ b/dcb/dcb.c
> > @@ -470,7 +470,7 @@ static void dcb_help(void)
> >       fprintf(stderr,
> >               "Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
> >               "       dcb [ -f | --force ] { -b | --batch } filename [ =
-n | --netns ] netnsname\n"
> > -             "where  OBJECT :=3D { app | apptrust | buffer | dcbx | et=
s | maxrate | pfc }\n"
> > +             "where  OBJECT :=3D { app | apptrust | buffer | dcbx | et=
s | maxrate | pfc | rewr }\n"
> >               "       OPTIONS :=3D [ -V | --Version | -i | --iec | -j |=
 --json\n"
> >               "                  | -N | --Numeric | -p | --pretty\n"
> >               "                  | -s | --statistics | -v | --verbose]\=
n");
> > @@ -485,6 +485,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char =
**argv)
> >               return dcb_cmd_app(dcb, argc - 1, argv + 1);
> >       } else if (strcmp(*argv, "apptrust") =3D=3D 0) {
> >               return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
> > +     } else if (strcmp(*argv, "rewr") =3D=3D 0) {
> > +             return dcb_cmd_rewr(dcb, argc - 1, argv + 1);
> >       } else if (matches(*argv, "buffer") =3D=3D 0) {
> >               return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
> >       } else if (matches(*argv, "dcbx") =3D=3D 0) {
> > diff --git a/dcb/dcb.h b/dcb/dcb.h
> > index 4c8a4aa25e0c..39a04f1c59df 100644
> > --- a/dcb/dcb.h
> > +++ b/dcb/dcb.h
> > @@ -56,6 +56,9 @@ void dcb_print_array_on_off(const __u8 *array, size_t=
 size);
> >  void dcb_print_array_kw(const __u8 *array, size_t array_size,
> >                       const char *const kw[], size_t kw_size);
> >
> > +/* dcb_rewr.c */
> > +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
> > +
> >  /* dcb_apptrust.c */
> >
> >  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> > diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
> > index 8f048605c3a8..02c9eb03f6c2 100644
> > --- a/dcb/dcb_app.h
> > +++ b/dcb/dcb_app.h
> > @@ -22,6 +22,7 @@ struct dcb_app_parse_mapping {
> >  };
> >
> >  #define DCB_APP_PCP_MAX 15
> > +#define DCB_APP_DSCP_MAX 63
>=20
> It would be nice to have dcb_app_parse_mapping_dscp_prio() use that
> define now that it exists. Back then I figured the value 63 in the
> context that mentions DSCP is clear enough, and the value itself being
> grounded in IEEE won't change, but... um, yeah, if the define exists,
> let's use it :)

I introduced it for PCP back then, so why not for DSCP also. Will update
use in dcb-app also.

>=20
> >
> >  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> >
> > diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
> > new file mode 100644
> > index 000000000000..731ba78977e2
> > --- /dev/null
> > +++ b/dcb/dcb_rewr.c
> > @@ -0,0 +1,332 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +
> > +#include <errno.h>
> > +#include <linux/dcbnl.h>
> > +#include <stdio.h>
> > +
> > +#include "dcb.h"
> > +#include "utils.h"
> > +
> > +static void dcb_rewr_help_add(void)
> > +{
> > +     fprintf(stderr,
> > +             "Usage: dcb rewr { add | del | replace } dev STRING\n"
> > +             "           [ prio-pcp PRIO:PCP   ]\n"
> > +             "           [ prio-dscp PRIO:DSCP ]\n"
> > +             "\n"
> > +             " where PRIO :=3D { 0 .. 7               }\n"
> > +             "       PCP  :=3D { 0(nd/de) .. 7(nd/de) }\n"
> > +             "       DSCP :=3D { 0 .. 63              }\n"
>=20
> I was wondering if you had done something with this instance of 63 ;)
>=20
> Can you also drop all those extra spaces? Here and elsewhere. These
> tabular layouts only ever lead to later reformatting as longer lines
> break it.

Sure.

>=20
> > +             "\n"
> > +     );
> > +}
> > +
> > +static void dcb_rewr_help_show_flush(void)
> > +{
> > +     fprintf(stderr,
> > +             "Usage: dcb rewr { show | flush } dev STRING\n"
> > +             "           [ prio-pcp  ]\n"
> > +             "           [ prio-dscp ]\n"
> > +             "\n"
> > +     );
> > +}
> > +
> > +static void dcb_rewr_help(void)
> > +{
> > +     fprintf(stderr,
> > +             "Usage: dcb rewr help\n"
> > +             "\n"
> > +     );
> > +     dcb_rewr_help_show_flush();
> > +     dcb_rewr_help_add();
> > +}
> > +
> > +static int dcb_rewr_parse_mapping_prio_pcp(__u32 key, char *value, voi=
d *data)
> > +{
> > +     __u32 pcp;
> > +
> > +     if (dcb_app_parse_pcp(&pcp, value))
> > +             return -EINVAL;
> > +
> > +     return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "=
PCP",
> > +                              pcp, DCB_APP_PCP_MAX, dcb_app_parse_mapp=
ing_cb,
> > +                              data);
>=20
> See, the way it's formatted in app makes it clear what's what. Consider:
>=20
>         return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
>                                  "PCP", pcp, DCB_APP_PCP_MAX,
>                                  dcb_app_parse_mapping_cb, data);
>=20
> PRIO has proposed value of "key" and goes up to IEEE_8021QAZ_MAX_TCS - 1,
> PCP has "pcp", goes up to DCB_APP_PCP_MAX, please use this callback and
> invoke it with "data".
>=20
> The expression in this patch takes the same amount of space, but it's
> much less clear what is what.
>=20
> The same applies below.

Ack.

>=20
> > +}
> > +
> > +static int dcb_rewr_parse_mapping_prio_dscp(__u32 key, char *value, vo=
id *data)
> > +{
> > +     __u32 dscp;
> > +
> > +     if (dcb_app_parse_dscp(&dscp, value))
> > +             return -EINVAL;
> > +
> > +     return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "=
DSCP",
> > +                              dscp, DCB_APP_DSCP_MAX,
> > +                              dcb_app_parse_mapping_cb, data);
> > +}
> > +
> > +static void dcb_rewr_print_prio_pcp(const struct dcb *dcb,
> > +                                 const struct dcb_app_table *tab)
> > +{
> > +     dcb_app_print_filtered(tab, dcb_app_is_pcp,
> > +                            dcb->numeric ? dcb_app_print_pid_dec :
> > +                                           dcb_app_print_pid_pcp,
> > +                            "prio_pcp", "prio-pcp");
> > +}
> > +
> > +static void dcb_rewr_print_prio_dscp(const struct dcb *dcb,
> > +                                  const struct dcb_app_table *tab)
> > +{
> > +     dcb_app_print_filtered(tab, dcb_app_is_dscp,
> > +                            dcb->numeric ? dcb_app_print_pid_dec :
> > +                                           dcb_app_print_pid_dscp,
> > +                            "prio_dscp", "prio-dscp");
> > +}
> > +
> > +static void dcb_rewr_print(const struct dcb *dcb,
> > +                        const struct dcb_app_table *tab)
> > +{
> > +     dcb_rewr_print_prio_pcp(dcb, tab);
> > +     dcb_rewr_print_prio_dscp(dcb, tab);
> > +}
> > +
> > +static int dcb_cmd_rewr_parse_add_del(struct dcb *dcb, const char *dev=
,
> > +                                   int argc, char **argv,
> > +                                   struct dcb_app_table *tab)
> > +{
> > +     struct dcb_app_parse_mapping pm =3D { .tab =3D tab };
> > +     int ret;
> > +
> > +     if (!argc) {
> > +             dcb_rewr_help_add();
> > +             return 0;
> > +     }
> > +
> > +     do {
> > +             if (strcmp(*argv, "help") =3D=3D 0) {
> > +                     dcb_rewr_help_add();
> > +                     return 0;
> > +             } else if (strcmp(*argv, "prio-pcp") =3D=3D 0) {
> > +                     NEXT_ARG();
> > +                     pm.selector =3D DCB_APP_SEL_PCP;
> > +                     ret =3D parse_mapping(&argc, &argv, false,
> > +                                         &dcb_rewr_parse_mapping_prio_=
pcp,
> > +                                         &pm);
> > +             } else if (strcmp(*argv, "prio-dscp") =3D=3D 0) {
> > +                     NEXT_ARG();
> > +                     pm.selector =3D IEEE_8021QAZ_APP_SEL_DSCP;
> > +                     ret =3D parse_mapping(&argc, &argv, false,
> > +                                         &dcb_rewr_parse_mapping_prio_=
dscp,
> > +                                         &pm);
> > +             } else {
> > +                     fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +                     dcb_rewr_help_add();
> > +                     return -EINVAL;
> > +             }
> > +
> > +             if (ret !=3D 0) {
> > +                     fprintf(stderr, "Invalid mapping %s\n", *argv);
> > +                     return ret;
> > +             }
> > +             if (pm.err)
> > +                     return pm.err;
> > +     } while (argc > 0);
> > +
> > +     return 0;
> > +}
> > +
> > +static int dcb_cmd_rewr_add(struct dcb *dcb, const char *dev, int argc=
,
> > +                         char **argv)
> > +{
> > +     struct dcb_app_table tab =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     int ret;
> > +
> > +     ret =3D dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &tab, NULL);
> > +     dcb_app_table_fini(&tab);
> > +     return ret;
> > +}
> > +
> > +static int dcb_cmd_rewr_del(struct dcb *dcb, const char *dev, int argc=
,
> > +                         char **argv)
> > +{
> > +     struct dcb_app_table tab =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     int ret;
> > +
> > +     ret =3D dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab, NULL);
> > +     dcb_app_table_fini(&tab);
> > +     return ret;
> > +}
> > +
> > +static int dcb_cmd_rewr_replace(struct dcb *dcb, const char *dev, int =
argc,
> > +                             char **argv)
> > +{
> > +     struct dcb_app_table orig =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE=
 };
> > +     struct dcb_app_table tab =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     struct dcb_app_table new =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     int ret;
> > +
> > +     ret =3D dcb_app_get(dcb, dev, &orig);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     ret =3D dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> > +     if (ret !=3D 0)
> > +             goto out;
> > +
> > +     /* Attempts to add an existing entry would be rejected, so drop
> > +      * these entries from tab.
> > +      */
> > +     ret =3D dcb_app_table_copy(&new, &tab);
> > +     if (ret !=3D 0)
> > +             goto out;
> > +     dcb_app_table_remove_existing(&new, &orig);
> > +
> > +     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &new, NULL);
> > +     if (ret !=3D 0) {
> > +             fprintf(stderr, "Could not add new rewrite entries\n");
> > +             goto out;
> > +     }
> > +
> > +     /* Remove the obsolete entries. */
> > +     dcb_app_table_remove_replaced(&orig, &tab);
> > +     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
> > +     if (ret !=3D 0) {
> > +             fprintf(stderr, "Could not remove replaced rewrite entrie=
s\n");
> > +             goto out;
> > +     }
> > +
> > +out:
> > +     dcb_app_table_fini(&new);
> > +     dcb_app_table_fini(&tab);
> > +     dcb_app_table_fini(&orig);
> > +     return 0;
> > +}
> > +
> > +
> > +static int dcb_cmd_rewr_show(struct dcb *dcb, const char *dev, int arg=
c,
> > +                          char **argv)
> > +{
> > +     struct dcb_app_table tab =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     int ret;
> > +
> > +     ret =3D dcb_app_get(dcb, dev, &tab);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     dcb_app_table_sort(&tab);
> > +
> > +     open_json_object(NULL);
> > +
> > +     if (!argc) {
> > +             dcb_rewr_print(dcb, &tab);
> > +             goto out;
> > +     }
> > +
> > +     do {
> > +             if (strcmp(*argv, "help") =3D=3D 0) {
> > +                     dcb_rewr_help_show_flush();
> > +                     goto out;
> > +             } else if (strcmp(*argv, "prio-pcp") =3D=3D 0) {
> > +                     dcb_rewr_print_prio_pcp(dcb, &tab);
> > +             } else if (strcmp(*argv, "prio-dscp") =3D=3D 0) {
> > +                     dcb_rewr_print_prio_dscp(dcb, &tab);
> > +             } else {
> > +                     fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +                     dcb_rewr_help_show_flush();
> > +                     ret =3D -EINVAL;
> > +                     goto out;
> > +             }
> > +
> > +             NEXT_ARG_FWD();
> > +     } while (argc > 0);
> > +
> > +out:
> > +     close_json_object();
> > +     dcb_app_table_fini(&tab);
> > +     return ret;
> > +}
> > +
> > +static int dcb_cmd_rewr_flush(struct dcb *dcb, const char *dev, int ar=
gc,
> > +                           char **argv)
> > +{
> > +     struct dcb_app_table tab =3D { .attr =3D DCB_ATTR_DCB_REWR_TABLE =
};
> > +     int ret;
> > +
> > +     ret =3D dcb_app_get(dcb, dev, &tab);
> > +     if (ret !=3D 0)
> > +             return ret;
> > +
> > +     if (!argc) {
> > +             ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
> > +                                   NULL);
> > +             goto out;
> > +     }
> > +
> > +     do {
> > +             if (strcmp(*argv, "help") =3D=3D 0) {
> > +                     dcb_rewr_help_show_flush();
> > +                     goto out;
> > +             } else if (strcmp(*argv, "prio-pcp") =3D=3D 0) {
> > +                     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DE=
L, &tab,
> > +                                           &dcb_app_is_pcp);
> > +                     if (ret !=3D 0)
> > +                             goto out;
> > +             } else if (strcmp(*argv, "prio-dscp") =3D=3D 0) {
> > +                     ret =3D dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DE=
L, &tab,
> > +                                           &dcb_app_is_dscp);
> > +                     if (ret !=3D 0)
> > +                             goto out;
> > +             } else {
> > +                     fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +                     dcb_rewr_help_show_flush();
> > +                     ret =3D -EINVAL;
> > +                     goto out;
> > +             }
> > +
> > +             NEXT_ARG_FWD();
> > +     } while (argc > 0);
> > +
> > +out:
> > +     dcb_app_table_fini(&tab);
> > +     return ret;
> > +}
> > +
> > +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv)
> > +{
> > +     if (!argc || strcmp(*argv, "help") =3D=3D 0) {
> > +             dcb_rewr_help();
> > +             return 0;
> > +     } else if (strcmp(*argv, "show") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_sh=
ow,
> > +                                      dcb_rewr_help_show_flush);
> > +     } else if (strcmp(*argv, "flush") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_fl=
ush,
> > +                                      dcb_rewr_help_show_flush);
> > +     } else if (strcmp(*argv, "add") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_ad=
d,
> > +                                      dcb_rewr_help_add);
> > +     } else if (strcmp(*argv, "del") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_de=
l,
> > +                                      dcb_rewr_help_add);
> > +     } else if (strcmp(*argv, "replace") =3D=3D 0) {
> > +             NEXT_ARG_FWD();
> > +             return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_re=
place,
> > +                                      dcb_rewr_help_add);
> > +     } else {
> > +             fprintf(stderr, "What is \"%s\"?\n", *argv);
> > +             dcb_rewr_help();
> > +             return -EINVAL;
> > +     }
> > +}
> =

