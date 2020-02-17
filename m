Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6748D161406
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgBQN4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:56:01 -0500
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:6250
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgBQN4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 08:56:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnxfxjPgMaY+0M7i31xR2mkUsp5WKVEJV+gy8duzmEltXV8kbsmyKhA56g3R3DVAU9XnqSmpoE356kdNFMbfxu0OZekUsBSHVNEf1CDy6PAgt7DRGnFKpWcsp3tks3MZ+flRE4B667DPCpnmaTOnOlYE/aHI7xg7Nekb4u6pl4ATT9wcF8+VPg0W7ZXVxM27LykgvekhfbtSsUWMT2dWZgkSu5tCm4ho7NLo0EhDFrvLpF0G2VWZ3K/Om2X33U31Q9G+hHIY7kEjxGVuO/tAnMgSG3KlRaQzW/jrTk/JqemC0Eb11jJOjQMJiOHhA4y6LSJuQC32DF72WQ1YCKdDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZDO+xJm7BMB+GnSpPzRaR/QFiE9cs8VG7pbk6lvD8A=;
 b=VLkzYMz69DYyoFrAPIuDE74lIyMk5JZZix/eUTWIgqbiih6RtoLevfmGlG0IsyJ//cdmxTCfG0m7g8IQoWCwBDjRiyB4O6sb1MILLrtbCu2U28KcnSCT02VjKBumbel4mRmM3mwRPeLS/P3vPCwhiUgmxMz6ywbmb7yWfQylf4wB6lkhe+FWSr5i6xkLjGb28uI5WBhTsrRcz0lX36aJBgClMOcKknBo/n2bpCGvvPzCYPUh44VzZGBAqAX5oT5ReBPleOSBGhgkKVuYvuCn5/3JGgy/i7Pmb/+h8uaRHt4+n8fgyUErfQce5TLJUmcfY6cJg2fQlYQMeTifQW6isg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZDO+xJm7BMB+GnSpPzRaR/QFiE9cs8VG7pbk6lvD8A=;
 b=Fj/zAy1pMnMUo+a1fygNfjgdP0ym6YA9L00NPBP7C+welq/j6ekqbU/ybcUIw/cHjJZdiluePsMmc1mMsFrwOou+eu5tTdPg5geoPwD+ToP+5H3ZO4hDRUJ79uMcpdIzy1p6xjyZMPozUJDcaDB8fPJ7ntky0HshEyPgVUfC6jk=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.174.19) by
 MWHPR05MB2974.namprd05.prod.outlook.com (10.168.246.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.13; Mon, 17 Feb 2020 13:55:58 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::51b6:783c:d99a:ddc9]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::51b6:783c:d99a:ddc9%3]) with mapi id 15.20.2750.016; Mon, 17 Feb 2020
 13:55:58 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
CC:     "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
Thread-Topic: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
Thread-Index: AQHV4zfJqe1l5HpcNUuu2+iQYujv9agfa1Vw
Date:   Mon, 17 Feb 2020 13:55:58 +0000
Message-ID: <MWHPR05MB3376C52124D5BB1835CC3362DA160@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20200214130749.126603-1-sgarzare@redhat.com>
In-Reply-To: <20200214130749.126603-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f047b07-4f07-4a9b-06d3-08d7b3b11dfa
x-ms-traffictypediagnostic: MWHPR05MB2974:
x-microsoft-antispam-prvs: <MWHPR05MB29742ABB612C7E389F467BFCDA160@MWHPR05MB2974.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(189003)(199004)(71200400001)(52536014)(2906002)(54906003)(110136005)(4326008)(76116006)(66946007)(55016002)(9686003)(66446008)(66476007)(64756008)(66556008)(186003)(8936002)(8676002)(53546011)(6506007)(86362001)(5660300002)(26005)(7696005)(478600001)(316002)(33656002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2974;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VgOG4s+nV5pBB7IXO/6j6IkyhNhC/Kllf7/dBDztR+V1CuvAqgFr/U4qiO/nZQClhlFWWg16C1jkbsodXbzicY5SGY2fyZAMghTwS3dKlmuicHTAW/5fM66mAYufrj5rZgIayVqBgi8bhuqHEJkCB9eUbFdQz+2JTMt7xPWLfKTB+/2AVz/Uq1kcjBYwiOIK8zjh3qFL1cOo++Code2JMF8RzkyI1MlQuuDWH9NDflPysYJOgaJDznKrNVXqFdhVXFnLar5LzVOAOx0ylwwiDPR4gOBpTr+01XtCvY9LIa829ro6saEoTXdTdr+oq03SZ4ucVnHIe6VMrALnmCSejq+NzYN6KlYXAIgZwU/piPLbNfXfMpuVgi9PAXM9IOgZ7UOslPqx3s8VVKP0+CABOfyU231L8zzeT/X2okL0jPMS0S7AOHNuT2k601V3PBzC
x-ms-exchange-antispam-messagedata: tGg6EWLfZoYVlRFfu1ieG1FsbJjyQ6lW4zDdbycxODlICAsNEj8FmVrZSGBFKGw2jVJIGJOAN4/SrThjRqASuoTE4glRzILdm2PveT2Q31HlHARBtRO6Pf7jTeHxjUra04KKbfogrFc7aC5zypaPRQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f047b07-4f07-4a9b-06d3-08d7b3b11dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 13:55:58.8713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+aPRNtlURqPykHNkXiN60zk3/O2yiAqzsqI5D7IuM9Fe4OpjN3hTUI6ZdLeKTVVNufGI5I6qGcHJa3IRvh0fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2974
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Friday, February 14, 2020 2:08 PM
> To: mtk.manpages@gmail.com
> Cc: Jorgen Hansen <jhansen@vmware.com>; linux-man@vger.kernel.org;
> Stefan Hajnoczi <stefanha@redhat.com>; Dexuan Cui
> <decui@microsoft.com>; netdev@vger.kernel.org
> Subject: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
>=20
> Linux 5.6 added the new well-known VMADDR_CID_LOCAL for local
> communication.
>=20
> This patch explains how to use it and remove the legacy
> VMADDR_CID_RESERVED no longer available.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
>     * rephrased "Local communication" description [Stefan]
>     * added a mention of previous versions that supported
>       loopback only in the guest [Stefan]
> ---


> @@ -222,6 +232,11 @@ are valid.
>  Support for VMware (VMCI) has been available since Linux 3.9.
>  KVM (virtio) is supported since Linux 4.8.
>  Hyper-V is supported since Linux 4.14.
> +.PP
> +VMADDR_CID_LOCAL is supported since Linux 5.6.
> +Local communication in the guest and on the host is available since Linu=
x
> 5.6.
> +Previous versions partially supported it only in the guest and only
> +with some transports (VMCI and virtio).

Maybe rephrase the last part slightly to something like:

Previous versions only supported local communication within a guest (not on=
 the host),
and only with some transports (VMCI and virtio).

Otherwise, looks good to me. Thanks for making this update.

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
