Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9621A6544
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgDMKha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:37:30 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:37884 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727776AbgDMKh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 06:37:29 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 46FAD4006E;
        Mon, 13 Apr 2020 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586774249; bh=mYy9Z49lRmLsLp0EE8aCjp9q+MK4NG/BpdOIymWqfmc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DEabxfxRIqUm3qznWuIC6wtKoo8HO5OEKG6YCH+OSB9PguiwUhWrte9zhio+W0LsS
         mpSY1iv99beEik9xNLYtsp5NGmiD1jp7TUVz6/d8bTB/QGPTGQjpn8KLCMQ3ceWezr
         4JvfoWKtdhtB1HIPScrUvL0KBxrGJGi67jr5FeYbif7Gs7GnH9j75ck+Wk24DNxWoV
         aC7k/kx2wEl6FULf0VtH6i9lOazcYK9lHlBzZtM/zkicd8dW2wcnSf2rnjxSLTGvgR
         9BgdEEP39Mgk9H+fDe6/THenHj6SdMU9Y3pknW8RiuMEoCp98vLwdnCgdTVMVmzv2w
         XZTLb0yVFlTIA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A375DA0067;
        Mon, 13 Apr 2020 10:37:26 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Apr 2020 03:37:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Apr 2020 03:37:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKoIK0qu82xATaU9xKTjybxdDJ+pAx3zX+YuCqaWeiPBmea7ld46FIRJ/0yZ7fmtpnS6WojDF+MdqqClbLF2tPj/gp0lRSKKTH15frDmL5v+ox4cYDU76+u8zkHSqaEKZkbcz5SsrHzoRTrD0TDRhSr/XlNhoH/I5lzQT59XVUwLWcCObmq3XbHrGsKz26scZFdgUuvz5l7nOMR96X0/QtWsIirQ/eNfIBSHAqSzSxUFZ0fUZxgl0gQhdluE9+26lYIG/mdZkkp7FmsmkDGs/kN5HoWwG4+CklsEHfKCS3Xj3tlzhpc34EipWjJxMz74Pejg5qI0DJDZGDoexTLqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Mbu3XwQoO7lPBzkzFcp3ULRYoES4llF2BSClHVhqr0=;
 b=hvT78qTPIoenGHgGlK97Jr51K1/fBDbOd1UIzrLQGsU/SabX+rWyDHADzNetRSdMrBH9G9GROr2BTFSZm5B2s96LFkU8/LnjkEcBgfS/9rJTQ+W43eVzkAtu4Fy3D1hznIAv1wJYQ1/fjjsfexyzD1V2SAwXpvw/AAwpYyspnpQlaOzuiUoPRbmh6kOZBiFOqCSElugJC4WIB0tm1B74DzcHXtPbLJDXkyGA6u+sjxXFiF6ZRkujNo75QREC1ASF8uaN4uYxFEE1cKb5ScbE8AjFT8jUouZEezu+1ryQ11Sm74fuX2gQjE5MtfVmG42CHp0rn3I7/FLSkmdj1NgqOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Mbu3XwQoO7lPBzkzFcp3ULRYoES4llF2BSClHVhqr0=;
 b=LnRoY9nV1gvVLlRHA5XdyDxqxMgR4VPx3RrJx1XCebRsiYpxYyN8q1vd4RTqLvZ+k9CZmTOCHmcjZ6GGqqIbmMWOW/g1Vf8ZJt7xKDaGhnU+G+agUKdmPix1Ki79P2xVaIzO8nenaq1y6EH0OaMDgKecHcrIRyJBgAHThed0XwY=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3171.namprd12.prod.outlook.com (2603:10b6:408:99::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Mon, 13 Apr
 2020 10:37:24 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 10:37:24 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Topic: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Thread-Index: AQHWEJDvA8zEZsFxqkWKpdmc7/rynqh2wgkggAAXQYCAAALIkA==
Date:   Mon, 13 Apr 2020 10:37:24 +0000
Message-ID: <BN8PR12MB32661B539382B14B4DCE3F95D3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200412060854.334895-1-leon@kernel.org>
 <BN8PR12MB326678FFB34C9141AD73853BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200413102053.GI334007@unreal>
In-Reply-To: <20200413102053.GI334007@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a29a971b-7093-486c-7bb1-08d7df96a75c
x-ms-traffictypediagnostic: BN8PR12MB3171:
x-microsoft-antispam-prvs: <BN8PR12MB3171A512A8B161016327D1E2D3DD0@BN8PR12MB3171.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(376002)(346002)(396003)(39860400002)(136003)(4744005)(5660300002)(33656002)(9686003)(52536014)(55016002)(4326008)(66946007)(86362001)(76116006)(6916009)(66556008)(66476007)(66446008)(54906003)(8936002)(64756008)(81156014)(186003)(8676002)(316002)(7696005)(478600001)(71200400001)(6506007)(26005)(2906002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eeRq39aXBo4EMTxH/FDcMDksSk7PTi3OVZ7mcX82r7Ewl2QTQFXNwdp3QQtJ3db9Q4W/ij94oW9iQTlHF6bvWw6mCcRVhKvMAzyDNy3WhraVFDuFIqT2sSOFSr4l5Vafpf3y+rbaojvANiXUietWUzuEzJkrNQxCZKBHrmx+O9HDo6NTDWDlcdUe++q73XHymA0Rmb/1TKmVsmantNqI/1laeElzhzZoVDYnfiHK7YFKjr990sPYuIY37f6IiNz6twQ3sFzACPNlSBMo9HLh2uVsQXkmnmhOr3qOl0VhD9C9vKjojQ0Bxps9I244ppVcuIzH3rEHKRqCbyY9gXs+Xk95PBRpHEPKxJsnTuTZLA/q1guXXT5plIN7HmmdeljFaO2aIrRa5KCIyqvtamPxCp/HZmHlz21uK+DdcRnAXUznqRiGin2SxLq5R9+2cj+w
x-ms-exchange-antispam-messagedata: XDoEb/zCdB20LpMRrgBV+dGIqW479B1mqQ0eGFr6FS9YIXXMmQnWw6TS/5sapDmOD2717pqi4Om3FGxjYpJuFp6Va/RVa+3OFIbGaazww+A8QVGYtVRpBVdVq+VIlsyJeJELxeFkYtQtdHPEo3N72A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a29a971b-7093-486c-7bb1-08d7df96a75c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 10:37:24.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UC0eZ26YwA6N9TWRTK3jfe34Wp0YewW/obTWhkzunw8C4PjgIX5aPxuzZQ7iffM4x3s4UQrOFbACmU9a95KnIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3171
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Apr/13/2020, 11:20:53 (UTC+00:00)

> On Mon, Apr 13, 2020 at 09:01:32AM +0000, Jose Abreu wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Date: Apr/12/2020, 07:08:54 (UTC+00:00)
> >
> > > [  281.170584] ------------[ cut here ]------------
> >
> > Not objecting to the patch it-self (because usually stack trace is
> > useless), but just FYI we use this marker in our CI to track for timeou=
ts
> > or crashes. I'm not sure if anyone else is using it.
>=20
> I didn't delete the "NETDEV WATCHDOG .." message and it will be still
> visible as a marker.
>=20
> >
> > And actually, can you please explain why BQL is not suppressing your
> > timeouts ?
>=20
> Driver can't distinguish between "real" timeout and "mixed traffic" timeo=
ut,

The point is that you should not get any "mixed traffic" timeout if the=20
driver uses BQL because Queue will be disabled long before timeout happens=
=20
as per queue size usage ...

---
Thanks,
Jose Miguel Abreu
