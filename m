Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75809F4AA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfH0VDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:03:31 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:10960 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfH0VDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:03:30 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tristram.Ha@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tristram.Ha@microchip.com";
  x-sender="Tristram.Ha@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  a:mx1.microchip.iphmx.com a:mx2.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tristram.Ha@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tristram.Ha@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: zpWlrr/LAzjO4unoCeeA9rptwCvcMKkjSSBUOju6ttgwYCRfnLiLFLI0qWMTW2QsVcxhrw35bH
 G9IzKMa8Q2otw5X+oU/vrIv7tOhn2vvhdScFVdhWJmyqdJZuZVC2h6ivS5cernHofc1CxXq7lw
 URCckNHLebi0VfYZY3qMvk2/FJYJ9+/unNv0H+OEsOn+s9uz1WfCFFwpLgaSZESJa1HtQUR6HW
 oPRxnCViWHcUvhUl8zsutXksUE7WymR36lDoW05dPij5rfJAQuKj2i5vXbrBpweSo4fEWXIVDY
 qio=
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="46748735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 14:03:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 14:03:28 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 27 Aug 2019 14:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUKSdOnUcqhOVAggoOsw3YoIzbrDVdw/LtqFd1hIBSSPflksQY7ZRKu6rG7mIv1a7Xrd8QEnU3w2uPiAxPN+99b2jkuFf/mDrMwA2Umil49KnhTA5yP10J8JMm2GcTk+RyQCh/MAcXG6YA0TTu0goLMiX9YW9IJXZohRhM9yollOAWxpz+YBZDUrdadfHVXb3e/HF5nbGyd0adIJeIN5RQ/NCHFzIyqPs7sF6xo78pWT7EyR2ase1YBrFgdNe2VR/+A+WB25uAAJ1plx/0vQl5ExNqV9ZIBZylkithV99qcF71CkxteJDa8rjSAab3ShD3j7VZ/Vio8LU0QlvQiMbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbraKHQYPk0Jm70dcR0Zr/1/ZdEZK5cI8MVHjz4JuK4=;
 b=IC4IAKuqj+bXfcqL3OXd0Yo1ILnNd006LDhRo3v9wgyv0zV9hmyHJk4lDjdR4Kw//oib1w/tD3DW0UaAAZoBUlF5QQ69YYc9apgi7Trml6/+xgJlbPAW6C2yDpfRLBxZ9OezSBvUp1B7rjrdE+cc12cszja5M/EYQDlB4HVsA1eF9SjbMYjDxit2fl2etk9t8kVwRFz67tNWLbEZ1W9T2j2WkFf0qyivmm4FaCpmmZYPuzKYZUjjr38eZXr70DZ/ZuZqdg+beD4A/dYqBOSSVshcoq3xurGV54FtRLQ99vD1Y+VJy0qUbdzYEmtJ8LEgUCq+/d0xwOq+EE+3Jcm5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbraKHQYPk0Jm70dcR0Zr/1/ZdEZK5cI8MVHjz4JuK4=;
 b=ZvkBKnvJ5p27Gv0W/BMdtkCePTiQ3TT//Txx30CAiFDkHqp4o6mOzVaYu8KVJONOGJMalFzbgu/Jy25Sff0koB+vEMCNX06b89x1bmGhIWWhgkOZMwDTwv1ffdUqk8dxeek/k6pDB4oUP8kg4GxOvjZBXQo+ldUfa5boCRsfySc=
