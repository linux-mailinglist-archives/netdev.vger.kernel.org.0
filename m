Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8544B3940BF
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhE1KQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:16:18 -0400
Received: from mail-mw2nam08on2082.outbound.protection.outlook.com ([40.107.101.82]:56832
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235361AbhE1KQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 06:16:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akhTSVKYEwLUC4WbKMDSbjrz6vHhlRRG6y2vRrL7DhsjxjXFZTmLJo88KPiLSDJThjjL/4+Be7w92kz9wKVhwK3rHCEooncBo62DLntItRX/yIOi3EYvUpE0f3PqjE2lY500+amN/XTz0jEtasiTjbSO1H6m564sexHtOAuELUDbgLIL1dMVHxpGkpNFlH6VNh7e1JJXgRwxfd/pOnUadTgLe3m1o4qUrQ9FpWXXuq2d2WGSlSWF0Od+4rAKWHp1Z8fzz4GEGVbuJ3ES2zveEVb/o0+9blwTk6+P5r56pposxt2dweM7kk0u+wMh9+XJkk0+VaxeDbLK371ZYyNrTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhGwkCBvilyP0lzBqgmvLtZEPBynNf7W5OB6qthxXHk=;
 b=XmjFog84dKov2ZGZP0nV7DA+Qn4v5Up0AJ3F2LNOj9Hg/+sQMXeL8CY9YqYm/fiemov0PZtsjsFJim7F8Q8cWqQ/dZRtRgTeRBhK/Zt5lvqil40Zwi1UPz8ZkxjIVcYmcDvr/C6QH/PQkc7/is8xhjFmid2n9/mvp79+siifQPkeBXp9sdFxgxNuwiYMGGNl1Lo1JP5I9BU0T9gpPH0ka7PgJm2WIyWwrwx4Mvdqy0QYS4CEs/4gBV272rKpBgzBWbrgDwi9umgNyFUVjvy7950BvDZ8u38T8SrBnifNpKGYTa6GA27TRNn7Vf8n/ttJxhpyOHQUYeCROmuYykyYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhGwkCBvilyP0lzBqgmvLtZEPBynNf7W5OB6qthxXHk=;
 b=Yn8pYPwtgtxAkrvHIsNlHkEaGyQzd2+u0Cayn+3Ofjed1OrL68QMTCfxOiZRCBxLFrvFnrvSbu+ZOlqAjET+SArZiA2pLNU/FkrYBk3kHKPa+GOnmSC2T3V8PyQOKE4aq3aIY5+EW7pMO+NS474ACh7TwxcCvFmeNNx+0SvV2rU=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 10:14:41 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 10:14:41 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Topic: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Index: AQHXUy5AQawm5aX1GEG2TCkCm2KCTKr4hIAAgAAZu06AAAVtGIAACjNy
Date:   Fri, 28 May 2021 10:14:41 +0000
Message-ID: <PH0PR10MB46157D5E1072B4D2AD005463F4229@PH0PR10MB4615.namprd10.prod.outlook.com>
References: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>,<bfd059d045dd9649b7c20ecac0fd9f2d0cd5df4e.camel@intel.com>,<PH0PR10MB46156B1956C7102D0E420E8DF4229@PH0PR10MB4615.namprd10.prod.outlook.com>,<PH0PR10MB46159FE3F3DE4426AB7E73DEF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
In-Reply-To: <PH0PR10MB46159FE3F3DE4426AB7E73DEF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [178.174.231.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaa97b9c-200d-471d-ad1e-08d921c16886
x-ms-traffictypediagnostic: PH0PR10MB4486:
x-microsoft-antispam-prvs: <PH0PR10MB44869570432B279768B6D146F4229@PH0PR10MB4486.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IwK9CJLA8UuciYJiqmmvTlyCAYJ0eW0PSSP1u6GusvYHpDwfv0pUj4L7fL5rFv05zLI5hrFZ7U3oeJrhtzEykV0AHB5G0l2CWyUHBfTHoqx2ZV42gtkBxB/WjzRGMgTlv9zP5B/ZOah6Iro6toUuU6hXW+btN9aUPsTxS13Zt0+zhnXcaV9HwarfAALdgOlU/xC5Qa0iFWQsMZv08p3mAWYBbv2Xdk6yCiCLFjDPaaA8s1psFGwFGEWwB+pHLMx+4qEqZj2ou3nSz79SLS+F1g4dGs/JqglX74mWh3kKhBuEf27eX95bei2cpkGtnT9nR+vJ85PBV3bwaTxFsB7lVDdUbE/UUhWbTqjkioWW/Y0US+2JHbpi0Ro4Hcl9294IND4BEp/aHYX3Jmz8jBpnATfN5S0LRzA3BUzBamVBEFDxI/n13FrUInmtCvmkcCel0EDGHOuSggNIAOov8U1p2jzPL25uhd2jgi+Py1uvy0/sdrxL8EY6qHPpNQKwU8MXb2bDO2IBCTheyA7fvQk013/NzA4/phlVcC1hJOxRssYrPvz/IUPIpe1UqCx4KtMRauDcDR9dnZy0V2sJninEiLR95panCF85aUdm0lKVVJI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(39850400004)(346002)(8936002)(8676002)(6916009)(55016002)(4326008)(2906002)(26005)(9686003)(122000001)(2940100002)(64756008)(83380400001)(66476007)(478600001)(91956017)(76116006)(66446008)(52536014)(38100700002)(186003)(86362001)(66946007)(19627235002)(66556008)(5660300002)(6506007)(53546011)(71200400001)(7696005)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?NtJfnju+5uZkR6lcbELrn2Edfm6UoMytu5t5069eS6a4BZlMoLGsogPFWh?=
 =?iso-8859-1?Q?y1IZQRU45lkM9rsFAGl+Zs1GOqgLSHkoeD7vSJAspIfhagpHDnFR0zedeC?=
 =?iso-8859-1?Q?O2F4k/V+xZlIX1ykLDFzT4v0aaKhOB8lI+9n4Gtq97wA06MjP+zy6pdMM7?=
 =?iso-8859-1?Q?klZ6zAPD1c3OTTmEYhcIJM3Su7yOjW5G9/YoCE53pQDREgsIG9/11PnyzW?=
 =?iso-8859-1?Q?JcHWZiFGA/dwajYinHABMeV5a8+so5xLMInl+zFHtybBIWGNpWIu8i4PDn?=
 =?iso-8859-1?Q?XPwZGu3npiPC0qmddKJGsBKrWRjrxzApAcmTOVZh1E83GfltjQal3DmagT?=
 =?iso-8859-1?Q?ejZkuhnNRn4Ryx5FITWD7mLuCNq62eGz3PXXTM5lzKfGyTbeGW+e1Pms/o?=
 =?iso-8859-1?Q?peYRsHiNUJzugocPcXdq3bbD8zC95gHFJIX22sZP7TPrO0EaJYBVS1X7s3?=
 =?iso-8859-1?Q?Cx4UAYuw3kO76FO6N0ZCXCkfyy7dKsR7L8C6l16iU3NbqLnOB2j9c25l8x?=
 =?iso-8859-1?Q?6xHCeXAV5WzzwJmwE3UP7JV7blWO69gC0H+brhgGL+SZToHJpgm0CUaS2f?=
 =?iso-8859-1?Q?3lMAWbzJGRD+nIj75OgND+awF6rioIZyW/6gBuDawZFXzzcIaQ4VIy57rp?=
 =?iso-8859-1?Q?2c22eVyiNoIJge8uHAnuKxmBHfWWCpyu88j3+g/wziMiCE8pT5wiM8whrk?=
 =?iso-8859-1?Q?nd2yBwlyPygPR9zg70uQdp6PM10PKhPH6u86Y8koXWUrWmmGuDGzd2C2vu?=
 =?iso-8859-1?Q?z+bZbSN4thk4vcx7MW3JWF2XBxWkCpHFqqbAU7PaPBA89rSw+kcQNX52px?=
 =?iso-8859-1?Q?wOQ8xpsgOHa4bs9yFqgP3JCDUoxAWrz+BU9cQ63MHLEhGIjHKe0UWQSiC0?=
 =?iso-8859-1?Q?pDWLeDJybDLbEG+1V1jhruxzFQSOlwJhhtfujuXiua0xh21RShFMfRoksW?=
 =?iso-8859-1?Q?KnvdkNbZvSSCbqpmeTpxlvl2GKJaLf6qsnr9Zx+ESmF480ZdSyCRnu8WhF?=
 =?iso-8859-1?Q?Fsm8vi7oAGjZfbEyZyLVBh2EJ9AjutCbPAlh1oNGpLBeOFoETYBRV/3ebw?=
 =?iso-8859-1?Q?ga5KItiY2yLHFFbygn/sohCjPiOZRtE5Nc9iEdiQU+V2SIz/LrQCF0dywu?=
 =?iso-8859-1?Q?vFmX4DLol3qk16CtkcxC6OCQKyPux3WrlqRcplVzaFdSkBU/e6ZHcv0Qox?=
 =?iso-8859-1?Q?XLsCnppF+Cvve233YyWRJBFgekBzeIA9hWkSOuN+RZdaZWf5u5NFwo+qIT?=
 =?iso-8859-1?Q?qXrBAk4gid3gA4E28pImrjwqAPMjh3rMWXZeLNnxwBJxjORELsfYMCvjeT?=
 =?iso-8859-1?Q?X6S4slwCYZ/jNHf8SqmfoX2EajOE35WlfvdnJd4yiYBbh6fp23nMMgFJmG?=
 =?iso-8859-1?Q?7DRCZ2YNnG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa97b9c-200d-471d-ad1e-08d921c16886
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 10:14:41.4134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4um73KDetXv8DcLQ958GGAELvt8FOPHeJEYvz16fi8d/VvsltnXvQZ+dKcBTdG1M7diT5p7p+1Fq8cCTbaWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And when it works API_MAX increased:=0A=
=0A=
messages:May 27 20:43:23 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: TLV_FW_=
FSEQ_VERSION: FSEQ Version: 0.59.2.22=0A=
messages:May 27 20:43:23 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: loaded =
firmware version 62.49eeb572.0 ty-a0-gf-a0-62.ucode op_mode iwlmvm=0A=
messages:May 27 20:43:23 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: Detecte=
d Intel(R) Wi-Fi 6 AX210 160MHz, REV=3D0x420=0A=
messages:May 27 20:43:23 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: loaded =
PNVM version 0x324cd670=0A=
messages:May 27 20:43:23 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: base HW=
 address: 1c:99:57:7d:3f:11=0A=
messages:May 27 21:17:22 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: enablin=
g device (0000 -> 0002)=0A=
messages:May 27 21:17:22 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: api fla=
gs index 2 larger than supported by driver=0A=
=0A=
________________________________________=0A=
From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>=0A=
Sent: 28 May 2021 11:37=0A=
To: Coelho, Luciano=0A=
Cc: netdev@vger.kernel.org=0A=
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have IWL_22000_UCO=
DE_API_MAX 59=0A=
=0A=
This could be a clue:=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: enablin=
g device (0000 -> 0002)=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: api fla=
gs index 2 larger than supported by driver=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: TLV_FW_=
FSEQ_VERSION: FSEQ Version: 93.8.63.28=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: loaded =
firmware version 59.601f3a66.0 ty-a0-gf-a0-59.ucode op_mode iwlmvm=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: Detecte=
d Intel(R) Wi-Fi 6 AX210 160MHz, REV=3D0x420=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: loaded =
PNVM version 0x324cd670=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: Timeout=
 waiting for PNVM load!=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: Failed =
to start RT ucode: -110=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: iwl_tra=
ns_send_cmd bad state =3D 0=0A=
messages:May 27 15:39:10 se-jocke5-lx kernel: iwlwifi 0000:09:00.0: Failed =
to run INIT ucode: -110=0A=
=0A=
=0A=
________________________________________=0A=
From: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>=0A=
Sent: 28 May 2021 11:18=0A=
To: Coelho, Luciano=0A=
Cc: netdev@vger.kernel.org=0A=
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have IWL_22000_UCO=
DE_API_MAX 59=0A=
=0A=
No, there is no such file, here is what I got:=0A=
ls iwlwifi-*=0A=
iwlwifi-1000-3.ucode   iwlwifi-6000g2a-5.ucode  iwlwifi-7265D-21.ucode     =
        iwlwifi-9260-th-b0-jf-b0-34.ucode  iwlwifi-Qu-c0-hr-b0-53.ucode=0A=
iwlwifi-1000-5.ucode   iwlwifi-6000g2a-6.ucode  iwlwifi-7265D-22.ucode     =
        iwlwifi-9260-th-b0-jf-b0-38.ucode  iwlwifi-Qu-c0-hr-b0-55.ucode=0A=
iwlwifi-100-5.ucode    iwlwifi-6000g2b-5.ucode  iwlwifi-7265D-27.ucode     =
        iwlwifi-9260-th-b0-jf-b0-41.ucode  iwlwifi-Qu-c0-hr-b0-59.ucode=0A=
iwlwifi-105-6.ucode    iwlwifi-6000g2b-6.ucode  iwlwifi-7265D-29.ucode     =
        iwlwifi-9260-th-b0-jf-b0-43.ucode  iwlwifi-Qu-c0-hr-b0-62.ucode=0A=
iwlwifi-135-6.ucode    iwlwifi-6050-4.ucode     iwlwifi-8000C-13.ucode     =
        iwlwifi-9260-th-b0-jf-b0-46.ucode  iwlwifi-Qu-c0-jf-b0-48.ucode=0A=
iwlwifi-2000-6.ucode   iwlwifi-6050-5.ucode     iwlwifi-8000C-16.ucode     =
        iwlwifi-cc-a0-46.ucode             iwlwifi-Qu-c0-jf-b0-50.ucode=0A=
iwlwifi-2030-6.ucode   iwlwifi-7260-10.ucode    iwlwifi-8000C-19.ucode     =
        iwlwifi-cc-a0-48.ucode             iwlwifi-Qu-c0-jf-b0-53.ucode=0A=
iwlwifi-3160-10.ucode  iwlwifi-7260-12.ucode    iwlwifi-8000C-21.ucode     =
        iwlwifi-cc-a0-50.ucode             iwlwifi-Qu-c0-jf-b0-55.ucode=0A=
iwlwifi-3160-12.ucode  iwlwifi-7260-13.ucode    iwlwifi-8000C-22.ucode     =
        iwlwifi-cc-a0-53.ucode             iwlwifi-Qu-c0-jf-b0-59.ucode=0A=
iwlwifi-3160-13.ucode  iwlwifi-7260-16.ucode    iwlwifi-8000C-27.ucode     =
        iwlwifi-cc-a0-55.ucode             iwlwifi-Qu-c0-jf-b0-62.ucode=0A=
iwlwifi-3160-16.ucode  iwlwifi-7260-17.ucode    iwlwifi-8000C-31.ucode     =
        iwlwifi-cc-a0-59.ucode             iwlwifi-QuZ-a0-hr-b0-48.ucode=0A=
iwlwifi-3160-17.ucode  iwlwifi-7260-7.ucode     iwlwifi-8000C-34.ucode     =
        iwlwifi-cc-a0-62.ucode             iwlwifi-QuZ-a0-hr-b0-50.ucode=0A=
iwlwifi-3160-7.ucode   iwlwifi-7260-8.ucode     iwlwifi-8000C-36.ucode     =
        iwlwifi-Qu-b0-hr-b0-48.ucode       iwlwifi-QuZ-a0-hr-b0-53.ucode=0A=
iwlwifi-3160-8.ucode   iwlwifi-7260-9.ucode     iwlwifi-8265-21.ucode      =
        iwlwifi-Qu-b0-hr-b0-50.ucode       iwlwifi-QuZ-a0-hr-b0-55.ucode=0A=
iwlwifi-3160-9.ucode   iwlwifi-7265-10.ucode    iwlwifi-8265-22.ucode      =
        iwlwifi-Qu-b0-hr-b0-53.ucode       iwlwifi-QuZ-a0-hr-b0-59.ucode=0A=
iwlwifi-3168-21.ucode  iwlwifi-7265-12.ucode    iwlwifi-8265-27.ucode      =
        iwlwifi-Qu-b0-hr-b0-55.ucode       iwlwifi-QuZ-a0-hr-b0-62.ucode=0A=
iwlwifi-3168-22.ucode  iwlwifi-7265-13.ucode    iwlwifi-8265-31.ucode      =
        iwlwifi-Qu-b0-hr-b0-59.ucode       iwlwifi-QuZ-a0-jf-b0-48.ucode=0A=
iwlwifi-3168-27.ucode  iwlwifi-7265-16.ucode    iwlwifi-8265-34.ucode      =
        iwlwifi-Qu-b0-hr-b0-62.ucode       iwlwifi-QuZ-a0-jf-b0-50.ucode=0A=
iwlwifi-3168-29.ucode  iwlwifi-7265-17.ucode    iwlwifi-8265-36.ucode      =
        iwlwifi-Qu-b0-jf-b0-48.ucode       iwlwifi-QuZ-a0-jf-b0-53.ucode=0A=
iwlwifi-3945-2.ucode   iwlwifi-7265-8.ucode     iwlwifi-9000-pu-b0-jf-b0-33=
.ucode  iwlwifi-Qu-b0-jf-b0-50.ucode       iwlwifi-QuZ-a0-jf-b0-55.ucode=0A=
iwlwifi-4965-2.ucode   iwlwifi-7265-9.ucode     iwlwifi-9000-pu-b0-jf-b0-34=
.ucode  iwlwifi-Qu-b0-jf-b0-53.ucode       iwlwifi-QuZ-a0-jf-b0-59.ucode=0A=
iwlwifi-5000-1.ucode   iwlwifi-7265D-10.ucode@  iwlwifi-9000-pu-b0-jf-b0-38=
.ucode  iwlwifi-Qu-b0-jf-b0-55.ucode       iwlwifi-QuZ-a0-jf-b0-62.ucode=0A=
iwlwifi-5000-2.ucode   iwlwifi-7265D-12.ucode   iwlwifi-9000-pu-b0-jf-b0-41=
.ucode  iwlwifi-Qu-b0-jf-b0-59.ucode       iwlwifi-ty-a0-gf-a0-59.ucode=0A=
iwlwifi-5000-5.ucode   iwlwifi-7265D-13.ucode   iwlwifi-9000-pu-b0-jf-b0-43=
.ucode  iwlwifi-Qu-b0-jf-b0-62.ucode       iwlwifi-ty-a0-gf-a0-62.ucode=0A=
iwlwifi-5150-2.ucode   iwlwifi-7265D-16.ucode   iwlwifi-9000-pu-b0-jf-b0-46=
.ucode  iwlwifi-Qu-c0-hr-b0-48.ucode       iwlwifi-ty-a0-gf-a0.pnvm=0A=
iwlwifi-6000-4.ucode   iwlwifi-7265D-17.ucode   iwlwifi-9260-th-b0-jf-b0-33=
.ucode  iwlwifi-Qu-c0-hr-b0-50.ucode=0A=
=0A=
=0A=
________________________________________=0A=
From: Coelho, Luciano <luciano.coelho@intel.com>=0A=
Sent: 28 May 2021 09:45=0A=
To: Joakim Tjernlund=0A=
Cc: netdev@vger.kernel.org=0A=
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have IWL_22000_UCO=
DE_API_MAX 59=0A=
=0A=
On Thu, 2021-05-27 at 19:29 +0000, Joakim Tjernlund wrote:=0A=
> I think this is why my device:=0A=
> 9:00.0 Network controller: Intel Corporation Device 2725 (rev 1a)=0A=
>       Subsystem: Intel Corporation Device 0020=0A=
>       Kernel driver in use: iwlwifi=0A=
>       Kernel modules: iwlwifi=0A=
>=0A=
> isn't working?=0A=
=0A=
Hard to tell just from this.  the MAX_59 API thing means that it will=0A=
look for something like iwlwifi-so-a0-gf-a0-59.ucode in the=0A=
/lib/firmware directory.  Do you have that file?=0A=
=0A=
--=0A=
Cheers,=0A=
Luca.=0A=
