Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D024B11D8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbiBJPjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:39:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiBJPjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:39:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A86B9C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644507548; x=1676043548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5sv+jcs77+CdzilIwZdtgZYcChO2O7WAt5RdqDnUl90=;
  b=NXXsjDpJgpKZsj+FMzzdrwbKEUPIcuF6rn/0g58+MEmV07nVSJPFEtHO
   wLcldI8gEnT9FEQyByrFcxjjAgg4Jl6J+N5VFMzYILmdJ90Y8h3l0qtoU
   Ymc+uDNMWPhOtZEw5CtwVdEqp9bIX/kpuOdAPH5+MJvgyOuUVrRw5+9Ed
   Xvbqdtlz/IPmlSvjsk6gRYJqrqMLKp9tBwwGyWiD14qupo0J7ttjS3hXZ
   JxSzpdQ5nyjQcqLO5SuWhOB4f+xxOtAmSYfbYBirnaYvcZ/X+R3NgCFfA
   fW5nbXsxBNRkt/fDMidRvhIEl9EVAuAW4zQtI7uwRrHfxxNDhK3pHKYID
   A==;
IronPort-SDR: 16aYIYD6UbWMiAr069XHlgcU9WFJVRyw6YleiSnx1bOJZIMbDrnRBf+dSXWXOBpHmwjIAgZK8H
 BbA5GitwLvxCMuP+WGpe42fGcxWsll5KAkLV9a+ICOA3coj2TIQfduT+6c08ym+HpumPhfPeSG
 m3gyvSA99pEtwExWxhKFEXl2BdT/t3vluLaQhiMO4NQMSicY/JPcr52sI4k/tgJxJOnXTel7Bz
 iQbIeXDlERuu/wfs9kVdggPGnDdJPfrzRk44gI/lFNJPlyOXkYGCWuJoXhfjRyp25FjtPNMYzq
 j7jAsTQdF8HVh14+Elio2kD+
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="85317106"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2022 08:39:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 08:39:06 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 10 Feb 2022 08:39:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neH9b76pvA5Gyk4RcUWqHe9s41chEJToIViMqu0E39VwDU5yVNBcAiIuoxSk1EMnX3o1l0ELqlaljqtYhVx6Ug7WUqbCAyo8B8nJ6rWu9r3KmT9rCY3pc2OxgoFGedIFkYDwW4XmdsRwVCMJ3d4hH533+Sy9WnyD5F00DP6lXhJWLFLXQsGK1jW+CvlttsTfp3yxLdSc8gLz7mfL+G/3vtRR1erWmJwhPUNDc7//f/483N6HjC1vq/Wus3Bm+ywjNMlewpBNoBZAyAsoc6K4MNTH/LRNX8d/1dbN3ma7v4SsrAA1yQfs03iTWS+TZPvjNuYV74KpOQnQnaep/rhqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5sv+jcs77+CdzilIwZdtgZYcChO2O7WAt5RdqDnUl90=;
 b=krYdxikFrAqAme862N0cXdYY4RkoyJ4yV5ha6zWBRW931927XpUm/sNHlRh1q5XHb/bG9heZbwL2hfDTOLn1QdTtKPlJjqYEtWOssTVHhH8D76nBm1ULQdQDjRC6Rv2dGydnCbmlxjPbRg78habXwaEffGpeWOZ8U4gae2xJX2bfwDPyc449HGPGjerDyR0tCvqO/7PPAJYsIGtcA8OAv7177mMVWvN/50Trxg6gAhV2lFCZxmOCVPDxH87dyAlSyC1eGDuGj71Ly4Nwpn6bG+Sft2dlX5duysvM6wredeCxZJPTkeXTr7g+I5e59Xjcc1bQlzU0SF5v0/Fj7Q2x5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sv+jcs77+CdzilIwZdtgZYcChO2O7WAt5RdqDnUl90=;
 b=MFaviZcbrTxe+pomKcBV+MjzR6FXbmGcQ6obRdzYZ+yI7ioIoQGwB3dUrtQXM20m//ofWzYkuho0tHuARZbW6zffhTfr/A5lp0UH4jfuKk4eUXvF6gW8pzuXElP+zcyPWor2NLkUR6nT2ybGyj+QLGFvU0vhbM8TvKKNsxJFzOQ=
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SJ0PR11MB5677.namprd11.prod.outlook.com (2603:10b6:a03:37e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 15:39:00 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::b9cf:9108:ae17:5f96]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::b9cf:9108:ae17:5f96%3]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 15:39:00 +0000
From:   <Prasanna.VengateshanVaradharajan@microchip.com>
To:     <enguerrand.de-ribaucourt@savoirfairelinux.com>, <andrew@lunn.ch>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Thread-Topic: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
Thread-Index: AQHYHO267iebaZNvCk2PCKSscj7+r6yM7FiAgAACbwA=
Date:   Thu, 10 Feb 2022 15:38:59 +0000
Message-ID: <5a13e486f5eb8c15ae536bde714be873aa22aeb9.camel@microchip.com>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
         <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
         <YgGrNWeq6A7Rw3zG@lunn.ch>
         <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com>
         <YgJshWvkCQLoGuNX@lunn.ch>
         <42ea108673200b3076d1b4f8d1fcb221b42d8e32.camel@microchip.com>
