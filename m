Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6372F30BBA8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBBKA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:00:58 -0500
Received: from mail-eopbgr140130.outbound.protection.outlook.com ([40.107.14.130]:38557
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229692AbhBBKAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 05:00:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzUqA2USadEprjSKS67Bvnh/E1CJulIOpJcdV0Pp+o/dGNVR6DXYBoIOqLBujqxjReDDWFSpdjCs+UuP8i4kqENF7nUoUsjLaj9lkgSnzak3OKNBdQe0b399sXHcqWZumTBeQhe3BVVNYKVfH4DsNXSau2TW+nE7X6TcZF3/YacwApVWBCjgLbqmtUlo1ejQiOSl+FDTpQHiBkrTRL6wpJ+9xGttPYaSlgbe0BmBRHv/WBaMVaAZkP5HMJ4be2cFPu6bHII/uOmtwN04GsLLr74qSoexgtdjQQffFYu/xcFhk2QbT5N9uhK8r28VARsPvdKQ8iP2eOKpopVYimDgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1bA8/SLm82jlQl/xCgZDvJNhstlZxlN/kl+W96eOME=;
 b=K+5HUzLk8/rgKeMDSN94sUkyfWJLXbHnIK3h3rtkM9YmubKdLw+9OkVWLuTX6nKMOTqR130WO9V7N/iAQuBqYKmSb1Ab1/Y7a+iW2w2rLF7cw0lYpa/D3AJDNlRJqwg1f8Cf1T7xo30FoRD7vvcj6wkzaAv7PAZ8F8ocKJURHMYlfzGI+kAbzrn+Uuo0VOOutLAH283XAc9e7wZg0QV2+ETCKBEt22/fhRYhHNOk/L5VPTrw89bU8e3W4WUJ1xpJtM1sARdZBHjkees0NeFMm1qnG+Sd7FuLntr/1BQKJq6jzuKqsvfmT01A4kzrziSbHfHfRpbAvluY4yDc8rO3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1bA8/SLm82jlQl/xCgZDvJNhstlZxlN/kl+W96eOME=;
 b=MRT1RfdHb22ejoKqTO8YEMskvtnpJIATaJVifG7YYI4UB24kj6/13e24puKf/YtRu+/xDY1UruHDc3tIEtBF/fr6ejZrV/eaXxRXeZ6O5KITFcVNexbmO4b1Ai+tzmxVpsybZZ4e16sTNWSVgduonO+NUHrn2ldKZLiKCPsMiAo=
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com (2603:10a6:10:10f::27)
 by DB6PR0401MB2678.eurprd04.prod.outlook.com (2603:10a6:4:3c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 2 Feb
 2021 09:59:56 +0000
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9]) by DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9%7]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 09:59:56 +0000
From:   Pierre Cheynier <p.cheynier@criteo.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [5.10] i40e/udp_tunnel: RTNL: assertion failed at
 net/ipv4/udp_tunnel_nic.c
Thread-Topic: [5.10] i40e/udp_tunnel: RTNL: assertion failed at
 net/ipv4/udp_tunnel_nic.c
