Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7451CB087
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgEHNcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:32:11 -0400
Received: from mail-dm6nam10on2094.outbound.protection.outlook.com ([40.107.93.94]:62592
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727903AbgEHNcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 09:32:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCq1REoD0dqdJzs66IoWxoZWSsVE4IsvO2K4+3bzkmti4zCSnWcNDVQ+jw2CMJ/fysfdiv3lDVCOh9imPZICQiHlckOLBDypWuguPQ/nwmL6srMlihcjIKwq7LMqVqHZONSwrZqoKQ2QIP+D55yuawxIY+LJL+q8aSn7MwV5hpqQonno2+orFg4dwrWygXRD6ADuiboo3A2VedmTKd+fPGDTHOzy56rKtgSJawebmn0/L+zsedOp+gdWcS4ONqaFOkuLjOeaOorikaUJ1rbXIyK4umyOmJDYH964xKJXrIO8Ndt5/uxdID07C2Q4nJISMktpjOpm3AwNgGZnY3QzcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WehEWW/hpb2u4FIzNu5NTywIbhQT4Io15URZdhZYMxc=;
 b=CiCPpwSIZdd0U01CTnGadILYMLy1Qa8AuspT3mD4GrVuRPlQZoV6Xci0eUNPIHH2xNTpor96iXFdFwvanTayefXXdZUBoWbHNsF/o8HpwTtJZKMylGt6W0rx4g9ECk/T6NBtWkfYODY3NtgAkio+7aLk3yJAFgtMXBmjU2/XZ4WlK9d5GfNsmgOSnbpoNUpfdRsNthSbZ5K9wBTDgR1GGi8xvuUaGz2/yAM0a4Rfslp5+rf20W5S+x+SKAklGZpwYbMo8Npm41wv5NlpKO+fQwIwRmoClBdf79uak1SyrhRPysuaM/7meoWw+DK8SjuWZXFt8foM+Q+xAG9sOd6a3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WehEWW/hpb2u4FIzNu5NTywIbhQT4Io15URZdhZYMxc=;
 b=AUUUYFUnFAMs04tqpCquJg+4k8gtO57vIoSYIgEzswJTSDexNC8KDlNdTi4oMSVEdUirxwbM277qfd6alNuuA2/6K3TW7997k8sB6CPg1X12+gMBe8BRDwB7TcR2Oq+sQLU5By0ZxPEvKe3RpMbX8R7PA1vi5G8HJQOLEJw6plU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cypress.com;
Received: from DM6PR06MB4748.namprd06.prod.outlook.com (2603:10b6:5:fd::18) by
 DM6PR06MB5324.namprd06.prod.outlook.com (2603:10b6:5:102::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Fri, 8 May 2020 13:32:07 +0000
Received: from DM6PR06MB4748.namprd06.prod.outlook.com
 ([fe80::85fb:1c0e:ce17:e7bb]) by DM6PR06MB4748.namprd06.prod.outlook.com
 ([fe80::85fb:1c0e:ce17:e7bb%7]) with mapi id 15.20.2979.033; Fri, 8 May 2020
 13:32:07 +0000
Subject: Re: [PATCH -next] brcmfmac: make non-global functions static
To:     Chen Zhou <chenzhou10@huawei.com>, kvalo@codeaurora.org
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200508013249.95196-1-chenzhou10@huawei.com>
From:   Wright Feng <wright.feng@cypress.com>
Message-ID: <97fd043c-bf60-b2c3-b901-f57d7fa957be@cypress.com>
Date:   Fri, 8 May 2020 21:31:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200508013249.95196-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCPR01CA0024.jpnprd01.prod.outlook.com (2603:1096:405::36)
 To DM6PR06MB4748.namprd06.prod.outlook.com (2603:10b6:5:fd::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.236] (123.194.189.67) by TYCPR01CA0024.jpnprd01.prod.outlook.com (2603:1096:405::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Fri, 8 May 2020 13:32:04 +0000
X-Originating-IP: [123.194.189.67]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77ed7be4-df52-4534-9aef-08d7f35433f0
X-MS-TrafficTypeDiagnostic: DM6PR06MB5324:|DM6PR06MB5324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR06MB53249F79DD595D7A9B568122FBA20@DM6PR06MB5324.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mtlaQU/712NAMs7rFQj2AwBVIiHBgmcQDWiKa6Mz7C4ADgQX4LUdfM0eWmF2mWszKPUBwvE5+lYa1z1IVPMNH5Nq4u2RattLLBECH39LRbOrjKS7tuIuZVbI2yalhYFRHSrFH61AyFAMOfmPsxaDqo5g4nZGPn4xs+UeiGaNMPIozxpoBb1BjQf4tvPVKvWXwVp5bQZOXqiV8mz/B7Qdhd5qpJm1MfbmSuCMY9eJbsczeyd0wagfRgQxlrtjo2NSLTDU+It0S/faBccCPhFSNr4DXEqBK/LghBKqNI+SYkWPU55RSYD0zdDUaM9yTzY6rSylW7bhOpv3xh6H/JJlTDvQqFd3gwpEmHYGv11DYKf7a37y1C0N1HNqqp1v+qI3WnjvtRXjhEF9EKYvW5VI6UBVluXIjeAt+cioEnPl2m3uwfP/YUdueQrNJBELVKuEnqh5809Q7ShsAprGZ1S9ORHnQndnQMbehnd88Dxm7CWGLKb/FVVtHrpn/xY5tHkwo1v4/eiFbwuoJIM95xa6r59tGPglUXG/GirSolT3QsMwY4PiAisHIz/aBewfssYr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR06MB4748.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(33430700001)(16576012)(186003)(4326008)(6486002)(6666004)(8676002)(44832011)(2906002)(31686004)(8936002)(52116002)(86362001)(33440700001)(16526019)(956004)(478600001)(36756003)(83280400001)(83310400001)(2616005)(83320400001)(83290400001)(66946007)(66476007)(316002)(5660300002)(31696002)(66556008)(83300400001)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hc2xKokofronD1DcGXPAvROCpufA/EF9FbdZoPm4ftTAitbW/Omu30NixyzsqjuxiGxxWgmA8yYht4zAqXWBU6dbcv4xmFjDS829j3B+mNguRFidNL2H71pdG5oR7VIvwe/flGD3Gf7M7VpNaIORMx3Ljfui/fTrZPLv1GYeD6coOhiXzkGhunl5WCQy9+/+Izscj9Ugek5BCaT6EPFde55oi5gw/EwKmPTu5V3jHYrCTnTocA8B8rKibDvB0lFRBweHccnoNs93XsVWBl7pQuhCi442jlZAMtCRMwfo+eTjDGo8gm4Z+djNwloTnplZ8Xz0Ww1/P1iFt01uAi1yWwXf1GjBtjCU3vfFrG5D2hZJn2TmQuwvpHqImPP1d6Jm9uPnDsR3mCd1tVV1WRWpxzXJbZl/BovDQI0s7gEIQI0BVkg5T++Z5/5CR+BlwQ272N3ZJQTIlw60km4VRMU0cOQ+dA+P8X9+uolAbjrNcioDDWfQSWoW2MXngMjJRwSU
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ed7be4-df52-4534-9aef-08d7f35433f0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 13:32:07.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVoVeP0TSQDJzV16oXyo9kGfLVgPbTw1aFooVqcXPT0K6FI4EyFWKH+YfPt56aMUWddq/SinNHEahN8RdxiViw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Chen Zhou 於 5/8/2020 9:32 AM 寫道:
> Fix sparse warning:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:2206:5:
> 	warning: symbol 'brcmf_p2p_get_conn_idx' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Wright Feng <wright.feng@cypress.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index e32c24a2670d..2a2440031357 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2203,7 +2203,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
>   	return ERR_PTR(err);
>   }
>   
> -int brcmf_p2p_get_conn_idx(struct brcmf_cfg80211_info *cfg)
> +static int brcmf_p2p_get_conn_idx(struct brcmf_cfg80211_info *cfg)
>   {
>   	int i;
>   	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
> 
