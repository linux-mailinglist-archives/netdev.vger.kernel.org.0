Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EBE39401E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhE1JjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:39:01 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:46304
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234770AbhE1JjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 05:39:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/2Tqiwhvbrys2meBIwB6GSy1fbaU8tXP8pWlqx3mbBD2qKLaDAHjQPn1/1Gg5YraX2FTk/IBHr1QTJMRWU/N3STbiSBBTdlx3ucr2w5PLA0EUuACB4ZqyX7XqEHHfIDUcZ/2ZCE0RrOQEVOEKykBOCP6Jcg8BH0SSBUX8XVHx/BiP4Iy5pn+AXA6NVV3YxrxPWRJnI68/JjfFwtC8h07NdJxNJQLYRPwVlA2K3zjR7snmL34Z4ks8ImwYgwfZ4PP0bqpgA4m7QLVHw+YpVdOM56z2ghqJ6neuuSbGFhJwBSlmAqlP/XOid9hRlehbNMx5OvLvDtcnpOyR+uP6BLFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxZfHY5jxSyUzpKyW73ISJOSr5gzL+qbMpFzpmd86Gk=;
 b=Xfb4GKeIasPl0aSbPWPGYDx/BJbPH8ueUrxgwD9YZAUbg73jlD/hr9nJ/4WuFApUh28L3jDikorGPCGVYf8GRsYIh+YPHHK03bu3vYHZMuxB3yzrUknanNNRzTb5EZkBnVPpbqLmFkwmcwFgkOPoXQZ5Q91l4XVQi3vggNJNfVN7EyKsT8bqcuZjFnX/QmIt4GmeL1xV4hJEwnYgyhHdFvm2PpPgDjO/NUTMtBgTIIIx3WaKPRsB7R1x/TdOzJwbIAMcC4P3snLExgYnj8ACTn8e1xPc3MO+TUXBZL7MNUcQsZ8tXUhE8ssmb38ceuext7k7PKVwfePJNstYo2rj0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxZfHY5jxSyUzpKyW73ISJOSr5gzL+qbMpFzpmd86Gk=;
 b=GZbruehXGvGw5ixX/tee28ttTG6sai548wM/ygcCkH8k9+MK/PbYuvK4goi4Wsom7pqSXFUeH7LNRBNLVjDAl1jAK55nq45swx8hjdy7W24BYeOr2NrazubDE/d3Ax1TuLi3Q4t4/fl6tobEQZ3mh6bhuSnZ3Z0ILO98WzHCxgg=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB5435.namprd10.prod.outlook.com (2603:10b6:510:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 09:37:24 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 09:37:24 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "Coelho, Luciano" <luciano.coelho@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Topic: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Index: AQHXUy5AQawm5aX1GEG2TCkCm2KCTKr4hIAAgAAZu06AAAVtGA==
Date:   Fri, 28 May 2021 09:37:24 +0000
Message-ID: <PH0PR10MB46159FE3F3DE4426AB7E73DEF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
References: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>,<bfd059d045dd9649b7c20ecac0fd9f2d0cd5df4e.camel@intel.com>,<PH0PR10MB46156B1956C7102D0E420E8DF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
In-Reply-To: <PH0PR10MB46156B1956C7102D0E420E8DF4229@PH0PR10MB4615.namprd10.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [178.174.231.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa4a9fa4-4b79-428e-df33-08d921bc331b
x-ms-traffictypediagnostic: PH0PR10MB5435:
x-microsoft-antispam-prvs: <PH0PR10MB5435F1A8B948DDA0C45C39BAF4229@PH0PR10MB5435.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jzs+iBZeaDWVrmiwhcOprJGzqBNiHVzPhenizadHVdWcnv1aKYU1EysZPEUUWF7qHYJrhudGQqyrjebAxaf37+dmxQ70cLAOP/pSP8vkGEIJXtH/P9nzlIzPZJDZkoKqHomOxUafCuuUmE8KLsuZ4B7zkOc/e0zG5enMAu5E1a9gy2NxudITwO09mwM+w+OKAi3tNRRZZyLqtPuVf5lcoYCqiE2Fp5DO7VpPBc1J5k2S3r1rqO5Owu5Wht8g7N9Lg1pH5zcc5JlS+5KisuBS1VaYz4TIcGpLA6xImxFBBEaoboQFbFp6eMqaradyacdN09RRtE5/LkYunJLl4vAIhIt6VgAAkHxzz/yWJ/OK5UnA2ajCSXGInELrgZKkfLtJTA7lXXlfapb5lBv+5TI61ozBcIFPGyMKlWg3BPzuyEywQbfo1Sf//nDfcydIlLnaiEVg33ybkiIzv1nm2PS1V3I7JO24u7n/U6TVJQPs54kbYsYjO/5sVmAuqUwG4XAxKtgEs7oryQDVZPH0rj23z1BRlB/tclStHvZqmL9ZrXuW+gJbui1X5XxDgLbV58IPB7fMKxRL6hbbA9IsMn0K3qAhDSCGN34nnLLrPUQ5A0c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(39850400004)(346002)(186003)(2940100002)(478600001)(55016002)(66556008)(66446008)(83380400001)(6916009)(86362001)(122000001)(64756008)(66946007)(66476007)(91956017)(76116006)(53546011)(52536014)(8676002)(6506007)(38100700002)(7696005)(8936002)(71200400001)(9686003)(2906002)(316002)(19627235002)(26005)(4326008)(5660300002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?TIntCU4X+AR1bkON1qXClKaaMLXTTch0gTod0Il2YVymGaf0CwYmeMb+mO?=
 =?iso-8859-1?Q?fAeLujGQI9clVoOMKKNQT4SiYII3n6ejkgUuDMPLKtGM13XbKfvr70EnLH?=
 =?iso-8859-1?Q?qsTFY4iHmR/2bDm21d5E/fvb3gqR/IQPB88aw/rNbtbGmFTVVJyi9pyb2W?=
 =?iso-8859-1?Q?8yhLG0f6SuyGE4DJodr5ZN9aBAhTAYsytGQo5YCZHfXdhGQ5h0t6Sn6at3?=
 =?iso-8859-1?Q?291YCe2RJOg+PQakaGMHKxfZvTjRGDA6gJUJxBFZs3FF9swtQeOxHDEhDr?=
 =?iso-8859-1?Q?p8IyYZNql++2YjV3jY/0mVOWJ4rqUzBqxQ3LxqQkhbFz4pG1v/9vFEk7DA?=
 =?iso-8859-1?Q?SVif89mquwWrpDsdchoDtQCyt8xZoae5k+X/hke6ovX+c2A7vIGvvA7S1k?=
 =?iso-8859-1?Q?me//f+Xv0FrQB6Y+RYIT0XIzsz5Gd9Si2Vgzq9rTYRp4tcZufc7kJEx81d?=
 =?iso-8859-1?Q?YTjcz2eGI66NMq9rY2tIThHKXUnpA8Tu79TL8uFNuDngmNR6+hloPRavaq?=
 =?iso-8859-1?Q?dSXmpU9I/UdDS8rHRbWZTkQYHKo4C+l4//xNSIySXE7KNSN0gaPM5UQwNJ?=
 =?iso-8859-1?Q?qXIhuKIP8qQgsqv03IndKy1wYT/OGB9teAiu4rxZahaMG8g3psoF6Rdmaf?=
 =?iso-8859-1?Q?6EYQsd1y9rG+IZTIf6nqXO10g0scl3jF8hUNeoio/T+JIl+7x+oyb5wFmJ?=
 =?iso-8859-1?Q?O156XGeUnwMIt6a9ZG02GVebtz4VpVQw4Hl+lyM4+u/9qt15m3zG5B+d38?=
 =?iso-8859-1?Q?orTZfXjVxj+wK91cSywPWrMezw4fsVGeBXJJB0L70+sbG0DefeXN+y3HWU?=
 =?iso-8859-1?Q?F67MA7iIL48UEP9qad6okC2N+etOOgRiwCv1AYOcr+iVahnF83CKdXK4DV?=
 =?iso-8859-1?Q?D4neog5jXTC4cHJqUfbdMziXHKFYqHTJ/hVlAW+k86JvHCFxMkTJ97kXtH?=
 =?iso-8859-1?Q?Va/HABkZz3Zj/JDm2Wfep0RB8s44bgYBScUqvn/q9MpTFyg/9HbFoasFjl?=
 =?iso-8859-1?Q?9RscEwrCzTmC5OYA+Ug0tuoQAKZhMIGN1Gc+RQY5+DhKWt9Gtd+SGevYnV?=
 =?iso-8859-1?Q?M6jPlheDa6LSkfu41vcYfxvWkVeJ8mxdMjdHoWSNu5CoChHwp1MyYeMUXs?=
 =?iso-8859-1?Q?AaegHvi2hdkNOkfVNL+IsaThlLvaEjyNfaBCmRRZ6LMJmG83mESJh+O//w?=
 =?iso-8859-1?Q?PMPudy5V20Frz6Mxe6LcH2Lzv3k1tSEuiNm9t7xC0pdLYgcPkqgqmDhcMn?=
 =?iso-8859-1?Q?6gdRFvaKP/5yraElW2srjHZpiKly4bxR6e2iUVtR3dMR/jlFa/bkOEFwbk?=
 =?iso-8859-1?Q?yBgWGVaNLN83Atf3nK10Oq8I74pVPll2uIPgynmYU1U/lRfO4qJrs9u6e1?=
 =?iso-8859-1?Q?ZDjpI5ebF6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4a9fa4-4b79-428e-df33-08d921bc331b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 09:37:24.2747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7hqRQjOapvLHwDZZedvns6g7gDWbMoyb0NcsmK0nhac10lqYw7BN+RKnpu6MgBdnebiXvlRiAV30ZSDKcyRKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
