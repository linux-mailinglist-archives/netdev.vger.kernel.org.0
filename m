Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F99D1419F0
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 22:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgARV6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 16:58:30 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33575 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgARV6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 16:58:30 -0500
Received: by mail-qt1-f194.google.com with SMTP id d5so24754417qto.0
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 13:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOf5bG921245cnNVP0JdEynakSyVJtkYnXWjmO8t0fM=;
        b=m+mKSRlGTIaAScJmcVU58wBBj16K63crQYGdkc0fI+3YNjIxPO06jxJH1SCc7EjW1m
         2E03Ia3d32vE4Uws9lECh5gblnFo4akBYhHgMMsZQ+4p33QU0NVBv3flz8Wlq4RZlemV
         ct2mG1oe0+31uu0/81KL8YvpxLdQISHcgqLhkp/92pqKX6EzNHW8JzYvOlJOI0mmtsJ4
         8gYOEG2WSJuH8RfNXlCLeLSp2ZnqiLnQ9FxL+V/D5FXie8wiLp3FKdpE1GqBlIGamDZU
         u2QV79oagExmpHZR44o0YipdDj57K8q3LCACeyK+usIhFYfe+iNJYjXdbkX4jZKyDdJA
         l3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOf5bG921245cnNVP0JdEynakSyVJtkYnXWjmO8t0fM=;
        b=f+Ag3UmmFRaEVT4a3EHcuqY2uE8zYArcBMwxQR1mNNPvPlnjH0cyifv9v+S3cOeoey
         FNL+I237KNjOt/pwABpJuGkUWvrsr8I5ufnNPVe4t/oGJnLSInEXbJjHgXQuEUIHATVt
         QEN6mLlqxgut7dZLqADyFGk3roAwMClGZW2sLA/vx0JOwKvz32636UlUjwMZzd6W028+
         UItO8RP3EGlIRiv4QIItz16c3vojtS+dehK0ncT1r5lPmfSt3IP3D4hCIgbRi8P9LV+W
         3j934cfPZo/RZnxVpqvRlO9eUnVJ+XNe4GgPTl0ux71ZhpB7xru6LJpDK2Xch0YyKEK2
         lWqA==
X-Gm-Message-State: APjAAAUyA/IDJM2C+QPa1nNBU+jPWEbMxvmwcG6ForpDmP6ChHImz7e5
        vqqjfGac1Kcq/924myRdo5KGfnoJ
X-Google-Smtp-Source: APXvYqwqbO6576Vd1xscxqqWke7yXUUKwwP0FqAraoiX3kujFzir2SzKMC2/kCOBQ/7WkQ9PuK8RfQ==
X-Received: by 2002:aed:2394:: with SMTP id j20mr13984834qtc.167.1579384709311;
        Sat, 18 Jan 2020 13:58:29 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:61e3:b62a:f6cf:af56? ([2601:282:803:7700:61e3:b62a:f6cf:af56])
        by smtp.googlemail.com with ESMTPSA id b42sm15725555qtb.36.2020.01.18.13.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:58:28 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/2] Add support for the ETS Qdisc
To:     Petr Machata <pmachata@gmail.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@mellanox.com>
References: <cover.1578924154.git.petrm@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8cd41192-89b1-af30-af14-84bc351e22f6@gmail.com>
Date:   Sat, 18 Jan 2020 14:58:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1578924154.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/20 7:16 AM, Petr Machata wrote:
> A new Qdisc, "ETS", has been accepted into Linux at kernel commit
> 6bff00170277 ("Merge branch 'ETS-qdisc'"). Add iproute2 support for this
> Qdisc.
> 
> Patch #1, changes libnetlink to admit NLA_F_NESTED in nested attributes.
> Patch #2 then adds ETS support as such.
> 
> Examples (taken from the kernel patchset):
> 
> - Add a Qdisc with 6 bands, 3 strict and 3 ETS with 45%-30%-25% weights:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 
> 
> - Tweak quantum of one of the classes of the previous Qdisc:
> 
>     # tc class ch dev swp1 classid 1:4 ets quantum 1000
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 1000 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 
>     # tc class ch dev swp1 classid 1:3 ets quantum 1000
>     Error: Strict bands do not have a configurable quantum.
> 
> - Purely strict Qdisc with 1:1 mapping between priorities and TCs:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets strict 8 priomap 7 6 5 4 3 2 1 0
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 
> 
> - Use "bands" to specify number of bands explicitly. Underspecified bands
>   are implicitly ETS and their quantum is taken from MTU. The following
>   thus gives each band the same weight:
> 
>     # tc qdisc add dev swp1 root handle 1: \
> 	ets bands 8 priomap 7 6 5 4 3 2 1 0
>     # tc qdisc sh dev swp1
>     qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 
> 

applied to iproute2-next. Thanks for putting a lot of examples in the
cover letter.

