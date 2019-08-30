Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED461A3F9F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfH3VZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:25:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44597 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfH3VZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:25:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id b6so5486441wrv.11
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOisKAycy46LXkC0Lo6AUjhfu5v+2EY9zADM7z2jLEA=;
        b=bB9mkqr+gTmbk6wS8FicSzRU0Ku53orp5SOg8l4i2ffrR0y3/j7bMNww/3YjqvOGtv
         WHP2fQtTUREEjzeIwMUzDqAy83s8PzxaXv0E50GCcJ50vuEjiQmXdCJyeP795/Ywhvwp
         YfS38AHtE3SuIYXos5x9TYXoeicC0dPb06XRiFBZXV/Od2aiJ2FXNBiJpM8+fuAj7flR
         zFjZ+lskK1YQbqSE0eIdwNpSFMtLF83DUmJbLvIJi5kdb7uj8gCkbTwlB6YDVITEinbw
         3eJzUAbliUHU3RliWedvt6YfoFtxAzvMbrz+X9MH4aIDzjXy05VCnJ72sMdP4gvyXlW9
         ehhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iOisKAycy46LXkC0Lo6AUjhfu5v+2EY9zADM7z2jLEA=;
        b=kR+G/U4yLfq33wC7YMr01cRHfWrVprstem8TAftKENLCH2tah9j0QUl0mkZgCQVPUH
         gtnMkw7LCu9uZ/owdvCo9Q7g6edsqptCkknDmkkQ6OqgE0IeU7tqrYmTz6wO834JY50R
         1H9Qs+/H4IKcdx4umJMB3KV137LfwioRBjqs7HWEbf5A105DuhuSylTb5Rb9Ixumh1jQ
         1Qpbs+IobZZ0M/ApxyIhKGF4jC52Fd3rCmxyGEyPTP3wvAVv88bkO6qxn3EAfQm9hYvN
         nLANux+L/zfoA+tv70+1K4HJ6RrcYbGrbCPfljR8LOZL0BDrLLV+mj9fUnI/8ymLTxuU
         u/tg==
X-Gm-Message-State: APjAAAUhkRmQnoYGJGENpKf9UWbI0UgHFSgBNSBBYYXN5F8YNjAToRYX
        bV+uWO4J4PUvlPzegmMtJT7kYA==
X-Google-Smtp-Source: APXvYqzqZ5tQ64Lo/MNaxTDfo2VVpk0tqYWKIu4YwS7fnZOpjMKPpKOlkObDY+A0Rq+Y/kzD8LWviw==
X-Received: by 2002:a05:6000:1002:: with SMTP id a2mr9044933wrx.28.1567200306038;
        Fri, 30 Aug 2019 14:25:06 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:dd14:ded7:6a4e:962e? ([2a01:e35:8b63:dc30:dd14:ded7:6a4e:962e])
        by smtp.gmail.com with ESMTPSA id e9sm8621918wmd.25.2019.08.30.14.25.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 14:25:05 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] tc-testing: don't hardcode 'ip' in nsPlugin.py
To:     Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lucas Bates <lucasb@mojatatu.com>, netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
References: <8ade839e21c5231d2d6b8690b39587f802642306.1567180765.git.dcaratti@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a333eec9-6a6d-ba84-1ce3-73dfaf13364a@6wind.com>
Date:   Fri, 30 Aug 2019 23:25:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8ade839e21c5231d2d6b8690b39587f802642306.1567180765.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/08/2019 à 18:51, Davide Caratti a écrit :
> the following tdc test fails on Fedora:
> 
>  # ./tdc.py -e 2638
>   -- ns/SubPlugin.__init__
>  Test 2638: Add matchall and try to get it
>  -----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 clsact"
>  -----> prepare stage *** Error message: "/bin/sh: ip: command not found"
>  returncode 127; expected [0]
>  -----> prepare stage *** Aborting test run.
> 
> Let nsPlugin.py use the 'IP' variable introduced with commit 92c1a19e2fb9
> ("tc-tests: added path to ip command in tdc"), so that the path to 'ip' is
> correctly resolved to the value we have in tdc_config.py.
> 
>  # ./tdc.py -e 2638
>   -- ns/SubPlugin.__init__
>  Test 2638: Add matchall and try to get it
>  All test results:
>  1..1
>  ok 1 2638 - Add matchall and try to get it
> 
> Fixes: 489ce2f42514 ("tc-testing: Restore original behaviour for namespaces in tdc")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
