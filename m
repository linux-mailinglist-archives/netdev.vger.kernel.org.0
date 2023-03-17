Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB776BEFB8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjCQRcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCQRcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:32:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F39A4BE9F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:32:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z21so23320347edb.4
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679074323;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBQZtC+0eLGVRdevYQZTCzh9Pc2ZrfmWETKrta2FZlI=;
        b=DGWApvCuqSnmrxlbunp6S4NSspRrHvVwXKGzPPeIEyEF+5t0ZJQJGZXtzNtrgMbo2o
         4/D9LPJBAXryZ/r3HMix1Pc27X34y6WDqDDrsYcgAgeBrWz9xJI8sDtgQF6tO1KH9fd+
         AlP8fyYtQ+wvhHI+GtG0tQqv7j7zqcRZb6nkM7Tuh6EbXLn4k9k0apTXEOFDyJibSeMf
         LZ+e70+IYiTJPBnw32g39svpB6v4f3/ThjSfqjwKaeu8GEy2gVr0+dZO7pASNg3EMK2e
         rWVBMeAIWUY9DJ9gxtCBQoPm7SFSHbHHBoJTrhpMr8tlpLqrDOnp/ptsevS9qULLX/fu
         uw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679074323;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBQZtC+0eLGVRdevYQZTCzh9Pc2ZrfmWETKrta2FZlI=;
        b=XrSxibWyLcEnS0gsbjLi9cOkDLs4TLqWjW8BOqKrxTLCqlXZhpkYkCJXDIxBt/57k+
         kkjgBxvqCH/8zR9Rt0it35cVv5kyZnUIkGAiFB/bDcdS/tZp4dkJ7dSfmoDhdzXViIso
         17/9rKVYu1o38rtt4Cl+1s2VXDs/GqqEWjYgV95khYitpamKsb0HtR3LXxdlGK6Bb7Th
         UtVZ0pQ1H/RT/nF1nPFb3YjdsNG0LdH94uc1HRbnQMmvoUok4yepzRgi26pofrqgDYXP
         3KMUgMSO9DilBXyjbG8HzrueWA2P+uS5BO/iURUuqxiOeojW8A+AITysS6hgT6taKP1a
         eEAg==
X-Gm-Message-State: AO0yUKXFVATiYQulB9LOGM+FqJrGNYMYjFe+zBCKwj/RixIDhefFQmc7
        H9+aUKmsvwkkXpGNKQMSQIQSww==
X-Google-Smtp-Source: AK7set/Io+9nIBkV3nfTTlHpLyL63wJeICZLWQDgKoPp8r0nvwh2ySlASagnN9zUjuEW5ZPazOc3vQ==
X-Received: by 2002:aa7:c948:0:b0:4ab:d1f4:4b88 with SMTP id h8-20020aa7c948000000b004abd1f44b88mr3306180edt.41.1679074323472;
        Fri, 17 Mar 2023 10:32:03 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id i23-20020a0564020f1700b00500383a202csm1347885eda.6.2023.03.17.10.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:32:03 -0700 (PDT)
Message-ID: <b9b3e7a2-788b-13ca-91a6-3017c8afbbf4@tessares.net>
Date:   Fri, 17 Mar 2023 18:32:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 09/10] mptcp: preserve const qualifier in
 mptcp_sk()
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, MPTCP Upstream <mptcp@lists.linux.dev>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-10-edumazet@google.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230317155539.2552954-10-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 17/03/2023 16:55, Eric Dumazet wrote:
> We can change mptcp_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> We need to change few things to avoid build errors:
> 
> mptcp_set_datafin_timeout() and mptcp_rtx_head() have to accept
> non-const sk pointers.
> 
> @msk local variable in mptcp_pending_tail() must be const.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>

Good idea!

Thank you for this patch and for having Cced me.

It looks good to me. I just have one question below if you don't mind.

(...)

> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 61fd8eabfca2028680e04558b4baca9f48bbaaaa..4ed8ffffb1ca473179217e640a23bc268742628d 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h

(...)

> @@ -381,7 +378,7 @@ static inline struct mptcp_data_frag *mptcp_pending_tail(const struct sock *sk)
>  	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
>  }
>  
> -static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
> +static inline struct mptcp_data_frag *mptcp_rtx_head(struct sock *sk)

It was not clear to me why you had to remove the "const" qualifier here
and not just have to add one when assigning the msk just below. But then
I looked at what was behind the list_first_entry_or_null() macro used in
this function and understood what was the issue.


My naive approach would be to modify this macro but I guess we don't
want to go down that road, right?

-------------------- 8< --------------------
diff --git a/include/linux/list.h b/include/linux/list.h
index f10344dbad4d..cd770766f451 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -550,7 +550,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  * Note that if the list is empty, it returns NULL.
  */
 #define list_first_entry_or_null(ptr, type, member) ({ \
-       struct list_head *head__ = (ptr); \
+       const struct list_head *head__ = (ptr); \
        struct list_head *pos__ = READ_ONCE(head__->next); \
        pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
-------------------- 8< --------------------


It looks safe to me to do that but I would not trust myself on a Friday
evening :)
(I'm sure I'm missing something, I'm sorry if it is completely wrong)

Anyway if we cannot modify list_first_entry_or_null() one way or
another, I'm fine with your modification!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt

>  {
>  	struct mptcp_sock *msk = mptcp_sk(sk);
>  

-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
