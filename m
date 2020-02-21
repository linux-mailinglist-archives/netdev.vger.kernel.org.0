Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB851681C3
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 16:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgBUPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 10:35:02 -0500
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:41121
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727053AbgBUPfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 10:35:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8/wRCj/Kn9NGQfLOejRVKTjZLX1xI4DFhs+0h+cKyND5cJpNS8RoeGtk19NIM5v3hs15/IxqcnPW8ArwZuX2HsRC1Uv783mPcvDlB9cZoLX0C0/SsZBUlIc8aS+RbUsrdvwXROWJSNdGPwfpPxW5modL0DtOB64tDuKbeVXnkvfEMlj4Gnw9EMXdWsiFziRlZvgR3xmr/koxnqNGfaZR/79TLJdI1oVxQR6WuRcH556uIfPXOBZm1MKvdJiZ1arItfUa9rokedviN3aggxy8ss8Gzwg/3HYLBSe+gfTptmnWUpjxwV26hpktwcIMyOOw79h9O8F1PeoI2Lo+7H0bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuhjviSa5QaO8Whk7LMBelbg2Xhs5gMg2k/1Bm3kuJs=;
 b=IqXVAzrKqa4TDc/uVDlTELs+0irWM29Rt1RDdO12k3GuONprs0mIEcZae3dmkfYeD3dRMqolGzegU8LHuj9PB5ucja5vkL6vcW657xfRWWMJLOoTbFDSiVT0MUz2MdO9MYRzfdFPDDKaPRDODFCWGCp26+/kyS8fL9kBusDgvrp0YcXbzru26j04AHSsNPKWBE/fLqIMMQeNLjbBHPTQYUKmSyvC+hJW6zkmkkut9khcd5ZtqjYhzlLwKKMVoXSP6low1YnOMjA4UEwrV6VALXTxrzguK81fP2smxesEI0z8amfkHHU+GtpkzblZrYqWRLlr6GB4D4vquRs4mbbjHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuhjviSa5QaO8Whk7LMBelbg2Xhs5gMg2k/1Bm3kuJs=;
 b=DKzJGdrIeS5bSZ6OcxpaGh3Wju0NvKQfgdKUS0mdm4xZzMPAM57OScekT6/+/zSjszq5oAA7ciWmZw3XAb9wZMheH6RxEmzAe2sy9+v1LLWy85XqGjAhdRQg2Ucf12ZZK2nJQ02woTfSzXaGi2fTrcrYzZspYzXmWDSM9DMdGpw=
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com (20.177.33.85) by
 AM6PR04MB5909.eurprd04.prod.outlook.com (20.179.0.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 15:34:58 +0000
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402]) by AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402%5]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 15:34:58 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] enetc: remove "depends on (ARCH_LAYERSCAPE ||
 COMPILE_TEST)"
Thread-Topic: [PATCH net-next] enetc: remove "depends on (ARCH_LAYERSCAPE ||
 COMPILE_TEST)"
Thread-Index: AQHV6MW0POq0FKWECU+Yt+MO149EsKglxlvA
Date:   Fri, 21 Feb 2020 15:34:58 +0000
Message-ID: <AM6PR04MB477415C85EBF734FCBA82A8296120@AM6PR04MB4774.eurprd04.prod.outlook.com>
References: <20200221144624.20289-1-olteanv@gmail.com>
In-Reply-To: <20200221144624.20289-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f41201b4-43b8-497c-d459-08d7b6e39c1a
x-ms-traffictypediagnostic: AM6PR04MB5909:
x-microsoft-antispam-prvs: <AM6PR04MB59090CDBF5514434D2E9CB9C96120@AM6PR04MB5909.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(71200400001)(81166006)(52536014)(5660300002)(33656002)(4326008)(7696005)(478600001)(6506007)(26005)(186003)(81156014)(8676002)(4744005)(44832011)(8936002)(64756008)(110136005)(66476007)(66446008)(2906002)(66946007)(66556008)(86362001)(316002)(55016002)(76116006)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5909;H:AM6PR04MB4774.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fldzcK8yUhuH3yMdMvJ25/QgnkGc/JxDBtYc4enm+zycaqycvEOpDvc0g33QIzljQ+RA60x4277YecyhJMPSTm3Cv7SB1vKtOCnyeFcEBuH3Yj/jiyTTq34CA5UFsAy2lG0Tv3qLGGb4iTNXmw6CzPO9TCJutlwf5xe4o9+3FGzHHKdOUHWNzQ6U2tqyRdQ8E7H/YPoojrwifeQjADHoG3GiWPY3GGq0L4op70/FZdsr/NCVddnytNF9PCF6KKPcazZd/zt4Ekub9aiIUdN0vzPBBtkvLgZkG+i84kQDaZBc860/JEe1uK+7tB9wILUSigZlLXkw3+EXYbwsOsAEp5ILf3DXeWaq6wAswC7u4qrtnr5Gw39MIc642nzV6ehd/Qrogm3JrLxcPabElP1CdwrCu7t3/P501Ks3Czxx9FQogWbjQS9xhbFAWAaG2KLn
x-ms-exchange-antispam-messagedata: 1gNOuRZtUlqxWDzCILiBPgDxDOuTNtBu/YyIkb7zYYFjfGPeAenkUgol9ndEa2h9JuOOx1uKoUDyCyRtqr16tIpK3m3XL17AHU6Wx0m+BHBivkcnaafB/7RIRWyevR2o5NaPrfDR7VemCc5B80GkEQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41201b4-43b8-497c-d459-08d7b6e39c1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 15:34:58.8161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nt0ApOvApEPu8wN25gNCZdTxz3nbrmQq8bPUaUCXCwOcjdO4ckacgKU5Pz4H2lSyhgPl26RFl6b7CsZEZfLdbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5909
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Vladimir Oltean <olteanv@gmail.com>
>Sent: Friday, February 21, 2020 4:46 PM
>To: davem@davemloft.net
>Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; netdev@vger.kernel.org
>Subject: [PATCH net-next] enetc: remove "depends on (ARCH_LAYERSCAPE
>|| COMPILE_TEST)"
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>ARCH_LAYERSCAPE isn't needed for this driver, it builds and
>sends/receives traffic without this config option just fine.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
