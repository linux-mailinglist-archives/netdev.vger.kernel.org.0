Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12F406FF5
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhIJQuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:50:52 -0400
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:63777
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229466AbhIJQus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:50:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j22aNeHUiuVYaXh7FqE4yvYHDKPs3bfLClSyg9+mfm0Sx2gwNVmwSJ/QJCi+4X4urlDIr1c1RP1SictlrIMaiRY9tL48jiRnPUKfFXg5o6tssd4jTarspTEjCkNIO7EreCidLEtlBDyG/0A2WBBNZgAWO26UfF9aJj4vZss0YpZqw5km00FU77gT2jy4bcGrSi6Y0ZIAn+GU4XS8Kd5yYxCvhQOdqREq8vyZfL+79RYfnEHOMHwRGsObSeEI1ipMIjKjPhEoggNmksiP5d2+hp+qKmdUZzsSYnNKMpoO2xJcmouK4XxTrU9w2YIJiTxc78SL9hmGyrDXvegLyTDv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/9uUF/wguKjlNXcv01lfiNDYgNSKIhCncIBXQxXjIQs=;
 b=UDSxnxG+yCBlCl89+WLz7skF7soa/gJjAW/ytnYCGooknvuMeNGSJHQaPHfkv5B0XKN2hd9f+XELzqhlAZ82JBwWIRUmstJCBBTTYQJ8t+5YdYSM3Kq53k06xejwUiN+62p40pXiEwFXlxeMulJ8Jk4cMNz6AsaMXkzlbySADaZXHcTYf1BNzsnm6fCiuzzQm1V9FljvtTLXAlKrSOVmoGu7wZYzg5RusBck4xRn6Yzx+cANtUhpKfyTc+LPFn4lUCkGeswy+RyiMGHu2OZeukKdqIr9dvWoE12vpUUh5CZUbN78bv42kB00LJcFCj8zLzOh5kCNMZkdS2azV29lSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9uUF/wguKjlNXcv01lfiNDYgNSKIhCncIBXQxXjIQs=;
 b=D0kCKCa5TSYnmFEnD/SjAeZCROtdpuqspq7wbMkuk4nAToeidkxuIHdzuudNALYgY6s9velN3jAv2ljN3MjOYvh2PHzH8xU468YXdEayVZg50poKCq6pcUH52FRbzjUnOd97KUG7S0vN1yrtYbeLFdkCClY/vYfJ426vQAJFMjg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Fri, 10 Sep
 2021 16:49:34 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:49:34 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 29/31] staging: wfx: remove useless comments after #endif
