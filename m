Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0894D39363F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhE0TbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:31:18 -0400
Received: from mail-mw2nam10on2042.outbound.protection.outlook.com ([40.107.94.42]:3072
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhE0TbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 15:31:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEzisr2qU0gV1aCePobPB+liWpmqPRX4ZjBO8Egv97dEodioKmmt4TE6dx5l0q1Vs4Y2lB9Nvdf4Op82+jIf0sMvsm7JM5D2XzxbnGLWW+83PHy4gt816wj9R5lljar8a42dRpTw8XeT/uE86dFS0JT7e7y7ToYMGqjlyqrApBZHN+D7ugaZf5ZFuLEi+TLsYYfU3KOTJ6PbdN9PVmv1voWpi8j+gNnrUsxazzEZnXEcD39ScasC5QC8ijusrFx/EDUC20gAHRJf4HQiDQ7ZtUTfWreiwcQZV7cy6v7cX50BYBfi8wvF/sghBDEDpZiLVRJbTe4op5vG3HuLmhgiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HNSO+UoOMSDNiT0XsDTaRSTt8ojhzp4ONzqtGbE/Gw=;
 b=AV5g5mqdraWdBW1mPBQg89nBvFLageJ4qacTtRQLZoRCsIGb1vr+mrNVgbsNve65vb28Zh3zwts0/uROLBx/foHSNbYHiEVl5bhGF+dJrcplY5aCh8niv2oPyH/AAVxWL5Di+Ula3ZMqV/nfZAWZAyaKYGTLuuP2u0wQ81EW7L0GEzWbJ7JdiIqn0JdBGPdgxgBrHWhcDNKW1C8oLBHNmdJlc6vlz5ujwcS5GbZZ3OR1HbigM2V2axvNkftiolCOMGFZDWQhY9dl2ZYJ9cNo8z2RjwKEWkT2FGOUkNoRHbAR9VLksl3lY/zlFTOokAEqnu238+llWySJRUSkQZzUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HNSO+UoOMSDNiT0XsDTaRSTt8ojhzp4ONzqtGbE/Gw=;
 b=D956my2nh8N22ZWR2kiWAGbh6ntRURk+glF2e2DmME8XAyJ0qzdZK1hqu3PqYfH1Kv9ti8wG0KH2Etvo/YQFmKHc2QE8uuyWHmWWAUvUB7B3nUwOmqIfFLwu57ENK7gLU+yFzYxSroyKLBx9wlP87jmYO7ZSUf2eAoVMseK7T3Y=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 19:29:43 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::5021:f762:e76f:d567%7]) with mapi id 15.20.4173.021; Thu, 27 May 2021
 19:29:43 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     Luca Coelho <luciano.coelho@intel.com>
