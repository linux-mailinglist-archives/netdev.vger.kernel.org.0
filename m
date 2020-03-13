Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE471848EB
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCMOM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:12:26 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33094 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbgCMOMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:12:25 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B53F6C0FAD;
        Fri, 13 Mar 2020 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584108745; bh=dK092ZStMcpJfLv1Zi5vxQbrvIHTEKlEuMUGMwAVQhA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=aJ5c0RSH1tv150l2asoh/BINWxodvTlZuSmyJ/hJZEhRZC7mfTU4LWMtx5hgHwa+G
         51/EXkDUw0WCd8ef6058w+mqudcdaIA4lxm64uXOca2Xj5OhDhXaM/n2R99gzyv+Pm
         u+0ltlN2l/LuSEePYdvqg6CUjywqE4Nr+v/nTX31yAiIADo1ZfE+9oRXNnQc2VXtTF
         loNri9m5y3HwQgDjMm0hKw/JuHjB0sHkQqezbtCNZigfT8QKSD1ha2QoZNy5gt6sSW
         cXTXIz3acwIA5W+nNnMFjnHPA3fNPtv/dw9cepCPxD2nqqsNlOhZzBP84Gy+/pCkPk
         EDHvKBnyIc0ug==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1EC7AA008A;
        Fri, 13 Mar 2020 14:12:22 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 13 Mar 2020 07:11:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 13 Mar 2020 07:11:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgkmngwqCauQ+WgteU5rACs5v01KFKO6gHk37AkxBeeO6PCq3PlYwoVb0SzliJkRAxyPsQFOjIVPjTv5JHajiEwQC6KsDpfnhzJN03LPBEW8N8YdS4JAdrt06939GPtGluyZ6LJcnVDZa1R7EZvEhdryRlExqmOg5gB7GPVeekRDsJ9dz5buD4sZgPhesxWapkuVkR2e/eyzX38kTSXCCFJO9AYCZq6xMt2T2VGev+Gb8XCJpyqCFhb+RC0itPMGtokDdhC70GKCKd6oKLsgV73Nliy3J4VRw6/5LvhWybr2nzqR53nIoFoKqtVQKV+addQOPTxI9TYa9KF6+C8RQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFQT7AW2IFUHXX+1hxyIaEC8DTDiAPapvdE1eNdfBfg=;
 b=PBZ5oK59GTHY0s3oQAxXp91w7CXOpxtULfWCSos0Yb/zOq6wBHFEzHSuUu4O5DdyQRrfYkPBqBMVed2IIafD72lnb2TH6ZxjKFZWUjAKSx1zdibaqWcyvmo5izrt/77pS76P2pc4p9OkD7+0GBvwP4NCdQmNRN8HTGjVzjrnhmflzOxn5c3J7Zq60TFmQDo9kF+gt8R+IGjcgOtSRS1cSdUzmwlaYpQCjiF6vzNUVLWqW+VkLArV+cZwW70AM0J5dWaCXLW5G9aBRylPjJyRAQvVZzs5kj0h8nPXiF5UDog7TeS+ujucsQvbMzmlt0C/dfVuWxdHVnnHSZXPW38tvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFQT7AW2IFUHXX+1hxyIaEC8DTDiAPapvdE1eNdfBfg=;
 b=JQTE7N33xQ8VzxUuBkpwX/uBQPPydwXzSqhuKfv5Z+WnTSGCpEdv596saHNOF8S0fk0yVIoOwGqAUiH8iFpB3h6UU4ITR5aCvOOXP5uyrGA9UIf/+DY+wk5uTm09Xpx4cmdPTAC6IHvRCLqgfHB0aQjNQaEwe8KSBRFlF99Vl1Q=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB3539.namprd12.prod.outlook.com (2603:10b6:408:9d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 14:11:36 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 14:11:36 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] net: phy: xpcs: Clear latched value of RX/TX
 fault
Thread-Topic: [PATCH net-next 1/4] net: phy: xpcs: Clear latched value of
 RX/TX fault
Thread-Index: AQHV+T0DV8FPfrDj6UiwCwoiz8iVCahGjUYAgAABUYA=
Date:   Fri, 13 Mar 2020 14:11:36 +0000
Message-ID: <BN8PR12MB3266F7ACE6A778CAA883F8F1D3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1584106347.git.Jose.Abreu@synopsys.com>
 <50f3dd2ab58fecfea1156aaf8dbfa99d0c7b36be.1584106347.git.Jose.Abreu@synopsys.com>
 <20200313140122.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20200313140122.GC25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0218ae8b-a6fb-4996-2bf7-08d7c7587158
