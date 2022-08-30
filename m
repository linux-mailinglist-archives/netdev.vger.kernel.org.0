Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EF05A6215
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiH3Lhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiH3Lhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:37:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F182BF5CE2;
        Tue, 30 Aug 2022 04:36:03 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id a10so4315650qkl.13;
        Tue, 30 Aug 2022 04:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=t+R/8H1+D6PkifBzEZLGo3obwCZRygBKpW0t5nLQzgI=;
        b=WB19/tzLCc9OYHyYBrBBW0BeoEBlCigT8+6ePSd9j9yQkl6FwAyJAxc6zlSluGXIZR
         FltdZpyyGxcJR/1nAnsUPbPV9bhcQkoB/ooh5vEc8QCyi/0TW2ZkFKtv9i6mRyhcn2sQ
         1gScXFtNKPfHkM6PTPi8/UH/tC862rvGXFc6Xvn65EyxgB+5HsZY67VStr7McHHZRtFO
         hksVsu4Tu0r/sMU9QxJzIhIWFRl7YW9TXeqhFy9K9I+LpmwIFNus1K2E9QzdifNuOEDB
         BZrtHTavMetSrRhMk7KC7oP8AaOPVWY+qjwNlPyON/i2USQwGzdgD4BNqJxnQlE/K/KT
         GLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=t+R/8H1+D6PkifBzEZLGo3obwCZRygBKpW0t5nLQzgI=;
        b=rLsoz5SzbRKVFtq2C+MTYvvUgVLqH6a4h1wRRLDDuWnbQH/jj1ck2neY7ex/xWm9H8
         EdADuzqGcjfIMSm9ByqPFgiFH1lmDDTauFIDr1OIAjWoAdItiNlRT2k2/HB6Q+0twDSm
         e7q66eDhntTsEQt4O03N3rkA88+zrSWhX1Pxhri0C2Uu1+K2gf2/QoSQ5i6EEf7K96dy
         yUvQ3QvaNGw9Z2rpYgsHPNQvD/HssRX/PohLZuJXuj9ft1sq3/APltKl2hd04T77HX9j
         HFLsg8SQ5wAuPYKOFmYBQ+aWHd6YXsR0Fl23HvLhVyBlwfzJ2ftYVJMpvNjJAXu6EzSh
         oBgA==
X-Gm-Message-State: ACgBeo0A2DrLJ96sR2O8VuWMYGKkTV09Ozcoi2LeMbXnytZZGTmJfo9s
        jP3Cqx2AKbHRZOrQV1zapQo=
X-Google-Smtp-Source: AA6agR5Y8ZVzxmzDExFDhrRRK/J1flUuzG1hHeLJKLG1K/nrsN+OdsrMaM0o2SyYX6E+tTBsdWoGPw==
X-Received: by 2002:a05:620a:68f:b0:6be:5a7c:d61a with SMTP id f15-20020a05620a068f00b006be5a7cd61amr11542266qkh.519.1661859308921;
        Tue, 30 Aug 2022 04:35:08 -0700 (PDT)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id bs43-20020a05620a472b00b006bb619a6a85sm8102429qkb.48.2022.08.30.04.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 04:35:08 -0700 (PDT)
Message-ID: <72139841-f5ba-6fb8-8268-f59cee0a2bc2@gmail.com>
Date:   Tue, 30 Aug 2022 13:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 linux-next] wifi: brcmfmac: remove redundant err
 variable
Content-Language: en-US
To:     cgel.zte@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alsi@bang-olufsen.dk, a.fatoum@pengutronix.de,
        loic.poulain@linaro.org, quic_vjakkam@quicinc.com,
        prestwoj@gmail.com, colin.i.king@gmail.com, hdegoede@redhat.com,
        smoch@web.de, cui.jinpeng2@zte.com.cn,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
References: <20220830105016.287337-1-cui.jinpeng2@zte.com.cn>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <20220830105016.287337-1-cui.jinpeng2@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 12:50 PM, cgel.zte@gmail.com wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Return value from brcmf_fil_iovar_data_set() and
> brcmf_config_ap_mgmt_ie() directly instead of
> taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 7c72ea26a7d7..8a8c5a3bb2fb 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
[...]

> @@ -3997,10 +3996,8 @@ brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
>   	for (i = 0; i < npmk; i++)
>   		brcmf_dbg(CONN, "PMK[%d]: %pM\n", i, &pmk_list->pmk[i].bssid);
>   
> -	err = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
> +	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
>   				       sizeof(*pmk_list));

You should align the next line on the column after the opening brace. 
Using the checkpatch script should report this.

> -
> -	return err;
>   }
>   
>   static s32
