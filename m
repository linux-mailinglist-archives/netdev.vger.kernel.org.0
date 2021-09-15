Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6B240C0B5
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhIOHqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:46:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54173 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhIOHqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631691885; x=1663227885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p3LfOMh6kfq1XPNjcaMYwLewbPEYeD3C0h+hrPafoUs=;
  b=DNGfe6iVg1CbMbObKwkmxJUKtaPrbppcbYWGkiD+GEeQZ0tk/oIWIFE+
   6ipvssULUKHXFCuipvQevk9fE1WD0qbcXaZnu2xQNi2WPc9yeCZwUk4wQ
   HURMocp2zEeym+BAyyJB9I3/pgYFP1aYpRtUQV6y5Rti07KJY2qAmJdNs
   dxCxj/wowGoKxbvVmOn18rDy5301vRB7HECtUyUkitinQYYEpbAStH5mm
   0dShwxb/6jtHi0+4ERcVuH6wVF1sejIY3X7u4/MQ6UxNbsksjxrPlOGlv
   aXznyhxMJUEp8fEEOiigjl9M9BFn5E2lBM+ZeUKP8Is8PPs1bPNnYSs5D
   A==;
IronPort-SDR: 17mrLjq1Uze7zbpCKpR6oeP8iKt48C1xEExJOX+6in48eZ0LNNSoA51Z/f2qsuD2b9DUWTohkB
 r0qRnq1WgXOd05muYvUyt0fQWP8mde/VEnokN04LB6zTpp0G2zu9dpOVaxZCTKd9J8EshBSJRc
 A/u9C3AhNZ9EDkhhWGlwyLdkzQSApUGu2bWrSI14Q11WjFCy+waog/ML6yZ32xJBYIFUjG7W4e
 Nd2AtWBhgn+zHA6blbocfAdtzH+iwpQJK1IA8xpRKRDR/vENTZsLfpxsa4iq1q5Hh2sOzK8aZc
 FZp/xG+8HMwRYrEsUv11aF/p
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136599700"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2021 00:44:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 15 Sep 2021 00:44:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 15 Sep 2021 00:44:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mf1RK591tY/qpq3qPNC+GdqGanfYVPFw+emy+z6fKajrgLU+CK8uWKKcJj0zzXIi6asITXDODBqSdwZ55ZHRuq2g5hPbfHmJNofMQHueh3koM4QY07+zw12n8TvlJcR3KmuoN8qg4Ap7ReSryfktxBufu/oVTatMJ1GM+8AoIYA8BJYcU28MUhSpEQb4MIL78v7aQQWfCm5VjcID/RmveK7qqiR87pqE5VwNo0KvOOcX9/TB64bFyDr7vXmKoNHK1yEjPG7WpUL5wmR1dS6REPXfU2+cUdyhf9Chpjghc8sITSskJo31dWDUjP+ImC4eV1p2tuGrLuswBNSIZy+I+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qd4TlSnWZZwZAUgi6pvYkT7sSscDANe1soS7IgLtfDw=;
 b=Ke5AdgNvoRSDHqxs7WseEzMS6GDB82g81NIovAhkd95dXmmyra9uvsT1qyD+c3eTfLxIlTzlCGOwrTc9sPShigCv3wTSb8sn+k1iM6VfpKyzD7HQ4q/ZD2iq7p9d8yEa1hBCvd8CtsO8b+0+DolLi7c/b1hgyno7TB7VivkNRzu5YMlRgNMDGAz1oBa1JtqTdDOg4rLeIrhJSACOiO3oHEjF2Hjauvny53QZGq6h0CAFXuRlogbNakJt7fq4iSyP6rjtj/xTrDzlYVJy7gqRKaF5XG1sllcTVa6pmXRA7v52A9Qk9zZLyyCK+hOeNtGiEbUlSbPfEKQ8I5g1tAmvfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd4TlSnWZZwZAUgi6pvYkT7sSscDANe1soS7IgLtfDw=;
 b=bEK5mODaA13eTGjp0MUX7pH42lk4J3O26+7tloDTYBfuf/kpbeDaAgKXm73mz8x2PneXbI7d0Srxadi7MGZk+lsCOansP7WH2vMeOhJ6VNl5CmAYdemRL7iYbASIsElYSGMbOpaoR0H5AYEgPBD1gEe8+61saUpzKU8qN5DjEwI=
