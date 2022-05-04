Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86E9519694
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 06:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344566AbiEDEck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 00:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344563AbiEDEch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 00:32:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9531A26AD5;
        Tue,  3 May 2022 21:28:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d17so426609plg.0;
        Tue, 03 May 2022 21:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QZv7jD+5fjk8Vawh6DvHYJ+ahvZutcLwH7fZiiHiZyw=;
        b=Jso0De5bNwc//lqgdmQqnB+Zh9nQgwCN58RWg43w5Ql33c4zC2QiPrAfbAC9KfP+2d
         3GALSCV6ukS5IyeHDSZESrC54EvB6uOjA5vjOU7P9HKbJ/XegozUG6Q8ziIPVJgwO8SF
         dE8E0sPCsXGjNjMGbbKnMOO9NARdh8dSQsKG6InlkTzh9MMu3cSz3QCdBKyDJsEmbOp7
         6Bef7YduWVgSkkyd/ZoDuhiBD9AJD9iSbTrSLWOilbSe9WJP+VfLkjKvf1kwocC0HL6+
         S8ZsWXqUOD9UPvXvprS6RW+lJmDvp1Eq31jckdGHvImYs9hgpg3/AkUz/yGAAICSUQmk
         28ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QZv7jD+5fjk8Vawh6DvHYJ+ahvZutcLwH7fZiiHiZyw=;
        b=THqzooi3aTchZTueybjcRDJIwoum7ZI+BFbtvxqTwBu/lmQVimvgfk0Tugtw9Ix7Ha
         ifK7DsXoVEN7nPSOUrncIsXCisnZRRsfk+9YZflYzUFFsoRt9IBWcabi9mmLk43Clu8d
         FjQj9na1iKRZglhWxYKaELgjEw8n/Y+hAtQrptriOGC9wL705spDnosdWWALIJEg8HGD
         cE8UhOgYvZ6cjuE2cpxSXLUe9F9rElNE3xy+9qPF8eP9CFhmJN22G6CSYt4CWP4P0waL
         jyLmAXAs5+JT0x/WvdziSPmcN6n9qEtvAjTdOnc70SgHNtXrPDl87+wbNu6WuZzOCsxb
         Obfg==
X-Gm-Message-State: AOAM530fL93d1rT+Ktwxt6b1kl/91KRQEM6wopoBnB8XWt/VPBfeRxqe
        uBhK7X4+5N24vE8aBpFbmyo=
X-Google-Smtp-Source: ABdhPJxBosJjQajdsV74540jZx9QulgrSss19Tu62YIXWGYMzhRhhFToCNoBMcqTNvczd7RKluLEDw==
X-Received: by 2002:a17:90a:b106:b0:1d9:7cde:7914 with SMTP id z6-20020a17090ab10600b001d97cde7914mr8402344pjq.56.1651638537098;
        Tue, 03 May 2022 21:28:57 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-30.three.co.id. [180.214.233.30])
        by smtp.gmail.com with ESMTPSA id j12-20020a62e90c000000b0050dc76281e7sm7157486pfh.193.2022.05.03.21.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 21:28:56 -0700 (PDT)
Message-ID: <9d8b436a-5d8d-2a53-a2a1-5fbab987e41b@gmail.com>
Date:   Wed, 4 May 2022 11:28:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] net/core: Remove comment quote for
 __dev_queue_xmit()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-doc@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Jones <davej@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pavel Begunkov <asml.silence@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220503072949.27336-1-bagasdotme@gmail.com>
 <20220503180341.36dcbb07@kernel.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220503180341.36dcbb07@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 08:03, Jakub Kicinski wrote:
> On Tue,  3 May 2022 14:29:49 +0700 Bagas Sanjaya wrote:
>> - * -----------------------------------------------------------------------------------
>> - *      I notice this method can also return errors from the queue disciplines,
>> - *      including NET_XMIT_DROP, which is a positive value.  So, errors can also
>> - *      be positive.
>> - *
>> - *      Regardless of the return value, the skb is consumed, so it is currently
>> - *      difficult to retry a send to this method.  (You can bump the ref count
>> - *      before sending to hold a reference for retry if you are careful.)
>> - *
>> - *      When calling this method, interrupts MUST be enabled.  This is because
>> - *      the BH enable code must have IRQs enabled so that it will not deadlock.
>> - *          --BLG
>> + *	This method can also return positive errno code from the queue
>> + *	disciplines (including NET_XMIT_DROP).
>> + *
>> + *	Note that regardless of the return value, the skb is consumed
>> + *	anyway, so it is currently difficult to retry sending to this
>> + *	method.
> 
> Why drop almost half of the comment if the problem is just the ----
> banner?

I can't think of preserving delineation between actual documentation
and the quote without messing up kernel-doc.

Actually the "--BLG" signature is the culprit.

-- 
An old man doll... just what I always wanted! - Clara
