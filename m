Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD4E5F4BCB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiJDWYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 18:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiJDWYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 18:24:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3E16CD0C;
        Tue,  4 Oct 2022 15:24:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w2so14337718pfb.0;
        Tue, 04 Oct 2022 15:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date;
        bh=evX17P0ZnVSXMvE7sJV+TWeehCTXdrdFotLZXAQP8zc=;
        b=XAI16xB1zMqR24QuiyjNiY/oNbIbAKqVWvUmgmlhlwVqEc+QdpTx7CoxFuL8qB/qwA
         oRSHxz1bWTwFRAXIoRhJpZ7RUk5wlYU1PpsIryxg8LRpMI1zC229kh3RLGRQAwd5Boso
         tlJdj0MacbcR+TL2TF9ErJ7Q4Q80m6gKNjCrzZyXaaszWI167naGAJlFXtJ8MC1mvpcX
         Mpzci273Lvu3/uD/RKEVlGHx5JzFRl3Y3jCEKtlDNP0bH/nSxX91eUCjQWvNCDJQG2Yq
         wuNCSmQey6/hcikUXAwrABxFvTFhGiTOlBeWvKHYqqDIP0Ui3R4os8+8k8ZkinaLh9d2
         Hf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=evX17P0ZnVSXMvE7sJV+TWeehCTXdrdFotLZXAQP8zc=;
        b=efnR/l/O23QeeymhtqlW/JEaERI7rDyeQGqWrwwkuS5jj8hmK25/rk7+TU4gr67mt/
         oTe6Kejovc5cWlYeTN3sMdit35WLIH0JwVyTdc6FQxmHgHSk6qsV6g/EjtFvK9byFyOO
         rvdkcN+CMVcdHpvWkakPwjZ++t13mhHYHJHggCFOSN7a8TuXRirh044d5uQQ9mUyDmsR
         WHRxk2OgzM6MFrbfIZWXBbwO3Oexx/KPhPmr6cUjZocu/BIQDbc0ByrQkIcGgkXoYH7A
         fp8dC5NmRkMKBDkg2RADLG47GgLQTNxRi/TvWld5RySc1//Hl+LLr+1vM3hjX/Wobbu4
         8HLQ==
X-Gm-Message-State: ACrzQf1U5R+ovz6ch4MG7KOUH1uWJspvIdShip4ANOS5DTPHZpc+nSfX
        0Y0gydwoPPx2zade2LBNMGmBf2vhJ54=
X-Google-Smtp-Source: AMsMyM712xMX47z4gMFRnbV+NaUL9BOvGyOK6ldgENZpKlUJeiLq14wh31jz5rD0vCF3uivRpfc3OQ==
X-Received: by 2002:a62:ee0c:0:b0:558:5c4:97dc with SMTP id e12-20020a62ee0c000000b0055805c497dcmr29537271pfi.14.1664922242751;
        Tue, 04 Oct 2022 15:24:02 -0700 (PDT)
Received: from [192.168.11.9] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b00179e1f08634sm9272873plk.222.2022.10.04.15.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:24:02 -0700 (PDT)
Message-ID: <57f68fef-8a45-184d-4536-52b94fcc9c03@gmail.com>
Date:   Wed, 5 Oct 2022 07:23:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221004072646.64ad2c8c@kernel.org>
Subject: Re: doc warnings in *80211
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <20221004072646.64ad2c8c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Date: Tue, 4 Oct 2022 07:26:46 -0700, Jakub Kicinski wrote:
> On Tue, 04 Oct 2022 09:51:07 +0200 Johannes Berg wrote:
>> > doing basic sanity checks before submitting the net-next PR I spotted
>> > that we have these warnings when building documentation on net-next:
>> > 
>> > Documentation/driver-api/80211/cfg80211:48: ./include/net/cfg80211.h:6960: WARNING: Duplicate C declaration, also defined at driver-api/80211/cfg80211:6924.
>> > Declaration is '.. c:function:: void cfg80211_rx_assoc_resp (struct net_device *dev, struct cfg80211_rx_assoc_resp *data)'.  
>> 
>> Hmm. That's interesting. I guess it cannot distinguish between the type
>> of identifier?
>> 
>> struct cfg80211_rx_assoc_resp vs. cfg80211_rx_assoc_resp()
>> 
>> Not sure what do about it - rename one of them?
>> 
>> > Documentation/driver-api/80211/mac80211:109: ./include/net/mac80211.h:5046: WARNING: Duplicate C declaration, also defined at driver-api/80211/mac80211:1065.
>> > Declaration is '.. c:function:: void ieee80211_tx_status (struct ieee80211_hw *hw, struct sk_buff *skb)'.  
>> 
>> Same here actually!
>> 
>> I don't think either of these is new.
> 
> Thanks for checking!
> 
> Adding linux-doc, but I presume Jon & co are aware if this is not new.

Yes, this is a known issue of Sphinx >=3.0, which prevents us to
bump required version of Sphinx from 2.4.x.

Link to a relevant mail from Mauro in the lore archive:

  https://lore.kernel.org/r/20220702122311.358c0219@sal.lan/

Note that the same warnings can be seen when a kernel-doc comment is
included from multiple .rst files under Documentation/ by accident.

Actually, Sphinx < 3.0 can not detect such true duplicates.

As far as I see, this issue still remains in the latest version of
Sphinx (5.2.3).

HTH,
Akira


