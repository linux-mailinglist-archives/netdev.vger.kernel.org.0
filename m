Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B82305218
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhA0FSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbhA0Em0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:42:26 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E01C061756
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:41:46 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id i30so522567ota.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r8VnUXKruL+zOVMcgISy+iEmaF2HIaIRlFw5iMiYIQE=;
        b=nDDm/gcIrnp5+Vte1oeuzqO0rJj/UPAlnz1gHZb8GDHxnRhY5fKsV1w7qUqICZ6VFX
         yPjPv0uW0FYnllbJo+z9c5+LjpXYjUZXjV2Sv/YW3o/50tMOyVvG4DBGh8uLp5IVDZmk
         EyzQO2H40M0WxV5f14lUEgc3wiRYx2e7DpFzHmF8kTSG9RPuVHapUFChPPbexA7YXNv4
         zAwPV9Ykci1mtsilsqT37uAWV9X7EK35BwP5TViJKNvmk9NfsP6RbtexFX/3JM6WUqN2
         Tg3buQl7gPVPTnI9TM0deVUnFTSQNuiaDqlSvwXRV3ET71olFmh7PdZxpXi7RG6Jmgxg
         kKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r8VnUXKruL+zOVMcgISy+iEmaF2HIaIRlFw5iMiYIQE=;
        b=NrlL83/WkzxpOcX1cLFJIkJzTR0hVqBkSrZSzcxUu2Yc2mjpLu/7x2aASIGWq0fV4s
         PwOJ8I2YtBF0Aem1sLq97eYP5O5uO7fxDRV9flmtASfQ+3xSjwhXe5cCE2Q21mntEvgP
         GLEfdyQp9VPlxqGELXiPo/g8f8K8QmMQlSidYYezqDE4N0v5fV5eBJP9Wj8DVcsoPg5J
         uTrLb3Y8QdwyjSCQmQdZA55vmAlrFve0VdHVa6NXpsCkdqc7Er0LL0nP4BXWKlkuAoDZ
         tmgHxNtaUNJzUoooqYTzfFuT55skFZ6sFVowfMWhOavkVy49z/KrN6hXYSRvu4UaJdW5
         wOww==
X-Gm-Message-State: AOAM533dtmNorc/dheGFrexEcyXAqa1l8SObb224Cf2vsfkAbZJQ/UYM
        s2iCBMSklhu/hF0I7PmmPzw=
X-Google-Smtp-Source: ABdhPJxNHyMLUtcueLd3+vo+O5ZL86U6T6WcmzWfMoeD8U6mzeIhLq6AiBWfw6zYXR028oulq31VaQ==
X-Received: by 2002:a05:6830:1dc8:: with SMTP id a8mr6454127otj.26.1611722505960;
        Tue, 26 Jan 2021 20:41:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id f10sm242034oom.18.2021.01.26.20.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 20:41:45 -0800 (PST)
Subject: Re: [PATCH net-next 04/10] net: ipv4: Publish fib_nlmsg_size()
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e28426c-355f-9152-5530-05a513646ee0@gmail.com>
Date:   Tue, 26 Jan 2021 21:41:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> Publish fib_nlmsg_size() to allow it to be used later on from
> fib_alias_hw_flags_set().
> 
> Remove the inline keyword since it shouldn't be used inside C files.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_lookup.h    | 1 +
>  net/ipv4/fib_semantics.c | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
