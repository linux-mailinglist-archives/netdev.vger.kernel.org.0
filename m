Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FF867FE13
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjA2KLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjA2KLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:11:39 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33711E5DC
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:11:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id p26so13085850ejx.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WGEur4ZImg+eboS3WKEGWQySrzE5jLwrJWc4aJbdxO8=;
        b=Upyq9ukTht74rZcR5Xt5AYL8dRAaLLsu2mgmtKAlw27RORtnQVTR/cMugKdJn9133p
         jb8EyEeD2MMWQ460sVZiATkzfBitfITUgIkqPdkFtNNrF/n/KztvFAL8kRokBp58E/bC
         OZbciMu2pXLcRkEevNng74DoWr+KCF/UbaPvHr+RioJIac8vTx82xDp3rPMbTXU3aoTQ
         3a/Is+PsG9awAP11q2fjlUxY2fyB+UZ0sx5xLOsznHP86J15+YaSiOWUN3okCunhLJgD
         iXRgqC2NAvEykBYdwX7GpBEj4yJCzDuW05wdFmUZjgvbH9mW0eg+fSkrKzS87SFQkk4j
         z/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WGEur4ZImg+eboS3WKEGWQySrzE5jLwrJWc4aJbdxO8=;
        b=dMegIEvj0vZCaywBYNkfv05sFha1rg/2dqJGd7qKcut3dqS4HT/cQscmwTFsKEN4fN
         KBzxa5AtSyBb+lt4y0ykWbWE3BEMhSTU+AvwZjRLVCmF59qkqX6sx1oIqmJPFQTP9m1h
         Mi1w6SvRhF04zECLf+1deWWEvnIwWaykz3humyo84eGqvyhPA+N9/M9NvoX1qFzWC92m
         TG5amnwCvBj0kVNqe1u5jaSudR3KebUzYf1XOchI+ZYsZZ7gm7zimKmCj1kwWimWpWWk
         Ey35dJ++nLHj7QJdWZgSi/+L3+N9TaGr7Paq1dWQziO8ls3e5FpDNGOlMZTK2rVQ4XCA
         1ioQ==
X-Gm-Message-State: AO0yUKVYY/FI04gkerhRjZn0cAqk1fP+oQeNfFjfk4M/S5mf9rf5a9c8
        ot7IdgAIAtaUM1+Ki1ab+kUCsGvxb7hKHx6Ox1I=
X-Google-Smtp-Source: AK7set970quRC4KMo1FnKwsZMwePweLpetzv9GuXAD4nqHwDJpP9nPkFFTVqlEpDX9jH7bIZhdf3GQ==
X-Received: by 2002:a17:907:2989:b0:883:5b33:e019 with SMTP id eu9-20020a170907298900b008835b33e019mr4303568ejc.61.1674987096320;
        Sun, 29 Jan 2023 02:11:36 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id b18-20020a170906709200b0087bd2ebe474sm3765960ejk.208.2023.01.29.02.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:11:35 -0800 (PST)
Message-ID: <7fd7a5a3-2ca9-d42c-f0a7-5b03760ab507@blackwall.org>
Date:   Sun, 29 Jan 2023 12:11:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 14/16] selftests: forwarding: lib: Allow list of
 IPs for IGMPv3/MLDv2
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <273051ca0cae7bcd2957e44803fed128efc80336.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <273051ca0cae7bcd2957e44803fed128efc80336.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> The testsuite that checks for mcast_max_groups functionality will need
> to generate IGMP and MLD packets with configurable number of (S,G)
> addresses. To that end, further extend igmpv3_is_in_get() and
> mldv2_is_in_get() to allow a list of IP addresses instead of one
> address.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 22 +++++++++++++------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


