Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C0C402055
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244855AbhIFTL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 15:11:57 -0400
Received: from mail-oln040093003003.outbound.protection.outlook.com ([40.93.3.3]:1174
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243755AbhIFTLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 15:11:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkay9/SViCQ2jE9+7RtHNTIiwh1WxunrY18GRwv+40z7wou0JIy6AScnm4qe5wrKjzQZ+vHwZmsT4y+oWMRZQ9E/kCN03g928501eX0e1QFqSPc0BaEN7oPDs3imFwzwkrapw/6/+Ya7DgayBh4lYc7r23cJZXwOEwC/AOpkxTeoS3PDbRm9fIaRZYxEC9UFhlgdWX7zJixCKZOggsWAsHrrFsecHdF3oLCxmt9QbNCORz2hz5xrvbkQfUR5zgNsEjdU7GLnpLannaQYoRwX//8EYQ89/CRwa5U4/p8JD0GuS0osWAr9/hbkO4b86PyNtb+IDerZgukv6d+QeaezfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=G2vUUjW6Z4LunfHdSguPn7k5K4STR0B9El3eMcQ+dl0=;
 b=U0XuolDth7URm9WZZUOee/sH0TRMG5ZzL/OIp0HqREecfzIMok3sqyWt7hPpxd3FWlG1SaGER4etlvb31oyfqeWzLd/uCdmcnVehELvJ1F7oE4HMPeAVJv+NjYMLA5OAG2RGq805cS5+/JaiYCkRLySiFt6fB8vAP8XLqDapE8TZ1fV9kHIKWnqiLe1Ad3ComuEhJFGK2s9tOp0Prn8nQmtN09JTDp2tx0BKsKQ7nAcX51XVmE0/58cZPaCfqu3zBZxf0/5aeSx098HQQEWdhGua/V5PJ4b4c/wH1+fkvVusfPGGehUAH6qtGGlSRS93gjWNtQVJAymnDvv/CaVsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2vUUjW6Z4LunfHdSguPn7k5K4STR0B9El3eMcQ+dl0=;
 b=eG/d5+UPsj2a5cYs9sIxxkGQtLLlfsq52G+WKkWf1qqGKMFTCOWUWvs5oSyUskZ8QXU18nbp/1xjcPZzH3LAfTdNorZa/AE3Ft4eLuuoEvUvlCCkwVFIzyRHohghaP7UhP3t3JEBLeEVmlshfud6pJFFS5NecYAGDqW5BhHr1wM=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1622.namprd21.prod.outlook.com (2603:10b6:a02:be::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.7; Mon, 6 Sep
 2021 19:10:46 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::d9dd:dc3b:2f98:7924]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::d9dd:dc3b:2f98:7924%9]) with mapi id 15.20.4500.004; Mon, 6 Sep 2021
 19:10:46 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Thread-Topic: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Thread-Index: AQHXov9L/BhYZtlmv0aYWU8ANIV5qauXXKYQ
