Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A249B32C44D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391267AbhCDAMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:40 -0500
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:38956
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230474AbhCCMtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 07:49:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DulHxZRXeOG5rUXkF+rqlR9d2MEbm5n+BgWC8lfSi8lc0cNY1MxxjPJy0eS8Uvmk59ule26VORyEdSbv7RDjnoVK8r3xVBjsaJ8o6dFJvP8QKp83aT0oPi7P3lOB4vcfURLsDe8NZ8wLRJ7CuFRQJhuSuVKbcjUV1Xthh0av9x3sqrjg4WV0yCLWHFkT9oaAX8ZuduJsFeW8RvVn1BAfetjlWsxdJBGQT3K7T8SDIh8INZLxUpzqT8AibiB22ZEwXyaBw5Z5xK+MRTj4jb0v1NMqsM6pYOilnOkF5Ezbm35i+/Jxkhf8VrX//EnO6WKYhBzZbcdWAJaTrIE/kikswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dI/B+xbzrWuReTZb5TH6g3x4QY4cHW3L41aBA1/FLw=;
 b=iMcp6oF7K+Yj6JyJHF46Bg8MmpNweJV6ganXiki0YTVBI6Vj9nSUQhX0XTTawrRFpSAzbFYQMDvxC+WwusuSOxoIBR9Lf64x91PSPNEKsXJe26Cd0bkux41rY13rY2VatU/S1oK+PTMjI0w9UdFUPFX8cNYzylAUiIpmrnlR8CyoohbjEnKAmW80+lfdqDGAVN0/+LcSLqngbNj8M7Jxovd+qzlDOz2aaEiWJVSDDg1ys3gJ/ENBzmHcDDVK97MTGeS1FWnJYvkNHhQBKnEkY0Mk3O8LmgAMuCeRTUbN1+xn1tjUqu+1zm3uUQ3pklOMXM/dM/0LkaesnPhEMtAk4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dI/B+xbzrWuReTZb5TH6g3x4QY4cHW3L41aBA1/FLw=;
 b=LX4y4/T7oSf93cQcKKVWghaNxSvJvwpP4RLQOzkpa0UwdI8bIVJB1zbYv6QWrsXY88evxxVrF9vFL3eKRkjf2OKK4IsGtiFBM03w3YWqgWv8KY+gxapA62iZ3NUBHgMmUxMcWLi+jOq39Z+zKXrnike1XY4HbymxEtqUYrQ5gBw=
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12d::21)
 by DB9P190MB1147.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 12:47:59 +0000
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d]) by DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d%7]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 12:47:59 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net: usb: lan78xx: Problem with ERR_STS
Thread-Topic: net: usb: lan78xx: Problem with ERR_STS
Thread-Index: AdcQKyr/67nCMUTQRfSAw3DF6if14A==
Date:   Wed, 3 Mar 2021 12:47:59 +0000
Message-ID: <DB8P190MB0634767F08E9D40E9DEBFDECD9989@DB8P190MB0634.EURP190.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=schleissheimer.de;
x-originating-ip: [62.153.209.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20e7e732-2318-426f-f794-08d8de429391
x-ms-traffictypediagnostic: DB9P190MB1147:
x-microsoft-antispam-prvs: <DB9P190MB1147F06F20C6B56568A74620D9989@DB9P190MB1147.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3pqSqK5hlQXCd/7+IUoMxhLRKxFjLvTM02CM6dbj/cLKJt0KhbD15q6Q97YLhFrCOFAN3H7p7tmWMVSJrfa7h2jfB+Zhkl9y3zcvz7NWwiclHqzahUWAVa53PfGja25QPRlWXBmYLOgbqP2yVvIwRXLz/vsVVHFaK+wkQkFVg0l2V3s5K5440pKzCram5YtzcDX+FmhGRpIthMc0I2Nuk9+aICl1k7uclM5dD8bNpW1K9E1BAwp/GcyGg6aaetRzYAVCy5NzcJtm5IjWP9jzWdkWsO/au7s17YTtAUotSVs08hVPygLEEW+Yc7dETcgbqsy8XPLtbIv9gAs1/kI5pY2GCAt6Vto1NYjmIYczpoeMgxgARvZPHFPL1EykiWnpST9B4FanB05DWnIIV+50Uz616EOKT6njILwVYrjJW6IZ1mKAtzWaCdGjTtkvjFL+qk0Dvr0Goeix5GED0z+ANTkq/yj0xnj5WIAfdpEpcLKDqOVfcKyM0LPbiAUZm7CMmN30jp9CZiM0Ig9ym/dhvVK7g5r/+Z/AScnPtJXMZ7u0mmzs2oyU8T3ajj/8HjGZ+ZilMujuNNxtkiG8Ot7Ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8P190MB0634.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39840400004)(366004)(346002)(136003)(396003)(66574015)(8936002)(26005)(83380400001)(478600001)(66446008)(186003)(66556008)(76116006)(66946007)(64756008)(66476007)(8676002)(110136005)(6506007)(966005)(33656002)(54906003)(86362001)(9686003)(316002)(55016002)(4326008)(2906002)(52536014)(5660300002)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?W78MIUowFEwvpn1dJxssUvJZfo08IEXZwI2NG0UrnAs0xAMqUB2RHuFqCf?=
 =?iso-8859-1?Q?1rfJ6b+FoJhFodP5FKb+RuqXFP4UeONo5UCVOhAylm11EtHyFXJPU2ULcp?=
 =?iso-8859-1?Q?T3gAIk4ltK7Cb2lvnkZ1XXpH+9LsivvoKkvh0UDYIWwhUJz6q16sDV4O/S?=
 =?iso-8859-1?Q?PfK/d0WiE9MHie5j6wW5V2b/lrsgSLb9/ZhcSqZszyDqUlfJRlyLIgEvJg?=
 =?iso-8859-1?Q?zaaEL9UVNd/YES8dQStlXmUtIBTn1ZiWHVSQT+gvwnLhucE9qtitJozaJh?=
 =?iso-8859-1?Q?yMLsQtEnklq5BzFRTd/2TeEHOP02eHDBk333JLjkYNDY70HTOWKiD7GuJe?=
 =?iso-8859-1?Q?FCe3MKVWGkIcaCFzjCXbBxTyXdEEgpUzfymzIRHuIok+5mLFR2qtH8mOi6?=
 =?iso-8859-1?Q?B+MinkO4Zejz5YkHh43ZIJAc+n78IjvgTC76p1KIBK7Nai6Ks/Qy5buWaz?=
 =?iso-8859-1?Q?KJSvJNAhB/FlLsh0EdUAW3V9ycEp0S4EN+HgjnMsEeiQ0FylIkQ1aog7HN?=
 =?iso-8859-1?Q?ImRPUeVgmh/Xc1ltukqfI9ET9jNQ5wcZ1xd3GKCKoTTh+3D65ovCccNyvD?=
 =?iso-8859-1?Q?xpZydaPJ7PlsFKbPac35bWatO+7hwbDRgMSEPaNlTdV+ouCN8wdIHLM5HE?=
 =?iso-8859-1?Q?lHuDVnE68YVSbS2loxypxv+5GhVPIDcfGozT8QN9jLvirx8E7cAQ9P/jiZ?=
 =?iso-8859-1?Q?Wy96uRsuf3juhz9+1BcMbkDWwoB8sPBKXEkR/wGr5Tz4vAWN6OvX6PpQqY?=
 =?iso-8859-1?Q?oq50nzkG08iZIRn9pXj3xa2Pakv3kNbnjGRffBcw8wG2KSTwwRyW+RTlF3?=
 =?iso-8859-1?Q?rLzGQXFBxVBClM0rsDI8E/JeK89O8z7NTZvDmB0E5bO0y0WxwTMR7ELeb/?=
 =?iso-8859-1?Q?wOAQMJhVgiZ2XchpmUyKQEFhNyZhLZ0yQAm/wjNmCKAp8pXfFlmkkmfMZd?=
 =?iso-8859-1?Q?vJZwdXS9Cp0LfRyrqNLKF2pNAm8zgYSjh7s4NPRjrwNr4qkwr/O6wNwCIp?=
 =?iso-8859-1?Q?XQpmsf2Wb896sudY1691+dkbaTvzQgdLcVr8GXpjjbsves961/TIgXY47i?=
 =?iso-8859-1?Q?U9Aigyvo2R93U0QBoZHlxN3xMjCIGafWENVqcmQ3ug5xHDchxXZjgOINP3?=
 =?iso-8859-1?Q?uYpW1Sr3Mxbh3uLwPYWUKlVKxqwUJfwViy1rYgH4zMJg4VVKKzUfNfrVCb?=
 =?iso-8859-1?Q?ngHwvliQV4aPfq20ssNDu7dTVCeH2IpQF7uwzdaeZLwnrIweJqU6efyiHg?=
 =?iso-8859-1?Q?clF19IDGIEyTp6Y15GUhHxMZ6AnEXarhFLaQfyXozMyinDEyH/v5iMUyah?=
 =?iso-8859-1?Q?lN4G9d+SSwDZ98OAJAoax3I5NiL6ivUwpOb/i02gOJyPipshIMk8qBMjfG?=
 =?iso-8859-1?Q?kr4UVbvuFV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e7e732-2318-426f-f794-08d8de429391
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 12:47:59.6784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DkcbrE2oTNPWoVG6B3gUjxdMPKapCfIN5QUZ/NR0/LDO0ViHID6Vg7S9Hu97lrvLHuR78UBMuraBj5dpin8Rv2/ky4QYnaJ0I0dgEQW3xCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Woojung,

