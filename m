Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6022213222D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgAGJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:23:09 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:59362 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgAGJXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:23:09 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 947224065A;
        Tue,  7 Jan 2020 09:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578388988; bh=rF49R7wK663Cb+9DQWpm+psd5Who6XkF+k3pqUaMJXs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Q3NaHrBEI1j1PC9TxW2wvZoDpSvWZq+7FStF9JTtmCGKcLXPzqT3A7pRkHbQTtrM8
         ygeyQVD7umTy74bHg4h0aRxmxV9n73HmBEwc+nmNY+iOciRFkmxbyR1TzsSsT7I6SK
         znAgkmIKcx/W2Jx9RSRDEJszfphAGwnn41n5ZLkNjM+pM4sU5hq/xXJaMYJkm6eNf+
         dbe+AaZRg4Ih7hygQb+5U0wzqcxLfROeWBP+fnrQ3xcGo6GoBcFfEqYOF6gJg08G6F
         dFbj1J+F28hr682vOQllsgITRFlSXSaQtORuJ7v84NsFCuJGIQxfvaDBL5SdWClFJ1
         xYfyb/GkzR36w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 664A7A0085;
        Tue,  7 Jan 2020 09:23:08 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 01:23:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 01:23:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8FW3jwdiB7UKgSfFpqeWpewTdpHltcKygDk/gzpzx1nTfdLpxDGo+Kp7gn8DCdFsFg6gYZPWvteYw49rFxxJ2/7DPHlnbpzXs0wf61tfSgZTTOUQ5cv8jr5qiuHqUWJlgwGvDvIZ0YGwedPdyAyaqbfb3+4PQB0E2fIRBFX65dU8nVLfrJ2n5JZdg2wAmRsK2de8k7AkgIAqQwM0MvwK79UZLbQSvlDQsy8Gzrv4GEne+jITJCkNi7AgxoKQJ9x57Zee8FAtOybQkkV2bxC6CfGowEaaiBl+u2MSqHLsSr5irsN98C+zMEIo1KR8qSaJRp/DnOoJ8Er4aOZcofVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF49R7wK663Cb+9DQWpm+psd5Who6XkF+k3pqUaMJXs=;
 b=V9rB1aURFiUfwsHLd7J9P0hx/VXTdo7RU/s9ukxofbQv83h0MKj0LEp5WbBKwVv7cnT9pWY4FqHY+D3sdLkgJhkpTURgt6XOSt7SOfjzvg9Ko4roQ6y22Bd8EEmQ3t7TN5cGCNjMb5C56GOzcsZ9K68LoQOepHkizJQMtcp+v19EcKa9gDXIzg47p3MMV1ds59o/WdrR1YAcMS64+gcMkSfjZQfIFUbZ80xRTchC2ZyNRbFP1B2T3xk0FwAYo1AAKMERh0yanUziemKzGbUrdBYEsfA7sumggDSoLrsn8NJUhG4/HhD4KNH0WMPJwE+mKpESn1Rp+3IxDF0p5K8kbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF49R7wK663Cb+9DQWpm+psd5Who6XkF+k3pqUaMJXs=;
 b=jn37Pk7xt5RN4ohyWwbtwC8FpMVuzYrdo5cpAaZFC5LHGT4G1Vzu7nuT7DuPo0MnRdGJCTAQZ2o1uPx+v6js9V2MHMCbAK5SsTfLCMgPC1Se0Kz8SB5MM4LwyxBXGyVGW/vj9gXOsp9mttkJyZhEG309vD6FMLn7l4F+WTGrnoo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3235.namprd12.prod.outlook.com (20.179.67.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Tue, 7 Jan 2020 09:23:07 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 09:23:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Ahern <dsahern@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqfAhW2AgBM2+ACAC1GK0A==
Date:   Tue, 7 Jan 2020 09:23:07 +0000
Message-ID: <BN8PR12MB3266194DA97893C39EEF472DD33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <8230b532-ffe6-4218-94ae-2609eb9034c1@gmail.com>
In-Reply-To: <8230b532-ffe6-4218-94ae-2609eb9034c1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0313d5ac-88db-42b3-6967-08d7935334b5
x-ms-traffictypediagnostic: BN8PR12MB3235:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3235F1052C4CB90952706F90D33F0@BN8PR12MB3235.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:357;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(39860400002)(376002)(346002)(189003)(199004)(4744005)(55016002)(4326008)(2906002)(52536014)(66556008)(9686003)(86362001)(33656002)(107886003)(316002)(5660300002)(71200400001)(110136005)(186003)(8936002)(64756008)(66446008)(81166006)(81156014)(8676002)(6506007)(478600001)(76116006)(7696005)(66946007)(26005)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3235;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O65zhft4OygrBgTFS0in8l5/WXjRa9ML5aCPqwB05X7r/Lc6O0/yZSxBUmlnluW0q9bJAbIy1wLOU5PYbS8dUQBBOstuB+t7NUcLR4PAooEdc2u0w7ASdJxIycXR7iKkb6OxpXr0tNlymke17RTkJobBjeNVKEQ8GPE5MNtAKH6RAEH25+XgO/CPl4kdtuvDFfoK0fRJVgsc4N8LXnpT4wo8ysH7RTztlxlvI//vjg2GK3QwJU7j5hneMBFAxGB+KFVCco5JsWMWs3i8/l7hNRXUN4QjuKriqk0AbNubQqOtnNaWCEKgbK1vUxw9mIT8C3InWisPGHh5ku3PZFwuK2MDgY8Aov5rvAo66BjA8FxjIfI3VXOUYkoPOKfmRIwuhdfiDxrFnNJ1BFbSptgCRUZG5ui4YX8ZRsYIzMQjjb+BENrawSGUbQ25QBfQz98E
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0313d5ac-88db-42b3-6967-08d7935334b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 09:23:07.0868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y4cLgyad3KqXGIda9RGLlB72w38Zcx1jkkoTP2tW6surO8OLXNJULPTYTc1TZhKAWNTm5fqf+ouz1pooMID72g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KRGF0ZTogRGVjLzMxLzIwMTks
IDA0OjMwOjU0IChVVEMrMDA6MDApDQoNCj4gdGhpcyBwYXRjaCBoYXMgYmVlbiBsaW5nZXJpbmcg
Zm9yIGEgd2hpbGUuIFdoYXQncyB0aGUgc3RhdHVzPyBnb29kDQo+IGVub3VnaCBmb3IgY29tbWl0
IG9yIGFyZSBjaGFuZ2VzIG5lZWRlZD8NCg0KVGhhbmtzIGZvciBhc2tpbmcgRGF2aWQuIFRoZXJl
IGFyZSBzb21lIG9uLWdvaW5nIGRpc2N1c3Npb25zIChJJ2xsIGFkZCANCnlvdSBvbiBjYyksIGxl
dCdzIHNlZSBob3cgdGhhdCBnb2VzLg0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1
DQo=
