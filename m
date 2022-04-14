Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6029A5018C9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiDNQjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiDNQj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:39:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D400105075
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:08:45 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id p1so3839465qtq.10
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5kUWovzors6b43+MCan5lC7dj6ywh73Yq3+a22fP/DU=;
        b=A+rOZ9tk8+hzM+lnYiWKS3hOI/rVhNOk3tOAdHZ348zSA7sGzHTv0SzkJMj3U3R+fV
         UBxwtbXn8PUmtvEa2z6/82X3OgXdTK4CErdVCVf6k7hWUzIOQQkJO28Ffdgnsvsvyz4p
         Cb2OmtT1pjVpUgPCRw1WkstwXJMdiFe3asPu9d0CNE+SfIsjKaNHYPBZE4XgYiEglges
         shJdlD9NPGhpvPZv7zhI3DUu9y3b/fVZYml/2PjTpuAQ9aG58MsQZovb1LkJsdCWBEj2
         ho3IpaQigjT2MHGs0EqRH+IpRDDKuQbPK7x++wbu89gw7eWGhdwp0SgJWr5I5NFRPD/w
         QG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5kUWovzors6b43+MCan5lC7dj6ywh73Yq3+a22fP/DU=;
        b=tYZEHPaDXKYDyzEl/vIrmxQUiMmHK6Angs2aYO5Vnl43bIRBlsUye60kh3+iHvWAKu
         Tbq4SMoZB7BnOpavZX7g/Of+I8Ti2LAVUqcKdg5OUGk570TbZhrxiPBDGSc6u8Kz6JTl
         J8QVWXkjxoDo+XCAG5jiqPcE3+EPH8jr9d2C2e5mJNs9YqXyZSxmpGfGmy4lsOdIyYhZ
         aclst+cuXYD+Fne3PCS4StVVLO2pk3nNciI14jrau06hI4lnvbVSkAPsHQpmIzuTApya
         x8Xl4cb7pQ4nXY6xM+RWWJ+6KeMBgJLRtVAZkjAMKwHokGzI+AgphRvTEd+gBSXh1EST
         Flag==
X-Gm-Message-State: AOAM532/Q9p/JC/zvYenrY4PODxsy9wSMOsmHI8iI1wGH+AL6TpNwWrP
        4omVpJD1Sy+hhVvbg5o1KHXOlg==
X-Google-Smtp-Source: ABdhPJxWf3+NgZWiPRfiAFAUh7kcTRt8BM2qZM40BYS8ezKWnu+48uVE65XoyLhmoNh1JhH9kk0PMA==
X-Received: by 2002:a05:622a:38b:b0:2e2:34d2:2a51 with SMTP id j11-20020a05622a038b00b002e234d22a51mr2334032qtx.250.1649952523857;
        Thu, 14 Apr 2022 09:08:43 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id x13-20020a05620a258d00b0069c7468e123sm1042640qko.122.2022.04.14.09.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 09:08:43 -0700 (PDT)
Message-ID: <cf849e82-afc8-a9e5-74b9-69f07f817926@mojatatu.com>
Date:   Thu, 14 Apr 2022 12:08:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net_sched: make qdisc_reset() smaller
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220414011004.2378350-1-eric.dumazet@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220414011004.2378350-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-13 21:10, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some unknown reason qdisc_reset() is using
> a convoluted way of freeing two lists of skbs.
> 
> Use __skb_queue_purge() instead.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>   net/sched/sch_generic.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 5bab9f8b8f453526185c3b6df57065450b1e3d89..dba0b3e24af5e84f7116ae9b6fdb6f66b01a896c 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1019,22 +1019,14 @@ EXPORT_SYMBOL(qdisc_create_dflt);
>   void qdisc_reset(struct Qdisc *qdisc)
>   {
>   	const struct Qdisc_ops *ops = qdisc->ops;
> -	struct sk_buff *skb, *tmp;
>   
>   	trace_qdisc_reset(qdisc);
>   
>   	if (ops->reset)
>   		ops->reset(qdisc);
>   
> -	skb_queue_walk_safe(&qdisc->gso_skb, skb, tmp) {
> -		__skb_unlink(skb, &qdisc->gso_skb);
> -		kfree_skb_list(skb);
> -	}
> -
> -	skb_queue_walk_safe(&qdisc->skb_bad_txq, skb, tmp) {
> -		__skb_unlink(skb, &qdisc->skb_bad_txq);
> -		kfree_skb_list(skb);
> -	}
> +	__skb_queue_purge(&qdisc->gso_skb);
> +	__skb_queue_purge(&qdisc->skb_bad_txq);
>   

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

