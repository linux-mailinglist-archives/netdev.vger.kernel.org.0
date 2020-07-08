Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF17217D71
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 05:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgGHDP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 23:15:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:49359 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgGHDP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 23:15:56 -0400
IronPort-SDR: q2xmPCBnBikyeyJQsoyE388KinnOJKUSjsLKUAEttSxT4yKcE3Zhve6191DskMRnm2HrB5vzw3
 pGk7HQHEGi4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="212677713"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="212677713"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 20:15:55 -0700
IronPort-SDR: rf+ZLxZGAY2AeuiqRd3dNZxvZeFn0ONGQjgJ9wiq9lxIdhxZCDRZ0Yn6ODp33m9tZaxUrB7VZZ
 rrGqWmo723DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="483733312"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2020 20:15:54 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 20:15:54 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 20:15:53 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 7 Jul 2020 20:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TunmIbYO0fEItQ3c4UKOhVz6MlqlZJgPQKDrupiU9kER7a2k5rhNn2OoQrNwu2Ew933irfxSbMjdmvPpNuEbmaoxzqN0mw1PyNSx8Zsi55dyLxvFQK5kjH3Qh/1xku1rHuTxrXVhXY4UXfAM6fQ1wwGrT9CnWf0T4xJ/pQlUlSgGOqXX0TlldwnFtK6TiABC+gniGacfJgaQqmDyOkWbyqvAkpIIIBErlGUhOv7WhVPXfwDR2B8TNnrD41FcQ0CvO9kauVfD0yU1Jsp//XsUfWInLyOqjHRz0S4wgmbNPIkHcPFW5D1WAgfrCkq2Luv1D+hcUDpX61cCXHU3hPuYrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJN7k7NumL3zguwfgMaJij1/ySMtGs2+D/pPuT3zo/c=;
 b=WTJ23kHw48jvxxKPaiAXYrCRPcpE00dFn0ZQV8GtpS1aB1BLV3DRGOq6dfuIgeDvkpR52at2HO1sONfaRj90n9bS+3BRE9vQz0NdJxsaAR/MQbX28EqjcdyrP3kOtWhKaH1A7XcmwasJ6/QA9/gUaSpMWatrDZBifknSquFDmr/DPsnc94JAF4r5bIzKbz5FDTdbyQPTWJ4hpizAmAXOpLAMPfADzJrp2po+ZZwyLKwOQCOkbx+4GuwoVeGXFc1vKSV9gj7QKJkPO8Z/HoMC9xw01JJIFtIyDSjFGAOC4I04oIJbRkYkuTHsgutkQnl4H8byr4qscjqfTQe6PZgXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJN7k7NumL3zguwfgMaJij1/ySMtGs2+D/pPuT3zo/c=;
 b=VroTI6y46r+pP3vO4kQQdF3INSm52y/9h7YAw7HhmOZPlbNez/XG3nGlejaAp+yn5UuyPD0H/NGnn+Lg65xh3K1fk2TG2Ed8WJM4YsxQXOEfTHtmjdHQ+Zjg7gql4UMTn1RMCGoo+rxXeB6dtkhKB50Ff11jGKxyV++CojK/N7E=
