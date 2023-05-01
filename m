Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE456F2FFC
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjEAJva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 05:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjEAJv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 05:51:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E5BE4A;
        Mon,  1 May 2023 02:51:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-24e01ba9e03so517082a91.1;
        Mon, 01 May 2023 02:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682934683; x=1685526683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wAyKklJP4RAwcGyHLElFHWzPziFPamUTZVBn88mFHEM=;
        b=GqMfQC7PQxWSJHUrzTkIrUFwPjo7AQsDMlPtX/wojI4kRyPoU76VlXhPhhdiWO2liC
         M1Y5g5GAs0zZLbMPhMZnI5FkpQ2WCSHTYZ3mqeftXv/E7ReZJOyGSksVcK4kvfbXG8N5
         GmgMAXvRjp9iE5FQl3/M4krfXy8951z3lHS5+DK9cKhcX+DFLC3eowFmt7twD7yU14+K
         YDNV1J+//dvM0DHYoKBmtLshIcTTakJsr7tDmbpkhFzI7A7Ox2INx6MUn4eXx7voZlE6
         7cq5cS9ggipGlO+YFALA7YmsWyxxwtqk1jHXjO/1utZCrMII0jf38EZ2JKSUr/E1CTrc
         i6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682934683; x=1685526683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wAyKklJP4RAwcGyHLElFHWzPziFPamUTZVBn88mFHEM=;
        b=flKWZVthQgECi7qZxI+TGlRc63Wqm+XloM+2DrzY1FKs2vMRqQDG4G9yxrZSM1mWmd
         we9ysisSAOJtXXpOvPJ48JnRBpzFjJIqKYRMtkw8nU0xOmynnyFU/pPXyLj7ucYaDP/x
         W3Bm5QLuc1w1Azi2dikaIeJZ0xgJHF8Cx22w5apg0F0cAJplqG3GhvjuH6aq2iLRWuJi
         iAwqCADH+N2wV5Td9HTPW1jGVwWpU4UoiZtuv4VN4Ga096N3+W9rOmT6BGc93lFkhKw2
         S73kSZEqpnXvCtuAPRaNNJ97/kSQRlPvueP4zL/MaXUfRqFkSP/Pwonvda+rGgrWHyTC
         wLiA==
X-Gm-Message-State: AC+VfDwURUefprrKj7xQqpCQ+poRxPM1TyugkaZmWq7r0jHz1+MeqnIG
        ml5nCo0UsUyA4+Ox0GWfW7w=
X-Google-Smtp-Source: ACHHUZ7bXlwoLS0yE+UKf5JmSxUljwc8fOGS1fiKev+OTVuxC2eEjE3byoVXgpmu5zrdQewi4e6A0w==
X-Received: by 2002:a17:90a:bc89:b0:24e:134e:96db with SMTP id x9-20020a17090abc8900b0024e134e96dbmr619501pjr.22.1682934683254;
        Mon, 01 May 2023 02:51:23 -0700 (PDT)
Received: from [183.173.17.116] ([183.173.17.116])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090aea9000b00247164c1947sm5180481pjz.0.2023.05.01.02.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 02:51:22 -0700 (PDT)
Message-ID: <d9633b9b-c39f-699a-4b05-1c0c55e2dec9@gmail.com>
Date:   Mon, 1 May 2023 17:51:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [BUG][RESEND] Bluetooth: L2CAP: possible data race in
 __sco_sock_close()
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        baijiaju1990@outlook.com
References: <CADm8TemwbUWDP0R_t7axFk4=4-srnm5c+2oJSy7aeSzdKFSVCA@mail.gmail.com>
 <CABBYNZJCbYnxodwXAeq8F9NerzGWFva0OG6SfUWfJ_Grz=Xq6Q@mail.gmail.com>
From:   Tuo Li <islituo@gmail.com>
In-Reply-To: <CABBYNZJCbYnxodwXAeq8F9NerzGWFva0OG6SfUWfJ_Grz=Xq6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply and interests. Our static analysis tool is still 
to be improved, and any feedback on it would be appreciated.

On 2023/4/29 5:24, Luiz Augusto von Dentz wrote:
> Hi,
>
> On Fri, Apr 28, 2023 at 3:27 AM Li Tuo <islituo@gmail.com> wrote:
>>    Hello,
>>
>> Our static analysis tool finds a possible data race in the l2cap protocol
>> in Linux 6.3.0-rc7:
>>
>> In most calling contexts, the variable sk->sk_socket is accessed
>> with holding the lock sk->sk_callback_lock. Here is an example:
>>
>>    l2cap_sock_accept() --> Line 346 in net/bluetooth/l2cap_sock.c
>>        bt_accept_dequeue() --> Line 368 in net/bluetooth/l2cap_sock.c
>>            sock_graft() --> Line 240 in net/bluetooth/af_bluetooth.c
>>                write_lock_bh(&sk->sk_callback_lock); --> Line 2081 in include/net/sock.h (Lock sk->sk_callback_lock)
>>                sk_set_socket() --> Line 2084 in include/net/sock.h
>>                    sk->sk_socket = sock; --> Line 2054 in include/net/sock.h (Access sk->sk_socket)
>>
>> However, in the following calling context:
>>
>>    sco_sock_shutdown() --> Line 1227 in net/bluetooth/sco.c
>>        __sco_sock_close() --> Line 1243 in net/bluetooth/sco.c
>>            BT_DBG(..., sk->sk_socket); --> Line 431 in net/bluetooth/sco.c (Access sk->sk_socket)
>>
>> the variable sk->sk_socket is accessed without holding the lock
>> sk->sk_callback_lock, and thus a data race may occur.
>>
>> Reported-by: BassCheck <bass@buaa.edu.cn>
> Need to check in detail what it means to hold the sk_callback_lock,
> btw is this static analysis tool of yours something public that we can
> use in our CI to detect these problems?
>
>

