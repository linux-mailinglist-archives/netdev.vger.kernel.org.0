Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33F220A390
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406560AbgFYREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 13:04:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:11854 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406524AbgFYREB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 13:04:01 -0400
IronPort-SDR: re3V2/jtAsNwmGHelifQ+lMBXNbax98Ds2kfiIee+PMxLEQe8sSJW6sqgCfb6oxVfIbQRW+8YG
 EgrAjl4Vr+lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="144058086"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="144058086"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 10:03:41 -0700
IronPort-SDR: +YIFVGHM1PxNF6lsGG8mS8jqq5prpcdvaJNv+2xmW2Qe1SBif4FCTTzVUrQRIqdAZEJTVHhzCQ
 8QLQ4+LyKqvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="297867115"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 25 Jun 2020 10:03:40 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jun 2020 10:03:03 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jun 2020 10:03:03 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 25 Jun 2020 10:03:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 25 Jun 2020 10:03:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2fA3VQNi32jakQqA2wgZriIEl5twu9Ks+kS0k1IR6cXzrNTsPyn8s6/s7T19CyTeGUfHVVZhHrnxOf8x6FuEif/G2eT9fT5rrf3u3xZecL54q5oJ5VUTcjWvbjUwm/fZHADUESn1Tmkkq/rL4UNZTRyyh8JAz4LKheVxQtENRLbAvYmRsQBB8TbiYNnM5E2O7UE81N5aOvOnWOdef62SanIXJl+KOkzQexIzWWrUnF13MKLFvPP8KyqDDPFZjWPEF1y1NZN9mbpm9qm1ATXEwMD0njYdcdbi+2ZNcoiewwaNCQDkW4dZ2HwXj+c1md4dtSTmf+G2NjneK+cSBledw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRocJjLufZtCIXOWCC781Ib68vkLwbl0zDZpqmvOssI=;
 b=haHLhRS9xfAz5pCRSIQfTUtHTsFmOD0BR8uERH9D6oOlyU2mawcRNAtn1JyaYo7InNYP2ZBvBUWHN5vcAnOALlFm8XvcqgQMg6QtdNN8XUT2sTTFBxii/NUpjz02LQHFqP67bzBOyOA8816y3gRVn0PIF48/M1eI6u7VaOZJ7GmjYf/PwSd0OLuBbtDRThsTd+mUIt5nAkiTLCb8t8jJB04TCdZxCKHOM/GqLlex9muKYsYBGljKSwNvHiP057JjLzoFnDYJt3hlKX0xRgX/WflL+hCK+5S7fNP3IDJx3qL18NPhVP5N36pmWBaF9TsWbvinB94c5zwOj9zU3QWlNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRocJjLufZtCIXOWCC781Ib68vkLwbl0zDZpqmvOssI=;
 b=JRKsXXC772d5mCOICbAb7YymEUOf+qc+HXsvYlmbEopGg3739SKJJA87YRPPIoKNp1BTzWsrofmSnZk2oSKHNSBGDP049U46lPAazG2r5ws5WRSYrvpnbFFdvPsAsal2EyY6KAwxNwCGeNRGMnhWtSVYO25a6dGAo49W5DuOTJM=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN6PR11MB1761.namprd11.prod.outlook.com
 (2603:10b6:404:102::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 25 Jun
 2020 17:03:01 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.027; Thu, 25 Jun 2020
 17:03:01 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: optimize AF_XDP
 Tx completion path
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: optimize AF_XDP
 Tx completion path
Thread-Index: AQHWSULsc9hnb9wA20KiF+A4KOe78ajpklIw
Date:   Thu, 25 Jun 2020 17:03:01 +0000
Message-ID: <BN6PR1101MB2145362BD20CD9EDEA37E6A18C920@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <1592905458-850-1-git-send-email-magnus.karlsson@intel.com>
 <1592905458-850-2-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1592905458-850-2-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07befa95-b07d-448b-3837-08d819299e8c
x-ms-traffictypediagnostic: BN6PR11MB1761:
x-microsoft-antispam-prvs: <BN6PR11MB17618B9A476194FE8F1DDD498C920@BN6PR11MB1761.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: seTHvokxss5MJEOk7SB20rNNFIv/T5A0MG7PSou2sQ3ZyPQtSLNYac8//ufCiuSLgJM/92QGG62+2NIjtiRq8++Ub8i/k5HaFZ9ejm4KPx7b1Dg+LqvQ96npQMqGzWB02200L7q+7MDdTHwAKzA01hpsTQ5bihADPGPjjw/hWM04uGZf2cBrEkRmoDcHJsj/g+AcFxnWNyoKBzYtM4TwXOM9U0ToXFdXFXZSwUIGEtr4k7zRILC2aLX+pisdXSHZKF4/siRwMnSXDTaqNo2jpbMkwdf6J11MPRZdJin4ZXpkj3iYwOQQ/hixKRLkfy1L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(66476007)(66946007)(66446008)(9686003)(6916009)(64756008)(52536014)(26005)(186003)(83380400001)(8936002)(478600001)(316002)(53546011)(2906002)(76116006)(33656002)(66556008)(6506007)(7696005)(4326008)(71200400001)(55016002)(8676002)(86362001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NPjNuUXV4zbBWuk87KsedDla3U0ZEyTV+HkJl8BDXS8k8T3lJkoSehcerfKiPt4kt6dhaoVUbPrWoD9PcWY54aFEW9V2ysMt6KHcL0tA9HgkYOiESI65Cu80fdXmG74cwzY9J9K9Zh/CBr1C6YtPW9ACqOjyii0n005MpX0M9dJNGn/rm8ZAGTm6bW9XpXYednowU955mKxH5z7EmSyHAi0h8Mvcrkm2LVp/jVTVsGxoy+q7Y99U+4pStw7A1Bi+O+xUnpTR80la0neoNJpR7cNzV1l1tushlsPe5aNZrp1nvOmjkPAJ8tqWlI6KmTflnDSGuIsbBf0VYzaGvflPQmzO9/h0Pc67dhpyUCez/Rnn9gLM7CKrRZZE7/laTFrl1z4tHM4pAQm+BvKR+WWFRUtVgM9XjcjZiU66LngE7dGNMbxk41iBC62U8I/N+t9wNQhYNguiML14hqrv9g02UDSStMUbcJCtPrEWENY0oBrRUzB1+M0zFrhUYtXhAiQC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 07befa95-b07d-448b-3837-08d819299e8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 17:03:01.6058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPmn36d6FZgtiwFNjn70z6XRd1kUt4rD9+vVBLTRsKedDwo9PVenC0Dwm1uXGAWGQg0Z4eS5+azaDIp4k7jgv6f1zH0Zl6ovYA9MH3Hw0Mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1761
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Tuesday, June 23, 2020 2:44 AM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; Topel, Bjorn
> <bjorn.topel@intel.com>; intel-wired-lan@lists.osuosl.org; Kirsher, Jeffr=
ey T
> <jeffrey.t.kirsher@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Cc: maciejromanfijalkowski@gmail.com; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e: optimize AF_XDP =
Tx
> completion path
>=20
> Improve the performance of the AF_XDP zero-copy Tx completion path.
> When there are no XDP buffers being sent using XDP_TX or XDP_REDIRECT,
> we do not have go through the SW ring to clean up any entries since the
> AF_XDP path does not use these. In these cases, just fast forward the nex=
t-
> to-use counter and skip going through the SW ring. The limit on the
> maximum number of entries to complete is also removed since the algorithm
> is now O(1). To simplify the code path, the maximum number of entries to
> complete for the XDP path is therefore also increased from 256 to 512 (th=
e
> default number of Tx HW descriptors). This should be fine since the
> completion in the XDP path is faster than in the SKB path that has 256 as=
 the
> maximum number.
>=20
> This patch provides around 4% throughput improvement for the l2fwd
> application in xdpsock on my machine.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c |  3 +-
> drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
> drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 43 +++++++++++++++---------=
-
> ----  drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 +-
>  4 files changed, 27 insertions(+), 23 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


