Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63098470E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbfHGIYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:24:13 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:50754 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727967AbfHGIYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:24:12 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 77E85C01EA;
        Wed,  7 Aug 2019 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565166252; bh=iA0fMIn+z22QRrLHF0RKAehIB87oUX+syRcc+P7liBw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=T8ewGWnkDEroFTDuUK4yBaqWYaWOUrKwMbl/ZaTFCjN7sBllrYQR9/iWjifYiGpBa
         9pRfjzZXMCMG4Q2TLZ/DosotoetLRqXgYvEfRJANkaWdSWjsOYJmS3nU8A0raIrv+R
         2HS1MsvgfSBdLFeXs88WljHVMn/B7B/4PXguwtgwxnNhdlGCmjcVlZ+DMSyVuC5gR/
         o17w33MNrzG7BFMj7dpOXLw5/mXP4b2QglcH69Jp8FjZEo6BkQD3QzDwyirZ8eEgWU
         sHepxqsYjGUvAbHWmbGYHL+kUlrI7LS+z0EDEBtPlyaHnixiMUhPLAum9yp0PhQcI5
         GZ6FABV6CFp8w==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7949DA0098;
        Wed,  7 Aug 2019 08:24:09 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 7 Aug 2019 01:24:09 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 7 Aug 2019 01:24:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aW8rXPTjJ630uKf8oHlhvYRUXvAqZamgltYGVXmeHLEDlDrgN6rpDkWPnlLHC65w5EDNrRTpQZZ3XRXGb0RIj2fJ/661KftwIS9noj/6GvPl5Wy4RRfoQnZDVrclb4m2BRjXnoOy0iSi/NX5mW7f8f3/VR2ot6+h4Z9QiTGQW3tVbMhbgSg4xo2qlfNfy3JOb5T7R2X+7Jbr/6oFG90AfAc/KzJmBbfjoB00Ci3he7PjOvY5vl3ewXN8a3GIBvC0DODrzCZZontfwPwNmhWCS7mEcmiMTTck2PsvonV2LMH+EFKZ8SCcOz2M/4cuR62QafbgnxByHO18QQ7/wITSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA0fMIn+z22QRrLHF0RKAehIB87oUX+syRcc+P7liBw=;
 b=NHqHPzkPZXs+dO/67J3T/8XP79YwVfqQeFzjijPuXYEuqMHP4v3qebAyM0yUtazrOOjnWsOONGSH0uOzELKkqisV4/njHlUvlhz7Sf4yRAhHJWY1xta6EMkHovGQ3qJfs7baUt4SOzNfa1/d0A6Y/5G0HRkSMEAyHR6sWk/os+X2Yas44Je2orZkYr/Ks8lvJ5nc7d6HHFI4FZwjjtM4XfWxwsyDPzVJZTrEQulpqxgypSz2y8jGCq3mujzEa6GK1XHjN+uXHgK/9ZoPaxykzG4u4Nx7lpjDkW6yqU8svaGRzFMj111y4MblM4qUMUln01dFdEvky+6U5ict8sJnaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA0fMIn+z22QRrLHF0RKAehIB87oUX+syRcc+P7liBw=;
 b=a2/+MjUlvqewW8V10iKNoDo9h5Y/mZxG0yS1bZw87AaK6xQQoZ4A0hDBuNiIb0TCseEshw2H7m/4sJ0X1qGfCtMnIdmVl4lI2JSPRzEwcRSq2rY8iNmutyFqqrgEAcWh4INBtGAgPjIozegwwwuEv48FRCw/qmaLtay3fIdv/Rw=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3411.namprd12.prod.outlook.com (20.178.211.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 08:24:07 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::6016:66cc:e24f:986c%5]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 08:24:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
CC:     yuqi jin <jinyuqi@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: RE: [PATCH] net: stmmac: Fix the miscalculation of mapping from rxq
 to dma channel
Thread-Topic: [PATCH] net: stmmac: Fix the miscalculation of mapping from rxq
 to dma channel
Thread-Index: AQHVTPj9qPiSkQyqykCZYwYofSoX4qbvWOTA
Date:   Wed, 7 Aug 2019 08:24:07 +0000
Message-ID: <BN8PR12MB3266D248C58DB7ABE6238A49D3D40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1565165849-16246-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1565165849-16246-1-git-send-email-zhangshaokun@hisilicon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce15871e-b441-4368-8c82-08d71b109de3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3411;
x-ms-traffictypediagnostic: BN8PR12MB3411:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR12MB3411B8C8A23096085640C996D3D40@BN8PR12MB3411.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(136003)(396003)(39860400002)(189003)(199004)(76116006)(305945005)(7736002)(99286004)(7696005)(76176011)(74316002)(52536014)(66446008)(8676002)(64756008)(5660300002)(66556008)(66946007)(66476007)(2201001)(6116002)(3846002)(54906003)(11346002)(476003)(2501003)(446003)(486006)(110136005)(316002)(2906002)(256004)(6246003)(6306002)(9686003)(55016002)(4744005)(25786009)(4326008)(53936002)(966005)(14454004)(6436002)(86362001)(478600001)(71190400001)(33656002)(71200400001)(8936002)(68736007)(81156014)(81166006)(66066001)(102836004)(229853002)(186003)(26005)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3411;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lL+GRrma1gOShkjpNjyrzXaMKFL4rJFDk/qf6U+RhgBzO1bd4DNQB/oi6Bga2DqyG5ecGrXv1FFaXbwOBMHuAdqRxCauxrHC8JQHLU1qBcBfytY+TRuKsAi2tYllXp2V3ktekyWIMxgGL72MCtpyzccq/DCoCbsy8oPPD2BNhswz5b9LXrBeEtt5+aagdO20sE5H+2EvSCFrwy84WwL4KepB1pO6EQCc9hKxMcTZhpQi5Cf+l1vnctuJ/uh/3kdzyViYQioi1DY2fAvzEMu2N09/VD4B6kn221UWDjda0nlSqbmLqUxeNesjNyzYoLm5pdF0tfu0e+hB68SaEBcWtQtjwDyiBnf5YRXsEZy3JIkH6yXpfyEtlo/THBUB20LtGzugoiy3ai5h5HmNdxaZpRKDooy5a0+R0FYuAn62dGI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce15871e-b441-4368-8c82-08d71b109de3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 08:24:07.7577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0XVqHvUK6mK0rHxkIHv20T+08PfeQR1YUA6RmFMf/gO+XuuUq+CfDoGkfzhzfTFrD7cSMWvGpeF3KevHmTc/KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3411
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Date: Aug/07/2019, 09:17:29 (UTC+00:00)

> From: yuqi jin <jinyuqi@huawei.com>
>=20
> XGMAC_MTL_RXQ_DMA_MAP1 will be configured if the number of queues is
> greater than 3, but local variable chan will shift left more than 32-bits=
.
> Let's fix this issue.

This was already fixed in -net. Please see [1]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/co
mmit/drivers/net/ethernet/stmicro/stmmac?id=3De8df7e8c233a18d2704e37ecff475
83b494789d3

---
Thanks,
Jose Miguel Abreu
