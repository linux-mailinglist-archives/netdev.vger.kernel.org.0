Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BB35B109E
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiIGXpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIGXpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:45:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78794BD2F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 16:45:19 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so573462pjl.0
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 16:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3wkBaOkq/K6PeoM5XABHxOHn0wZTkG9XXO6cKDM9XJY=;
        b=L+JCD5DZXl3C9zGhy+x6taYdKAmzacEkFV5lglEjGwx80f+p1nVMaYa3IB9ec+ZCbo
         iP2l/X6StllOARkFN54UfUqD9bbBOaiebpIFD3ANEj4qSTMkDMd8rmq4OD0KXmYlBOZs
         kUOmx+A+R9O8mY5mw6UGFtkf4ufG6IcPBvVxyfma28bXf6/MHj6t3m7M5F/JNNhwd0Z1
         I8UVHOcE7+tJFH30N7gyCFgBYkkxpjspOieb4fPrY9lnKmuHx3ldC2IA1x36Ey4N2M64
         moD8/pIJPJeJhukaPXjH78ys+OIFlwFoBFjjY8SDwxiUygjf038O++2t6snSkgBL5Fse
         XCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3wkBaOkq/K6PeoM5XABHxOHn0wZTkG9XXO6cKDM9XJY=;
        b=1lMgZuNA+fJ/9mkpsssIlinKbQK6/HI8J6hKlz1vG7t9ZaMbGmG/8Pnt0PvgYcNOWF
         jCNZTO0sGerI4a0ajpiraCn6OmThkzeOjDepuLhr9frlLV7PN4g9wWcouEOyln26WtRV
         NGhxfvIGhnwZBEQfunyNml21OaTRUC8SJ8OVnzNGRXPVCyYhOARt9dyN61blnP1BxMlM
         UIuAL2X9Wv/wXRUdzpoxM4qO5xfD5cw4gjOpCrJk7jFzvUJbbUWhUQ0UUVXvcaCAWZTM
         TRNjGj1NmlpV+1PwZRsKrbBnPMq8ltc9yc0bmuq0SzVuq24FK7BitU33g/AaszVrFHYy
         TwwQ==
X-Gm-Message-State: ACgBeo2Px7+idx3BtWge2cefjgvzBio51YdA0Kq9ZsdHl8FBirQYcX9K
        WKD4kHKRm4daVzT+9gN0uEU=
X-Google-Smtp-Source: AA6agR5rW+mQAwACnEoIjBRc2wMGT0GXz5gQ1NClEmKOmSoCd/5xGsSIsY4TTcMOhPNAUuRMQOFDFg==
X-Received: by 2002:a17:902:7295:b0:176:a0d8:77e3 with SMTP id d21-20020a170902729500b00176a0d877e3mr6049894pll.0.1662594319185;
        Wed, 07 Sep 2022 16:45:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:48a3:495e:c90b:fc97? ([2620:15c:2c1:200:48a3:495e:c90b:fc97])
        by smtp.gmail.com with ESMTPSA id e10-20020a17090301ca00b0016c9e5f290esm13225591plh.10.2022.09.07.16.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 16:45:18 -0700 (PDT)
Message-ID: <8c70c1f8-68df-a9cb-9bba-f26edaebd4a6@gmail.com>
Date:   Wed, 7 Sep 2022 16:45:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 net-next 6/6] tcp: Introduce optional per-netns ehash.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220907005534.72876-1-kuniyu@amazon.com>
 <20220907005534.72876-7-kuniyu@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220907005534.72876-7-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/22 17:55, Kuniyuki Iwashima wrote:
> The more sockets we have in the hash table, the longer we spend looking
> up the socket.  While running a number of small workloads on the same
> host, they penalise each other and cause performance degradation.
>
>
> +
> +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> +						 unsigned int ehash_entries)
> +{
> +	struct inet_hashinfo *new_hashinfo;
> +	int i;
> +
> +	new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);

You probably could use kmemdup(hashinfo, sizeof(*hashinfo), GFP_KERNEL);


> +	if (!new_hashinfo)
> +		goto err;
> +
> +	new_hashinfo->ehash = kvmalloc_array(ehash_entries,
> +					     sizeof(struct inet_ehash_bucket),
> +					     GFP_KERNEL_ACCOUNT);
> +	if (!new_hashinfo->ehash)
> +		goto free_hashinfo;
> +
> +	new_hashinfo->ehash_mask = ehash_entries - 1;
> +
> +	if (inet_ehash_locks_alloc(new_hashinfo))
> +		goto free_ehash;
> +
> +	for (i = 0; i < ehash_entries; i++)
> +		INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
> +
> +	new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
> +	new_hashinfo->bhash = hashinfo->bhash;
> +	new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
> +	new_hashinfo->bhash2 = hashinfo->bhash2;
> +	new_hashinfo->bhash_size = hashinfo->bhash_size;
> +
> +	new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
> +	new_hashinfo->lhash2 = hashinfo->lhash2;


This would avoid copying all these @hashinfo fields.


