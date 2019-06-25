Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B08F52813
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfFYJ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:29:20 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:46920 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727829AbfFYJ3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:29:20 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P9Qnse002261;
        Tue, 25 Jun 2019 02:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=6S4cxwY403t+Tzj/kL/XlLMglD5BHrtd+ww9ytMz/FE=;
 b=KFOFwyQcXuNNNWtLjqQlinJI8Yt2w/KNBzxddgKYhbdOPxXumRLxLRz1MlzE4EEFxVyb
 CAQPVsZfMp/c5xFOUvYKjkb5qvokAILvVvRrNuF6yUjNiURCbV5QyMW0LNy1h9d6o7E5
 6obXn8WVQpB6jNDkxWMEZumi6TtmMxuK5ABTfGanB8Ag3JSU7oAHkJ96Ho+oYeZ5FY2+
 1mc1iU/+T3voIAyJCo/bfgBMYMJu4Uv2xYH+o1wRTFA+GJHXJhRvOgiPscwc0n3utqME
 LTz+X9WywBJeddfquaIYIM1VMsxubfjYfYyPHVuldXoBMG5c1YdBHgAQW9oNrRsDeufK qQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2057.outbound.protection.outlook.com [104.47.32.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvsbv4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 02:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S4cxwY403t+Tzj/kL/XlLMglD5BHrtd+ww9ytMz/FE=;
 b=R7WHNZ0Ek28muCiU4ExylNGLz3oUE+757IARFnLg6lwOJl9LkRbmbiwWvSzUmJ1G2rfCizinsz4oD7RNBMAU/RIBQZZp7JWACROcHULxrRfHctB5A8E0sb0gdbr7oN4jKuLticiqbdrWpy/5Z+76w3zTRRvhIFjWKLYVcJtM2hI=
Received: from SN2PR07MB2480.namprd07.prod.outlook.com (10.166.212.14) by
 SN2PR07MB2559.namprd07.prod.outlook.com (10.167.15.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 09:29:03 +0000
Received: from SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba]) by SN2PR07MB2480.namprd07.prod.outlook.com
 ([fe80::7dc9:f52a:3020:d0ba%10]) with mapi id 15.20.2008.014; Tue, 25 Jun
 2019 09:29:03 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: RE: [PATCH v5 4/5] net: macb: add support for high speed interface
Thread-Topic: [PATCH v5 4/5] net: macb: add support for high speed interface
Thread-Index: AQHVKoYfMA9Li9EuT0O4O+K54hF+RKaq0c2AgAE8gRCAAAZVAIAABn8w
Date:   Tue, 25 Jun 2019 09:29:03 +0000
Message-ID: <SN2PR07MB2480AE208D1C5A3D6AB7E16EC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378355-14048-1-git-send-email-pthombar@cadence.com>
 <20190624134755.u3oq3xr6uergnfs5@shell.armlinux.org.uk>
 <SN2PR07MB2480CF15E11D54DA8C3B7319C1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625090324.c6tq2neksatfwljw@shell.armlinux.org.uk>
In-Reply-To: <20190625090324.c6tq2neksatfwljw@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1hOWY1NzIxOS05NzJiLTExZTktODRmOS0xMDY1MzBlNmVmM2VcYW1lLXRlc3RcYTlmNTcyMWItOTcyYi0xMWU5LTg0ZjktMTA2NTMwZTZlZjNlYm9keS50eHQiIHN6PSIxNDYxIiB0PSIxMzIwNTkyODU0MTI1NTMxNDUiIGg9InFnK3BXNUJFc0xUeDROSkY5QTJhTml1d2ZHcz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4d94863-ee2e-41d2-a7a6-08d6f94f9035
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN2PR07MB2559;
x-ms-traffictypediagnostic: SN2PR07MB2559:
x-microsoft-antispam-prvs: <SN2PR07MB25590C663EE49ABE48385685C1E30@SN2PR07MB2559.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(39860400002)(346002)(136003)(199004)(189003)(36092001)(78486014)(6436002)(73956011)(86362001)(107886003)(55016002)(256004)(81166006)(486006)(476003)(9686003)(53936002)(99286004)(2906002)(6916009)(229853002)(66066001)(76176011)(6246003)(33656002)(6506007)(55236004)(14454004)(14444005)(478600001)(3846002)(25786009)(6116002)(446003)(4326008)(7696005)(102836004)(11346002)(26005)(316002)(66476007)(64756008)(66446008)(81156014)(7736002)(66556008)(52536014)(68736007)(8676002)(8936002)(66946007)(54906003)(76116006)(5660300002)(186003)(71190400001)(74316002)(305945005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2559;H:SN2PR07MB2480.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Tfa++H2ooJ0Yv113Z0dGeQapxmbLZ2nK+L1fF03TbvSYjMafMHm2b5EDvjrKslYrfvxDHwdbxPO5JtKBH+0a7Tqo87zc7vVnevh9CoHVANekMPOWOjjxtbdLCxFJt713i4TOEeA4MHRQBNdTiTaMXXadJ7bPFovr8KnqsmzSv3gvqo+1bWQ4yWW2XMV00UI4pTiRQAceW2cDkVM/8KYtPOIgBB6BssIXq3gleeD41sLHkdayoWXkbVVnTfk0Xchh/N/PcPlMKDsjg0B8Kae5fe8ObVvvuYJk7V1Nb4ecWxgHY43Rs7os2B9Yz2CplLmpKWq2gYzB+xvWfPLr6VcRXy3yyLXWIWm5C5BkHJmRjVqMcC/YUUcnYagX7gtF8m+qgGb/5oWkOfRxX9cEXtYOokWYjmKX17MIjc0VluvGH/E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d94863-ee2e-41d2-a7a6-08d6f94f9035
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 09:29:03.5010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2559
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=667 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >>  	switch (state->interface) {
>> >>  	case PHY_INTERFACE_MODE_NA:
>> >> +	case PHY_INTERFACE_MODE_USXGMII:
>> >> +	case PHY_INTERFACE_MODE_10GKR:
>> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>> >> +			phylink_set(mask, 10000baseCR_Full);
>> >> +			phylink_set(mask, 10000baseER_Full);
>> >> +			phylink_set(mask, 10000baseKR_Full);
>> >> +			phylink_set(mask, 10000baseLR_Full);
>> >> +			phylink_set(mask, 10000baseLRM_Full);
>> >> +			phylink_set(mask, 10000baseSR_Full);
>> >> +			phylink_set(mask, 10000baseT_Full);
>> >> +			phylink_set(mask, 5000baseT_Full);
>> >> +			phylink_set(mask, 2500baseX_Full);
>> >> +			phylink_set(mask, 1000baseX_Full);
>> >> +		}
>> >If MACB_CAPS_GIGABIT_MODE_AVAILABLE is not set, are these interface
>> >modes supported by the hardware?  If the PHY interface mode is not
>> >supported, then the returned support mask must be cleared.[]
>> There are some configs which uses this macro to limit data rate to 100M
>> even if hardware support higher rates.
>I'm sorry, this response does not address my statement, maybe I wasn't
>clear enough.  I am asking about the *PHY* interface modes, in
>other words (e.g.) PHY_INTERFACE_MODE_USXGMII.

If interface is not supported by hardware probe returns with error, so net=
=20
device is not registered at all.

Regards,
Parshuram Thombare
