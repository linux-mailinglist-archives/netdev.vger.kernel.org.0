Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7963C1D3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiK2OGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiK2OGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:06:20 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D77E1BE98;
        Tue, 29 Nov 2022 06:06:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s5so19862917edc.12;
        Tue, 29 Nov 2022 06:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hmL1fhnE+p0KsqeCxjrzRVw7wn8P8LkuAKnfVeGOj2A=;
        b=XTCemeXiOGKnvNbckv1301QKX5bIDcDqtA3c6/YSlrGtZU4X2mO+InaTAgY85JI2gY
         S/0E8Q919zpvoGBoXNdhdWLEKEsexc1o7MgLGyhZzyr70UgcDWaCmlFDSzoHY7uwsE2H
         n/shoVz9Hb5kw6B/F7ebZsE2nqqeokFQ1XBUC2AYZgQZDSVeZDCmPC6NPqSF79BlHWoJ
         ugUXUyTlBU4YJDTH7LEIWU2ImQ4Qr6KyVjMfNjG/Zlb1UcLXm1d69ssjE7cUf9LrWuvW
         2GRWB5XqHnn0DdNLgkd2ZEtDue4ZwNMIOkJdIbOh8WVYKv381C0Km7Q9lRVxRYbp1OYS
         dvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmL1fhnE+p0KsqeCxjrzRVw7wn8P8LkuAKnfVeGOj2A=;
        b=420hhEGDGWDQBQMYmH8i4sbCZ6YNB9aHsQJb2ty1rWo9E4BOk9PQs+TaNZW4Em3JIM
         uv+D9GDKB/E6wBGoT+DW3ks3TCzKWoPgPijfbbA+rU5PgLI7RT1VTyFs1O0M+S7BxZ6W
         mV9lhemXcqaUdUlp4ZKstboo5VLwPaeSReJTmNxEiekbp5JnkyHWx/pkagTXW6maSbgk
         kSp0h37wRijd09gld28DncBAHKgRAGxCG7sTGhCUcm/ql4JjkteWQGXn3HvkyAItjKHC
         w03ARuJas0MTNOQDOChGN02KvaR3ukmccUIuj77xE6jbhm+eqqdlm9eWEJNG6HYB+QWn
         5J5g==
X-Gm-Message-State: ANoB5plI/zBrZ6UQGzBngmEfMBkW6/5evlvkRK7Dt1rdeZ9axvTcgBU8
        E65qEdkVzVMCrmatQ3mxAnc7t40Umjc=
X-Google-Smtp-Source: AA0mqf4mqg2EnXkZYNbhUKsGXY1BBZ8UyLKrBdk7L8KZf9rRCNM8akxAQtU/E/o8MQc2qP6fu06aQQ==
X-Received: by 2002:a05:6402:120c:b0:46b:86:20b5 with SMTP id c12-20020a056402120c00b0046b008620b5mr12645010edw.130.1669730776585;
        Tue, 29 Nov 2022 06:06:16 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.254])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00741a251d9e8sm6193645ejg.171.2022.11.29.06.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 06:06:16 -0800 (PST)
Message-ID: <9dc328a1-1d76-6b8b-041e-d20479f4ff56@gmail.com>
Date:   Tue, 29 Nov 2022 16:06:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drivers: rewrite and remove a superfluous parameter.
To:     JunASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
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

On 29/11/2022 06:34, JunASAKA wrote:
> I noticed there is a superfluous "*hdr" parameter in rtl8xxxu module
> when I am trying to fix some bugs for the rtl8192eu wifi dongle. This
> parameter can be removed and then gained from the skb object to make the
> function more beautiful.
> 
> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index ac641a56efb0..4c3d97e8e51f 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4767,9 +4767,10 @@ static u32 rtl8xxxu_80211_to_rtl_queue(u32 queue)
>  	return rtlqueue;
>  }
>  
> -static u32 rtl8xxxu_queue_select(struct ieee80211_hdr *hdr, struct sk_buff *skb)
> +static u32 rtl8xxxu_queue_select(struct sk_buff *skb)
>  {
>  	u32 queue;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>  
>  	if (ieee80211_is_mgmt(hdr->frame_control))
>  		queue = TXDESC_QUEUE_MGNT;
> @@ -5118,7 +5119,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
>  	if (control && control->sta)
>  		sta = control->sta;
>  
> -	queue = rtl8xxxu_queue_select(hdr, skb);
> +	queue = rtl8xxxu_queue_select(skb);
>  
>  	tx_desc = skb_push(skb, tx_desc_size);
>  

See the recent discussion about this here:
https://lore.kernel.org/linux-wireless/acd30174-4541-7343-e49a-badd199f4151@gmail.com/
https://lore.kernel.org/linux-wireless/2af44c28-1c12-46b9-85b9-011560bf7f7e@gmail.com/

Any luck with the bugs?
