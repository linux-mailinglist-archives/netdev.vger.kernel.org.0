Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4601E73DA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 05:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgE2Drs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 23:47:48 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:52110
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388037AbgE2Drq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 23:47:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGC9WaGv7kOGWGWy4lCa1F/to0yPNR6UzTJDfWilLEi/PDJKCbcT9m/xjIeugRAXQTXdaX7lG7TbnE0eLdlqbZXyti3eorxQpBhaoG/E38j6qGWfXIPhQfnFoV/JMgz6jeUu1f+iGwc+2o5YDQvLvJHTKIMVpgbpMzH0gZyzioMgq67LNoH7sugC6a78y+gEQXhM2cGPjGGDfU20GcmbMIVOxcdx7NRF9EwltZnmqrmQ+phareycc8XggqrQ1JfpO1zvvxX5pd/XiWmxFFmCLoPE+/mDjn4hBwY/7ecON78mOOUH3w167plEw5LRw59u9isIEJqCg+lIVVK6SnLcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcd+Uhzr0qjZfnQag0g/hmWUaJmEePf8osyDV+w/1ds=;
 b=QtlOoyFquliuOevJPitTF000N4ZufDGh4x5Y2VnYmyra1FdRmp9lPXTd1Ys+9BRaMe6rx5QhzaBovPxClW+2hC4IB1Lkafn6zzwpPuoLBthxZy3Poag7NZMA59SFh8yKcI40PJgUS8KVwPeqXSkbvo16PpNUzy9NDRuBW/3CSDk8MhVCBj5vzCUSVmt1CvTWEAJfMZCPLrVUA806HDG4mpg29XJHqxpi75k+FPPX1u08qAUPs1ZFvWpx9iY4p4TuSl584LYA0elyLYewkdEByE5ePEzbuLnDNWN1ZdRsRlsOXUvzJRdrqRvxXvUMXw1T5sbES9SdrrX0UY9K8NzqWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcd+Uhzr0qjZfnQag0g/hmWUaJmEePf8osyDV+w/1ds=;
 b=jYevGm+HSPhVvzcgbAhbFgg5yvqeGp2aJVWgY4PnRc26HmncAbvOtsF3dkL1jIC3s89XXEKkJBh8Fd2NYiQkh6zDd3xhPGSFRkzfU5/mDrz5Un5BY9fjZq9aQPZkhLOHvrn8JYSkrdsZNEU2pSyM3kRJKbZLxjPsVz/U7tjdpgE=
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com (52.134.30.155) by
 VI1PR04MB6143.eurprd04.prod.outlook.com (20.179.27.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Fri, 29 May 2020 03:47:43 +0000
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09]) by VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09%7]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 03:47:43 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] mwifiex: Parse all API_VER_ID properties
Thread-Topic: [EXT] Re: [PATCH] mwifiex: Parse all API_VER_ID properties
Thread-Index: AQHWNNrPPyMyN8tP00SSOiu9MK2qcai+bcPA
Date:   Fri, 29 May 2020 03:47:42 +0000
Message-ID: <VI1PR04MB436680DCC1D6A32CB28CD34C8F8F0@VI1PR04MB4366.eurprd04.prod.outlook.com>
References: <20200521123444.28957-1-pali@kernel.org>
 <20200528102858.riwsja5utqix6wqo@pali>
In-Reply-To: <20200528102858.riwsja5utqix6wqo@pali>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [103.54.18.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ef8b097-d19b-490f-35df-08d803830ae4
x-ms-traffictypediagnostic: VI1PR04MB6143:
x-microsoft-antispam-prvs: <VI1PR04MB6143E58B4BF7AE7881A683338F8F0@VI1PR04MB6143.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tAA+JtOZM6zYHmEG/UljV8/G1WQbX72hi5EUA/oFS3XBo7ceO5OUh1EZQo2ZE5SeGDF2SRJC9Xp4Z6L2+GLvwYdWCo5gF/Lu62Du1Uspl4JMwndLRRlJU0KiP9nUzk1X9BPouN2lrmzNzM4Y4aHcJcZhGa7CPT72X2aw7DfKLNgiz2o8lZddwiuX9AjdNKInWcALFy5B5+X8eT5i9FjmxVs3Gi2CC0Dr51KKd6DBmfhtkrh+vxNY7rMtGpXYeUkhx/NVuHgI8KpE3IcOrYeae2qZLfcqFI5e2YUvCyhqNYBF7QzNb4Rq4aFIcY0EvLPo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4366.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(26005)(44832011)(6506007)(54906003)(5660300002)(33656002)(2906002)(110136005)(71200400001)(316002)(7696005)(86362001)(558084003)(8676002)(9686003)(66946007)(52536014)(64756008)(66556008)(66476007)(66446008)(186003)(55016002)(76116006)(8936002)(4326008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gpbaCoBo99fNXpqDj4KV6b5GcNwJj3sUnUYejiA4GXHQdH946PWbbjrS9L7t9sJjFAam8iEcoPBjYdXxNHropW67JPExC60WR+NMjwLnK01Ex1/JNvDM7EjSBE5ngcWwsUxawTMZpMISFvZpq5tN6zHn4nK2uJQfWZICut9ucZuZ9kfIQTr+IkB6r73kHr8KDSiT4grvpdN2O3GioJYnWVcMat2gYg4FeuBZSx+4mKfvp5KYsSlL8o/LDIl8L84ZOHPKc+6IZuXRm1D3yPApWvHMpu2DftS4ikm1atnAOf9QLO6TR1la5cRR6NqyNIOdJ5MhWLF7sXd99mdImRV3Tp4epC+esrISnnCGQ4N10Oc2q8ZB/4cXqCMS3z7zXHjRulSKAYkF4mc2L1vlRUDXS2+IfhmZ1i8qVLTtJcuQg5ebp8MpkYBhRXQWa15HA+tfpH3MM9AQageQuFh1V4MmnIHIe9qm4ANkckU65Xdm1ol3EZFMMl/FPozWpJg/PSce
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef8b097-d19b-490f-35df-08d803830ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 03:47:42.9753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sW3VcK9iIFJjLTgzSAgVmroBYa3KTieABHAYnJ/7cFKHVlXRn0bux2mxmjGNVIf1Dyu/o+52vAhCsCDjmMly7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFsaSwNCg0KPiBIZWxsbyEgQ291bGQgeW91IHBsZWFzZSBsb29rIGF0IHRoaXMgdHJpdmlh
bCBwYXRjaD8NCg0KVGhlIGNoYW5nZSBsb29rIGdvb2QuDQoNCkFja2VkLWJ5OiBHYW5hcGF0aGkg
QmhhdCA8Z2FuYXBhdGhpLmJoYXRAbnhwLmNvbT4NCg==
