Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5881889BE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCQQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:04:40 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38042 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbgCQQEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:04:39 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4CE29402D3;
        Tue, 17 Mar 2020 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584461079; bh=IEapErGx1GPb/LDcQqKK+waiT25ShV5DZRDwLwzeWzc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=g5caUmTDfbklpWrPjFNsuwlyEnQGI2JQE+mSkrQZeag/luKymYtQjFbOY9WVPJExe
         b/L3fDCq/h8JdSTDX9zW74yxD+0MZpRfKMqoE/lmKamYgN2kQ6UfxXUOqlS1R9Ga56
         ln2/fSMeTfmg9zuqGljDnDjFPl+4GG1GftHZd8olNIbtzOjHRs0032pznnYK8oUqLY
         aLrg2gycMbopMOzJpNWktE5KHGfOSWocbYwG8UqGdgnEXTVw+CR3qw5coXfzlHruIT
         qf63MFZEWMU2r+0asqKKJUhvMjBc0+EqsKnNPk5CpKU8K57Pk6vpldUaaQVBzbf3uf
         KVB993Sv7dVSA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E67E6A00AE;
        Tue, 17 Mar 2020 16:04:38 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 17 Mar 2020 09:04:31 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 17 Mar 2020 09:04:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fdt4TMpSVz/l+RxAI4TgdSBkrHIxHrKeKQ6jWCH5KJJl28wVxoscPQrZ2LbStU1IHgp7yQde2TE+NI62fSh0AfoBKJk3aYb8w2U2YxNTdbCHJizTqIQJAaF+ackkgh/8XZ3Js/lQnFx/BbRSSs/uXnSiUPfAbKb4Og6mNnuz3KKB4sw/7EIWQAkocFV1Zo08yvmS8RdzItjWpeQAs6QQiikce1ZQGXPsSphG7VHMxvybz0Wa/owjr/ETQHDb36PUWLFmdXQnh6TTrRfhWtNJy/eq2bKLfoaPqA/fqZd7kd+Rgb3YLqf2gi0CTEPNvrgjWp4NIrDm4HnGk8bnQZQ7Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCB+BzgJpHY8/1I0KuyEwp0jfU6w52pBDvOcz9HGruY=;
 b=e44S5GkNOKzoh8vuPPr5aUG4GdLesQMlebClbP3RXvyHLuliJYKxMDAOEydOSCPnQ53hXt7p3yPNmuAKjyiZBjjiAzoZRhgS1buAfSrZR9s2L0ZlLPVwRzH7NwZLKYP6CnMPZ0LYhV64W/Pg4XFAV8Qc9lzRRp9elY0gCQzJUZ10fDKJwbQ9vfEjc+2k2QNwpjtZBK6Rco7XjA+YXUGeluMJBR2qjUXPVwiRlrxX5PVAjrivLHHQqk09NXKRT6wks1FC4WD2zyK8MhUbNwWuCEJzFnsMmUIzccK0W0B1CWsGMdKFx3+RgLptFCKAut4d/RzArQ4ZpoP/zvMskCs5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCB+BzgJpHY8/1I0KuyEwp0jfU6w52pBDvOcz9HGruY=;
 b=GqRWXe/RgElsrtF0FkKUKuW6KMGI+7wofDFvynPQIqcyCC1k3pOESbM0X6SG6NxGmpCFonyfbLuc/uhFTc4XTjtQCDumYPi92EYhM+snXWZyNsH9KYylkYnYOioQ+u2fxiISiMQpBZ3cfpGDH9O1eGFNvSIgkSNSXjnfvYGAJ0I=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (2603:10b6:408:6e::17)
 by BN8PR12MB2948.namprd12.prod.outlook.com (2603:10b6:408:6d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Tue, 17 Mar
 2020 16:04:28 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c9ed:b08e:f3c5:42fa%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 16:04:28 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Topic: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Thread-Index: AQHV/HG4xNUA04fN3kCshkX6WTztf6hM7DowgAAECQCAAAETcA==
Date:   Tue, 17 Mar 2020 16:04:28 +0000
Message-ID: <BN8PR12MB32669A0271475CF06C0008C4D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <BN8PR12MB3266FC193AF677B87DFC98C2D3F60@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200317155610.GS25745@shell.armlinux.org.uk>
In-Reply-To: <20200317155610.GS25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e47c3655-ce7f-4af3-eee4-08d7ca8cdf57
x-ms-traffictypediagnostic: BN8PR12MB2948:
x-microsoft-antispam-prvs: <BN8PR12MB2948977A2749AB8277639F98D3F60@BN8PR12MB2948.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(9686003)(8936002)(55016002)(26005)(5660300002)(7696005)(54906003)(478600001)(8676002)(186003)(81156014)(316002)(6506007)(2906002)(71200400001)(76116006)(4326008)(33656002)(81166006)(66556008)(66946007)(66446008)(66476007)(6916009)(52536014)(64756008)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2948;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RSoWT2hVBaWn67X4Q1OcDiMH8kaRtUw4FJc3Ql4PXi5bZrlbC6TPYt07maGxLSrfI9bE3wweTWzQsBoKsg1qV51SF8k99XvFG2j/lmADpBQ/AxaPtRG2/PtVi4klCfTQPV6euWbIXwtPYl6kvfIzFD7x4TUu+OcLocrt+B0QddKVytAlU50Se/pQGQrH2JBMdK/LBIiZzk4cm7N6vgDyIleMEMomqIldFt0TEez+wZh4cxJIXb4fVvr1y7KqIZ9Qazt2X8YrEuPWiGXuc/nQLZpjrjvznKkRQhTjJEjg8KdjO38GIDJVFLFMrz+hHs/0k7W8+IjL2OgW93cWyZvs4cJU+3sEri9eWMXV2lAdWyyDIJEQy6XXe/aQ5DcG/m/ufIe4QXz1TFHY0F+QA/j2ekXEZcfF8AAmm83HcZGxnQ9Ppk/sY/gMcTRFBaTm1krW
x-ms-exchange-antispam-messagedata: BvntBo2kfVDCjWmy4L/RAcr4B9z6HgKWIx2bKJQc+uktOpso4mVagPcTgKZjaUeBUMvHIJHLFS9A8OHR7lFRmC1RvdnY9CY8hYzhgW+Bvzgn3px2Co4qu8hknDq24Dj8IyjkyckfRGiNwoeXqi2F6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e47c3655-ce7f-4af3-eee4-08d7ca8cdf57
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 16:04:28.6479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ooGcPUYY7CQ54xL40wveN8rMUO/qcClMHfOUSw0AqHi1vADGIL/KuAQvH6ZvsriPZzQn6XJhb8c8l+s8oT9ftQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2948
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Mar/17/2020, 15:56:10 (UTC+00:00)

> > Please consider removing this condition and just rely on an_enabled fie=
ld.=20
> > I have USXGMII support for Clause 73 Autoneg so this won't work with=20
> > that.
>=20
> That is actually incorrect.  SGMII can have an_enabled being true, but
> SGMII is not an autonegotiation between the MAC and PHY - it is merely
> a mechanism for the PHY to inform the MAC what the results of _its_
> negotiation are.
>=20
> I suspect USXGMII is the same since it is just an "upgraded" version of
> SGMII.  Please can you check whether there really is any value in trying
> (and likely failing) to restart the "handshake" with the PHY from the
> MAC end, rather than requesting the PHY to restart negotiation on its
> media side.

I think we are speaking of different things here. I'm speaking about=20
end-to-end Autoneg. Not PHY <-> PCS <-> MAC.

I'm so sorry but I'm not an expert in this field, I just deal mostly with=20
IP.

Anyway, I'm speaking about end-to-end Clause 73 Autoneg which involves=20
exchanging info with the peer. If peer for some reason is not available to=
=20
receive this info then AutoNeg will not succeed. Hence the reason to=20
restart it.

---
Thanks,
Jose Miguel Abreu
