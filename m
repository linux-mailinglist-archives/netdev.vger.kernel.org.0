Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBCD197D9A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgC3NzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:55:12 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:31218 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgC3NzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:55:12 -0400
IronPort-SDR: uREHEc11EdBF5CDa+Goysr+ZWbbrygXLIYigb3XsruiVlCaaLh0BCI4DKOMyERLb7WH2MHFqoZ
 kttzhKkRxwS5C49t8UCKfhm2NTywhJGWY5El9U4F6uH6tX2n9I0iVsjuGhsqhGP7ucByHz2UaX
 QB8fpbxblndb8Bt0IH6yEJtFbHvE1xdbVOSn6rXKNfkjQy8LMEtCjdOIfYc+57JKE4HdOg7Ga5
 g2RTGZqFBer1se5+Bi6JLcf7B8VAhXyE8cX7sQogVBgFMGYl9qTA9Fu1FxGAVVKP1hU/rimbPh
 ngI=
X-IronPort-AV: E=Sophos;i="5.72,324,1580799600"; 
   d="scan'208";a="70640373"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Mar 2020 06:55:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Mar 2020 06:55:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Mar 2020 06:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJm0MqIJmVFd2KU6L1WG+EP1eNArEGs23JOa4aS++6SnIFHuT2vZhiC5Ln91V47OfYGlIIhCCItN4GQ+Ifut3XtCo2Mr6iqRkg4A0Calx1HzEaBJ6hfafMdvgPBdsrQFHJmvzH80EwHclmVGrtzdtZwOENA7TZPrb3+KmOZbjKU23T85pjLGDJmIdx8vT6QkCJGs7rIgnUASHM+vGWnHVyUrBd9EbLgHT1skVJgcRkcH/cSepYFreTnf6h7jX0vxayl7jpbgyzNyXrLnc7FY5p4Fn72nFBPWit5ZeKSrDd2mifG9ncAdFFdSb8GTRoLHgsXbcWDsdBgR1mWuTZcsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGCgGlBsToYe9QUj2LhqBfFciqXPDDXl7Yhib5r5gyk=;
 b=C6J9BLGhu8NzjdtrwUANIyRoCsCj8675KSFziof31Ble+84Nzz+ai9WUOfyYMx2MiY9/PZGnTMG9sOVs2vL1SGm2x8oXxzmx/djA/OsTFiFc/uSHgePj7XPLHNhl443DdWrIlokXpbXODrOvMLwSTcPIaaRc1dOK4pOZXysWEwaEQPg57BNItE+d7UdME//AHL8QmET4dsnvKZrtWMPU8ziMVE/9d/HWP+7LQ5EpwKxcUAOiFSguUEmoipnKNTk1Rl6qdnD3NzYfxxln1pDR+xewmTcitCGQVSyxwOM9daAOFX9A0Ww/OE74D6ienbEG2tPjHfkpL6aslhVCktNzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGCgGlBsToYe9QUj2LhqBfFciqXPDDXl7Yhib5r5gyk=;
 b=ICBHpTBo2Ie5F8jPr5YkALN0Adqz6jerI2ljv35JJsAPeYO63dEnlc/vRScCdeNWsOgxTD+BHEb8iLdnLTWT0vQteFR5E5bwramYOMLbuxzaIAl1l8Td1UEYI6mbyXYoLdo9CgphcivqjOH3Dagc7kSj3TnoHNxzcA16EW3tzrU=
Received: from BL0PR11MB2897.namprd11.prod.outlook.com (2603:10b6:208:75::24)
 by BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Mon, 30 Mar
 2020 13:55:09 +0000
