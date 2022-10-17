Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E436013E0
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJQQuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJQQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:50:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DF9DEC2;
        Mon, 17 Oct 2022 09:50:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z97so16915725ede.8;
        Mon, 17 Oct 2022 09:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ljMwFMsGhYFrteQhcvxg+9WwuCbKPdET/QlVHZX87ww=;
        b=SNCaIFZ6ZHk4eyfJ58C9q8dTHW9V/zQxcHJ5LbBDejwuh7vQPQuIQuHPof/8fQE0Sn
         F/dtmr/W0fcFN13pkFtfRSBnci1hEAgtd8B/RljU15/6eFy6rWl4Tm+hzl3Qb/TgJG/b
         /dMio2b84AzPohxjlE1ItyRION1zEW+tY2oQl5xCGVoiaytWSqrunofOpizMJUebDLJL
         ilyxhAUYQYDw2Qfofx9o7HULMbNxbl7QG+5Ydjl3rhWXqfKdPWGdqabXKWC98WtgQsVD
         WcYrCrYqh6GAMegYz+S9MmktknGo3Wk0f8e709LRR+oO66ulxAN7QbdM6MM+d2orjbSO
         rXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljMwFMsGhYFrteQhcvxg+9WwuCbKPdET/QlVHZX87ww=;
        b=MC9kbpsmiKiYjPwInR61u6RhN+R/zf+jQNxiA+H1/5gg7BtrTWVvfW1S9vnL44SdDM
         a//jkWLBlEBcnonLJE+RH2wTd22w3C1y8vBVxC1BJWEpc5N06iVjY/3U29CBaBoZW0Sq
         ECzFa4T0Qk0ORbJ6ob4xLZPonhluSbT6/ml/3aN8CXXxfKpPiTYKcsJA3dNfwNXBOGek
         4X+B/ZBit4AvVJNhfDmI6evupBVNUL6AXdh0gtpIJrcfzoqDjewL4Xliy6j1IObefV4s
         ePz595io6MUkwqGyxKoHBkHaLR9DTX4Edf8v/wZM2aqF1WcFOAzy/1Q0BX/eO2/TM2jP
         9jlw==
X-Gm-Message-State: ACrzQf2XJWARJNG23R4KlpO9QARx1n8warpKQfHXL9AMh8pM2peSH2wf
        j7jX1QuTIWC1uBOfiCzwaYM=
X-Google-Smtp-Source: AMsMyM7AQaEkuzGxOIvBD33JhgNoRm39M/cgF0yfC5eCV+qG8bnLKdSbc1ds0Dv1TrD7wCfh3uLv7Q==
X-Received: by 2002:a05:6402:34cb:b0:45d:197e:718c with SMTP id w11-20020a05640234cb00b0045d197e718cmr11151839edc.365.1666025413105;
        Mon, 17 Oct 2022 09:50:13 -0700 (PDT)
Received: from [192.168.8.100] (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b0078d21574986sm6387039ejh.203.2022.10.17.09.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:50:12 -0700 (PDT)
Message-ID: <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
Date:   Mon, 17 Oct 2022 17:46:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_CQE_F_COPIED
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Stefan,

On 10/14/22 12:06, Stefan Metzmacher wrote:
> Hi Pavel,
> 
> In the tests I made I used this version of IORING_CQE_F_COPIED:
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=645d3b584c417a247d92d71baa6266a5f3d0d17d
> (also inlined at the end)
> 
> Would that something we want for 6.1? (Should I post that with a useful commit message, after doing some more tests)

I was thinking, can it be delivered separately but not in the same cqe?
The intention is to keep it off the IO path. For example, it can emit a
zc status CQE or maybe keep a "zc failed" counter inside the ring. Other
options? And we can add a separate callback for that, will make a couple
of things better.

What do you think? Especially from the userspace usability perspective.

-- 
Pavel Begunkov