x-ms-traffictypediagnostic: BN8PR12MB3539:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3539373888F13A6FE25A5314D3FA0@BN8PR12MB3539.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(346002)(136003)(396003)(199004)(52536014)(26005)(478600001)(6916009)(2906002)(8936002)(71200400001)(81156014)(81166006)(5660300002)(8676002)(7696005)(86362001)(55016002)(6506007)(66476007)(66946007)(76116006)(54906003)(64756008)(316002)(9686003)(66446008)(33656002)(66556008)(186003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3539;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXLVpY8kmB5tNBsZLukOdO8A87KcLC6uQyKHJ4ejegMoT4z7JBBifrzT/2JbReA9aYXoeFNf6mNASAi3WhQcoGFng7oIvele1uC2HKEIE7FwaHt9hbLIXW3+1Ts2R9ijmIj6l/5qaee2HPW51FDVARD4QwkK+Ue+/0FwWOUjYBgbwS56+jkbGS0aMXrRPpMxKONdSJHqmbv22xi8Cbe65U94p4CyORm97rXRbLGZwuQJgtUt1lshweFI3vzCdPAKAx+xC7EkAIAnydzEeObP25EOzdQyVp6dyTfxqaaFt50a/YvSVx/1/UYGkuOJAgBkqrd285GEMJFJpEu3BL0juoGbMpClH71Vqwwd+nb25utHG2bEpLXw9utcDaYgGaPhXmG9CXbomXwA11jjKVZxqZtLUeXhm0CIMt4daec+B0ZI8csIh/UBNcNxA7X92XYT
x-ms-exchange-antispam-messagedata: yY1ycO6q3YjNv1XAc8ZXnZRfe/oNYYEM8Nc4fLB8qJyCntTMO0NvJxe4Dbhv3K7/n1u3y1rzhdmRci8nlIGN9oGHpgfls9lB/VaYEWs3Q85d2JQT/KhmzJnn2Q7t54oSsr7hjBofTetpMM1j2qtIuw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0218ae8b-a6fb-4996-2bf7-08d7c7587158
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 14:11:36.6928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4nSbclHA1gax5BO0ay3MfiQ/LHjOx5R1QoNW+y7SJDwuNcTgPVPEouheGGiPsIXBveQ7D8WRhxgnCRdCO1xxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3539
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mar/13/2020, 14:01:22 (UTC+00:00)

> On Fri, Mar 13, 2020 at 02:39:40PM +0100, Jose Abreu wrote:
> > When reading RX/TX fault register we may have latched values from Link
> > down. Clear the latched value first and then read it again to make sure
> > no old errors are flagged and that new errors are caught.
>=20
> The purpose of the latched link down is so that software can respond
> to a momentary loss of link with a possible change in the negotiation
> results.  That is why IEEE 802.3 wants a link loss to be a latched
> event.
>=20
> Double-reading the status register loses that information, and hides
> it from phylink.  A change in negotiation, which can occur very
> quickly on fiber links) can go unnoticed if the latching is not
> propagated up through phylink.
>=20
> If the negotiation parameters have changed, and pcs_get_state() does
> not report that the link has failed, then mac_link_up() will _not_ be
> called with the new link parameters, and the MAC will continue using
> the old ones.  Therefore, it is very important that any link-down
> event is reported to phylink.
>=20
> Phylink currently doesn't respond to a link-down event reported via
> PCS by re-checking after processing the link loss, but it could do,
> which would improve it's behaviour in that scenario.  I would prefer
> this resolution, rather than your proposed double-reading of the
> status register to "lose" the link-down event.
>=20
> I do have some patches that make that easier, but they're delayed
> behind the mass of patches that I still have outstanding - and trying
> to get progress on getting phylink patches merged has been glacial,
> and fraught with problems this time around.

This is not link status register. Its TX / RX fault and its latched high.=20
Link status is another register and we only read it once because of the=20
above reasons you mentioned.

When in 10GKR, this seems to always go up after link transition, hence we=20
added the double read.

I just read your reply to patch 2/4 of this series and it looks like the=20
two patches are correlated.

---
Thanks,
Jose Miguel Abreu
