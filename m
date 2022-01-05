Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987BF485485
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbiAEO2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:28:42 -0500
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:42208
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237136AbiAEO2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 09:28:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1aeSfyWv11a6hdeVtjS8DWvUSd2pgIQvTE5AM6cmW4eQ+2q9CttacUWBbDoqXBwUBMrft3HylZS1hfUn2G0EqZL6TFy55TCtt9C8bNElpo8Fs+mPdpZX1JNV7s5Gh5w+cDnaSB6gZos4p2dGMgKH+Nv7i3K8IJr8oytJEYHA8FrMRtdGKwNPIiGXvc1RHhhV9Xkyhde8kzsqdg7MADmH8IjRHGotJyduseke6QvwfYKYzXddFBmr43qLN8miToq5lDsTbSlncC7rPxRNroxzTiyjW6LUHBTV73udtXUxnb4c5YgzsOdJJN8LRUiLD/ZASntHlv3EiX/5sVmw32PFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IwmmPGZcXLsyV08yapbMxBjL4/WCekawrCAv4Lg3DOo=;
 b=OeDU0DXg0zrbEYm3D1ewGUm4+GynV54DYhf8tqKMDQr4BkziJBFTDdPZePVqc0ZedAB6GWQMZ39ZfW+R/YoJKRvYQOgHQY+3GfqIoE7OHO3hBUG9XybXIvXjAIZ8q7y/zsy55TaIfPe0EZizi+oNFdjkNa/qbmQlEsvUiO14+nxPruTtwXeggaa2pnoBb06D0BpB+2k/4+8ZEWnWCPI27qN7swPpi3gX53noETzO7e4CBxkhOVm9+CF9lzStN7pWhWasntzQNbqr+GyPhPZRiNU7hPwTDq/jCnAIP+aMPzjfGnulNBCxwFigNPe9AvxqcUbj56tSJf+adLjW0VB2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwmmPGZcXLsyV08yapbMxBjL4/WCekawrCAv4Lg3DOo=;
 b=qGCb4l7EgeW2oJG48YaAMJL9baTV1KsayqYkhHSUL103HxWADNG/GWC31SbtCW10s7xuRvZD492LHo6H9FxjUsWtl8yt6ewxVwQnjbi4Ih+tyCd3Xjq3q1BID8IJDeyNqxKjl/I8KztSpFVEWLEfSCnss2WFtiKayAlzux//ZP4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6510.eurprd04.prod.outlook.com (2603:10a6:803:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 14:28:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 14:28:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Topic: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Index: AQHYAjcz7PA8h1MVMEuDn2+fyJJZ2qxUfKAA
