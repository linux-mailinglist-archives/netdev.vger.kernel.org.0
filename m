Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA856360A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiGAOnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiGAOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:43:01 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F03B57239
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 07:42:21 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id n12-20020a9d64cc000000b00616ebd87fc4so1986366otl.7
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 07:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i/iA0fvSFFQNbAsaN4A4tn5aME0OlHBea28QDQaOjME=;
        b=j5e/fQA7tXiam4amQ6hiyGX+RNVd+O2Ddg6M7LrxnZOEEWOI/aFGRpDTHjvok8HF43
         rchK5KEKBJSu25QlXAWc8LLbpNuho96OFL5ppc6BJ/twTjBqIegBaa61e5j/ZVGMs2pJ
         dsb+RUz6wg6ZlnUBfgNji/Tq9ohM6/lqGl6zDyKgS94KqkUFePDoOAsQa/TFPsy5gNEs
         +Vn9/LkiDFCemyZpUm4/hgODHF0oF8gjzXs4jYd4qnzNXwAvXgUysJw8EJYxhgCtVXak
         sWyzYePwYiOM5wkrluDPhDZ5N4RY+k82218ORiAedmjAABBnq4/YMd+aNA+6fub6VKT+
         0QDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i/iA0fvSFFQNbAsaN4A4tn5aME0OlHBea28QDQaOjME=;
        b=wAjx+UajlNdIGW5fKa9uojWYejyDhtTSjwxM+rKO4qO+MQ+A8dBl3mJww5wyI6wwD/
         oDblZL82BRu1PQx4RW76RLbJCDsK+WtqXSKCTwD+r0l4P5zWOBXAK39VYlRzckNOhS5W
         MCJ2sR9Jlr85GazPCvk569jmlMDXBTRnYs8LOzDJwkq90iw6kdDN5VqAM9WDdejAS5J8
         0Zm+HStsUMXrI48aHM0f+Uz2fGHjLQXeDPLkSzfiB1LA1Qd7l2eD7z5+UhIFumoURuuS
         EEYfT8qBR5cokiAM1903q307Pf3VB5MFNJfJt0B2GVOE9k8AHXsy/DO6rW7z8eiqPNyS
         CwXA==
X-Gm-Message-State: AJIora/wxjc2Eb4eKt+dVwuL2rqXYhrAzRLFF78BunplZPNSz8mLdQrP
        ZoeJWiJz4tgaOB3aAYflCtE=
X-Google-Smtp-Source: AGRyM1utAQXzOfRWH+q8bTkTxS1DyP6GVjlFjGnuyo5FQmQMO22YoEwAxO1Y0thYDfZW3czFbNKL3w==
X-Received: by 2002:a9d:7986:0:b0:616:b967:503c with SMTP id h6-20020a9d7986000000b00616b967503cmr6725835otm.153.1656686540435;
        Fri, 01 Jul 2022 07:42:20 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id b4-20020a056808010400b0033519ba7d22sm11381398oie.32.2022.07.01.07.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 07:42:19 -0700 (PDT)
Message-ID: <7a9cc617-c903-d9e7-9120-649a3bab86c6@gmail.com>
Date:   Fri, 1 Jul 2022 08:42:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next v2] ip: Fix rx_otherhost_dropped support
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
References: <4148bef3a4e4f259aa9fa7936062a4416a035fec.1656411498.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <4148bef3a4e4f259aa9fa7936062a4416a035fec.1656411498.git.petrm@nvidia.com>
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

On 6/28/22 4:19 AM, Petr Machata wrote:
> The commit cited below added a new column to print_stats64(). However it
> then updated only one size_columns() call site, neglecting to update the
> remaining three. As a result, in those not-updated invocations,
> size_columns() now accesses a vararg argument that is not being passed,
> which is undefined behavior.
> 
> Fixes: cebf67a35d8a ("show rx_otherehost_dropped stat in ip link show")
> CC: Tariq Toukan <tariqt@nvidia.com>
> CC: Itay Aveksis <itayav@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     - Adjust to changes in the "32-bit quantity" patch
>     - Tweak the commit message for clarity
> 
>  ip/ipaddress.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

I merged main into next and now this one needs to be rebased.

