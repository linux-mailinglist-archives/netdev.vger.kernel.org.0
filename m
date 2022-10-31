Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEF0613FC6
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 22:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJaVRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 17:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJaVRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 17:17:15 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4098E13CD4;
        Mon, 31 Oct 2022 14:17:14 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 29VL74A2020997;
        Mon, 31 Oct 2022 21:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=xEQOZoeQz+d79gocLoLfDMdECpn1lTupjLfLjzlXF4A=;
 b=KBWk26G3AiJJRu3ZtwxD3fLBUOogsRhKmez992ZXJgN7G1TRxU/axB2kO4405OUi1CQc
 ixB4ohXyYS6+VMANFgOSH6mSpy5sqUxUmVlOU65s39rTkfOxAc/axWiJYepHTxu9oX4P
 69mL23AnJ2Za47Nzw9sj3FrdITWH+MjGwEPC2FAaUMIlWBz9yRoXkV/BT/UXwHixpB+3
 SAf48od7hWCxbY/GfNy8Y+MtdLj4AZZcXMg0m2zP0mmDTr69X6XAkp88alf8l8FzQ2MA
 MzmrddmAb4kCuzSH/cL1ekcWsRTx+Gz0F/XfE10Gl1taT7KNdc0fIMfgZY1bhEx20bme xg== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kjj148tst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 21:17:00 +0000
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 29VLGxkk000771;
        Mon, 31 Oct 2022 21:16:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 3khdpm6d0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 21:16:59 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29VLGxO3000760;
        Mon, 31 Oct 2022 21:16:59 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 29VLGx1U000759
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Oct 2022 21:16:59 +0000
Received: from [10.110.19.51] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 31 Oct
 2022 14:16:58 -0700
Message-ID: <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
Date:   Mon, 31 Oct 2022 14:16:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
Content-Language: en-US
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>, <kvalo@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20221031114341.10377-1-jirislaby@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20221031114341.10377-1-jirislaby@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: D3seMyoJ8ZICL02O27qI9D3IV_24DjZK
X-Proofpoint-GUID: D3seMyoJ8ZICL02O27qI9D3IV_24DjZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_21,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=939 impostorscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/2022 4:43 AM, Jiri Slaby (SUSE) wrote:
> ath11k_mac_he_gi_to_nl80211_he_gi() generates a valid warning with gcc-13:
>    drivers/net/wireless/ath/ath11k/mac.c:321:20: error: conflicting types for 'ath11k_mac_he_gi_to_nl80211_he_gi' due to enum/integer mismatch; have 'enum nl80211_he_gi(u8)'
>    drivers/net/wireless/ath/ath11k/mac.h:166:5: note: previous declaration of 'ath11k_mac_he_gi_to_nl80211_he_gi' with type 'u32(u8)'
> 
> I.e. the type of the return value ath11k_mac_he_gi_to_nl80211_he_gi() in
> the declaration is u32, while the definition spells enum nl80211_he_gi.
> Synchronize them to the latter.
> 
> Cc: Martin Liska <mliska@suse.cz>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: ath11k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>

Suggest the subject should be
wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type

The reference to gcc in the description should be sufficient.

Kalle can update this when he merges

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

> ---
>   drivers/net/wireless/ath/ath11k/mac.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
> index 2a0d3afb0c99..0231783ad754 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.h
> +++ b/drivers/net/wireless/ath/ath11k/mac.h
> @@ -163,7 +163,7 @@ void ath11k_mac_drain_tx(struct ath11k *ar);
>   void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
>   int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
>   u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
> -u32 ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
> +enum nl80211_he_gi ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
>   enum nl80211_he_ru_alloc ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy);
>   enum nl80211_he_ru_alloc ath11k_mac_he_ru_tones_to_nl80211_he_ru_alloc(u16 ru_tones);
>   enum ath11k_supported_bw ath11k_mac_mac80211_bw_to_ath11k_bw(enum rate_info_bw bw);

