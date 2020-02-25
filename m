Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A743916B683
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBYAOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:14:53 -0500
Received: from mail-vi1eur05on2139.outbound.protection.outlook.com ([40.107.21.139]:29204
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbgBYAOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 19:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erEJpfsFFk6T3S7ekZXsWVOyXuTcXQZIzpg3g91ru5MyaLAkJrR6Ki0RrNpVTzunNhzUCg+ZsMx2IbWg3VPknsdhuanw4lT6pkY9ubFVWnf7aHo11MHdhLcZYWFZUIpMCJS1BtNXCPJYLy44TAvucfjejj38h0Xiycn5KBcnut5J0M5Xs12IwkjANZ2gzw/5gYoOtW755sFBp9uJVng+9DrqmcpcJ9Ouchz58GnLPH9uKqQ20EOQD9Yw+Uv/BJtcDPXGUNGkrzX36Vv7aGYn+TWnT1NNhn7FAZPQrzwF5ExUZsvSrkL9B1heTlVWidu/E+npQgsJgaGa2hgyiO+wag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j43+D425VRp5NzTNeMMebCI0wIQnUMk058NmHC9mSck=;
 b=jrdJp1D8posY1T3gk+zTmJ+AMUArsrgqKR++DgGHr0c++Xbbwj7r/ooipe7AmZTZR9AVW6Nx+VSYlVvK6IGnpH4DafRogNOalm7ED3DsPXwYktLIEP/7mfFBBjp/XypCxregov++gqOZ7kYtwtoasA0teBKSBLZwu8nCw8FTl1ADrYlIxvhp39rMcNeUzf8HTqVzgolImy2wvTPreWiygTfQldhdaVetDY89UHxLJ1m6Inrojyx2qCXNEhHFETY2lbzVt7FXmElkbuRaCY3WPbPpSBWJJr/ES7aPqop3ykYzyOl6+3tkv7qPOTsBNOq7SiLqBmsavJQ9YhiJJC9HfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j43+D425VRp5NzTNeMMebCI0wIQnUMk058NmHC9mSck=;
 b=YuZudngG7yF3P6o9xypq2+1f/0FHee8gdwbVczxDQHbtsLssTi3XOWmrbU9OCB63rdcirXztytqcMba/QNEysShSUgulofNq/2xbFRrYlCiwJlDWj2PJYb66pcEsF3L3+w03fjugTHuOL5n1KFRCO7UYCkBXVj/OR3rKgjBrk9g=
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com (10.168.24.141) by
 DB6PR07MB4231.eurprd07.prod.outlook.com (10.168.23.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.10; Tue, 25 Feb 2020 00:14:49 +0000
Received: from DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::d40c:1a36:d897:dd7b]) by DB6PR07MB4408.eurprd07.prod.outlook.com
 ([fe80::d40c:1a36:d897:dd7b%2]) with mapi id 15.20.2772.010; Tue, 25 Feb 2020
 00:14:49 +0000
From:   "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "willemb@google.com" <willemb@google.com>
Subject: RE: linux-next: build warning after merge of the net-next tree
Thread-Topic: linux-next: build warning after merge of the net-next tree
Thread-Index: AQHV62GlIj4EO15ztkCQL+lX7FjKtKgq8LCAgAABR4CAABdakA==
Date:   Tue, 25 Feb 2020 00:14:49 +0000
Message-ID: <DB6PR07MB44080818D2EB925DD9F024F1EDED0@DB6PR07MB4408.eurprd07.prod.outlook.com>
References: <20200225092736.137df206@canb.auug.org.au>
        <20200224.144243.1485587034182183004.davem@davemloft.net>
 <20200225094717.241cef90@canb.auug.org.au>
In-Reply-To: <20200225094717.241cef90@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=martin.varghese@nokia.com; 
x-originating-ip: [122.178.219.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8493b2d-81a8-4fc8-e562-08d7b987ba3f
x-ms-traffictypediagnostic: DB6PR07MB4231:
x-microsoft-antispam-prvs: <DB6PR07MB4231E1A514554F8A052866D3EDED0@DB6PR07MB4231.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(199004)(189003)(52536014)(186003)(86362001)(76116006)(26005)(478600001)(71200400001)(4744005)(66476007)(66446008)(66556008)(64756008)(8936002)(53546011)(6506007)(5660300002)(66946007)(2906002)(4326008)(55016002)(81166006)(81156014)(8676002)(9686003)(316002)(7696005)(110136005)(33656002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB6PR07MB4231;H:DB6PR07MB4408.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1Ycka361L+s4eKHm8YfX/EiHSjQqZmsVSHmTTh/OBA+7gs5hBCgKMTbyWn5OSnDqAP9K4bxIPmggP9hEWY0CaKVbbuUFz8n8KU36gpQXeU7+LN2j6Py7p22jXhAaQef1de0lKwXw2IGLS/b6vYywwQA0Z0sDNCHWnFPUm4sfffugUBtMQHmpIpxltPYt+p3J2xbQjlR1Bozx4U94RYNrhwvUU9TnEajim6zMQgnAP+UWxQV1yPZl31Rumcao1QtLMWNfmz90B2ChLfRJdDWHp1NLHxu8rNIhoEaIB++54LkFjZSHuHhtF3G+AbXgTu0Gw/xE3ZEArMPa5cIeSTvSZk4fGfGx2L6GwTQLEtyMmleZR6H5awxLh6e/VWsutIHqh+3WOff9QOrvSsCh7+MrQKmvcZSLHhiZl5xCJD2nZmEvCPQnWaq1MDKYx+dKX8m
x-ms-exchange-antispam-messagedata: K5YynRerxxBK8Y5y2NnVp/fWEpwdnX9UuhE5fPtINljv/FnNXDRZcktzcACEXXIOXiRyEly2sDQAXyEcqMvW0AWVnC4Rzlai4kbii75fU8nq7TOEupgpMAfDq9+EDumMQWQJK1ludEtLIoVg7vIEDw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8493b2d-81a8-4fc8-e562-08d7b987ba3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 00:14:49.1338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kr79IuEtQRjlx2hhWqafYvAE/GveimVV6fvsmUR8BLnTSBLsuIRD4szCqxX0UdAa2bgEVqZYFtkLEYx+2nS3DNtRUssvl04CByvOIn93UY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR07MB4231
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI David & Stephen,

In v8 version of patch while fixing reverse xmas tree I wrongly judged the =
variable usage and removed the initialization. But wondering why compiler d=
idn't show me that. Apologies.
David, Thanks for fixing it.

Regards,
Martin =20

-----Original Message-----
From: Stephen Rothwell <sfr@canb.auug.org.au>=20
Sent: Tuesday, February 25, 2020 4:17 AM
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org; linux-next@vger.kernel.org; linux-kernel@vger.k=
ernel.org; Varghese, Martin (Nokia - IN/Bangalore) <martin.varghese@nokia.c=
om>; willemb@google.com
Subject: Re: linux-next: build warning after merge of the net-next tree

Hi Dave,

On Mon, 24 Feb 2020 14:42:43 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Sorry, my compiler didn't show this.

Yeah, these ones especially change with compiler version.  I am currently r=
unning gcc v9.2.1 if it matters.

> I've committed the following into net-next, hopefully it does the trick:

Thanks.

--
Cheers,
Stephen Rothwell
