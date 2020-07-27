Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC31922E622
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 08:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgG0G5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 02:57:33 -0400
Received: from mail-eopbgr50109.outbound.protection.outlook.com ([40.107.5.109]:62373
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbgG0G5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 02:57:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjFnLjUQlKhRPKcbnLxg9G+TVbsdBT49Vc38UFhidMwfZhdcV+Zma/5xyhmfTplkvFE4LmWuc5xbidXVeSz/FIcyZsvONRBuuUQqNhKLp+AU5jdTb0KJKem72bC7+soJKP/LUtmO2F/uZ0sc5bKMRs/8uuJLDyw1XkQXIWnAzrJC5VkxhhCYYvLRMeFOSrLaDQyV5AA2JcAIInzcrankn9HIdIbSnuXlAqKA2WgdSTmfeAIGci4E9tHtNYi8Ilc9qB4wMLTsrpQjitv4w3xYfOEpvmcJHPcJa9Ixk1MlzH6ZxkMkcPWyWjn/hVBzbObpVcI0xzoH1sMS+QKGBeLqPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04vdQvW0EfASuhtweW5e6aVTBJLfCI1rNKsV2OpbRgU=;
 b=jHdZ0lGG7ybFW4HGz6gHPrE47bNe+EvsUcsco4ikfguDDMLm3LZ/hvBlE1wBpEZhDScb348cRobekEf8eFlPnxuAbsp8wP8ABizApMlPplTsXAdx/R+RQEJ/vWT6a10MD9MYo278tbn685hxBK8Jm61Xr8liu9MinY9dd4HVUPvYmhAOgjzBcHRXwqM8dzN0gEVejavd1JodZaohpZVBGNZ3xRwiSMAMEVuUKlAe+mAbE0WusYiMXXmLUJHsuM2V6v5yYcTifmXAHmxrysVlYAo4Zd06W6pItmzsixC5yHeGet7U+BM9gxZ9U0xzZcMgibji1Olp5lMC3gAQZd/sJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04vdQvW0EfASuhtweW5e6aVTBJLfCI1rNKsV2OpbRgU=;
 b=mrAGWYmmsADWbq+l6vBjGIcAhW1NR/VJJea97vzHfN8+GkOgnMuiBqpu97OpaMSiVAzmlbiPwpnYU7GQlDJFyJg2aG+Trh29xyywCMzphJLv92mho5FIj8uRWGz2czc5pgRvXG0xBgBbcnCqIbuG6HzvL+1OHYhWEYc6ES5KQr8=
Received: from DB7PR07MB3883.eurprd07.prod.outlook.com (2603:10a6:5:c::11) by
 DBAPR07MB6950.eurprd07.prod.outlook.com (2603:10a6:10:19d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.9; Mon, 27 Jul 2020 06:57:29 +0000
Received: from DB7PR07MB3883.eurprd07.prod.outlook.com
 ([fe80::8415:b7aa:8ad5:2681]) by DB7PR07MB3883.eurprd07.prod.outlook.com
 ([fe80::8415:b7aa:8ad5:2681%7]) with mapi id 15.20.3239.015; Mon, 27 Jul 2020
 06:57:29 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     David Miller <davem@davemloft.net>,
        "martinvarghesenokia@gmail.com" <martinvarghesenokia@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH net-next] net: Enabled MPLS support for devices of type
 ARPHRD_NONE.
Thread-Topic: [PATCH net-next] net: Enabled MPLS support for devices of type
 ARPHRD_NONE.
Thread-Index: AQHWYEM8ZUvmzOl+W0iIGPmJWY9BxakVuM+AgAVJxxA=
Date:   Mon, 27 Jul 2020 06:57:29 +0000
Message-ID: <DB7PR07MB3883AE7ADD2F8A9DC800F2E5ED720@DB7PR07MB3883.eurprd07.prod.outlook.com>
References: <1595434401-6345-1-git-send-email-martinvarghesenokia@gmail.com>
 <20200723.150025.1966416182386618182.davem@davemloft.net>
In-Reply-To: <20200723.150025.1966416182386618182.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [2409:4073:2089:380c:15e6:5019:ac43:6be7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b989487-707c-40c6-8d4d-08d831fa5446
x-ms-traffictypediagnostic: DBAPR07MB6950:
x-microsoft-antispam-prvs: <DBAPR07MB69501DA5EBFC29A64966ECBAED720@DBAPR07MB6950.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1eCJIZmJ45FvObYBTYwjMRZqh6g6n+XV0ti4w11pIFOrFz46WrpBbIdXy1K4xiiaCUJn8ZJ63Kut46v7OOcKrZ1i3dT/FYqvuMKU2uB30A1Hu71ZaDterMfnuDP+AoFqn3zEyPquMQ8TVKeYCX51kymmeW8MoRORZNcHwwI3MRoAHEg/UC4N1NyyIQ5Cyjt0ui9eL7gClbc8/qwTcoAdiM1EDsyrLylGfeqL5ydBjYfrb8C98g+oNmEczgPPE1/elYtYlLkIdlwHoLnPbOoXL2YX4nvVTQwJuOEFsvWrm/5e9gg3fXEVtzI1Z2vn+Prd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR07MB3883.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(7696005)(2906002)(55016002)(316002)(86362001)(6506007)(8936002)(478600001)(9686003)(66556008)(110136005)(54906003)(4326008)(76116006)(66946007)(64756008)(52536014)(33656002)(66476007)(4744005)(8676002)(186003)(5660300002)(71200400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YdUHWmOAmRc6c2H+SM+WidvJp3z25kpwIuQvDJSx1pNMoWQE+xhuSZ7WNStjJS9zbEv0UbbEJN9T8NHL6QIvvCRV+FJpMSiR9FjjB6PyHiHlS2aibUjRo2A89wBon+IJXuYeLgOC8TUq0h1xSkNeT7elRoXcsdIfdWpAGZV/NInxdNVGxiIVlNgee0aTSKhDsZi+OCLZYh1ofzg2EA4lnmo8Acdmmdi16WqIxIVmnX7/3kMkxVL2LC9Rae9kydapq7CND+QXxVrdsuaJn3ojsdRqxEE4jTWtCs3x9ektcNuKVuwfk9ypxct14yeRNtY7lLjvBYD7/VwfFYOUNqMCAtA/6w6AY1zFKL8R3SU8FLmXDclfTSBwpsTuiXjnHkK3e4Cw3NBlJEfFP7zU3zfkAEOHxPnI2IZB0hryv+t3LEcTkz2ENm6p9U5mhIQLfEzf/AM3zCdKPvYV5TuB1Cb5QsrOP0ku/HdZs5tLI3g0JnbZO4cG8/jeDbCeZYrJRmjfuoyJy8Bv6z5B2PRq+hVSAQURfAAbuZJ5y9AbFSOI7PKrRCp3zv21lnawSy1dIXKtSP3hk/J8k2Gpy+v0YPxYFBpA1ciaHpngVl6D5E3UgW0I59vHYlNc/0uIljMLGoRmjPxpzRl/7FL3jGNvOLgzd4Xi0apTvz9h7JXEY62WsMbAb/zrPg8WGgB5wGrO2gHg03CRmRuB0oH1XmGReEDJyQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR07MB3883.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b989487-707c-40c6-8d4d-08d831fa5446
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 06:57:29.4592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fEqD7VGzJBnJra6gAOxhVlllcH6cAjbE0qVL2hefKiWRV1l7Zp+fsOZ8rScieMVPbe7SZNiGgZXFdtjrPWH325lXKbfHskDkN5QP7PLX7u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6950
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> From: Martin Varghese <martin.varghese@nokia.com>
>>=20
>> This change enables forwarding of MPLS packets from bareudp tunnel=20
>> device which is of type ARPHRD_NONE.
>>=20
>> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

> This restriction looks just like a massive guessing game.

> What is needed by MPLS by a device specifically, and can therefore this r=
estrictive test be removed entirely?

I think so . I  will send out a different patch which removes the complete =
check.
