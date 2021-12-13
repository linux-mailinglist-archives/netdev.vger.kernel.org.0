Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2F2471F7B
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 04:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhLMDIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 22:08:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:36188 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhLMDIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 22:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639364921; x=1670900921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SNsUOCzWEISKVVlXdXn2Bud/p+TR5XW/RLYpzSKLCM4=;
  b=gPhFYJtca04MCd4JEsaoQJrypOsHj2h4KgQjzI35u8rTEWqUuvqL0MT5
   VP2b0JXYjeH3UTqH3Y1PSHRBHW79FmO35ZLKzEJIaYsnylL9z2w8oAGJq
   ETyKQAfkv5D9nqFeQJgC43YyubxYmeskyUq7ZoELJDndKDxK2ZjdkRUos
   AYtEwJbYkw36HAjRMHNlkak1zS8p0L+qH7nk5JtnzPtZyb/7wIaWZoTEp
   01SoG5yuE1nxNeWWIO6uwNzsp/5kqb3IhGb/wDzHukE/ZgJ8B5aDiAM0c
   X2XEN5PvPXCXOIBUDhYCOLgQAXr8/HtLy/KE9K554m9Qo1M53yMWF7H+v
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="262777054"
X-IronPort-AV: E=Sophos;i="5.88,201,1635231600"; 
   d="scan'208";a="262777054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 19:08:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,201,1635231600"; 
   d="scan'208";a="517573332"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 12 Dec 2021 19:08:41 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 19:08:40 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 12 Dec 2021 19:08:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 12 Dec 2021 19:08:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 12 Dec 2021 19:08:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACKzciUUSoVtiYjvuzGVJu5w8CYIwzNBnNOgzVvdnoHniAm1uCRWLTG2DWpReu+KO6A4n5RgQbdq4sNwnnNSqFPj4pL/aeVZYX0N45FZI4BfkrYV98YDeVA2ZdgdYZ5VpBaBIX626L/wqQ0meduILA4YaZMSTKLG7/fzjAwffboiB632OvhezMpWA8f+0/m1Upr21poRDruIfGb/+Zni68zPuM6ceAjLbIxHL0pU+ktjADYTYPUw2h/Dw5CcNh3CVnqsPErweRBxCgUOfMBJtE9KeKAKHctnB+qPb8Fe3863F1HIzG9nZBMtpsPoV85QvhOG6eUMbBYTaHARBb0y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUf+6qlvsjhmjBcJUI//LfMNBIEh5XreaqXxZye5EmU=;
 b=CyUI5SJdLZU4i8Njd4go7E0x2iyDim15/FB+48RnsZpavP0xqeu2xM2ao7B70dgaZqnLQN8wx5qp2LtVOl4okj4U5OYRUzz+rB8Ze30WKBvGiVGKGcxq/AxrIZHxJFgSwGfeOjB+jzEm+n9xnEEAu6m8M2sS1Ew87Gjziq4RRb4xNayEFF0SeECPZ3uKVzd6pSO2WkRwblc5pJKaLqPrKK53+Cst54YWOpg/SAL/d45tDTX0ezV6qvFqx/HG6FTv909o4NkPSfIK88cKh2C92/EdMlgwM7fmz5U22l+fSJX4uLf213YeOlv25k6bOlGOxKWHpmqIaBAsUfuVlYo9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUf+6qlvsjhmjBcJUI//LfMNBIEh5XreaqXxZye5EmU=;
 b=hdBigH/Y8u6Ck40GZ+/eQ/i6Uo+qA7FqikgB/kSw9f4/LMw+btDaHRoRCLGaqyRGXdYpXXkzZOwxdHUaoZy6r+cfcAgRwvzM1mHR0vfCilt8vl1o+8j/aWjsW0wy1UoNyxS1dZPrGHODOLeDQpwWJ6K6/u72kTPW40lome3xvcE=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB4869.namprd11.prod.outlook.com (2603:10b6:510:41::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Mon, 13 Dec
 2021 03:08:37 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 03:08:37 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Li, Philip" <philip.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>
Subject: Re: [PATCH v2] selftests: net: Correct case name
Thread-Topic: [PATCH v2] selftests: net: Correct case name
Thread-Index: AQHX5yRnUK/BJh/89kydkZMBcbubD6wmkpQAgAFimACAAAaFAIAACCMAgAfI97c=
Date:   Mon, 13 Dec 2021 03:08:37 +0000
Message-ID: <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
 <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
In-Reply-To: <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ec95c6e8-cc6b-0a93-3de6-8ca2d2535866
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfdb472c-c65a-4157-9119-08d9bde5db36
x-ms-traffictypediagnostic: PH0PR11MB4869:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB486972B7E85005006E6C2E7CC5749@PH0PR11MB4869.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rsGc1hkaApjvh9vTeLHRsN2DXuErkh2bvghfEVx9uLu/VAb0sCMqYV8QGyJb9zfClJTNf15HiFeVxeOVp/kXhnT+L3b6vBZpnk6qamnnprvR1YbiWnOdPN+4+QMMhuJ6VChPG2kb0nMqOoPkvfwQm1ClN+hBhee3F+Npiyc04xiiPmwITbfh41gZiq48zq52GhfZD2fS0rroJp5xMKoyt7o/yEHDViivpmO9Esm8rD93+Z+5VCRipCwlTW5Rqsvi323H9O3V55a4LdznWWXuavOrKZXaubLkAMYhHDKP++HVp683p2s7v+wID51UNN0n0YZCaWxCUlQ4Bu7b2ahuEE6BV5+y4cxNXWVvy9Gr1deST5+WAyfRAD0b5Rby/BiJua1F1JNuouG5GXJgCyVjySkJ8vHsv9TlB4ZPImRO7QwQQzAvMlW4xsjj84ji6Cj81JG8TdUzmHJPJ2u4jzofT9z0DgMnFedfgMF1g1qfP2qU2HCh6/xWG+m2SfiNLh6I4zcnJ78C11tQefK6mm9pEA0rzh0MboS16ri+rq6RQlD3mqY2pxoPrPXLqn7ASVQ1fyxtG7xV7fghshQ0WwdtC1FvEDpo2ECrS5SGpJcXOHMBhMD3CVtZneW3/CrrlMu3rIeR0gKXnnugELRdhXzahLFT7SCuyorLmbEaPqaDzbFHE7M7fq3xnOnYI32DWpTvTgDqIVfrK4kQVbxIv0Knt2Ezuj5vCKwZnebF50K0iGzSaL06h9dK+jwXroZEjaoqdjzc5dJUxT+btq+a42wUeu/Fg0estIl29SRYf6Ptzs221O/mZdbvKmTFwV13FVfsbkQ8en/GMeinVeC1wqrgug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(186003)(316002)(8676002)(53546011)(107886003)(8936002)(86362001)(26005)(5660300002)(45080400002)(55016003)(110136005)(76116006)(508600001)(4326008)(83380400001)(6506007)(9686003)(122000001)(54906003)(66446008)(66476007)(38100700002)(66946007)(33656002)(66556008)(64756008)(71200400001)(7696005)(2906002)(91956017)(52536014)(966005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T6i0EFFwfa7XGFgjSbrxTup4BeR8qZ52rdQ6ezIayfu54s6YyDlwhktEY3Z7?=
 =?us-ascii?Q?tCJ28oGqDXAkPld09MXWJ2shF2HBWcKT2Mxgti4PXST0RbNvL0gU5qxhdR9D?=
 =?us-ascii?Q?k8M5tvZtGvog72edFPtAjHRQaGyrYrBfqb7sdpYEraiWjDyhXY57YRGJ/SJP?=
 =?us-ascii?Q?bWSUTY+9aIeGhECXgTGrIRdWNAq4VOeC92lTvx40gP54jdm0+ZWI6H4kIluz?=
 =?us-ascii?Q?ge8o2XcaLpKnMw8uO4pTUadZ2T6JeU8ZhFd2WOGTwULZDrM3BpT3kMMepI7r?=
 =?us-ascii?Q?wfIb3//+eh9sTQOioBcPzSlsa6//QQi588m2cHrlEXVBFvjGJI4TMeYdKBNP?=
 =?us-ascii?Q?mDos5bYp0vGeVwxV4HfPlvdu4KxQkCPT3D8bWS9mllpP5QWLFEDYG0U2Li+q?=
 =?us-ascii?Q?nDkjvlTStra8WqCDZA+NPGs8u3GK3PXYF60atf1AbH8UOyA6LN8X/IXG0jDu?=
 =?us-ascii?Q?pVJ9qfuUax1B4CzeckLORhDgadG6YynuSp5t6oeI8DOijpBMBG6miaEmb87D?=
 =?us-ascii?Q?QSN4Md+qRZX41o7/S7blq/aSMqsJVE8B1wSMB1CWGtwpLcfJnISTecNl1rAk?=
 =?us-ascii?Q?EvW+aZssPBTVdZo9axjsC2GzCh/ejpOsTfQHxNq4BVMlcJNYya+C71o5FqVq?=
 =?us-ascii?Q?LApYIdvAhZNWFRiymHVIWsqIxC2q+66wgS2yk6bx+iOzo996K95ayRWLaBES?=
 =?us-ascii?Q?/DAMW3jw6lC6oxVjdxV/pRnL8+y7A6IIe5sUKFMeRK08TcdlP1m/Wfj8acLt?=
 =?us-ascii?Q?HEBjcz27e+HnReAcJkR1iCcrHkLoYnl9716OSf0Lbn1K520dhMn6jsLT3fsE?=
 =?us-ascii?Q?aeP3AMrfKlGQNx6Szm0R+8dgzwC7P9RyfDs37Btb4DHTQ5SsqqviwtqwwUEx?=
 =?us-ascii?Q?KML7bjtZeuMMLQGGenRpD+8pev+Ao9hxJgR/zdO6HQ6YpAj8eLkUmIVD69G0?=
 =?us-ascii?Q?sw5nASrkoAq+ev7VghY/vIxgCzdhm6jNPa3yCxtzJpQmd6Sflx49xNTluDY4?=
 =?us-ascii?Q?FVsH0Tzkf6G2ZCC0G1JbbHP8d+hKK6RljkMMhQzBSjwemhB7xOHJLRGoyAFt?=
 =?us-ascii?Q?TQ4xtSQdq2Y5NTzJz00X6MJfwKKyd9vtBy4DUpCMlIhchrG76ZRaI+gyTTVr?=
 =?us-ascii?Q?3u+iw6PzGnZ+uqQ06nhU+9D/Ic+Ge5RidlKQDc+oOJjLi1KjUHkHf1ilxB5T?=
 =?us-ascii?Q?9NK719VL0XmtfsjdmQanapRVvuLCuwxs1lUTOuBKczEyj+taky3BbYVnB7IN?=
 =?us-ascii?Q?jcp49+XRkw9EnD65/movO4xKr+qhm2P0J1ofACXBuNxigxsKKF2TtmRuJeXn?=
 =?us-ascii?Q?fz74W+dSHzqsYNw+fL91AoQb4LXK5CtUFPMERXWbUJY7+L4wiyTuVd5l0Wvz?=
 =?us-ascii?Q?2Y28Gdf0wV50MLwPu+fQYudkDoWPxZtGv9XmzLCPYZGJJMuluFmimboj05bQ?=
 =?us-ascii?Q?mpThFML1N9id3Iy0RoLpcKAVI1wjSJJiM4H+BDUXE3yAKfvdDbbdTxj1/+FR?=
 =?us-ascii?Q?of/MZ/k4y6FxJ4Jn4k+vNLHN2wwG0rUo+P5CGlm8IW49/IDIMXnw5dlSHdC/?=
 =?us-ascii?Q?Im6t1jsvEbDCWvsspKgX9zlQ8XkABRLLdri3S8WvUxjx2bzceTfrTOeUqOy3?=
 =?us-ascii?Q?hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdb472c-c65a-4157-9119-08d9bde5db36
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 03:08:37.1497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iM7r6205Dl8WlIIROk1VNCwYNr5+FqMODxYSgGyp7WBjgS4rVuZulVP+Uw5XeMfYk3bwTD25zJjHSpjaqZFAgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4869
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

I try to apply the "selftests: Fix raw socket bind tests with VRF" patch.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0f108ae44520

And found that following changes.
TEST: Raw socket bind to local address - ns-A IP                           =
   [ OK ]
=3D> TEST: Raw socket bind to local address - ns-A IP                      =
        [FAIL]
TEST: Raw socket bind to local address - VRF IP                            =
   [FAIL]
=3D> TEST: Raw socket bind to local address - VRF IP                       =
        [ OK ]

Use -v to see the failed details.
#######################################################
COMMAND: ip netns exec ns-A nettest -s -R -P icmp -l 172.16.1.1 -b

TEST: Raw socket bind to local address - ns-A IP                           =
   [FAIL]

best regards,

________________________________________
From: David Ahern <dsahern@gmail.com>
Sent: Wednesday, December 8, 2021 12:07 PM
To: lizhijian@fujitsu.com; davem@davemloft.net; kuba@kernel.org; shuah@kern=
el.org
Cc: netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel@v=
ger.kernel.org; Zhou, Jie2X; Li, ZhijianX
Subject: Re: [PATCH v2] selftests: net: Correct case name

On 12/7/21 8:38 PM, lizhijian@fujitsu.com wrote:
>
>
> On 08/12/2021 11:14, David Ahern wrote:
>> On 12/6/21 11:05 PM, lizhijian@fujitsu.com wrote:
>>>> # TESTS=3Dbind6 ./fcnal-test.sh
>>>>
>>>> ######################################################################=
#####
>>>> IPv6 address binds
>>>> ######################################################################=
#####
>>>>
>>>>
>>>> #################################################################
>>>> No VRF
>>>>
>>>> TEST: Raw socket bind to local address - ns-A IPv6                    =
        [FAIL]
>> This one passes for me.
> Err, i didn't notice this one when i sent this mail. Since it was passed =
too in my
> previous multiple runs.
>
>
>
>
>>
>> Can you run the test with '-v -p'? -v will give you the command line
>> that is failing. -p will pause the tests at the failure. From there you
>> can do:
>>
>> ip netns exec ns-A bash
>>
>> Look at the routing - no VRF is involved so the address should be local
>> to the device and the loopback. Run the test manually to see if it
>> really is failing.
>
> thanks for your advice, i will take a look if it appears again.
>
>
>
>>
>>
>>>> TEST: Raw socket bind to local address after device bind - ns-A IPv6  =
        [ OK ]
>>>> TEST: Raw socket bind to local address - ns-A loopback IPv6           =
        [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - ns-A loopba=
ck IPv6  [ OK ]
>>>> TEST: TCP socket bind to local address - ns-A IPv6                    =
        [ OK ]
>>>> TEST: TCP socket bind to local address after device bind - ns-A IPv6  =
        [ OK ]
>>>> TEST: TCP socket bind to out of scope local address - ns-A loopback IP=
v6      [FAIL]
>> This one seems to be a new problem. The socket is bound to eth1 and the
>> address bind is to an address on loopback. That should not be working.

actually that one should be commented out similar to the test at the end
of ipv4_addr_bind_novrf. It documents unexpected behavior - binding to a
device should limit the addresses it can bind to but the kernel does
not. Legacy behavior.

>
> My colleague had another thread with the verbose detailed message
> https://lore.kernel.org/netdev/PH0PR11MB4792DC680F7E383D72C2E8C5C56E9@PH0=
PR11MB4792.namprd11.prod.outlook.com/
>
>
>
>>
>>>> #################################################################
>>>> With VRF
>>>>
>>>> TEST: Raw socket bind to local address after vrf bind - ns-A IPv6     =
        [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - ns-A IPv6  =
        [ OK ]
>>>> TEST: Raw socket bind to local address after vrf bind - VRF IPv6      =
        [ OK ]
>>>> TEST: Raw socket bind to local address after device bind - VRF IPv6   =
        [ OK ]
>>>> TEST: Raw socket bind to invalid local address after vrf bind - ns-A l=
oopback IPv6  [ OK ]
>>>> TEST: TCP socket bind to local address with VRF bind - ns-A IPv6      =
        [ OK ]
>>>> TEST: TCP socket bind to local address with VRF bind - VRF IPv6       =
        [ OK ]
>>>> TEST: TCP socket bind to local address with device bind - ns-A IPv6   =
        [ OK ]
>>>> TEST: TCP socket bind to VRF address with device bind - VRF IPv6      =
        [FAIL]
>> This failure is similar to the last one. Need to see if a recent commit
>> changed something.
>

similarly here. Want to send a patch that comments them out with the
same explanation as in ipv4_addr_bind_novrf?

Both fail on v5.8 so I do not believe a recent change affected either
test. I guess these bind tests slipped through the cracks with the
misname in the TESTS variable. Thanks for the patch to fix that.

Also, make sure you always cc the author of the Fixes tag when sending
patches.

