Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CAC6C3C36
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCUUub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCUUu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:50:29 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FBD18B12;
        Tue, 21 Mar 2023 13:50:27 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r5so19585744qtp.4;
        Tue, 21 Mar 2023 13:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431826;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S6fQDT/dXt+zImXTmZzFAKFLs6eI0WspGBWxjWwpATs=;
        b=bSj3xG+Go7pzPy9klGV77k7bPcvGGvgibuS9UMIqbL1d7b15uf1ORx/lLa7eaJSY+E
         eSHmw6rsyokDbYSMdf25mmeD9eQFPJ0lj9ebq+vmiO8qBKSgFwKMc0FAviAjQqVTv5YU
         OrtqWR6TKAx9QvTPDPBa9fIpWZKQZL3g/nfe4qmgGIj61hC8JD3hqJcjLefJ9D+3xsFH
         LU8uVn4P25pNhqWdbirhBZc1U6Z5BbEyRJEB1h9rNRxJM6MinemQ2R5gatIcjSHCv/8t
         xj7fOXNgThfd38MkL6iSoFI32TtLWjqyB+cbSW8RZAgv4nrieB1ptCgcELto6h2egVxa
         E5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431826;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6fQDT/dXt+zImXTmZzFAKFLs6eI0WspGBWxjWwpATs=;
        b=Zhr7qrCN4OiklFOl/NtbTSehuS22Sy9i7s2Hz9h/71g3I8ueuJaULEiTquQtCZT9pa
         Db0GXtiDzzui/lY/p2wxecy+7IuTwmWTBjKD0ZqSyKSztirUL7QYMJTE9Frn5kNqByNh
         0SJY75j9Ct3dcOCs1ljLqhjylEbvbcLk3eDJgt0WnUZj/GmW4iN4+eXnm8/2ZQ77DiIx
         YU/CqdDiHIccv5kU30MykIWyGsDp3zNBn6HIOkZf08dHpok9x5BYKeH5mhsPin5/kQcc
         CWALW9gYwNx4MgAXDfEFRTtEkcJlTmBAmceXgHsMWaeThf814v4M8Ui5YvLa3MPd9Z3M
         higg==
X-Gm-Message-State: AO0yUKVXYWpwEx2tlGwgcqXRAqkr0Yl80CL5zLlEIT8tq1nX1E5AKVrl
        G9Xzv9Xk2xXVrcE/QdQVaqA=
X-Google-Smtp-Source: AK7set/XFUnAk41UVsRf7k6iGS9p+MknNvGOIl6xD4Ct1/T+iVPPY+y/k8b/Wh1I7sJRyPavTp9sng==
X-Received: by 2002:ac8:5c0f:0:b0:3df:6b5:d12c with SMTP id i15-20020ac85c0f000000b003df06b5d12cmr1910892qti.32.1679431826206;
        Tue, 21 Mar 2023 13:50:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z83-20020a376556000000b007468ed0160csm3688508qkb.128.2023.03.21.13.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 13:50:25 -0700 (PDT)
Message-ID: <162215ad-a1a0-219b-ce83-d307bf101f62@gmail.com>
Date:   Tue, 21 Mar 2023 13:50:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        corbet@lwn.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, pisa@cmp.felk.cvut.cz,
        mkl@pengutronix.de, linux-doc@vger.kernel.org,
        stephen@networkplumber.org
References: <20230321050334.1036870-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321050334.1036870-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/23 22:03, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

