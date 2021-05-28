Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5CB393FB8
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhE1JT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:19:59 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:15200
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234926AbhE1JT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 05:19:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEss2+n1fMaiaqNbDLNCRhhbPXL/Q3UGwiiKDux7h/2BO7G2Yi85EvcNLtF2e6udiXDW3vL5qONdjcRVoeJw/NCMQHsH6Z2wDVn1sIySqL90AH1LiqRiE4KSiZDy1cjtqMqFJV55aGQbWAmwrTy63FqtDilbVKiZTROxZSJJRMjnqgUPIh9mo5ATKKcZ1aVUnwFTdR2gOcKnl/lswMRk6c89KQdJE7+r7flDc4pySTFDZyI59F/m4DlbtqqlyKNih0SH16jZi2+AKvpolL4Ui30N/iFK7oWk/rOcIfcSk3EJlew9mwQcUdCu/nUrf5PBRIiVkVr/W7UUnEkRtC19uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/BxdHZIo9vbRwYD5bYVejXtCCVaQLHT1WhBK69MKXA=;
 b=FMX11tZ4T2DI8WG2Qub1dPkKmXP5QBGjx+Ona9NTODoGhISewZkE+OTfgAeUE1egLOtvKzonNcjTVsP0KQCM3QhJI1M0MaY6qVY5RHbnVowhbpZteourOt2RC1IrSPY1yNAmaE296/LsHz6AqmobA6FEbnmPeJyoobV0wjmw7p4SrMZfymOWzu5ZgEG/XJwF9VKQcvKzV9RUCqFZYlrlYj4/T2jVExKn942RX8AKq6DBJQtuKxSfntjtqhoDY4g13cYpW7Fxcbmkr2+Hk7grAkYk18P/onviuAxNWZRF7OqQm5U214K8R64Vr6v+s1qX76kse2EkJJJKa1W+FR+Taw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/BxdHZIo9vbRwYD5bYVejXtCCVaQLHT1WhBK69MKXA=;
 b=ZKBo0P86yf/Lw93IYY032+4gP3eNsvnwIbxn4lbc4WjNvLtoTl6lQl6Hsx9KdWRF4zo9k5dMgcQpduDwLbFAszyL/RwY0Di8DK4CoV+eNSLv3avBN+dRotJyoPICnd9vXXyQXGEADOqWeMDCJNn/UJdJbyZMKQ7wo/pem01g5Bw=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Fri, 28 May
 2021 09:18:22 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 09:18:22 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Topic: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Index: AQHXUy5AQawm5aX1GEG2TCkCm2KCTKr4hIAAgAAZu04=