Received: from CH0PR11MB5523.namprd11.prod.outlook.com (2603:10b6:610:d6::15)
 by CH0PR11MB5459.namprd11.prod.outlook.com (2603:10b6:610:d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 07:44:43 +0000
Received: from CH0PR11MB5523.namprd11.prod.outlook.com
 ([fe80::8857:c39a:75e0:43df]) by CH0PR11MB5523.namprd11.prod.outlook.com
 ([fe80::8857:c39a:75e0:43df%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 07:44:43 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] net: macb: align for OSSMODE offset
Thread-Topic: [PATCH 2/3] net: macb: align for OSSMODE offset
Thread-Index: AQHXqgWL2qBFbDxWL0uL4iC5PRtGcQ==
Date:   Wed, 15 Sep 2021 07:44:43 +0000
Message-ID: <f70f89b4-008f-6393-7069-f408df7733ea@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
 <20210915064721.5530-3-claudiu.beznea@microchip.com>
In-Reply-To: <20210915064721.5530-3-claudiu.beznea@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95500ca3-8795-4fb4-7bac-08d9781cae7d
x-ms-traffictypediagnostic: CH0PR11MB5459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB5459A9D16D87CB7EECED8E31E0DB9@CH0PR11MB5459.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sY/oCIH1/b3LvWQCvR3XsxRlIfjAqiwahmFcM5J5pLOTyzCUaAazBOJKKH1NKT32qyK4miVLssjOQQ2SI4UZ05Sha6SLBcLtpsqhSxVZc+BSmnGKbHP4GhKE9FyDEnK2SIhD1pvdoBu0WvXzoFWY3te9vlhNOzyXPqgNiJ2HKrJZ90ud54S0fkTUBErTQoGzi0axnsqcWDRUp4OUDVegK/pXAsaORkd6ZJKU/rGcDY2HJjhiptcbnzCqpVMgg28vvd6H6+v1TH+T/QU4kxlp2BMNz6lSHo0E/sDWvgAXwWFAxFPV2YYmzvdBBgUZMoG7W7N8t1gEwGdq/4dPBZyhWjZtFXYh3oWMzSv9CFLDKFtRKgZWmKLyT/BVlJSLoMrTJqtsg+j9o3BxYaU67weenVYC793hMLYTPzuPW2T8Q6b71DQ/lwK4ktotiXlpMY/RsGSpRJI/dEJ3MTqkiFAYl9Hqpy+psCdRHnzJOlqhXFCGoQ6yAmGFf/9ZxAEvcIh4DHXEQuAmXyB/j+rcbG9Mb2p283/uh9Tjsd5rtBdFbiBPxk1Eh0TEyGUDkLt5Wmg5KXp8Sl0zlh288TYhC5B/iIIS+YH/49tw60FeOfPlppTRTyw/9wZiHsGdJ+/QParMj+CYrjy+3+HIrY+f37ZFR0e2u5iRtCpR96Du1mUdVg6jQMp8R7HeqGcxhXXYY6e/jXrpBEeb3jn4G1jhPpxPxNzK2eDNytYbSfKuy340q1APZVvJ9XK1mJv7l1rsVplizYUjIQkK3pts8F3d7Wnpdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(366004)(346002)(76116006)(66446008)(4744005)(6512007)(66476007)(64756008)(66556008)(5660300002)(186003)(53546011)(6506007)(91956017)(66946007)(71200400001)(8936002)(8676002)(83380400001)(2906002)(38100700002)(478600001)(54906003)(316002)(31696002)(31686004)(86362001)(38070700005)(110136005)(2616005)(36756003)(6486002)(122000001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?XavQKMoAlI97K90fduxKANLIhkwiAvWeA6gch6PHkMHVDLUyK0SgcYPk?=
 =?Windows-1252?Q?u3O4/3HzKWZGl7IAZEljN51VyDqhvS+T0iQeTsAHZ+/7mee8ZpFBo1pZ?=
 =?Windows-1252?Q?MtjEAIEx16jxUmRhlU7jE0F2siUQ9AcIf+OLr5NS4BHlNNePiM0BXkeA?=
 =?Windows-1252?Q?Y36tEDCeX8AFeZjFK3GXtSioKoBpMrrVJh+2FBlSGB9qIcs5oRGRrq9t?=
 =?Windows-1252?Q?dLEt35w2Q+8dtgn4rn+kRbtcZyBrHzgnHaA8Q6dBSovif7GidtdBtnEk?=
 =?Windows-1252?Q?QbVNHPKnKUGdwoXgTgl3jfPQaWL7xiNRl6ZiraouVvA+S8c8FC7HkaSz?=
 =?Windows-1252?Q?b3tJV9ajdrUC7yAYhs4/FWmEqYMxnAshkhwnOTfc3GgyXIWa1HSc3FSy?=
 =?Windows-1252?Q?x/Df1V83rs20J1xGMpzOnD9XxieKRGTqtsX4Lv9FaIrESzIydxPzSp9l?=
 =?Windows-1252?Q?FnSkuRQ+mJ/O3sMCuF0XrR9nu5Xt9XxwnyVRydh7Zv/mTx7XayrwZUhC?=
 =?Windows-1252?Q?3vxMbLj/8iLfrMIqfRXoNxAuBGToFHJ93LmvR5skL6o47iin0TFRpGol?=
 =?Windows-1252?Q?VxhmHYnvaSY9W6UjQECTEIXMcQq3oyGM/8J1bKUT3sr/E9ltHCJrj9TZ?=
 =?Windows-1252?Q?MiM4QZ3v04OFUl5w9ap+aulN3gQdM3JJg3pkMxSAR0xrvxk8NwNQpLZl?=
 =?Windows-1252?Q?Nd7TQFzp7dG7/TvWMYaH27MzjUUes+PRXpx8Uglo0WWJtzx+WSXB5syP?=
 =?Windows-1252?Q?iUNku3C+Z3iw096iXbTd7Xldg7KqU+EQOqfzKM2Jop0KvHHkWt4UOpqt?=
 =?Windows-1252?Q?PWJh7T2uWnmxgop78xqWuG0kJLypON0ZlUNbXrpC5iGkrUH6CGXjWgvs?=
 =?Windows-1252?Q?EpHV6CSK2iQewoC09GXokgrLs7daJ4zInGA+9DSjVCpt/1o0xEbxEc1v?=
 =?Windows-1252?Q?mkKZkmubmpSeDI52ecRuftrlvggIDFpYxxZJe0OQkb9Wf/waF3AQV4xp?=
 =?Windows-1252?Q?UKwMCrIfo/nC04AOdatD68l3YhxrW1rUxqrykziuSDuJMHtgGmVmNNlb?=
 =?Windows-1252?Q?ahgmNi3yuiFlSdvi31LdWHK03VNuxsBm5mqFBUerxB5u0jjBZi/A+lTM?=
 =?Windows-1252?Q?ZJ1I9bhxQM6Fb6Q+lBZfBbeuX9+oIksZkJst2RT4ZE1pZjF5xUjQrvHe?=
 =?Windows-1252?Q?8OWhxvaB/njsxtGm17S2vGRPnK0jpNFPavL/9nWkj4GXA+A+P3ARMUZb?=
 =?Windows-1252?Q?GvQ1icWhJQ525YSYpCtob9+JWQ9Ssho3mapY4VxMUt0KvtfA4gXe/o5L?=
 =?Windows-1252?Q?ShOcOU3RquToOktdaRGc2286YADl+Dqf8twxYYlfR7qjcuRJ9K8mZF+q?=
 =?Windows-1252?Q?zbterp4XMgoCcKlqhosN9d5cASEIJbgot/OcRapPVqpOR1dhZVcIg5LI?=
 =?Windows-1252?Q?8/sDIqiZcccl46MBvNxb0UbpsA2PFeJgY4x+4l64OyI9xQiAMKfFL8tk?=
 =?Windows-1252?Q?nZuJN7Tc?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <617E15356FA8AE4FBAC3F10A7886555A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95500ca3-8795-4fb4-7bac-08d9781cae7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 07:44:43.0417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wIRVPq49qSY+JElevo2sEysz/bIbIXraBp5KbvBfhdmYkdY2LYtsgnWSb0I+fGAtOLTiB9bejXQfa+sZjaVrIrliRpeKMe2TFBhDuXtxbc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2021 at 08:47, Claudiu Beznea wrote:
> Align for OSSMODE offset.
>=20
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
>   drivers/net/ethernet/cadence/macb.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/c=
adence/macb.h
> index d1e0e116b976..c33e98bfa5e8 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -244,7 +244,7 @@
>   #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
>   #define MACB_TZQ_SIZE		1
>   #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
> -#define MACB_OSSMODE_OFFSET 24 /* Enable One Step Synchro Mode */
> +#define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
>   #define MACB_OSSMODE_SIZE	1
>  =20
>   /* Bitfields in NCFGR */
>=20


--=20
Nicolas Ferre
