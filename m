Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844221A7728
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437505AbgDNJPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:15:54 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:46680 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437356AbgDNJPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:15:51 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4694FC0098;
        Tue, 14 Apr 2020 09:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586855749; bh=ecaHZR33wEYRKaaRZzsRpGGr046Qibrb1dNmG4BvH8w=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cBXcLTjq6YlHcxugAJi/rE1k6GId2I7BcMZnRkYaLWtVVyfcwsiG/ERuGGJUf41/y
         FbdLvEyRLuuuw3oSpDe1XpRe8jc73FUcbNZZ6yih9eDUeRjzptcwWNvT45B70GVWJK
         3HcUtc5LBu0vfjDVz9RABnIygPYoWt7bgfcqLMTPpSMSmyyqGi1hVTgTlGRvmPVCLx
         I5fsOGMXQjjVGi3BAzxi11Grwc9CTIOJj5pDDBRyQAgrDd/mAhmR6mxVYxUNZr3qcC
         gnMfjBOLnp1JOsGxqNxrVB/o+LqcTwgmKBSB9UN5jfDxIe444ogtYluNWWTWA3QiaB
         g/cwuVSiWd+FA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 8E016A006B;
        Tue, 14 Apr 2020 09:15:47 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Apr 2020 02:15:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 14 Apr 2020 02:15:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQn8Np6QHigazJjDpLtHDsOlHRPu7UOJK2g6djiJEvYb3tuj9327sMDvSgHSan7E61z7BStcpZ/Hfi75DK9xswBNKDMPrOfuLsacmiUj4Az1SRVK8WEUCEpBPEUCO4i7/lMpja3f2dYFMaVwTwSqivBOMdk22J6YFvRjCDp8oAjHdkEADaH5RLbBjo5t0vVSxelIGEPKPRo+0HHpEJHahOS/asIBG36U1y64qQ/hiIRDEynqYbbgKYiNPPc2JcBpHhWU6CclgANhromGz/nYW76cdaEUzLr0+2/UhtSpNhZqzKnNNkrOiEiQuR8GP1Ddvsed1Fw8lUjOuQp7aXT+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecaHZR33wEYRKaaRZzsRpGGr046Qibrb1dNmG4BvH8w=;
 b=O3wA+XcIREV8mVPSeeT39AbH4LqWYYX+2He0hOfjaAi+cH0ZWRcWrnZe4dTbXrUeH2hNuA0EDnZQBK4LAbmo/iY1mWMMfNqubMvlLRP/wLn+v8SGPl7oWI6StNOqZd2Q8afra4uMFEj2+t6EhuywWK6nynkO5fvRriSDfqNUSBZSNzyGyMkhISxuHUnxNkAOHq5mppgSX47zVbmX8YwYdJm+74OVDk1R5hCQ+S8Xp3ds62fKbTNFG2S/69lhd+2m6PIbizV4YCjU1goAAen4aVqE51kMeYxM7sb3s5cWpRocMZ0o/4px//ryNMy0XR8sI2xL+N6LNKXnkwhv6NSmkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecaHZR33wEYRKaaRZzsRpGGr046Qibrb1dNmG4BvH8w=;
 b=wm8boqAeV6AxsEQLrG19fiw9aHeokqKHwgi0EIb649bx9tNb1DWn7iQ/d0Jmy47v4CSr21I9oDEVAYK+izCK/AFjVQgVM0FxVjNdJ+u2WJO8fZUZDAZ3+bywR8YggC2PqeqR7IwgBxRdK4yeqhbkZPjtk4edGkK8FMGiLd3VWhA=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8SPR01MB0009.namprd12.prod.outlook.com (2603:10b6:408:65::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 09:15:37 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 09:15:37 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Julien Beraud <julien.beraud@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/2] net: stmmac: Fix sub-second increment
Thread-Topic: [PATCH 2/2] net: stmmac: Fix sub-second increment
Thread-Index: AQHWEjzJl2bGDtzrd0q53ni2NN1AB6h4VYEg
Date:   Tue, 14 Apr 2020 09:15:37 +0000
Message-ID: <BN8PR12MB3266F9F1656962A9D1675AE9D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200414091003.7629-1-julien.beraud@orolia.com>
 <20200414091003.7629-2-julien.beraud@orolia.com>
In-Reply-To: <20200414091003.7629-2-julien.beraud@orolia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40f0c02e-cd70-41f7-e2f5-08d7e0546538
x-ms-traffictypediagnostic: BN8SPR01MB0009:
x-microsoft-antispam-prvs: <BN8SPR01MB0009DE613CC093C4B6CAA42CD3DA0@BN8SPR01MB0009.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(346002)(39860400002)(376002)(396003)(136003)(366004)(478600001)(186003)(316002)(66446008)(71200400001)(66556008)(5660300002)(76116006)(4744005)(33656002)(66946007)(66476007)(52536014)(26005)(2906002)(64756008)(6506007)(7696005)(110136005)(81156014)(8676002)(9686003)(86362001)(8936002)(55016002)(4326008);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRm8edPO5ugn0/79XWViuCZk3Z4UFoXJfx/cMq1yJ68hG6PuN7Q+qs6fAmCflwfHAydFHkyK4OVdA2sa+qAb9xOWex3nsWcxKYv0gPfQPsp3oqukhkxo0vH/1ePIjylI3tShMA2u3KpOu5vwKzGRfcnWKFxZ5cHVr8G3mGRn/PyBmb6WfV+4RGnJVdhhhuPdnwKir+gdM+E2hae8CYiwaazcZYibro1hNEoPxR/z87xxpqLnCG6u1IrGYK1Ap0eP7IAZOf7lviroE0vUq1NTM+akgyetW40n3dGtV6xUZ/N8j579cPEz67CkwMZpDHjSJpXLUcXrJ15jQKG7loaiuaAmHzn3EHhf//j5943M86UBou1y6pC1WpkPNPdVEafQ0Si9LUXYEWUQStwgsjBoxF7baZNYQfBZK1oLeJQsjEo6OTz9CpyrA/T6S0CSrS8y
x-ms-exchange-antispam-messagedata: WjIVenTdmDrduV/KEPH5+ADr3uFsnMoC4Hb59JeTJEw0RDkvnBavOQ4Odm9xkWmYa8dd3QPxuGVlO2+VWipZa9ExvyGmBeCAox/J5DYq25nfzJ1Mti/cVz4LijP0w1CFw+tFMVGC5WZNRolWgztIEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f0c02e-cd70-41f7-e2f5-08d7e0546538
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2020 09:15:37.4637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I+nwJiw7cJzseEQzR8Pt2kfjm0XhEaawizgulq/9vtWX0Jriq8b0aOrz/yDYQsT4/WjngkrI+j/qitlJthdB7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8SPR01MB0009
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Beraud <julien.beraud@orolia.com>
Date: Apr/14/2020, 10:10:03 (UTC+00:00)

> This will also
> work for frequencies below 50MHz (for instance using the internal osc1
> clock at 25MHz for socfpga platforms).

No please. Per HW specifications the minimum value for PTP reference clock=
=20
is 50MHz. If this does not work in your setup you'll need to add some kind=
=20
of quirk to stmmac instead of changing the existing logic which works fine=
=20
in all other setups.

---
Thanks,
Jose Miguel Abreu
