Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4124C5DB
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgHTSvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:51:51 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10571 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgHTSvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 14:51:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3ec6020002>; Thu, 20 Aug 2020 11:50:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 20 Aug 2020 11:51:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 20 Aug 2020 11:51:41 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 20 Aug
 2020 18:51:41 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 20 Aug 2020 18:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6XJeoTZyNiQqa3JnbKO90fmCeEDooXSeB2Gh3TpgHmInaDlzi+4WK5mYdCo5p51cB0Chzr0qVqAM5K2JBB7ivBu6cBEfXzczBkEkpa4xAjwWkDIDx9nmPfre4PlWhP9+mgFZqlHyde/ovUag1gWsPXSMDA8TZ1dS8P/Lnm3S2j2J3U9GNxJRUIjXMiig12/D8xfQf6oAPcbhedH2I8Vw/TNUtCDoNDtRUKcSM2owqNrMu4I2AfI+Q/PcR9mSabtkDI556wukxam3tHr2u3ydCzbf1y/FWKzUgnmvWceWfmwZWLPmQ4qBWIc/nUJdCtaheOzM02n9YQYFg+sYxGMjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLcPLbRAmxuCHhdsrekxQVzWLDrHMgxunfE/HK6V0/w=;
 b=k3Gliq7tkMZ7vdFL6665i0Yxv5oBv3yHMRZCfgJMHSfSjpZTB0ZXSmMn72s0csYkb4uPiFwLce1gUDHVVadhNJnwVGYlnap9H9QDAS44MUMyYN2zlEs38Mral34UURP778WOcctTbMRZ6KqxTss4C/uwfUpKBBsjWqQbeoiUM/BQ3PNrzwGGeDYo7bWHXN6n6FRqM1Cp+Aexrp4jkPb5IVPtx7/Jb0TF3gIsXWnd2pJzezHYcX5qlcfgTt5ILMsyYco416lir3Ud4w2T1xM/0QEzRhkBoEm+kvUS/AJSrRJihsdcqf/vTWAeBMTVhVRoUmrn4dhOefFYlQI2Ud82Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from MN2PR12MB2975.namprd12.prod.outlook.com (2603:10b6:208:ce::14)
 by MN2PR12MB3071.namprd12.prod.outlook.com (2603:10b6:208:cc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 18:51:40 +0000
Received: from MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::d8b4:a463:431:7083]) by MN2PR12MB2975.namprd12.prod.outlook.com
 ([fe80::d8b4:a463:431:7083%6]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 18:51:40 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Thompson <dthompson@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: RE: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHWbGN0XVOwTpTa5k+pNDw3jkbxUqlBaONg
Date:   Thu, 20 Aug 2020 18:51:39 +0000
Message-ID: <MN2PR12MB2975DAA7292C27DEB0B518A8C75A0@MN2PR12MB2975.namprd12.prod.outlook.com>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
 <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 736abc11-5322-4d00-d710-08d8453a12f4
x-ms-traffictypediagnostic: MN2PR12MB3071:
x-microsoft-antispam-prvs: <MN2PR12MB3071954AB12B3FEFA6086437C75A0@MN2PR12MB3071.namprd12.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sDANxmyBgVijyuXIbxQMkKBYIhMEO/kME9drPzdthC6Qp26QAOBRk5e1fI4DguEtZnrFq0MzaK0U5vJtQ7eGEx0tm13ycCK1mhIlPfxQpA9r4HVV4uVoCb7AQC8a+WcgL270qfuPSXTaKw4srNCcVgED2K68EOV9H2WKnfSqghK2xQWSyus8qwiLwjvCbq94eAtdlns4JHz2WT9c7K3p9PawYyACtctPXgya83Bu9TaSkKjJlhwM11H2tNbiVwgni5HHxP/r/3wBW1yjCtRtP3XsBwZUmmWigUMwgtYvF5v5geBhDcISKuV30JqUUDyxeY64bxEKxb64U9yjuI+wYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB2975.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(55016002)(86362001)(8936002)(9686003)(478600001)(8676002)(83380400001)(107886003)(71200400001)(6506007)(33656002)(186003)(26005)(5660300002)(76116006)(66446008)(66476007)(64756008)(66946007)(52536014)(54906003)(110136005)(4326008)(7696005)(316002)(66556008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PQDyPNpLJKp9DIfGhjtPoYvXzza8b+BNQfei2xVVQQkhU5rYL4zATzoWDzZuZA8aA9ykpSuJIySXaFR99ym0X9+dqeDwIatR8XZ4CPD2g75ThHaz3vL9+IzYWQisTkRF7vr0z5Rwm8EzitzwhbXxYBksTMzf9RHw0iNcVsW7bRSQWFqXGU/sIOU8DZfJM+crU+f2xbwdVc37xe44Co/kiXdioulNcQ4VRN2Vcj2KT8SZ2Fz3wYKicB71v/wFwEAYkNbQ7hrVLElku019e3C2BRpETdAAX298bL79BrAVZp9kYmT4zBsuw4Gnf5g6Yyea8dmEO3c8Ogu4HPPszDI9nTES7ZSLwNRMzMx+B0FVuTYMCPXMJku/AysL8q59408bcNEIZ754ymdOSlp3jGiX/oUOzruACQ1J8txSYsn5EWD7r+XthZvjRpfPJTBjVXXqPtI90Se5vrE8l9LZfw7V7KR7T+dAih1wj7XQ53otgkwFF9n94nymQClaMXsfhYZRfFCfkPDGW5hWpiH1oPX6ygHatXHwLlYHxR1EigH3J9sVRSu/jlYY8nLzow99fK+AqgFY0AFaZZdemM+nfq+/bRgNv8+bhWZG3de1Gs11GwKOQhLnYxhe0HnWm784kym1ORn+wXH7QXsvkXXjkCbqwg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB2975.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 736abc11-5322-4d00-d710-08d8453a12f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 18:51:40.0181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LIpOQfl7c3QOT5f6PqqBDWl4VG0Yie051j7+IgjS69TmqEpJi5Z2GnQ3yIlW5qVV5OvytYoOSZU5XlEub6A1Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3071
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597949442; bh=VLcPLbRAmxuCHhdsrekxQVzWLDrHMgxunfE/HK6V0/w=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-exchange-transport-forked:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=KYyzLPrnz4r84NnDXkXxdxH5PReRixfzTcaCCKdvIdmQvmyJSY7vgOHmhC1xurWKX
         cEWkJ9e/8PNAfq+MhpyDAG7raa45gZsxSO6y7qm+WELl7hI5pM1ZJY1QFimXD2cPWI
         WBVPK0TJfd3w6iERGPW8zNk7XuQuVSgOrxGLxRLcyL2cDFn7GWXmSjOQOA4PdSuSak
         SuGeKH0Fu6s8jdWg/v5mdfQs5ovnsl1DtOr+Q3nfyyCVqHcQJD/uZS8OaJTCOn33wR
         Fq5DEAd7pSTEobS8ckGKSBHf3DMe2a9Zgc9YnwydvPYfZcMvVxE9U1+6rSIs6Lgixa
         k3XNCjaDf7aNQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +config MLXBF_GIGE
> > +	tristate "Mellanox Technologies BlueField Gigabit Ethernet support"
> > +	depends on (ARM64 || COMPILE_TEST) && ACPI && INET
>=20
> Why do you depend on INET? :S
>=20

When I wrote the Kconfig definition I was thinking that "INET" is an
obvious functional dependency for an Ethernet driver.  However, if
Kconfig is just intended to express build-time dependencies, then yes,
the "INET" keyword can be removed.

> > +	for (i =3D 0; i < priv->rx_q_entries; i++) {
> > +		/* Allocate a receive buffer for this RX WQE. The DMA
> > +		 * form (dma_addr_t) of the receive buffer address is
> > +		 * stored in the RX WQE array (via 'rx_wqe_ptr') where
> > +		 * it is accessible by the GigE device. The VA form of
> > +		 * the receive buffer is stored in 'rx_buf[]' array in
> > +		 * the driver private storage for housekeeping.
> > +		 */
> > +		priv->rx_buf[i] =3D dma_alloc_coherent(priv->dev,
> > +
> MLXBF_GIGE_DEFAULT_BUF_SZ,
> > +						     &rx_buf_dma,
> > +						     GFP_KERNEL);
>=20
> Do the buffers have to be in coherent memory? That's kinda strange.
>=20

Yes, the mlxbf_gige silicon block needs to be programmed with the
buffer's physical address so that the silicon logic can DMA incoming
packet data into the buffer.  The kernel API "dma_alloc_coherent()"
meets the driver's requirements in that it returns a CPU-useable address
as well as a bus/physical address (used by silicon).

> > +static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
> > +					 struct ethtool_stats *estats,
> > +					 u64 *data)
> > +{
> > +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&priv->lock, flags);
>=20
> Why do you take a lock around stats?
>=20

I wrote the logic with a lock so that it implements an atomic "snapshot"
of the driver's statistics.  This is useful since the standard TX/RX stats
are being incremented in packet completion logic triggered by the=20
NAPI framework.  Do you see a disadvantage to using a lock here?

> > +	/* Fill data array with interface statistics
> > +	 *
> > +	 * NOTE: the data writes must be in
> > +	 *       sync with the strings shown in
> > +	 *       the mlxbf_gige_ethtool_stats_keys[] array
> > +	 *
> > +	 * NOTE2: certain statistics below are zeroed upon
> > +	 *        port disable, so the calculation below
> > +	 *        must include the "cached" value of the stat
> > +	 *        plus the value read directly from hardware.
> > +	 *        Cached statistics are currently:
> > +	 *          rx_din_dropped_pkts
> > +	 *          rx_filter_passed_pkts
> > +	 *          rx_filter_discard_pkts
> > +	 */
> > +	*data++ =3D netdev->stats.rx_bytes;
> > +	*data++ =3D netdev->stats.rx_packets;
> > +	*data++ =3D netdev->stats.tx_bytes;
> > +	*data++ =3D netdev->stats.tx_packets;
>=20
> Please don't duplicate standard stats in ethtool.
>=20

Understood.

> > +static const struct net_device_ops mlxbf_gige_netdev_ops =3D {
> > +	.ndo_open		=3D mlxbf_gige_open,
> > +	.ndo_stop		=3D mlxbf_gige_stop,
> > +	.ndo_start_xmit		=3D mlxbf_gige_start_xmit,
> > +	.ndo_set_mac_address	=3D eth_mac_addr,
> > +	.ndo_validate_addr	=3D eth_validate_addr,
> > +	.ndo_do_ioctl		=3D mlxbf_gige_do_ioctl,
> > +	.ndo_set_rx_mode        =3D mlxbf_gige_set_rx_mode,
>=20
> You must report standard stats.
>=20

Are you referring to the three possible methods that a driver
must use the implement support of standard stats reporting:

From include/linux/netdevice.h -->
* void (*ndo_get_stats64)(struct net_device *dev,
 *                         struct rtnl_link_stats64 *storage);
 * struct net_device_stats* (*ndo_get_stats)(struct net_device *dev);
 *      Called when a user wants to get the network device usage
 *      statistics. Drivers must do one of the following:
 *      1. Define @ndo_get_stats64 to fill in a zero-initialised
 *         rtnl_link_stats64 structure passed by the caller.
 *      2. Define @ndo_get_stats to update a net_device_stats structure
 *         (which should normally be dev->stats) and return a pointer to
 *         it. The structure may be changed asynchronously only if each
 *         field is written atomically.
 *      3. Update dev->stats asynchronously and atomically, and define
 *         neither operation.

The mlxbf_gige driver has implemented #3 above, as there is logic
in the RX and TX completion handlers that increments RX/TX packet
and byte counts in the net_device->stats structure.  Is that sufficient
for support of standard stats?