Date:   Fri, 28 May 2021 09:18:21 +0000
Message-ID: <PH0PR10MB46156B1956C7102D0E420E8DF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
References: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>,<bfd059d045dd9649b7c20ecac0fd9f2d0cd5df4e.camel@intel.com>
In-Reply-To: <bfd059d045dd9649b7c20ecac0fd9f2d0cd5df4e.camel@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [178.174.231.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7107361-5bab-46e1-d6a0-08d921b98a2b
x-ms-traffictypediagnostic: PH0PR10MB4728:
x-microsoft-antispam-prvs: <PH0PR10MB4728B34E50B1D13D495940FEF4229@PH0PR10MB4728.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2Hqq8WojD5XuEGt1n8Kg84gEksJRz1kfHQON5MJx/v/hv2jiY98fAJHwDRqZCWMTf0shIOqheNXboCU3I+ALk7yX2/zNI22Kyy8SwyAmSxr5cLdyNDKJ/VJEcZ67cLxlBZ34oYmbGc/BHvn3nKLw3jyS98soVaOj20S8OosGpvGM0n9BPnXju1c700PoXJp7I8eYZLiO4rVbyggk3iLYqRkLgp47eg90RHjBKjJFdm7haFjaY/odQ6wk3qGJbRmZ2kop7GAArbnyvVGZ/5mq2mbdiUYIPs9333ozN9ywsSZI6RZOeqCp2yJfBm4k6e6RD4FULB7ByOeTyhxqCPR3FUqrhK8ep6XfzpKTS/mYGMnFQjOa6dkYTeTaNCFPckeQJtivihHFjxDNOgbnnA5OeBHXoNnPtr3hcA6hAJiZF2OMlkwXCAwhCO4ZZ0CZS9VMe61sovmQZHxUuPeSgEa6DChTFVNgzuNAkc5JIn30T4MENWoO94ERvDuqEiK4ZpEZz4bIwqfQrLU1ta2GHRwXyGOK3Yx5i21UCyXlYI+4KYfHZRqlXuBO0jYC8Doz6m4GysvNoSfzhwxLFAoOd5maLLbN9mC6/ctY06mac9p2fg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39850400004)(136003)(376002)(2906002)(5660300002)(7696005)(6506007)(9686003)(53546011)(55016002)(86362001)(71200400001)(19627235002)(8676002)(122000001)(38100700002)(8936002)(26005)(186003)(316002)(6916009)(83380400001)(33656002)(66446008)(478600001)(64756008)(66556008)(66476007)(76116006)(91956017)(66946007)(52536014)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?2uPOEQwU/28dafL9G/20T7a4Qb+VqcXCguppNJnbe6PvomUhpVpVWaZ00P?=
 =?iso-8859-1?Q?2cvmlzKntc852M1n5MOs2Pb3xbj3NYVjcaSIkI94RGG3pOKFa+GgawXnq9?=
 =?iso-8859-1?Q?p0qdHNEmrvX2oV+wCP4IxAD+ChZRZeAJigixCio+V9bXnLJHi/MiZN0o3n?=
 =?iso-8859-1?Q?0OT+MasnVdeRRNHsOjmWZ4gN9dhQjK6o4rlHS7HtOdmyBFA3zbHPSpme1j?=
 =?iso-8859-1?Q?DICP4HsVxBc+vJ8xNWR0gS11tnHHg3Dvatw95kef7ub4+n3boC2FZHtc63?=
 =?iso-8859-1?Q?YPw/fImZuswOntncPWYTwvjm5v6dg7rctNQTMnBVGczcAgJjR0pLLcPSO2?=
 =?iso-8859-1?Q?v+9T9OOPkUrEPkyUdu2SNDmlX/Y7/CzrTz7tE2npavlLcSvJuB9/MsCzZI?=
 =?iso-8859-1?Q?ymDmXljEAPRmkuGBSr0SbaBJ0ValjasGlzhOS5oVmfvxZ7cAie1BLpa+xT?=
 =?iso-8859-1?Q?iGnLaAPmgKDhQlbKa9ZyAVetyV/KO6lhuZ3TEnhAtFJLg/l6vBSAiqnbei?=
 =?iso-8859-1?Q?z9ly7l+px8xWYyJfdv65+zVtwmKdgh4xsu4A6WVefr2vF/eM8DhZXCDJdz?=
 =?iso-8859-1?Q?IlT1zRbbDEhMT0w8wGdWIyHbTSSeB++ERbB2Ah0JyxMSiZDe+RnxhHTG1f?=
 =?iso-8859-1?Q?WZ4Ib1mkBxVcw8n7IqS0dBIK4RP59vius/MTqEM3hMEF6gSn04QP/2g5Lh?=
 =?iso-8859-1?Q?pLWN9Ysjab2uiRV9H0WJeRirCbv63yP7WND6IqA3Do0+aynMVRe8uOyI5r?=
 =?iso-8859-1?Q?NzUX+Sr+FsXOvJ4M65CM/OzJXavW/tCzBY/L3bup8E7BU02k8s2x+A14pp?=
 =?iso-8859-1?Q?hvYLBw8bGn1xzymQWzpjiuOwQtYvid23achMclx0+h1RMqxS0lnipUvH1K?=
 =?iso-8859-1?Q?MSodiJdfyYP7LxpS7LeajsQcI9GJ1tVSsPJh2hfPZwX2aIePsaC75eb14g?=
 =?iso-8859-1?Q?zuHpK8JiV+O493a3XI/KftmEPAcMUdIrE2ukabXnoJjavkyv3odeGYFIf6?=
 =?iso-8859-1?Q?QkhBAx4UxQcVMzTJV6JyHqTrxN1fF18k/CAc34xSQTsF8I71cPXXk4yXtw?=
 =?iso-8859-1?Q?5AmkPvK7dW9ADXxigGNKeL1e5Fq/5Rdgwkb/AEIaX7sCPoHPauBD9XqEVk?=
 =?iso-8859-1?Q?aY3VKXGQcmnJNXNk4ZD183TjrsszhLlEq+w2zbSx0ZNiiqZTpIelIDu2ph?=
 =?iso-8859-1?Q?ZWk4+h7CKkKDLw0z8lT9FEr7XTGSMOJWpxoQQ0RpeSkjRR11XotrMytX8a?=
 =?iso-8859-1?Q?8jocvCmkgECYoUCR+ArDexfSSC5qXd6t0ebnxIReoYO7BBdMxusNpBcZGj?=
 =?iso-8859-1?Q?8nHTAdUgBGdMvvcDop7M/r6yRZ/kYqPxRR4bbqgEVb/d65rszEtmnDndKV?=
 =?iso-8859-1?Q?Dg36qYB6MM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7107361-5bab-46e1-d6a0-08d921b98a2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 09:18:21.8838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bsT8Hkl+AvhtJzJfjrAiXTvMBtSAB7frIv8hdj0AM+cTJJ9qCdeHHNC9FLZu0AsF1CKZNyHF5wSnvkTv35n6Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No, there is no such file, here is what I got:=0A=
