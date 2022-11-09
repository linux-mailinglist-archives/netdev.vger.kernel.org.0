Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05986221E0
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKICUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKICUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:20:31 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61498686A0;
        Tue,  8 Nov 2022 18:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667960430; x=1699496430;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DvDjikgBcnv9vxO2Mhwgx1nPIjVMWSvBu7fEcNuQA2Y=;
  b=bEK/sAuNToxQgl3VCu7opuaIednpIw8zOvFPqIWTiaFNwuiIr0telJFd
   fsfBU/HiLtSSiiXOXDUSg2rjwn+m95iNQnb+Bh53JVgm1tUgRgKyohuJp
   q9W1sUdkCXx7OFVQ/0GW7MkLQydrhC7u0okURLxOTGnbMzW3nbGnKBGoh
   V9AKp52YtaRLEhXp2kP3R2mB+WshL91wpQgYT+324EAngYkje62y/YiUn
   seWzZu1RBTJlLzCtJkhqdYzg1YomnJuPurNQVhag2eXlCJRaL6liyLdum
   S2QAOELfaX1HLPP7D+2rLNztSgKVoU19VnWvjV14jZfathvqn3wlyiYxA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="375141599"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="375141599"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 18:18:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669778414"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="669778414"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 08 Nov 2022 18:18:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 18:18:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 18:18:40 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 18:18:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfGa9p4aYUAO6xEc9oGUw4IkP28BTQDU5d7IZxiKGgaaComKwrMopUMp10meiqYF7IcFTNO8+0RIvKIxiaP89L6kTr9A3bog58nD1wTBhee8j+aWa16U/A7TvvnwFUdBJDzBLU/2mjWhYDBxf3uHS1S8J4GZtUL4zwMi3himy/OJnpqGciFowEDLEqm5mWiGlN9g9GZ79ygVJ03MH9HALu6Ij0QslBozrngr9Jan/288jGxcADyMZFlDBEwUftDHEQiwikfWdpU8IbwKO2pZR34Z7+cp3ulm9jJ/5Edf+FARzKeuQ77NMgpEh9873nO93Q9yW0Hw5SxxJoXWgIp/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mh5oLQXXX9xY4A4i+NIEbPzDP4YgXCUKCr/4IHbPM+s=;
 b=E58GON/b/qNKrOjayHBx0AP0uzd7W3XQ10oj8BOdPYigvyVEW0lVFb99LOLRTmBoDHoIrU1IapRQVPvFzoHIoFOZrofXZTQb5B9aUyICCqKU4Tcmoqei30p7jTXmOXRoK1xyuBEBXsyuihYJJI4X+6iqI/kIK7Xt6Hok5KIE/OBkD1fNJTjiZN/Hcy1jyxotqW0gFgbqx3kNSQGhLvUs3N9pLjf1x4x0A/ZdAV0XmeWQIKjaredo/kUypGiD6QAwVnGb69HC+68VQlmBRnZHEnMMNg/2ouN756w2jjFYnE/m2W1H4Sg+8iXTSzJun+/6mG1GZRHegsJ7e/dtM7w93g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1593.namprd11.prod.outlook.com (2603:10b6:4:6::19) by
 PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Wed, 9 Nov
 2022 02:18:33 +0000
