Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700781A49EC
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 20:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDJSl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 14:41:27 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:53706 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 14:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586544088; x=1618080088;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kbq/J+BpUiojh1IGM7bu/et6WJjobJGXRTGoZdB0yU4=;
  b=NEeEMV4CboOcxH0payUKPSh9VKH159dgtmsR5OCq9rfzlWqCB54bR7kB
   7CbhuAR+bT1Z8fKCLxuJ8p7HsSRmw24hU/VwgiJvVF9eQcr4TRvOS1rQO
   5sAf7r6Ir+MzqdciP45Wtrt5XwCNKzsDFeXuFPGWXypIoqWxXEhWh7ov5
   G7kYEJwLfdMkt5dhC1qhplzJK/A9NkYCsT+Y3c4lyJGYomBKedSE5yiS9
   sPQ67JMl0pZoO3wcMNrpSOnio77ktONhBy3MSKz7r3srDCUfsAvsAmiKR
   zhIZOjUrTvUV6jowcnzsD4O0RLJ/9Z6LmTiC9BTW1LcnwU2Fhwk+uHmF+
   w==;
IronPort-SDR: LrjoOXD+XlTNXYX6yoLJID3L1UGLIgu30ev8HzyAlyjqIXbh7obmIDR+iDYwVXB3UYNTKRVFB7
 5XgkSY0X/6o+O6ssgnP1x4n45uGVpGIrAFgGrpfqnWhBNKSiOI/u3aFG/sI6FsvGjwrpb+GPH0
 EdVMsv2QyI6L6cY0eqwkvFSYij3UtXw+85IsCK0KvcN1gpP+1XDBDKkfF2+ga7wF+qfF15BRrR
 qMYdmLOgk4s9JPUxFi6Qa8A01vHZ8S/Bb2URUpR5XZSiTCFqxjHQyR7XlAuRujaw/F5i7+1RF+
 cM4=
X-IronPort-AV: E=Sophos;i="5.72,367,1580799600"; 
   d="scan'208";a="72116543"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Apr 2020 11:41:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Apr 2020 11:41:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 10 Apr 2020 11:41:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUE2HGeUQevlg0ZRF9a4L3LxyNCSlGEekrrzatAb2+zHJa/hj7GXLb7muCtpclHjsDOxZAt1VnWzBfPlZmAnZCP+JBNGabpnAFxxWOAUkG8A3Zp/AhUTpbPi2QP0ZFkT/3JDfyKe+rwM2WSz0xr6K/gKy++cEhNSMvyLX250jbVMHTFk64MHd6/z8FwmeZ8LjkT9Xfuo8wqZ32r8F+x0Q0eHwuxe4xRlL/w9foNB7D+lau3D+M+jW116/K5F2GJee+rU54GYYo758cdZXBmFKb3HTGpJXh/al46aJ+IMPPbNS8IZBBUYAlt6lZuLikkqEMSrm13mzNLM1sZstL5viA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP8vzO+frzk5gl7ZkT+cJJ+lTTihSJUmd2QwktbJ+s4=;
 b=OXk8GbnYc72/c4Bdf8lQZloIhN9Xlij645gtg1avKmRk62sW9SLN71rIcoN6VqqXiJ9ETj7e3CqLAWc4eG/qeq9+qzicr9iojvBm3gUzAIbWuo1KGWmSXNMHPm8e/xjfgz17wwtgCcTklI1NCKtGb63b/wGc5CrP8MW3pAMHxqrcALlQEzoYosgjGV0e0knDWJb6fUP47W4SEqPE6UXMyiOE3feTE8B9Zk2miilb1p8rBpPdyKIxV49daCrJyQr8jB4Gn5mJntCn2e/0Yw3u/rFHWuqSgbGQxzL2fOf29B60F18yM1FaSiNdduuuRIbdRsRfptxtDGoreqSeLAyR0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP8vzO+frzk5gl7ZkT+cJJ+lTTihSJUmd2QwktbJ+s4=;
 b=lXpRnHX4ZPfv2GdGZkY56IheBI6tAVEShzfeqElsYPkbAVOXFOVTaxbgwVO5MKkX319flY8f4u4jNSOLoM5+S/aZ785DsjKE5X/XAJE140ULtjqFwOAO5uX7qMuMsvwv+4ITLUlNuDhfGpgTZB3mXf4QW6IkN/rk+LDlAnfehBo=
Received: from BL0PR11MB2897.namprd11.prod.outlook.com (2603:10b6:208:75::24)
 by BL0PR11MB3265.namprd11.prod.outlook.com (2603:10b6:208:6a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.18; Fri, 10 Apr
 2020 18:41:24 +0000
Received: from BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92]) by BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92%5]) with mapi id 15.20.2878.023; Fri, 10 Apr 2020
 18:41:24 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <kuba@kernel.org>, <atsushi.nemoto@sord.co.jp>
