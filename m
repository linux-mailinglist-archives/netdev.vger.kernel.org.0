Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF76639152
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 23:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKYWTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 17:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 17:19:30 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D025123BE8
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 14:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669414768; x=1700950768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bOrl7daEAYSZE+yOE82bwaUc6z+lyc7bjPstgW4bE5Y=;
  b=ZVJczv0ywPLM1IiDnMBN+FOCH+dj6XRKqZ/ifsrOoIwEw+p6SwRCDdNK
   AWNaKTQe68koc1jeHwlt8buwk6UWrbrfN91xtNhwHA6iCX0RPO23Hy2RY
   CfwaU/67PCsqBytcUnFtWJmDPpWFzhxq+ySeEuKOcwRVaMupg1I6MJYFl
   RWnLzc0UQiypFQHI0tdZZgQrAJq8ajuHdRYVKqLUR8QMhRvU/eyzB6okF
   /LF4dn3GDBC/esLSugMQKEnnDjo8zBXip8zi3k1thzEIMl2SUg/jeHe4U
   o2YF6PEukY+dcgKFJLFAD25N+DZGl36PziIcls3cWoC3s14lW+Y9i2D/8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294930389"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="294930389"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 14:19:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="675483315"
X-IronPort-AV: E=Sophos;i="5.96,194,1665471600"; 
   d="scan'208";a="675483315"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 25 Nov 2022 14:19:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 14:19:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 14:19:27 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 14:19:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf4dMw+vUoCj3PNHndqnPL4pKoZ7V8x8p+iP0HOWfdIlUdw5w59nGzgziLeVRF6pn7xrXtiq19eB58HcpHLhfoHZTg0J5Db4Tj71QjgXVeDF6gXRJpcu25xuWkA1R7zh8utpC77BvFe9I0R6D9IKmgFQVaW7WEuhEz0dZ96b5QDFgVO/OHUQ+HryIX7bEsvTZj2s80E3BqJNgrgD9YsPGRWuuga4+KRDAasxD/v45sl4Nis62jVP+RGULDditUQBMaiceigrm3uCQjP6YHn6+EWO2k3Lang0t+Wv6lnxXCv4pLLuJFuyXPV2Wi3XqnRT4tYTnT5kDImdR+n/RfYTwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGDq8qumIO4lV9pFj0/X0W9iUHyYFLZLaw9LIr4lars=;
 b=PF+RchGh784M55U17tJXILmR+gOVWTxNYK6Yrqk/O08QawWhjZJUbZ1mkX+uattSU32O7JeEdaz89GGAlbDoXOIQsglP0iWsvU3qyqxSwDTE/O51S9lRubP9Vr0M3gcp3ScRhgcB6r6gc86dyX//3bs3BMJG9ZTkIQc8SkMXmdW8W05mnR8W89+7FZf19Gt9i3ChK0vRjqUsVIxVxlmApyrGYsJKxvh80+qGMPb+sMyaSCy1yTH/m4jUkGTD/R5+kuZyoE28XF0bhCePcNggRKEHDGbeDmSzeI0LaLVWM+xZ7t25q/TkliHOg9UISyGrMFEgcb7k8pocebq+7ZhroA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 22:19:23 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::c669:1d22:cfd3:da07%7]) with mapi id 15.20.5834.011; Fri, 25 Nov 2022
 22:19:23 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH net-next v5] ethtool: add netlink based get rss support
Thread-Topic: [PATCH net-next v5] ethtool: add netlink based get rss support
Thread-Index: AQHY/2y0RgcXrB3SGUWmQxB5dUJADa5Na3AAgALApWA=
Date:   Fri, 25 Nov 2022 22:19:22 +0000
Message-ID: <IA1PR11MB626656578C50634B3C90E0C4E40E9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
 <20221123193048.7a19d246@kernel.org>
