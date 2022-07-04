Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63904565DD0
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbiGDTJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiGDTJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:09:03 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF911E4;
        Mon,  4 Jul 2022 12:09:03 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p9so6040739ilj.7;
        Mon, 04 Jul 2022 12:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=URkacvLwOCim4ro6sjuoVvqr16Vge8XHF6pKruCveU8=;
        b=W7K0TqoaiiMG8G9pHOGU4jkvfJDJ0eru9aSqSlATDmhoaPMeRNCd/vTaJxn7dS4E24
         iEdsDuzJv/HRg5MbHxV8QhjQvw7oyDRVcpNXRtjXzhi/2w0wD0lUAZLr3fqqGiqak2Kh
         wKDdVF87sk0uZpI9ovKBLCPp1c6fV7cs3cpdYjsjg3eNGH8Ut79ab6k/+OCOUdOrXj7S
         6C29v9vIj5nBlNGwSx7V0Rz2B2aAbOlkWBgLYa+G++6ORoxRdP63tnYuVKTD73Fly7jx
         R+FU9vjYS7E0cGSe8sbp7xdXqMFFOs9YGiJ2uWaGHATPjUfqzve4qawwzF5Dl0z8ws5q
         cIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=URkacvLwOCim4ro6sjuoVvqr16Vge8XHF6pKruCveU8=;
        b=mmcjPQ8cafDbNu2dKyDhQ3O1/HeTdI1VrYyeh8sYQWiAOMIQHWBeyRXgBiYR2uu7xl
         Ixma9S8eyRsoF1ZcEzTGRi5zAWw1fQaQaw+deInlURpIxsH8c9d4Wab2Zgl2xUbjRjjS
         8l/x0JP/QIdLw3OjpRXa8qHA9kpamWB4TKnGG/odR/go5z0zIx8ZxXEGF7JXZMtwinWc
         M5jzoBsaApw4O+SSjVLqvyOn5zrnJe9Pi/2GzzBQ+DDrFCM7CJVQauXO3ITKP53JNlZZ
         VPD9GBy0GooH8KInJVOLdYVCS4PfV9eq2jMrvvpciNkMU/m8k0XNVxwG/MfVtp4dKOss
         RMcA==
X-Gm-Message-State: AJIora85AwxtZ3sYQUzB1xY+O8TdIVPZdW6/pCqw3wthNwZSAJDaalF+
        pSL9SRR27Lud+ScIzbRo401xmPw0zNQ=
X-Google-Smtp-Source: AGRyM1ux6bLb1uwTnLkLYYHQoho8dXnSpDtJ53TL3Cd1y1agZxelqlO8ZFsAMAB91g3npZ8/n5g8xw==
X-Received: by 2002:a05:6e02:1c07:b0:2d9:5fa0:f5d3 with SMTP id l7-20020a056e021c0700b002d95fa0f5d3mr17772939ilh.134.1656961742523;
        Mon, 04 Jul 2022 12:09:02 -0700 (PDT)
Received: from ?IPV6:2601:284:8200:b700:89c9:fb3c:ea5:5615? ([2601:284:8200:b700:89c9:fb3c:ea5:5615])
        by smtp.googlemail.com with ESMTPSA id w1-20020a5ed601000000b00675305c58bdsm11466627iom.18.2022.07.04.12.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 12:09:02 -0700 (PDT)
Message-ID: <38135333-b277-1b1b-8346-1da2e1f114a7@gmail.com>
Date:   Mon, 4 Jul 2022 13:09:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2] tracing/ipv4/ipv6: Use static array for name field in
 fib*_lookup_table event
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20220704091436.3705edbf@rorschach.local.home>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220704091436.3705edbf@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/22 7:14 AM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The fib_lookup_table and fib6_lookup_table events declare name as a
> dynamic_array, but also give it a fixed size, which defeats the purpose of
> the dynamic array, especially since the dynamic array also includes meta
> data in the event to specify its size.
> 
> Since the size of the name is at most 16 bytes (defined by IFNAMSIZ),
> it is not worth spending the effort to determine the size of the string.
> 
> Just use a fixed size array and copy into it. This will save 4 bytes that
> are used for the meta data that saves the size and position of a dynamic
> array, and even slightly speed up the event processing.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lkml.kernel.org/r/20220703102359.30f12e39@rorschach.local.home
>  - Just use a fixed size array instead of calculating the
>    size needed for the dynamic allocation.
> 
>  include/trace/events/fib.h  | 6 +++---
>  include/trace/events/fib6.h | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


