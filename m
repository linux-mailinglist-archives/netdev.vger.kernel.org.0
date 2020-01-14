Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E4413B048
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgANREh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:04:37 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44076 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726450AbgANREh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:04:37 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 51DB8406E6;
        Tue, 14 Jan 2020 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579021476; bh=Mm3MSZqC1zqJvH0MmChVvhHcosSr0ipdo2lXzi0QO5M=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZYSY1t4hQMiyegvX6Oa/w9qRIfEV9gP2M3pHMjNkOF1VLrFHUzlG/QpY0DQGFi2lU
         knoLULLarUEffcTmYWVvvwFhQYu9asv7wII5QiPy2bVMgrlLEQuLc8+O7wzT4V0OqA
         PwMOrxVdKUxTsaEKAqg+5XOOMf+8d446e8MpE+2ju1zWLvTimCeWkqOruZF0K8C7X4
         gqH0ztHh42C8OruVrDgTk5sK1G0F4IKQIdw13K269GEpEuvv3hLXwzNN/lzgBbNxRJ
         3KBGEGwbjJRCdKO/MvrnERDVX2axvpMy6/li39iUMulwBUkmPK1iFAFlzPzycvr+iX
         wAUWrHtqeU9Ag==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 24581A0085;
        Tue, 14 Jan 2020 17:04:36 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Jan 2020 09:04:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 14 Jan 2020 09:04:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0xlQDGHnMCakRBGBEgvhYnXStQZzYgb6qH0Y0qucyHUc2o9O1YiR76H/jdC51svEvztYniOuejDFNvsWp0wrG8v0tK2qOh3uUJi9Kn7m7YDRfxqL7YaRIOswzYjbDiijh7EYFBriuKXe6SdUVACQ/MKtoVCl1JyUi1GO4dsmLPugS2Ll7pl42UUK00rhw8oDM5XYdG0IGUYIo2LuSpZmO3bF0PFbuzmtc3ZhzNK5soLSM09IRpsmsV326DIiBGAZPvJcDpmXJr4iHmTwUeZW7ZDKGn9LeZQSsvQCnF1rRRVEqNcqIOwsSlMuqpX6l6KtEoa6oY4MBy0dRZHuiZlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm3MSZqC1zqJvH0MmChVvhHcosSr0ipdo2lXzi0QO5M=;
 b=HVxOxjDHERJjALjwZpcVia6QT24T4H7T4Xa10QTpmsumLJNul6kTkD+DNRAJGeXFrz9GeIC1whCIcqp8NHZNl9/Cw7E9SBxaAclZ+Seuy+/sdeo0E3W025G/JOwLG0j4X6eL92uNt1EkbSDAslGuhP+wRc5AdywmG5Uc0pE4LlGR3LpP1nhSXCgVzkrl2KjzuiepxcT69nOd6WMzfevf6SzcUgZj2F1QhHYHC/B34YiHYuVe2W0nTpWHnxJyg2TTDISklHlTwGnrFx5hcNvPqXH1whxMbxC+S4s3X2Rbi7OmjfemBxzoc94JG/iKCcBBEbbIhqY1q3lXEhFmEEuoxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm3MSZqC1zqJvH0MmChVvhHcosSr0ipdo2lXzi0QO5M=;
 b=XC3dc04pVlh1mzxwVEVgZ1XyRf+53DsFR7Fn49SrXOVOY1j/xJPcwKT+Ea/L7hBZOPuh2P5BMivct6DajNviRkLaOJUDssRlxjAftq199ntQkMwkUqb9+AuAgmwBDT+p67y8fmAtaMdSDHbndCylVGXArpQbiPzioM9AdgND/L4=
