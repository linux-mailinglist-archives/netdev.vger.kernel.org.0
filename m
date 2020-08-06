Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A205F23DE0F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgHFRVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:21:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:62906 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730280AbgHFRQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 13:16:06 -0400
IronPort-SDR: fUu7rFtrozVUF+Zdcdw6Kcz0ng60nUTQxo+G/gFIt10e6MTf1q1g37i5QRyqPt9lN6canOZB9u
 W6/g6Ys3Kc6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="170850918"
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="170850918"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 04:27:11 -0700
IronPort-SDR: 7X9rh/eOTZY6LxE2YkAsLS6rwjbvfymTJj/pbEOu4z/vJvpp5MVi1iV2My6DjWzl3HuHpmMIoT
 nzCt36pKkFdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="333157896"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 06 Aug 2020 04:27:10 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Aug 2020 04:27:10 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 6 Aug 2020 04:27:10 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Aug 2020 04:27:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 6 Aug 2020 04:27:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwSh+bkZzEJsIHyctH6MP1vMuewmvnGKgQQgSQjjvkDAPuNQgsAtkAKBy4o126JucFmswP9Yv2APumtoGcNy+kVjRUSh3NWcwwyUE2ciPmRnF05/KbLjSOfsnnF0nNcPun6C3qpZoH/NIg2P1ivLzqTTJh0A1Ei6yMn/iDVNRfcNmjlLW0nZSDAlULFS7r1I107QhAG7e2YxSCT0kgA3OLrCJzvmq2fQ+eg+wPTx1MBJDKwbHGBzFiMt68I/vV/gNL2cQz6W+7Rt81rqb0+PsxZCujx3CBaHd9JCYPoUGwZke6KckTir/EK/0WdGuyOqn3wE8R+FiniN4PeP1iuaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ht630EpjhlpCJrY7DtUdLR5S1lgjOxKuIWyV/rfg5ZU=;
 b=CJPIMZOLIBqjBDFqURux7cNaW/2zry9jrj5B8Ir7Q17Z6ghPqzgFa6UMxsw/88/KOMLCW2WAv0BWSeTDuVFRekQ77/mGoXnGtrl/jVVY2uh8fvBbzjqBz9vFDEti7MnN7KmwykpC281o/cIxq12UVdrcpoe11aKTzImhT2xN3FpsXrgpznorWlaof6m1V2tFon1iDYYcoccDL6Hb0kdJUCCTVDYSdX3zzRlro8E6poKUVcRRvii4Wwx8WlPTkM/g/q4QRDdger0CXcvdCb9mtj1In98e1Gbmj8NaZWRlRn2l1jaFLA9Jf46JEo8HYkPrf4cEKoISJYeFlc8syneETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ht630EpjhlpCJrY7DtUdLR5S1lgjOxKuIWyV/rfg5ZU=;
 b=QA1PAQYnEDoHhOMLus+G3tkja29BwZyxrwcCoV986Q4dVa+4/8YwrfKkBmUS2ohmtV1Q4tLEtW9WN4lC6QDLLz19nUIUmSIqwOzkqC9uAzttjRlBMIQNVKwyX28MWZqE39Hf4ifratAeXmObjhVHnG7Qcirc+YO4PCBXJ6Z0jvI=
