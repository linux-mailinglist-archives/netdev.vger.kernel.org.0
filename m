Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5F6C867C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjCXUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjCXUDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:03:21 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDF65FDC;
        Fri, 24 Mar 2023 13:03:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id dw14so1990512pfb.6;
        Fri, 24 Mar 2023 13:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679688200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k0zyKJqyp2y1lBt0CEJpnXXir3hiSl95FjcrusJ4FJo=;
        b=jdo2UNjWHXf+WaFn7+HpYKqoUyXzC3SUgTio2/Y7sy4RDl3YeM8e62X7aoYuKv7X5s
         QU28EsGLHL47/0tl6EbqR9CKmQHBPlgfhLhm/dcH7cQ3kaDKjJfos68N+ADUNIs6poWe
         9Dgxnx5U8XsuCupYX4tniXuNU48hHUvEHeFQXkvGDAkec4yJR24dPPqIiC/7gJWQCTrp
         tCdEaAobeanFbP/w3ilqIMi9mVEnWiyZL6UvZ0kuu4PZcVL2ZnlY5QgJdNwbQc4aQYFY
         HUy07vIw1exftgNIibxlTdWCyyIe0mrQA2/Kz/H8Xy+B0EYx0OahH2iJfLOlzmuH2RZV
         rIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679688200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k0zyKJqyp2y1lBt0CEJpnXXir3hiSl95FjcrusJ4FJo=;
        b=6H3VwkukIWjCQBIgK4+HDKMLUkkI5ZrJms+6m2Ves+JwA9Lxr2FR+PjmxXFFloTiYf
         SN/XgksRW4BmdgZ/tc+wh2skfWaIoUF2YYQN2bBovNJ1KlPw96DLshFhJ8iXsqC53Tlg
         qAEAf8W0YEy2V7xzqX23wPAJW842X820tkDgBrTGVYMq6RMTvn4gPoUjx1GOwPeidFc/
         UXicQ/jUk1zSSXMQvbVOtTUlZLJgQa0O6MfgEYGUVJhBq5JNYWCA+kMw3ga4GObmrLY/
         MXxIPeVW+7PpKS+se9iY3HvhXhZIe9nEsee6Zhkx+gpnJEcs/Sg+RWRIpx3XznmKsgc3
         A6UQ==
X-Gm-Message-State: AO0yUKVPtn06nszk8JNWywPmdP24FMtJnIj/947GxS3htYNwZEHkJpWj
        dkeMWaieIqlsQGxtxU9Qez0ypf+1g4g=
X-Google-Smtp-Source: AKy350YXw6kZ61/uTa+XbH4rSQJAV91yWnUqZCIZ84aaVCwqLRDcvRmIpfkjybQE5rHmf6ChnAuLAw==
X-Received: by 2002:aa7:9a5c:0:b0:628:1347:a619 with SMTP id x28-20020aa79a5c000000b006281347a619mr4324845pfj.10.1679688199613;
        Fri, 24 Mar 2023 13:03:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a21-20020a62bd15000000b005895f9657ebsm14221903pff.70.2023.03.24.13.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 13:03:18 -0700 (PDT)
Message-ID: <37969f4c-21fe-0d06-f5c1-f110a2eccb0f@gmail.com>
Date:   Fri, 24 Mar 2023 13:02:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2] mailmap: Add an entry for Leonard Crestez
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     cdleonard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Qais Yousef <qyousef@layalina.io>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vasily Averin <vasily.averin@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Kirill Tkhai <tkhai@ya.ru>,
        open list <linux-kernel@vger.kernel.org>
References: <20230324172659.3495258-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230324172659.3495258-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 10:26, Florian Fainelli wrote:
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Andrew applied v1 directly:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-entry-for-leonard-crestez.patch

You can drop this v2.
-- 
Florian

