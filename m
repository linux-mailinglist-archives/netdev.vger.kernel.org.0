Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90CC644BF1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiLFSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLFSkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:40:47 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A830F4C;
        Tue,  6 Dec 2022 10:40:44 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d1so24757187wrs.12;
        Tue, 06 Dec 2022 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jC9GDyGbPYsUpaA1vd85seN1hS5MLlrIfa/P+yli9b8=;
        b=EcogxmYpd/Pu16hs6PJNVrTMNv6QNhPa9CdJr84SHIEjpyPobvWDb2SiYlk4ae29aS
         Emae6QO0/zV4BNAEHPZrN4bt71mZWjSA2MCP7Z4bG15hLhViXAptUHu4X6Ge1VeyaPsC
         6M8HSXQooWHvho/TVVozvC0Fv/QrBKnwqUEx9KWGr0l8ssSXT/5QPSkLivW+ZZqa0Six
         JYhupWD+2Fx0t5y2048eMIQrfgVS3l2SJwUksSkMayyIRcadvIOtw8v2yAo3A7SZbYs8
         gfJHfQKPRNiCxmnLa6EGlF1NX2ahafhUPVBpfvfZd0RuXiQPZfXSl+YT6JQENso38A9o
         sEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jC9GDyGbPYsUpaA1vd85seN1hS5MLlrIfa/P+yli9b8=;
        b=jQcjaMZ3MM1icDdJOW+7Ej7/xYcz+REcFZskLClOrlBrGjmC/pMWS3jROkyvSfxMFw
         W3TsgmLh5ngkiRRteC5w0SXhEYL6ITk0ZLLMOom/3j7JMTjdDkjv3SGbc6MWwbjB6QPq
         s9EQabL/H5AzNHiZzbT1PgpPNuTRMgjrqXp/5sqhjeySvrOhjTKKZ6f/KCAGAyJZBaAJ
         BLbl4dSTNgJGVzpjaLpN9/qjmw2gZKQ0p6Rwg7gWxXVdYIcBl4unLChbw+Kgkho0IJrX
         9gOQBwvHDNXgEMoyztMcrG6ILUR8+S/2VgZ2KirDQNYkO8hokIoG+zwIOw2Vx2bBH/hN
         F63w==
X-Gm-Message-State: ANoB5pnKMKzrJT0ZmewqIU33agywFPXyPF3OPYpAAqPiEEZgVtbgJkzH
        jO90nSMLcidMOxoK/d5T3PI=
X-Google-Smtp-Source: AA0mqf7qfkCOK+SDCnsG4JqjH2FqBPUZS3idNcfuEbfo6t9dEgt+C3XW6U5WvxMMYR7merp+tlOMlA==
X-Received: by 2002:adf:de08:0:b0:242:1d2c:9d78 with SMTP id b8-20020adfde08000000b002421d2c9d78mr23507497wrm.490.1670352042744;
        Tue, 06 Dec 2022 10:40:42 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.254])
        by smtp.gmail.com with ESMTPSA id t5-20020a5d5345000000b0022cc3e67fc5sm17135332wrv.65.2022.12.06.10.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:40:42 -0800 (PST)
Message-ID: <312341d3-67b5-3de7-e4a7-ee94191c15b0@gmail.com>
Date:   Tue, 6 Dec 2022 20:40:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drivers: rewrite and remove a superfluous parameter.
Content-Language: en-US
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        JunASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
 <9dc328a1-1d76-6b8b-041e-d20479f4ff56@gmail.com>
 <184e897cf70.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <184e8aa3278.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <184e8aa3278.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2022 20:19, Arend Van Spriel wrote:
> On December 6, 2022 6:59:36 PM Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
>> On November 29, 2022 3:06:37 PM Bitterblue Smith <rtl8821cerfe2@gmail.com>
>> wrote:
>>
>>> On 29/11/2022 06:34, JunASAKA wrote:
>>>> I noticed there is a superfluous "*hdr" parameter in rtl8xxxu module
>>>> when I am trying to fix some bugs for the rtl8192eu wifi dongle. This
>>>> parameter can be removed and then gained from the skb object to make the
>>>> function more beautiful.
>>>>
>>>> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
>>>> ---
>>>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++--
>>>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>>> index ac641a56efb0..4c3d97e8e51f 100644
>>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>>> @@ -4767,9 +4767,10 @@ static u32 rtl8xxxu_80211_to_rtl_queue(u32 queue)
>>>> return rtlqueue;
>>>> }
>>>>
>>>> -static u32 rtl8xxxu_queue_select(struct ieee80211_hdr *hdr, struct sk_buff
>>>> *skb)
>>>> +static u32 rtl8xxxu_queue_select(struct sk_buff *skb)
>>>> {
>>>> u32 queue;
>>>> + struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>>>
>>>> if (ieee80211_is_mgmt(hdr->frame_control))
>>>> queue = TXDESC_QUEUE_MGNT;
>>>> @@ -5118,7 +5119,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
>>>> if (control && control->sta)
>>>> sta = control->sta;
>>>>
>>>> - queue = rtl8xxxu_queue_select(hdr, skb);
>>>> + queue = rtl8xxxu_queue_select(skb);
>>>>
>>>> tx_desc = skb_push(skb, tx_desc_size);
>>>
>>> See the recent discussion about this here:
>>> https://lore.kernel.org/linux-wireless/acd30174-4541-7343-e49a-badd199f4151@gmail.com/
>>> https://lore.kernel.org/linux-wireless/2af44c28-1c12-46b9-85b9-011560bf7f7e@gmail.com/
>>
>> Not sure why I looked but I did. You may want to look at rtl8xxxu_tx()
>> which is the .tx callback that mac80211 uses and the first statement in
>> there is also assuming skb->data points to the 802.11 header.
> 
> Here the documentation of the .tx callback:
> 
> @tx: Handler that 802.11 module calls for each transmitted frame.
> * skb contains the buffer *starting from the IEEE 802.11 header*.
> * The low-level driver should send the frame out based on
> * configuration in the TX control data. This handler should,
> * preferably, never fail and stop queues appropriately.
> * Must be atomic.
> 
> I don't see any pushes or pulls before the queue select so that would mean mac80211 is not complying to the described behavior.
> 
> Regards,
> Arend
> 
>>
>> Regards,
>> Arend
>>>
> 
> 
> 
mac80211 is behaving as described in the documentation, as far as I know.
Technically, rtl8xxxu_queue_select's hdr parameter is not needed.
