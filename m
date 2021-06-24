Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86263B38ED
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 23:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhFXVxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 17:53:25 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:42887
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232300AbhFXVxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 17:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkKNlpcW34oak1hSzZZHaHJiGiGROV5cvDeMgFw/g/tQz0WADh07xqjjHDGN2KRK07SLUR4qI+S06QWg8DAf73BkgGbOhvWbCi/iyz8KCtvsR8fEYDUVIZJPMiPKVT0PPafHf7s16hvJopr/nP0wfnqvhelWCACMKmljZFFeT52SYoDgjNfrIoXcgVtJ56EgyHNEF6iwz3qWt3ZGoWvO5JB9aceKpAL4iMYzrdqgEAEQe3LCPlD3M0ZGW1m8SRpncy5Z53WwWsvCN3KZyRv6PW6FuSYVw8zQqtgeyn7SYFsdZzxYbQJ8wFPZxUKD2+uEpuePb/fQJboDfwgdgc05Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tED3YwhehVm0mSELPBZ9QPpGz+8RpJkUlgMnfneFDOM=;
 b=m2RoeN0vUxkoiSirgEZEBTrOyWCIOcOmjIKLkDerMWdgQdtq0KZaw6jTdwXz8grMaa/nwkJVTAlrvbjymtbT/13MP0urxhiWuPHWTzjt7zvknIsHRrxVT7BdlRzD5FNeBFmtH5hnz2Nei4i9K+6PmAc2na5Xgg6xpusfASea60Mw6zdCxH+VI9av1WJqU6esqoCxOOIkjh3aMIXwMFdPGAGGfLLdszTFpnxrYGRtbVpaNfrxaTeXfKiZ9sbSChJ9Q1dn9Hajq3Xpljv5D5vWlLt3eoofJntkcp5tMoL8mNvErXpRfqEs2HSWCtgGOCwNIupGCUyiv5rdKqSCLtuc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tED3YwhehVm0mSELPBZ9QPpGz+8RpJkUlgMnfneFDOM=;
 b=stVxNyLdwSL5SC4YPqHR8yxgHbqeM4AnLew44/u0tPc20wSjy76pIAt1rb82ke1iuZHL/BuzB6i6u/uqXJxUfOuq35ruc91xvY60kOOxMYOvX2ZxUwAedwgh2oYEDWyNWGp6nU+WY92wvf9Y2c60v7La/ZOc5JDFqD902Fa1qVI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Thu, 24 Jun
 2021 21:51:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 21:51:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Danielle Ratson <danieller@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "amcohen@nvidia.com" <amcohen@nvidia.com>
Subject: Re: [PATCH net-next] selftests: net: Change the indication for iface
 is up
Thread-Topic: [PATCH net-next] selftests: net: Change the indication for iface
 is up
