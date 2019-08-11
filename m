Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9403189425
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfHKVUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 17:20:11 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44830
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbfHKVUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 17:20:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2j9gyVOT9DWecR5j2C23qIcOrNGHhwqBRx7xpVmxoXIenZ1yiCh//xsDliIbdkdoRUtLwMO9qKTTTK0fAuumyYyOiMOiEz3FN/VILnWa/sZnh/Gpnp2d7tPZoWOvN91f2lfKBMlX6Qovmsx04Nk2JsKtcojmLdEBe9/owfWqAq6UBrven7Kxt4xkUMf+sMB3RWZexM2VdoGFixw0NArBX7vso0ofxPL3Pj2LHkuLI0H9+ZcoV+bpD/eVfw1cCDAfFtrMq+0D6485FPrM1MP+xa4iQzSnNRNS1Cq0Iwq1zM+lO+fk2zdhLWQ1OGV9pd3qf94ib4WyD9X5N0RUgYsDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lGoGkYmOzQZ1eQyE522w0CPa3kbmHcqPT92t0+ZkYM=;
 b=Vk9InmeL1jHz4YzLDLuvVbRPe/Xjq8jcKya3AvPpOVjP/uqLd5zPnBLZsC/6mp6nrHQOcWSRGZJucvzIi2MlmGbPOgaLc6heQcVRpiDNlad9enX8z9POU4WNG6Dj40u7rgrLDDUqJQWFzzRCZY2Ojf8VqUMxr7YzrLEfEdq9IQoKzqbkNrQe+9ONsrHZhJjWFoT0OJ8Sh9lV0vZ+g0s4sMPH7hEVbR1Z0xZ0Xe1X2MNw0SiBA3l7mMdud/2IFpRpa1+wiOz03R5G605PkUDMt/BZ1QIS37PEoEcu3DI2FKXWwd7Nm6brjipTCoifpEQyNNi/wOaEPzmmGx6tnH3RdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lGoGkYmOzQZ1eQyE522w0CPa3kbmHcqPT92t0+ZkYM=;
 b=ZmCExw7GOAgG+vVv3cbX3tMiF6hyBUbaBKZkKDt+B3OKxYh+5VSHt2EFLIi2baJIgWMvMd8klznQ83C1JpMysCVeT7y/s13H/D5HTKev/7iDIMie35sXfGB760Ob5IKF3q4YTbs5deI5V/QFza4/MsUFQa0jfc8SiLwqIWaIsJg=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2846.eurprd04.prod.outlook.com (10.175.25.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sun, 11 Aug 2019 21:20:06 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 21:20:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out of
 staging
Thread-Topic: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Thread-Index: AQHVTsse6Qsm2zNpN0akGPBvGQTj7Q==
Date:   Sun, 11 Aug 2019 21:20:05 +0000
Message-ID: <VI1PR0402MB2800292DCA9CC91085E5033FE0D00@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
 <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190811032235.GK30120@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.91.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3125374-b1b6-4711-3d22-08d71ea1ae7e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2846;
x-ms-traffictypediagnostic: VI1PR0402MB2846:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2846A89DEA03B2D38FFE78B2E0D00@VI1PR0402MB2846.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(189003)(199004)(26005)(44832011)(76176011)(7736002)(186003)(86362001)(6506007)(102836004)(53546011)(5660300002)(7696005)(476003)(486006)(74316002)(14454004)(446003)(6916009)(9686003)(71190400001)(71200400001)(6436002)(55016002)(52536014)(229853002)(2906002)(305945005)(76116006)(8676002)(478600001)(81156014)(81166006)(4326008)(33656002)(66946007)(6246003)(8936002)(66556008)(3846002)(53936002)(66476007)(256004)(6116002)(64756008)(66446008)(54906003)(99286004)(316002)(66066001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2846;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SEIMCODk27xgepqZk+X+jnRZiRNn0ZAWYMXaIP0o5SZAQWnE0/hP1QKv8CBd8NPEs1JmLQ8bBPRtmj+jyS7fN5VCZtiKomV1y2xQOxrUkD+JxzpKd2FlidBldKyNjlAdQRGjV6n9oEJ0YvSD97GScz8b9ped7b3MRvZMZrvoUqYhQ6bOFt/1c2sjytvoMDKmw2BqJYGGEv7EXPBt/mTZHxUQ2uYCZyqzcUYyxO4PW5y8j/sVgwzC/HsynjloMfo0m1ZeHsqrBKVyz7cY3ATtRsxT0aMCOyw81oNySEZ0gY8jNEqGYiY9CcIwT2HNa+yk3zSEX9T6KbwYvcBFgohJJETDUQVBNfP1s5hmRzD/nmBGF+4W0md4EnRntkhCk+yRs3pWkw6wboRf2XYkft3OEwpY2GNXKupsQtq8/JljF1I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3125374-b1b6-4711-3d22-08d71ea1ae7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 21:20:06.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ixEdxVUB+hdLqwUbeYBU7ULZhzRUxEv1cZ70RT7XSYY3a34GJLjKhg4a3kZbmC3lbd059ZBC/qr+PcxJH9Nehg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/19 6:22 AM, Andrew Lunn wrote:=0A=
> Hi Ioana=0A=
> =0A=
>>   >> +	struct ethsw_port_priv *port_priv =3D netdev_priv(netdev);=0A=
>>   >> +	struct ethsw_core *ethsw =3D port_priv->ethsw_data;=0A=
>>   >> +	int i, err;=0A=
>>   >> +=0A=
>>   >> +	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++)=0A=
>>   >> +		if (ethsw->ports[i]->bridge_dev &&=0A=
>>   >> +		    (ethsw->ports[i]->bridge_dev !=3D upper_dev)) {=0A=
>>   >> +			netdev_err(netdev,=0A=
>>   >> +				   "Another switch port is connected to %s\n",=0A=
>>   >> +				   ethsw->ports[i]->bridge_dev->name);=0A=
>>   >> +			return -EINVAL;=0A=
>>   >> +		}=0A=
>>   >=0A=
>>   > Am i reading this correct? You only support a single bridge?  The=0A=
>>   > error message is not very informative. Also, i think you should be=
=0A=
>>   > returning EOPNOTSUPP, indicating the offload is not possible. Linux=
=0A=
>>   > will then do it in software. If it could actually receive/transmit t=
he=0A=
>>   > frames....=0A=
>>   >=0A=
>>=0A=
>> Yes, we only support a single bridge.=0A=
> =0A=
> That is a pretty severe restriction for a device of this class. Some=0A=
> of the very simple switches DSA support have a similar restriction,=0A=
> but in general, most do support multiple bridges.=0A=
> =0A=
=0A=
Let me make a distinction here: we do no support multiple bridges on the =
=0A=
same DPSW object but we do support multiple DPSW objects, each with its =0A=
bridge.=0A=
=0A=
=0A=
> Are there any plans to fix this?=0A=
> =0A=
=0A=
We had some internal discussions on this, the hardware could support =0A=
this kind of further partitioning the switch object but, at the moment, =0A=
the firmware doesn't.=0A=
=0A=
> Thanks=0A=
> 	Andrew=0A=
> =0A=