Received: from BYAPR12MB3592.namprd12.prod.outlook.com (20.178.54.89) by
 BYAPR12MB3189.namprd12.prod.outlook.com (20.179.92.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 17:04:18 +0000
Received: from BYAPR12MB3592.namprd12.prod.outlook.com
 ([fe80::39a1:22ee:7030:8333]) by BYAPR12MB3592.namprd12.prod.outlook.com
 ([fe80::39a1:22ee:7030:8333%6]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 17:04:18 +0000
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter
 number to GMAC node
Thread-Topic: [PATCH net 4/4] ARC: [plat-axs10x]: Add missing multicast filter
 number to GMAC node
Thread-Index: AQHVyvUfClf4TsxnMkuRbCyapjHT5KfqY2YA
Date:   Tue, 14 Jan 2020 17:04:18 +0000
Message-ID: <139baf42-2704-db1b-579b-50f35c86c6d7@synopsys.com>
References: <cover.1579017787.git.Jose.Abreu@synopsys.com>
 <b1abebaf6ac9a0176b82e179944a455fbf1d7a15.1579017787.git.Jose.Abreu@synopsys.com>
In-Reply-To: <b1abebaf6ac9a0176b82e179944a455fbf1d7a15.1579017787.git.Jose.Abreu@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vgupta@synopsys.com; 
x-originating-ip: [149.117.75.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00166dc8-5278-482b-8f3d-08d79913cb15
x-ms-traffictypediagnostic: BYAPR12MB3189:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3189BCD5223DCC9787C5B98BB6340@BYAPR12MB3189.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(136003)(366004)(376002)(199004)(189003)(558084003)(76116006)(86362001)(316002)(64756008)(66946007)(36756003)(66476007)(26005)(66556008)(5660300002)(31696002)(6512007)(66446008)(478600001)(4326008)(110136005)(71200400001)(6486002)(31686004)(186003)(54906003)(2906002)(53546011)(8936002)(81156014)(2616005)(6506007)(81166006)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3189;H:BYAPR12MB3592.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: an9ym0rcXWG/gzs48vn8cAKvuaAsdhonDPavf9SUus/e6yFOlEeGQ/qvTZ/im9HAC6JXmsdHKU+6c7f2QzZ2fxENO7VEWbQ0de6jmElTWgyBuD4FRNmXUKqASIhBneTE87U1B3qgXu7CPgm7RJRAz7/0LkSmQGuC66uhR+/XeRfXUAAG/WSrb2FUoLW7GLyOzhmdtsKR6HX1PoxDegN+lxIqeaIDQD7BnyfnNT2vYbTwBVT99+l5ihEuJqUlipBkBgg+mpB04IWOrMHc5cF9hTM6qWZb9aWn4+mTvBKEKZ4iGtQrHqOJn9sCIniFHgMhNmIWgVVLf8cn0s1GkNpCRuYXnEKGP2N+KrZF43GwPCnBHUKPENS9RgN4X7hv2Z+KIadPMX6Is65+EyVt3kd+Ryv12WrLWYMqpTIq1HblxHU+BUKgjXknFqb2L9cAVzkw
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDDAF59D5ED969459334D80E14DDC0AB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00166dc8-5278-482b-8f3d-08d79913cb15
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 17:04:18.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHlzY9vp+Jte1XeVbiJSRWJHH0p7Z6/BWBO57emIdwga4qLydyxnKjPLwQQ/LxFllMcRRQ+vKHifBONmmWu+lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3189
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8xNC8yMCA4OjA5IEFNLCBKb3NlIEFicmV1IHdyb3RlOg0KPiBBZGQgYSBtaXNzaW5nIHBy
b3BlcnR5IHRvIEdNQUMgbm9kZSBzbyB0aGF0IG11bHRpY2FzdCBmaWx0ZXJpbmcgd29ya3MNCj4g
Y29ycmVjdGx5Lg0KPg0KPiBGaXhlczogNTU2Y2MxYzVmNTI4ICgiQVJDOiBbYXhzMTAxXSBBZGQg
c3VwcG9ydCBmb3IgQVhTMTAxIFNEUCAoc29mdHdhcmUgZGV2ZWxvcG1lbnQgcGxhdGZvcm0pIikN
Cj4gU2lnbmVkLW9mZi1ieTogSm9zZSBBYnJldSA8Sm9zZS5BYnJldUBzeW5vcHN5cy5jb20+DQoN
CkFkZGVkIHRvIGZvci1jdXJyLg0KDQpUaHgsDQotVmluZWV0DQo=