CC:     <netdev@vger.kernel.org>, <tomonori.sakita@sord.co.jp>
Subject: RE: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
Thread-Topic: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
Thread-Index: AQHWDuZyx+Bnj2Vff0qt49ZkCcQUDKhypewAgAALTAA=
Date:   Fri, 10 Apr 2020 18:41:24 +0000
Message-ID: <BL0PR11MB28970553683592F839743CC28EDE0@BL0PR11MB2897.namprd11.prod.outlook.com>
References: <20200410.121616.105939195660818175.atsushi.nemoto@sord.co.jp>
 <20200410110004.04a095ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200410110004.04a095ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Yuiko.Oshino@microchip.com; 
x-originating-ip: [71.125.3.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 022db3b9-bbee-4808-6141-08d7dd7ec5af
x-ms-traffictypediagnostic: BL0PR11MB3265:
x-microsoft-antispam-prvs: <BL0PR11MB3265D5C70524992F159A7C9A8EDE0@BL0PR11MB3265.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:289;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2897.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(346002)(396003)(366004)(376002)(39860400002)(136003)(478600001)(71200400001)(33656002)(26005)(8676002)(81156014)(5660300002)(86362001)(54906003)(110136005)(7696005)(66446008)(66556008)(66476007)(64756008)(2906002)(6506007)(55016002)(66946007)(4326008)(186003)(8936002)(316002)(52536014)(9686003)(76116006);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Kc+K91BcygkczJceXqv7j0w/vqGAdtfyXR6xnu8ASorfnGr6YPa1bpPfBpk7tCbgcO2A5HEnzI3ZLGngi/gtBSfecjNON+jQsT77fhUTZKAcCxp/+wp5tfDzeZbiQIDXn8gSesklzwQ+3JRiVLHlGzGkwRzNA4hz9YIWFMo4u6RMqXnygfMufLhYS5H+kPR6ICUZeRMZruPIHzmjRvpG4tLCV7g0L+JUmbMwuIPfSYSDYer/RnpC51luaEuL+pSQaU0Mtn62vnRz5aETACA2VG7XeB/0cdSj5AguUToKqlY5lasfzErSw3Yru0TovYVVZLxzdm3e/dpTTqMRWwA9BhA0SLJkkVVyXAEbjq4pLmaJKos9BzgP5/MQKfNW1LGQc+yS603bDxSJQUBth1GBfn4+dEwRKn44H1kS+tit9MXgG0D8i/GGGjd+FUVcg6a
x-ms-exchange-antispam-messagedata: KG5YdUHwr0ehX6lh4tYYicH4+nriyJEwY/468ecku1gik8QICVoZ8zAOTQLpMZ8qt7Whd4JGpVP9Ve3cHoD4X6JYfhEcAPaAPYkUueiv8iNr4g8yCgAU9meA8zXSXFA8c+vBy9x2eU/vO54MvAT+yQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 022db3b9-bbee-4808-6141-08d7dd7ec5af
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 18:41:24.6840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NnwyxSF9Xf/BIyqyQ4vq6RSEPjPU2bFQmOA8I5qWx5izrHFxDj1uimMa7Hsk7rsjDApkzlmLoMotrFmA8ohhmFgxaJf4dRcnk33j09EOI+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3265
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, April 10, 2020 2:00 PM
>To: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
>Cc: netdev@vger.kernel.org; Yuiko Oshino - C18177
><Yuiko.Oshino@microchip.com>; tomonori.sakita@sord.co.jp
>Subject: Re: [PATCH] net: phy: micrel: use genphy_read_status for KSZ9131
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Fri, 10 Apr 2020 12:16:16 +0900 (JST) Atsushi Nemoto wrote:
>> KSZ9131 will not work with some switches due to workaround for KSZ9031
>> introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
>> ("net/phy: micrel: Add workaround for bad autoneg").
>> Use genphy_read_status instead of dedicated ksz9031_read_status.
>
>That commit older than support for KSZ9131 itself, right?
>If so we should blame this one:
>
>Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial driv=
er")
>
>Yuiko, does this change look good to you?

Let me check with my team and get back to you.
- Yuiko
>
>> Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
>> ---
>>  drivers/net/phy/micrel.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
>> 05d20343b816..3a4d83fa52dc 100644
>> --- a/drivers/net/phy/micrel.c
>> +++ b/drivers/net/phy/micrel.c
>> @@ -1204,7 +1204,7 @@ static struct phy_driver ksphy_driver[] =3D {
>>       .driver_data    =3D &ksz9021_type,
>>       .probe          =3D kszphy_probe,
>>       .config_init    =3D ksz9131_config_init,
>> -     .read_status    =3D ksz9031_read_status,
>> +     .read_status    =3D genphy_read_status,
>>       .ack_interrupt  =3D kszphy_ack_interrupt,
>>       .config_intr    =3D kszphy_config_intr,
>>       .get_sset_count =3D kszphy_get_sset_count,

