Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF5249EB4C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 20:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245685AbiA0Tsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 14:48:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:59183 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229735AbiA0Tsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 14:48:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643312910; x=1674848910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fOKkvvjM7JhFTxpiow5fYAV+V5Ytnf+RZSyHwN08n/4=;
  b=bfNy07tDNXf9+tiST6uLpK7ovp44fTGo9oE4lxLgvXEiYi4Qpj3N1SyZ
   hoxnRnjOlkNUoCt8t01Gjsij7p4FvTNtI7xzTLo4nu529fUh71wRQnM1W
   uAeZiJHKle/2AX6nRWBsqJmccoWRoF1PsxmT37OYO0NEN5aNzHbarL3t+
   v+uMTJrIlBymAqH18HbQSOeMrVwyNO0bBebQRr4geft8dXjYohF8ONLoG
   YjNYoGLKIanhqoPoE/ufGL96HmtWCb1sTs4qyTChoNtF6IhaVJrUuexcj
   tmnGgRX3WfjSmwk5uDOF7gDxtxaQr54pvqL2Uj01Ggzu9qoTp0sRwgF75
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="271408272"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="271408272"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 11:48:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="535801097"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga008.jf.intel.com with ESMTP; 27 Jan 2022 11:48:18 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 11:48:18 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 11:48:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 27 Jan 2022 11:48:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 27 Jan 2022 11:48:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuShRp7sUHIAUJITpOshq6e8EAlU3nLCC81FlNyoYvMfyLLGLYlKxJFh9Ctzh2zjvBXTNE62yehBIZ7yoYtBMdOeg9wVpsx8CEjoR721dnjR9YU90up2dw3UcGfmRVNfr+iLOGXLjEWtloqajiiEi1xDdEf7p7+S0POqX8JYCjPX5vhFzQFQC04UgMYJbTAL7p9+2HDSIX4tpHvSM8WMrPp54C888WMXVtpOGaxMM7JEl4o7gPu1bK0TQzxaY5DeRZFOo/mPuCO7O0c5cJrAl5BBEaWZ4rCRYNWxC5O2UgPmcAD7waZsKLpmkeMhsT7DeCq+FBmhMbUmUkluI69vsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ie08Q0EBLMT8IQr9Npb7GHXHxbkEcSVyK42jQAuMyH8=;
 b=TVD4c7yCdaWvSvN+gZ8SiMHLHEiXfSNQgdyN+wqlj816PXBXqjTZqb2E3DmhnM3a4bCD1ARA12+JSpkX7zULMXa9yP3BBDuXKT6QuxzhWuggU9q8CwZ6YmgDT84geEau61l0bKNVJOBZ2V9RXikYfnk+Naa3+2SYCKk0dklJ3sYp3JktYU5Bvvq3MQZg9pIKfGwczIKp4+lBMBCKDftY+LLHift52a88Ehxsj4jMDCP4lOD1SiV8vVfH2zGCQH3fQgNjx4NN1PXSkr3A8TmkKCAm1/hZ8zYyxJ3iqql4Ni0U9G2uWZTj/X5EeqmeLJ0UxAAOwvVWzZO8EoLDGgcW+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM6PR11MB4156.namprd11.prod.outlook.com (2603:10b6:5:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 19:48:15 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 19:48:15 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>
Subject: RE: [PATCH iproute2-next 2/2] f_flower: Implement gtp options support
Thread-Topic: [PATCH iproute2-next 2/2] f_flower: Implement gtp options
 support
Thread-Index: AQHYE6GOJlIjm2xYkECQsDWIk5oi5qx3RLlA
Date:   Thu, 27 Jan 2022 19:48:15 +0000
Message-ID: <MW4PR11MB5776C847D3EA30238E35CFD9FD219@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220127131355.126824-1-wojciech.drewek@intel.com>
        <20220127131355.126824-3-wojciech.drewek@intel.com>
 <20220127091541.6667d4d1@hermes.local>
In-Reply-To: <20220127091541.6667d4d1@hermes.local>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2df13052-ada1-4394-a791-08d9e1cdf59b
x-ms-traffictypediagnostic: DM6PR11MB4156:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4156702948C0B3A4088AD268FD219@DM6PR11MB4156.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rlc0ztkxrZgX3mBstFJk2TRPQjqm6YCChkAxR4OyhIK6IZ1mZ3xngz4Df1JI3ENAMqSnmNgeG/0c2mnUP2tAsH1oqyAGo93X39tYbFEY9uCbvcmCL8X5djFO8Vi5W6hcTv+tEtt59ko48bxrYEgG8DVFzQq81cgIjvxvtUQql1QeLqjUsqRSs6zeR64lNCjp+JKl3gBGAgRagZN6KYOmYW9CQT1pvBAWL0WHRw7PM2f97+g8I4SWR0iGCVKA3XBHiFKMiDj2umpdbOsNmtooc2sMsg2vUsct72i8RvpSgXVp8/OiGrXEvCx5HEX96tP8bwCpCwBk6NEsqkmlzu5ApiIq0f+jGSpVwZojsvUmETI9XbJSm10mQrUxXIa7jRwizIeCvpDANgVXbCRzikE/Kx+9tnFdK1VhS/u8czle4mM3zI2++aIYlL3faAPWakaggm5FwdkW6WETQIqQfAKXQoc5LaOJoQq/rYJCanz6/BQyAGuVslXAnKd+yo+F45rFE7qfTk+JJPVBJiUjRq+VWmP5SaW/6rtxCguIslIOHspyEdK3UjBoozqB+2BFfWxnY0E9wnDpSJFlY4Xf/qixENSepBDCEvpYf3Zqk54GDpUwNbbd+/NkzYVjqJdSt1SQnCgZNrD7HET4TGcZJNPP4f4mU2oTGy3qvklmI5wedcr8yTrVvNUB6xT7xwc4bK1kSJ0HYrw2T7jnDxyKqStS2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(52536014)(66446008)(66476007)(8936002)(508600001)(4326008)(66556008)(8676002)(9686003)(66946007)(82960400001)(76116006)(86362001)(64756008)(4744005)(83380400001)(5660300002)(6916009)(316002)(122000001)(55016003)(26005)(53546011)(38070700005)(38100700002)(186003)(71200400001)(2906002)(33656002)(6506007)(7696005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DCYuNxZALRsVjSxiN+YlzwxzCpV7QRnP87CyZiO8Lm7LX4UX1ZwbHF52ce//?=
 =?us-ascii?Q?ViRlMMqw4msKxrzgSZxNeZKRlEdvGxCMTULL8CUk83WQ4jbWwaEXGG9wvWjv?=
 =?us-ascii?Q?IP3EaUn9WLhlvbl8o9Vd3a1qFCeVIYpoZNe2Vc5vLz5aLBj79f5wH30zmiaD?=
 =?us-ascii?Q?pJkJQx8err45EJk4VOyEYCNCPMbkPQcyHXeyNRLO3adtSddDqVMksXAHpveo?=
 =?us-ascii?Q?vAcPawgPxe8rCKRKvFl5XVO2/DJqvXQB9zWnflwxCNNvlgL/aFJlDoMVk2wZ?=
 =?us-ascii?Q?3boXENYi70b/xTBAExx8bZDru6bqNb6i1L7DMBiZJ5sZTFoczD/zAsjX5XoS?=
 =?us-ascii?Q?1a/7mpJiw0ZD6T4MlHRNf2nmALIWpEn5e4Ex8r2PMvY8UKI4WkjAqlUCcNj6?=
 =?us-ascii?Q?FiicaH8c3L+dG18dVUOAAl9ue1tzqgGwmSNkDWQ3b2ZIPREDTHlAPjPDZ/LC?=
 =?us-ascii?Q?v7N3GoXGcH3qAgslR1jDgdBZb7gbyHNNo4yePaWRS9Ivdhp64S2tb2nQpHsH?=
 =?us-ascii?Q?k3dFd932M6O2sLXmC6hPoEmWciR6qlbLizACPkGNSC63pS1xPK/SWOxBqasW?=
 =?us-ascii?Q?uVMOIF2RdsRBiiYUvE1ewbYPcGPb4SbZq5r4/Req5N32IrhJBr6sKA800BWV?=
 =?us-ascii?Q?0jGgfzC5E+mmZ3YOVusqjNepTF7PQ5JU44He65kF35ypNXgE/njBks+97F7E?=
 =?us-ascii?Q?RGSceEmVDFVMgFnGNojtZ2HWYH6egJQ2T3Dtz1rnJvthe2z17ZTO2YH/8FqO?=
 =?us-ascii?Q?oRzmDxfl4gb5U4hFwAO1d9Og8pB6icY60GThkCNP4JGNSaQktv3h5Kg70SMu?=
 =?us-ascii?Q?BVIjSKvEVTQzM3IIi8wInPy19O4n/2Ko1NptnJ0zsGZDjj6aErFPN7vrAj+z?=
 =?us-ascii?Q?p3e0fOqmDczgfrYrFDbOF3sY7HyCJ7EfLKO917monuE6OxeNbIwFUbgeiJMA?=
 =?us-ascii?Q?LB3/4pbw3mXGEoStGrV/I5TfQs0EbkZ6+LCZcMSbpQDyoCMecTJSJykqaGEo?=
 =?us-ascii?Q?A6cPO2+AjQtJpVSCh6xzZsld9gbGexlSlLZw+wsUu8QsCfENBILUYoYo66q5?=
 =?us-ascii?Q?jQnpl6cHvAHCDcrySOBS9prRhzrKl04LeWzGCgOorwT+1W8k9F4t5JOcLJZ5?=
 =?us-ascii?Q?FUe9abDndiisGFuDTeLCLOiHkOTk2JA8jKfGxMWGcv6rIn35xz2+kMR7i6NE?=
 =?us-ascii?Q?QWSnmbN+O1Vv8o7Wy84/wazZCetYLHeqtomuKBkQbU+7UGy/3t9hBtBd+9J2?=
 =?us-ascii?Q?/Gs3d+mFzUU4qoGAmzwGDZT+Jk6FSTMIqE44QBhiDqrL0HXMcomeD5eKx+zu?=
 =?us-ascii?Q?ElLfbRfO0CfynNgzYiHX3jFsmwWhcX0TUJ5wP+e82ygUgCwpIGYkESy5o7ho?=
 =?us-ascii?Q?mjmDZsN4vknbALAxpcqO/Aghc5n1x8uS+Hn4YoJ5fQjIzkcSwaIdETqX6x0K?=
 =?us-ascii?Q?wbQ9MQ2R65k1Sc1pRRCJJa8vtAxOYAsk+vHlF0/0//gdD7mNflAZcQJ6QaDk?=
 =?us-ascii?Q?wpezFGqpvtLDACXVaRE+K7RhkSunKFVRSTejycuOVZQi9spVuN5cIt9zmSAp?=
 =?us-ascii?Q?lpascp8U653f7plbW8MlbYrgC+2wYw4W3HdzEzHrNjo196ZA2z2brOkbIcfo?=
 =?us-ascii?Q?oKMX2mcy3cscKoQNPX3+A4LdZRYu4X97bpYMeKYFIBm/Yh61aouKPHAk882X?=
 =?us-ascii?Q?c0nH3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df13052-ada1-4394-a791-08d9e1cdf59b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 19:48:15.3706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2/AC8wS0IHjcylnAHsk/VeSCYCAd/8L3a9s3GknTYQadeEhS4y/N+mQEQYBSZqURjQF+0kyvTz7+Co3ciTdTlULTMDUbqM9h20eBVoyy2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4156
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

I was just following the approach used for other options but it looks like =
that
JSON specific code is not needed. I 'll get rid of it in next version.

Regards,
Wojtek

> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: czwartek, 27 stycznia 2022 18:16
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; dsahern@gmail.com; michal.swiatkowski@linux.i=
ntel.com; marcin.szycik@linux.intel.com
> Subject: Re: [PATCH iproute2-next 2/2] f_flower: Implement gtp options su=
pport
>=20
> On Thu, 27 Jan 2022 14:13:55 +0100
> Wojciech Drewek <wojciech.drewek@intel.com> wrote:
>=20
> > +	open_json_array(PRINT_JSON, name);
> > +	open_json_object(NULL);
> > +	print_uint(PRINT_JSON, "pdu_type", NULL, pdu_type);
> > +	print_uint(PRINT_JSON, "qfi", NULL, qfi);
> > +	close_json_object();
> > +	close_json_array(PRINT_JSON, name);
> > +
> > +	sprintf(strbuf, "%02x:%02x", pdu_type, qfi);
>=20
> Doing JSON specific code is not necessary here?
> And why an array of two named elements? Seems confusing