I am currently working on a project where we use a LAN7801
together with a DP83TC811R phy. The Problem is that if we change
link state of the phy to down and up again the LAN7801 is
not receiving anything anymore, while sending still works.

I already discussed this on the TI Forums
https://e2e.ti.com/support/interface/f/138/t/977492
but I still have no solution.

I placed the following code into lan78xx_link_status_change():

	ret =3D lan78xx_read_reg(dev, INT_STS, &buf);
	if (unlikely(ret < 0))
		return;

	if (buf & INT_STS_MAC_ERR_) {
		ret =3D lan78xx_read_reg(dev, ERR_STS, &buf);
		if (unlikely(ret < 0))
			return;

                netdev_err(dev->net, "MAC Error Interrupt, ERR_STS: 0x%08x\=
n", buf);

                ret =3D lan78xx_write_reg(dev, ERR_STS, 0x3FC);
                if (unlikely(ret < 0))
                        return;

                ret =3D lan78xx_write_reg(dev, INT_STS, INT_STS_MAC_ERR_);
                if (unlikely(ret < 0))
                        return;
	}


If the Link of the phy is going down I see the following output:

[  151.374983] lan78xx 1-1.4:1.0 broadr0: MAC Error Interrupt, ERR_STS: 0x0=
0000308

So the lan7801 seems to detect an INT_STS_MAC_ERR error (where the contents=
 of=20
ERR_STS are not always the same). The Problem is now that the lan7801 does =
not=20
receive anything from the phy anymore, whereas the phy sends valid data on =
RGMII=20
if it goes up again. Strangely it is still possible to send data from lan78=
01,=20
e.g. echo requests are still on the line, but response is not received.
The only way I can recover this state is unload/load the lan78xx driver.

Does anyone know how to recover the lan7801 to receive data again?
Any ideas in which registers/functions to look why rx is not working anymor=
e?

Best Regards,


   Sven


Sven Schuchmann
Schlei=DFheimer Soft- und
Hardwareentwicklung GmbH
Am Kalkofen 10
61206 Nieder-W=F6llstadt
GERMANY
Phone: +49 6034 9148 711
Fax: +49 6034 9148 91
Email: mailto:schuchmann@schleissheimer.de

Court of Registration: Amtsgericht Friedberg
Registration Number: HRB 1581
Management Board:
Hans-Joachim Schlei=DFheimer
Christine Schlei=DFheimer