In-Reply-To: <42ea108673200b3076d1b4f8d1fcb221b42d8e32.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.0-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 364a5827-1e7e-4dc1-ccc7-08d9ecab7541
x-ms-traffictypediagnostic: SJ0PR11MB5677:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB5677D1663A526806A263FB73822F9@SJ0PR11MB5677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yucgpRqz5NC2n8GInNDwDX77t538UaJxa9ZSfJvxtIdAu6UO1/6s/WtEfcBdDal4DUpjC7YEiaJLZynZMldLkcPUVYAf5YXBkEDlsLPYRCfNrXkcSSCzwvwS7AD3uw0IqO35TmyG7bNZ/EOYUFWPrESl3rJNDhVHJM0YEmAUb601rBtcsfx+WZ1rrYXt5xd+RIs0J6/DTux4H4RROZu6Dy53cI09X7/INZk7Lb45fU74QLKzOakGiRZfx6iU9yVpr/0NWqqGquRQ5/d+7dyLVCAo+KtwuuliZJp8jQAr7jVzIQdjf/abgxjGyJJC8mk0bLzix15d5u3+2CwRsOAVf2nz+pPvbjuTi4/7UtxrLpiH6AOIKk4SqOK9+BOhCV8wprLbojHcz5tg4GHNWQXG1uDtqX4wsa0Z5S6TeYLAOYcatCFesfLcLpfJAcbMSsxLEBDRLz0TiHCQ8NGaKLpBz8JOHlllPoLj3Ji0QGbI29t+Xvr7Cu8nGgtsgGN550Zs60X2q7NB7XvskWgBDZFLEsH8TxQcnQKEi5IP03lSX4nQ9so19O6X4IIj26mv5JRz7bzcsZC3GjbyKoW8Rk1CEaDgMIvhw5cCZ/TNkBMx16pOypYgduuoc22Cy7UtU0zh+0wxOXkUxX6p7zODcuURyKs9qzQ8P1YWvyZRb8eyhGzi541yN6lW2B93UYWbbwketsbwfYnZYhGnblFvgmc5VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(71200400001)(6486002)(508600001)(38070700005)(54906003)(110136005)(8676002)(64756008)(66446008)(66476007)(66946007)(316002)(66556008)(76116006)(83380400001)(91956017)(86362001)(6512007)(2906002)(6506007)(8936002)(5660300002)(107886003)(2616005)(26005)(186003)(36756003)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckpCbVdmS1YzUkt6SVZVR2JvTGN4MFF1dWRLVzdpSnBzNmV1L0RpTU40dnB5?=
 =?utf-8?B?Z0d3WlJmYk1xenZDZHZ1SnZXR2Y2V0xabmpHU2UwQlpwVzltOFBhb2RMWUMz?=
 =?utf-8?B?ZXFYMW9PbHZ5NGNGcVQrNkN2TGdEUVJzdEVMRFVWa3Nvb1RKNDIvRkJiMElm?=
 =?utf-8?B?b1U0azU5L2wzRUMyaENZeDRhekh2Yko4U3Y1L3I2Z2tZMHA2VkUrQlJTa1Bt?=
 =?utf-8?B?dXovVndXUVdiVDhWdjNZYzRSV09MVVU0OGo4NzNycnRYMitlcFV5b3F5V0ZG?=
 =?utf-8?B?cVcvZlM1aUVhQUc4b0pVbFBSYlFCTFo1M25VZXhzQkEyMGJlOFQ4SjhpMFpt?=
 =?utf-8?B?Mk0yaFovZzFpVnRzUjJqRmtBWXMxaWFrMUhoRmY4cnZDQVNoVGdLeWVySTN2?=
 =?utf-8?B?RUk1Ymk0VmNLaHo4alVCN3d4L0ZTN0VsdTZZOWlPZVdueUR2WGVUL3BVemJI?=
 =?utf-8?B?Ym8zMkQ2MktrcWtiL0hJT1p3YXNEaGg4NzNrc1RnRC9MMHJNNWRGOVRxR2Rp?=
 =?utf-8?B?em5KcjF6NG02dUV6bjJ6Z1BTOWRqUG9yYVBRNGkwWENwQVc4Y1VyWTQxY1FO?=
 =?utf-8?B?NHdJY1hwYyt3TW14UWw5L1ZicE9DYUEwVndLYTBMZjNtT1VvT3ZmUUhIRmNr?=
 =?utf-8?B?N2orVHpBY21DL1h5Wmh4RmFQOGh2V0lvQU51ZmZ4TnRTVTkvRVBKVVluclV4?=
 =?utf-8?B?L25OdDkydndjVllQMkEvUm5PS2dzT3kwU2c1VVRVT0l0eU45aXF4OGk3c0RN?=
 =?utf-8?B?NzlJZmVGMjU0K1llOTZDK0VzRnA2RWFlZjB2aFRPTnF1Y1BmWm50V0J3eWk2?=
 =?utf-8?B?cjZXUk9TNDJzbDcxL0xJSHIvZThIM3pQelFsWDBJTlZrTnNtT0hrVE5FM05D?=
 =?utf-8?B?VHUzdTJGdjU1YWVJMWhLZ2ZwY2dIOUo0ZnFwdkJyWVIydDRsL1d6dUthZmxY?=
 =?utf-8?B?UDNLVjMvRmVWam9ySGhBcFhiZVU4dlN3akswVnVGNGY4N05BVCtSdTJPTTho?=
 =?utf-8?B?bE94YUZUaVRoWmlqU1ExclZpR2tTdmJnMGx1WkROQ0tvdmN0Y0oxNi84OFlB?=
 =?utf-8?B?a1Y2d2x1QmR1bFNIc0ZUR0JHZUFoYmxDejRrdzdaTTIrckdOTGNId1FDc0xl?=
 =?utf-8?B?Y1VsY0x4MExGYm9rS0RhUGRjdWxadEczNUMySHBlcFo1T0o0SjdXV2s3cjJq?=
 =?utf-8?B?dlNNYmdyWDZsNTk0bG5ISnpFdGw0YWEwZ3dqeTlsSk83ZTNITW8rTks5TXpu?=
 =?utf-8?B?Wlk2V2tINDdNQnQyYU10SW5wdGJtemtnNUdORWUxaVlkVVU1dk4wdUtZSURv?=
 =?utf-8?B?RGpSZ21mdWMrWW00bXlpWXY2SXI1Wk04OWdhSHZzQVNrTVYzYTJ5aVEyRWpo?=
 =?utf-8?B?TjZYRm90K1ZFUkVaeHg1aS9zbFJUYnRpV21ONnRiT1MrRVJvcldwVitDYWZx?=
 =?utf-8?B?K2JoNUcvM2dseGFJN0Y0YllHWnFxTjF3R05YU24veVZNNldVbjV4MEx2VE5t?=
 =?utf-8?B?K1lPbE5ScUcyTVdocnFNYTBOUzFKV2VIdnU4Mmx0RVowMzNNZmZldkRsTk9R?=
 =?utf-8?B?Nk9IL1hRQTFybDlRcTlkVlYzaE9VNFEzdlNoczAxRmZGMXNSSVBVMVMraDlz?=
 =?utf-8?B?V2kzZC9URmFkWnFOdzFLWEo2Q0NOUllST3VwNngzZTJVK0pBU0w4NE9vclNM?=
 =?utf-8?B?NEo1T0JjaXFTY0NydWJBYzBQTW1jT01rMFZnczkybUh1M0VrelpxN3FCTDVH?=
 =?utf-8?B?bnp5U0o0bElwcWZkRXBhdEl2Y0ViK1RJUWVJN3BERGJ4RlBIVnZsbU1obFg2?=
 =?utf-8?B?OGh2ZUI1N3NxMFAyYmRYMC9XVGhiZlZnWVREQ3FlTzAzenlLQk82TmtCZkYw?=
 =?utf-8?B?NkE1ZDZYOGlaem1OQTZsaC94L09XSjBBeXl1QTZJQkpUUFljZFAzRkJjdjhy?=
 =?utf-8?B?WGlnL1BBMG82YnJkMHhnQ3dkMWdZeXBSVUI0MUxTU2VMbkVFYVJBWXNxdi85?=
 =?utf-8?B?dlkwYkJoZ2ViQXVSUTE2NEd4M05rTE0yYkRhNXJzanRQS3BqRnU4eXBEa0dH?=
 =?utf-8?B?NXVnaEQxN3VvSExJQVkwa3ZUdElJS1Y5Ty91NlBmWVVBcXR3VjIzWW11L1B1?=
 =?utf-8?B?MkZNNDdWNEl0THAyQ085QTBzK0NRZWErWFlZR2JDRTRJQXlOejZSb0ZucTIz?=
 =?utf-8?B?b2wwdi8zOUNNWWxFVW1nNlVOTkhmMklBM0lMcWZ1OFQzdURvN3BFZTBPb3NC?=
 =?utf-8?B?bDRJZWRKckx2QnNZdk5WS0ZoQU13WXQ2bVV0YTVpQXAvN04razNWdUxwcG1N?=
 =?utf-8?B?YUpEdHBLdXlac0NOcWlVUFFwRTBwUHA4N1MvbVhZVmZvTHVZQ1JKUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA636A724235CA4C9CEFBDEB5EDBF208@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 364a5827-1e7e-4dc1-ccc7-08d9ecab7541
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 15:38:59.9976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mxNR0UPihXPVEDkK3/3GmQHKlZlw2eHuyF9g/BGEWDp3lOwtQYrskaXxEcJj6FzUt5LI4hx+z5chmBKPPl3s3gp0tRSIJMuZEJEz18qZVMbchsFK6hY+bkPqMw049ChK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5677
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAyLTEwIGF0IDIxOjAwICswNTMwLCBQcmFzYW5uYSBWZW5nYXRlc2hhbiB3
cm90ZToNCj4gT24gVHVlLCAyMDIyLTAyLTA4IGF0IDE0OjEzICswMTAwLCBBbmRyZXcgTHVubiB3
cm90ZToNCj4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQ0KPiA+IGNvbnRlbnQgaXMgc2FmZQ0KPiA+IA0K
PiA+IE9uIFR1ZSwgRmViIDA4LCAyMDIyIGF0IDAzOjM4OjQxQU0gLTA1MDAsIEVuZ3VlcnJhbmQg
ZGUgUmliYXVjb3VydCB3cm90ZToNCj4gPiA+IC0tLS0tIE9yaWdpbmFsIE1lc3NhZ2UgLS0tLS0N
Cj4gPiA+ID4gRnJvbTogIkFuZHJldyBMdW5uIiA8YW5kcmV3QGx1bm4uY2g+DQo+ID4gPiA+IFRv
OiAiRW5ndWVycmFuZCBkZSBSaWJhdWNvdXJ0IiA8IA0KPiA+ID4gPiBlbmd1ZXJyYW5kLmRlLXJp
YmF1Y291cnRAc2F2b2lyZmFpcmVsaW51eC5jb20+DQo+ID4gPiA+IENjOiAibmV0ZGV2IiA8bmV0
ZGV2QHZnZXIua2VybmVsLm9yZz4sICJoa2FsbHdlaXQxIg0KPiA+ID4gPiA8aGthbGx3ZWl0MUBn
bWFpbC5jb20+LCAibGludXgiIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+ID4gPiA+IFNlbnQ6
IFR1ZXNkYXksIEZlYnJ1YXJ5IDgsIDIwMjIgMTI6Mjg6NTMgQU0NCj4gPiA+ID4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MiAxLzJdIG5ldDogcGh5OiBtaWNyZWw6IGFkZCBNaWNyb2NoaXAgS1NaIDk4
OTcNCj4gPiA+ID4gU3dpdGNoIFBIWSBzdXBwb3J0DQo+ID4gPiANCj4gPiA+ID4gPiArIC8qIEtT
WjgwODFBMy9LU1o4MDkxUjEgUEhZIGFuZCBLU1o5ODk3IHN3aXRjaCBzaGFyZSB0aGUgc2FtZQ0K
PiA+ID4gPiA+ICsgKiBleGFjdCBQSFkgSUQuIEhvd2V2ZXIsIHRoZXkgY2FuIGJlIHRvbGQgYXBh
cnQgYnkgdGhlIGRlZmF1bHQgdmFsdWUNCj4gPiA+ID4gPiArICogb2YgdGhlIExFRCBtb2RlLiBJ
dCBpcyAwIGZvciB0aGUgUEhZLCBhbmQgMSBmb3IgdGhlIHN3aXRjaC4NCj4gPiA+ID4gPiArICov
DQo+ID4gPiA+ID4gKyByZXQgJj0gKE1JQ1JFTF9LU1o4MDgxX0NUUkwyX0xFRF9NT0RFMCB8DQo+
ID4gPiA+ID4gTUlDUkVMX0tTWjgwODFfQ1RSTDJfTEVEX01PREUxKTsNCj4gPiA+ID4gPiArIGlm
ICgha3N6XzgwODEpDQo+ID4gPiA+ID4gKyByZXR1cm4gcmV0Ow0KPiA+ID4gPiA+ICsgZWxzZQ0K
PiA+ID4gPiA+ICsgcmV0dXJuICFyZXQ7DQo+ID4gPiANCj4gPiA+ID4gV2hhdCBleGFjdGx5IGRv
ZXMgTUlDUkVMX0tTWjgwODFfQ1RSTDJfTEVEX01PREUwIGFuZA0KPiA+ID4gPiBNSUNSRUxfS1Na
ODA4MV9DVFJMMl9MRURfTU9ERTEgbWVhbj8gV2UgaGF2ZSB0byBiZSBjYXJlZnVsIGluIHRoYXQN
Cj4gPiA+ID4gdGhlcmUgY291bGQgYmUgdXNlIGNhc2VzIHdoaWNoIGFjdHVhbGx5IHdhbnRzIHRv
IGNvbmZpZ3VyZSB0aGUNCj4gPiA+ID4gTEVEcy4gVGhlcmUgaGF2ZSBiZWVuIHJlY2VudCBkaXNj
dXNzaW9ucyBmb3IgdHdvIG90aGVyIFBIWXMgcmVjZW50bHkNCj4gPiA+ID4gd2hlcmUgdGhlIGJv
b3Rsb2FkZXIgaXMgY29uZmlndXJpbmcgdGhlIExFRHMsIHRvIHNvbWV0aGluZyBvdGhlciB0aGFu
DQo+ID4gPiA+IHRoZWlyIGRlZmF1bHQgdmFsdWUuDQo+ID4gPiANCj4gPiA+IFRob3NlIHJlZ2lz
dGVycyBjb25maWd1cmUgdGhlIExFRCBNb2RlIGFjY29yZGluZyB0byB0aGUgS1NaODA4MSBkYXRh
c2hlZXQ6DQo+ID4gPiBbMDBdID0gTEVEMTogU3BlZWQgTEVEMDogTGluay9BY3Rpdml0eQ0KPiA+
ID4gWzAxXSA9IExFRDE6IEFjdGl2aXR5IExFRDA6IExpbmsNCj4gPiA+IFsxMF0sIFsxMV0gPSBS
ZXNlcnZlZA0KPiA+ID4gZGVmYXVsdCB2YWx1ZSBpcyBbMDBdLg0KPiA+ID4gDQo+ID4gPiBJbmRl
ZWQsIGlmIHRoZSBib290bG9hZGVyIGNoYW5nZXMgdGhlbSwgd2Ugd291bGQgbWF0Y2ggdGhlIHdy
b25nDQo+ID4gPiBkZXZpY2UuIEhvd2V2ZXIsIEkgY2xvc2VseSBleGFtaW5lZCBhbGwgdGhlIHJl
Z2lzdGVycywgYW5kIHRoZXJlIGlzIG5vDQo+ID4gPiByZWFkLW9ubHkgYml0IHRoYXQgd2UgY2Fu
IHVzZSB0byBkaWZmZXJlbnRpYXRlIGJvdGggbW9kZWxzLiBUaGUNCj4gPiA+IExFRCBtb2RlIGJp
dHMgYXJlIHRoZSBvbmx5IG9uZXMgdGhhdCBoYXZlIGEgZGlmZmVyZW50IGRlZmF1bHQgdmFsdWUg
b24gdGhlDQo+ID4gPiBLU1o4MDgxOiBbMDBdIGFuZCB0aGUgS1NaOTg5NzogWzAxXS4gQWxzbywg
dGhlIFJNSUkgcmVnaXN0ZXJzIGFyZSBub3QNCj4gPiA+IGRvY3VtZW50ZWQgaW4gdGhlIEtTWjk4
OTcgZGF0YXNoZWV0IHNvIHRoYXQgdmFsdWUgaXMgbm90IGd1YXJhbnRlZWQgdG8NCj4gPiA+IGJl
IFswMV0gZXZlbiB0aG91Z2ggdGhhdCdzIHdoYXQgSSBvYnNlcnZlZC4NCj4gPiA+IA0KPiA+ID4g
RG8geW91IHRoaW5rIHdlIHNob3VsZCBmaW5kIGFub3RoZXIgd2F5IHRvIG1hdGNoIEtTWjgwODEg
YW5kIEtTWjk4OTc/DQo+ID4gPiBUaGUgZ29vZCBuZXdzIGlzIHRoYXQgSSdtIG5vdyBjb25maWRl
bnQgYWJvdXQgdGhlIHBoeV9pZCBlbWl0dGVkIGJ5DQo+ID4gPiBib3RoIG1vZGVscy4NCj4gPiAN
Cj4gPiBMZXRzIHRyeSBhc2tpbmcgUHJhc2FubmEgVmVuZ2F0ZXNoYW4sIHdobyBpcyB3b3JraW5n
IG9uIG90aGVyDQo+ID4gTWljcm9jaGlwIHN3aXRjaGVzIGFuZCBQSFlzIGF0IE1pY3JvY2hpcC4N
Cj4gPiANCj4gPiDCoMKgwqDCoCBBbmRyZXcNCj4gDQo+IEkgaGF2ZSBhbHJlYWR5IGZvcndhcmRl
ZCB0byB0aGUgdGVhbSB3aG8gd29ya2VkIG9uIHRoZSBLU1o5ODk3IFBIWSBhbmQgYWRkZWQNCj4g
aGVyZSAocGFydCBvZiBVTkdMaW51eERyaXZlcikuDQo+IA0KPiBQcmFzYW5uYSBWDQoNCkFkZGVk
IHJpZ2h0IGVtYWlsIGlkLi4NCg==
