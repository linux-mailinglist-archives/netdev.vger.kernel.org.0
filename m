Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F776C7434
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 00:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjCWXmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 19:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWXmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 19:42:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314C53AAD
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 16:41:58 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id ix20so363955plb.3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 16:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679614917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fDpD/ybITO7liyBq9HCXQZTyhMpHZd69iRN42WeD4FY=;
        b=iLQ3E4sQhR2xbDjqbn4tZLin0FUNeeq0Mzd9VqlnovSBTN6zTDZS/ILSjyxz9g7iwd
         TWq/WErRH+OM4xyKU+sY46vYLQC1/nRLswUwkmCWBFD60TaA1G8JKXZXWKn4jM2nPXio
         SEppHnJfbtmUHW8ppJZZ88PmLacgiNzIm2XFpbWOMtMi/eTedy5Nss3xQYEEfwAbd+bR
         pAXJE6plFxzjBlfuHxPqD+ukFBRwrn2gurK7UEi/6xcJdfbzOjtTlkfQIyHpyzqJQro7
         UhtSGeL3l/pvpRY7+tn+8j+TKGaj37QvTr9uwhN9WMUbOxAIpHwpPM8yUh0MzNb1XOvz
         QyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679614917;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fDpD/ybITO7liyBq9HCXQZTyhMpHZd69iRN42WeD4FY=;
        b=am+zcAb8ykhlPoQr7tZ7Rj3RB/ocdpAT8nhsOGC7coCrY3CxHM1njA5fh50GigOI1K
         zIJFn07wu6UYruIzBuEQdBB6t7eSgLNad3NB/wQ1QEviN7Wsy74MZscBO+mZVszQ0kMs
         VI3Xdy31D8+ML9eKQluf1epI+WM5Ei6cc5iiqAVZirEb3tgEiQYWjyo5tkiDcR9fHwcK
         O12vyyHp9swU/ckoju9bOPj70nRjGMDHC9SmEAwPCcpv6bhl2xL39KOHf85fLktRkXg0
         bQ7tX0bJeKQpI9kJgh2R3fSnDYQngh/mVlyOT9XW3pT1w+SAEfIWcv6LhNyEpcqhUMyx
         NqMw==
X-Gm-Message-State: AO0yUKWy/iBUxJLV3oV6CFsQkW6slbwrtBXCV/4e7wFNYthXx6FNn0gE
        JQLlmHtElEdQIfgIgrwAhm8=
X-Google-Smtp-Source: AK7set8AdVzGbcCCjNVl7zNyo4BOMGxVzKW3lhvY72TssjuXEjzdLxYjHFrAK8Xwq2BjAAfihUA0fw==
X-Received: by 2002:a05:6a20:7a8a:b0:cb:ec5f:3c5b with SMTP id u10-20020a056a207a8a00b000cbec5f3c5bmr1038342pzh.18.1679614917450;
        Thu, 23 Mar 2023 16:41:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s14-20020a62e70e000000b00625ddb1f4c5sm12488138pfh.114.2023.03.23.16.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 16:41:56 -0700 (PDT)
Message-ID: <bb32154b-142a-bafb-57be-e4a7bb8e37fe@gmail.com>
Date:   Thu, 23 Mar 2023 16:41:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH ethtool-next v1] ethtool: remove ixgb support
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20230323195424.1623401-1-jesse.brandeburg@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230323195424.1623401-1-jesse.brandeburg@intel.com>
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

On 3/23/23 12:54, Jesse Brandeburg wrote:
> The ixgb driver is no longer in use so just remove the associated code.
> The product was discontinued in 2010.

That is the case with most of the pretty dumping tools that ethtool 
contains, yet we kept them because people might still have those 
Ethernet NICs around, why should we treat ixgb differently here? The 
amount of maintenance for this file is basically close to zero.
-- 
Florian