CC:     Netdev <netdev@vger.kernel.org>
Subject: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59 
Thread-Topic: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59 
Thread-Index: AQHXUy5AQawm5aX1GEG2TCkCm2KCTA==
Date:   Thu, 27 May 2021 19:29:43 +0000
Message-ID: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [178.174.231.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81bac0d9-a36e-4973-29ec-08d92145c7cb
x-ms-traffictypediagnostic: PH0PR10MB4567:
x-microsoft-antispam-prvs: <PH0PR10MB4567AD3B2D90D46B210C2C38F4239@PH0PR10MB4567.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wbfUfYCHOtvAOPv4jos1bHkGhn2zhUxZpHWMEeVJlSMV9L32qLGVDmk4hfJPAfPguT3IxUX7l8T3CBA9Mm0qnKiSwFLYtfn/43VPZuCnCmqEUQQqLTWivAW6setjHKyKC2Ra5vsHw7WbUxuwpUsGkjoJ5ikAvGTn39gJ+RdzECDGC3t3eTmTwAomeTrih9TR0CvyBFPMPUCxc86OjK0MpIC/Av5lY0xlckwC/nU2daR0+eEU0gSQmhgQsTMr1AraerKU46hFpms6X0F/hBSWNX25rEzFVGPncCz2LbbEpYUDLf0gqZDh8ltYrQ3qcUMld5EiShcr+w0hvSpbZUFxjdT4/gszV4cEugM3oCjC6XSI8o54pK0la3f2ulP/cPiRjjSjGvfJwrvkUQZYs73jfpmKpM1TgH6IdavojwBSjnOu2w2an2r0eBOJeDEliXid+U8GdtChC5Ef3eRFF6HFBSU0RZbbKyZhq8Men9v1/m/qQclPQw/22FSq0Hl403iYFT7EJoWM2tkU1asrbvrKZHAAMEKpNrg/ibss7ZwVyzq1q/G6e/Lz3NFFnzcIFHdYtTfpVSgQT2Uge8XCXFm1Yg4YHHOtYB0kDJ9/GXKhu68=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(6916009)(122000001)(66476007)(38100700002)(6506007)(64756008)(66446008)(558084003)(66556008)(71200400001)(186003)(86362001)(498600001)(8936002)(8676002)(4326008)(26005)(9686003)(5660300002)(66946007)(76116006)(7696005)(4743002)(33656002)(91956017)(2906002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?BBLOjvv1rB6IA+VrIPmcvP2nEGCj0IM9QdVWGXbN1pOT71U8WglLHz58MJ?=
 =?iso-8859-1?Q?dp7FdafXyHsBCim6+mW3lxiXQtrNQH0ICQW5ljzYK9LCUkYjMjN2JgMoTd?=
 =?iso-8859-1?Q?eqSGEsBopW2wYOHx/57aUTL/CY0HfJGynrf4m9i9cHGvaN26tGqOAzFVRZ?=
 =?iso-8859-1?Q?/KcaR+Tp4nEsr2rNK01p3WGqRkdQ3zOVx1N0kAB3slkKDr042DLVVTX1sg?=
 =?iso-8859-1?Q?bzuzw9fOquri4moOZw23/3VRJKNY/bhZnbANMi3tp8abAMddaK99t1lBpv?=
 =?iso-8859-1?Q?b8TC1vtrHZV0I1B4h+0FQuN33U5bShg9MoK53HJl/QbSP69EAQwQYoXta/?=
 =?iso-8859-1?Q?T/ssi28PnSHvYMdfP/SD+ov21fVFq1N5A1kCDiuRV0qBT7p+LnTiwahbeF?=
 =?iso-8859-1?Q?RSYJ+A2gwjnCGmb8UrhAgrmLUDKcS/hci4khyv/5rW0F6XZqpJ0USmpZZh?=
 =?iso-8859-1?Q?hULbPLz90iKPO3kRxQqaPRvHRC3cLwr1GiR5KhmrO+jWjrrHHuHE/ZZft9?=
 =?iso-8859-1?Q?qoEnUya+SSZQzsm4bIC0KFkQP1uEh9kA/K6K53zB3FCduDoyKODmZtLO+1?=
 =?iso-8859-1?Q?99OHdfTRnU+ahuvvGNiVE8HLqp0xxgDNyen3Q0be3SPJ0eqbNEHf9mk+aG?=
 =?iso-8859-1?Q?/SucHPd52hpLfrjg5D5M9Gkd5ZWaxgP2CwKSuyK5ggL/us7qFQt7wPTTW0?=
 =?iso-8859-1?Q?E0NGcqURU321/82hvYP8EZM3gjR1BlM8arsVkvLE1v1/rHYfbOLwWF9WtY?=
 =?iso-8859-1?Q?RwNXAyyv7pOXX/QTvdOL3n57LMDS6FBq+pCgOow+e6mT3sc+2l3fVdQQ3r?=
 =?iso-8859-1?Q?fQVFmtqjj3h8ZVF40qiMTwW/IzRwpx/St20duxM1E3KSvuPoW/yPxt4pOb?=
 =?iso-8859-1?Q?kIcFHN6qSx5nEXNB8qDG85uEgt83HhrAB8l/sFcFJRLg+cbpwYrs4/zXMl?=
 =?iso-8859-1?Q?GRTAkoAFyL/xQO597W5Zi3DYqNBLPupHBQcqeSGmeBBVTSE/qKbxWVESMf?=
 =?iso-8859-1?Q?vlV3yBrS62mIcnJ/9DBNJ+DfQpndUtNoUzcHWXdzApYB9jpdbzZHWUlFQ0?=
 =?iso-8859-1?Q?xH3iCTnaivTOqGsiMsj2WquMwYGMvi3RpInyc4SUQ3KwwRL9egJKqPDX3c?=
 =?iso-8859-1?Q?NgeuDVTFRrd7OZ2+WeF222LfIoECBhmQIVn1elaSB8Nrmsg4Hd1iEOvm0A?=
 =?iso-8859-1?Q?sGN8OtotRd6PJGAU3+Uh5IbOWkGX9W0/bIHwP2Jc06NJaYTrtQXz2zN0X/?=
 =?iso-8859-1?Q?C+1GpA93jk8uHXJNhpVDhvB3LASiFv6pIHrrlRxtLPEX3U8q59r/HI8/pd?=
 =?iso-8859-1?Q?TUNGSk2BKXWQxX6ym7or4MUNcTz5i5nvhuxzmWk75lxtTMK/4Gw5YKLYii?=
 =?iso-8859-1?Q?2+QKnOWyXO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bac0d9-a36e-4973-29ec-08d92145c7cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 19:29:43.6891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjMM/sG21EXUILvE6EwiUwX0v0Y9MSOyXc7IpcfHFMYWqvUhPHeQ8RU3M2dd+6TmiBlTZGZkZ2ElfnWzMBWPpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think this is why my device:=0A=
9:00.0 Network controller: Intel Corporation Device 2725 (rev 1a)=0A=
	Subsystem: Intel Corporation Device 0020=0A=
	Kernel driver in use: iwlwifi=0A=
	Kernel modules: iwlwifi=0A=
=0A=
isn't working? =0A=
=0A=
