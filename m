Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B5136F4B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgAJO1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:27:16 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:35422 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728044AbgAJO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:27:14 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7EF45C051F;
        Fri, 10 Jan 2020 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578666431; bh=spvWNnDQ43HGJWweZUf+9BfsSoqekFWa3BaSoGf9XTE=;
        h=From:To:CC:Subject:Date:From;
        b=WzQhSWJm34Ks6ACA50Gf6/qVybZ4HfX5krfvOaOxPgVVhtwEzE/hzaYyetXOx3VU3
         eR0bsy+Si1UFZfDaocqvfCfCVV84/GMwrd2RAw8GoZ4YKh5uzoRBeQD9vIjvtjLg09
         CSDHJc3YdTTcJOQYrwQdGE355NI468oDQaweQfKunTKqRXYxRC6KSF/CrhJCgR8GBt
         hXdhfu0Gu0nxDG3xZ6tg96B/xrrg9N7rfkDZMNCjKQBldvtY8/wisSga8o/nsaf4EK
         jaowLlAcy6FM6ND/qNFPPjnX3lL3Ip2BivYpEy2cupzJLlcXFnaX0vS+LSjIWtYHND
         fNiC/LiJAyZCQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D9CCEA0069;
        Fri, 10 Jan 2020 14:27:10 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 10 Jan 2020 06:27:09 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 10 Jan 2020 06:27:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kanYd5q9UmaEG4pb/YsFDBDuZirJk5AT99T8YlN5BJ/hRwV2rflRy8JQfDCCs1tseuR4GD1/GatfRlVmflE4DftXi84GHnyRCPH+w83d3u8WxAllEvDEnPEwtbpetz5OU1foSK7tqc2mB8QKhd5ucdqzl+RQFxutDZPiYYtWmxPG1kMHSFsD4fXxlccQXLzu6A3VvbrmqbHyoukeXCGGeOcKjLqtJO7fUzOeXXK3bhemXJiDCJLcqjpPVxykbrZdVdPcyD4EdvOIO4wF9ONg7mn7pdQRshC4lIcda1p4Focy/vrthPvj/SUE/s4iUYMj2sGsKA8NQkJjZaVyIS0m6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spvWNnDQ43HGJWweZUf+9BfsSoqekFWa3BaSoGf9XTE=;
 b=DBC1jf+XtfvUaBSRLsyhCm0nwsFEjY8J2lIMH0VG6475Q91GUgzEwBTrcNXrN/DLwDo4Tx9IOeShsvTUKahkK8A3URu5+s5Ir9Ta4doBxm7VM2AhJJilut8JiGNndLNLvrJT0TA+5zj6GYRGdKko/qY0w7N5We9HKFSGeiDqgf+HBvwFc3vN53Kxc/KZqf0BanQaLJ489bKsmcTyQOZr9T/WjYfDCg9bDiFVtq1eKGWA1a7QsJ73nU/j3pLWrHg1cqw4SrpBP7knZ0E8jDgN5ND5p7Wn4BuAhbsmJUlNKxC7ZC13mA0zYLJNG9lsjf/DhdhlnV7MBtcRhHFjToY76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spvWNnDQ43HGJWweZUf+9BfsSoqekFWa3BaSoGf9XTE=;
 b=K7UdBLciROg0TQ/8qtVkIRdyOxqqYYYpDHX19C0f2dYj2odhsasVJj3xo68BbhdP5Rnw7tUchju4QFDlcjVsiRZ/MNAoKpcfEgEcl/xaFUkZq/GnJa1ku0GHeZJApEjD9kmecX5dwQ8uj0/4iJ/DJ/CGYWDlYxLlDtQQ2uRBJY8=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3220.namprd12.prod.outlook.com (20.179.65.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.12; Fri, 10 Jan 2020 14:27:07 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.010; Fri, 10 Jan 2020
 14:27:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: tperf: An initial TSN Performance Utility (UPDATED)
Thread-Topic: tperf: An initial TSN Performance Utility (UPDATED)
Thread-Index: AdXHwcCbzJKHePp2QTSnfpVPJ2shXg==
Date:   Fri, 10 Jan 2020 14:27:07 +0000
Message-ID: <BN8PR12MB3266D8596EA0B226E7A39C7BD3380@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 129e1b43-fa56-46a7-fd01-08d795d92c2b
x-ms-traffictypediagnostic: BN8PR12MB3220:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB32203CB70CC0F76800F91140D3380@BN8PR12MB3220.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(136003)(366004)(376002)(39860400002)(189003)(199004)(81156014)(8676002)(9686003)(52536014)(15650500001)(4326008)(54906003)(5660300002)(478600001)(7696005)(558084003)(81166006)(8936002)(71200400001)(186003)(26005)(6506007)(110136005)(316002)(2906002)(33656002)(66556008)(86362001)(55016002)(64756008)(66446008)(66476007)(76116006)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3220;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FwSnpqmuU9eiD/b5swH+WWBmnXGRWl1vsAfm0GonaTVGvO8Y1dy4cn1TuvjZb+PGKYZc8M+ARdjVDrhZhGaoqIH4WjhO0gqxheIzvlnT5TLxxfRha94livEsR2DGSQVm8Uo9Nsch+J0Y79p6uqw+btxO3h7VyIXFzzsDslLSyzdtR/E+3ktYmt44tWwA5LxxgRLU7ppbI6eb4CZRrnF0UtU+KlNtanf4bi9p5tsSdVR68W5kgTd0WS4Eb75C0xbMdTHPN2mMg2at+xYW1iFM9sgFEOYuLuL+f3iayfsx2CuRvAJN1EeGTLqArs7WTAvjUrLBq5icTNxf/U9TIxJwfAzJwDDYZI5XDgQtwFe4AKBLO3Zo7p7PSiQdq2pISFE11YKjYhBSXIkr9MTD7SaSYcyya7K0SaSk6TRE4XM/9BPeBL2t1ksxGat2dR1aSZxW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 129e1b43-fa56-46a7-fd01-08d795d92c2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 14:27:07.6767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AS9YbDz2GFwlbfSEdESuaISkyLaCg/3JwljMdqbW5t9BCsAgeuAVSUgBAdaKNB4Bq4+AM+9ElyKmZegUvDdOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3220
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you all for your comments!

I've updated to tool to also use SO_TXTIME and I validated it using=20
internal stmmac patches that add support for ETF Scheduler. README was=20
not updated yet but it should be pretty straight forward to use the new=20
functionality.

---
Thanks,
Jose Miguel Abreu