Thread-Index: AQHXaQvfLTLjVCHUhEWgfLSjz7XPaqsjs/QA
Date:   Thu, 24 Jun 2021 21:51:02 +0000
Message-ID: <20210624215102.auewn2cod7z5kjki@skbuf>
References: <20210624151515.794224-1-danieller@nvidia.com>
In-Reply-To: <20210624151515.794224-1-danieller@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca771c9b-67ec-4305-d739-08d9375a2974
x-ms-traffictypediagnostic: VE1PR04MB7328:
x-microsoft-antispam-prvs: <VE1PR04MB7328B0A448B92C82E08DA064E0079@VE1PR04MB7328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jw+qn/XJpsSS777MMmQwF3u+KfGbTQOO9L1cEIHggwV3ebGNqIEdNSFz/S62m0y5Xdvw50O+we9IXtl9E9qe7P9t4W6yho3oo+a6eZKLnqY8hepyFavUQXffWzWMudbmIpuwGUROFe3qqMK+dm8Dm6fwKHUnPZGJcj5P2ixtE1s6LhvpHWZ8EYdcnRGPiaFIDLuEYfdudxYmdJkx4+W1inF5LqEjUZeK8txEaaX/J+L33CqMHqLd/bH+8191VrHy2PjcAdNsl3rhKn+lqKf6MAHWV7CRg+LJe+bocLHgdlRTAOwfQiQLjL+bHvs3/baItYyl0RrupKeRPoGDQD/W2Oc4Qxyt9iI8GoMZRtUgP1f/6IsMrnGpzX2zn7rPwDNueLci8Zp9VIxXW3mqrUBQIup83cKaXuV8I0w/xx+6s/r6ZUzjmtm66ZrBAah12sI05mFdjgobJIAg9WF9+AwhrM4yxRT5K4MV4CY95qHMBPqgR+U3UFBrS66vb8NTlqcLUQqdQaSipY2qFOfvORzp/o5qOoKBJ/yu1bVrIm34AAn2l4/ooHFJrVU9XbVuJVV1zdFe5Ea3h+vKlXyHXCxDnnNu2wqtqYKUZOZ9+9WSSjA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(6486002)(54906003)(86362001)(2906002)(38100700002)(76116006)(66476007)(66556008)(33716001)(66946007)(66446008)(6916009)(71200400001)(5660300002)(64756008)(91956017)(316002)(1076003)(122000001)(7416002)(26005)(478600001)(6512007)(4326008)(9686003)(8936002)(8676002)(186003)(83380400001)(44832011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4/QpJFjNfPhk8V9lsNuvAqSyNIJxWBSc5N2clNljpW8+AqCN1vErk+dkBS?=
 =?iso-8859-1?Q?C9trrkLTY+MYxQES8gvRk8QrcEJABWUFIB5ImH7i3m343lTrpfh4/6FOft?=
 =?iso-8859-1?Q?kkklOb8TD+gTDF1UuRsxE+A3sw2tRIPxr/tFqWSpc/hsC83VG63zerWsT4?=
 =?iso-8859-1?Q?wa5VF7jxGJGsFYFDUQOwTEnPyNKQ7GdHQSVBIMilCRzpBnfStmOI4l3cBw?=
 =?iso-8859-1?Q?+7adNtv+BpV4oDqNpZYf9aE9J3P8sPm2M35jT2Ql+khJmumSwJrLbwBGDl?=
 =?iso-8859-1?Q?87fGjTLIwVq3sjZ6RJRBM+2Kn+4jufdAOYubCQtlpQpRztDrTI01163zU/?=
 =?iso-8859-1?Q?2FTenI/CtDYtmH1GZ7vqZO7pCLj+xFSnkrAk44XoQqAUz7XkXeNzvniAkQ?=
 =?iso-8859-1?Q?KEfZGCGn2TU8IjHHQOWbOCgIoFJzCs5FdetFHH8M7Id4Us9s3N9aSVum50?=
 =?iso-8859-1?Q?b+sUdsPx9geZGlGHHADP1BmmOg/eFtjXwcn91C1yLJp3pnW24FP9fqgwiw?=
 =?iso-8859-1?Q?V8Y4wOuW2k5g3m7SUMBqZ/d4bo9o0+X2QUl6mwnHn+mVUlbH0MJR+mDP0N?=
 =?iso-8859-1?Q?hDttOeejPoLhZdnzeb0HYsTf9S5ASljpcPe1/fTk/JFfUotJDTqvdkpN5o?=
 =?iso-8859-1?Q?flfJmJRicqqHP5iRfV6PhjDbFD1UEGUJmrClff6hBukq7pIwvOfXNZ/Wqm?=
 =?iso-8859-1?Q?cmsIjMvfHq0JBgwiuPsnSSltPKtoGKZ7Hw16GYtlszCrTO1qH/FM3Aj+a+?=
 =?iso-8859-1?Q?aXkUhsTFQokP2NnGd7NH8sVSfm8jLLuzKnP7FL43SrYKJnidVBE7P6UG29?=
 =?iso-8859-1?Q?6v7O+Lao8HG6579PUGuBwB9DCb47ylkh/x57Hevvm7hMrZ3jIFOmJMJ5qx?=
 =?iso-8859-1?Q?CAXaFlL8/gPWqnVk4NCgz1UbvzRe/oKUVYcz/9V/27VNqUkvj21mxt3h5w?=
 =?iso-8859-1?Q?1/9caye0ZLFj/lzr52vEEcUF1ZhMYoLxmgWl/CTSvuRqBlRjAHkx5y6yXz?=
 =?iso-8859-1?Q?fW/J1Hf2CGVb4+ligTIJESaENQnT8YD1QHhoDdB1RNQ8rbZoU1FsTL0fW9?=
 =?iso-8859-1?Q?a5nU2ukBT++s/vBYimx0XPOa5dCX2u4AikdeZ4GqUuKsjvjmWP8DKrnBHa?=
 =?iso-8859-1?Q?NVHNqDD9Bn2d0I4mHg5ss624NgJfuvEjK90Y5LHqm5bcpmmSI+9+6zvWwl?=
 =?iso-8859-1?Q?nqEdu7UuC8ndgUqqbDAWjQIwQZ8B2hcMzuDl8oZul0QI6nLHFBiW9zLkSV?=
 =?iso-8859-1?Q?LBa+LBDT9efiMxRvUHDxqhePpdsmXY81KVt6MzTTghNtJk19RNPk2t0VMk?=
 =?iso-8859-1?Q?1k+UA6/LrphnSIs9rDu3OoSJAeOzniL5ijtzSqLEzyrqTfcJuMhaAkuNf4?=
 =?iso-8859-1?Q?A0g14xhhLz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <33EA6ADA8DA47D44B63D783FDA751A40@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca771c9b-67ec-4305-d739-08d9375a2974
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 21:51:03.0999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doop6W1q6fb0CmFnSOwa9XNkvJ2LH9tDdAf3/JN6ZE/hsP7dyZ1GMjRCQKASG5yn0wJBR17O+Ye7E3+YXES3GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Danielle,

On Thu, Jun 24, 2021 at 06:15:15PM +0300, Danielle Ratson wrote:
> Currently, the indication that an iface is up, is the mark 'state UP' in
> the iface info. That situation can be achieved also when the carrier is n=
ot
> ready, and therefore after the state was found as 'up', it can be still
> changed to 'down'.
>=20
> For example, the below presents a part of a test output with one of the
> ifaces involved detailed info and timestamps:
>=20
> In setup_wait()
> 45: swp13: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel master
>     vswp13 state UP mode DEFAULT group default qlen 1000
>     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> minmtu 0 maxmtu 65535
>     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
> 17:58:27:242634417
>=20
> In dst_mac_match_test()

What is dst_mac_match_test()?

> 45: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel
>     master vswp13 state DOWN mode DEFAULT group default qlen 1000
>     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> minmtu 0 maxmtu 65535
>     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
> 17:58:32:254535834
> TEST: dst_mac match (skip_hw)					    [FAIL]
>         Did not match on correct filter
>=20
> In src_mac_match_test()

What is src_mac_match_test()?

> 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
>     master vswp13 state UP mode DEFAULT group default qlen 1000
>     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> minmtu 0 maxmtu 65535
>     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
> 17:58:34:446367468

Can you please really show the output of 'ip link show dev swp13 up'?
The format you are showing is not that and it is really confusing.

> TEST: src_mac match (skip_hw)                                       [ OK =
]
>=20
> In dst_ip_match_test()
> 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
>     master vswp13 state UP mode DEFAULT group default qlen 1000
>     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> minmtu 0 maxmtu 65535
>     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> gso_max_size 65536 gso_max_segs 65535 portname p13 switchid 7cfe90fc7dc0
> 17:58:35:633518622
>=20
> In the example, after the setup_prepare() phase, the iface state was
> indeed 'UP' so the setup_wait() phase pass successfully. But since
> 'LOWER_UP' flag was not set yet, the next print, which was right before t=
he
> first test case has started, the status turned into 'DOWN'.

Why?

> While, UP is an indicator that the interface has been enabled and running=
,
> LOWER_UP=A0is a physical layer link flag.=A0It=A0indicates that an Ethern=
et
> cable was plugged in and that the device is connected to the network.
>=20
> Therefore, the existence of the 'LOWER_UP' flag is necessary for
> indicating that the port is up before testing communication.

Documentation/networking/operstates.rst says:

IF_OPER_UP (6):
 Interface is operational up and can be used.

Additionally, RFC2863 says:

ifOperStatus OBJECT-TYPE
    SYNTAX  INTEGER {
                up(1),        -- ready to pass packets

You have not proven why the UP operstate is not sufficient and
additional checks must be made for link flags. Also you have not
explained how this fixes your problem.

> Change the indication for iface is up to include the existence of
> 'LOWER_UP'.
>=20
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testin=
g/selftests/net/forwarding/lib.sh
> index 42e28c983d41..a46076b8ebdd 100644
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -399,7 +399,7 @@ setup_wait_dev_with_timeout()
> =20
>  	for ((i =3D 1; i <=3D $max_iterations; ++i)); do
>  		ip link show dev $dev up \
> -			| grep 'state UP' &> /dev/null
> +			| grep 'state UP' | grep 'LOWER_UP' &> /dev/null
>  		if [[ $? -ne 0 ]]; then
>  			sleep 1
>  		else
> --=20
> 2.31.1
>=20
