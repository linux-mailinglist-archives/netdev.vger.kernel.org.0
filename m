Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49A62CDB97
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgLCQvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:51:33 -0500
Received: from mail-eopbgr100119.outbound.protection.outlook.com ([40.107.10.119]:11140
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbgLCQvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:51:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUh5yygaWTdSHl3Lj3a+8ndRNNL05hCkurRvLSyO//b5gmg23CR2f3XoO1L6PhPNaht+I5TjbzoPT2zA49NmZYoX0RZ5/p5OSlHrK/PDSU/h699ivJiYI6l9xXMEZHPmw/esV3TencYAe2LIXHxe2uk+IKG/1bJwInSXUaz/+Mys0alMIaeflda1tPnqpQvpNOZ96qvUWf1/GSGwo+6eoP6Nc9CFTKpyWlzhJUvt+B92n+oxxVWBKJM65K+fgrm+kDQXRldNTG2ZEjs2S1ZABjG8ms/VrEGn3u8RzKhG54fa/RpC6O7GznpetpQKHjTueWCY3Yt/OeCqVJvKn8w/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aicPMbx8kquvyq0RsG85Z6UjQ4eazu3OAULwZEZKBA0=;
 b=eEs6aQ2Fp+tvFlJpx/2+x27nhAcwLAvQeazEcC/U6ECQX+dVxliTzSzXgpFhjyQOEeG9hohwUaaulQO1lm40ntJE8U5Oz+qDo7kbOnplNfJnuyjebHoSXV/2Mv6fAwu82qdYehlE31RHjIqey4CgVCeHaAaPKQZ2QfHOgHiCMFi5OTbKXIeHoKQ0diW26T3kz9i7QR6BYb2sVRw+ppBDhqLMT7qam5goTEOz+PBYHWoETckZ59hG6fo/4tL5POF3zNcgiWncG1Pc7OgaBcNBdnt21Ywqsj78gjuB3Rt/XCTl2NUqOU65Pw35Oh+Uh37hUKyqcaC7svhnlO+nA1E7Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aicPMbx8kquvyq0RsG85Z6UjQ4eazu3OAULwZEZKBA0=;
 b=vUPZ/Pq/znbVPtKyR3NG0B7s0ggfHIUIfdrO8rK5+f4JBzJDgKdG99tF/kezpFrrCH2TnC5Syl3zSieVrQdK08QeqApkqzqItxETmEkK5sZcZu4Wi4WScoZfQdyymsp+opmNRbHb7x3J6A61a584CuxlZD9E8avKoKge8udG4xU=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWXP265MB1046.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Thu, 3 Dec
 2020 16:50:43 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::c196:42db:8b87:c1ee%7]) with mapi id 15.20.3632.018; Thu, 3 Dec 2020
 16:50:43 +0000
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
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v7] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWu/oh8T+esyecpUerAB1FdPgUnqnXaMIAgAKA/DiACvt14oAAvUSqgAANr1o=
Date:   Thu, 3 Dec 2020 16:50:43 +0000
Message-ID: <CWXP265MB1799A9CC75C3B506E1475D4EE0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20201116092253.1302196-1-srini.raju@purelifi.com>
        <20201124144448.4E95EC43460@smtp.codeaurora.org>
        <CWXP265MB17998453F1460D55FA667E51E0F90@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
        <CWXP265MB17995D2233C32796091FFEE4E0F20@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>,<87h7p2hoex.fsf@codeaurora.org>
In-Reply-To: <87h7p2hoex.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none
 header.from=purelifi.com;
