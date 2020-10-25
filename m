Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C611A2983A1
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418836AbgJYVJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgJYVJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 17:09:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41DBC061755
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:09:54 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r9so7860634ioo.7
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=in0cG5oPnYev6Y8g6vBoZp5FtC0YlLh/tqYbQsrpq5Q=;
        b=XXRNrGqkqFW0h70wH2o35uWEOX0hXMm4ScODswrhp0n0B7rOXs9n6pdtodyazP9QiK
         seESTPkPVl/1u+SYvidGo/PKyEKJvZXqLsDma9PhJQVOqzZ16C3uXEsky6muEvVWRivp
         d+SFGjTSpPAQXIwaReJld+KAjtWF6j0Djl4AsyktVy7sYvt5F9Shevhz0tPeUMXUyfsC
         8f2PNFWjuwfp9OgVCuP5fs+pSsaQ5YqIbihSyq24oyZDvTHuOCsbsxc2ElzXvM6H2YRm
         tPactYwdssS+iP1Vl97hNMfQ96CkFr9Wnl42cGK37KzP7mtpdYFCNNdPJjUIEIoGN6vZ
         MocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=in0cG5oPnYev6Y8g6vBoZp5FtC0YlLh/tqYbQsrpq5Q=;
        b=ihvE0fuW4d08a+wszXiK8b+2UxryZiLFWgp6s0OriC6pvzTo/0KA86F8vNgD8lFneQ
         2urrVwntbdzzE9wM5/c1guges3KmaX7FsZw7GkaDekNYW+wXFOqwJ+RbyeQnU8Ddcmfr
         DCjJIsfouv5hp0HZ53vLeyLO59+dJD4OCTtfvVD8I7qg3iqm5mplqBHHZrx//hZ7lStA
         58BpJMGUiG6gIm/bNsqS023lLZFQpAvdco6fyfgZjEO0mJnTBzokbJYk8jhrQ70lzdIu
         4UvrGzFPs0Jq3KXIWnQCaIoi/WE0Ay7feLZtduJs1BLjKB9x5lEr7Res0fLR60F3so7y
         GHrw==
X-Gm-Message-State: AOAM530s7PCtysnQW5snyLY3s+wAyU4/7RujikPtQrcxUWW/v3EsvLJl
        TNrJIGmJtPXkEw8l4TsgY5o=
X-Google-Smtp-Source: ABdhPJymF0u49O5tmRqT8VobJsjjnctM59gPhjC6kp8xR9lg0LGfCQ6ZZwtlc5kb23/8puHtheZYpA==
X-Received: by 2002:a5d:9481:: with SMTP id v1mr8349235ioj.168.1603660194242;
        Sun, 25 Oct 2020 14:09:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e928:c58a:d675:869a])
        by smtp.googlemail.com with ESMTPSA id y17sm424301ilj.7.2020.10.25.14.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 14:09:53 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] m_mpls: test the 'mac_push' action after
 'modify'
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        martin.varghese@nokia.com
References: <4340721b2347c9290d2e379ee22b3a1a05083eb6.1603357855.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <342316c3-d434-749a-dff9-63ec3dd25feb@gmail.com>
Date:   Sun, 25 Oct 2020 15:09:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <4340721b2347c9290d2e379ee22b3a1a05083eb6.1603357855.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/20 3:11 AM, Guillaume Nault wrote:
> Commit 02a261b5ba1c ("m_mpls: add mac_push action") added a matches()
> test for the "mac_push" string before the test for "modify".
> This changes the previous behaviour as 'action m' used to match
> "modify" while it now matches "mac_push".
> 
> Revert to the original behaviour by moving the "mac_push" test after
> "modify".
> 
> Fixes: 02a261b5ba1c ("m_mpls: add mac_push action")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tc/m_mpls.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

applied to iproute2-next. Thanks,
