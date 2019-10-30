Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5961AEA623
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfJ3W0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:26:44 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:57654
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726501AbfJ3W0n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 18:26:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gG6O5CUfHxO4yToTOwHKQg7KIRPXFt0sVN60409WQ/og+Osq3ULwVrqtg7+kLjxBFZds9WT7cDEZE/KnobdaFpSc1vxITSgB9wPgaGecpskRWQYZVJEsMO+lE4XckZzKAo2iesIswIaIvf3bZ130W3EdZDhDUpyai1S1edxCK1648/tiK9z3fQyl0q0LgybvujjaPjQwmMcRGFGS5ndrVqPums9a7+YMVDPuvpQQHPJsRNsb3QhdahIhsvZ7oPodq/XhKCzPh1NP7cpkBvCSMBxyQ/cL0LwIWu4LTipmYgY9pClzx/m2UPU7AtDa1VeI/2703+EKmmMFWXXJxA4Tnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aADv434K6n18sXNdUf3WERzTQyCxl1/YeX312KLInYs=;
 b=KL/BQCd7RWtYy+Tvu/NrECq2kVHoklxGc8noQRMbzUdrmV6FZFsOT+iBkfEXxrBUe2dtWl2/Wkjzqu0eQ0fOOaenmS+bVfbfzoWNDFkOi5dir/dAMSdSgEnM/8JcAGNDRxMT7PG8VwYny8lbWE8QYZ2y0Nif05c+9gZnQdf9ZTeFHe4HY+JC99YM/s9LEcB8Kli/Z8A/QKU522mRHl6Hn6DrAZQTb+V9XFiriR2apLT3UMKgMbbTy5ytsWYEps+yMXLOZuZBsiBW95/oGS79dNYBedIob66bQ3A2p7iu7+UZnmPztiro5Si7NHQ1vi8MoqZI2rwoMzCCYBSUc9XVXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aADv434K6n18sXNdUf3WERzTQyCxl1/YeX312KLInYs=;
 b=AcUH+9dRgTOn7O7D7LW+/6Dt66Fcf7dgLMqmZm+luQz+ZXiFdH4UusURLCzhQTK+EILUdN/WbUy5dM9iGlhmTs84xFiCSA78ok2YO3lGSxml3FoPcy99v1hyrXDpegsEyaHSDngp2OvoRY58w+Bw38nSxYTQhc2eqCSlc1ieqEI=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3888.eurprd04.prod.outlook.com (52.134.16.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.27; Wed, 30 Oct 2019 22:26:39 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2387.027; Wed, 30 Oct
 2019 22:26:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Topic: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Thread-Index: AQHVix1sOC+L+Xa0dkS4RnM3YQGOjQ==
Date:   Wed, 30 Oct 2019 22:26:39 +0000
Message-ID: <VI1PR0402MB2800C85DDF69B699620DF973E0600@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
 <20191030.145917.1263185053715293146.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.121.29.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e36a2b9-0bb5-42b1-462e-08d75d883bad
x-ms-traffictypediagnostic: VI1PR0402MB3888:|VI1PR0402MB3888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38882A6A85338A44B5B0C79BE0600@VI1PR0402MB3888.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(199004)(189003)(5660300002)(71190400001)(102836004)(26005)(25786009)(52536014)(74316002)(64756008)(66446008)(305945005)(4744005)(6116002)(186003)(66946007)(76116006)(7736002)(71200400001)(6246003)(66476007)(3846002)(2906002)(229853002)(76176011)(54906003)(33656002)(478600001)(66556008)(86362001)(446003)(53546011)(4326008)(256004)(44832011)(66066001)(9686003)(81156014)(14454004)(6916009)(55016002)(8676002)(81166006)(476003)(6506007)(8936002)(486006)(316002)(6436002)(7696005)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3888;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ed8Qgv4DYMazNcF9bPKgPDrGAKZ4RhZtXuA9HUR9Vre1Vd/t7jovkS3M2GW0YHBuCGqpw7AoMBCzVm/9pxlvRdmK35Wf4s81eZZnsDcBT0jDoH9E1rV03w8q7eVT/UiRlvalnKtdAn9iqgscoX5U/mUrzBCViGfWyrXHxifUCpfkt51zxXPsrAxzSa9gz7CaC5ecw51Bcb3eQKwB0KEfxVNpclNnygjnYN06Gnad9BMnRJYMNc2bb8fpgqLwFuEpxIuj80+lbVnAUfyT7UH53WkmhlA1+sGgdjEtpmas9YsaVgnFr1kSwpTXA+ylfMgMGppuL20x7q8EMsimtnhuyYbKkgyg7P00VxIJj0JjQ6+vcCu9Hije9YVyvqYIojp+9DqN254bjgHdQbozF0z0EHqihQyxuE/qmwgXOuxO82fVd7IdDqOLMzJLmYIKS1xI
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e36a2b9-0bb5-42b1-462e-08d75d883bad
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 22:26:39.2452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mRkdT2K51HZ/P5ssAYG/UK1hX0qjL6uPwW6k0gVjvGCbDVpzXdJIwXFug4GYxrbqml5T18OpeJYi41gtmGhKPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3888
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/19 11:59 PM, David Miller wrote:=0A=
> From: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
> Date: Fri, 25 Oct 2019 13:17:07 +0300=0A=
> =0A=
>> @@ -712,6 +712,39 @@ void fsl_mc_device_remove(struct fsl_mc_device *mc_=
dev)=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(fsl_mc_device_remove);=0A=
>>   =0A=
>> +struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)=
=0A=
>> +{=0A=
> =0A=
> Like Andrew, I'd really like to see this returning error pointers.=0A=
> =0A=
> Even if right now the callers don't really change their actions in any=0A=
> way for different error types.  It's just so much clearer with error=0A=
> pointers and opens up propagation of error codes in the future if that=0A=
> works.=0A=
> =0A=
> Thank you.=0A=
> =0A=
=0A=
=0A=
Sure, no problem. I'll submit a v4 shortly.=0A=
=0A=
Thanks,=0A=
Ioana=0A=
