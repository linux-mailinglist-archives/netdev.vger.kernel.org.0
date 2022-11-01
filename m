Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D28614469
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 06:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKAFta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 01:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAFt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 01:49:29 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93B513EA8;
        Mon, 31 Oct 2022 22:49:28 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so2809389wmb.2;
        Mon, 31 Oct 2022 22:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFiJ1Xl5U/Q9kIWUJyg3ATXUzyGX+xpzIsnQgrcyPqQ=;
        b=tFK9mkK3gniaO/JeNjMrTt49uv1LYAZio5vps3JcglvunpbpkZJRwoMkxBPOM9f5Vt
         knwt82eTLzuL6FFmdFLk8u1n0JlAfFPVyVff5AcDvsoChBsPtXtahDg14Mfstmge61uv
         7QPqj5400eNwmXRoyIf0JAgMW6niJuw+NCTABoakPiNuzd5UWzHzXZMiPQMusy101Heo
         RmU7P3g6ovkpH2nxCGTE9t1gD7anCqMHZxNqXOw2Ylf6FInUTKhV2CeCcf5gkR2DPAYO
         nTuE40iaRxs390/zOgRpdj6CL+cAiNBKHJWydEWSDKe5f+keDCAiHwdOUzT4Z5x/JZ9Z
         hWlw==
X-Gm-Message-State: ACrzQf2ylfK4j2TM6eRcVk5Ihfpske4O4DvFlpwV2Xr/fFFbnePdPynh
        yzyGPQIAxnnCLwI4nYzF6iA=
X-Google-Smtp-Source: AMsMyM78+gzC+G4r0hw11WY5fFkvvC3bal3WJWhhwtOLtGcIGj1F43LHVUwke1fflbbAJ+GtTzEUyQ==
X-Received: by 2002:a05:600c:3b1a:b0:3c7:132f:eb7f with SMTP id m26-20020a05600c3b1a00b003c7132feb7fmr20478963wms.49.1667281767330;
        Mon, 31 Oct 2022 22:49:27 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id y2-20020adffa42000000b0022e3538d305sm10350826wrr.117.2022.10.31.22.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 22:49:26 -0700 (PDT)
Message-ID: <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org>
Date:   Tue, 1 Nov 2022 06:49:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>, kvalo@kernel.org
Cc:     linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20221031114341.10377-1-jirislaby@kernel.org>
 <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31. 10. 22, 22:16, Jeff Johnson wrote:
> On 10/31/2022 4:43 AM, Jiri Slaby (SUSE) wrote:
>> ath11k_mac_he_gi_to_nl80211_he_gi() generates a valid warning with 
>> gcc-13:
>>    drivers/net/wireless/ath/ath11k/mac.c:321:20: error: conflicting 
>> types for 'ath11k_mac_he_gi_to_nl80211_he_gi' due to enum/integer 
>> mismatch; have 'enum nl80211_he_gi(u8)'
>>    drivers/net/wireless/ath/ath11k/mac.h:166:5: note: previous 
>> declaration of 'ath11k_mac_he_gi_to_nl80211_he_gi' with type 'u32(u8)'
>>
>> I.e. the type of the return value ath11k_mac_he_gi_to_nl80211_he_gi() in
>> the declaration is u32, while the definition spells enum nl80211_he_gi.
>> Synchronize them to the latter.
>>
>> Cc: Martin Liska <mliska@suse.cz>
>> Cc: Kalle Valo <kvalo@kernel.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: ath11k@lists.infradead.org
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
> 
> Suggest the subject should be
> wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type

FWIW I copied from:
$ git log --format=%s  drivers/net/wireless/ath/ath11k/mac.h
ath11k: Handle keepalive during WoWLAN suspend and resume
ath11k: reduce the wait time of 11d scan and hw scan while add interface
ath11k: Add basic WoW functionalities
ath11k: add support for hardware rfkill for QCA6390
ath11k: report tx bitrate for iw wlan station dump
ath11k: add 11d scan offload support
ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
ath11k: add support for BSS color change
ath11k: add support for 80P80 and 160 MHz bandwidth
ath11k: Add support for STA to handle beacon miss
ath11k: add support to configure spatial reuse parameter set
ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references
ath11k: Perform per-msdu rx processing
ath11k: fix incorrect peer stats counters update
ath11k: Move mac80211 hw allocation before wmi_init command
ath11k: fix missed bw conversion in tx completion
ath11k: driver for Qualcomm IEEE 802.11ax devices

> The reference to gcc in the description should be sufficient.
> 
> Kalle can update this when he merges

OK, thanks.

> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> 
>> ---
>>   drivers/net/wireless/ath/ath11k/mac.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/mac.h 
>> b/drivers/net/wireless/ath/ath11k/mac.h
>> index 2a0d3afb0c99..0231783ad754 100644
>> --- a/drivers/net/wireless/ath/ath11k/mac.h
>> +++ b/drivers/net/wireless/ath/ath11k/mac.h
>> @@ -163,7 +163,7 @@ void ath11k_mac_drain_tx(struct ath11k *ar);
>>   void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
>>   int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
>>   u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
>> -u32 ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
>> +enum nl80211_he_gi ath11k_mac_he_gi_to_nl80211_he_gi(u8 sgi);
>>   enum nl80211_he_ru_alloc 
>> ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy);
>>   enum nl80211_he_ru_alloc 
>> ath11k_mac_he_ru_tones_to_nl80211_he_ru_alloc(u16 ru_tones);
>>   enum ath11k_supported_bw ath11k_mac_mac80211_bw_to_ath11k_bw(enum 
>> rate_info_bw bw);
> 

-- 
js
suse labs

