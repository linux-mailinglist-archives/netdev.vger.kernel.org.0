Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E2AAE3F4
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404406AbfIJGrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 02:47:12 -0400
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:19110
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404308AbfIJGrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 02:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qruy3AHpu0MlOdtusvjNDZsk+fjcYu1YOTlwaVkCg+S+CuL9txrmhMjCLxAmp5pq2kXhRkMu60cI7AP/VKNTPPFnCf3W/hOwfHZLrJ61J4KVaA6RA+TlZXlHCskqboGMLK7aengUAU/CpwHjOE550D96oe8vOuJ5VHh9PNYQlIgs/SjMfaZXBmkCquTRVjoCEwZyIOISpuxtnDVwh4ivC1SHZKOmn+tPjmbpwvUzpVNm7/RaZ1YevgKN5opgSuVU8YiXMqqO5lqBhlpTANwJXh/3gFhvYF214xIT9u1XUznWtPT8j2R1XF9aAGuTljcy5YCs3v7+EoUV9JzX5hlrxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1Lu1mf2xkjyWAObdlGStknVthq1ChUNOiBl//WcMlE=;
 b=QqUXFMfw8qmanRILaq17jPYXsrnqG1qvkGMsYCOZipndLUs+wTWM2gqohgRofopq68I+gZd52JPHOHs7FVJMWkWmTYqAA2yts8PANA5xbjot1hWgHUArcPcF0vw0QYcW/f/hmI5VayDgIJNQvxDGP1wV5qF7EG8IcxTHSE0Bnp/nKXci7+GtBETLMhEG5PGk8WozP2kJstpfWjxuVMjbBiiOwA8XPJXABRiLK5Oz4g4KRkkjbKB+l3apn3IYRJ0hh1OwGOf+y+iJ24FU4wp+LtYsTuiLL+hT1TTT7myxrsWFae6QLSw2Nsu8z/KPar7qUPlMEwc7RwkekgzqKiB2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1Lu1mf2xkjyWAObdlGStknVthq1ChUNOiBl//WcMlE=;
 b=CM11K8ZITnxvsmlQ5nJgZ+8YOeqcm3U3a6ZWhpzPkoKOvRUeMGrjaSOUp+dhSpUJMItTHfyTpE7aCKNVRG/Fd/eP6RL4kbDLFyqePdD4rjumDPe3ZkLQisSU9A8GUJ5ANrgwzpIu+ACHtuePgPF9eycqnfkhFog1smSfK68Ys3E=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5541.eurprd05.prod.outlook.com (20.177.122.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 06:47:08 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 06:47:08 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Randy Dunlap <rdunlap@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH] lib/Kconfig: fix OBJAGG in lib/ menu structure
Thread-Topic: [PATCH] lib/Kconfig: fix OBJAGG in lib/ menu structure
Thread-Index: AQHVZ1knrZP/QccMQEmplqeL/ehE36ckeGwA
Date:   Tue, 10 Sep 2019 06:47:08 +0000
Message-ID: <20190910064706.GA18005@splinter>
References: <34674398-54dc-a4d1-6052-67ad1a3b2fe9@infradead.org>
In-Reply-To: <34674398-54dc-a4d1-6052-67ad1a3b2fe9@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0190.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::34) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cffc347-8675-4d3d-eb55-08d735bab341
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB5541;
x-ms-traffictypediagnostic: DB7PR05MB5541:|DB7PR05MB5541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB55411CC87421D78B6F4C753ABFB60@DB7PR05MB5541.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(199004)(189003)(53936002)(305945005)(486006)(9686003)(54906003)(229853002)(6486002)(99286004)(6916009)(6436002)(33656002)(386003)(33716001)(76176011)(52116002)(316002)(6246003)(71190400001)(71200400001)(5660300002)(2906002)(14454004)(25786009)(1076003)(6116002)(3846002)(6506007)(81166006)(4744005)(8676002)(107886003)(6512007)(8936002)(186003)(26005)(86362001)(102836004)(446003)(66446008)(476003)(66946007)(11346002)(66476007)(66556008)(4326008)(66066001)(64756008)(7736002)(478600001)(81156014)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5541;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nI9WYjOjevEiwpq1jTKak3XDIntCUk7ch2t4lD0bQ+IciBdy9+Ax7ao6lLYZN7onzDtK0URm+ADC03E3p3ehh+I6BunwZXIyPPVR7j11gIl4bE0jj5MxKLmwAcV9dsxUWYZ+JZlepV/HndqY6gmlI5P+8s5kzf3J+iyji6awz+POYwjRJrRkfFge5kdiiF/D7SJtXuH7V1e2rF4u7sC6IRTRspGk6d1J/IX7WMB1sdBTGUhHGNkHf0lkhU4IFDXXzLOBxRk2HKigiVL7eKwG6WxBB4hTJmVW9w0SewpINq1iIzpk6eh+y19iUFqdWlGh7z/cGc2xDYkYYMPXNCwXq/pMj1BuIYr5FZUiHfdTZpE1I49XNAh7aEYQeiXYkwiJdKM8JYc5M4HEtvWJ1W+qz8IYAFsq9NAmOn6B2HeQGGw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B23F48184E9D5428576D72C98F8A22A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cffc347-8675-4d3d-eb55-08d735bab341
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 06:47:08.4954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZFgdPOReiFDQofHiK/HwhZJNvPbNCDq+b0TK/wUOmhWVQvS3huaZaMdv3a2rT9vRfxfwPrm38Sk9L0f+3/oBOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 02:54:21PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Keep the "Library routines" menu intact by moving OBJAGG into it.
> Otherwise OBJAGG is displayed/presented as an orphan in the
> various config menus.
>=20
> Fixes: 0a020d416d0a ("lib: introduce initial implementation of object agg=
regation manager")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Ido Schimmel <idosch@mellanox.com>
> Cc: David S. Miller <davem@davemloft.net>

Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
