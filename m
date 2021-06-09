Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216553A0BC4
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 07:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhFIFRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 01:17:39 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:34584
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231329AbhFIFRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 01:17:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTjv29gGowmfichfqyGK25mUnOKx89g3E5CBYqUvkOtZLLCsuNGbwQzRoSwoJuNxHd5rELQSVemrrjRG9hohzMY25bOszBEx7MtyQ7c7MWHO+rihRKYiTzCxT/tqG7VhkSsOtUnfB7c+por+MdrarbRRf7NvOa//SLcB3I9NAIQeIok9Udne8JTlI4a8YrSg9TXK7CLjc9cEYUCKJo2bRTp1pGlqxhiGgZMvA85W0T8cDSi0U4BjQTkj9AGse8pHvA+Q1ndbb1IW2wOfcSI1HQjqgdJomPfSzsm21RC4jozNv/DpK6DQmUg9pAgQkNy/7vyIhbU9t58sTi6MEEXv8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN5fGdt7axDnDBt7BTyuvBAhph3z65wmq5R3loYeogM=;
 b=PaOeWV2/9wxXpjx078JxMCEhK52+30rmcj6UG0A0tDkd5sHr1DSdeM5WHAcB1r+7iUsKrLSVpihacG41Zhldc0PYXCOM/6nJoiHNhaRiLDyFOX/NL/PavDiv2NhJX5T7CSqEBNNXI2WkOYiam7Tpm8BW4DDFjwH7wYzGfOucGAB5lwHm3eM7wkfAdhDMwbZT/37NKMak6WwTBZ0SNlGbds68kXNGAazGlW0I6FOPZ+YBYTo5+a2slCnTc7iTWFAaiXdeAMigVK9RNnTmjYemqKwVVJ7CPgLwvdOokbJD9RFZJfJanEE+kWYNnhuHRXf4N8kRTmwz+lfj8kER+oIigw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN5fGdt7axDnDBt7BTyuvBAhph3z65wmq5R3loYeogM=;
 b=oSf98K1dUGZKi5GxCw6gtFJPt1ry5v+T/Hqj6McMSshmTuXO4bdaV/seC2mcaBzkGmhTFOCRymnnw1vzn2egsa5AXwdgxpmTDBJCn4ZAwTOAEYJyOn1veLulo+758GahtpNDG5woNsBPePDfLIBBl0OMwalvELvF2IH/Hp1NXZ6QRDaivQ4BfgsfeGU1ZEymybEQVtJ+DMpZPC03XaWoHsEVd0dXPPKNmewOWfgjtraYVIpQNYQKiY0A7pmQtTYWpHAmYT8LLCWo9f+I87P7mJo/jn/24zjSM/Wi1JWweBCWwXAeyDnDKgxQgVXv8anaDbPeWaEETqq7MY78VsHFtw==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.23; Wed, 9 Jun 2021 05:15:42 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 05:15:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2] uapi: add missing virtio related headers
