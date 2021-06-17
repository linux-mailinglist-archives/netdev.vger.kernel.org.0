Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE53ABC7C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhFQTUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhFQTUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:20:37 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1381C061574;
        Thu, 17 Jun 2021 12:18:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso5388286wmc.1;
        Thu, 17 Jun 2021 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G25iPlaj2HGTX4/c5/P02HpluiLJKUaToUtVn3p2XEU=;
        b=oAmGXcFGyeOAMdXRXsgNwuJK8YrgMHMqNbf/jUmBfo09nMs4tNOfpzEwrFBQTuDEoB
         2OzbF89eiKcCQFluqpTZxdF3MmLRxkP5tT9jr0JxSLb8jJJnzK/mrjzZGn5gPOf9Q3l5
         ypeuuUO/xtF36cJ+0tEFgFZQjw6kpYcfIEaspKDuZjo4HUsvK8tKt8Dk3xJryAo40moS
         sspmM+Q7d93o9rfmRBnA0BCM6NpsM9nofBLk5ompjot9iDYctYKXe9OYMpsDZO/7aJVn
         RK184oyaH/a7qwsN/5Y9JRy7BXgpAdrPpTsuAABTpSEAyCUA1Iru7C3wieFEEGiLhoz6
         lcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G25iPlaj2HGTX4/c5/P02HpluiLJKUaToUtVn3p2XEU=;
        b=gbi4+TKxPkESInvfEQaW+25Inh/+qwKiKCbpriwtdZ4R3JUFbVgGImseYnni8JAT48
         fSSXF7F86/IU27kQhq99EFc52cdse9Z57QIl/84RWf8Bpyjs7tn/JwIQzuZXrzicnLKj
         e6txQKXOw+kqT52wAurLIcSPgnPuvj4c9wJtH8PYfbdAQ4oDq6626JbJIrVxXsf4lJPl
         lXuiSnvDZPv/7C7Wh+IqNW+GYpFt0LDXv5Ly8b3cO0ZizcZuv/6aQ+3YO1qK0qVLJMuw
         FzlIdJ7CdqFnz7lIc6c3Ywe8jxUaiSdnbX4ltOEoybOavlojhiVEyb55/1BFbLyrPJl3
         erPw==
X-Gm-Message-State: AOAM533fYVPR0vSUDdKYQXJ1AgRJ7lXcktmH2eg5JcOVjDwrZ+2fMHe7
        PoqTwPnPKBr7HMDZ/6lMu9g=
X-Google-Smtp-Source: ABdhPJxD+RhPQTQ8UkShaehTZ5CaMDskeoT8/i9aZqxMLyXGYQXYXEoCFr7uSbC5Mg7664IMHGb18w==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr7174032wmj.119.1623957506595;
        Thu, 17 Jun 2021 12:18:26 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id s5sm6779320wrn.38.2021.06.17.12.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 12:18:25 -0700 (PDT)
Subject: Re: [PATCH] Bluetooth: fix a grammar mistake
To:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
References: <20210616082524.10754-1-13145886936@163.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <0e895cfb-21f0-70da-540b-72d6b5d06d8b@gmail.com>
Date:   Thu, 17 Jun 2021 20:18:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210616082524.10754-1-13145886936@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/06/2021 09:25, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix a grammar mistake.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/bluetooth/hci_event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 98ec486743ba..a33838a72f19 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -5780,7 +5780,7 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev,
>  			 * for unsupported remote feature gets returned.
>  			 *
>  			 * In this specific case, allow the connection to
> -			 * transition into connected state and mark it as
> +			 * transit into connected state and mark it as

Nack.  The original phrasing is correct; "transition" is the proper
 technical term for a change of state in a state machine.

-ed
