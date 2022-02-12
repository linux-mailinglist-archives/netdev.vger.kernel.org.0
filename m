Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1704B32E7
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 04:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiBLDtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 22:49:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiBLDtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 22:49:14 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F8D2DA90
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:49:11 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n23so19620500pfo.1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 19:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8z8JAsCWn9qPhfMljfdwjv2hZneT/6sTEC11FGPf2o0=;
        b=bWQ+h6hu8Yzylc6H6u49f6fbyMZAiun1vA3uJcXtqjrrjhkxjAq7nyLpQSDm+TflnX
         TooPBxkIt2HZuPL8e9NSIULjjo7C3eRXDBLaEwF0wEZcfMOXSHxau8veBPsfPBBYAkQT
         CeiVi+KjLtLfoCR9WiLk6K7+BZe3VAPXPlTpWQTxVZK78YmnMCw+KGNAq5pP4zwXIArK
         M3urHefQ6YqVWiyiFFCCAK4kvo5IP+kqKKiwcF6lctOBos9DCuZUqUA2ejSR1n3HtE4F
         KGeFAEaBmF3K5afsBE6xNuckTop2EXRNc5K1/xbjDMcZZEnYZo+lC3fh8FZOGAb3SUvZ
         pWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8z8JAsCWn9qPhfMljfdwjv2hZneT/6sTEC11FGPf2o0=;
        b=stUleWMein6hEZrMsT1nrx5FU6BDGyIsMZGFSz98q5iL41EAMoCJyLAZdH0tMNT3Cs
         LlKY+V0Ufv0ok7uhe/py5yimmzunhDcUHToFcJSHSeBlFceXmW6FaS/5Nf1U+8x4EAT4
         x2Pb7aa+8WSM+M1ROjPh9GUwzkf2h1DtTv/7kMc83BVVHqFKf9VX5b63tX9T2+V7YNPi
         VFfVz5dkMxp4pQMzq55A7nHpgEcKabFracjceCTwTe10PZP3rXxe7hNIWfdRKcBekWfp
         cCtvV71QAp1QUOFiREsgBvLtBTcSHWo06cBorNOtzSitlbYlCPLjI7cfUfdeTchXeAn1
         nFug==
X-Gm-Message-State: AOAM531xbsS6R3qgG+CLo92rwH3bkcpPUJCABYUOYJ8sEDTNwQmv5qsY
        hLmT7kN0Jna3FgxgZfROf6c=
X-Google-Smtp-Source: ABdhPJy0matzSuASiJXZdwk3vGTIqYCnBvXvwWmlnUWb+rShtGPekmTE1HtldVoc57WWPzz3nyJoaw==
X-Received: by 2002:a63:2326:: with SMTP id j38mr3829097pgj.346.1644637751085;
        Fri, 11 Feb 2022 19:49:11 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b? ([2600:8802:b00:4a48:b84a:fcb5:bf5e:eb1b])
        by smtp.gmail.com with ESMTPSA id m14sm29505074pfc.170.2022.02.11.19.49.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 19:49:10 -0800 (PST)
Message-ID: <f86bc031-6baa-7045-f488-f47556086f6c@gmail.com>
Date:   Fri, 11 Feb 2022 19:49:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match
 filename
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20220212022533.2416-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com>
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



On 2/11/2022 6:25 PM, Luiz Angelo Daros de Luca wrote:
> The macro was missed while renaming realtek-smi.h to realtek.h.
> 
> Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
