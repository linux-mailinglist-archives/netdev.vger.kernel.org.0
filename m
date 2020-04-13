Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379421A66EB
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgDMN0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:26:16 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19594 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729811AbgDMN0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 09:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586784374; x=1618320374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WJJRzbETTjmzkW/RV14ckIICND5rcuwxwLd3c/APox0=;
  b=ej0pmRYhjVfs4VIdPdzaesc0STEI8sdsIP4FNhsnFYQo76BQQWRKm57c
   iiyXZabVgyzE6CdicHdfsB9i+U/pHJ5n9ERsVw/E1TtdGDOHPfDFTF5MG
   DEQJQsoV5ihiQDTxi3pD6BXY4IQhVUGDpSwB45KX+pPZ+6bOrKwTOcLks
   9IDbivzLoF1ZBguj6kq2h/3uhWeikcLBrCuY+nWYPQJFW5kNznh5nOk0a
   AQ9p49RheW5lbIaTgNpjgR+SM4b766PSkXh4gJRvpwyNHEfsHHGpF5pH/
   W56quPn2ivUBRZhGeTrsMZBArenZCSULHYY2YfEOpjBg8FKKi4QtxTzGR
   Q==;
IronPort-SDR: fcGj5swzZfk8JH1wZ/TiHOpHssklRFbr1OLOiyeIcVzJYRXIpQWLZJvE8MPUAepa9JT1drRPim
 CGv8dXpuYCdXwEHgZpov5nYAca5ZSVMyeM4Jdy5RGJkmZh9g9EE97AeyKKQ5k/7ny48+BZjF6Q
 7IAZuDNGudDdlF+iPxDnM22uEe0M6tD3zHSiYJJnmnBI+xUsGmyVAgKzHTploxK5pjhJyWI7y8
 JnUZvZiN+Xaqz5JCMVWOyuGsKwjVL5rnmNpDO0SW2sNiPz5sVQBb20mFbiRf2RYf+aJmeiDOBH
 HhM=
X-IronPort-AV: E=Sophos;i="5.72,378,1580799600"; 
   d="scan'208";a="70145318"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2020 06:26:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Apr 2020 06:26:02 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Apr 2020 06:26:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2w6JGx/FbI8gIHYQYfG/znHAqgnpJMoMJApwX2L+3UsEwFFpwziuq05TagvDHfJFNB4Ot7rr6aBS2I6Yw/+QBluttsKtMBOSwTSGYj6pGb5dIjf9aFPfq+0FEXwcD5kfk1DJEPu6hxAiN4aVAilGCJupdW5lp9GpuRAoCnFof5qNUqrUjFNc1LX+ah5KgNnWqhlRRiCfxNHRHiB3ZXqy8UjWnbigVhjUtkxTcP/39+Q4PwQ8HeM1NHmUSqkR3Vw3Wktkq8XEegQZpP+gSDe66ltve+0BZChyiNGLK76zU+Ab314PK7XVFJxH9OPuOdSome/jzFBOVfpYr3H6ic3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/QuMLsKUw2Kq60iGW0+lZ8Vq2ObNVoTMPvrR8Qvgbw=;
 b=MTOResoxjdPGdQvjgH59eEEQ1A7gLOHltvABdpiyJQhG/aJ/tGo9YGp/ctX/pFTjl7RKvK/q3aKyP2T4Q+nrmkIXrEKazL9F7mzYoPQEVF/3F1ExQI9AnediCBQCiNtHsZiVhEuQ3d4XItXFaVH2xdJrr9sUl8SXovXFX/S9MngDLvUU2TbicxfOjvgrC6pfz0GpuHmzSFuH0msVE8Yh4BZBAa9nmlYFlAbtKarXXR1opdpwk1cAzIBQb5xawCgz1EiznLD6xM2ewR9iiJNOOArvexBraYrXKihLY0agfag3lYS2QJ6CLXfAXsVJRm2hQF9N/7XDVJhwzce4CaCc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/QuMLsKUw2Kq60iGW0+lZ8Vq2ObNVoTMPvrR8Qvgbw=;
 b=QzSzNbIWAhXDE7mLo27Jq0VAn1T+TOLXKbSBEiJBjET6gqwpL72Oka+NyRZ3tpCxEKvvXiL5a7Q738f/hipuy0BsGgToKXTeC0iXq2N969E1HknLsI3Gf66ENdaVo+uneQvCnpc+cdtqqjO3Sa8kcldVoLoPvW4BFwL7pX48kQQ=
Received: from BL0PR11MB2897.namprd11.prod.outlook.com (2603:10b6:208:75::24)
 by BL0PR11MB3027.namprd11.prod.outlook.com (2603:10b6:208:77::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Mon, 13 Apr
 2020 13:26:11 +0000
Received: from BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92]) by BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92%5]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 13:26:11 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <kuba@kernel.org>, <atsushi.nemoto@sord.co.jp>
CC:     <netdev@vger.kernel.org>, <tomonori.sakita@sord.co.jp>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
Thread-Topic: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
Thread-Index: AQHWDuZyx+Bnj2Vff0qt49ZkCcQUDKhypewAgAALTACABF49IA==
Date:   Mon, 13 Apr 2020 13:26:11 +0000
Message-ID: <BL0PR11MB289748084689BF185D9E55208EDD0@BL0PR11MB2897.namprd11.prod.outlook.com>
References: <20200410.121616.105939195660818175.atsushi.nemoto@sord.co.jp>
 <20200410110004.04a095ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BL0PR11MB28970553683592F839743CC28EDE0@BL0PR11MB2897.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB28970553683592F839743CC28EDE0@BL0PR11MB2897.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Yuiko.Oshino@microchip.com; 
