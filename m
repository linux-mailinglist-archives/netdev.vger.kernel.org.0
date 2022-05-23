Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3C531968
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbiEWR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 13:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242510AbiEWR1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 13:27:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4914A814AC;
        Mon, 23 May 2022 10:23:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso14375564pjg.0;
        Mon, 23 May 2022 10:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kVCTG+3+NA8/KUywnzUbBkQ75c3uC0F9FoLTv7cklr4=;
        b=dEAveRG7O1ujSVYjlQfsaO+q3cP8iBMOi6KEg10kguUaVpe8ICSQBjKAxntihwgkrX
         rF6creaObAFxLfp98upZ7iOl8Cjj8uZA5cYNqmwh4Xtg+nXlgJ7sDoxec1jK5PLk1s/W
         2Uli+3sqrT/0iIINldfzLFsH5qxEmWQpeuo4GUFJ/iLWBBj9tHEzp68NQC/OWUmZVEc1
         tAb0X2ongh3O15vvd6Pu5GEq5Rn1FOGtRYjGr871OE8/NMmDCCJ37XrBGpYIIlQf4QwR
         dgYh3JXeb+Z5tM5Ji3GqYHqXuXkOnvGuqCeYL4QNymyFqfrbcRtK1dPLvohkLxHLUQbK
         V51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kVCTG+3+NA8/KUywnzUbBkQ75c3uC0F9FoLTv7cklr4=;
        b=DuJbFKpQS5RuupYF5CiIo2rIN5r3WjI7yehGRE4hNj7U8TqWUJ4cOM6C+y6y9IhbFH
         9OI//CdQd3/IrP7MsvksJCEtRF0wbpb+RJfW67Cxn4lh1IAXHCUlz+ZzXLYoe8FOlZ50
         qu++0ZI/n3/E4YBabl0EKzAdfqwHaGa96/bTi84Ee+zLYh1H4m4c9M4ihWoXMma29qNv
         uRjlkMzbFMixHUkE7rpxkETBSEuDZvUrqKNu33boIp8a1vm2Ep8mAGFvq6MlO9/qnn5/
         H2xgctWnrdK0PMzqXrzfggcggUikM7RgWp2YY06AJuzh5ikX3sL7TVuIhAWPOEhypDqU
         wL3A==
X-Gm-Message-State: AOAM530ZltzhTyLuf1+jsPtEVkRz9Xp/tPG3nl3peuDCpamrLCxG9k/C
        nA1a4oNeC+S+zQWOkNjMdKg=
X-Google-Smtp-Source: ABdhPJwj7ZzeTeCfVX6/y6kQdpi8V/I/S7H9fOj6ggu3ZX2FrU5/IBQ/5FPYM+tQkrE9SEoHUozFnQ==
X-Received: by 2002:a17:90b:3b8b:b0:1df:f2ca:c56d with SMTP id pc11-20020a17090b3b8b00b001dff2cac56dmr39343pjb.199.1653326604202;
        Mon, 23 May 2022 10:23:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 1-20020a170902c10100b001617aef3e08sm5474612pli.51.2022.05.23.10.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:23:23 -0700 (PDT)
Message-ID: <772f9381-1180-319e-3afa-cca900291c94@gmail.com>
Date:   Mon, 23 May 2022 10:23:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH ipsec] Revert "net: af_key: add check for pfkey_broadcast
 in function pfkey_process"
Content-Language: en-US
To:     Michal Kubecek <mkubecek@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <fbb31dc72fb38a69a2aca6c25f1be71d6a8bcc96.1653321424.git.mkubecek@suse.cz>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <fbb31dc72fb38a69a2aca6c25f1be71d6a8bcc96.1653321424.git.mkubecek@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 09:01, Michal Kubecek wrote:
> This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.
> 
> A non-zero return value from pfkey_broadcast() does not necessarily mean
> an error occurred as this function returns -ESRCH when no registered
> listener received the message. In particular, a call with
> BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
> zero so that this commit in fact prevents processing any PF_KEY message.
> One visible effect is that racoon daemon fails to find encryption
> algorithms like aes and refuses to start.
> 
> Excluding -ESRCH return value would fix this but it's not obvious that
> we really want to bail out here and most other callers of
> pfkey_broadcast() also ignore the return value. Also, as pointed out by
> Steffen Klassert, PF_KEY is kind of deprecated and newer userspace code
> should use netlink instead so that we should only disturb the code for
> really important fixes.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Maybe you can add a comment above the call such that future tool-based 
patches submissions to give the author a chance to read the comment 
above and ask oneself twice whether this is relevant or not?
-- 
Florian