In-Reply-To: <20221123193048.7a19d246@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|IA1PR11MB7319:EE_
x-ms-office365-filtering-correlation-id: bafe28d5-d0df-4e13-ba6a-08dacf331abf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jTpcHVsubJ++2tuHhspKfvtlVehINVU50ed7KWreMa2FV2YQ4+2wTihyRhf0wKjheaKiEipcR/IQu4heIPzPaeKpcJPzO4vuV4lxyRaARg5NcHImdxFwO9+j+eNJW82EN+Gp+O5w10o9gm4zI9T5hj7xpG92Z+rffQavirKBE31g22wq1kEDmLT0XppTtCkAwRQgnx1gAQlbfWQLNjb1f8S2THiSxdypFjdvi5vklfPUxlYq7tFvMeKPr14zoPCO8DkXxKmyYgKwGrTDc12oDObZfgrOI9SU0Z/EeZENPSW0GwwilbYGtBL7noAVGZTH9YbicygpARtc+j5+byKfaiTC4jP3sBDr8AumE939LwJOAkEPtsoMjf+a93JW/t0K1HnW2j7gPM4agiYWYtdZabOZOaeayBrllw71y4ej4YVrTFy1WeCjfQFgH+54NtFk7V3Dsrn5NfbtThLSMA+9+4Pl7lYm/A/3ORmz8u4Yrd5K8jwJ9nKn2Zjs6qd7rEIkbuZ72ZcqUsh8THqnT6Cwzj04LU2+c+03YCiv4lbWz7i7UW7vRrM48tBjs3wXYFNGFvzBHZgMKCq/18Kc+r/CV2h+gjHyVf8gpK32yGKClWb2y3nEhHzi/jmASiQopt8Qg5v5VwSQyHLvJBdv2rPwo4ObNNGwf/BvzS44lFKhtSvh5UNYYaYizc8cQnf4I5XqOTGUcj3TdAXNj1YD1YHEbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(38100700002)(86362001)(82960400001)(66946007)(33656002)(38070700005)(54906003)(66446008)(76116006)(66476007)(8676002)(52536014)(64756008)(66556008)(4326008)(316002)(8936002)(83380400001)(4744005)(2906002)(5660300002)(122000001)(55016003)(71200400001)(478600001)(6506007)(107886003)(6916009)(7696005)(186003)(9686003)(41300700001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sln1rGk2roJH6Ft+5UJu6eMLoTbSTu7cXYf2XVtMsMy71PXJlIbPwUvhQkPE?=
 =?us-ascii?Q?D9NWkVgPZ2P+16ds3b4qSPLdDLPM5YkIWrR80S+Co+a+cMxJH6uWQeMoO8Jb?=
 =?us-ascii?Q?ZFlW4pwCO/F1k6A9c4qFaUqn7Wk9LznFS9lS3bgskHW9Ei3pNx3tf4Ydzmgc?=
 =?us-ascii?Q?Vq57vIk0s1ywZVtyOeaqwJAEeuo185wc2AdfLDZXm3F0nH1nB3dePyVcXtZu?=
 =?us-ascii?Q?LyaMlsO+ia/yh0igE7oJVJaSXDUVkp5Zu6GWFylC535uMxIIfydO5ObdM1/i?=
 =?us-ascii?Q?Vx9JhfauDM1WMAhlfwtvNtyT7MTm6CUhuIEDIdYCFGGpLrqD+rC7z35G3SB5?=
 =?us-ascii?Q?98WssijpsI7YdS0jQNvWibktzUDSFOkAH4ZZfmB4jc2o33M0Y6ySk/atxGUO?=
 =?us-ascii?Q?dOW5NwEDwS4G/QMxxOamOSSQ27WN0je9dikgYC7q/8YL9iU422TyKq38oBcp?=
 =?us-ascii?Q?cMLT0KSLOSvo0nZ5TeBzDphu3a2p0RPOCzjBJjfvlyBkivIvjVI/xIuwRaWg?=
 =?us-ascii?Q?SYHUYvugZ2kqfL4euefjROKPA4syJRjtNpR6DROHNFjdK1xxJabqDWcNyitD?=
 =?us-ascii?Q?0YwQ6+hT1JJ6khO/XbFEDUjda4OyqcsKZi5AbfEcjZ1Tb9hSjSHpoL9ftJVw?=
 =?us-ascii?Q?gjtX8FNw/9KNXq3ojYxrtpIjjdqTu+zna/hauigGaRrMtxHUFFvkhpGGGMZY?=
 =?us-ascii?Q?5C1aM3DdmM0uUweMiW6taBQk1GhAnYdssdWUBBtOdys+cuLIk50slTowPjv5?=
 =?us-ascii?Q?lrpmf6zyJ8GUfbO+DzBRd0B/Nzc243PS/zLPqFyq+a755T5wZydRMKrGFij1?=
 =?us-ascii?Q?KXZbMmJZCzvytQugWVSZiwcCqvRHQYX59bzhR4pEDj4K1DgP74+yWcuE17Bj?=
 =?us-ascii?Q?d4KTm5LD6GYB7IYlgzkWn5MxSvO74po8D0Ii1uRwM1Oxx18vg5lb/+CybEYi?=
 =?us-ascii?Q?5aswoPipjUefl+OKe5oeXqtp6jtnalE6Kn3lJeDlKEQoapE1leJl2W91jB/f?=
 =?us-ascii?Q?9ejOefxbjcm0lKCHdMfD7JoJY+NkwgqhyCxMg6QxV0EEVEDyOgH4tOL+RoIz?=
 =?us-ascii?Q?QvST26k9PKI4krwbbXQDxhVk0TcZzXce2g0rViAq/h88EGzwhgA5CEYo0rTv?=
 =?us-ascii?Q?pju9VmUdEheyY+2iq7toq6p4IqRtzJk9ktnHViL1x+YPmHIUvoGELlzUTor/?=
 =?us-ascii?Q?AB/GUIgILxHXnvUb0ZdGDSis8Z4zc7IHpaG+3v6+HZmeKQ0vWkMMv/zKEjnO?=
 =?us-ascii?Q?jJdFn19J7yB7JVngDIAcsWNygIp2K9+nz84NCqG61SAsEjnaeQYed0nIqZ7V?=
 =?us-ascii?Q?zgjOatGfNkxu+yEe+KMcLohyrc4BRp3UaUfAuTnfTvbeMY2kucxCg0X8GSNq?=
 =?us-ascii?Q?8RualSXnNi7B2IyCYzX3xw2LFllrPGXVckpgW1xafRBw8j5lrbEB2xUtfsuT?=
 =?us-ascii?Q?7nqqUFxFjS3pV4GLrdXYnU9ke7SaR+DfWViITS9YsFXg6bGUoxHcs7iC9teB?=
 =?us-ascii?Q?IZCrw0WEYUkOjc5TUeRCeO8LaPgC4LxH7MRqNItZlZLU780GtWBPfX3Dj4tv?=
 =?us-ascii?Q?uhljITA0flztdc8hKb8y3kEcQYLO0c3lG+6cvXjmcAFGsa51ZbZFt3DCRu05?=
 =?us-ascii?Q?vg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafe28d5-d0df-4e13-ba6a-08dacf331abf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 22:19:22.5245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAJcqsfpXS8MKLMgojaHC6OabOx/1KtOrcSNz1z8DHkPoheARkXY6mLDDlqUXlrL3h2BruaGz59BEvGcRtDsRPK4BWKKiUxnPZRC+ZpmyjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, November 23, 2022 7:31 PM
> > +  ``ETHTOOL_A_RSS_RINGS``              u32     Ring count
>=20
> Let's not put the number of rings in RSS.
>=20
> I keep having to explain to people how to calculate the correct number
> of active RX rings. If the field is in the channels API hopefully
> they'll just use it.
>=20
> The max ring being in RXFH seems like a purely historic / legacy thing.

Yes. channels API has this information. If ring count is not recommended in
RSS_GET, any possibility of excluding rings info from ethtool output too?
Included rings attribute in RSS_GET because user space code gets simplified
while maintaining backward compatibility of output.=20

I assume same output needs to be maintained. So, will have user space code
doing CHANNELS_GET and RSS_GET during ethtool -x.=20
  =20
$ ethtool -x eth0
RX flow hash indirection table for eth0 with 56 RX ring(s): <<<=20
    0:      0     1     2     3     4     5     6     7
