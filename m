Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9252CCE786
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfJGPbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:31:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:53452 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbfJGPbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:31:21 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9A63BC037F;
        Mon,  7 Oct 2019 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570462280; bh=NfJtzYMTfHdjHO1PBgbzSaEh++T0F0G1nFTtAr8J8Qo=;
        h=From:To:CC:Subject:Date:From;
        b=Hh8K9JR2D1kgrTrjqmBpGdadX8AYPkpkePXDIhp+6LRpjjzI9m+Si0S2ooG3QWknw
         LsnBZtbh24vrGzeZy9RXngQ35doO6Z+sYUEC2MPt6V8pE0CoMpcX/ZbUTP0Z9TpKyr
         cMJuw+SUbud4+m1arSoIHieJ0FXRCjGYI/LoIDiGyHsWgyqs1MkV8a/I0spKAwLEfN
         /W41su+nEQnHwrz3eUh7RLbc0oqjQN8nVHrXazBl0OZPiSUqLAddV7Lq2T6WFr0v2p
         ikNu3RJNraRc5YMfklVuEWR4YczY1/eW6YfEHzDIeTPnU34MHFwHFFNyVJQA9o3HJ8
         yvpJQsnh+8+LQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 58A17A005A;
        Mon,  7 Oct 2019 15:31:20 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 7 Oct 2019 08:31:19 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 7 Oct 2019 08:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp0Wwv2uM7iwgXAr3TPIB9e452ilNDD0mZJOQIBOdg9qXREX0EWfNESpEKbtal+cP5xIlQYXI/YungBHgprEJ5iU76I4LE608MTKEph0QscO0BoF3kSIM0FpuDSAtZiBPfAfLYCYiuQ6UITO5tR0ur+gZshnI/1Mcn+T2VnV7Zk7lZ1xin0wcHx8nqujenfW8R1ktkw5IuzNY9HXLrInzJ3fuBZEZaXvjArZvijSZs43vVJbqMSfz9k79kDXWdDI/iJNuD3tfudP1DZLgbxqUKcgBcG8W1Ii6ZyHik0xF9SvPdol7FH9nPqvTXtg3mL9Yi3Qg9pz+zxCerVkwzQ99A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfJtzYMTfHdjHO1PBgbzSaEh++T0F0G1nFTtAr8J8Qo=;
 b=VRTrmAX6utdYnpiLdUpuD6XGlpUwvPeGqYmcBlC18T8JgjCyLLg7FbLqMyrzBHedN4DJFbRq6VpEY9FZuQx9PVcBUT7LAZyB+kvpCwgDUdxcvWiLZS8TfozxpQuKFU4ziJTo2WxtmdTe5Aeh/X0A9bzuxpy0LJ59d7PreiT6sHqZIfmmoV8AczQGg2EzM1TF9VruqC058SBWXdnSn7Tgck8zA1gjmznUwIENADyY+yGZwqHMkYUOEVplFkDzcy0Uqu5n62skDaDKe7D342qszonIb8ck6rXnhIWeVxFC5Fvoe+FjJbHBxWzPjpNbUIoWqcumS2d4Y1j006XmWQhM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfJtzYMTfHdjHO1PBgbzSaEh++T0F0G1nFTtAr8J8Qo=;
 b=nQmPtgdbFI3ljhRjF4xFBI+XZiZnHsGLT7OakUYkoIslfZNw4MUUMOTnAS7EfOJRKVZr246Eap98xQx76ycoUNvlgVfPdg74kHjbelmy/PuXHUH1XiUWzDjGSk0GbaLGCqS4ifSsNXPtaQKTeH9LLVc332o23m2UXm8Wn7PS/9Y=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3459.namprd12.prod.outlook.com (20.178.209.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Mon, 7 Oct 2019 15:31:18 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f431:f811:a1f9:b011%3]) with mapi id 15.20.2327.025; Mon, 7 Oct 2019
 15:31:18 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [RFT] stmmac Selftests
Thread-Topic: [RFT] stmmac Selftests
Thread-Index: AdV9Iyg3hIIizkerSPyTtl3Mb/iA8Q==
Date:   Mon, 7 Oct 2019 15:31:18 +0000
Message-ID: <BN8PR12MB3266FA3776F3173B15D1F90BD39B0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d477d46-95c7-47a8-d361-08d74b3b6642
x-ms-traffictypediagnostic: BN8PR12MB3459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3459076C89D9896170E63911D39B0@BN8PR12MB3459.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(26005)(102836004)(66556008)(66476007)(9686003)(64756008)(66946007)(4744005)(478600001)(2906002)(55016002)(186003)(2501003)(66446008)(7696005)(71200400001)(71190400001)(81166006)(54906003)(6916009)(76116006)(5660300002)(8676002)(81156014)(52536014)(86362001)(8936002)(6506007)(6116002)(305945005)(316002)(4326008)(3846002)(7736002)(14444005)(1730700003)(6436002)(486006)(25786009)(74316002)(256004)(14454004)(5640700003)(66066001)(2351001)(33656002)(476003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3459;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uBoIDBnLKJZR3uLCUekpayKIM9t8Z7qIgM5GLsIkMq2fu7379FifxyB6Choe7ozuF10PlCkpYSv/DlDzqSsMA5nftitjvPbqVUASD+68CPg8yKV2HqE3HC/9+gg5FiCleD6JvuqXVndoslzCMHtWglV0f8bn85bJpbRL64dkq3Bop8sp2tBy8Rq6OBYV3xinIgxkTj4wzBeVIJRSowIpDLtMam9bKtFve0a8n/5Oiq/Q9AzqWkn+MLCadCTSkyVcWxheTsUxu7RQ6UK5NetfG0d4MOEzhCF6J8kP9ec6TNFSRvLFxtmfOwVikU26rI9WhzMbepmE8Gf8yv+tlbdeb9aKiimiPiuHtwQ6RN5V/UhJvWne7KrVNeehhDWewCDrVY9d40+BxskpA0oqEOrDeu8k+7F+R7uBo/D+R1w8mvg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d477d46-95c7-47a8-d361-08d74b3b6642
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 15:31:18.5244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMymrPxtmp+wH9dZH5m+gn0iPJzBn7w38eSfQbudjjJbjEw4WG5uvUxtzU6b1gpFvx/detuh094cfnOKbiqsrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3459
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi stmmac users,

Since 091810dbded9 ("net: stmmac: Introduce selftests support"), the=20
stmmac driver supports ethtool selftests that can help diagnose HW=20
mis-configurations and SW programming issues.

I would like to request all stmmac users to try running these tests and=20
send the output to this thread so that we can try fix more issues and=20
make it more stable.

Appreciate all the info you can gather :)

---
Thanks,
Jose Miguel Abreu
