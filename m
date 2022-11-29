Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4109A63C364
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiK2PQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiK2PQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:16:53 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2382F384;
        Tue, 29 Nov 2022 07:16:51 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vv4so34607421ejc.2;
        Tue, 29 Nov 2022 07:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ef9KuAzl4Ml5WfPA/egn9eVef6ufZPHKdL802Tgb7nc=;
        b=C77tKt1pTDn/lXkTY9vUa9wGM5ZMp5vsG30RaQ2awnSyxtLSoaE9UN5Xeujz/gq+Pc
         UxRuLBGtXmoXTX7DI4bmw6SU0sjlV2Po6wJLATwzm4ONsG3/LNc6q5KjyeMKJ1cWAfl2
         FbMGltEaq7hF+h/TrNPD4TdRvZ14+cdy7fNXfPEJ/676XX0Bl2DKMszUkekiz/Olfko9
         eoflRrSZipswsDvWnvU3Iufu/23MJnnxjDfeWnZWGd21d4qlRjuvdLyY1GtcOxP0PdrC
         PrBtRkTTAPYH4/ayCSCDuJEcihIusWVLM5mpK8FfXpX/ETNWEyoUQodO+Ic8jUq6bDwd
         MHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ef9KuAzl4Ml5WfPA/egn9eVef6ufZPHKdL802Tgb7nc=;
        b=j6vHUCVihNWegKFsZV4FHuVVW0egvcxZQw1ADCK2BWumsAPKZMcwOO1nxqUKLVfDGU
         nopaH0JgHadQfPu/B2uKdACqUIKSjvRc9n3zZh/dzjirFQph2WB/8fRRTjCl4ohn1bKu
         c/ld33J8XzLpfrRIGKcnyycuUa+tbJh9O4ereKnISRzQtI8zMJqEmjc1xO55+pnHXVNy
         Pd6zxZLCEzTGLJuDhr2cyPK7mdb4dlgJXh9Tmyj6wLMCDfodybGEB5XUGyXxzy9NNC19
         eAbD5/1ngwi2sMBd43i+uxDQ4G1vDV6SdUMiYMrfENUMljCc4xXt9uuPPBys9/B5wFVk
         EdKg==
X-Gm-Message-State: ANoB5pkItxg46z8AhmlG2pst02+PRP+PesfFc4vitgrT9Jxna/YAixML
        +PUBNtBme6zRgZwNsjINk8zsaPLqchA=
X-Google-Smtp-Source: AA0mqf4RjUxPstqz1rw0GDB91w9vS8eK94+6zYfcoLpxC+z1vMuqXRAlgWGC9cAzFZsik8HQAAp6Pg==
X-Received: by 2002:a17:906:7f92:b0:783:7020:53a7 with SMTP id f18-20020a1709067f9200b00783702053a7mr47687206ejr.736.1669735009406;
        Tue, 29 Nov 2022 07:16:49 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.254])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b007add62dafbasm6225660ejt.157.2022.11.29.07.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 07:16:49 -0800 (PST)
Message-ID: <8736307b-8b09-6cc2-bf89-8ee77f1af62b@gmail.com>
Date:   Tue, 29 Nov 2022 17:16:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: reply to Bitterblue Smith
Content-Language: en-US
To:     JunASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
 <20221129143225.376856-1-JunASAKA@zzy040330.moe>
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20221129143225.376856-1-JunASAKA@zzy040330.moe>
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

On 29/11/2022 16:32, JunASAKA wrote:
> Hi Bitterblue Smith,
> 
> Thanks for your reply. I've seen the discussion.
> As for the bugs of the module, my Tenda U1 wifi module which is using the rtl8192eu chip running into problems with the rtl8xxxu module, more information can be found here: https://bugzilla.kernel.org/show_bug.cgi?id=216746. I want to solve this problem but I haven't got enough experience upon it. I'll appreciate it if you could do me a favour on it. Thanks again.
> 
> Jun ASAKA.

My only idea is to compare all the code with the working driver.
I'm still busy with other things, though.
