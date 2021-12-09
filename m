Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB0246F361
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 19:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhLISy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 13:54:56 -0500
Received: from mga17.intel.com ([192.55.52.151]:37028 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhLISyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 13:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639075882; x=1670611882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LWl1/aiDk7KSW1ROcrFFwsJWUYUIM1rbG8lXPfSFL44=;
  b=mY1rh+SZ5lqSz1bK5I9uPFZqDequ3pAz6fIdX4WrlTOeOwUJBe676HVC
   HB2JJiCUu+PFDHduJh5AZZ+QnNUOb5GCAcsLtoYfRnN9onCM4K7adyYoD
   jqHEBx8/aG0X1edNWoAhdHKiw19XrlUYx819XjJ1fBM2V2MCY8Xxqhi2D
   MCl3+2RImYDnxGE8+XtnqR0wwnBKFGCsuuRkiY1mrUqrb9DcTAPygZXH6
   f2fMgpEB8URLaGJOTvRAwGicl2vmRlJIkCZfSsYV+pelopmWSmv5RJqsm
   4ZNy86aViQ8/EmnbLoA/p992tVPSGyZYZlDSEYKwZ6J9rvvWWhViM4oSP
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="218872941"
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="218872941"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 10:50:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="463361278"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2021 10:50:11 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 9 Dec 2021 10:50:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 9 Dec 2021 10:50:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 9 Dec 2021 10:50:10 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 9 Dec 2021 10:50:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmttH2R7lE4PeWMcG9yguNJkWXLLmcyL86AY0WYfBbu9+/XT7x1Zvxnkdsrr65zg+juIInSdSoA6uWM17MJ0GOJtbhr28dR9VJQzKodGd6ucmZDFHsAqkc4950nqZ8DYIZ0rN8xIGGVSLRdvJjk4/zKYgV+Y2VkGfX6Ts14XsXNeEcRwa2jxYAjn5yS1mQ4Gqy59D711fV8c05pefM2CgWtMkGMb1To64XttlhbkZYltwLhw8W4Czzt0aPQncOrrzb+np2iv3vVXAouHrYftpBYiEWpv15dQKd7f6VktjqaTnZPe2ES6/VK7MTCbhFo54di70jO9bC+ZkkAv9Wp4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWl1/aiDk7KSW1ROcrFFwsJWUYUIM1rbG8lXPfSFL44=;
 b=O9WPZPmlVr7awQ+rO7pjTOBDmCMCW+ltDd1CeB3ZWbEMyed7rmI3GIK1jOi/2IQc19LGxY0FrlHWACalzDj0vb3mj0E288CGQmk7VUb24MAIf1gvjX/EZPQch6pNMR+6x3ls5fWlXPAgZw5GstKsCL+3CXs8eXyvj3TAPZkqm3qrlzHWqbzqbVWjo69Ny0q2Go7t63JZ252YAQS1iaJnMhVeQJNkugMt3nJwZ4uiIOaDTGWZT85fjYQFaEJCwKjvwcN7hUWheOapdWO0uqsuFvWbaklu6aiMSMubWDD97f4wYdZ9krpK2glLX4mPmEweLoQpA6C0BvvdYR8N82bKpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWl1/aiDk7KSW1ROcrFFwsJWUYUIM1rbG8lXPfSFL44=;
 b=xHrqD0y56GPpRM+IyBXJLN419XrJ2/q+fT/WifSbt41/3+ahf0ofuCGE3zs2tjfDgNLUMmrvXr8NxTIeIRY6DHHSuELapYFSIECgn1PzJgBrSSzRZgyJzzWcIL+EzPfVBA8zCu8cyJnfF4G4cW/EEx3Eq8SccXKCUfQ0j2NHwrk=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4827.namprd11.prod.outlook.com (2603:10b6:806:11f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:50:07 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 18:50:07 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>
CC:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 2/9] i40e: respect metadata on XSK Rx to skb
Thread-Topic: [PATCH v4 net-next 2/9] i40e: respect metadata on XSK Rx to skb
Thread-Index: AQHX7Dz8jVSzpJwUVUqkU7i6x1Lp96wp1MSAgACZ2gCAABPOgA==
Date:   Thu, 9 Dec 2021 18:50:07 +0000
Message-ID: <11db2426b85eb8cedd5e2d66d6399143cb382b49.camel@intel.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
         <20211208140702.642741-3-alexandr.lobakin@intel.com>
         <2811b35a-9179-88ce-d87a-e1f824851494@redhat.com>
         <20211209173816.5157-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211209173816.5157-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df0ff253-49dd-477a-ee9b-08d9bb44b894
x-ms-traffictypediagnostic: SA2PR11MB4827:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA2PR11MB4827674182892F234227FCE5C6709@SA2PR11MB4827.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gP1k1ZdX4ZSrZkNKV1eNjW1eVyrefZ+YHTa7HKN4xtRHSGDCGhQ/XfyeIkrqhLUmV9bk5E27KltszzG4VWhPGs50tYnwBGXlbO6NC2vW5RiwQJ14Nk2yDY9c1DZnXmA1coP2totAa7UDOcdNXRSVk+cbV/y77zCxoRacqdkStewb006qpGIrkxmVzbA3nnmg6mIFnV0KddF0FMjYUfHhr+7viFQWfJOimWXY1FR3sihzI0flZ7FT6z36dqwr/zaCw9IBUYSRD9NHFnrl7jfprdM0eV36yKELIVtyRjO5+4JcTq98XR1IRKpQIEGcteAgB++d+8k543PJPbFJhpnXbxnWHte/nCPxaDqwNV8KZcByzi0pYx6Dqtu2nmRAVPph5U34EE6FTDvQDIQ1WGeLsBBdDwf4Yc1U/9fZ/dkrnS5xR/6yEPmcZGR/zJP8ZWf93pEiz/OjdMOBqWW1+D8rveUpiJ7VBTwDCzdZ1AzUaUZaR8JVQPPaLb+0y+uVdX73rDMd/UC48AA8HNPHpURp/E3mc9T08u0qsxXANp3ERPIR/Ped+DVcK9wWMLLjHV5KigR9eDOs7Tn7YNXCX44vt63fc5+NgRfLgfuj5DQq1gyHb6gn4jgF0MLlmmlQjggvTPA+rbmmUkkBKGphz24gB1QT6M+2TjfSOlANS5zZgHRKpVEhDZQu7/Zf6dBVeTa52E6lBLpmhQtne75RblU+Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(66446008)(66476007)(64756008)(76116006)(66556008)(71200400001)(91956017)(66946007)(6506007)(110136005)(38100700002)(7416002)(36756003)(38070700005)(6512007)(8936002)(122000001)(8676002)(5660300002)(82960400001)(508600001)(2906002)(2616005)(316002)(54906003)(6486002)(26005)(186003)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFA0ZEJVM3ZZaDl0ZWNoaER4ODlSbmdMeWpsNDNnRGM2K2RQWm8ydld0NytZ?=
 =?utf-8?B?SXcvcTdsb1g1dW1RWmY1NXgxaXFZRTgwV1dabXVtR0E1YXlxSnQxeDFuSkxh?=
 =?utf-8?B?cXRsaHhPcGRYdXkwdksvYUk4dXlyc1Z6RFNWcUY2VXMxTHdMcVlUT3VNKy9N?=
 =?utf-8?B?a0M1WEpFSjFTTTNBSklyZ2xlRytEeCt6ZzRzNzQ0ckFIQjV3MXJ4RCtlOGRQ?=
 =?utf-8?B?MVNpMHFXRjNFVXhEZDlZTVdJeVJvREtwK1d1SnBodm1pSjdZZ2JZeFRGOW93?=
 =?utf-8?B?SGYxd1JuMWN4NHpodGhHTVBVMGFEaEptN1F1U0xIMVVocDJoQkpWU0pmVE5k?=
 =?utf-8?B?R3VBV3VjeXBPY21ZSnFrY2gvaDFHQVdJZTBCZVlXY0xJTWdRVklBaDMvTXdO?=
 =?utf-8?B?bHM4RDV5T3N0RitCTWFscWhtd2FyZmp3NURGZGc4Wk5vVGRlMUlYZ2MzVkhx?=
 =?utf-8?B?OHdZb3pjQWEzNmlPV25YTHZ3RlBmTE5SM1RUT29DV2toZTJpdG1paXNxVUdF?=
 =?utf-8?B?SmRITkZSRSt1MzQvTlhRMUV1UnJVeDBMZWRRZStiUkZuOVNnLzRUbGZxMCs5?=
 =?utf-8?B?eXN3V1AyTnhqekJjWHVxRGJPT0E0a3RSTi91ZWhkaW9adUVGSXFQR1R4UXEz?=
 =?utf-8?B?MzdKa1B1bnQ3NFRhazZqdWUyYTlmb1ZEalRkai8wNWZxTE40Q0NpbXFDa0dh?=
 =?utf-8?B?bjl3d2dMMEtJL29sM2ZjTzN4WmFGZkpGNXhoSU5vNGJ1TVloNU12eDIzVmJ6?=
 =?utf-8?B?akRrbUlqK2E4Y2Z0YncrRnVFTXJHNTB3Q1l0eC9haHZydmcwYnk5cEVRT0JE?=
 =?utf-8?B?aitvMzRMdGNIRytFbDcrUHZSVkJDQmhoN1JBU1JlNWJHT1UvbkNTTWpnV1R0?=
 =?utf-8?B?Vm9uY2luaG9YSTUxdEV2MnM3M0NrSVJXU3VXN0pBa2RxRDA3ZkVlVFlzVGsx?=
 =?utf-8?B?YTlOaG41SlVBWWxvZUVydjZHdXBJTXlsNEpibjEvVFIyY2kwOVUxME1oaysy?=
 =?utf-8?B?SW42aGZtQUlHczdFbmFDcWdGYjdyVGQ2SmczMnBoL0YwdCswMi9GM1FWZzJm?=
 =?utf-8?B?R01kNEFIcGNGVkdoTFVYUWRmVVBXU1NobXpyR0VidUxMVWI1SEhOU3dKZVBK?=
 =?utf-8?B?ckVWV25qWWVGQzE0UlNkdjJ5RVg1ZDFkZ0ZBRm9KZXBKN3k2RW5ZQXA3Wmx0?=
 =?utf-8?B?ckV5RHptNnNoSWM4cUNJOW8rKy9tZ0xZRXhQQU0wVENFQWxaL0ZmL2F0Skl5?=
 =?utf-8?B?aEFidm9DOUoxazRKdE5iL0tjT1FFcWxOUEZqdkJPME1Hc0Y5cnlId0xMVjlv?=
 =?utf-8?B?WjhUMVRlSGVRVGdxMlQzQzBiMnpZN1lsRXk0KzFJVGFNNktkbnV3NlJRSE1v?=
 =?utf-8?B?ZlFySG1WYkd2YUo4S1VYekxEK1dJWDJ0YktpeVR2TG9sMm5SWDBrZ0RjMGtr?=
 =?utf-8?B?eFo0cTA5YkI0RExaT2lSL1d3WURlb0tmbm5OTS9CUE9GdVpvMWxzWitmK1hj?=
 =?utf-8?B?QjNwR1Vhdkt4MzZOOG5jSCsva0RGdnRGNENmd09TL292eFYzUlpFUXFVVnFv?=
 =?utf-8?B?VWFzczZOS3ozenR6NFdwWVYxZjZ1ZjNIOW5yelowc05Yam1BdHFmSVdkRjVO?=
 =?utf-8?B?VVA3eEdrcmVCUERrZGxtbHJlSlk2Y2dpMm9mOGorRDVua200UmJKbU0za09k?=
 =?utf-8?B?WnVyZXErK1hjcW5BSlZqY2FYYk9oQUJDcjJPMnREaXJNY1EyaXdVMmo3NXR2?=
 =?utf-8?B?Y1BJTDgxOVQ2dTFCdHkyTUM1NDVRbVBCWlNyQWkvdFVycjlYT3cxK2xoQzdC?=
 =?utf-8?B?elhFL1ZQSVIrK3VTOEk0UzZFMGtqZEhBT2hsaVl1NURPQVV6cVhJSmtiVkRT?=
 =?utf-8?B?TjlsVzlBRDZqZ0d0Y1ZJWlZEQUN5cC9obHZNL2MzRjN3cC9UUUtmN01MNUpz?=
 =?utf-8?B?NXh2SjYvS1psc3NubmpyNjJwR0FmVW96aGpKWVJ6Wnd2QUU2NE1DNFlLT24r?=
 =?utf-8?B?RlUyVkVrWmNjRVljZThWLzhaZnJnNnJGbU9QeGVpRkM2KzhSSURXWkErbVgv?=
 =?utf-8?B?QkVucm1zSUs3Q2xQNGJuNVRSUksyRTJqSmE4OXRFb0ZOU0xxSUdMeHc1a0J3?=
 =?utf-8?B?U3NncTZFWDJTYVlvb21qcXN6MmMyQVFzRjZvMXVhK2U5Q3dHdElqaEhKWnEw?=
 =?utf-8?B?aGh5YkJyQzZDcERtVmIyT2NOSXQrTE42N2xWaGJRQTNteXJlZHlIcXpJOUpE?=
 =?utf-8?Q?hlroPjtkBTmjDaDSgHh4wwT1vTDpBH5i5LLPClPVn0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0928601D220F5649AC2115A97A06F1E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0ff253-49dd-477a-ee9b-08d9bb44b894
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 18:50:07.7784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ljZE4rqtKdQcf/mAnj7ahtNTCAk54C6tRA5WDrxRm/MfVDfV5yO6W4UsOa5HorfB6wc4QVPF97zvFsv1rfWbE+5aC0AO24cGvCIK0Xts8Sw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4827
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEyLTA5IGF0IDE4OjM4ICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToNCj4gRnJvbTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8amJyb3VlckByZWRoYXQuY29tPg0K
PiBEYXRlOiBUaHUsIDkgRGVjIDIwMjEgMDk6Mjc6MzcgKzAxMDANCj4gDQo+ID4gT24gMDgvMTIv
MjAyMSAxNS4wNiwgQWxleGFuZGVyIExvYmFraW4gd3JvdGU6DQo+ID4gPiBGb3Igbm93LCBpZiB0
aGUgWERQIHByb2cgcmV0dXJucyBYRFBfUEFTUyBvbiBYU0ssIHRoZSBtZXRhZGF0YQ0KPiA+ID4g
d2lsbA0KPiA+ID4gYmUgbG9zdCBhcyBpdCBkb2Vzbid0IGdldCBjb3BpZWQgdG8gdGhlIHNrYi4N
Cj4gPiANCj4gPiBJIGhhdmUgYW4gdXJnZSB0byBhZGQgYSBuZXdsaW5lIGhlcmUsIHdoZW4gcmVh
ZGluZyB0aGlzLCBhcyBJTUhPIGl0DQo+ID4gaXMgYSANCj4gPiBwYXJhZ3JhcGggd2l0aCB0aGUg
cHJvYmxlbSBzdGF0ZW1lbnQuDQo+ID4gDQo+ID4gPiBDb3B5IGl0IGFsb25nIHdpdGggdGhlIGZy
YW1lIGhlYWRlcnMuIEFjY291bnQgaXRzIHNpemUgb24gc2tiDQo+ID4gPiBhbGxvY2F0aW9uLCBh
bmQgd2hlbiBjb3B5aW5nIGp1c3QgdHJlYXQgaXQgYXMgYSBwYXJ0IG9mIHRoZSBmcmFtZQ0KPiA+
ID4gYW5kIGRvIGEgcHVsbCBhZnRlciB0byAibW92ZSIgaXQgdG8gdGhlICJyZXNlcnZlZCIgem9u
ZS4NCj4gPiANCj4gPiBBbHNvIG5ld2xpbmUgaGVyZSwgYXMgbmV4dCBwYXJhZ3JhcGggYXJlIHNv
bWUgZXh0cmEgZGV0YWlscywgeW91DQo+ID4gZmVsdCBhIA0KPiA+IG5lZWQgdG8gZXhwbGFpbiB0
byB0aGUgcmVhZGVyLg0KPiA+IA0KPiA+ID4gbmV0X3ByZWZldGNoKCkgeGRwLT5kYXRhX21ldGEg
YW5kIGFsaWduIHRoZSBjb3B5IHNpemUgdG8gc3BlZWQtdXANCj4gPiA+IG1lbWNweSgpIGEgbGl0
dGxlIGFuZCBiZXR0ZXIgbWF0Y2ggaTQwZV9jb3N0cnVjdF9za2IoKS4NCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBeXl5eXl54eF5eXl5eXl5eXg0KPiA+IA0KPiA+IGNvbW1pdCBtZXNzYWdlcy4NCj4g
DQo+IE9oIGdvc2gsIEkgdGhvdWdodCBJIGRvbid0IGhhdmUgYXR0ZW50aW9uIGRlZmljaXQuIFRo
YW5rcywgbWF5YmUNCj4gVG9ueSB3aWxsIGZpeCBpdCBmb3IgbWUgb3IgSSBjb3VsZCBzZW5kIGEg
Zm9sbG93LXVwIChvciByZXNlbmQgaWYNCj4gbmVlZGVkLCBJIHNhdyB0aG9zZSB3ZXJlIGFscmVh
ZHkgYXBwbGllZCB0byBkZXYtcXVldWUpLg0KDQpJZiB0aGVyZSdzIG5vIG5lZWQgZm9yIGZvbGxv
dy11cHMgYmV5b25kIHRoaXMgY2hhbmdlLCBJJ2xsIGZpeCBpdCB1cC4NCg0KVGhhbmtzLA0KVG9u
eQ0KDQo+ID4gLS1KZXNwZXINCj4gDQo+IEFsDQoNCg==