x-originating-ip: [71.125.3.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35e4cce1-2264-4ad0-9fdf-08d7dfae3be3
x-ms-traffictypediagnostic: BL0PR11MB3027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB3027A02220AF4A275045EF148EDD0@BL0PR11MB3027.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2897.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39860400002)(136003)(376002)(396003)(366004)(346002)(186003)(55016002)(9686003)(8936002)(8676002)(107886003)(81156014)(86362001)(52536014)(66476007)(33656002)(5660300002)(76116006)(64756008)(66946007)(66446008)(66556008)(316002)(478600001)(4326008)(110136005)(2906002)(7696005)(54906003)(71200400001)(6506007)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZdGUPLzPAezkFtMKFNXIbIhOtCK+55HggK6KvjO5fEu2UljTcqdVm8m+aCk57/i2ait8NVFhShLB7b9c6Yb1RlaQmRDLoFK/hVEI6ZQqZQ+ehmFTVOrxxNkp+U7Xd1gKuDEjanf9gLZVYVE8m2IPmjXjjpo8Vaa2SUP+8U4KTwL43N41II+T2ViK0hJEQSkCJzmXHVH8lCRpdd4MDLDIVMi5iA/ya+2BTGAU4wzoHnAziALn6IwZF/FFmsmhx26y0F6kRLEBbPP1VHml7L1YeKfWuGDJJry5s6GXdfk2zQSDKq8u/3Eg0VM/G2TCYuJabojpnyJqbG3D5ySnQqRBA0BvlU/8xyhQS1UgeEmXcE4tUjdrH3dHq95egh62QIikSprRLQKmOFDXHpjaO+8bAmjkOmEQmnCPflaGQFgYNJ1uJQ5j62sDvlRUG2l41hyV
x-ms-exchange-antispam-messagedata: SowGFIEMYiCXChVVWZsBLcffWVfnMPbGpaln4ZfKDvHvBLLbwjCJwu+BNJ+B3JlQeedMAA4gC7NEixm1IXJYiM07Tdteo8n86g3ii1p9FsUTXXHa33t74ilRB6VeT/c+cVJXNFTAWOJVyrtWlNwvQA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e4cce1-2264-4ad0-9fdf-08d7dfae3be3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 13:26:11.7142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cMxLtJmeS8YVyQr+qfhsBCNB5bH1/V94YPqT5KuMd9MYOYZxRpKd0n7J6G49c2ah1LuAUY8oMVjYlqh8HEp7SjK1XlbYj4qI/VhP+ee745U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Yuiko Oshino - C18177
>Sent: Friday, April 10, 2020 2:41 PM
>To: 'Jakub Kicinski' <kuba@kernel.org>; 'Atsushi Nemoto'
><atsushi.nemoto@sord.co.jp>
>Cc: 'netdev@vger.kernel.org' <netdev@vger.kernel.org>;
>'tomonori.sakita@sord.co.jp' <tomonori.sakita@sord.co.jp>
>Subject: RE: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
>
>>From: Jakub Kicinski <kuba@kernel.org>
>>Sent: Friday, April 10, 2020 2:00 PM
>>To: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
>>Cc: netdev@vger.kernel.org; Yuiko Oshino - C18177
>><Yuiko.Oshino@microchip.com>; tomonori.sakita@sord.co.jp
>>Subject: Re: [PATCH] net: phy: micrel: use genphy_read_status for
>>KSZ9131
>>
>>EXTERNAL EMAIL: Do not click links or open attachments unless you know
>>the content is safe
>>
>>On Fri, 10 Apr 2020 12:16:16 +0900 (JST) Atsushi Nemoto wrote:
>>> KSZ9131 will not work with some switches due to workaround for
>>> KSZ9031 introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
>>> ("net/phy: micrel: Add workaround for bad autoneg").
>>> Use genphy_read_status instead of dedicated ksz9031_read_status.
>>
>>That commit older than support for KSZ9131 itself, right?
>>If so we should blame this one:
>>
>>Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial
>>driver")
>>
>>Yuiko, does this change look good to you?
>
>Let me check with my team and get back to you.
>- Yuiko

Hi Jakub and Nemoto-san,

The KSZ9031 workaround is not necessary for KSZ9131.
Please apply the new patch.

Thank you.
Yuiko

>>
>>> Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
>>> ---
>>>  drivers/net/phy/micrel.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>>> index 05d20343b816..3a4d83fa52dc 100644
>>> --- a/drivers/net/phy/micrel.c
>>> +++ b/drivers/net/phy/micrel.c
>>> @@ -1204,7 +1204,7 @@ static struct phy_driver ksphy_driver[] =3D {
>>>       .driver_data    =3D &ksz9021_type,
>>>       .probe          =3D kszphy_probe,
>>>       .config_init    =3D ksz9131_config_init,
>>> -     .read_status    =3D ksz9031_read_status,
>>> +     .read_status    =3D genphy_read_status,
>>>       .ack_interrupt  =3D kszphy_ack_interrupt,
>>>       .config_intr    =3D kszphy_config_intr,
>>>       .get_sset_count =3D kszphy_get_sset_count,

