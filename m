Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8416037F2C0
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhEMGDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:03:19 -0400
Received: from mail-mw2nam10on2115.outbound.protection.outlook.com ([40.107.94.115]:31073
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229748AbhEMGDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 02:03:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMHRsKgg+STYjEy+IAoY82czpm6MRKl1yzPvOlmWLrpv2szaUXRENiB4fVhMhQM8I3XegKCV60uE/LGUWDMVaaTRPjlfKNBdM3dT8RoZBYrgiJtrVKqgii/b2mGfxYKIa6Q28mfhpY3PHRPJg7sWpDU5OdA18wAgzPTvXol78VM3LHRJu5J+xDBtPumF+feA3jFpKWJNPiDVDpgemn+EDwTP3ouN5uWYDZpEYfIFTjH7Yd83EztPN6N5bgb0WCgCiRnzdlQFRcMXcaL4K8CSe7eGSfVQ+j53XOAhIPFH4o6ThBmMtlYkQ2Nm8ClEBbKozRpN2PmqS66NADNyG0b+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9408YTzEEtLE4VrhzpN2/a5tyuy+2yuUedmaEuwqz9U=;
 b=Y+3qIYR6BpoOiLyi0XmA5K9T5pYwOcyNr+GhoIrPUmsNI5DwsRYtgyhk/4MupC7XySbvwpkOyEllU3W2oCuV0Q60Ns2J7FGjv2plwk8FMfu1t89WKI001/dT3zS0yZFOPRaV6aP0QyRWFyOYE+DuAEAWtkjL0mcVSKo8hb/siHZ7skq1X+QMNrzDVMcBInWf+9KmEem1gF3xH/dp5rTlURktrr6Mdi0XM5g1sv620R9vo9BQtve7XO48brUdNVt8g+VYap5VxbSDeuDbD8F6dR+F+RKd/nJSVuZ/ufaMMcj/X5gUhvusOde5aSDTeh0ZGRQel1Fp9M72jjbmZ16ulQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9408YTzEEtLE4VrhzpN2/a5tyuy+2yuUedmaEuwqz9U=;
 b=ZOUsKTSnPddqafx9Gk3rmJxqmffKb8E9svBgOIqtpdH2zU5aPdySmQtqcxJBWtGzGF5Ggzp7DW+zrKZDAURIScC3SVGuz76VgVjtDiSWwEE1UAvjYK8VtknRCd82WC2P9HCxi+m8w1zJc3Eh3FJ8aA6ZUAaBD52+Kxau37kD3NY=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB1939.namprd21.prod.outlook.com
 (2603:10b6:303:76::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.5; Thu, 13 May
 2021 06:02:07 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.4150.012; Thu, 13 May 2021
 06:02:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Topic: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Index: AddHdN+snMbFwQLHQSmZ6J2vO7HZjQAM7kqQAAUT/wA=
Date:   Thu, 13 May 2021 06:02:07 +0000
Message-ID: <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=356357d2-2a65-4b3e-86cf-03509df80d8d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-12T21:20:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:9d16:8ec9:e190:4c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efe575fa-4412-4a1d-de32-08d915d4a3cf
x-ms-traffictypediagnostic: MW4PR21MB1939:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB193924F34F18A92E50615B21BF519@MW4PR21MB1939.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m3ewiVkPZVv54rpxWS8CvM+KyZd6KCPx1vMoPg6CO61nFnpg/CRIp64odDVEIcYozILtbQNOzA4RZ0vfA9XkHZFP8qN+rWbLgD7F4Lv/8QZBxB77Y1rJ5A8XPAJzekic/DliMv5sst/aWTtcwjC7yZ+tImky1S9DCb3Z17R6EdKzSLJ9ER+qmsjVXwYdgwkr6gwAE+a3MkjvGcIXQJhyqbjYfE79InsRsezo3q/QxazHZ7sayobrctErV4+GqHfKHdkdEhTV8ekKJFQlH82KtGZhvY3Xm0yMkAFfOcLX+EXelwzi9ihpsjlIbnJ93K8AEolhGpsY4cdo7stajDczBvVrIPu0FeQpghRnd6HtpX8BUkyqhY7R6+4w9qZiR4LEMrlNMFDIHNPH8g4D6fTUFR/mEpXcoRec9mENmfgvQGVDU9KrzFl4vF3bMh2zTpHS3iPN639Kp72A2NCi1VRvECzZUsUk5LeIjUPmzwshy5xXpOUSCFIjdlI9pd8qINlMH4PQldAwYWKzrOp2m+VAACx+VL6P5zS9oiu+rMElPKnjSEcJuxdpBogUG+D9NHFfO2Q4d49RAVx4p6yKsstNSFA6hnhdcnBnws4s32KIs/h6Al5Xle1BzJhRirC7KIVjNmwbdA+Sq8VR8FiIMVjr6chzVSxMRW9vcX7MrFItmAQq5ONtIEIfQpLJXVCX9f1Ufg8HACpq3AaObd92WTUtRu8SjWjLM2fAZ1MB6CXu9R+ynEM0Dp3n3R3cSBpifXBH2ecJ1PR8Jag9mWz6i9BmCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(82960400001)(86362001)(5660300002)(8936002)(52536014)(66476007)(4743002)(478600001)(33656002)(110136005)(54906003)(8676002)(10290500003)(186003)(55016002)(4744005)(9686003)(8990500004)(2940100002)(71200400001)(7696005)(38100700002)(122000001)(450100002)(4326008)(76116006)(316002)(6506007)(2906002)(66556008)(64756008)(66446008)(66946007)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dZFJEIL6AAmlX4yzZHTXDw7CGmwN8TrxJ9bmtp+espqQnvtPkuXx564R7Mdj?=
 =?us-ascii?Q?JoXuYwKvpejzB1VGNJDIemHnHD4zDkAppfZfTbWL9XydKDkgrn0UyQdrPAms?=
 =?us-ascii?Q?a9/XcDTm9nC0lAwj3kRN7XxH4RsQzlTByzVMzlkQQMUl1fxnbSXHl8j2L559?=
 =?us-ascii?Q?t/783T3C5kNRlTA5pXPvudrFY88YpztFAWo55jECFL1VksFju6TktbdAYfxV?=
 =?us-ascii?Q?5E48QAPI+UgrQYnfFgdxnALneADjmckM5fBW2TndLwbgxG+LvVuyef7sK3tQ?=
 =?us-ascii?Q?kokRtmeqWI0vnzdh5QJoR3lzyU/NiUyqO2Sh3W4OyZ6K2PZJrMSxr6dJHqYC?=
 =?us-ascii?Q?3fiRh5pEPJ3RnmTLDyFQLXX1EpJDa2Bm8HuhIFgUaH+P4BWrqbYzjs239yHc?=
 =?us-ascii?Q?o6nh1KRLBTK5nN/e8Twr/0MWZMoZDmdXTH9LQBw/XebVztz4Y2pzhU+nNqIp?=
 =?us-ascii?Q?pWRsx2EV6EvCP1J62D29feEKE0WNz5htbcrKA5TWvbfFDInz2Eq1mpv4lxGz?=
 =?us-ascii?Q?4xr/noIksWyDU4vP23rNwHROm5BX97CWLnQIwgtB7m1GQHaIebhXfCsEIXme?=
 =?us-ascii?Q?cojtHp7t949PtJncLTGSAArqxiD6DcUseBetzFOKo2/0+FsWbfUT9vYxKHdk?=
 =?us-ascii?Q?VIIgORpBltAS++R6BxCihC/LgNKjHgci4ZsiX1NJya1bYUabadpMv8M8Ywm6?=
 =?us-ascii?Q?dkZgwZrtuJDWl6oePnSTVQ30pn2DBW0T5x/erGWzeRjOP124f2LghCBCMDlw?=
 =?us-ascii?Q?k1KNXw6fhW6KRPwPzYkr0luh9i0F3XhTYOqSNtI4evJYRDdjWEXK5YimOfhw?=
 =?us-ascii?Q?tvAOCSqNaxiJDtoDaQ56gW+Jw03qpS0wmPxEmi4S0aFHRDE0WsDdF17M3VUZ?=
 =?us-ascii?Q?wlqaIyiqlpA2cjdzivzMLo8dmreDCDas5nZEFFYZsqUnGvU9SHOsjzf9gwyQ?=
 =?us-ascii?Q?wv+aBz04z2pGDh2bLl8CfeulJH4d0F/jP/cXWHlA?=
x-ms-exchange-antispam-messagedata-1: aWKuH5LMf20VMINsuVGNfvCQoJ9NjWKu0SaYoxX64kokkXHwW8pElxM+d1rUPQoQX1LM8qAU7rADUrrSNnFhL4iyHDvYaxoG5MrbaD9UGU6HkVh/8PNyln5uLkCRpweW+dkC99HjNKCht/WCraEWma3JOlZLWEKPhMhe4uLjq/cOIsDZRWMBIFPXVDX8e8JpIw6Z2Q7l98uEa/cIUuBFD3qGI336ftzLN130ZNoJTZJ+yODNOZjB7YivOI4C+RC0QSSZnCMXoxO7DZ8LnF6qclPnUrFZeSe1qoNo5g1Ilk6yXdgwprpv1p9XGv+GzYNYvoIDQ0uUYZ21hD4acu5tLbbXpKmYWXtCWakhumQLRa9Mz2xpCNx2kRNGhgfhE0aBksFSfkM6fSH0hJOjrYsYG/g+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efe575fa-4412-4a1d-de32-08d915d4a3cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 06:02:07.3755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyyoVi/8cvv7taYHWK8I/358Pis0AdlqK6JrUy4DE1aUJb0YtfDpvOFa/w50Gl1zT7JzSDTYI+d3duz+2rNKeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1939
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Wednesday, May 12, 2021 9:19 PM
> ...
> I think the latest mainline kernel should also have the same race.
> It looks like this by-design race exists since day one?

I indeed reproduced the issue with the latest stable tree (v5.12.3) as well=
.

> > BTW, iptables does have a retry mechanism for getsockopt():
> > 2f93205b375e ("Retry ruleset dump when kernel returns EAGAIN.")
> >
> (https://git.netfilter.org/iptables/commit/libiptc?id=3D2f93205b375e&cont=
ext=3D10
> > &ignorews=3D0&dt=3D0)
> >
> > But it looks like this is enough?=20
I missed a "not". IMO 2f93205b375e is not enough.

Thanks,
-- Dexuan
