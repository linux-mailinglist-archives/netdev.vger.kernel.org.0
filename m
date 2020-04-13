Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA87F1A682F
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgDMOb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:31:59 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33822 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgDMOb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 10:31:57 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 017E9C00D4;
        Mon, 13 Apr 2020 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1586788316; bh=XU+Pdp7n8Eh/O63P/VRQFtJrOZ1cbiUbe1bpAQxRjaM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Wg/xeygOsw7Tt9dxLbF4zJX120Idwz1p70tCQPNAYWPnbMKObZQ7abVQJ2Qp4ZAvB
         vea8I9xmLHHxzNXD3p8/a+5jS/nXTCuBfVUpnim0UmCF0QXLyamsG0B9OFaY2Ko02A
         AETah1FTZzr404OKwHxDtVmMBaHKkpqEHcvkZqv7EH06jc4QPs8CKoN7RuIjvxEpfX
         8wuq7DEldQ5h0AkMekWoVqxYFBba1JhPuvyH/wIkIRxMrhVLCrj6Lahlv81aGyP03W
         1cMYb716wxGCw8NtySUXm7ajL5FP6caQrttX6v8alD74TokTCX8/5JKO659IbdFeV2
         hiTaXrY/7XM9w==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 60987A0083;
        Mon, 13 Apr 2020 14:31:54 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Apr 2020 07:31:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Apr 2020 07:31:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UH3GOVTaHQszEPPiQLbrf7lFfUeMu2SDiE0rQ+YD9SurkBBstZQ3l0tTjPjrTILpSi2tj3rKiu3tIxEfnbuJiWFzGb+VMGJPwiGHWrhurwaUsz5DmNWZMyLcpDS8riR++iflSVTyOR5nHJWaiHNcpVPzkWr1YCYbcVxqHG0NeeKvXWfzZPMHK5zXT1oeXhBjn9058jYDp+FgMwcNQSOId37AHSw93FZc7beNuS7D+jiE/Q68ROCB+0N001x6B00jiPDPzFx86/k8K5I0ZqOnVL+GzcVw5QZ5vpdK7bfPtUy651euzWk5WFsZbYWgC39QsoVauEa6W62yqi4O2jFHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU+Pdp7n8Eh/O63P/VRQFtJrOZ1cbiUbe1bpAQxRjaM=;
 b=gOhk0YrwH6IVpni5dPAJDyLhOnm3JzEJxyI4Z65TVAbBpxEgF5GfJqZH+YnBqSoEJma+6IV325IWJi4eXBAaB1EFZ0q1IUcizp73UqbydFBvpST4uazvtPks49wzlr84qcyd9aQgCGXKpFZ6k6q6r+VRLZG/7NijKYQT56nNA7ok5dBe9SzcJKTg3HgxTUJfz4duQXLYrdwzsleMj1GPiMmvw0l/BLzNeCfaGvE69LadUEJ1RAmiT3WEiLrhRdaEn3Pf8ZzKn+xQ0HOAdIJuzginCXdHJpROYpxscJROU//iNDxGLInpJG6M6FSZuzAFOg6yfuriBuz3Hbqvv6aySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU+Pdp7n8Eh/O63P/VRQFtJrOZ1cbiUbe1bpAQxRjaM=;
 b=UgIUJ0cKbJJ1eklTCyf/rYPBpwWMqeVN7SzTgaHBAnOHo2GaUPL45s3Qkxb1pUbRcwsW+i9AwewJ6oEw21M0clbsen5eydiHAeIiTdugfuwe5leePmdSCj0RKdmdwbV5fFuofzHgjUrd1Ti8OXfLFC7erbvxO152TZg4Zq8JI0Q=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB2916.namprd12.prod.outlook.com (2603:10b6:408:6a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Mon, 13 Apr
 2020 14:31:52 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::651e:afe5:d0fb:def4%3]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 14:31:52 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     David Wu <david.wu@rock-chips.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC,PATCH 2/2] net: stmmac: Change the tx clean lock
Thread-Topic: [RFC,PATCH 2/2] net: stmmac: Change the tx clean lock
Thread-Index: AQHWAcBbH5bOP5X8O0OfeAWbLj2RKah3POrA
Date:   Mon, 13 Apr 2020 14:31:52 +0000
Message-ID: <BN8PR12MB32665A2AA9302F64C1F4871BD3DD0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200324093828.30019-1-david.wu@rock-chips.com>
 <20200324093828.30019-2-david.wu@rock-chips.com>
In-Reply-To: <20200324093828.30019-2-david.wu@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e5c1abd-d4ea-41d3-350c-08d7dfb768e3
x-ms-traffictypediagnostic: BN8PR12MB2916:
x-microsoft-antispam-prvs: <BN8PR12MB2916D6C2B26F3E23FB71F4D5D3DD0@BN8PR12MB2916.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3266.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(136003)(396003)(346002)(376002)(366004)(71200400001)(66556008)(76116006)(54906003)(110136005)(26005)(33656002)(186003)(52536014)(64756008)(66446008)(66476007)(66946007)(81156014)(9686003)(6506007)(7696005)(8936002)(5660300002)(558084003)(2906002)(55016002)(86362001)(4326008)(316002)(8676002)(478600001)(142933001);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: woenLBkA1WwqbynJno+G1vslkkbYMMMFsEnTi4ZNhJ5vqE3mBsJj9snFv4UPQX5PUxOLZWqrNZwe67rYQkq+eBj9IfdL7t8lf5ZAEt8zHTxYsQ9IeQnL1OTregaRSRFWO3/MADTlZz+IDVs0PkuaKYvDQnd05604s3oFHlFZFvDA4gRib4o9zkxZ+iQq0uhm8Cn2U3xBW9pvNnx3m2A4o+qySvLI2Zx2SGXPbMyVtL+N2Js5lcJkM9sbr0BCxWzNl3DrKaxT8UE9q5X5ajlkNyXKLYrK3uMMSCEAyqr4k6/IxDMbS99QkjksapP5UOq1f35ElvEtuziIxq5SJuSwIsNAIF5p2bjNatClPMCsqEaxaDYzq5qsQP/z2IbAwaKejrLIeCmfLM3dnU944hJZqlavzLeFen38Wqzo4PTf7B4F5mSishK8t8RF6VVaVLIL600gtAQVGTjz3XwoUrx/6pfnukMTlRFDsZNGMNcfxU2qrLKYOnHMbsEMsl1883Xq
x-ms-exchange-antispam-messagedata: itloKvP8t9LfvSGvhYkz+PuN37xQFEv0mjQb7pFcRaZVrebKrCZqeBvi8FJ6WN+KB7Hu7DsE5fhcOQ00PcQIDVLkTE9zFMT+FEVfg3rpVWqWTo3Rj+Aym1WpzNt1+Ro7Y2b4CjxGFTAaR4ObO9IXNA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5c1abd-d4ea-41d3-350c-08d7dfb768e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 14:31:52.7204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3yvXj3zqYO7i+8q2aSzHYnTrQ8al1oN3OnBC/eewdxwSsg75m6wKu+C85lHHxPMIceFsvJb77/dcy1evikEvmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2916
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>
Date: Mar/24/2020, 09:38:28 (UTC+00:00)

> At tx clean, use a frozen queue instead of blocking
> the current queue, could still queue skb, which improve
> performance.

Please provide performance improvement numbers.

---
Thanks,
Jose Miguel Abreu