Received: from BN6PR11MB4049.namprd11.prod.outlook.com (2603:10b6:405:7f::12)
 by BN6PR11MB1282.namprd11.prod.outlook.com (2603:10b6:404:4a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 8 Jul
 2020 03:15:45 +0000
Received: from BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::5960:d54:eda9:ab84]) by BN6PR11MB4049.namprd11.prod.outlook.com
 ([fe80::5960:d54:eda9:ab84%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 03:15:45 +0000
From:   "Xia, Hui" <hui.xia@intel.com>
To:     Edward Cree <ecree@solarflare.com>, lkp <lkp@intel.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [kbuild-all] Re: [PATCH net-next 03/15] sfc_ef100: skeleton EF100
 PF driver
Thread-Topic: [kbuild-all] Re: [PATCH net-next 03/15] sfc_ef100: skeleton
 EF100 PF driver
Thread-Index: AQHWUbnmjnB7Nhm1wUCB0zmq5d5pk6j8dyWAgACQyUA=
Date:   Wed, 8 Jul 2020 03:15:45 +0000
Message-ID: <BN6PR11MB4049AFC1E2230707C1FE8950E5670@BN6PR11MB4049.namprd11.prod.outlook.com>
References: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
 <202007041218.2NXltj0z%lkp@intel.com>
 <24a6f07b-7888-e722-0c4c-41fb3a8f3cc7@solarflare.com>
In-Reply-To: <24a6f07b-7888-e722-0c4c-41fb3a8f3cc7@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: solarflare.com; dkim=none (message not signed)
 header.d=none;solarflare.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da3717b3-aaf8-4609-e217-08d822ed34ad
x-ms-traffictypediagnostic: BN6PR11MB1282:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB12821987D7D1F2BE1694AE02E5670@BN6PR11MB1282.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fAvoxKOQn9xQEcBLSHc3N4720rs03hpfxZGmmgKbWoF9McGaKdEYm5Bx0SxIHaQWFeVFowxW9HIKuw6+OF0eFZhKneeAzCehGtCHzOXVXc3f2LYYOV3v1tk6PLyXWfuU6FDCieJGMdw/Gq7HG7k9knkfRDgqA0d3zdARjraeuIbNevmbrrga67BXhXJjEnBynf6xZe6SXzrbhzp+a2xaB1t5qjq2EngBC24vh+op74IO5xFUqumxHJM5NYCnJfLtlRPDIzgH0MrYuGY0V5cmu4M3GrbdIhRwEU+IWGb9sBOnVtyPRHRHyxWjCCVPKRDdhP4JptjZI9w2/SBGQ4xOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4049.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(76116006)(52536014)(8936002)(478600001)(4001150100001)(54906003)(8676002)(86362001)(110136005)(55016002)(316002)(9686003)(71200400001)(2906002)(66946007)(66556008)(64756008)(66476007)(4326008)(6506007)(66446008)(83380400001)(33656002)(186003)(26005)(5660300002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ICNgzdwj4p9pYS16ph1LhaIiXlG7QL84O+iI0c/XoXGrK0AjfZnIf3MnB9Y0IM4jCL06Qy0GTFKdKTAgzUlU9+L9lGLns9xk1UmU+ykMLWdR19RmNKxIutoU0mZMR/dSEob0KK+gWSqZRE6M6OIjXjnlv8GZC9jzZ7XNH47sDzENPifwBDyC55mddhaB3yD75Oz/DUuuGASP7epbaNNBE+0p0MpQjOz7A4rkhQwIAuPtKLK4jUlZH1QbRV4tiqiGkqcSpuVKvsakh/iM76Vk4jDotI09gefQT15XAJV6SxsWB2gvKAO6m4+8nK7w7Ts1GNuhMAFzauY1VNWzRPudoH7lcK1cwat6uoPnk3tVLZdBFpoGAi6/WzpZamZY0s9uBlLojboP98SgJ+5eCVXLdprhQN7pLkfO5JuYQwr2tUQTAYjx3jE7UnIPAmr5pID7VVzRvBwfCdl4Ba3s5cvHtNLKlRK2i81r/r+cVgv4mp07IHzg8U8kK8XV2NAGUoNS
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4049.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da3717b3-aaf8-4609-e217-08d822ed34ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 03:15:45.6691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dsL3b3lB075N7+tPlaQdrvsYgHQSlG2Eac09IW/L7W0In7EiXsr31f/bGEy8VFRn3x00FdlroAWR7vefkYKMRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1282
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Edward Cree <ecree@solarflare.com>
>Sent: 2020=1B$BG/=1B(B7=1B$B7n=1B(B8=1B$BF|=1B(B 2:35
>To: lkp <lkp@intel.com>; linux-net-drivers@solarflare.com;
>davem@davemloft.net
>Cc: kbuild-all@lists.01.org; netdev@vger.kernel.org
>Subject: [kbuild-all] Re: [PATCH net-next 03/15] sfc_ef100: skeleton EF100=
 PF
>driver
>
>On 04/07/2020 05:16, kernel test robot wrote:
>>>> drivers/net/ethernet/sfc/ptp.c:1442:1-4: alloc with no test,
>>>> possible model on line 1457
>This one's a false positive, see below:
Sorry for inconvenient. Please ignore this warning.
We will double check for this type of warning. Thanks.

>> vim +1442 drivers/net/ethernet/sfc/ptp.c
>>
>> 5d0dab01175bff0 Ben Hutchings   2013-10-16  1434
>> ac36baf817c39fc Ben Hutchings   2013-10-15  1435  /* Initialise PTP stat=
e. */
>> ac36baf817c39fc Ben Hutchings   2013-10-15  1436  int efx_ptp_probe(stru=
ct
>efx_nic *efx, struct efx_channel *channel)
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1437  {
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1438  	struct efx_ptp_data
>*ptp;
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1439  	int rc =3D 0;
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1440  	unsigned int pos;
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1441
>> 7c236c43b838221 Stuart Hodgson  2012-09-03 @1442  	ptp =3D
>kzalloc(sizeof(struct efx_ptp_data), GFP_KERNEL);
>We allocate ptp...
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1443  	efx->ptp_data =3D ptp=
;
>... assign it to efx->ptp_data...
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1444  	if (!efx->ptp_data)
>> 7c236c43b838221 Stuart Hodgson  2012-09-03  1445  		return -
>ENOMEM;
>... which we then test.
>
>So by here...
>> 7c236c43b838221 Stuart Hodgson  2012-09-03 @1457  	ptp->workwq =3D
>create_singlethread_workqueue("sfc_ptp");
>... we know ptp is non-NULL.
>
>-ed
>_______________________________________________
>kbuild-all mailing list -- kbuild-all@lists.01.org To unsubscribe send an =
email to
>kbuild-all-leave@lists.01.org
