Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535472F7876
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbhAOMOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:14:39 -0500
Received: from mail-eopbgr100126.outbound.protection.outlook.com ([40.107.10.126]:38112
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbhAOMOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 07:14:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mr9PpPKCovZQAqHilLPHf0yRz56nB6EYFboYqL2qhEk496rIeojyFyaP77+WTwdz3ZCNiSLrp+w+S6Upg+0f8cBvw6uASWi3mdOli54Yh+j91ENyO7xd4/clWJ2j7opdEcGwP9PNUqjMOp+RQViu/0NL46HtdCMwxKB5DO1vTJxWAWp+uD6uUQEFjHGSNShsRyozWer7AGQc9bJ/9JDfR95f3ju96RmFAorWy+FWbhqcqOBjlrnCWiZu4kQ3uAG4CmWpmpeEQGq4UhYaK6UfvYGOa9nOsnwXLGGM9jahhKXdsrpjv0MjgZB2hTzD4T5+82Yvr8gHOB3Ln2NOQIxo5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aksGs/7W8CrqgU8CluBTCGY/V8U1W5sA6hI3nuhqezo=;
 b=KlJ7+H9s7Ul55+fJp/3yUwRShij+tPaKPbxFujk2rP9i7e/arEu4pEn7MDxlAiiofH0LY2sU+bWuTHfIyrVxM6miQ6COZWUHBrtWDMDN5JYI96bPAqmqT79xV+E5qvinJmnXa++hvCG+Hts+zTlGEuKU3jtMc5dB/rVf3FssqfkE3RDH1YuuFNkBXWemcuISl0ipZN5n5aqgStL4bpm7PTYPqcvNpXwIst6yH2i5U59R8ev5B24TLDxTFtXvBWn52p+aqL/bNgl4Sy+BydzCUqUMHMSejGexr6Yt8/U8wJgA7ogsj6LiaG7GgRHN3D9JappSjKXX4+jYXGVx1uuAQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aksGs/7W8CrqgU8CluBTCGY/V8U1W5sA6hI3nuhqezo=;
 b=HIFtzZZJgPy8JV6kVzmzlWDeZBOlTSBhai6zl12fe/wYhWxPWXms9czMda/ALEcFMfo9dwC/CWvU2s1Cnv5Ckcs57L7k6gkblcJajKU6spPWAXxEEqDUL+qvhLKBASBWa/i0gJL3hY2GWGJtFdWqVigguBWLlWF2rJ54tYldWIc=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWXP265MB2839.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 12:13:49 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 12:13:49 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v11] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v11] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWzVlVgcXQb53S8U6wOEHHlogKlqn+dwsugAKom+CAAAIA5YAnsukk
Date:   Fri, 15 Jan 2021 12:13:49 +0000
Message-ID: <CWXP265MB179939ED08D6DFBA53C9C65AE0A70@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
        <87o8iqq6os.fsf@codeaurora.org>
        <CWXP265MB17998064FCE8FCE6B313FAD1E0C00@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>,<877dpbd7lu.fsf@codeaurora.org>
