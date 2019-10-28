Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEFAE72B2
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 14:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389560AbfJ1NgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 09:36:10 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:29182
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729742AbfJ1NgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 09:36:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1siS0vGjjj6Yjt1MkX5BVC+uPLlAG9CzoMMf5qb5QYbsDyyKbQGDlV7V6o9UfnqCj3ar8mhZyv4TH1CxDJWGF8wzGizmMEml5M1FBAD/PpZD1MZ8+OhMtMQJz8IPoT8K/yHXdEBMfh7CCVXlXw8qlIZKttOGPWbJFXqZWXwSyvPJPg6nXL6+gKC1NQpWRrS6ZwInyPI7AU23z3PZqD/1NalA6So2lzaB7vFlToV9DR/y0cIZvpdzLKmkJVkzJGrtICE/Z3wnSYLWYMq+fd6y+62MlSdt0oJDTpafs/L629SiXYhZsQwxlfcRUh1tctQW+CefEXSsPH7QVRkWO6beQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw7U8FrPJnr4yF8NVKyIfIGiJe+0GGw3CkbvtqiULBY=;
 b=TC1Uyp/QmxTVBveeuyuBUAk4nu9JxRJilj3sIKz99fvgk+NTdEaXOBjk30yHukv4qEe6xLPfFI5tVcsWEbr1bWYecIC3xo/Rd8sARk2Cxj1Ch0CXkBtPqiBHBjsymqTqW7C1+wUf80Xbvd5oh4naCBAkyzM/OQiK2a9M4WJKowPKoaBYAEaLTJiB7WjMs1Y9UIaHjKEhlReCa50Q/ahj80Gz0reMG611MukuUnboYDZ8Gy5UTsLUwm7XRJCyKT/8bknOt0aAAKpk8M93AEmcovrkz+15k0qwdqM4k6IazyvBByMjMK1cPIryWt5V/SDS4v/ubhoYftTTlYTfGFHSLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gw7U8FrPJnr4yF8NVKyIfIGiJe+0GGw3CkbvtqiULBY=;
 b=SeffgJJFLQEMvIsw0NnVLhz8BF7PkWfZlzFKkdt+N/C/d6nK+krceq7xo/3ZuthDnfrqmjswlBykHcheqGVg2zu/Ol6x4ouAM13aCHSlXjFjPw93G4RQZbPcPl2YyGDRS2+JEVjqHmi6eNpf8TGz94cxktx1GLDbGdu0ZrGEdw4=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5099.eurprd05.prod.outlook.com (20.176.236.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 13:36:04 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::6507:ac3:8106:3d0]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::6507:ac3:8106:3d0%4]) with mapi id 15.20.2387.025; Mon, 28 Oct 2019
 13:36:04 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [PATCH net-next 0/3] mlxsw: Update firmware version
Thread-Topic: [PATCH net-next 0/3] mlxsw: Update firmware version
Thread-Index: AQHVinqqfWMr8Hm2rUWr2XZwno6KJqdwFFIA
Date:   Mon, 28 Oct 2019 13:36:04 +0000
Message-ID: <20191028133602.GA3999@splinter>
References: <20191024145149.6417-1-idosch@idosch.org>
In-Reply-To: <20191024145149.6417-1-idosch@idosch.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0080.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::21) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9eee6f64-7c81-4ac7-8bb7-08d75babc7b4
x-ms-traffictypediagnostic: DB7PR05MB5099:|DB7PR05MB5099:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB5099C6A8754ED08C31600028BF660@DB7PR05MB5099.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(256004)(66446008)(66946007)(66476007)(81166006)(1076003)(4744005)(8676002)(81156014)(8936002)(66066001)(305945005)(64756008)(14454004)(54906003)(7736002)(3846002)(186003)(33656002)(5660300002)(76176011)(316002)(52116002)(102836004)(26005)(386003)(6506007)(9686003)(14444005)(6436002)(6512007)(71200400001)(71190400001)(66556008)(86362001)(229853002)(446003)(486006)(6486002)(25786009)(4326008)(476003)(2906002)(6246003)(107886003)(478600001)(6116002)(6916009)(15650500001)(33716001)(11346002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5099;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vL9yR3N+TLSCzfysqizBKExqcdNAWy1RxFFVie0IuGIuSTbWPAHDosgjFIeiZHOHkX/WwsLQZB6uke3+GtIu0+b+xuGnKqz93mCgC0DRGTeifmd5YWhILDkjnHcoBBy+MijqfLR59W984r65MlJD0zsUtfpOCvPZ98fYOBr77PTePH0s/g5+ggbt2F3tawgPgXgoejnQD3T/KhCJASyW94vnChMspkoFTLrACvARewVRqA8QsITXvhmcyUcLie33w0xlBrvgn6GuR2n2HQhi67w+SzaAhRW6P07BYExeNhZJNMzJ13ll+r7V6/JGs9FWHfNJMDrUSpAbGxULM5MMsyJqjsIX/bo5FuXCaoLOLA74XWIPRPcaYbF44NBQwlfUbngB9X0JISz8wUF1YTz70DLZqNDs6h0pIiDGutNE3KSsosXKvrP21iguje/ZXu1A
Content-Type: text/plain; charset="us-ascii"
Content-ID: <358032187CEC0044B7FB56E84F3A86C3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eee6f64-7c81-4ac7-8bb7-08d75babc7b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 13:36:04.6596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yXOFitJKZFzdO7Ye+jdMWY64f2ojvlBo5mSD+yUkAH6h2QF+iPZ6i71KCthGpd8dh3WiBIOmRyETM962f06jqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5099
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 05:51:46PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
>=20
> This patch set updates the firmware version for Spectrum-1 and enforces
> a firmware version for Spectrum-2.
>=20
> The version adds support for querying port module type. It will be used
> by a followup patch set from Jiri to make port split code more generic.
>=20
> Patch #1 increases the size of an existing register in order to be
> compatible with the new firmware version. In the future the firmware
> will assign default values to fields not specified by the driver.
>=20
> Patch #2 bumps the firmware version for Spectrum-1.
>=20
> Patch #3 enforces a minimum firmware version for Spectrum-2.

Please ignore this patch set. I need to send v2 with another patch to
avoid regression with a particular system type.

Sorry for the noise.