Received: from MN2PR11MB3678.namprd11.prod.outlook.com (20.178.252.94) by
 MN2PR11MB4271.namprd11.prod.outlook.com (52.135.36.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 21:03:27 +0000
Received: from MN2PR11MB3678.namprd11.prod.outlook.com
 ([fe80::b98c:209e:ba2c:e682]) by MN2PR11MB3678.namprd11.prod.outlook.com
 ([fe80::b98c:209e:ba2c:e682%5]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 21:03:27 +0000
From:   <Tristram.Ha@microchip.com>
To:     <Razvan.Stefanescu@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Razvan.Stefanescu@microchip.com>, <Woojung.Huh@microchip.com>,
        <vivien.didelot@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>
Subject: RE: [PATCH 4/4] net: dsa: microchip: avoid hard-codded port count
Thread-Topic: [PATCH 4/4] net: dsa: microchip: avoid hard-codded port count
Thread-Index: AQHVXLpYAiqtkBHu40WEfk7DWY00bqcPeo1g
Date:   Tue, 27 Aug 2019 21:03:27 +0000
Message-ID: <MN2PR11MB3678CF331310105FA5916A56ECA00@MN2PR11MB3678.namprd11.prod.outlook.com>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
 <20190827093110.14957-5-razvan.stefanescu@microchip.com>
In-Reply-To: <20190827093110.14957-5-razvan.stefanescu@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.46.67.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41ee7c34-dac7-4e8d-0cee-08d72b3201f4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR11MB4271;
x-ms-traffictypediagnostic: MN2PR11MB4271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4271442E3B080B3D7DD6F3D2ECA00@MN2PR11MB4271.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(396003)(136003)(366004)(189003)(199004)(71200400001)(4326008)(6116002)(3846002)(14454004)(25786009)(71190400001)(102836004)(5660300002)(74316002)(305945005)(6506007)(6862004)(11346002)(99286004)(9686003)(446003)(7736002)(52536014)(7696005)(76176011)(66066001)(14444005)(86362001)(55016002)(26005)(6436002)(33656002)(53936002)(316002)(6636002)(478600001)(81166006)(54906003)(256004)(486006)(66946007)(66556008)(476003)(64756008)(66476007)(76116006)(229853002)(2906002)(8936002)(8676002)(186003)(6246003)(81156014)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4271;H:MN2PR11MB3678.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BB4qEVwq0wUIjvRcw0ZvyLUJJeHzzzYKqDKHjxJK38elRlF9PV9cgyBTdudJYXSCDZUIx9RYx10H+L7pvwWTHouqGdjgIJjlfAcC5qv+l0BlZNyGUjjKi3JJQX07gzJOMPuaUKgDyEjU0z8Mm/ZK9ZWcK95ySkModi+rw+mSo3o7GJ6FpNk0Qg45BpLLZrUPaq0YwggA6jDF5cWMsYbgwQSeShC2Fehv8hnOBsXRawb8HU/LvRhd2rHfq35rAeGMkdTbrnjHscAtbyVTiobK/JG+wCEx1pp0iJMFbiMMGn4HTeDGcx5voR/b3FnpSRYsALhmGkwbdPj6qagNn59zcqcXOVtjUnNL6t0RHle0Ty7HB4IYKx/vs1ThlPU8+pxIXBemS5ROeuc3KiQmOyUTtCAAtEfkZJn31789Co6ZwZY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ee7c34-dac7-4e8d-0cee-08d72b3201f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 21:03:27.5905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EZ/TbV/i6YZfY+ZV8LQBhMHlE1w7qgPc5gNCBAe47gpT0Q/+w/ZVe0jCooE6nWvKZNKJlZdYUUzFzLqbCE0ZsPEsxB2+T5NNb9LorW9m1eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4271
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH 4/4] net: dsa: microchip: avoid hard-codded port count
>=20
> Use port_cnt value to disable interrupts on switch reset.
>=20
> Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/microchip/ksz9477.c
> b/drivers/net/dsa/microchip/ksz9477.c
> index 187be42de5f1..54fc05595d48 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -213,7 +213,7 @@ static int ksz9477_reset_switch(struct ksz_device
> *dev)
>=20
>  	/* disable interrupts */
>  	ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> -	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
> +	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->port_cnt);
>  	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
>=20
>  	/* set broadcast storm protection 10% rate */

The register value is a portmap, so using port_cnt may be wrong.

The chip is a 7-port switch.  There is a 6-port variant, but it is okay to =
write 0x7F.

There is also a 3-port variant which uses a different design.  It is a bit =
of stretch to use 0x7F on it.

It is more a code readability or correctness than incorrect hardware operat=
ion.

