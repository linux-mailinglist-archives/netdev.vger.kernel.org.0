Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F73515147
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359643AbiD2RJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 13:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiD2RJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 13:09:13 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7E27F201
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 10:05:54 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e5e433d66dso8720188fac.5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 10:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=jnCtyXnESVbchZJWJZYW28GNNZvgABPwKrO6SozJwzs=;
        b=bPoBi1YAZsJTWrA/ZdRHRXaVulHPlcKW1cma6SzYu9pZWqGe/3kdUgR90zifXX5wVW
         ZEZUbGQRZoIR6K3+alzmSuvyHCnnDl+gBtjsv0QTrQzq5GfmDOeXPzMIQCLlSoIWj2C6
         dAXwhrHF6efP+QlTTFu8GyDtxnchRoR/rnExNn074cqA0aBF6bBTuKJic3cMCRT4OaJ4
         fqKMD6ikNKXPNzDlzA4jylHu++DflQLatPXNEXcHZa1l2r3FQIYalBmudqlibGa2ZRVf
         4fSLhf96V6sFtjx02T6iUc2JKIiphNsejTbytvAE6dsWrH+D761KIpZfPN+3qB+Iyig1
         JA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jnCtyXnESVbchZJWJZYW28GNNZvgABPwKrO6SozJwzs=;
        b=0SeTJzAzTyt8LD98UZhA+IQBRYJJ57Netcu7yxFIG10xdBNOrOAyMUNSCsNlQ7RXWM
         eaz+aU8wFbVU7TCzrtRMTHcexzSOdK7SmOwjYhf8QZ7BF5ZYJj88v+SESp9KMAOBZfeH
         j1akFgMaum7MOD0kiMwArJ0Gwjc/QR8jjamGX1oqL/FdZgKIy2JDy3VmLRUtVk1Cj5s7
         O8zEy23LXLsYJ5fA8TdNuTYZW/mbZf+5B3e2tMGz9EX0o+E1B0WoUYecn6UFmvN4iKdu
         LbX1baqRJILs2K0sxyGNiO8TT6cdRhdwo4p68Gj15IUjC0YqBKQxqO7//yZ+HGzM9bfe
         o+2A==
X-Gm-Message-State: AOAM5339R/5C77sHtTrRLMlO8PeU9gnR3E6Bd/i8ZAelmYxmQNjwf+yn
        DaKPF8fnAcSaYYRm3EW4Nyc=
X-Google-Smtp-Source: ABdhPJyNcQuLw0ifPKxmkw5JvY7VEa1Lt5XOsdxB612ehcujy7YbtWBAGWZLtRICdNpeuERvfz9iaQ==
X-Received: by 2002:a05:6870:889d:b0:e6:170e:a37b with SMTP id m29-20020a056870889d00b000e6170ea37bmr1725074oam.38.1651251954058;
        Fri, 29 Apr 2022 10:05:54 -0700 (PDT)
Received: from [172.16.0.2] ([104.28.224.252])
        by smtp.googlemail.com with ESMTPSA id 5-20020a9d0105000000b005fbe5093eb0sm1257355otu.54.2022.04.29.10.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 10:05:53 -0700 (PDT)
Message-ID: <c1070b15-ee51-c487-7081-5e1048a1298c@gmail.com>
Date:   Fri, 29 Apr 2022 11:05:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4] selftests: net: vrf_strict_mode_test: add
 support to select a test to run
Content-Language: en-US
To:     Jaehee Park <jhpark1013@gmail.com>, outreachy@lists.linux.dev,
        Julia Denham <jdenham@redhat.com>,
        Roopa Prabhu <roopa.prabhu@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>
References: <20220429164658.GA656707@jaehee-ThinkPad-X1-Extreme>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220429164658.GA656707@jaehee-ThinkPad-X1-Extreme>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/22 10:46 AM, Jaehee Park wrote:
> Add a boilerplate test loop to run all tests in
> vrf_strict_mode_test.sh. Add a -t flag that allows a selected test to
> run. Remove the vrf_strict_mode_tests function which is now unused.
> 
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> ---
> v2 
> - Add a -t flag that allows a selected test to
> run.
> 
> v3 
> - Add commented delineators to section the code for improved
> readability.
> - Move the log_section() call into the functions handling the tests.
> - Remove unnecessary spaces.
> 
> v4 
> - Remove unused function
> - Edit the patch log to reflect this change.
> 
> 
>  .../selftests/net/vrf_strict_mode_test.sh     | 48 +++++++++++++++----
>  1 file changed, 39 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