Received: from DM5PR11MB1593.namprd11.prod.outlook.com
 ([fe80::7940:c5ad:796e:3e1b]) by DM5PR11MB1593.namprd11.prod.outlook.com
 ([fe80::7940:c5ad:796e:3e1b%12]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 02:18:33 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "Gan, Yi Fang" <yi.fang.gan@intel.com>
Subject: RE: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non
 OF devices
Thread-Topic: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non
 OF devices
Thread-Index: AQHY895ZtWivL+GFVUe9kKNuDpdQc64120Sg
Date:   Wed, 9 Nov 2022 02:18:33 +0000
Message-ID: <DM5PR11MB1593619ECF5A94A92D5EA1B19D3E9@DM5PR11MB1593.namprd11.prod.outlook.com>
References: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
 <20221108175531.1a7c16a6@kernel.org>
In-Reply-To: <20221108175531.1a7c16a6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB1593:EE_|PH8PR11MB7022:EE_
x-ms-office365-filtering-correlation-id: 84e582b2-189b-413a-d4bf-08dac1f8b34e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n5W/HhxgrC9E8vov8Wy+jsjXQZpKyUm1BAzDGNDfYHdMxpuyUOQ+LRfLUTdUPeWWY5KlhrFJoTqOQQrLT4rApoiQKLK+j7Ktp5DPSPwkpwz8/Wznad107wAvhimKo4N/XNWclIycldV6rJc+QefiXSxfBuAD1k9oAZy5S746f7DEJUL4NwZT4+QfLpWaepCIWWaiVVzP1uRPfedG7RGtrNP6LwskPBTO45XcyTq1hz8Tk4gMQSXfZC47RfbSwACxM5btBG1PqRSC7/sRMJsO3j5skvyjrOZXUzFHdDcSuRedg7zl9CPMq0wYYmy1J5mHclCtTIwJNKHD/gCG+hX1BK+Pf/DneOhS9ECntwcQTSnjShuXL7tdqilCRKUNK/vxDilP9c1RyJIoV4EArqImN1cAdD+yRtrTqbHxBMOlAhtufrGKC6rA0c6J8t8L2znKdxU0ok5FnS3U4m0Tj+KAqsC7fXXSeZg6RKCyaLg29c6VzMPysDcpHhJYbX7JKKbe4Necv9rIKNnP3W42dK8nDupiRRv6MLcenJvdFhhlMJuicOm9mn6h3iwwB/O6hK2A/czZ+1yHjnIpA4rog6r4K7ha2GCuFB9SgR8wsSSIb8nc+lPZXkMRjxsfW6KxcVbGY6GAiFFKK4HnRU2SOJXsQXNkOG+R6C55/cauNkU8lBBHbndVZCc2z64rzQ+/XRy4f2zyG2o1QTx2SLLJrSCNcFsjAnjfFOTaSY3Pkw8os25uXJbre6NK0GYlYFJUYXdCQ1dUNWexhGwvDfOTEC5Igg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1593.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(5660300002)(8936002)(71200400001)(66556008)(54906003)(41300700001)(83380400001)(38070700005)(66946007)(2906002)(478600001)(4326008)(8676002)(64756008)(52536014)(76116006)(66446008)(33656002)(66476007)(316002)(53546011)(26005)(186003)(9686003)(6916009)(55016003)(82960400001)(38100700002)(122000001)(86362001)(107886003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?paNOtpJHwNKdRNC682HJlSae8cfqZjJkuThDtcBv2kVG9yaO1UWFfpmH5sGx?=
 =?us-ascii?Q?I+nXgCnj4D5mkidm6hQdj9uGhwDtz1Kp+NaEg8Udkns+YHeCecRhebx2fTw/?=
 =?us-ascii?Q?Cfg5MRmaPyJr1LTjIycUqGvTj9GQR1SVAx62I8SJwQhRfhvf5GPU0td0H7Yw?=
 =?us-ascii?Q?Ye4s2Hyn0sAl5c7lLiiqpQ+cF5O+u2KXuzfqOpB2uoa1aRooKmStHwsWT+Kq?=
 =?us-ascii?Q?DNwBkn/p9aMD+Xz+AAz1qaI9ExUfwdQ65gXFpn4ncktTKZr4JxGaV9EzCU+S?=
 =?us-ascii?Q?uUNVFvWsjBjH+9Dnbq6howW+NtH5OAKf6ZFOPBAsMkl6x32xWWGvP6Fhnvmc?=
 =?us-ascii?Q?ks62k3/Xqh0NoeCC5JxbLjtB2T6RX7Qt6y562tM8CU3jXalkLKt2j/AmVBAV?=
 =?us-ascii?Q?DFwqDtUwKeB+WwQhDAt38bWMaAv3S5CLMVXYWpfBk84jUMQyRP/NN6u+6C8v?=
 =?us-ascii?Q?rfmMn9BYp6wTDLQr9/WvOAnpUY+QPjIQDV7k+8Tf03cjHQR6yCrKuQ1EJw8z?=
 =?us-ascii?Q?pHS95aoMKZ1HxIGQw5MIA/wV+bUr1iEfth2QQdSRVNunQGn84sr41+7sGxCf?=
 =?us-ascii?Q?q2mzA7gvKfkQ8/K16qIKS9PlzCjFNlVF/uxM0MBWMiKF1K9h/YC6aRBxCC8R?=
 =?us-ascii?Q?ZPOUUlm5yYCy/NfOLRUApPmeZy4klq87L1735y2w9BB7SbrjF4hSPfhqRMEb?=
 =?us-ascii?Q?Ti0bgrfnxEA3wfKERLxzXMMMqQ5NphwNKVNSoIFQhapXMeR4HHepUXLxO++n?=
 =?us-ascii?Q?s1E7GECyCfI9oDYuFQKe/zOecwSfQ228ZfU9s1TechfV7vppSISFvtpt2oPl?=
 =?us-ascii?Q?oe5pn++r2VouO7by1zErue205RIZXMKkho4GXdPr5yL2wj6N1udV0gCK0VL/?=
 =?us-ascii?Q?QDQLQ+M4efo3/AAqk3x+nReuZYk/jjAdJQB46yfanNLykyQ9ABWbYHWkPbg3?=
 =?us-ascii?Q?AQRP83EgTDxkqsn+tJ8MxfHi1fTAtwKRtRSvFijcI+qYDVeVQLXJXqubre/3?=
 =?us-ascii?Q?os8+4/0DsGyiu1d80i581LLeOJd/L2M0+/ZP9RHx4alwSQtggIzlOkacUT9A?=
 =?us-ascii?Q?PklhpgMKUDZavsCJ0FFnkr5hS+CSJXgVgzVt4UErvgZ/GhUF7BB5g561oRb3?=
 =?us-ascii?Q?TxjMJg6UZTZNbuxh+hleZJPmJLGyFtH2f6RjbGrsskAKh5Mxh1AjrL9JF9Am?=
 =?us-ascii?Q?w1ULir1Hb7cseK93V3bDJ/zQsNgYHJ2j3KkjjZNDoeIWLDDkrBCWk80nlALC?=
 =?us-ascii?Q?9fpMybmf+2YeAP9BbCZG/1gKdrqmhKdXoN+dwwYhYZ/H7635EbUgNkYjmV13?=
 =?us-ascii?Q?Lc4or8z9mQ7X/vsojPsCT6nTFS1uwPXjk//L0Kn9SpgSU5LIo48RXLPbvkn1?=
 =?us-ascii?Q?s9Zjmmy3xfYNsxEDeVB7KQ7EuDJSpiacUsSpdh4MSpL4vCWuQqZGjbVRk1IG?=
 =?us-ascii?Q?9LnIydz8SudGw/qIAWHzr3YWzg5nYUXy2LKJwtYmT3PcmQUSYlDqoQB3SIOW?=
 =?us-ascii?Q?tFdGRjeapQEWJqZsLY4Yb84Vf7RnwKT3/OJNteKfaf+tQ1s/Qlk3xpCVAWMg?=
 =?us-ascii?Q?+OQ2DE0KzLJQ0hrenZP3sK+esBg69s+SeTw/XmwO8vVcwvCgXB+hbp3qnRNj?=
 =?us-ascii?Q?Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1593.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e582b2-189b-413a-d4bf-08dac1f8b34e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 02:18:33.0528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDqDQSNP2r0dKdoZvIJwqGESeyeMwylTtv5iVTGQkqYxIgZ/lis5wB5a6KkVAUuMLWiJ0yRbUrgQ/cAIYHhnJ9xp7dyTpNZqmRP8N30QfI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
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
> Sent: Wednesday, November 9, 2022 9:56 AM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>;
> David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Tan, Tee Min
> <tee.min.tan@intel.com>; Zulkifli, Muhammad Husaini
> <muhammad.husaini.zulkifli@intel.com>; Gan, Yi Fang
> <yi.fang.gan@intel.com>
> Subject: Re: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO
> depth for non OF devices
>=20
> On Tue,  8 Nov 2022 18:12:18 +0800 Michael Sit Wei Hong wrote:
> > Current driver code will read device tree node information, and
> set
> > default values if there is no info provided.
> >
> > This is not done in non-OF devices leading to SGMII fifo depths
> being
> > set to the smallest size.
> >
> > This patch sets the value to the default value of the PHY as
> stated in
> > the PHY datasheet.
>=20
> We need a Fixes tag, which commit should have contained this
> code?

Will add the Fixes tag in the next revision.
Thanks.