In-Reply-To: <877dpbd7lu.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.104.125.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 214ea67f-eddb-4f50-7d38-08d8b94f03e2
x-ms-traffictypediagnostic: CWXP265MB2839:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB283914A9A2828D26883C0564E0A70@CWXP265MB2839.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hM8eUEKH2UHuJ6OupP8KJDgNGlnLpXbyhS9ny/3OpLjqqxBzl/Hbx1EqVxU0HiYsNWqY7bbQo1ZRnDN8SOMSy44yx4WavqhJNLckeQ84kj1xFyUwpWw/o+Hk3X+Vn3el96040Ep5XGFxSB54sMO7FDiZRx4i1XOKLywisKPVZ3ViDkPBG7vBCoHX/XqFc8lgO7zlMc1uGGkJpxitWvuJaGBJaqUa8vHmMp+7mrPSRj1FOVG2u/5Ditd9pHIQ9sPmpnvpEwu46Vj2nH6R5bkxCIINxefPTgfL0uQ4KeXvVLFmrd6ZvgsC5eZBycKUHlVuoiXBIuU1DNGetZ6u+bGd5wdLTqT48vvmnrqU4weq6dD80De6E6xz7StXXdgetAsSnGUUEBR5MVxOLHRSVlwi9m66CAsAUbam1R0Rl1oDd0YWR3XZBLtFgZ6vTaJgstVJ/SinzdDKji1pnClg6W14b8Sbq3nwTuXDIMkttEFZb5Z06HqRxsEU7tpq9cYS2ceJ/GGUks7WYpvDqzvRtKyyrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(376002)(136003)(396003)(366004)(39830400003)(346002)(55016002)(8676002)(54906003)(6506007)(76116006)(66446008)(66476007)(64756008)(316002)(66946007)(4326008)(91956017)(71200400001)(2906002)(558084003)(66556008)(5660300002)(86362001)(7696005)(33656002)(9686003)(478600001)(26005)(8936002)(6916009)(52536014)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?hdIWlgi95ycp68K4ief44PV10SUMech+sZmp7O4I/SiLTSQO5ekfSxXgLX?=
 =?iso-8859-1?Q?B7hVrv/yw8tla5i7qvMmN+wZxe0Ivk0qmnpa7U358B9LxZxagErR014H3w?=
 =?iso-8859-1?Q?DNfdXrCD6cZs8pK1fN1Nt8eomaPzAGrbnt6lptlNA7m0NmCS9E7GjaeXqj?=
 =?iso-8859-1?Q?9MpITB/zC06C4TP9UUe+NZBGs9gV+GQa6l2lFx7qW0wZccrBLS8qTdqsrV?=
 =?iso-8859-1?Q?gFjZ8RMQdiFWhcLc0eM2Z4e/PWpWo5hWMx0+FJLnto8mM5mZrB4OORKGWT?=
 =?iso-8859-1?Q?6rjmDOirssIr2+TidR/ADMvUYU60HQbk/5i5KDIyln1uz/NIEqLau9uKBr?=
 =?iso-8859-1?Q?HFxSLs7ufHtbEcf7FpJ0t+Ua1mO/UW2QZSC1unXmQ0xssqVR4fXFe05Bur?=
 =?iso-8859-1?Q?b6q9AtnJO3DAoV9qXt/vDoCBdH/DNm/OhIVwuk9THX3ULK4+t3WWDoZbh7?=
 =?iso-8859-1?Q?dGGLqxd3NyViYg8FZ/qknZiQ6HW8G/g78WKk932vvQ5p7inwmsvPyjuHy4?=
 =?iso-8859-1?Q?os1P4o8XBCsQRoHAUHuYPH/npr7nWq7pJgiQbhle8u+59qg7Gul1Vy3sXf?=
 =?iso-8859-1?Q?62Cl7ltSaEUgHYrIBFlnrWpD0kYzP5zGCmOrG4lBr2nuDsFyjJpYFWqHk9?=
 =?iso-8859-1?Q?YIG2gcV0vV3vEhLsQ2nTsh7nE850SxhhMs87xfWkhXFWK0F34EYJ1kmK1s?=
 =?iso-8859-1?Q?jNMEqsu91ShpqnBKdVPB6OT5qf8C2FiGltGdfD8zQrJXXqgOgFv+G0HseK?=
 =?iso-8859-1?Q?BKU9X0a8lOW4AEsM2v7lmYlVPnB6DnQOtB7QqcST5Z97+QCmZnxQBEL3Yn?=
 =?iso-8859-1?Q?go5Ai621Sxa5chuQ2p9ylu3eBYWwDNm3BW5dwcV3bJlV67vbOHMwWULG2O?=
 =?iso-8859-1?Q?1lVHmUIKGtsuIWDeewKKHJT6jFeE/CpL86DpWSRaj0Sv7ZGzhe2tKnhKGB?=
 =?iso-8859-1?Q?FGnokMJZ0QUGqDdVcZALjyh9YBh3T0xvArTyt1b2BPHzHzyzq4j/wbMeLm?=
 =?iso-8859-1?Q?YYCx9Fs0yK9rJmXWc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 214ea67f-eddb-4f50-7d38-08d8b94f03e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 12:13:49.1177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9lPriaJmMC+UtIIBtD+sk1mNq3sEGo0O4p992ioC0QxbQKbemhDx3hm2HcahVE6cs1V7//RAI9l70rVP56AQnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> I haven't had time to do a throrough review yet, but I suggest fixing=0A=
> the stuff I commented and submitting v12. I'll then do a new review with =
v12.=0A=
=0A=
Hi Kalle,=0A=
=0A=
We have submitted v12 of the driver for review.=0A=
=0A=
Thanks=0A=
Srini=