Date:   Mon, 6 Sep 2021 19:10:46 +0000
Message-ID: <BYAPR21MB1270B80C872030CA534C667EBFD29@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20210906091159.66181-1-sgarzare@redhat.com>
In-Reply-To: <20210906091159.66181-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7bb7a008-996e-4318-bc11-56fb8840d2db;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-06T18:59:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcb9cf68-789c-4069-ade9-08d9716a080f
x-ms-traffictypediagnostic: BYAPR21MB1622:
x-microsoft-antispam-prvs: <BYAPR21MB1622E1477F92E36ED7E89D20BFD29@BYAPR21MB1622.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 82+idIrHhxZaeo6tX+Fdd6HjVzd3J7iEu7q1WiSrMIxVRDVFV9ulTohzKW8MOnWMriPYUy3tKmEZYtXk3ccLtHwqGDIsghsJLJrA14FojTkr6iA0QP6Qvniw6g60pTGZ7yOHLLAPMekcMmxXoWoG7IPekvbdTmTBzCqT4Mh9s6HHzwlx3HkyEXSSZkWHBdG34X64L2TcR7+A0JdNIUwXHvMqy0L80dAV9WleuoQpTGd9h3mXVH2yIF3KbLhhzJNFtdD1zlB5Pi1EhKctgduFOYrS9T5QbWV1VGW8e07V+5Shqh06A8bHjqk/KvLmoLrpDTG8Yo0Dyr86/Qxzyx3JZG0Vk45qqY3rqtKuE59U1n1iXSKWgqrKtLuQ5T75fkkCANBITm/FmJ/CztQgXzhrn1odp+VZxiTIf59i1OvBSuzQ71tHuFctYFLGBM01g/UnGHeC9+tGszbZUiC883d/RlTfNDLCvQ+XnP56RuqtK+oFqUyzV/UkDvVqjiJbWOGQv5IaHboQpvjFWFdDkrgGaCOqd4RC7H5Te+AUf1lylzCuosUXxnMlfUWKhPa2US41u9OoKyLbnb6s7Je1YGI8R2MVRB3ZoxBtLLj6m9Gikev0+fBTtzYk4dUjiavOovHJJA1P/eikhOOQVoKugYG7ElYlXtvq4OSKobLBeAAX/k7DkL3t7WEe/3kX1JXy76Pl11q2Ye4LxIR4sJZcN5Aeuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(4326008)(508600001)(71200400001)(52536014)(7696005)(4744005)(6506007)(316002)(10290500003)(55016002)(86362001)(8676002)(2906002)(26005)(122000001)(76116006)(33656002)(8990500004)(186003)(66556008)(64756008)(66476007)(5660300002)(66446008)(66946007)(54906003)(8936002)(9686003)(38070700005)(38100700002)(82950400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fm1EFmHnADCTmYo3ZvsI1PZ8fkPqD2FJXNMSdZatLqPFCKLEXAN0FTV//xdk?=
 =?us-ascii?Q?8QRH8JfpGs/r47S0BuAL2wG96vWbL0N2A/EESfot6V4R+kCnGNR/IHF8iytL?=
 =?us-ascii?Q?/uEZ4TI7iq7gzshlNibheouUVE0oMNEnSJO9q1X+k5nKQZ5cYP8yMv6LiX2b?=
 =?us-ascii?Q?QoUfRVLBk4+33FBN9H4KCchmxOay7smjPE2cQLQzvbz6rAXwxUd3Tsm/PWho?=
 =?us-ascii?Q?ofGfHkaiBmdSMv5zEa2HQWp00nsyJUrM3i97a+9JPxWrXLjy1t1xPnMVRjJe?=
 =?us-ascii?Q?xqP1+1PM7Ajo9dCNk3EhSOUrZVb3tZCd747O2e2PUoylnOV2p2BHRQQmBdF4?=
 =?us-ascii?Q?hPETFDppUGx6WMOgcnrLj2yygsBDbR59LvHXRQiablWMfTITdDJNnTEKlHQX?=
 =?us-ascii?Q?b/uEPR8ybnZZrTgp9e6yDDxfPu3etVnSnkWmnjCVWMxGluSWUVYatM50aapW?=
 =?us-ascii?Q?D1WGNvRI5TUlNkFMwOChG7YuzksHD87ZWlol6/eFn0ceOY0qkz3WOy6DB1ft?=
 =?us-ascii?Q?I8WfEw1m0ZHXL9K8aJ5o00TCHZ1ShPHHZ0iw92ZLvyUtQWoCK0oDxLhdWAUq?=
 =?us-ascii?Q?NNuQZI3S9sWue8bZcR7+IdUlI/fnyEskk/r0mNTWJVMjO1ZQvAuVylsMAxhh?=
 =?us-ascii?Q?GzSz9MlLcvymPqhD+FSrNMzGNSHoZYLJ6cnHAINVlf2QcLnGDnu1/JJ8NwgA?=
 =?us-ascii?Q?JcB/5rWF6tzY+Uz8NfOm6Lny4iSdRygk28rNnxf1ianse6VyUI81VGKwjfww?=
 =?us-ascii?Q?KQm2y9OZONs7UvwZUI+FtennLmpniJ1rQ2DsQIfNgwnFq9eLbE7oeC7Itvmi?=
 =?us-ascii?Q?SoHx97LE6shRe9v6os5WLdeiyjEhIgkyyp7+CJArAeIO+E9X9xiFEHBPZOxO?=
 =?us-ascii?Q?cor9QXhljVKLhN7kBou4IL10qwZanN+NCj9hcbL2y+MhF7oWcnh/aMvr0pQn?=
 =?us-ascii?Q?fQaszJ3PiQCJNJW+5YBNKq5ZlnmyoyNiBKWSkcRpasOdZRKaNEI+bekUgAGs?=
 =?us-ascii?Q?wxmEnGpEA9bwTNIxtt4F4mp897/MgcGnSmmK/EYzN6ZKMtfm/DgerRs+0kHr?=
 =?us-ascii?Q?RRhjqwHmd/GhrVp8vh0jeP0soii5jD/xAPyZxKf7syVDwO5AaCC34ckISMX9?=
 =?us-ascii?Q?RHhSvCbrCXwKG/bgqQsKyHGpxS58u/thhRxZ9dY9uxsX7SgFvuZzJVowe3Q7?=
 =?us-ascii?Q?5W7KVft5Hkjikf8rDA/z/aJN87mVFJ9zmTD80exY5NewmxP9pc3RcgRET+AH?=
 =?us-ascii?Q?+8mZlolDrUx4mvNF6n1JURB1hlFrFmbhRakBNww7mC9gZeu66PU5DM1jqOc6?=
 =?us-ascii?Q?DRwbx+z+lWM8A9drvEWH1P8T?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb9cf68-789c-4069-ade9-08d9716a080f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 19:10:46.4613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zu7y0cgfxEVA+I84RaZyEw9VvXZh491HtxpXmaknrod4vcQAtQV4zlLPoqdexB5tapK0rlNV8IZlqULNJztGxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1622
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Monday, September 6, 2021 2:12 AM
>=20
> Add a new entry for VM Sockets (AF_VSOCK) that covers vsock core,
> tests, and headers. Move some general vsock stuff from virtio-vsock
> entry into this new more general vsock entry.
>=20
> I've been reviewing and contributing for the last few years,
> so I'm available to help maintain this code.
>=20
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Jorgen Hansen <jhansen@vmware.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> Dexuan, Jorgen, Stefan, would you like to co-maintain or
> be added as a reviewer?
>=20
> Thanks,
> Stefano

Please skip me (I still review the hv_sock related patches).

Thanks,
-- Dexuan