Date:   Fri, 10 Sep 2021 18:49:30 +0200
Message-ID: <3556920.DX4m0svyV5@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910162718.tjcwwxtxbr3ugdgf@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <20210910160504.1794332-30-Jerome.Pouiller@silabs.com> <20210910162718.tjcwwxtxbr3ugdgf@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN4PR0701CA0040.namprd07.prod.outlook.com
 (2603:10b6:803:2d::18) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0701CA0040.namprd07.prod.outlook.com (2603:10b6:803:2d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:49:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab70d748-0ad9-4b0d-7da3-08d9747af7e7
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:
X-Microsoft-Antispam-PRVS: <SA2PR11MB5052ACE7C1010719FFCF786F93D69@SA2PR11MB5052.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4HH+AYH7rnuitmg4k5Uv4xEQP2Sf4Rb8VTcA5f8zSqQwA8Ko6bgA/cn70T0WfufJhge7TeTVDGukomIpm7KsqHMfMCHc5zVONeM4DsJqU9B7uVwYEgeRcNsayg+C98ISN/ekdCGFXGc/vt6Bra4WyQfW3FsuJVuHVGqZB2S8KspC0ZLEZP7Cmn+NR91e4a6dgZlfbijyegSyXABldwoDt/X78zQSDdOW3iwiW770wDIW5lei7x/x8SqvmPIM2Kg5PT9sgO7x5z1H4ql42NLXT07BXZ4NHxa81IEzUa6hY9GJKWRMTaEEgcAjf8jc7Q0fWG3qCU3iKt4xvZU+GUlkx6Olhx8YH8ynfkksIPays75P5N5WYEFpJehru0pCVHaTBIhSlCst+R0KXS+Dko9HJirJIV4vAR8HeEcPPZodOifXWQqDb74B2csqoSVnd+YC09gFJvUgXqOKM01iDxQ1PaNlcP4WW/ZPQVDhpmBGBlDTak9L42sF2Byq9f6q/oNgeCqV1GHX645MP8rDXZKwbM31rJSAIFbw9M8ShB9fSdalElyc5imNKTXGSlwm97LR8n6wGekNulFQ78mxco18Qtz193WZt+4BbP6lp5QfnYocHI45V4OlNP0qaFGdBcqsNbh0i+RPdPhXJM8cy+sT6T+z8CkV6BMZGVUWZJ1ett5r+Hli2BBauHEtN4UWWsDY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39850400004)(376002)(8676002)(83380400001)(6506007)(2906002)(6486002)(33716001)(4326008)(478600001)(66476007)(316002)(9686003)(6512007)(66556008)(86362001)(36916002)(52116002)(6916009)(66946007)(54906003)(8936002)(38100700002)(5660300002)(186003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pPuP4VoRvVKpG8UsZ6XKfgBW5OdBENlGz86w32m0WV239EZBkyhDh45ZmY?=
 =?iso-8859-1?Q?0A0G0dqYPMg7Tl2wpIQoRPDQlYnjM5PBAZkvFkqHHp2n0CIdYS6DRKMG/z?=
 =?iso-8859-1?Q?GBa6XeJ+KPmjkcTadq8qzqZ1dShhUZOYHBnFBxUJqbLkQuoCrirJ0EFXQx?=
 =?iso-8859-1?Q?KyihFwWm6AP6QmX4XEt40NIWgSOqR9Zh1Js2N/JB+3avlvUsBAcssTiJsb?=
 =?iso-8859-1?Q?Cvg3nY5vr/hknytHV3XeXgtQ5cESszj24ntMg4jWpsJc+q+lcM2Ul/KQz3?=
 =?iso-8859-1?Q?mpZ8L5cRILesbtXEJD5EFKscjfrthgnKbrgDwJjtSpSon8So7gWD22wCjo?=
 =?iso-8859-1?Q?Q9SQbFF457O1HHAwybzmb1ZGX2lk0ojRg7tDME8FA3jJ4mup3fHda3eswf?=
 =?iso-8859-1?Q?IdKwJcudczOx/o8GnWmV5lx1Dx14wMMAotttZSKwXUQ/j3xbEuyQm6A1iv?=
 =?iso-8859-1?Q?ipcn8I+tM+1RjJroYxU8hV6Ierh59REhSZo4Huh1ZkwMrMyyB+vY3pq4oJ?=
 =?iso-8859-1?Q?Ha+pHf21NzxYHcIMG9/6OHBWb8rSWC2NgpHVkmXmSBkEecK4xX/Q0EsNEg?=
 =?iso-8859-1?Q?3ectjYUztO8kko+bv8uEKafUGJVajF0WF1rhFnYpPEQahhKfLK7vvFBZZp?=
 =?iso-8859-1?Q?dCcoQ0G0z6ynvMaUYIaQ0VlLAVGD2/QrRuk+CiCP2sYPTEpHjC3zjvgoUG?=
 =?iso-8859-1?Q?/us+/zpk26OzRJU/C01j2PvE9vOP+U7RrO/dVNTwE2mgRkyAMTSQh7Z8VA?=
 =?iso-8859-1?Q?zC3PSf9rCwoHuOvMR0ZLsbnxVzd7bfNA/eZp0RFX19StQBRWp4l1qmuDTf?=
 =?iso-8859-1?Q?ow7J79hEogFbHh3f4Zx/1P3sB8Pxc3p0hT2+P963QEtCVNv0LkCD+I0fMV?=
 =?iso-8859-1?Q?Zv3bYwrw/pTerxvhyJ0xOT3eZWGSmvqBOltbnWYuwvGv4cd6sQ5Zv8RDy3?=
 =?iso-8859-1?Q?KW9TTFP/cExLg4eXbEVHVjr6LMRUouunsQqRPFw6oKLTFcTulR7G17X8Ao?=
 =?iso-8859-1?Q?CjagB2hOxlUXs7WtMMkizMtWsg/70WalftoTmWBInth+rFpn/J5lT8DsJe?=
 =?iso-8859-1?Q?9yG26NGtdFSX6nvXTNx840frRAxzewBwLg+paGgwZNJ/a20/f+zApKT2s2?=
 =?iso-8859-1?Q?xSvdgDO2kCW7TiECKG1imjZ8bPIcJjkegG2zZm4Ml7sJ8/VZ+hMHYp/Zrd?=
 =?iso-8859-1?Q?zUhQ0UXkkbLVJ61lMpVD2yAQTklfgp92Z47SdLQZo6CYb12/rxSa42MJu+?=
 =?iso-8859-1?Q?gmJVs9IOBFBzvhutFMLeWOFxBNYI0okS9UQLBU0hqgJJZCaDxerh1P2UBU?=
 =?iso-8859-1?Q?QEZYISebpZyCR1kmbn27yGEKQhrlU9Raw2KKY2608YcOsGCmZbsI1KVwbU?=
 =?iso-8859-1?Q?fxUbGt+QD8RTkjAtkCfcQsEDNhUElGaIdL2OP9Q2iXi3r04bys9oo0sqIa?=
 =?iso-8859-1?Q?zLK6zkZWbjA0iWaA?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab70d748-0ad9-4b0d-7da3-08d9747af7e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:49:34.5010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9+RsaNI48b7NOUxXmwTldbLXh9T+GzJkqXCuh5KNUYbyZo8hKD+BekdYmFpZnRExCmRzv4CFxD29L3VSI6ctw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 18:27:18 CEST Kari Argillander wrote:
> On Fri, Sep 10, 2021 at 06:05:02PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Comments after the last #endif of header files don't bring any
> > information and are redundant with the name of the file. Drop them.
>=20
> How so? You see right away that this indeed is header guard and not some
> other random thing. Also kernel coding standard says:
>=20
>         At the end of any non-trivial #if or #ifdef block (more than a
>         few line), place a comment after the #endif on the same line,
>         noting the conditional expression used.
>=20
> There is no point dropping them imo. If you think about space saving
> this patch will take more space. Because it will be in version history.
> So nack from me unless some one can trun my head around.

IMHO, the #endif on the last line of an header file terminates a trivial
#ifdef block.

Moreover, they are often out-of-sync with the #ifndef statement, like here:

[...]
> > diff --git a/drivers/staging/wfx/key.h b/drivers/staging/wfx/key.h
> > index dd189788acf1..2d135eff7af2 100644
> > --- a/drivers/staging/wfx/key.h
> > +++ b/drivers/staging/wfx/key.h
> > @@ -17,4 +17,4 @@ int wfx_set_key(struct ieee80211_hw *hw, enum set_key=
_cmd cmd,
> >               struct ieee80211_vif *vif, struct ieee80211_sta *sta,
> >               struct ieee80211_key_conf *key);
> >
> > -#endif /* WFX_STA_H */
> > +#endif
[...]

--=20
J=E9r=F4me Pouiller


