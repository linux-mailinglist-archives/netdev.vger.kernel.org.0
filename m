Return-Path: <netdev+bounces-4867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC22170EE71
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774DA2811CC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976FC187C;
	Wed, 24 May 2023 06:48:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD331FB9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:48:33 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5151FF1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684910881; x=1716446881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rccg7OVTud6nksuh8YjXmTbx/JW2e8/U2rT9Vol1CJI=;
  b=W03Pr3qiBmWwPiYg8gb+He+DgJDHXQDfgZZhKhjpQANJWHpUDiXH1sY4
   cAM0WGY4yapGcedzjbGawQM6ijz+XGavX3B13LSqgtbq9tTJPZMobNlLN
   x+2KRzbQB9GNgwIgF616YP0J2WJFZMG+vtU9eMeE2U+RcTowExtVI3Xs6
   1qa5mEfZXRAuEJAs5kYC0s2MXwtjqFlgLhGSqMzIwg6tfxUBGC5BeJeIC
   3JmEHNmBhhUjFYEutaP8vsuEhq8hsVsDd3uN+q1yrTnuLQoUK8xFlvHgs
   uJ8IBhe7jSgYhAJ/vR4Yq73iM2PqtuQGKMwi7ujjGlwqmRropzPI+0Bea
   A==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="214645172"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 May 2023 23:47:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 23 May 2023 23:47:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 23 May 2023 23:47:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYp+Ic3/2OFZxo8Wl2+JhwQUI9rctpEjJcVk7+U2zPUBMnWLKzhpFFrBBajw+UUBbokxvq3e5r5HWEDPZcAQDpw3bsKr2la+MphyCHepWwFgxv+3r40qI+UL4ZjIHYBhmAbEdREGVfUmfTgKNdBkWbRpxa8xojzkfvsi67FPWxELyDakz//fCrPBzAxYjXCuEeg63QAzRAO/hetZWr/iAtSSniq4a2gOsyQECqP8zRT5FuVrOdKCSWekAKVzkHUWZAF8NDeUuYVPXfFMt50LbE4DxOkHgNE2J8F3VJ/iMwc4Dthty+VqkCcD8eSgzoOX8agYPRrkIm6c6aVdckPnpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5BbWr6iEnoj9uLAhw17+EaMMrQGhFlwSiZyuol6WyU=;
 b=ZG8dvf++wFPaiUFrS/1lzrEbH7QL78fcVfdPRJ2Sg5OmTcoSJ2xrnh7JEJiRYz5U0KR0tuWSKwt/h7Ux3jNgR1CPXRbuux8l0gyac5yHLlMfHFiyHW/7JaI2kJacFrtBBzwjzQlYZlnbZgZhFVxeT8nB8mIrbtxK6aO7Il+14mbVW0gZBGuUH4syDHhtdivEsaNq0o4JyrAGc63hzPlurOpmek/9kr75aScLUfen6yvnJnR1IUTW3sWptiCc0mmDgH+GPsJ60zYO+p21UZ0EmP5Ap4llp11IDqX8An06e0JkkozJNq19XtHoJyTotOMNVqlVUmmTZble2RRyPiUrCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5BbWr6iEnoj9uLAhw17+EaMMrQGhFlwSiZyuol6WyU=;
 b=vIc1hHjaHhAqlG/hQ9MlG5F7nY7TTq0GJhNnj7/7CgV5eF13MIv7vAko1Yg1m6eLwR+/GZ47Q1f8m4lv/OY9j0wCpeDSjLZltLZ9Ip/76tGTYtklpKDD/G8I6zNyXL4QiMxnh2vLgkOI9X3Lp+8ikdrFo9qIvXcXXUPnsdTeWGY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA1PR11MB6664.namprd11.prod.outlook.com (2603:10b6:806:258::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 06:47:49 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4b7f:179e:442c:ddf1%6]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 06:47:48 +0000
From: <Daniel.Machon@microchip.com>
To: <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Thread-Topic: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Thread-Index: AQHZjN0KyVSon6NqOUGG/AUCi0xdma9n2eAAgAEjswA=
Date: Wed, 24 May 2023 06:47:48 +0000
Message-ID: <ZG2zFOFJyUFZfg+p@DEN-LT-70577>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
 <87h6s35dx9.fsf@nvidia.com>