Received: from SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 11:27:05 +0000
Received: from SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::6407:40fd:19e3:e270]) by SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::6407:40fd:19e3:e270%7]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 11:27:05 +0000
From:   "G Jaya Kumaran, Vineetha" <vineetha.g.jaya.kumaran@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 0/2] Add Ethernet support for Intel Keem Bay SoC
Thread-Topic: [PATCH v2 0/2] Add Ethernet support for Intel Keem Bay SoC
Thread-Index: AQHWYm0U3dOFCeirEkqoBFXOtaTjdKkrA7Dw
Date:   Thu, 6 Aug 2020 11:27:05 +0000
Message-ID: <SN6PR11MB2575B44356D218768D24229DF6480@SN6PR11MB2575.namprd11.prod.outlook.com>
References: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
In-Reply-To: <1595672279-13648-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e1018f6-ff7c-4467-c7d7-08d839fba5f9
x-ms-traffictypediagnostic: SA0PR11MB4527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB45279CD6FEEA61F3CD1175F0F6480@SA0PR11MB4527.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5n2rAl2fov7W7VvSvGmX/e/0xbhzZhe/fHm7mXiaGG8ywe6OPIdpspOrA3Nms52QaknDVadpPqzXan6841tUfBdVHdZLBV9uE0MVk7r1Amwuwn/B8he1m5ySV+1VsE52FRYTy8+XoOl3Woql24eHBqYamstAChU1r0i84dgYC9+b0dRmuRyiXZztbpYWZSPzju3qDbjbxX5/bi6y3iuOlt4vqQn0z/S3Hrpj24zStlhpZNuqPBxTHWBekV+WM4keRHi9gkQqOGxP82HMXltA/JwRe5ZkYDKXasy9jtsl5IxmzCPZ9bN2yQ50dg6zBVE1EHUM7dWnkSd4jY/TqYTpcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2575.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(54906003)(110136005)(33656002)(86362001)(9686003)(107886003)(55016002)(316002)(83380400001)(71200400001)(76116006)(8676002)(2906002)(66946007)(7696005)(478600001)(4326008)(8936002)(26005)(53546011)(66476007)(5660300002)(52536014)(6506007)(64756008)(66446008)(66556008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CncZdrhcC5pVcru57/qpzMtZ5B20qEBgzkTDKVuLXzDD320CaA5aJufLL/GZfE3Bg0BM9162WpwNVVr5dE69IO8r8BIsOT0+aiRqS0z1FcPwHX/xpdVZj/Q/fkADr3G3JZtBoKinup37eJ7k1G9pYrcAa/lsM5qphDHKZj0nDFH3PC3iPBFg2hG8N1l49unF/p/2CFCSqussdpuRyysNqiduulmXsPcDHwv65/dgUGP9gLWkflvEmh6vbxc6Wr9A2CLdEtjKdDzhYDDqXmhxvgQGSMJJmjzPFecOiNKIqNmudWyx454fEgCamQ/aeQY6UO3JXY587syfh1mchfiGlfD5aBSrWhUFBHiQuDnlgMu0V91v2Ch55zMFyNFfSCx3eIn7cfFj+wDTeYwJMD6tCBZVQEs8/ZXQ0R2Lm90UBZVhQCjoy2EK5k+CGVwBPZai/MOoYT7YaqAQwNXK5Mw+hfEUu5K8ICkx7dKl/uHo9om6K2fhvGrZD414FZ9fl2g3KcGlPTSRbuTxteuGgrbLFlnHgvtWIhWxOCr9Kc5JurtmoccDbm5Nf5BOwPDpY4GnS8OGS8ut8UlXvlJt8KISwLzQqxrpS1B1M4D6UcDtbLpmm139FknVkoZbjw/RJdozNh73onhQpYak5RXaLAS95A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2575.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e1018f6-ff7c-4467-c7d7-08d839fba5f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 11:27:05.5990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sxj1eTb9UOVLxEUsi7fSONemgMIiEgYNH+OhOPRS1F3uU/mNgd4sqP8xJUy6/w5CaxEXJ1quZcWyHMfpZdL2Ve2k0GnH+hUtyKs9eH9SpxQ0/LKggt9iY5o/ln7+i1Hl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

May I know if there are any comments regarding this patch-set before I subm=
it a V3?
Just would like to check, since so far the feedback obtained for V1 and V2 =
has been regarding only the DT documentation.

Thank you,
Vineetha

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of vineetha.g.jaya.kumaran@intel.com
> Sent: Saturday, July 25, 2020 6:18 PM
> To: davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> robh+dt@kernel.org
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; Voon, Weifeng
> <weifeng.voon@intel.com>; Kweh, Hock Leong <hock.leong.kweh@intel.com>;
> Ong, Boon Leong <boon.leong.ong@intel.com>
> Subject: [PATCH v2 0/2] Add Ethernet support for Intel Keem Bay SoC
>=20
> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
>=20
> Hello,
>=20
> This patch set enables support for Ethernet on the Intel Keem Bay SoC.
> The first patch contains the required Device Tree bindings documentation,
> while the second patch adds the Intel platform glue layer for the stmmac
> device driver.
>=20
> This driver was tested on the Keem Bay evaluation module board.
>=20
> Thank you.
>=20
> Best regards,
> Vineetha
>=20
> Changes since v1:
> -Removed clocks maxItems property from DT bindings documentation
> -Removed phy compatible strings from DT bindings documentation
>=20
> Rusaimi Amira Ruslan (1):
>   net: stmmac: Add dwmac-intel-plat for GBE driver
>=20
> Vineetha G. Jaya Kumaran (1):
>   dt-bindings: net: Add bindings for Intel Keem Bay
>=20
>  .../devicetree/bindings/net/intel,dwmac-plat.yaml  | 121 +++++++++++++
>  drivers/net/ethernet/stmicro/stmmac/Kconfig        |  10 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 191
> +++++++++++++++++++++
>  4 files changed, 323 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-
> plat.yaml
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.=
c
>=20
> --
> 1.9.1

