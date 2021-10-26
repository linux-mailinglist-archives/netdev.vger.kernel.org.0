Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E843AF25
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhJZJhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhJZJhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:37:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338EEC061745;
        Tue, 26 Oct 2021 02:34:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m42so13430362wms.2;
        Tue, 26 Oct 2021 02:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=pe5ItmrqZlQWe+ghkVLJnFdsnauuXZw4/ir5F3P/i6c=;
        b=bELRZxWKOhPIeulHBAJfhROm5Yvmgruhg7V8v28/Al9et0dX214LFCwgQfHGlP3oRS
         LdrAQhHARoNzzAOCGkEqA/aNUjMWjY9nT3kEZpyt4CzTkpgWth6cfQdi5jxsBxgMQ4I0
         cE2p3CqzGsQB2h8q43EqNF25mJZmykkNQgXriqtXILTELqOwsQY39AR3SNXWmRybfAeS
         hNcPu85X85+lcNjvxLVfgKBR6pOvSIsE0c8xqysYSdDLVCPuYh5lmhRdgBG9bLJ8KoR8
         jP5kiwQBURG7DikgtXpFF6N/P0pmpJ81ZLuXB50qvDuWL1pjVIUp976y0zFc9hw7ROvo
         Twdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=pe5ItmrqZlQWe+ghkVLJnFdsnauuXZw4/ir5F3P/i6c=;
        b=tCm3Chu295+acRQNf+5GaA8D/4VK//qH1vP/a+koiupi/B4HRedjQEVSJbOt7MXRos
         1X2I5ckGSZWKUDxkjkaEOdMHmdwfZSorMoYnLtyc+rmNP1eWtMAZTzarPxcTCMrvonjl
         clEjRki3j86kgyo/V3DjukI8Sts+4qqpC5CDRzghzrS8xfWFkh+ZeezCFZ1atQuXRXDA
         C2gRgOfAJdwz0gSd+03CtqjmvD10p/1mnOtNtV76AFSSvkkQ+TBvhVMExZjH1mwzDfkE
         KniXr+e+WHFZDS/7qjfxtL7Hp9Kg6de9IcPmXcJKB4rEjBHdzWuK+ZyGkluCEVtOQGKu
         H0IQ==
X-Gm-Message-State: AOAM530Rwcg7NBMl2e/eHsiVEbll+tRDb34A6rbNxk8otik0p9YY9lB7
        pJ2NCsFk+kEKrw==
X-Google-Smtp-Source: ABdhPJw0o9LbUcRUKEKv46C1/vUL7D+hbu2nfG6Rhg+nbB3edMts38NG4cYpb2vclIzsiaVtXQq3lA==
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr20452683wmi.11.1635240880702;
        Tue, 26 Oct 2021 02:34:40 -0700 (PDT)
Received: from [192.168.0.209] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id b8sm1403194wri.53.2021.10.26.02.34.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 02:34:40 -0700 (PDT)
From:   "Colin King (gmail)" <colin.i.king@googlemail.com>
X-Google-Original-From: "Colin King (gmail)" <colin.i.king@gmail.com>
Message-ID: <0ed0b3bd-05ab-d357-56a3-e2ce33169030@gmail.com>
Date:   Tue, 26 Oct 2021 10:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH][next] gve: Fix spelling mistake "droping" -> "dropping"
Content-Language: en-US
To:     Denis Kirjanov <dkirjanov@suse.de>,
        Colin Ian King <colin.i.king@googlemail.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211026092239.208781-1-colin.i.king@gmail.com>
 <a7155c22-c487-9a76-d3b3-628c0e27d3b0@suse.de>
In-Reply-To: <a7155c22-c487-9a76-d3b3-628c0e27d3b0@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 10:32, Denis Kirjanov wrote:
> 
> 
> 10/26/21 12:22 PM, Colin Ian King пишет:
>> There is a spelling mistake in a netdev_warn message. Fix it.
>>
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> 
> you could fix the second instance as well:

Will do. Thanks for noting that :-)

> 
> grep -nri droping drivers/net/
> drivers/net/wireless/mac80211_hwsim.c:1279:        /* Droping until 
> WARN_QUEUE level */
> drivers/net/ethernet/google/gve/gve_rx.c:441:                    "RX 
> fragment error: packet_buffer_size=%d, frag_size=%d, droping packet.",
> 
> 
>> ---
>>   drivers/net/ethernet/google/gve/gve_rx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c 
>> b/drivers/net/ethernet/google/gve/gve_rx.c
>> index c8500babbd1d..ef4aa6487c55 100644
>> --- a/drivers/net/ethernet/google/gve/gve_rx.c
>> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
>> @@ -438,7 +438,7 @@ static bool gve_rx_ctx_init(struct gve_rx_ctx 
>> *ctx, struct gve_rx_ring *rx)
>>           if (frag_size > rx->packet_buffer_size) {
>>               packet_size_error = true;
>>               netdev_warn(priv->dev,
>> -                    "RX fragment error: packet_buffer_size=%d, 
>> frag_size=%d, droping packet.",
>> +                    "RX fragment error: packet_buffer_size=%d, 
>> frag_size=%d, dropping packet.",
>>                       rx->packet_buffer_size, be16_to_cpu(desc->len));
>>           }
>>           page_info = &rx->data.page_info[idx];
>>

