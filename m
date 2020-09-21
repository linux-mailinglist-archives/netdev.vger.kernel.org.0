Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3327253C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgIUNSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:18:20 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:56877
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgIUNSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yqz78Fb0mRU5C9LUHaCUjPQmgoL8qasbjcR49bpDeXLz2/hlGfS+eGs29UrXy3vh1omJHDGA1LWOsmZnVLW7DcwOpDqfLk8VoY/rj8X6pGapazw88jraCy/jphYB2pboar3O68LUnC2dB7F6w7M2/D1Z0eVrd39pYIKM98/pjTKfOg+z1DE57RfMjw7qY6TBXG4OBqhnZevLh7uhuQUBFG5OrMfQP8n+DF8s16Uwk9PtRgWG5Al5pqWFb5lvT/8wa+cW+7uSv5GNxz+5qLBqIKEuLi277leI/QMe2+tEB0dKlzoUVyP93cS4P5p+sDCwOxkasZzSRdqk0qYMHsByxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5HG+7Mr4MzNtrlZqXPf/3vR9C/pVVIzA+h0ERhp5/E=;
 b=CpgkiGqqXuFAucyVq/Z+eucJu7h/HBMTsG+FDdeCzp0KT86PYAFUABu9fq+hewnm+9U1e9pa0MOImRxiFtwCLdSChxfI/2jvqhreroVFxSJvo/Re1wp6hoCpJTg/5dGo5Td/l+LMv6075LmsBT0tmoiQeL+P9+uQPm3lDfSuFp3WfxBHigaxDZfAAWwua0NDvhTUZZCL1zcwcp7a11CsqtGik+2jZ9yOA4Zj5BdNejPwRREZs3LG3Fg9r3syUv6Vzfg12zHnXCrX1H7kxYZBXqOUCW8ssdU3/elfFd1fPM1qRgmPsZOMbJKfP8UoxKsmKs8nLGWr2S05mx5L+pI1Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5HG+7Mr4MzNtrlZqXPf/3vR9C/pVVIzA+h0ERhp5/E=;
 b=J153ajyQk0ke9TRpPBHLefJK9Lr6bxMmKbDW2aj+6V5mi1GGDbvTxDrJCiXu1DvYd0KCxjcJvVnAtdzTVqGKs1yyWN84oTP807tS5+TUBXpL1V5uNOqVdIyU6iaP7Q+DtUNrOw+84zIWvT1RFYCqS769xqPDvFiwWJny7lFXnmI=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4116.eurprd04.prod.outlook.com (2603:10a6:208:5e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Mon, 21 Sep
 2020 13:18:16 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420%5]) with mapi id 15.20.3391.024; Mon, 21 Sep 2020
 13:18:16 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] enetc: simplify the return expression of
 enetc_vf_set_mac_addr()
Thread-Topic: [PATCH -next] enetc: simplify the return expression of
 enetc_vf_set_mac_addr()
Thread-Index: AQHWkBiMF02kkeGX10+maMzxyVQzFKlzErJw
Date:   Mon, 21 Sep 2020 13:18:16 +0000
Message-ID: <AM0PR04MB6754E556C79F067897456106963A0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20200921131026.91790-1-miaoqinglang@huawei.com>
In-Reply-To: <20200921131026.91790-1-miaoqinglang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.124.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32d1db3d-d261-4667-60f5-08d85e30cd46
x-ms-traffictypediagnostic: AM0PR04MB4116:
x-microsoft-antispam-prvs: <AM0PR04MB41161C9D19755CA029C7619D963A0@AM0PR04MB4116.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VB4sXLExAF2ntyHuExTnSjWXGU7P7m9Vn/P9ftGFGGGeKXWNSCq7bTlOvaweVCrcpGJuWBHvUjAIACGDaIW1kNX/gL49uNfsO5ooQ3TJlXj7QcS0A+a/KygfLh+umQQzwu2ZB0dHWt0zUm9/7z4Cw4HPihUBv/zH6Z57KRhGW1iZKRgHjgfavnXz7hSrr+Q72IkscGIpFIA3Pu33JZhJ+PHiUv3/oaQvBYk133C9M1ehl52xRssje+Mp2ZbYuUAsU6dcofZ+tIvPR3KIT84qwTUPykmtz4gpPKaDydDkj4eGDnBcrGWg/iOv37Z4JQl9D+U+nPoXCQzIhycDZ+qSgzVyfkazrz+ijWP/HzXMnC/5wz0QNBBjP/U8bkhlmu8f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(66476007)(76116006)(26005)(66446008)(478600001)(66556008)(4326008)(33656002)(54906003)(316002)(64756008)(6916009)(8936002)(44832011)(186003)(7696005)(71200400001)(2906002)(83380400001)(52536014)(9686003)(55016002)(6506007)(8676002)(86362001)(4744005)(5660300002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CegEjd0aCCNXqImGurzgnHMFE+l+EJLtZHG4h1JIAoKXP0M0sW4hc8s+P4dqIRJDlx1Wf2yzcEixKpv7OyiopVpnlT/8JoEFxdaD0Q5pSgWLPX05Gv1t+1i0HsfqUKp5+uJ6dhN4rGLryxOjAFB0f6Kzw5VWf1aDokxwSa8K7bjVEbpx2z0Bh+9Te0FIe6uwQdoYpzDGsEFclCVFN2vVpX6hJcBmcwc9Atpz4mkw5MQjdN+Kr11IY5CoWka9sNr3UI1MsL8W5n82m0NAEVPXXpRDUl0Nf3tsk9s0HQxvF4LT4U6rq0aAV85DE7oIrbLUYIitf3YPDUJNpi4uTY2EnsWcXAnlZvX37mT0qzb9FtjfMU++3EUlGNeEoosl7vxUnDo4IhLpVsuME+UAadMLYpznHEVuZF4s6ru3Floyg4YR0KXQmEAOHw04NtEvXDSlTFV7qK+LDQi194tOxKkuVE1hO9BChUHLggMUzL97BJXO3EX0uJ4RtoCwuhs1kK6s0UD5WwQE2bSjI8X5OysA3/wxRRzPkVgDCuj8f0QuPJzrO5gE6uFcU/ZJJhERDG0YvFNfKbG01upB7dioC+UYmt+UyHgUgwAN3pDFEQZzJtwgiX2mJoKCzHm4dxjTa3ILxtlh5DLb1G9eHlc0ncljEQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d1db3d-d261-4667-60f5-08d85e30cd46
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 13:18:16.7808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQYUgkMApfNTX3m6an/4dHY6TktsrKNg3nWEQB3yTCIhY6IA3wz7P2Ny/fNb31BA6Qm15rQ4AJHmirYKIfyT/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Qinglang Miao <miaoqinglang@huawei.com>
>Sent: Monday, September 21, 2020 4:10 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: David S. Miller <davem@davemloft.net>; Jakub Kicinski
><kuba@kernel.org>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>Qinglang Miao <miaoqinglang@huawei.com>
>Subject: [PATCH -next] enetc: simplify the return expression of
>enetc_vf_set_mac_addr()
>
>Simplify the return expression.
>
>Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
