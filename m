Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF76913920F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgAMNVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:21:48 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:35996 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgAMNVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:21:47 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 973EF4017F;
        Mon, 13 Jan 2020 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578921706; bh=uuEIoKzZgL+QRBwSc86eSUYVDzgU3yPNPFY2nmwHbZ8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=crE9676obTDiGgeWVahPEUJUHRV1Ll7ihzcUiQJl4e3oA5+acIaWSw549Dt9isTyx
         BUXCFzL1IhEDiI76bBwTxOh5dE4l+DOKln90V30L9IlGGbjL7p3b/ursM2lq6RmpRV
         S0sDsj6G2VU99dMyhbuqBzD0xzvmbtQP3qIt1fU3WBQVS0c3E8eWzvhjRf+DkfQkfX
         GHyt4NSZJEY5N/i2lhDwf0S5n8r9Hu7jahmc0RYWNXOaSW2RFpo2ev51xvnGARDklu
         kDNAmfSv2de4O9jET21VYzAz+MNPjKbiQKr+HCAUWf6gzdPyAhoTP5ZBFVr038CJni
         RzcTbGks3pR7Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CFA5BA007A;
        Mon, 13 Jan 2020 13:21:41 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 05:21:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 05:21:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhXTUbDMzfWJXF2Lf+h+C5Hxf48HrdDzKUiHsiDdibxL152OO5cv/TAA5d261sysuWpvbDAf0I7wChwtLV/KQ4ff7wtn5b3Oqmmpb86nfjUaxorBlIkFlW0ACKps0jX2eh4taGcfaGwHnmcI6XCUQ5aLzwmKjr/23Zxk1slFVsCtqwTF6aUcLBUhpBdpEaiuND5RYeZXGn+80kW8huEI8rPqYG+66u5bPapzXXOuXmZY+ehC5KcUtBXoo5GwV03lnEHTDXEDCqx41rD3GJGyPLlOEb6x/GrkNuoVGLTO89tt+78uDxOZ1GbSaM1i++lTrDDQXcf0jRv+G4Tjz/bwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuEIoKzZgL+QRBwSc86eSUYVDzgU3yPNPFY2nmwHbZ8=;
 b=cD+kkLp5zmrS5j8hL0oAOY4KA/Qw8Zc0ZshXBIb0ELOfp3WoNNYh1ZGdwg7z9BHAMhn7r26MIaNHhlKpt6KVKiPy9Z9Yzs0hn6ZUuAAMwdN+2Z5UCIhjGo0bTLP33hxJ1OBgNx5ZPAH1oSMTTqklyUZz+id/qXa3RZXFIvvtbvgRgLXK5PsbfqfPUekcIYdjhO1iRWdnjAW3HMUITO3RTxbPe7yPwF4gpXcZoQaeB3cD0KqW7CUoxmRHsUn8XIOnK4rUpDw+mmp0LRrIwnI16/93TjCjnrEVVOUfNZ2VK4EGn5A1dxMozxeAL4NY68maSllXAsdsGA0UpHqe9jAUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuEIoKzZgL+QRBwSc86eSUYVDzgU3yPNPFY2nmwHbZ8=;
 b=YOvZq+Bl91B+OjetxD0/ZUYwUoqgFwc0bOpn0gxh5rImJg6fighsh6Dod+cIlWoktkiJUdDNbccshoGroiYaKBgs2N7WUvYOibd69FNbZWoZfDz0sb6OTdMAndcPLZAZnZaSuOnmsahPNqLb0upZJlOgO+bzzqHNcQX68M0OOBo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3300.namprd12.prod.outlook.com (20.179.66.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 13:21:34 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 13:21:34 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Leonidas P. Papadakos" <papadakospan@gmail.com>,
        "patrice.chotard@st.com" <patrice.chotard@st.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "jayati.sahu@samsung.com" <jayati.sahu@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "p.rajanbabu@samsung.com" <p.rajanbabu@samsung.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        "sriram.dash@samsung.com" <sriram.dash@samsung.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Linux-stm32] [PATCH] net: stmmac: platform: Fix MDIO init for
 platforms without PHY
Thread-Topic: [Linux-stm32] [PATCH] net: stmmac: platform: Fix MDIO init for
 platforms without PHY
Thread-Index: AQHVtlaLUHdZtR9zLkianwxirOcjq6fEEoEAgBiSRgCAABukAIAADA6AgAH/EgCAAIDFgIAAA9aAgAlrTQCAAABlIA==
Date:   Mon, 13 Jan 2020 13:21:34 +0000
Message-ID: <BN8PR12MB326611C6FDE8399F554ADA65D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <c1af466d-0870-364f-1bff-0ac015811e60@st.com>
 <20200113131920.13273-1-papadakospan@gmail.com>
In-Reply-To: <20200113131920.13273-1-papadakospan@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92621df0-7a4a-4f03-5764-08d7982b8307
x-ms-traffictypediagnostic: BN8PR12MB3300:
x-microsoft-antispam-prvs: <BN8PR12MB3300075D8C4AC7CC6FF9E61FD3350@BN8PR12MB3300.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(136003)(366004)(199004)(189003)(26005)(4744005)(54906003)(86362001)(2906002)(478600001)(55016002)(7416002)(52536014)(316002)(7696005)(966005)(33656002)(6506007)(110136005)(186003)(5660300002)(76116006)(4326008)(81156014)(81166006)(66946007)(8676002)(64756008)(66446008)(66476007)(66556008)(9686003)(8936002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3300;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlD8gdQhbixOihlNzTtlSkgC0Z1/ZZb+BbzmmW/mBgi7lS0UvuDfVltPV3GS8f5DAVjAd9laLR5E+PSP1pIHu7u4kidxbZLmx3itK2jgOQSUTtTrIZqnKEOYu6Dbiw4JdllVOsQtfy/4zL+VWzwcs/uShKVPCa4nMH8iLiNRdiSS4PhIJD/wiIEPHsp4owypBAUFFsX0HSz5vDotvtEtaK+ggdJBBv3Tt04eF8Iq82V7fWR/EyolJSMHnxxshwA2wLofmBeQ4Q3hVqP6aTgihrP74Pwpj4y9mvJNsc0vW4OGmqZoAdZ1HdjurGIuzB1bqhtuf393UyL67VBOVOytX6/Ta18q5QyI6xj8LnLZQz9vF0Z8Il2Noy6PAQPOE+2ahpWxsOoDUiJ/Cnn5oI9Am0JEMYZKu8oRB7ZVz9YXsTKTBbru+n2sVqT0M/cIjE4tP/ppPu3UEyFw0g85Lj5ni6IEUQuYfgwP9G9Fx7jhKsAgnvy4bC5J/5ChUxa9sO476eyZOWs0e2O9IJ7YwUXmTQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92621df0-7a4a-4f03-5764-08d7982b8307
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 13:21:34.4557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dIv4mIHj8LNjuGGEB6QVJoSB2mSn6TFnLVPlmokPzslTKQ3Uhwpuy3C5AYcDH5DX8VMpLuNjVedND5Jk0khY0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3300
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leonidas P. Papadakos <papadakospan@gmail.com>
Date: Jan/13/2020, 13:19:20 (UTC+00:00)

> This change affects my Renegade board (rockchip/rk3328-roc-cc.dtb),
> (and probably the very similar Rock64) preventing me from using any kerne=
l after
> 5.4.6 in a meaningful way.

Fixed in:
- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3Dda29f2d84bd10234df570b7f07cbd0166e738230

---
Thanks,
Jose Miguel Abreu
