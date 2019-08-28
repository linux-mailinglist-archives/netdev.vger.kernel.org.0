Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AAA0BBF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfH1UpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:45:24 -0400
Received: from mail-eopbgr810104.outbound.protection.outlook.com ([40.107.81.104]:62802
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbfH1UpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 16:45:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgQTKWzvO5NKofd7DuWbhrmgUwT+2nTQZ6VQ3W4chM4ogkPCBAN8Wj3z6MEyRyMOMXkKX7Ixyk3yCNBi6QBjtRTP/5ixytOCMyNC/mdbXQTlHlePDz/inggcLoA1OTH6/ZH5XidwX8zShFUkHIgOMAIJAc8O9b8dml8VW53TixYp5ilmTl+JxNwgDfJ9CqFOkIRo86nl9PCpCy1HeLd9O4hk0gla/ISjfmuCsuJnarziaEPEtFBHZh6cF4B7VPB3MSjb96zexd2Rz8zdiNAH4kGIvI9QDPj0MiPIbdHI4ANsA6sqQtKy+trm4UtkpDCRjozdjOoPu9eQw90Y4PSxNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4N8A8bK/JhU8eCUwoWU2R06EJ46Fxom2YRtMZl+TkA=;
 b=JIao8v6/X0JB9r9fJBdj0FGXDZwpP30LgDPeeExNKqb+cEk2ONCfe842FDHexrfvi8/AezXCt9uoG3vmY3/AgQB2Aabwe8UPKxorR5tzr3/0QqPR5YlKkfj5xJhnRwE6Zub9kUEtslbFLo1CBdenUrRiOdO0XZkVvZj0hHO2h8Z4LfbZjidM5TUJTn/5g0t+9iJlV4lXQIaa8buDXNAxIFjyMSFKQJb0pcIsWGBHyDzKw7zW3gX1pZIveKmuJki8aO6RUscqL9RKiGHkyfjGZsLT9yCrt/8uShs6rIQk2L3Z//dh5JBEqhBYJCpzzCovRufQiKBAwqFAM1MKUb5LDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4N8A8bK/JhU8eCUwoWU2R06EJ46Fxom2YRtMZl+TkA=;
 b=vRQNC0LzAdzBLegpXFNx58GLwRXXNgKx2KEfGsCYgBF4sotBkWlB+i8F6j6KeRacNj9AvWEJTF4Pg5caopMiPis1LCcCDhMgvd5bLx2PWoSF35annp2tYhucFZeQQYMMr1siAU2EW1axmcb2wFrKKcnhr4DjvILKqP0x1gwHY0U=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1405.namprd22.prod.outlook.com (10.174.162.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Wed, 28 Aug 2019 20:45:20 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3%11]) with mapi id 15.20.2199.021; Wed, 28 Aug
 2019 20:45:20 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
CC:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 01/15] MIPS: SGI-IP27: remove ioc3 ethernet init
Thread-Topic: [PATCH net-next 01/15] MIPS: SGI-IP27: remove ioc3 ethernet init
Thread-Index: AQHVXeGCj7Utd268IUuam0Km7Mn5KQ==
Date:   Wed, 28 Aug 2019 20:45:20 +0000
Message-ID: <20190828204515.mz4ijqrey624vnzd@pburton-laptop>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
 <20190828140315.17048-2-tbogendoerfer@suse.de>
In-Reply-To: <20190828140315.17048-2-tbogendoerfer@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0115.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::31) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:5e65:9900:8519:dc48:d16b:70fc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 599d0ae8-f952-4ee6-958e-08d72bf8a471
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1405;
x-ms-traffictypediagnostic: MWHPR2201MB1405:
x-microsoft-antispam-prvs: <MWHPR2201MB1405662F76D2ABA5183EDA69C1A30@MWHPR2201MB1405.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(366004)(376002)(396003)(39850400004)(346002)(199004)(189003)(9686003)(6512007)(6116002)(25786009)(46003)(33716001)(4326008)(42882007)(14454004)(6246003)(5660300002)(53936002)(6436002)(508600001)(186003)(6486002)(386003)(6506007)(256004)(99286004)(102836004)(76176011)(52116002)(229853002)(8936002)(476003)(71190400001)(66476007)(64756008)(71200400001)(316002)(58126008)(54906003)(8676002)(66946007)(81156014)(2906002)(305945005)(7736002)(1076003)(81166006)(66556008)(44832011)(6916009)(66446008)(486006)(446003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1405;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ALEpe80iBTaMp63ei/h0t1u8+Tdkgm46kfcUZYEZd1mmJQ1s4X6dcySM99FCoq8J38Vcl7kFa8+KSXEpvVc2bFZVaYw8LXTkDef80rsq48f0bFB69vECQEaxXihu525B9ocytGRpEo9HcRZXcv/Q04ftTm4gPFx17NJcZUqA62q3kzD702u06P6CtfQz/Bsz+d5v/guXei0NdKVObjKAA+oo6zcqtDmja8KmY5oaertCJYwsEL2C77DvVEiyXAiP3sROPgL9CtG4dWfpL98kcQDjBq33HgnL5PTwFVbzI/zSxZi0ulDB6YYOwy+da4mBkUZryIO0ZfMACYFjnnopAuGqgiRVRHwWiRu+aOm4ZMRwCBrZjzIfzwZXyf8nW35eezcRK2KVXUUS2hBsi8k5oXxMGZKBuFzldnwS6X4Ej/I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D32B5F4B3FFAC489CA16FBD9A6C3145@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599d0ae8-f952-4ee6-958e-08d72bf8a471
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 20:45:20.8504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYqVflqZfl7zHKFhEumx3vWgVshaxdvJI6toVkuWKjd/EJ0uP02+GUM2nG2uPl6bIfEu25uiDyF+yJz8KmS2QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Wed, Aug 28, 2019 at 04:03:00PM +0200, Thomas Bogendoerfer wrote:
> Removed not needed disabling of ethernet interrupts in IP27 platform code=
.
>=20
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Acked-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

> ---
>  arch/mips/sgi-ip27/ip27-init.c | 13 -------------
>  1 file changed, 13 deletions(-)
>=20
> diff --git a/arch/mips/sgi-ip27/ip27-init.c b/arch/mips/sgi-ip27/ip27-ini=
t.c
> index 066b33f50bcc..59d5375c9021 100644
> --- a/arch/mips/sgi-ip27/ip27-init.c
> +++ b/arch/mips/sgi-ip27/ip27-init.c
> @@ -130,17 +130,6 @@ cnodeid_t get_compact_nodeid(void)
>  	return NASID_TO_COMPACT_NODEID(get_nasid());
>  }
> =20
> -static inline void ioc3_eth_init(void)
> -{
> -	struct ioc3 *ioc3;
> -	nasid_t nid;
> -
> -	nid =3D get_nasid();
> -	ioc3 =3D (struct ioc3 *) KL_CONFIG_CH_CONS_INFO(nid)->memory_base;
> -
> -	ioc3->eier =3D 0;
> -}
> -
>  extern void ip27_reboot_setup(void);
> =20
>  void __init plat_mem_setup(void)
> @@ -182,8 +171,6 @@ void __init plat_mem_setup(void)
>  		panic("Kernel compiled for N mode.");
>  #endif
> =20
> -	ioc3_eth_init();
> -
>  	ioport_resource.start =3D 0;
>  	ioport_resource.end =3D ~0UL;
>  	set_io_port_base(IO_BASE);
> --=20
> 2.13.7
>=20
