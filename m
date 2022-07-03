Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C436C56496D
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 21:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiGCTD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 15:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiGCTDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 15:03:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EECBB95;
        Sun,  3 Jul 2022 12:03:22 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r133so6891211iod.3;
        Sun, 03 Jul 2022 12:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=N/hfDHgaxHAakJzchEJ/4/Y/HRFxdcAGIY5tPydeUHY=;
        b=eN1OjZnhKpjiEgzapN6o7aflY2fgPbUgQMILpQhzk4fX9tHBv533BND/9t0j23M72C
         wDt68FDErSmSFhQkgG4erOhf08/ZveqRy75ZJ3y5fPQWTyNVsmGX3RAI/zx0RK3VWBqi
         yWSDCiNHBiT3V8QMceYnGHvA1gddF8zk4RW+kK5BIUvq5D0J7mOuXHCTj+ud2CCvL2AI
         thc0Z9gPFGusjQUtLsyezjcCw0pBT0nkoekCxf/JIVz0ovM2YhvW6Vzf/rKq6sXXIy42
         WjfUiBG5i7F4h2SwZkX/J3Qsq6nZ4+pxQaVpjcMsRb6gQWlEApeS1WPEgxhfYpBg3hSC
         C1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N/hfDHgaxHAakJzchEJ/4/Y/HRFxdcAGIY5tPydeUHY=;
        b=sENQuyTc9eU6WiWJP3iRo+wcTz0AT5mrp0n9SCHUxeE3U659ADGGpCUhmaU7hLOyZL
         WF0KdBvkrKg4XEr6oI0zlI/aAhrZYXx9IAHNpYEJb9aaF2y39jkghhAvnHaYLll8+O7S
         ZV9SjDrGwmLSk6j5HivKPLDbjfPPVo3x6PCGaBqQcDpMNcn6bjfeJZDBAqk8foXakDVS
         8O3eNSU+PTdFewhO0Jlyepi06bBhevpPAmCor/gT/4ecYd6Dm77kIoRM2xQd30Al9i4Z
         5xBnFjfLcEXW9MgSah9eevxefIhQ07LocZpjefbLdFtWGBLzF0XtYvDJi9k2PJS3L1zp
         DTUg==
X-Gm-Message-State: AJIora88Ps66FZoSlqFh+9q8GDdDPtTgHMwnYOextSKgbohG7gnPB8eI
        l4VBn9susZ7A2OjkR4+ngW1xigznnkA=
X-Google-Smtp-Source: AGRyM1vXDA8eB3zspqQjNPGyWThoxaY3+uE6kveF7delyXRBtL9Eew2vL4LKz2UZt3nKr+UtbIbE1A==
X-Received: by 2002:a6b:4019:0:b0:669:3314:ebcb with SMTP id k25-20020a6b4019000000b006693314ebcbmr13597382ioa.197.1656875001784;
        Sun, 03 Jul 2022 12:03:21 -0700 (PDT)
Received: from ?IPV6:2601:284:8200:b700:89c9:fb3c:ea5:5615? ([2601:284:8200:b700:89c9:fb3c:ea5:5615])
        by smtp.googlemail.com with ESMTPSA id p7-20020a056e0206c700b002d11888a1acsm11271134ils.34.2022.07.03.12.03.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 12:03:21 -0700 (PDT)
Message-ID: <5f25dd4a-7394-cf97-4fc8-c43f0c449fc7@gmail.com>
Date:   Sun, 3 Jul 2022 13:03:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] tracing/ipv4/ipv6: Give size to name field in
 fib*_lookup_table event
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20220703102359.30f12e39@rorschach.local.home>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220703102359.30f12e39@rorschach.local.home>
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

On 7/3/22 8:23 AM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The fib_lookup_table and fib6_lookup_table events declare name as a
> dynamic_array, but also give it a fixed size, which defeats the purpose of
> the dynamic array, especially since the dynamic array also includes meta
> data in the event to specify its size.
> 
> Considering that the intent was to only reserve the size needed for the
> name and not a fixed size, convert the size part of the __dynamic_array()
> field to contain the necessary code to determine the size needed to save
> the name.
> 
> Alternatively, if the intent was to use a fixed size, then it should be
> converted into __array() of type char, which will remove the meta data in
> the event that stores the size.

I would prefer this option over duplicating the all of the checks to
save 14B.

