Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9E7547AEE
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiFLQCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 12:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiFLQCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 12:02:21 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1566DC9
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:02:20 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id i16so3824302ioa.6
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 09:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3CT8tU6h+btv15XYZvgJKK6KoycrUvY5hKX9hMchPFM=;
        b=PmT9KrSR7CFDkDqF3L7RMZxKbGjXsPluPYBcrATUi3gnWnTfM9dM87NCnVHAS+Qphz
         bAwctz1ni7V/Tj9H6TGy9zP5JyTMIvHpz5f1zSsS1timbxtwQ2mp2tEDQHkvcsgw4bC1
         sQ9pV5xk2yywUKlqg0XWSwPhS3+rqWAUh9SPG7SGFcWSPGPs2F9mjN+ImqaO8cEdTmlm
         XsZgpmg5dXIAynesXGzzyNXkiqXI3CYj2Gb2M17z0i7OYRiCEty0dBhKzgEpzl1L3Iu8
         eUAql962VrAy+ZnOpfhwV2KrDfre7Q+x05hYKSF1RuEq6cCJnlxMAwKFBwr0NRS2hCh+
         IjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3CT8tU6h+btv15XYZvgJKK6KoycrUvY5hKX9hMchPFM=;
        b=mRlOsVn23FgqbAQLU1EaZudmRpVKltVHf06d9Y34+JvJSO9lIiYf3227/+uKtSeV/P
         ENHP0qWe23gi1S+TTk6iuGeHuPbWbQtvbiF6bfG1M05s3ri1qFjKD7oxtTnUkNdKNx5u
         nLm8tOBLS1TD9DdPWO8Q2kykAcD7iw7pBeVgEHDslW36g0Jm2F8EGPtaOqr7uytFExve
         8c5I4I9QdN3vfLroNIU7fxFR0yQwETf1BgqvkCam7jIfM0N9ZKUwstneUwHzUyx4EBNM
         PuaIcHmX/JfppLYgi06myLvlAzaUC7s8trgFzsP3a/ncE9ACS+RXOOS9Lv6VdST7JP7B
         23Hg==
X-Gm-Message-State: AOAM531ha47lK3gxeaDRTdhjqB84XWHIk2LJiWO6hC0o/RAkXd4kD1eM
        0iuJicQrCYpx2Cg8NNmoTQs=
X-Google-Smtp-Source: ABdhPJxH1rTpS7yphKbDEUkNiMMTnKa76xBzCp0p7Ddhli50SnLZb/hADVTJRhy0Bf7fjQlfTx9Mzw==
X-Received: by 2002:a05:6638:d94:b0:331:7980:af97 with SMTP id l20-20020a0566380d9400b003317980af97mr26123639jaj.26.1655049740131;
        Sun, 12 Jun 2022 09:02:20 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:71d0:ca72:803a:2d62? ([2601:282:800:dc80:71d0:ca72:803a:2d62])
        by smtp.googlemail.com with ESMTPSA id y26-20020a5ec81a000000b00665754e45c2sm2740082iol.24.2022.06.12.09.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 09:02:19 -0700 (PDT)
Message-ID: <8529e314-1ffa-471b-a092-e6094295a8ed@gmail.com>
Date:   Sun, 12 Jun 2022 10:02:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next v4] ss: Shorter display format for TLS
 zerocopy sendfile
Content-Language: en-US
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20220608153445.3152112-1-maximmi@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220608153445.3152112-1-maximmi@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/22 9:34 AM, Maxim Mikityanskiy wrote:
> Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
> sockets") started displaying the activation status of zerocopy sendfile
> on TLS sockets, exposed via sock_diag. This commit makes the format more
> compact: the flag's name is shorter and is printed only when the feature
> is active, similar to other flag options.
> 
> The flag's name is also generalized ("sendfile" -> "tx") to embrace
> possible future optimizations, and includes an explicit indication that
> the underlying data must not be modified during transfer ("ro").
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> ---
>  include/uapi/linux/tls.h | 2 +-
>  misc/ss.c                | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 

applied to iproute2-next

