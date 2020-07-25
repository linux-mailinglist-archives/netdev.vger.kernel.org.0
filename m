Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196122D298
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGYAC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:02:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:55207 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgGYAC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 20:02:58 -0400
IronPort-SDR: tnywW5re1653/wgR6NjlgzR0Jl/7MQBY7UhriV7r+DBTGvaL/nmEmptv9e/mYDU69CveqVXYpW
 iuQV7X+3h6oQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="215377114"
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="215377114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 17:02:55 -0700
IronPort-SDR: zGYSHrvxb4ZCu4z5fCepIg020WJXaCEuYQQPQAu8nPkRtR56DqSso8JEbYiaa1pGgZNIa8MI8J
 fscyPnf64kGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="363516737"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga001.jf.intel.com with ESMTP; 24 Jul 2020 17:02:55 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Jul 2020 17:02:55 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX157.amr.corp.intel.com (10.22.240.23) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Jul 2020 17:02:54 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 24 Jul 2020 17:02:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWcSZ4zQAWkHE0N5rGwK4G+uZoTrlDDdxE20tyaVaQRQxnSxEOAKN7njtPe4EenLONQIMjlFBfdBTJuri50Mhq27Ph77w7SJQLfcpbXL9MrspmGZ688HqWj4XdOAxSB2inZXjZArgzK+LBvN9ppmdWSMDEm8qYdz9Mz2WKXfsX4/C5w7NFjRQSRh7RBztX5wcbyJ/rUh6drTV1NtyamHWVg/aDgppaQesLmq51ZGUPqjBfGp+pF6OvGKSEPFjVp3jOzCcfjGpiKbx6ABTgnzAo4E8MMDtVDynSO8XCZAG+4/HrqSF55dr9hkTqojUum72bq/UOs0gcVqeQPLciwj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUZWVrUSyTKfFfiIO0kzk4Xv1IJwQ6T66N7DXd9z0WI=;
 b=Mnbhn5FXnSxQ/XrKkz8lZUtMkVGKRSHNFuM0uL+ghWnzaZBDQeL2qRgVQ42mcFq/BMFZy8+gOeoZ/UrREExwBKxoRyGpx/pIXJ/1awpdIcQ3Valhm95SQfX1+YhffFUji3mhBxfiRPkdBhICWEvpBrKaoD/pgSoOqJ+FLxYPOqHnXlRb5onBf5eYyXRZi4AcDmWGZB51mJdqMZUINYhECO4+nbcoQTe4/BtGClXeCbeoFJ9Xl6nauOwBN5KSDcKrE/Rc2LyV81CUL+wvwbTN+AuZfrJVOAWYi3TmSQkXthmB9yUT94AByqZUfms/5OB6kITy6BNSOV2IJxRbg4Ty+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUZWVrUSyTKfFfiIO0kzk4Xv1IJwQ6T66N7DXd9z0WI=;
 b=PggpgR7FpCx+u42lFWQ1bD8X9KqN0DemHv3Y8kT26FGQl/l1CdOAunrlvMDdOI4RG29UErohkicraytg16CnJwuG6FPmU2qPAsuUKgUWJycnj2pZ0N9+QhVsm+orFEOEpB0kCT0mrfihHU09EgSKj5tl0cag+7FIz3NO5GdrSKY=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN8PR11MB3842.namprd11.prod.outlook.com
 (2603:10b6:408:82::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Sat, 25 Jul
 2020 00:02:51 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3216.026; Sat, 25 Jul 2020
 00:02:51 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ixgbe: use eth_zero_addr() to clear mac
 address
Thread-Topic: [Intel-wired-lan] [PATCH] ixgbe: use eth_zero_addr() to clear
 mac address
Thread-Index: AQHWXp778dA2riegO0mfYk6pYfEVpakXcG9A
Date:   Sat, 25 Jul 2020 00:02:51 +0000
Message-ID: <BN6PR1101MB2145A1849CC7D75BA3430D078C740@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1595233661-13699-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1595233661-13699-1-git-send-email-linmiaohe@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.59.183.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a086c26d-4fa9-4cdf-d585-08d8302e12d2
x-ms-traffictypediagnostic: BN8PR11MB3842:
x-microsoft-antispam-prvs: <BN8PR11MB3842C02FC6BA58AF9EC6EA518C740@BN8PR11MB3842.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7AICsO1TGF8yWqHIYUBrUMj9XZc18aLGSg9bxwiv5eW+k61t0E6dSMFIOnEmFWRgb7c//aPTJP/BRASIqdHKEvegDiKYi3LF64XXLaMRyjsvwnndBfkmi1YnP4I+e+/o6Wu1GEsEUWA3oBwsBTsMp9o5c3frl1hdbdemUYjo5xF5e6vsKX7FNEYggfIpQA/2ASg2a/Bxh33iLfM35kN9RrSgz8IP8s+slr1OdhFgD3O4IJqmVo+/KXDqtefPzS0ZI1OXSUyKnAXEGUNZl4YaTO0HPqHXcwXcgvNHypTI9orREOjoD3p7OzL1dgiuXDBtG7kn2KMZjGEH9q5IIQScgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(9686003)(2906002)(55016002)(26005)(186003)(86362001)(33656002)(478600001)(64756008)(66556008)(66446008)(76116006)(66476007)(66946007)(5660300002)(52536014)(83380400001)(8676002)(53546011)(316002)(7696005)(71200400001)(6506007)(8936002)(4744005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IcfLkwTVthyFAKHZfHy8LDBwnhiyd4qxJTN38x6951BisJCCOkbuDBRXau+JbyKfLyc621NXvKRzLlT5Ii8nnNZAfxMQ1dSIVe4xnMgydmgGOj8/Tqm9JV8EUiFlgHB3Ebz26ugwhAc0B4qVQwABvNmvSqbzaCSZsL2spx46tkfmNijqjYVZCo4mjMRuDm9G78NKEl+blT4bwYLkQi1rnmuNjPLhK5M6oIzFX54q3KLRT/lJUaymF7BpUZLuY3E9aKMIxqUorMOAWOLBS1v7/SX3d3KjiuyTx3iMgPakFEm8oQWST0GO5a8l6yaguiETnkRWLN1lutmYM9QaSOBYXMXwRIFE8HrpHdinxds8Wnh6I/WX42f3r1Bb18TxWpeUpGdfaKVL+9UvsdCCzv2eYTHArEBk7+b/0EFVWL25UrUJueo23tT283fWUERog59keOuBMt0HlMDsW0aU6c/TgM59M7R2dvnOp0rFJxp7EmUa21Whtz8uoZ0DhvqJxB7w
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a086c26d-4fa9-4cdf-d585-08d8302e12d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2020 00:02:51.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGMOcWdskbLDfvybZ21B0jrdgQYA9muj7dY4u/MNgtlGiv9RL87bvzUet8zOxSOJA64E7C7z2sQ4zKaomJg3Z9ZHADPMMMJzTCnnVprk1VA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3842
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> linmiaohe
> Sent: Monday, July 20, 2020 1:28 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> kuba@kernel.org
> Cc: linmiaohe@huawei.com; netdev@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] ixgbe: use eth_zero_addr() to clear ma=
c
> address
>=20
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> Use eth_zero_addr() to clear mac address insetad of memset().
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