Date:   Wed, 5 Jan 2022 14:28:38 +0000
Message-ID: <20220105142838.uzanzmozesap63om@skbuf>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d02faf3a-34fe-40b5-51c0-08d9d057aa78
x-ms-traffictypediagnostic: VE1PR04MB6510:EE_
x-microsoft-antispam-prvs: <VE1PR04MB6510527BE67DFFC1C6D3C5F2E04B9@VE1PR04MB6510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dMBcQDutqyBxBx91+xYs2WoFDm3ZJwygdFSp8jSeLsnqvf1i27ABF8eCFG2nw2s2RmCyh7PL6lkR3At2u2egWL56ToMhYdZg51IUxOH9nBrq54liz2QA3iCXYtVQihtMsU7o/rZUmDNaegDiCjAkXrNWx4JjQZJiLe9oZ9gscxQN6nANASYS1l7dGutAGfmeNm5ug9scxnmI7TCOoNNqMcXRjR0mIr+Ns0I+mXWcabrT6/DfZdqyeQQxQ0Dy3yodTLBjaNLDQbxX5nQyOq+k8wU/TSUgi9DSAk/JP5hF55iTgZEhnriMIs2JjNXzc0kS6rfxzKpDKUokdHx4daie+a1B+NT/tAHi3gg0lhTC/QeELF8N1GaI2yglqSry6cuplCmrRQZavidATg4x98+il1oICDHcqP93j6YS2wdEzHnzodQNfIEIs/VZo820yB78pG5BYjxJ+aRpMG508NYc7KQg+FYu08zdjojMHzNnkEd6XjlIYbxqvnVicqVZ5ZMlxH4v9EnilNXsRwv5tXLMBzr/Dg5wMpiVPlAgWCc6Q5nm8o562rn/dXd9He+fAqmcu7gfGxLm6f1naaJhUJF9ddvzshq6RGYNaW9ANYOjNeycOAv3JDr6YLy1sX3j3gJ+nL9bbIIJzKQZ8cOCUcJn/dWcD16ntlKyy+1jb6nL6mV2jj5KPVdJLebxg9OkRWz9RM3135tHgCUmKco7E2y7UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(1076003)(71200400001)(44832011)(9686003)(6506007)(4326008)(91956017)(76116006)(6512007)(66946007)(2906002)(66446008)(66476007)(64756008)(66556008)(6486002)(316002)(33716001)(186003)(54906003)(508600001)(26005)(6916009)(122000001)(38100700002)(83380400001)(38070700005)(86362001)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M7qoqdJ090DZiQ2Vc2RLq/kRYcX14c4YjxooTJJwTPiNqDj9ShMyVVc0f6Xo?=
 =?us-ascii?Q?46mTx4AhODlCcHb9lQ+LWxMVnf4ScH0p6cOJasRtOy1STWvujIzvoPFWfnK0?=
 =?us-ascii?Q?tKmBAbfL0r9BGzdNav+GMEwSCrVnk+KHqFFKO+aAwA/StO4JDmHebPL/2dtR?=
 =?us-ascii?Q?UAHPxjbU28ofKbhFJNrWkqn3i+gkjRp4oHcESOzNz76h/ChvPakdtLHxEWRy?=
 =?us-ascii?Q?c9C2NQBA5VGWW1DLQ1ESMrAvi40/DeE9LzdrrdXq0enklFbwDaGSekgoUGSD?=
 =?us-ascii?Q?gkFE98jKLoFJAPlOh3BUm59qJvZJgxQNpqrIikCeXmeOeejch1LpTHj6juDR?=
 =?us-ascii?Q?a9diHPeH/bxiJJ0mdyLjLtRQ2fXQ4k3I8YL2YnZ5FaJhEwz1mJT52gZvfNxy?=
 =?us-ascii?Q?rz1och61rNFAgVFkKCw+/X+oErw09HiiBV05FVZgIHd6TmsPcbVkdMVQpNf1?=
 =?us-ascii?Q?zqVPQLfEruSlkf5poWOXVNhJDXch2FGql58QhxA0flwgoIKPHpm5u8xhe0xz?=
 =?us-ascii?Q?qwdS2WQs2rZBUvJexz2iCYZClECK89s7p8sGFGNZfdKhdz1z2nprfm3wjNlr?=
 =?us-ascii?Q?SLXHjA+pHmmqKQ+pJGJHPbAVSDOtPCTm5sDQbIFasqVujrEZOBdXa6vllLb2?=
 =?us-ascii?Q?WOKLXefq1AkxXyV9oVRYOC8bdKhMucFfATkVKOme7ZPnpcMMIODPowHdC6Bg?=
 =?us-ascii?Q?j+73uVn+A7KbtyU8vioCyFLfVrSWiKySyK4xY8DhHkb8SX5rfUAjVfjIq2pA?=
 =?us-ascii?Q?DX6T68cLegHUtmp1P3XkUcUrScpCHgzGw1fIc4xoDdP7t1MRTZguLLJl363m?=
 =?us-ascii?Q?yBbQasJ38Q6RORkAAQl3OcX1pJ4P1+Uon5hC279Tcwn78QdE8pH5z51FZOlc?=
 =?us-ascii?Q?4TRIeEbJTnAg03RNWSLekfpm07gYWObfljA50bITO4ZC3KNwxMPn9gfGp0g8?=
 =?us-ascii?Q?M+v58AupLHwscsGN8bza0jtbeVxZNJylcBjks61vUUQx8mt06K7u3gNgOTRW?=
 =?us-ascii?Q?+ibwWQFDahNqRdyrgVQ68Rd3WFLLfHR4srrV/CFNAZ7jRI1ZF8raAuXA/AUX?=
 =?us-ascii?Q?u9bCTiH7yo8Ux75lF9vsBsYvbe7f6rZoKLS2T03FT6/nyQny+L7V7iUyDnK7?=
 =?us-ascii?Q?DdgPhUPgn+itV57bUhB2coWhTBt6YWu+rSGY4Mh1dvMFZZ5yq+423aFmwy1p?=
 =?us-ascii?Q?a33hi8AppPRPVHjTYr9REdueGb5jkSfQxgucQhIaFtpYjpb8WTKb2sLzM37E?=
 =?us-ascii?Q?tU0kwAsMvvorFk9g5OT6zUblNzWb+TYR2wqzhRrg8ZS7hcdQ3hi6PkNnFpN6?=
 =?us-ascii?Q?4wxdg4jrg+nC4i0BuC3Tx1Tu6CXutw7C0T9N4yx14yxnkCmCv2FWKbMuQt6y?=
 =?us-ascii?Q?kE6MKp4sHRJWe9ug7i4zAsJG9rCXvmCAmlNpXqga3nS3rgA8dlHPCfCGs0tG?=
 =?us-ascii?Q?HSY24lUijucuWeZkN1bLQ68JWFQB6z1nizH/hB6KZLasrhD9vGHTZlJFcGcT?=
 =?us-ascii?Q?FM6oSsUd44wpjqTHyS5fgr9JhxV+/Gvl4WLpnvMwl2HITefsyISuaH4FAnyi?=
 =?us-ascii?Q?vtdBgIgtNZn3t0q1H93Td/wJc1SbsgB1WsS7CUYc+nYvG35EmRF0oahTc1yZ?=
 =?us-ascii?Q?Zh6+X9cjbGEpV/9mClRqDSk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AF9B5D9A1372947802567265C6F20BD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02faf3a-34fe-40b5-51c0-08d9d057aa78
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 14:28:38.8973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kpofE/ffjVbXZ9rvwslWNKCD2lEn0xlq9cJxIY5lNXrsfBdoLDrEy3tz4gH74goUL0qx0/3xL4RRGJS5nDlmKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 03:21:34PM +0200, Vladimir Oltean wrote:
> This series contains changes that do the following:
>=20
> - struct dsa_port reduced from 576 to 544 bytes, and first cache line a
>   bit better organized
> - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
>   better organized
> - struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
>   bit better organized
>=20
> No changes compared to v1, just split into a separate patch set.
>=20
> Vladimir Oltean (7):
>   net: dsa: move dsa_port :: stp_state near dsa_port :: mac
>   net: dsa: merge all bools of struct dsa_port into a single u8
>   net: dsa: move dsa_port :: type near dsa_port :: index
>   net: dsa: merge all bools of struct dsa_switch into a single u32
>   net: dsa: make dsa_switch :: num_ports an unsigned int
>   net: dsa: move dsa_switch_tree :: ports and lags to first cache line
>   net: dsa: combine two holes in struct dsa_switch_tree
>=20
>  include/net/dsa.h | 146 +++++++++++++++++++++++++---------------------
>  net/dsa/dsa2.c    |   2 +-
>  2 files changed, 81 insertions(+), 67 deletions(-)
>=20
> --=20
> 2.25.1
>

Let's keep this version for review only (RFC). For the final version I
just figured that I can use this syntax:

	u8			vlan_filtering:1;

	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
	u8			learning:1;

	u8			lag_tx_enabled:1;

	u8			devlink_port_setup:1;

	u8			setup:1;

instead of this syntax:

	u8			vlan_filtering:1,
				/* Managed by DSA on user ports and by
				 * drivers on CPU and DSA ports
				 */
				learning:1,
				lag_tx_enabled:1,
				devlink_port_setup:1,
				setup:1;

which is what I'm going to prefer.=
