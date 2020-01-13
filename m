Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D98139499
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgAMPSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:18:25 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:34174 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728512AbgAMPSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:18:24 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 953D6C05D4;
        Mon, 13 Jan 2020 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578928704; bh=vIVMqQ+erk968iyMWmEbUxM7qO6UHUrUqFS2ux4tVqE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YNZNAePWd0YNKlhJepst8z+mTecYdIVd/PHBE4Z7Z/VVNFk95rgMYNNWBnJv6+lRu
         yPclOCvciDh0AOmGXH8gt9fzdB3nMsmCtx6fUXpw9u+cPqM+XxXs0YJEiqnE0XZRzM
         jYwxEUYIbeJingQ60eSHYlFIEtzHr3PFZz1ShV2WzAEZr3kGwXwyJN4jM+xCkYH6nu
         4iVaQ0TA0Wd8j5zj97iOREWA/ZW1+YPPKqbvhOnpSN7FCEoKcWWa6WPcyFRKYXoX6Y
         wWDE8WDwFytutV/k+Zl+mQG42UA/JW9G0s+ORrgqVDMo8uo7IheVr+YapX2pQWP+Ti
         zb94tNCTUVDFA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CBF9DA0067;
        Mon, 13 Jan 2020 15:18:11 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 07:17:55 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 07:17:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LghclE1eEa+ho2yYmWMwJJuZIt/JKeECtpSsowg7vpaFtBezq+L/NElaI55SWlst1OCtUAFWfHNPTRDMA3rOV5VkQ0QTb1awBhYc6HkqPaBrbnVCbc6dJGLFE0B5o2TkqjwEOHNpX0LVCHdIBK1TxqQ/6Ux8XNO1XniP4UI1pTcExagUAkmQgAPnqVV7XZh6IMEW1+66M/J5DBtOjQDbA7IIXvnT+xcUgRGIXHlukWqr08nWGLZai7gU4ZlW93a6ImPTW2+QuJMrh9Yc1HugCNTpOgygduVUpptRkyCc+fQ71neBC+Ag7XHUuedLo97V3G6vjsHMBJnZS+OVGqwlJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8URc7DSE2coKTFOc9MX3LsD6FQgFXyZzBykovODuv8=;
 b=XvHfxv9/mIGq9kjfAzl5Tq2ZYZVc/OKlhngLevr+k3/VKwQoWEvz8DQFP0cooDmKRy+Lp9Of7LLzwfDM+jlrxgwVRLE04agXdY3d1oG966jHIGtChQyUhnpTSfxGqMpKSitM4SikB80rd5AcmbEYrIWW79GwztUfWf6cdoXebb0/BBkk2aXt5NzlKpDQ1YE1O5EURfJmM2kYD4jpGMuJCgA9Ad+YRiU37RTpQi+3WLQbJqI3zKxrmiku6o0hbpteDvfLR6M0MUKlgrHs0rhuUF04RUiUa6bQjkKoCT8/W074uWigVUpmuIBpkHZyhfrsymcYI2NnfqnkqGL+FfOa9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8URc7DSE2coKTFOc9MX3LsD6FQgFXyZzBykovODuv8=;
 b=ofKwYjxQcNkGwuJuJuPPJC70y4tqxRUT5Po9vw/gRqywstGlgwPtSix7Jbk9CEk+CjSz1mmSaQkuO/KUbY6SBwlFDJhsj/Kn6Hn9tsGLA4cvanLG9I+Ti4+tQeHzy+68ON9M3jj83ol0Zd81WKbLjlP5cGtvsZVbrgtpnyTa3zs=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3364.namprd12.prod.outlook.com (20.178.210.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Mon, 13 Jan 2020 15:17:54 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 15:17:54 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/8] net: stmmac: tc: Add support for ETF
 Scheduler using TBS
Thread-Topic: [PATCH net-next v2 2/8] net: stmmac: tc: Add support for ETF
 Scheduler using TBS
Thread-Index: AQHVyhHeZaAMCxNvxE6DMPSEiL9/8Kfos7SAgAABPsA=
Date:   Mon, 13 Jan 2020 15:17:53 +0000
Message-ID: <BN8PR12MB3266DFED453215D29BCF2727D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
        <4a4290706a9166d67d2d455dfa9d5f259699a036.1578920366.git.Jose.Abreu@synopsys.com>
 <20200113071251.1d9d51f6@cakuba>
In-Reply-To: <20200113071251.1d9d51f6@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7260e1a-7ba4-43f1-8212-08d7983bc31e
x-ms-traffictypediagnostic: BN8PR12MB3364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB33646FBBAF15C5BB2E79217FD3350@BN8PR12MB3364.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(346002)(39860400002)(136003)(199004)(189003)(76116006)(5660300002)(54906003)(71200400001)(316002)(55016002)(2906002)(8936002)(66476007)(66556008)(4744005)(66946007)(52536014)(64756008)(66446008)(9686003)(33656002)(6506007)(26005)(7696005)(186003)(4326008)(86362001)(8676002)(81166006)(81156014)(478600001)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3364;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pDwmkzEp1URt3wP5XhcXmuTNazqagL+tXb9PMIYgUz7s0CvUCpaMJhfdTteMcUWUOja50rzXrpCVENnYkoofGo7YLXPSz7QdIlz4xY4xU9QeFV0ulCzQB9PtUHQXSkvQ1lv9QpB4tWMd4vRHDBlwd13W+bMjy3HTZYyL3q4/r2QpbXtTaq81gfqem5AtdiMEvaV6+o10CB8Ubc4I2IDFHdFf5yV3mMJpA6IV4hPhwMTvWLRCzKiI7xc4/wGYPVFbDVpxF1b2jdVog+uyQ0+kS7ADYwf/nOTWDit4oKs83ZKbcMe5JiggbXJVV4F1nfyGqUV3w2JPPXQNsu7akTQHr/KIHoS7Iov+QvrqEmdcevoIdK9V7dpcv3KGNT0FrEnBoHPBkyMHtcgosyv1vGHk+ammmdf4A8ZWdo+AwlJWwLoUIzxLukR+pcZHgOYg/eKF
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d7260e1a-7ba4-43f1-8212-08d7983bc31e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 15:17:53.9264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LkJGNftVd91gN+Hb14ShQfsc/LnwmG9uJm9mjA+6qBraY+TWF0Hs0AP9rwbaBRHf7rWJuz1okNbvofzY6d6qUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3364
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Jan/13/2020, 15:12:51 (UTC+00:00)

> On Mon, 13 Jan 2020 14:02:37 +0100, Jose Abreu wrote:
> > +static int tc_setup_etf(struct stmmac_priv *priv,
> > +			struct tc_etf_qopt_offload *qopt)
> > +{
> > +
>=20
> There's a couple places I spotted where continuation lines are not
> aligned to the opening parenthesis, and here we have a spurious blank
> line. Please run this through checkpatch --strict, I see quite a few
> legit errors there.

Yeah, there are two errors that were left from debug ... Sorry :(

---
Thanks,
Jose Miguel Abreu
