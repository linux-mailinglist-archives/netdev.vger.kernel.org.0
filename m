Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632F923140B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgG1UgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:36:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:24425 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728430AbgG1UgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:36:04 -0400
IronPort-SDR: 12i0FLLbsKJXDPq6vbkAS7xTbuBjU+hWHXoXdX+Ml9zy2suBTL6MOcdWIfCoF0LENPhyS1dhWc
 hVAXG1p8PRKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="130868896"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="130868896"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 13:35:56 -0700
IronPort-SDR: miVU2I0McXErxbxijod2t2SN2xn3F3lgq+8cASjW/oF5LcnlQ0DQUBwiwTOI+FgVowb1QRWzQD
 /vCancc/U8XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="303987489"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga002.jf.intel.com with ESMTP; 28 Jul 2020 13:35:56 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Jul 2020 13:35:56 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX112.amr.corp.intel.com (10.22.240.13) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 28 Jul 2020 13:35:55 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.52) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 28 Jul 2020 13:35:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzKUPqFwJ8a8AueIpsUAJzwA9I548Mh/TnbpbhkHuOY9nHE0WJ92i0QVLkUbWgj9toq+lM3ST28r6YqYH/zUbbdU80sqjnnIbz1Gg9ixHKlTa8sd4EscKrlxm/1r43XQKYEAq2CePnT4sMbSSLeat1Mci4PzlDWXmTIjj/EFwur1XKKsBdSix73ROxdhmGYDLf4PObuvBItWYSSCW33q0NQWY2K50KIX9VpnQyhoFjrLlnj/UBD4Yfd+eXXnG/Ierv5bW8FBGg1mdy31W+MlRgzmfWgQZrjTLX7s4/uWl0zooufjk3Fwouy0TFx1mb8OgRtEXHQOuP7YSKcDBlPqNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/PEPHlRkJL8f9+OL6/7qfINXyFq5hrww+zQ8CmF2J0=;
 b=nESm6AE/76uoYCCXJQrt1xifBKZ9Aq4B8odHKKWA8lY6XPZNm1Lfi1dk85W7K5nPgb+3Qx7ibGU6KKWn0Zlr2Y46KsA0MVdDvFLXkPzDtOJo1FnM3lQpOZ16J9sPLV4ZCVL+bhxDoGCuRNhQg6Lz2GsC3+ZhFZ0itVV0wenx8WIfWDGzH7iNBpnTW04nlcZj26CdzOOI5HZPn44djkB4SzuX9v/0qIgR9GaSKwveR5Oiz+k2NmtP6DLT9+cgWh0YQMO1hch/z7J2erSC1fIa/4tukWWsZHDkYnTjLeoBW3VOtL+31S5+hQ8x6eOtq1HzkhNMYRAKVwf/hCOjUoHj0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/PEPHlRkJL8f9+OL6/7qfINXyFq5hrww+zQ8CmF2J0=;
 b=iRf8hh9mHstb2r+b52dNec8mR1YL1ZzlvE4ZydWJQCukfBZqtm5YTp2koqMbS6mvlytG1kzO9rhZ/ZyxwKT3EJ9mW929aetB6lFN+rwhaqvP1AJ0O10Z9qAnemSkm8dURnP+jmc4jlXaMwSEknArnuMVUoMANbNSCfoAAAgBQQU=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4377.namprd11.prod.outlook.com (2603:10b6:5:1dc::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Tue, 28 Jul 2020 20:34:41 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::65c2:9ac9:2c52:82bd%6]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 20:34:41 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Aaron Ma <aaron.ma@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "kai.heng.feng@canonical.com" <kai.heng.feng@canonical.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
Subject: RE: [Intel-wired-lan] [v4][PATCH] e1000e: continue to init phy even
 when failed to disable ULP
Thread-Topic: [Intel-wired-lan] [v4][PATCH] e1000e: continue to init phy even
 when failed to disable ULP
Thread-Index: AQHWQ8XCGt1Zf2BsuE6OIRiqVZ8UlKjd8zCAgD/B2cA=
Date:   Tue, 28 Jul 2020 20:34:41 +0000
Message-ID: <DM6PR11MB2890F94DA893CE56A5D8A3EABC730@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200616100512.22512-1-aaron.ma@canonical.com>
 <20200618065453.12140-1-aaron.ma@canonical.com>