Thread-Topic: [PATCH iproute2] uapi: add missing virtio related headers
Thread-Index: AQHXOGe6eevrOHQvxUajlYYxsaO5m6sLaldw
Date:   Wed, 9 Jun 2021 05:15:42 +0000
Message-ID: <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <20210423174011.11309-1-stephen@networkplumber.org>
In-Reply-To: <20210423174011.11309-1-stephen@networkplumber.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb42d2d8-582c-4874-c2d5-08d92b05a0d6
x-ms-traffictypediagnostic: DM8PR12MB5480:
x-microsoft-antispam-prvs: <DM8PR12MB5480E79E5F8E41F7B8AA741EDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ko8FXHOQ5T+jpbJ+qmi2puwhweOq9jq/2iCQ8ea3pN22iMTZNSQUycgLsFqwf5shaKmvSDiUIB4xEZWuvjSFYXU1c4aYzhFtNxXY1rzNPwff7tvThUXnQQya07nUzrFcZ0hr2bHKVb8I3BAe/Yf8aSu/qfjOVYOKZG4td/zTlp0M9tg0PQkOemnbioHU+0/R0fNHVVxZZniwICnF7Ha6+Z+wmYLK9LKWRDcrswVd4mqoQ6Ry8IF1h12XPP/8VA/qSEKKQJu8jyZGlQi0Stm2h6iyxp443rY3B9Th0as+MalvQCw8gmB8gxul1lDjt4o4MzUx7oska8SG9p+vR06FUcP1RNJibuf02cfP30uOmfOCzE2CnSu/jNnvVsPPWpru35R2f81LHkweHpT4tai5ZrmI6KH47061cCsvgobHjWfknILqm3w7qMta/cOV0xW2LLlt+wxfHnFo3MWYFjheJ5OIOSauALobKfXiJR/NqyTU3ID58ve2qlGNoTXV92UKGTG0dDXkLEuVAOUES9p7GvUtu9Q7EA2lbOvK45sHd/tg8izZ6GoYfMvXjdtFAuEE6vV0smSizBvCQVcSojkbeYwjfD1+KPiMVEq1t13nN6gBoZEf4T3++yuMqa4tp4gwpX71veEiUZdwpg/FO7xWILoV3ZH65U3zOLTJEskc2CroYOwlclBNCJhSFP5UJOhDSVWwdAdXJZpgQX9WIU3x0WqgYFkprQFrJaRIdKrhKBo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(66946007)(8936002)(76116006)(55236004)(26005)(8676002)(6506007)(66446008)(66476007)(64756008)(38100700002)(83380400001)(5660300002)(316002)(2906002)(66556008)(71200400001)(55016002)(9686003)(110136005)(86362001)(122000001)(966005)(478600001)(33656002)(186003)(52536014)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FCngCqhdWLky1W/3+nct8EBijPyRkI5rWKedjHS0qNL2fM76Sb8ILyApR+cl?=
 =?us-ascii?Q?0LtrveNsiegmmbotJmp1+yXR4iWaTtL9K8zFQNOmwCTttzz99Ay5aK31HW0R?=
 =?us-ascii?Q?1YgUmvxkuONkKutv2/RsBf9ry89O0schyKCJ8W3X18woDYK4J9T5yVvEfAcs?=
 =?us-ascii?Q?u9cIwKxEYV6dbzIpDD6aylY80AILwV95nDW3H3cTy7UMHFHnurlKPsk856D/?=
 =?us-ascii?Q?PCjFaCkkdTl7I14XmHLQF3JdUyPCeZCTclCW1ulyimYR4rCg9g9yHfbWzWcZ?=
 =?us-ascii?Q?KZQKNfuYvYZsygx7FW3vh3iutHIpfB57e8dnHcACxQhKzAm9sVUNovqa/c8o?=
 =?us-ascii?Q?ZH4UzAMFVyaHi2KAgjYZfDe0VK5wVx1qIq/v386NV0Ym/tl3vPDGjQjbaLMg?=
 =?us-ascii?Q?EF2yqdYphsyWFGYwRllG0w9VSALdgWTdC7zQrWYP9B1/D2zPLptiZ2mbyshP?=
 =?us-ascii?Q?S5Hj+MbHhszotf6GtOQIijqksIxZazHIBD5pvlLW5odo5TC86fD+W8qu4tpy?=
 =?us-ascii?Q?u3cG1QPjyujLsTyZNy0jBGtDOizzXEGWdWMcb2BNMft5tltRezrEqXuLSoAX?=
 =?us-ascii?Q?xXkRJZZzivLSvbled+A9v48rKAy/hXHcFG1tDt4HkJbAy0W382fszIa3hXYz?=
 =?us-ascii?Q?wWccID3HvKMJp/szkMvxsFAmONXMvSZ+ezkZxndGxOhe+sSlRMVR0VM4XgSX?=
 =?us-ascii?Q?jacoOG6ZzmA/E07Buuou8hZMvXR4iM9YvKuuKa7gqMnCtiu+JCPlKAkOA3xT?=
 =?us-ascii?Q?xoq81NLbhdnehA/vLjwcnVt4ukkAMvyIP8rhVFZZI3tPNE5/Yob8q6hg/wlG?=
 =?us-ascii?Q?ilgG/K1JAjmFDUIMoa0PZVNdERuc8UB97vIDRAQ0lowlOmvourJDPXKErQlM?=
 =?us-ascii?Q?gaDQY8dJDjRLp77sfVI0aszz+gOwxTNIJgFMAyahuhYT6l5+d8p7zMEQgdyn?=
 =?us-ascii?Q?sTxL9XTXfDHJ8PfxYFGJ1CNHGY6hir2js7uYXJVrLyNonzRloz4M6DUqSA05?=
 =?us-ascii?Q?HOPiCIl0ENZAEc7my8Ux1INKWc6vqW5/WkTZjJ28tiXwH0HRZOfG7dGKrx9U?=
 =?us-ascii?Q?CjmhLMIbEezl08Qfp0bd5xOMQoBYNXg6WCKdZJud5AUghfBAblA7gskudb0I?=
 =?us-ascii?Q?L21ckPaodMYOn6q9v1ymK5cKPTIU4b4AcAvZwjivcmxoh/7AXqLsA88oDE38?=
 =?us-ascii?Q?1ZQ4xnN+TtHMsuqAiqMgleQxeWF13CSPMTd0hdFfCcLu9gCi9MBRCrdOFnYu?=
 =?us-ascii?Q?4ktoPMEUZhlnbVpIxgtKcZEm9L1EccPPOibCdNUNzPn7KAO7fBh4PVd5F83A?=
 =?us-ascii?Q?XPd8ggmo+A3hiBwKTBg2lHME?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb42d2d8-582c-4874-c2d5-08d92b05a0d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 05:15:42.1770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +xFOG/3l0thh9VNYstPxaFg5dlHJhuQMxfVP14+KPsBnT0uv8qL6CiMwRDz5uE5nlNEC+cw89Boq9qKB9PbzSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