x-originating-ip: [103.104.125.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54683aef-bf7d-432c-132f-08d897ab932a
x-ms-traffictypediagnostic: CWXP265MB1046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB10462C8DDAA71C2B30E81D78E0F20@CWXP265MB1046.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QbLHmUMr55W9tiXFWykjGv8MAvKrQo9PZn1KhkF6RzSpo8+dYi2NIKiUWpzRvJeNQNu5HTY8Kr9QukJMQhoJOZcwIHpYbLhyg6zmGs6J+xNsYjGXzQBnH4v7NkJv/pjNDFOXm21Kc6xeksSy+5RQKjTqxuFQGY6LBdLIYdYwgLfgufu2Gb7NWshDUjGEnvZfq2p6c6SV2g+fmc7qbh6pY6va/r9o8/cUfVR7FI/diJT5EKbg7c51QVGdM4fMXY7x+h1uaFAs0xIe4DEVjyZXnM8Zv9N1ZvIuCxCz9o3uwh+8KmZoLqxQRO8rVTJWP+z6XvZLcX8pwQ/9nrPUQzUjEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(396003)(346002)(376002)(136003)(39830400003)(366004)(4326008)(66556008)(64756008)(66446008)(66476007)(33656002)(76116006)(54906003)(55016002)(8676002)(478600001)(91956017)(71200400001)(186003)(26005)(2906002)(9686003)(86362001)(6916009)(316002)(66946007)(5660300002)(6506007)(4744005)(7696005)(52536014)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?FvQHu3HfnHaVyCCwVsUmwDZf+HEEIZsoXZt9rxg36LExKGAmgm11+SqaRn?=
 =?iso-8859-1?Q?YSVtFX/IOd0Up1wFlDjCd/1W/uIlmP0sbfaBTj56bwyVz9O1IH0VaHOo7w?=
 =?iso-8859-1?Q?HSIcK4ktxISgT/zITQlQuwfA2Cu4O3fMkPuFd5hp0J6DrWJpwXNVDEFcZV?=
 =?iso-8859-1?Q?pRRR9/hKOXa858DyS2N33NQ8zIW7uRIg/eg9JntiN9oFYr5vKaYmU3U/lL?=
 =?iso-8859-1?Q?zd+GtY3jreQiimLCSLnhXkbnan26yvC479gsq3JY+h+l7JxQEkaqBhKmzK?=
 =?iso-8859-1?Q?KLOAFZW+WfZspQvDslgqlw/q8xT7QamOXtdRmZ1WT6iDFmCW9JiC1OaQ8a?=
 =?iso-8859-1?Q?JzyRvvD5TrymQMBYoy0XOvMB9tok50+fQnophQFeNyBSGYC1N7K/YOuTNZ?=
 =?iso-8859-1?Q?e1AkgTCjIiEPweinXXE5t/7aIbYzsnM5NOFHtTab9Fl3ta0CFKZ/Dqpzij?=
 =?iso-8859-1?Q?k0SdNQ44Exhqa5Bxq42zHlnCTL5+fKu0hSZt7q1iw4Mb2hiVZDDR+p+aZN?=
 =?iso-8859-1?Q?N6aF1EtcuRlAFZp+k73DiriFCXz4q8+6QET+EOlatR7s0+LHNkSoYEBONI?=
 =?iso-8859-1?Q?usJz3PdO2RhqdXaCUimZ98SD2Dpaj4wqEoUjy079idBdcUmZ55lpzrK0eX?=
 =?iso-8859-1?Q?sl/HvXsBhxKjGfGxRqKCGgQpMSEJJ6C+ZeKLZ6+mGRGPKc2C6ROq2reD1z?=
 =?iso-8859-1?Q?u5zcCWeycNJpMsaTY7X24+m5vtd93k+fG5hN53QQnLvpW4hGCDQhMgEBp1?=
 =?iso-8859-1?Q?J1pTL51cW7lB7w0JfiLOVa/6FgvGL3SeJmhlRT77ecTgnCAr26eIwmD4wx?=
 =?iso-8859-1?Q?nKo4hIruHh2FYcT5mO+Fdx4o8X6wvMNLRI+DDqkYpUg2PSABRDxQK+pChC?=
 =?iso-8859-1?Q?pb7Csq0USHY/c8boTqrn8q5RGBQ4M4+JSfPRWVQ70IjUhpKQ6vs24UuLVv?=
 =?iso-8859-1?Q?abwqQqOitRsK4nuW7t1D+rRyuLIL+WobdMH50wbOEXJwdASO+i0wkZasIw?=
 =?iso-8859-1?Q?FvUdWNTsJLuOrYMZU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 54683aef-bf7d-432c-132f-08d897ab932a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 16:50:43.6209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iLNHYKmxLaegEOpW1N/g1J08egfmnsOWuI6h1vSUV4tu4RChJl07TDMpe1fL8SvvIwlHxXiHThod0GRPa+D/eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB1046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
> What will be the directory structure in linux-firmware? It should be=0A=
> unique so that it's not possible to mix with other drivers.=0A=
=0A=
I have created the following directory structure, Please let me know if thi=
s is OK.=0A=
=0A=
 LICENCE.purelifi_firmware |  29 +++++++++++++++++++++++++++++=0A=
 purelifi/Li-Fi-XL.bin     | Bin 0 -> 70228 bytes=0A=
 purelifi/fpga.bit         | Bin 0 -> 3825907 bytes=0A=
 purelifi/fpga_xc.bit      | Bin 0 -> 3825906 bytes=0A=
 4 files changed, 29 insertions(+)=0A=
=0A=
Thanks =0A=
Srini=0A=
=0A=
=0A=
