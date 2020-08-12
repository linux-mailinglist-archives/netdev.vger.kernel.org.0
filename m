Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71350242435
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLDQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgHLDQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:16:10 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A54C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:16:09 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id v6so825876ota.13
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EJWAIhw+Uzk0ukHNEXeQHpgWicYw0kiCzKoWzJ27Ie0=;
        b=MTLiheTS0XOBt9CbpvE/Jj4f1Il433GG3u58Ab+d+6HqIca4/kDrwGkA1CmcXiMfc4
         uCajPSlV15+FObD0QezdfhAnpKB1tNVK9ibn+aNsIIH8qGZhIyDi3wgE2024U1mM1zDn
         vRxJwW3lJ1uS0MOv70Wi4T/IYtUNDWlmg+Skfm5S7+fnKk+sBmuSWy0Lp1R4EyNa9NIr
         N4xWETu8BNrnqSSWcxToegtT0aca5lNK6Wd0WDiJshO5HyLnkgKks0Bnn73++kuv1iRR
         nTH+BRc9yVp4AXWbioqyMiqhC87oGMVij1Cnh2ihOzJ/4hD7HbjMbtpMTJg8DXbD0Q8q
         ulkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EJWAIhw+Uzk0ukHNEXeQHpgWicYw0kiCzKoWzJ27Ie0=;
        b=Ky79l3j7FT9CWInOPQzyq1zydggRsbJSmOv70ilPFh0DfRma/atny/KcRpkTAH7rQP
         p5lvHWUZGOYJCjM2ruj5fShOpGVdndip60yZG7OGd6ZowbhjwKCi0zQWWIhjPOzWlxa0
         BxJnw8SyQK43JlBFqOV9BI2k9sMo8WUMEI5c3ou4eQ+U8octt9eVv60N455kl1DkTu+U
         Mt8IWhTNybJxI0yzU6VzdwKZ2OO4+f6pRx6T/MEBm23TDU9Rq8TEtrqj5whbmx2YLzCG
         0atpV6H0TJ/VdibZqaSNu3FhZUIg5n2AIUM1cmVqBlZcwz3Y9wM4A7CT7ko5H3pLoW7+
         SEyA==
X-Gm-Message-State: AOAM530iL+iEvO5rT6937w9BcNbKVQsjhLRi8fjKeQ2nNe3vfb9e4ITG
        l3G6BUHUr5dnGXMN7Zr0qNY=
X-Google-Smtp-Source: ABdhPJxyFzQD3DAQrsBWAMWsFbliCQWz9Cr4zQVb47PX1fsBOTsn5bOcUY1mROCWXRUD1/UVuW5ULg==
X-Received: by 2002:a9d:5f0c:: with SMTP id f12mr7322614oti.141.1597202169425;
        Tue, 11 Aug 2020 20:16:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c1d8:5dca:975d:16e])
        by smtp.googlemail.com with ESMTPSA id l6sm181837otd.20.2020.08.11.20.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 20:16:09 -0700 (PDT)
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20200812013440.851707-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
Date:   Tue, 11 Aug 2020 21:16:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200812013440.851707-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/20 7:34 PM, Eric Dumazet wrote:
> We must accept an empty mask in store_rps_map(), or we are not able
> to disable RPS on a queue.

0 works. Is that not sufficient?