In-Reply-To: <20200618065453.12140-1-aaron.ma@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.173.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02e08b5c-3ae4-49cd-4571-08d83335a816
x-ms-traffictypediagnostic: DM6PR11MB4377:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4377A25AA28F2F88E56BCC26BC730@DM6PR11MB4377.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 78Vjw68GzTOx40YipGL5QoSHDmDc4WuxKaWMsMBc987tuW55AOPowIjVgXQRZGUw+rUrpQ+O9r/9+0o1xZpAk3+b0UnLhKf8BpxTdu9OZo/JTdoLfabPVx6LXmWheHc71w43hfHT6shVUkJlixL9hZJb325t+etSnGmkpt0vdhdlx9tzWIT+LFuxXG+HRJfAfR3zHcNLESO08DuMWd6DV84qn9WclGzjcZMVY5TkVL0IMqsHO9qYWUPEept0N+eQQS0Y7YBTFfSSbmX/X+zrgly2vgpKODMFOVgFwEF1TGp3DpOq4V7rPyOsH/VMDHgOcSYXmhbrHU3JlE0NhD9xkyxrDrUW3B1a8yZCEowEvlsKPNfLj07VrOJBuvv9se64
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(66556008)(66476007)(66946007)(71200400001)(83380400001)(478600001)(66446008)(26005)(64756008)(186003)(53546011)(5660300002)(33656002)(55016002)(7696005)(76116006)(8936002)(86362001)(6636002)(8676002)(9686003)(316002)(110136005)(6506007)(2906002)(52536014)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: e+ZDUsnjC5LzwXp69n+FBPzEWCreMobQ3OtAVRJoC3GpSzgy1weP36AY+PdzhjvDpiROzWV12ReWGxDwTdCv0qttvCoXuhA91rAqQMLIKSrjMpJN4aFBlWqrjmwwd+evh3y4WDSs/fFbNMfO07c6wjk0zkZEAzUVumLYy9hpTUgjFrJggIyitFncdutTjombrflns50uW9/vxZX6tzHf7AtdYREbUDXWru6QTf+vfyO7CKeehecvHpCDZl5jy98TlxEuV0fRBD4/DAPUVe3As+Lah+y/iAqB1O8yX9v/UwFlVwjjkfLapMrFkWou5t7S8huaOUIzyO7iRoswvmesfB2v23plGn+7nXSGX/CVbEgaPfqAo8C3sOoX5Jy295xLzYoReqDJKe4ea+ld8vafwNt9QLgFNtN9wN8hZAR9Qtscqj3GuF3ggoPhll32bnaIHqWHpgFWtSa7Gk79qdrwG1+mLPLnEhGXF6pLtBUfpmcOX8wi7GnK/yHPJxmFtZOf
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e08b5c-3ae4-49cd-4571-08d83335a816
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 20:34:41.8440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J9RVJEfLV/xiYohTy1pBzxzx+n/6XZw4u7PjwJgsaU0iJIfqbvf784Dy0ionNWL/hW5SWT0uWgKPxu3K2kZYEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4377
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Aaron Ma
> Sent: Wednesday, June 17, 2020 11:55 PM
> To: kuba@kernel.org; Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> davem@davemloft.net; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Lifshits, Vitaly
> <vitaly.lifshits@intel.com>; kai.heng.feng@canonical.com; Neftin, Sasha
> <sasha.neftin@intel.com>
> Subject: [Intel-wired-lan] [v4][PATCH] e1000e: continue to init phy even =
when
> failed to disable ULP
>=20
> After 'commit e086ba2fccda4 ("e1000e: disable s0ix entry and exit flows
>  for ME systems")',
> ThinkPad P14s always failed to disable ULP by ME.
> 'commit 0c80cdbf3320 ("e1000e: Warn if disabling ULP failed")'
> break out of init phy:
>=20
> error log:
> [   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
> [   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast
> Packet
> [   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error
>=20
> When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
> If continue to init phy like before, it can work as before.
> iperf test result good too.
>=20
> Fixes: 0c80cdbf3320 ("e1000e: Warn if disabling ULP failed")
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/ethernet/intel/e1000e/ich8lan.c | 1 -
>  1 file changed, 1 deletion(-)

I never did find a system that triggered the initial problem, but from a co=
mpatibility with the set of systems I do have working...
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