ls iwlwifi-*=0A=
iwlwifi-1000-3.ucode   iwlwifi-6000g2a-5.ucode	iwlwifi-7265D-21.ucode		   i=
wlwifi-9260-th-b0-jf-b0-34.ucode  iwlwifi-Qu-c0-hr-b0-53.ucode=0A=
iwlwifi-1000-5.ucode   iwlwifi-6000g2a-6.ucode	iwlwifi-7265D-22.ucode		   i=
wlwifi-9260-th-b0-jf-b0-38.ucode  iwlwifi-Qu-c0-hr-b0-55.ucode=0A=
iwlwifi-100-5.ucode    iwlwifi-6000g2b-5.ucode	iwlwifi-7265D-27.ucode		   i=
wlwifi-9260-th-b0-jf-b0-41.ucode  iwlwifi-Qu-c0-hr-b0-59.ucode=0A=
iwlwifi-105-6.ucode    iwlwifi-6000g2b-6.ucode	iwlwifi-7265D-29.ucode		   i=
wlwifi-9260-th-b0-jf-b0-43.ucode  iwlwifi-Qu-c0-hr-b0-62.ucode=0A=
iwlwifi-135-6.ucode    iwlwifi-6050-4.ucode	iwlwifi-8000C-13.ucode		   iwlw=
ifi-9260-th-b0-jf-b0-46.ucode  iwlwifi-Qu-c0-jf-b0-48.ucode=0A=
iwlwifi-2000-6.ucode   iwlwifi-6050-5.ucode	iwlwifi-8000C-16.ucode		   iwlw=
ifi-cc-a0-46.ucode	      iwlwifi-Qu-c0-jf-b0-50.ucode=0A=
iwlwifi-2030-6.ucode   iwlwifi-7260-10.ucode	iwlwifi-8000C-19.ucode		   iwl=
wifi-cc-a0-48.ucode	      iwlwifi-Qu-c0-jf-b0-53.ucode=0A=
iwlwifi-3160-10.ucode  iwlwifi-7260-12.ucode	iwlwifi-8000C-21.ucode		   iwl=
wifi-cc-a0-50.ucode	      iwlwifi-Qu-c0-jf-b0-55.ucode=0A=
iwlwifi-3160-12.ucode  iwlwifi-7260-13.ucode	iwlwifi-8000C-22.ucode		   iwl=
wifi-cc-a0-53.ucode	      iwlwifi-Qu-c0-jf-b0-59.ucode=0A=
iwlwifi-3160-13.ucode  iwlwifi-7260-16.ucode	iwlwifi-8000C-27.ucode		   iwl=
wifi-cc-a0-55.ucode	      iwlwifi-Qu-c0-jf-b0-62.ucode=0A=
iwlwifi-3160-16.ucode  iwlwifi-7260-17.ucode	iwlwifi-8000C-31.ucode		   iwl=
wifi-cc-a0-59.ucode	      iwlwifi-QuZ-a0-hr-b0-48.ucode=0A=
iwlwifi-3160-17.ucode  iwlwifi-7260-7.ucode	iwlwifi-8000C-34.ucode		   iwlw=
ifi-cc-a0-62.ucode	      iwlwifi-QuZ-a0-hr-b0-50.ucode=0A=
iwlwifi-3160-7.ucode   iwlwifi-7260-8.ucode	iwlwifi-8000C-36.ucode		   iwlw=
ifi-Qu-b0-hr-b0-48.ucode       iwlwifi-QuZ-a0-hr-b0-53.ucode=0A=
iwlwifi-3160-8.ucode   iwlwifi-7260-9.ucode	iwlwifi-8265-21.ucode		   iwlwi=
fi-Qu-b0-hr-b0-50.ucode       iwlwifi-QuZ-a0-hr-b0-55.ucode=0A=
iwlwifi-3160-9.ucode   iwlwifi-7265-10.ucode	iwlwifi-8265-22.ucode		   iwlw=
ifi-Qu-b0-hr-b0-53.ucode       iwlwifi-QuZ-a0-hr-b0-59.ucode=0A=
iwlwifi-3168-21.ucode  iwlwifi-7265-12.ucode	iwlwifi-8265-27.ucode		   iwlw=
ifi-Qu-b0-hr-b0-55.ucode       iwlwifi-QuZ-a0-hr-b0-62.ucode=0A=
iwlwifi-3168-22.ucode  iwlwifi-7265-13.ucode	iwlwifi-8265-31.ucode		   iwlw=
ifi-Qu-b0-hr-b0-59.ucode       iwlwifi-QuZ-a0-jf-b0-48.ucode=0A=
iwlwifi-3168-27.ucode  iwlwifi-7265-16.ucode	iwlwifi-8265-34.ucode		   iwlw=
ifi-Qu-b0-hr-b0-62.ucode       iwlwifi-QuZ-a0-jf-b0-50.ucode=0A=
iwlwifi-3168-29.ucode  iwlwifi-7265-17.ucode	iwlwifi-8265-36.ucode		   iwlw=
ifi-Qu-b0-jf-b0-48.ucode       iwlwifi-QuZ-a0-jf-b0-53.ucode=0A=
iwlwifi-3945-2.ucode   iwlwifi-7265-8.ucode	iwlwifi-9000-pu-b0-jf-b0-33.uco=
de  iwlwifi-Qu-b0-jf-b0-50.ucode       iwlwifi-QuZ-a0-jf-b0-55.ucode=0A=
iwlwifi-4965-2.ucode   iwlwifi-7265-9.ucode	iwlwifi-9000-pu-b0-jf-b0-34.uco=
de  iwlwifi-Qu-b0-jf-b0-53.ucode       iwlwifi-QuZ-a0-jf-b0-59.ucode=0A=
iwlwifi-5000-1.ucode   iwlwifi-7265D-10.ucode@	iwlwifi-9000-pu-b0-jf-b0-38.=
ucode  iwlwifi-Qu-b0-jf-b0-55.ucode       iwlwifi-QuZ-a0-jf-b0-62.ucode=0A=
iwlwifi-5000-2.ucode   iwlwifi-7265D-12.ucode	iwlwifi-9000-pu-b0-jf-b0-41.u=
code  iwlwifi-Qu-b0-jf-b0-59.ucode       iwlwifi-ty-a0-gf-a0-59.ucode=0A=
iwlwifi-5000-5.ucode   iwlwifi-7265D-13.ucode	iwlwifi-9000-pu-b0-jf-b0-43.u=
code  iwlwifi-Qu-b0-jf-b0-62.ucode       iwlwifi-ty-a0-gf-a0-62.ucode=0A=
iwlwifi-5150-2.ucode   iwlwifi-7265D-16.ucode	iwlwifi-9000-pu-b0-jf-b0-46.u=
code  iwlwifi-Qu-c0-hr-b0-48.ucode       iwlwifi-ty-a0-gf-a0.pnvm=0A=
iwlwifi-6000-4.ucode   iwlwifi-7265D-17.ucode	iwlwifi-9260-th-b0-jf-b0-33.u=
code  iwlwifi-Qu-c0-hr-b0-50.ucode=0A=
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