Thread-Index: AQHW9mMY04hDD4/GNkeljus5vphnq6o/gv8AgAUiwUQ=
Date:   Tue, 2 Feb 2021 09:59:56 +0000
Message-ID: <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>,<20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=criteo.com;
x-originating-ip: [2a02:8428:563:1201:a2a3:4a5a:5b1a:9e2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71049ce3-19ba-4992-8b01-08d8c7614b45
x-ms-traffictypediagnostic: DB6PR0401MB2678:
x-microsoft-antispam-prvs: <DB6PR0401MB267812F43531C62F8D47B663EAB59@DB6PR0401MB2678.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kbrirTql5it+L46rnTa2EOIm7F+4rYE23agiNwkQFes49b9qsLyd9Ky5zQy5LgOnRjgiBGiemN0o6/P7d0OuKS5bDglsph7VrKclgOX4PhQxrkjfyMR2HZ010PGvAsaG59zBV/61aycCNlIaicyLS4f3LejTSBXkdVL/kl+53w1/AqQRAXgO8YA+vEr2jcmGvM/ZIW4WcTUWFX+eJru3xvcwbbwc+E03AqWnlJTqzsowRqSrTGzlzBvHLor6R1j0DyVcCQVaRdmYwV6/yTIJNH51rKyMN/pLhwYyQTNdy0kHr0qZD8YZtQ+yx25n9xFWzgvn2ObfVFEOw02Z0wiAGbtHSZ6PLAPdFAs7Z+uOSRDN4AiElUv3yPCAISZGWEVC61lcOYIHFtggpU6XR+VY2sjg1wFUf8GkWuQ2L69QDmBJpmU4/Zul36xXMlJyAcbFRaTft7yksQ3ZloTrPiRvyyhQpo6BbtiBxc/nSciu6f504Bp+OTupaOvKU7TtPTCb+B9VynhllTY2YhzvYKQiaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6460.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39850400004)(376002)(366004)(5660300002)(478600001)(7696005)(64756008)(66556008)(66476007)(558084003)(66446008)(76116006)(91956017)(66946007)(316002)(8936002)(110136005)(52536014)(4326008)(71200400001)(86362001)(6506007)(8676002)(2906002)(186003)(33656002)(55016002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?jWSIrSsJrA49R+qZXHZoWRWI4+BKSD3rw/KEzmEjTC446ZHosLSbNuyV/m?=
 =?iso-8859-1?Q?5dlyeL3ee1dfE5YdxLBQDz5g4OOlPbMXIj0gV9J6EaEVk0CHiBjh2z+rsZ?=
 =?iso-8859-1?Q?lC2lc3K3pLK9vAxr8aoFxhtJ9rZsWG0kBitrZ3aC+w/5Tw02lqEK+ET7M4?=
 =?iso-8859-1?Q?Ed6/KL2f0St9QQbKlQ86DFB4U03YfJJc5qaNHLhzAuPiEDMwrAykbfgaDi?=
 =?iso-8859-1?Q?W/SzE6NZVTSMenoiyNSuLi0LFv3xvCCrlpDIssqMwX2KgLeR7BKdp+1guD?=
 =?iso-8859-1?Q?NAMKNf1h7/nmIu1XmDKiXN6BvzhS6Z9gXjVltgI+fkK7KSHeUsL4fONoN1?=
 =?iso-8859-1?Q?Yz0+UPqo8wWcxZnUufmiDs96fqj9JJjaJOkhD7iOmo9DDEU3ETB4m3atgm?=
 =?iso-8859-1?Q?DpPxv7SUauyQImJRXgNu+xMiavaTI7f3mcESvO5cvi1FTdET5DNnRbVXS6?=
 =?iso-8859-1?Q?cb0kcyNf7hk46ATjxBzJnsAeym+/bKzh7h8XtEKLy+MBWGs4QncLBHYemu?=
 =?iso-8859-1?Q?ZaT29bvL0Ld501/vEl7Newd42WxNYRYTVrMDoOtWL3N08tITfNhKF2rH8y?=
 =?iso-8859-1?Q?OMI9an5ICG169U/376qvoxjZ3R+B/vScl7Xj2xVlJ0IuHxquRwWIPl4EuT?=
 =?iso-8859-1?Q?L2Zi8Zw80wT6iHKqY1z3inuzNLnt9VofN9F937XQmT4kIM/0YCNDbAqzGX?=
 =?iso-8859-1?Q?7IJVZs+l3JXz+TUeXEqBa6yshiDlNtrbRlXN1OSW/s7lNbjIFaRAG9po/m?=
 =?iso-8859-1?Q?5mpf37tvRuKMb9Vfj3c6KHiq5ztxBv2mW447ok8KDyeLsYkX3jFvlqEE2c?=
 =?iso-8859-1?Q?LJ9/UPTWLrYlO+agx2ZqRKdbAV5Dxp/4irIWo54uem4vod3/njbKjz3C97?=
 =?iso-8859-1?Q?ZH1XK5H33gcav/G/GcO8+6aHXMQ4ke2w45oRi2M17zPFJEAWiXTMLivMQG?=
 =?iso-8859-1?Q?efFdFCxE0yrKx4XXRgY5vQPOzQZDn0Y7JQuEzWyoYkjooBLysTHBumsKza?=
 =?iso-8859-1?Q?Iu8VyQhLTWa2yn+ycgcByVLniVZnlzTTvM59YHd1jCwztXgU1iTRz8DeeN?=
 =?iso-8859-1?Q?oWD5l83CAErNA4nKcAEg/Jbc3UtUtFfPfRRk0n8wg0bbOMgyfDE4qsy49M?=
 =?iso-8859-1?Q?0zDav276TAeWjsiVb/zKOdWRBmpa8AiRLXY/KEkibEBhA9CN3Y?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6460.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71049ce3-19ba-4992-8b01-08d8c7614b45
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 09:59:56.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1WmB/bAv4uVH++0Axs/8bsACCZJBbql3StpuFEBSRKWykBNbA4HqWT3HiMkKBJVvR377FGeAMXobHvtrR76Ikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2678
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
On Sat, 30 Jan 2021 04:27:00 +0100 Jakub Kicinski wrote:=0A=
=0A=
> I must have missed that i40e_setup_pf_switch() is called from the probe=
=0A=
> path.=0A=
=0A=
Do you want me to apply these patches, rebuild and tell you what's the=0A=
outcome?=0A=
=0A=
--=0A=
Pierre=
