Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6995AB1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfHTJKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:10:49 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:8259
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728842AbfHTJKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 05:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dhn/hkIt0/TVZri5yYrfWtDco7BJc7W77jQQqSgkvJwIJKbQ2DcKzZ0D2OaUFIvMgHo2L1zYwp0y4K393AEoeb/4tapjzJkJZTJRqnJAPOYPQaMjQVHzdoJdVwbEuS23Zl3NtNj0Js0i3o/EIv1naaGRCZvUJoop3/zFKxMt9F6S6YIWqOqTMuwQ+Fi/o9yLuXY8EncV6owDsXJ0mIUO1h3GcJULWhyECan25SHwnC8/r84+53aO5Xv8yZVfqqiBtkTBXEq3t65d7Wq7HimxYGPubh7tUtrVDUpLpzP76QO9G0/pv/2Kl6jTQHW+QsdHSyUhGbhaPmdFl6IqWBi/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrytaO+H/fviBK6NtPQW72vDfo0lfdUv7ZQtsfh375U=;
 b=Tp2yvbOV4eVTAZeIonxoAp7vkT04WL0zr6vTqPcitHdfkdu9tLLBdRevQ/xptho5fIWBWAkeMzMMtQ1rVQNgbzAbUIA4+7BWqS+XPm/TbgF+JOLdKmK6Ui2gWPCHWJQJTsqqYaPOXrGM7Jl53MI8Qt1PRIyL1wxdTYPY38lPBpuaMElj6FeR5Sg9m+KukbexjyE2NecQSpzO5N1xstmr3FFYNkhIrcLNWcs7IfdFtaW+8DAReVgqRyz8XXwfyES1TuVUMXYoVuA8SYfchhvOCrztBAktCEv8y+7ceuYIfM0j1XHpVVshifx52q2pqRwk79sdV+qFkSCG4mXrsmtcTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrytaO+H/fviBK6NtPQW72vDfo0lfdUv7ZQtsfh375U=;
 b=osJd/L05eVyRoOKZKye5kCecFmzYh0tfOFjLR/J84tWViRfkh/iCcRH+oL6lq5Gz8ZE1craATdiWSlLmYAV9ZJDVU8IHmbZmP9qZdh8BKj1U65pdKMD5SpyBdu4CFzGz2o91w8ee9yZ4pACzuiFSeeuEi0JvbRn2j9knwTAuhx8=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4586.eurprd04.prod.outlook.com (52.135.139.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 09:10:46 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 09:10:45 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LA=
Date:   Tue, 20 Aug 2019 09:10:45 +0000
Message-ID: <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
In-Reply-To: <20190819173810.GK2588@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e917edb1-cc35-4bcf-1541-08d7254e4911
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4586;
x-ms-traffictypediagnostic: DB7PR04MB4586:
x-microsoft-antispam-prvs: <DB7PR04MB4586F2863AE06D937EF694D18BAB0@DB7PR04MB4586.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(13464003)(199004)(189003)(81156014)(5660300002)(53936002)(81166006)(26005)(4326008)(186003)(256004)(6246003)(53546011)(6506007)(305945005)(33656002)(8676002)(102836004)(6116002)(3846002)(25786009)(2906002)(44832011)(476003)(11346002)(486006)(7736002)(71190400001)(478600001)(8936002)(71200400001)(74316002)(446003)(229853002)(6916009)(76176011)(14454004)(99286004)(76116006)(7696005)(86362001)(6436002)(66446008)(9686003)(64756008)(66476007)(52536014)(66066001)(55016002)(66556008)(66946007)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4586;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MJH8g6Vh9sF2ao3Gbf5O23a5jz5Oo4RqI/1fjFIQ4P44jXQ3w5Sd37aC3EJ4fgkYe/14FdYg1tJJ2cpzyiUfKaTTB6EQZJBHOBhr+1Pxs8L4Q+GukRFAlMa1eVEOuPRMnp7Dysew4UWPmP1oyhiDA72PzIHyKntwuI4bXDxJj6iTu0cDdBz0tQtX0a31i/8JeXUyAsbVDBebRwH0/p3QhAWmFUSUVnEP2e07bQsIJaEwUipImTSAlsjmAdfKL2jfsPrRCdgqpSHLryxJE495Jn/h3EiQnWm5jr30BH8xqFmgqC7VHQl1fT67r0T2rJ7sP1WnEOs1jGu0iBet0+VDaZkSOQMgT2KK4rrSpejv2C1gm4DemTMe2CV8o6cmGTbMyWLr2wzCqjjMeGIGXnLbmf8l4IoHp+EK+4ed5RWKCoc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e917edb1-cc35-4bcf-1541-08d7254e4911
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 09:10:45.8978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: khbhEUjBH1HJlu2/PQMu09S7iMvMbbhR2rQy3a3m9aqOL3wk0Oz88j7IVHIa8BeYinh3z9cYNKwJ7ALFuxKJmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4586
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your response.


> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Monday, August 19, 2019 11:08 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: Help needed - Kernel lockup while running ipsec
>=20
> Vakul Garg <vakul.garg@nxp.com> wrote:
> > Hi
> >
> > With kernel 4.14.122, I am getting a kernel softlockup while running si=
ngle
> static ipsec tunnel.
> > The problem reproduces mostly after running 8-10 hours of ipsec encap
> test (on my dual core arm board).
> >
> > I found that in function xfrm_policy_lookup_bytype(), the policy in var=
iable
> 'ret' shows refcnt=3D0 under problem situation.
> > This creates an infinite loop in  xfrm_policy_lookup_bytype() and hence=
 the
> lockup.
> >
> > Can some body please provide me pointers about 'refcnt'?
> > Is it legitimate for 'refcnt' to become '0'? Under what condition can i=
t
> become '0'?
>=20
> Yes, when policy is destroyed and the last user calls
> xfrm_pol_put() which will invoke call_rcu to free the structure.

It seems that policy reference count never gets decremented during packet i=
psec encap.
It is getting incremented for every frame that hits the policy.
In setkey -DP output, I see refcnt to be wrapping around after '0'.

Is this designed to be like this or is it weird?