Received: from BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92]) by BL0PR11MB2897.namprd11.prod.outlook.com
 ([fe80::c9f4:7b2a:b008:8f92%5]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 13:55:09 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <davem@davemloft.net>
CC:     <davem@devemloft.net>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: microchip_t1: add lan87xx_phy_init to
 initialize the lan87xx phy.
Thread-Topic: [PATCH net] net: phy: microchip_t1: add lan87xx_phy_init to
 initialize the lan87xx phy.
Thread-Index: AQHV/JC3dchxL2NlOUy2oCNY8BvSQahT9keAgA1DofA=
Date:   Mon, 30 Mar 2020 13:55:09 +0000
Message-ID: <BL0PR11MB28976D2B5BB9A7CCCE5C99608ECB0@BL0PR11MB2897.namprd11.prod.outlook.com>
References: <1584472118-7193-1-git-send-email-yuiko.oshino@microchip.com>
 <20200321.201223.902296361952119725.davem@davemloft.net>
In-Reply-To: <20200321.201223.902296361952119725.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Yuiko.Oshino@microchip.com; 
x-originating-ip: [71.125.3.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b8ce4b9-6ef8-4143-1372-08d7d4b1f5ae
x-ms-traffictypediagnostic: BL0PR11MB2995:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB2995F3A91B2EB84CFA0C3ED98ECB0@BL0PR11MB2995.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2897.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(346002)(396003)(376002)(39860400002)(366004)(26005)(6506007)(478600001)(6916009)(54906003)(66446008)(66946007)(316002)(76116006)(64756008)(33656002)(66556008)(5660300002)(4326008)(66476007)(52536014)(186003)(8676002)(9686003)(81156014)(81166006)(71200400001)(8936002)(2906002)(86362001)(7696005)(55016002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6KfsvQXGGXELixp4rLqZClB2Myaz9AVOZSenKm1OUZiIb9DJUsVaErITCw4CTKuTJaJj4VOeJ1ywoc0CjncTyTN0wQ61Aw8iTuy8ptryw57AuaV9gPWPVc7Be/p05UuaG7JoVl/aGbRgw+R1DNrAShoOhOqliESEQhsTNlQoKZYBCNt+F0Sjkb1LMdezfadCHu3SfBJem+XscIkxB3N0wpQsyDdnsTJbtPJkPTwlwIGk1qAgiQZf9c6dHwWMnVGWzwJoxH2F1NDnXBCGBfzounFLh0r4M89dr6O7j1HGti4gRnKDj+5O1sx7xldTZskMwpDSbUlmCk+D9fGN9L+f4mBSUuylxS1mAdmwa7yhxNuJ5oHYmhDaUSXiwrsFsnEJanhEC5ZHYcnXzXDKBLGiqHiqY3eGxNEWP2V99UthPdjVMcS4doKmh9Ka5+iCg8SJ
x-ms-exchange-antispam-messagedata: Pw2vnpruoTaSHwlEMctrfzNTEbDDlOheamb1ppb7Z/NZmNO3Xg3TlZ4m/aZj7CM0Jgq+lCEUMUAQu7ru1D1DOqlGQyrasJce8Ia7n2j9Xyhhk02AclG9MzDkw1xMYsdtNa/iXlyzoxhRYVjboZ4Ucw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8ce4b9-6ef8-4143-1372-08d7d4b1f5ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 13:55:09.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iwG693MJLqlQ1heVLxjniPFw1yGBRewh1XbYs1nTJ7roX+oFIrsdKkqFVOVl6aVQYq12+LsGnGQxzBpsXVgbKrgvd97a9y1SpeJDqi2L2Zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2995
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: David Miller <davem@davemloft.net>
>Sent: Saturday, March 21, 2020 11:12 PM

>
>From: Yuiko Oshino <yuiko.oshino@microchip.com>
>Date: Tue, 17 Mar 2020 15:08:38 -0400
>
>> lan87xx_phy_init() initializes the lan87xx phy.
>>
>> fixes: 3e50d2da5850 ("Add driver for Microchip LAN87XX T1 PHYs")
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>
>"Fixes: " should be capitalized.
>
>You commit message is way too terse.
>
>> +     static const struct access_ereg_val init[] =3D {
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE, 0x0B,
>0x000A},
>> +             {PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC, 0x8, 0},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x8, 0},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x10,
>0x0009},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x17, 0},
>> +             /* TC10 Config */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20,
>0x0023},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_PCS, 0x20,
>0x3C3C},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x21,
>0x274F},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20,
>0x80A7},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x24,
>0x9110},
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20,
>0x0087},
>> +             /* HW Init */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A,
>0x0300},
>> +     };
>
>What do these registers do, and what do the values programmed into them do=
?
>
>If you don't know, how can you know if this code is correct?
>
>You must document this as much as possible.
>
>Thank you.

Hi David,
Thank you for your comments.
I will improve and submit v1.
The initialization scripts also will be changed as our hardware engineers u=
pdated them.

Thank you.
Yuiko