vdpa headers were present in commit c2ecc82b9d4c at [1].

I added them at [1] after David's recommendation in [2].

Should we remove [1]?
Did you face compilation problem without this fix?

[1] ./vdpa/include/uapi/linux/vdpa.h
[2] https://lore.kernel.org/netdev/abc71731-012e-eaa4-0274-5347fc99c249@gma=
il.com/

Parav

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, April 23, 2021 11:10 PM
>=20
> The build of iproute2 relies on having correct copy of santized kernel
> headers. The vdpa utility introduced a dependency on the vdpa related
> headers, but these headers were not present in iproute2 repo.
>=20
> Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  include/uapi/linux/vdpa.h       | 40 +++++++++++++++++++++++
>  include/uapi/linux/virtio_ids.h | 58
> +++++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+)
>  create mode 100644 include/uapi/linux/vdpa.h  create mode 100644
> include/uapi/linux/virtio_ids.h
>=20
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h new fi=
le
> mode 100644 index 000000000000..37ae26b6ba26
> --- /dev/null
> +++ b/include/uapi/linux/vdpa.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/*
> + * vdpa device management interface
> + * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
> + */
> +
> +#ifndef _LINUX_VDPA_H_
> +#define _LINUX_VDPA_H_
> +
> +#define VDPA_GENL_NAME "vdpa"
> +#define VDPA_GENL_VERSION 0x1
> +
> +enum vdpa_command {
> +	VDPA_CMD_UNSPEC,
> +	VDPA_CMD_MGMTDEV_NEW,
> +	VDPA_CMD_MGMTDEV_GET,		/* can dump */
> +	VDPA_CMD_DEV_NEW,
> +	VDPA_CMD_DEV_DEL,
> +	VDPA_CMD_DEV_GET,		/* can dump */
> +};
> +
> +enum vdpa_attr {
> +	VDPA_ATTR_UNSPEC,
> +
> +	/* bus name (optional) + dev name together make the parent device
> handle */
> +	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
> +	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
> +	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
> +
> +	VDPA_ATTR_DEV_NAME,			/* string */
> +	VDPA_ATTR_DEV_ID,			/* u32 */
> +	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
> +	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
> +	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
> +
> +	/* new attributes must be added above here */
> +	VDPA_ATTR_MAX,
> +};
> +
> +#endif
> diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_=
ids.h
> new file mode 100644 index 000000000000..bc1c0621f5ed
> --- /dev/null
> +++ b/include/uapi/linux/virtio_ids.h
> @@ -0,0 +1,58 @@
> +#ifndef _LINUX_VIRTIO_IDS_H
> +#define _LINUX_VIRTIO_IDS_H
> +/*
> + * Virtio IDs
> + *
> + * This header is BSD licensed so anyone can use the definitions to
> +implement
> + * compatible drivers/servers.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in th=
e
> + *    documentation and/or other materials provided with the distributio=
n.
> + * 3. Neither the name of IBM nor the names of its contributors
> + *    may be used to endorse or promote products derived from this
> software
> + *    without specific prior written permission.
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
> CONTRIBUTORS
> +``AS IS'' AND
> + * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
> TO,
> +THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
> PARTICULAR
> +PURPOSE
> + * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
> + * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> +CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> SUBSTITUTE
> +GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
> +INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
> CONTRACT,
> +STRICT
> + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> IN
> +ANY WAY
> + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> POSSIBILITY
> +OF
> + * SUCH DAMAGE. */
> +
> +#define VIRTIO_ID_NET			1 /* virtio net */
> +#define VIRTIO_ID_BLOCK			2 /* virtio block */
> +#define VIRTIO_ID_CONSOLE		3 /* virtio console */
> +#define VIRTIO_ID_RNG			4 /* virtio rng */
> +#define VIRTIO_ID_BALLOON		5 /* virtio balloon */
> +#define VIRTIO_ID_IOMEM			6 /* virtio ioMemory */
> +#define VIRTIO_ID_RPMSG			7 /* virtio remote processor
> messaging */
> +#define VIRTIO_ID_SCSI			8 /* virtio scsi */
> +#define VIRTIO_ID_9P			9 /* 9p virtio console */
> +#define VIRTIO_ID_MAC80211_WLAN		10 /* virtio WLAN
> MAC */
> +#define VIRTIO_ID_RPROC_SERIAL		11 /* virtio remoteproc serial
> link */
> +#define VIRTIO_ID_CAIF			12 /* Virtio caif */
> +#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon
> */
> +#define VIRTIO_ID_GPU			16 /* virtio GPU */
> +#define VIRTIO_ID_CLOCK			17 /* virtio clock/timer */
> +#define VIRTIO_ID_INPUT			18 /* virtio input */
> +#define VIRTIO_ID_VSOCK			19 /* virtio vsock transport */
> +#define VIRTIO_ID_CRYPTO		20 /* virtio crypto */
> +#define VIRTIO_ID_SIGNAL_DIST		21 /* virtio signal distribution
> device */
> +#define VIRTIO_ID_PSTORE		22 /* virtio pstore device */
> +#define VIRTIO_ID_IOMMU			23 /* virtio IOMMU */
> +#define VIRTIO_ID_MEM			24 /* virtio mem */
> +#define VIRTIO_ID_FS			26 /* virtio filesystem */
> +#define VIRTIO_ID_PMEM			27 /* virtio pmem */
> +#define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim
> */
> +
> +#endif /* _LINUX_VIRTIO_IDS_H */
> --
> 2.30.2