In-Reply-To: <87h6s35dx9.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA1PR11MB6664:EE_
x-ms-office365-filtering-correlation-id: a12cb8d0-bcbd-4302-f3f3-08db5c22c9e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rTnnWtmpMxlRtqhC01oW+RhkTane47CJizpexpl9W2HQ+Qiz3114hb4JZgoHgL317JIOg7HyUrDG7KkMakU0fSU/r35K+OEsY4E2IDMGZmGb0PRTNagc9v64ReZjZF7EInT0vdLn1mX4LYr04brGfKDgySaI8pBX+9W7Yotm12p6wPLr7DXU79w2SF+y8b/Md7Jj7rtnxdSafWl6x08MFckYbXVCvHhHukF3PzYrzQozIiNAkiVGQJCeU7UgySO7fkgEXxlxOFgtE92rjWbM6wYcJaYi8qu0ejcSOXtcNw4+fAdeK/02zm2qLJ2JZv2VaO4zBTgK8AX90okVRo4iqwmCNkOop4G88EGi8vUaJ9tng5KRuUN+TzCK2swmKwUs/A3mU3P0BLuEQOBbbqEDkrAhWGCQVHMnRYjHIddUZf6lXtSvBw2XGVyx+FWsYdXoiqtj539pzUhfN14NCKa9v1r/qjpAyfGYyoNkPEt2e1OUd6qMTB8qSWVe2JeMLB4XEGWZ51RCzkhqR3obKa3oSuOdYL/Lef4Yl7FYvZqBbCBekc9PrLoINGjPhdrUX+TuYGWpZ0RGvWFUHVfN7hpcUnlACvqdc6LLxUE6KVCwjEJxjpQPtxGIzRaRz5aYuN39wWmG8X6+hvS/vkgrcET8Dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199021)(38100700002)(6486002)(54906003)(41300700001)(478600001)(71200400001)(316002)(91956017)(4326008)(6916009)(76116006)(86362001)(64756008)(66946007)(66556008)(66446008)(66476007)(66899021)(5660300002)(38070700005)(33716001)(8936002)(8676002)(2906002)(107886003)(6506007)(26005)(6512007)(122000001)(186003)(9686003)(83380400001)(67856001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c41fgrdFeHV64fTl2tCVqVXrkaatbochq6bur7UyLX4n3DCjU8IGaiExtFno?=
 =?us-ascii?Q?CEX1cx9862Byu+HVsd6N7J3QeYMOvT/vHtFHi/eQql3t+ubwHtSRM5mjlJRw?=
 =?us-ascii?Q?LJnFmckNHII43wpIpCwZXYcbneR2D8vKhkj0VEBGSOm7wIZESgEW6m0bj6mh?=
 =?us-ascii?Q?cNuTPboZdPUzCIFNVwLEv/iYAlBnZ7MtQmhRWhqtYv1BQZFOFFDlzU1EkUiJ?=
 =?us-ascii?Q?QYPaNYtjpwPi1hyovFkOi+Gxa3HReapyM4oo1aQB9x7D4hyldPAym4TfUfBv?=
 =?us-ascii?Q?bHNhRzsVwP+qcnvIEiyuz2jtrnWS66nuhy9JSmeq6a7DlcJ+9Y+Z3KYRm/zr?=
 =?us-ascii?Q?wQWjGd4lzIcZFOTdPEc5LfxRGCACrKXQTSsU75Z9mwK+OU9jYZMYAdGqCI2z?=
 =?us-ascii?Q?0TA2F3idXIklmeFXyL08cATQsVSj9z/Tn3m+Zl19ZAdc10q595nj1l1OMvMO?=
 =?us-ascii?Q?e+XMEbkDbqoCdTVLXoGWPcqWVBpacfKVOD6LhTAGuToN5UP79LLFWUB11XB4?=
 =?us-ascii?Q?UOMI5PvKQfAL3jZ6uT4G9dCR+cSwC//GStdu7b9e6wGYfHfk39oQMCU5G67m?=
 =?us-ascii?Q?wYPSjK+YGvj4Z2lKZOs6OKoxt3/yYu3piPdQTGE8JjUPA8GJnd7EwGxElwed?=
 =?us-ascii?Q?zCWq6Pq+vRqtsVqRSZPg2O0Mci/eUTrNN49ICysnykDaRPfxykug8gJjTU7R?=
 =?us-ascii?Q?MVuYRikeEiKo5AvXdbW56/lfRs8gwideZ8iSqHgL1EMJ8YpZ8iv6bER+ll3l?=
 =?us-ascii?Q?q4OzBB/4Zq8ahNqDa0jUKoHJRCyxLiPYt5WZXVn4COZlhoOlW3OiJlc8s+hE?=
 =?us-ascii?Q?VwJ7CsO2alzW+raJ5BfOmxFHfejXYbXpMAQQ5qIfGfC+u0/Z13Z7XgvXoNhO?=
 =?us-ascii?Q?lTn3BRxa2QeOWiJw+ln+3qNqMzL2/CGCP61ANhYd9/zdy1qxEOo5wQlq+Gq2?=
 =?us-ascii?Q?VtC6PFAi1z1kbSo5HE+ykUfFLd/rTm1MVccRKOTEzOdSbLTa2a96I00o0NYS?=
 =?us-ascii?Q?d/PchCjf0adH6mPwNgBskGYTN68+Qg4o5XGsf/eRkg5CLxvDj+xLwtn2K+T2?=
 =?us-ascii?Q?X+ahUOmd6fmwySW2jdWUPBKkwk7jHoTJU9fNsj9LG3AEn2wSS9Wf1nxo0Y3f?=
 =?us-ascii?Q?ddSH53kKvl1eb1KqWwafWSL2JBJ3hS6gEXJBiNIr+O5nFce2/975rWbh6qbM?=
 =?us-ascii?Q?Hd38bnxqh6i8T1+0dQo7DLSgY35dNRLVsegwS50LnFOcDB2MA3VTWBob9Hvw?=
 =?us-ascii?Q?AhhdmsXli7vPTNa9TAW3EffZc2hXy9EW/4Gxy+P9IUWq3aZkHzA/UTTwjCqZ?=
 =?us-ascii?Q?C+wUg+sulg8uXNMd+z5QoRMzBJ2e2D/a111JlytbS1c4041S4j6EPGBgoKAX?=
 =?us-ascii?Q?0MQjRt5ayPy2jb6PwXwpl92p/Pht+MJ9IDJZaNEB2ctRXaiLam8C2Qc/koSX?=
 =?us-ascii?Q?+0/hdAXA6d2t7VPdzNavBVMvmZnhVJJ8C6aOCJoDagV6o3V2BM0IlGpgUZ5D?=
 =?us-ascii?Q?hyJ9vkXGQUNcS9NOIwbVMfe4WrIbVs261ZwDOz/pjlrnl9aX7qHDjqIcUOkT?=
 =?us-ascii?Q?JfGC+3O4rptU5MZ5hd8WQUheNVWdtqffrfk+yvE4kkAzxVXSVkXckptARCwa?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <469F3F7B1DB0EE42A5A97BF175DEBDD5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12cb8d0-bcbd-4302-f3f3-08db5c22c9e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 06:47:48.8793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vP3fzv5Z6rdn5G8CxiIIqYQblvsh18lhL4pdmWbmzDAZvEboG/BT7wIeNW2szknzyTgg9UB9wClaQxpILbPoTRK5ZR5HhpoR33QBom3JR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6664
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > -static void dcb_app_print_filtered(const struct dcb_app_table *tab,
> > -                                bool (*filter)(const struct dcb_app *)=
,
> > -                                int (*print_key)(__u16 protocol),
> > -                                const char *json_name,
> > -                                const char *fp_name)
> > +void dcb_app_print_filtered(const struct dcb_app_table *tab,
> > +                         bool (*filter)(const struct dcb_app *),
> > +                         int (*print_pid)(__u16 protocol),
> > +                         const char *json_name, const char *fp_name)
> >  {
> >       bool first =3D true;
> >       size_t i;
> > @@ -439,8 +437,14 @@ static void dcb_app_print_filtered(const struct dc=
b_app_table *tab,
> >               }
> >
> >               open_json_array(PRINT_JSON, NULL);
> > -             print_key(app->protocol);
> > -             print_uint(PRINT_ANY, NULL, "%d ", app->priority);
> > +             if (tab->attr =3D=3D DCB_ATTR_IEEE_APP_TABLE) {
> > +                     print_pid(app->protocol);
> > +                     print_uint(PRINT_ANY, NULL, ":%d", app->priority)=
;
> > +             } else {
> > +                     print_uint(PRINT_ANY, NULL, "%d:", app->priority)=
;
> > +                     print_pid(app->protocol);
> > +             }
>=20
> I really dislike the attribute dispatch. I feels too much like mixing
> abstraction layers. I think the callback should take a full struct
> dcb_app pointer and format it as appropriate. Then you can model the
> rewrite table differently from the app table by providing a callback
> that invokes the print_ helpers in the correct order.
>=20
> The app->protocol field as such is not really necessary IMHO, because
> the function that invokes the helpers understands what kind of table it
> is dealing with and could provide it as a parameter. But OK, I guess it
> makes sense and probably saves some boilerplate parameterization.

Roger. And actually, yeah, the callbacks are used heavily throughout
DCB, so that fits better. Will incorporate CB approach in next v. I
think this applies more or less to your comments in patch #3, #4 and #5
too :)

