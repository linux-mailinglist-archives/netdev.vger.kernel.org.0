Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6076A1B98F3
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgD0HsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:48:01 -0400
Received: from mail-co1nam11on2131.outbound.protection.outlook.com ([40.107.220.131]:62176
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725785AbgD0HsA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 03:48:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNkvYenzKno/TQgM6c50FyTcZ+LMjh+PBsFoMCtxL3wVhBrTC+TtjGadCIKra2ENQi6QyPm4EwoqT+6/n1iKqfMoTduUsvYZeHzwz2uj0L67T7jeY7rgfYIv1KEAkwI8e81TZsMEJLY67OgBlXCaikKph+CCegrbDNeGbmKMJGjSg8PnqrJn8P2RfKa68F3dvsG8DyL+B8jOTAY0JLJyodVyO+52EstYwtHPaF/ijOdSpdhniKygKhXKiw0mazx5IIU9gzBgMO2LmX/6PPhzR21J2UkUETh5+F5NNr5XBdrn9iugRiQD1M3pvfgi3TqEzWkLHM1oOkAk2uDTTFnRfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuKH0m6UzaZA6lGxBGjWasPhs9FvDqpHWeLqF5jf4B4=;
 b=hSaQx0bX1h6stKpfMUnS9qYDWaoaYXy7qDWTaJIQDuXKKvH2juqrfaSRD1kRfjhkwLEpQnpIv7cE2hIeDqYAPFsYdamxlUTyZ2YTGmoV+LyDzNfxZXfowys78FdKRHwjTQICBV4HmzGeR7PaHJgaewe9WOWOsoH6GsL3hglWrB/zChemzb/9Lmii6JCdL/4FwaLvVjuOnusCyNnz0bpz21M5ZDQ/PJBI4bYQs2nYjl8pj59XUTupUeeveGtQ/Zeu4egIOMgzpTPJsYMuEfsMPTbhNt2pH4oLSOrNfFVhJyrtYKMmf6NoAPu4N5YxxmbmCYNTPD4mKeB9fmYVIGEvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FuKH0m6UzaZA6lGxBGjWasPhs9FvDqpHWeLqF5jf4B4=;
 b=Rs6aQYAM+PvO5voam7ESwb7KVBophfxJPT3eN0LlL84rzgjYQAlttOLjGdiJQHKshV1XhWXlkQRNUiqINVYHchTsgl+gJiv23XAzCRQcAtd+FcMHeGELZ+2Eg/epDpFOBAcWSGaLtWlRrK4fRxOOGvm6pRjrpnqvTuUYmzCscio=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
Received: from BYAPR06MB4901.namprd06.prod.outlook.com (2603:10b6:a03:7a::30)
 by BYAPR06MB4598.namprd06.prod.outlook.com (2603:10b6:a03:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 07:47:56 +0000
Received: from BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::69bb:5671:e8b:74c1]) by BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::69bb:5671:e8b:74c1%3]) with mapi id 15.20.2937.023; Mon, 27 Apr 2020
 07:47:56 +0000
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH] brcmfmac: remove comparison to bool in brcmf_fws_attach()
To:     Jason Yan <yanaijie@huawei.com>, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200426094053.23132-1-yanaijie@huawei.com>
From:   Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <a49224fa-f645-53a4-d6ea-541758c7631c@cypress.com>
Date:   Mon, 27 Apr 2020 15:47:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
In-Reply-To: <20200426094053.23132-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:a03:114::30) To BYAPR06MB4901.namprd06.prod.outlook.com
 (2603:10b6:a03:7a::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.9.112.143] (61.222.14.99) by BYAPR21CA0020.namprd21.prod.outlook.com (2603:10b6:a03:114::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.4 via Frontend Transport; Mon, 27 Apr 2020 07:47:53 +0000
X-Originating-IP: [61.222.14.99]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df6252a3-c3eb-4b1d-d56a-08d7ea7f4c3b
X-MS-TrafficTypeDiagnostic: BYAPR06MB4598:|BYAPR06MB4598:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR06MB4598597BD73FB66B61738341BBAF0@BYAPR06MB4598.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR06MB4901.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(31696002)(3450700001)(7416002)(36756003)(86362001)(31686004)(2906002)(316002)(16576012)(66556008)(66946007)(8676002)(26005)(6486002)(81156014)(8936002)(478600001)(2616005)(956004)(66476007)(5660300002)(186003)(52116002)(16526019)(53546011)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pkZTy5+K5NeYiq72SVtkeAh3Wg2Ee8KRaEamSSffdp8PdVo0iF0Xm36SRd70e+50ryVuyYkzl01rPNzWtv0ZL6z7LDVaRG83GQrkoEquHOmR11oPOg9rcou8rZGFAoHn/8dxXtCOsqS4VjEXRCiti/lV/364zzg9/q45KsshO35So1PIB+q1ZQ8Arv+S9hSPSDbMOf+xfMGJfXR08WbboD5N8guO65My/TZ74YmEK+9YmBJN3hhzIv34sbXoYJnSFdSYH4KY3h+Ezu03apCTAUjQ5qk5O54ezJyd6GCEDaXmsyMlEoYPQD6h04IvfgUe4xDaNwDLvgIXlw4r/DC0GAy/bFUzeDOKbQhZGI0ObE9BA1FcJhuCgktJJQB0vZK8YZDo25Al0pzJN2Cf63ttCvwULBxiozauXpiwUlXBElpezQOP3PVwJNWWKq5k1hoSqAKWHYkVkk+HE4OQDXhv4JXZLgsSM2RH11c2wYAjaVM=
X-MS-Exchange-AntiSpam-MessageData: /gRGNRd+M6O+cgR4TcK+2HQn/V7nB3w5sq12xycO4Nj8WEt6E8ROB1SFu+T8SjgdOgsqGt2ykErySt/rlekP2Ho1QkFHAlJvnvvKpLvmKdWSEp9ZjUscFJxqaNWIRykaWqbbQIpOn2ftuIfZsinChrAPdpOEcwMbgjS9woQSM0ogxFu47ukUSfq8PzNsnvRSahjZgJQb5rvtOBWtnQ1AAfi+1JDB+vZNbU9+jqir8Lssts5o4qRcQLd6gwSigbzMIrPpsXOxwr7VtE3BW93ff/Kf39RWe3oHybKkISHInoWXJnihTSaZgNyROGySnaIykdUid6xRXfvrjkZU/jw4ObEoXu8xVGq7zfmxcAmC76GPkh7OZG5BlilHoyTRa48BO2F7RVnvrqSWVckADAouzV9UzKNwZXo4V3yoYrTpNGmwNMoFySry3khx0SmLZzxZK9uCkuiVuP5uFV7qWsz0Ag0f8ecyjbWby0T5Eb4bSwuHKFT7vIQXA1KntQlFbnOkyYl3IKEXpvCVnnoIEjdw7mqxb606R+LHDJJ1KPufafiCS7PRiHOnTtaT+gGVD2+sivkr9WFitbVkv7D8ZxtC409l4R3z4kA2kBsLVi7//+eCmSrOgcIvusdWr4OL3ohh0KtC/ove54qdGuYJFD2h/3ykSL1M5uxxh/UmstcY8sKpaAgAkgajCFmCvBdRUOZzH1RwgskOgVneh769ztC/1eoEPU1Xs0fdOOIcqX541yLxseNARfyBX28k5AAEJx49ujK4/elbHEzC6RMNT7Cxm6h6xZtJiV1njZcoLZEFe80=
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6252a3-c3eb-4b1d-d56a-08d7ea7f4c3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 07:47:56.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKNP4RYb1k+EhrBTBQjPBe3kOQyyiGXV+Tew8dHuxVLDVVEkkbePNTeMXnpAAYdFuCkXXIwJh7XsGUejCaFcmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB4598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/26/2020 5:40, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:2359:6-40:
> WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> index 8cc52935fd41..2b7837887c0b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> @@ -2356,7 +2356,7 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
>   	fws->drvr = drvr;
>   	fws->fcmode = drvr->settings->fcmode;
>   
> -	if ((drvr->bus_if->always_use_fws_queue == false) &&
> +	if (!drvr->bus_if->always_use_fws_queue &&
>   	    (fws->fcmode == BRCMF_FWS_FCMODE_NONE)) {
>   		fws->avoid_queueing = true;
>   		brcmf_dbg(INFO, "FWS queueing will be avoided\n");
> 
