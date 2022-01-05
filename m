Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096264858C2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbiAES7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:59:08 -0500
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:38240
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230295AbiAES7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 13:59:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL861LeGPOYl+Hrq+Ht345PGDQmnlCgqYWP6MjmlicS5ZQlI2C/PH5u4Wt2OVHbT2djTBfU3nNOZAkfJsCQkxr+Bsim6cMgnvyZoVLo8GvhMjl5u5tcG5d7UeqQyussZ6J0ZgGnCLBomxRKyuMkfAPDIfJkdvkw1f3xipTM5wgdq1MBrFvb9AdMOpdDfQWMxmJtHKbJQlrL/93fMARXj1UW276OA0jQ7W67Fc4Htq5ESfTkB7kiJUafCMBpNMxuLCoaBdwO6PhZF53OBBFmUdnSQ/BKJT/Vi3wr1lD+gHNPA1HdVM88ugD1qmwskebtCfYy8bVFLpe76TvD4oR0S9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOal7woGUSx3bH7VChN9FBP4D5efqwFHYwUdvbSzomo=;
 b=HdXRCeNaolZxKVElDD3HD9KevvcSUWQAdUEV9kaoYh9YmWIK0rIt4I0NsDviqVshCMK8nFjcNeGw869YX8zsUuyJ8iirUb2ExmdsbJbbHWKII05TOjLpxFouiDBdJ2S3oGgXBs2mo/EtOo5wk99BPCQe67t9YbAV2Ixo1p4kzoWMdQtFqNezbY249/5o/xj1aercpPRyyHRHd56xcSKBsXM6+ekHVoVb4SLg+jNb5idViqdmO3iJFlWWc2HepAik0POkMHsmG9s9u7zlF3OP6zPV0xnCKnIXV4vJxW3s6W7Yy6dlswsHvEe+ob3v/CyfPjPsvyPUdoKd46HJcEFGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOal7woGUSx3bH7VChN9FBP4D5efqwFHYwUdvbSzomo=;
 b=XZKWGnqe+YdOU78n6B6EM94/gY1gxL8Js3FB8fHU2c4joB8tU9E4aG48PjsUPXEBe+SbCCBKks8LRf4cy05eTpRdO1i2sW8cICde9bRttRy5l/kNYSL0J81RHv7v3CwTXxJVcSYjxMpyjvHLTPGxr4C7C/699fYnQze3S+A4O6o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5296.eurprd04.prod.outlook.com (2603:10a6:803:55::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Wed, 5 Jan
 2022 18:59:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 18:59:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Topic: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
Thread-Index: AQHYAjcz7PA8h1MVMEuDn2+fyJJZ2qxUwpgAgAAFk4A=
Date:   Wed, 5 Jan 2022 18:59:01 +0000
Message-ID: <20220105185901.hprorcjw6api4bwc@skbuf>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <f6d50994-6022-be0f-4df2-1dc3c8199c09@gmail.com>
In-Reply-To: <f6d50994-6022-be0f-4df2-1dc3c8199c09@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcaa397c-6f59-4034-489f-08d9d07d6fd5
x-ms-traffictypediagnostic: VI1PR04MB5296:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5296961C2FE2D90E3C64D0DAE04B9@VI1PR04MB5296.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DA3xeX/nmElXBzWWD/gHt+ea7YLJa+Jw+tUUfOjsDhJQUQL2eKHa8aW/Jfs0BRUR4EE3yTWYPxeCQ8I7oe+Lb686IES64u84Gw0a9OjKF4Y6JBxCxB7T92UK3e9Mh2Xnk8GDN/WOvg153fVdfKrhcwdkAJtAq+R6vYchiPu2aWfLgTahJHMqInK4LFW65Jxnc6xiv7a8X+nDDkC9gFyP+mgE430AKz17RDx46ohwT8dY2w1WJk89D9GIQ4HYX7XmC7u/4g4w82VFx2ytGLynqlVkGEO7GUr6SndbHyfbFN4yHAgI7c1VhznjyGQ+YJLJYp8M2pGCRR65prk/CB/2Bg66kqOJ6Bxxwo6bTnaMRl0Dkpfl/4dQlgHBd7brjSXjBS8MzQxInBYh2pVhs8wMMzmVlDHIhXtcyqhniuREP+UWcq40kR8UzBwdiWGpD09MU8CqR8IrUTxS6fWvtTLL4tmMEy+RzGUbLYN947PY7f19EtsGKGD4vQlr+Re0NObOiPc7MKP+ePgbsaEdid8Lsab2YJgRWHQmRPJXoJNjn+qgOr6v5y9gFLrC2wxBMdab4Gfjw8DbVFP7x4f1cQ/vDn/JF/hxntvu3zY7MB/2CWU9QRmtEwbI52Ydp/LKhygrfTXHnFJrqte502Z0EqGwk3FViguFoIwLl4/1qUo14ACEqjwenbOdL+4qOh6NC9xwTWH5zwQQZ0nevfyFCi3UNiEZzpi6RaMb5oaFx6mOaM4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(6512007)(33716001)(316002)(64756008)(9686003)(122000001)(53546011)(508600001)(86362001)(5660300002)(186003)(1076003)(6486002)(38100700002)(6506007)(66946007)(8676002)(54906003)(2906002)(76116006)(66476007)(26005)(44832011)(66446008)(6916009)(71200400001)(4326008)(8936002)(66556008)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y+IMwOkGK2V39L+shs/C4sBnt6gtVwgo7pksYh9ArRfH1WwtdOYT42hRfQJ2?=
 =?us-ascii?Q?Gu7RNMPkv/9Bi450Dm8a4/eOTfJw1E68qIMI5Ub26Vjbbd1G4ukhI3u4X2G+?=
 =?us-ascii?Q?bCOgaQhzax1FtldfgVYIcawBPPklHyRMOE560iRi1fr7qFvl7smZ89VDJnSV?=
 =?us-ascii?Q?9TOy/GYskjrcdB5az2aLMY4C7xCBvQ/h+ztC+4ef262wNyoALBoyO3WLHWed?=
 =?us-ascii?Q?FgNnehWD67jpu2MqOl/uYGQB3aat4eZqCIkJDgheylY9LC3TKg25cEpIKHTH?=
 =?us-ascii?Q?Ffdjo+kF9itnh9WR0NtbKZn1WCjAeQhpxTWafgtqU9F4mFBvQZoqjrneATMY?=
 =?us-ascii?Q?8f+572jsPEtV15Ka5YP9T8sFiSYwoD7qVfPXavLy0kZta2q+F/6DbWvDha1h?=
 =?us-ascii?Q?wTxeGQLFbcrrtU0LzN280+Pg7fDJF8O/Taj/emgBfdi0RKu700Tcv3if5UqT?=
 =?us-ascii?Q?BRRrp0jaer1aii4wgf7ZOSwSUAn+Z6wGJsxcsjWQe+GkZj7fnGKo8WhcsNqu?=
 =?us-ascii?Q?C838MSCEFj4zMREhDrHy67XOc4ds5gnjYGuOFyJAfO7cZdsUa6W8SZ8v/Ujc?=
 =?us-ascii?Q?2xF1je/vabYKF7myDQT92wAlPj2aYXjIdF0HO4ha6kUaKNfBPUfulb9IbhVI?=
 =?us-ascii?Q?cNfHs0T7g8rzB4geuoF25pJfoGQzLtizVQaZlH9ip8yKWtqBUwEkHGEuIs9y?=
 =?us-ascii?Q?PUGqZA78wYUCjF0+x33h/+GfvhzgArlknSQUrheOAa8bxnQKNOyI6M2Euo1f?=
 =?us-ascii?Q?8CQaBJziiStBURDcJIVOnaCDHeQ5MPfHUkcgok7supzCcaqV0gjikLOhuFJX?=
 =?us-ascii?Q?4gtV5hGm4r1179j23YpKNCK/hEDarst8JYm3Ckopjc3DheyFyAyADxXZ64o0?=
 =?us-ascii?Q?dbm4BThCWKL8R7+RndHSPqRAV/hoPNYMuQJ36Dx+YdaeZBqZshWcI7WRQQPt?=
 =?us-ascii?Q?HxJXTrzFcDMRn8G5O2ktlwactgdTmaFvGhP1yUBCbQCEoFByEoyviJTtzI/W?=
 =?us-ascii?Q?uDGNxvMVXiAl3NTm+/zI6U6pvEQ2sL4xcwW5C4LSwTkVfhZcDYOp0BeraRTS?=
 =?us-ascii?Q?R0vRqmADG0Tl9zMbJwKSBEI5J2/SBQjS1KFDIIYIaRLphrFxMxHkCgoXrunA?=
 =?us-ascii?Q?l8KoLp+2NF1+knoAnsL9N8EJlpfljX6cTFO8Qt7O296D5nVGhki2WHWpTw7q?=
 =?us-ascii?Q?5Mqm53RwnDouzYb1vL3QH1W351UtpTCXNIHjnRzXGtdSMZSD6siVCWHfHNNh?=
 =?us-ascii?Q?H3vXI7gnNfP1/4fesWWgk4PxyxKQWNWRCVERDBobi0ML72VqzmpRgCIf7/sp?=
 =?us-ascii?Q?+bWgoDo12stw9vaCwfU+pTl0Qh/24pPOSjhbVKqxSj6vyJBQtDBEkFkVXn4Y?=
 =?us-ascii?Q?Xm9P3GsMY4eh6J2AyA8kK2ovKCRksE1PTqYq/l3oy1RQ291pDoPbFa9T/AKr?=
 =?us-ascii?Q?g0/k0Hdsu+E2LK0I5sqXKVBAaYEznk8L/gUCAel16ilA6K2akfAv7XirmW9o?=
 =?us-ascii?Q?+UOl5GQRPH//6Q6tWqyQz32OtE89ZMfJ/knLsem94J1attnTVcWDcQq3oWW1?=
 =?us-ascii?Q?3L9QdBp2263IgbmgJI62P/TBcwqpriaGLgmbFi+Re3QuxTOw1M1V884ZYhTI?=
 =?us-ascii?Q?qJQZ6u/rWtMfbNn/Hsyzqfo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5450629D8E27054FA74C87F0F59D9BD7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcaa397c-6f59-4034-489f-08d9d07d6fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 18:59:01.4280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Le6SjlXcJA/fau0RhQ6Z/Dx1LQtQIFmi4ZoKhAsQULnkEKTqPLTDKmp9wlGjY+dChGoQm4EQUu3mUGd3c+SVxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 10:39:04AM -0800, Florian Fainelli wrote:
> On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> > This series contains changes that do the following:
> >
> > - struct dsa_port reduced from 576 to 544 bytes, and first cache line a
> >   bit better organized
> > - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
> >   better organized
> > - struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
> >   bit better organized
> >
> > No changes compared to v1, just split into a separate patch set.
>
> This is all looking good to me. I suppose we could possibly swap the
> 'nh' and 'tag_ops' member since dst->tag_ops is used in
> dsa_tag_generic_flow_dissect() which is a fast path, what do you think?

pahole is telling me that dst->tag_ops is in the first cache line on
both arm64 and arm32. Are you saying that it's better for it to take
dst->nh's place?

[/opt/arm64-linux] $ pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0    16 */
        struct list_head           ports;                /*    16    16 */
        struct raw_notifier_head   nh;                   /*    32     8 */
        unsigned int               index;                /*    40     4 */
        struct kref                refcount;             /*    44     4 */
        struct net_device * *      lags;                 /*    48     8 */
        const struct dsa_device_ops  * tag_ops;          /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        enum dsa_tag_protocol      default_proto;        /*    64     4 */
        bool                       setup;                /*    68     1 */

        /* XXX 3 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    72     8 */
        struct list_head           rtable;               /*    80    16 */
        unsigned int               lags_len;             /*    96     4 */
        unsigned int               last_switch;          /*   100     4 */

        /* size: 104, cachelines: 2, members: 13 */
        /* sum members: 101, holes: 1, sum holes: 3 */
        /* last cacheline: 40 bytes */
};

[/opt/arm-linux] $ pahole -C dsa_switch_tree net/dsa/slave.o
struct dsa_switch_tree {
        struct list_head           list;                 /*     0     8 */
        struct list_head           ports;                /*     8     8 */
        struct raw_notifier_head   nh;                   /*    16     4 */
        unsigned int               index;                /*    20     4 */
        struct kref                refcount;             /*    24     4 */
        struct net_device * *      lags;                 /*    28     4 */
        const struct dsa_device_ops  * tag_ops;          /*    32     4 */
        enum dsa_tag_protocol      default_proto;        /*    36     4 */
        bool                       setup;                /*    40     1 */

        /* XXX 3 bytes hole, try to pack */

        struct dsa_platform_data * pd;                   /*    44     4 */
        struct list_head           rtable;               /*    48     8 */
        unsigned int               lags_len;             /*    56     4 */
        unsigned int               last_switch;          /*    60     4 */

        /* size: 64, cachelines: 1, members: 13 */
        /* sum members: 61, holes: 1, sum holes: 3 */
};=
