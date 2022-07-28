Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAFF58422E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiG1Ovk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiG1Ovi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:51:38 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542325A15F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:51:36 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso1318424otb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XnGDHTUbxO09I7EUC7OMZ5yxrWBrI6pJHcYOupjtPo4=;
        b=BK1/zdu4ObIBvFHTiCTb/Qz3DORwrEepc4L+7Q0hzo3dn7xLWi3puJzo9Qi6cmkxPB
         LC8pft/7qernCwFd4F9I9vY0Cky20FO2lmuyA/DlsWr7zSsEU7vu3U2DLeHPC0W5wl24
         jW465t2Qkoffqv2G3SA4kh0nuDw/05G5Hvl01eSuHdB/gbQ/rZCD0kvUyEBzxVSYQ/U6
         EDbP1UrO+KpypZ/Lgv2NYRaTicqLM/1a/6iNQLmKqwZQWUuOY1MJJeJXEsKBzBzGWj49
         qNqSO0gu8IqaSdam77Hy3W+salW92Or+X0pNAitdnux1hzxJnTPg4i6zmJCmHU0erAnV
         naEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XnGDHTUbxO09I7EUC7OMZ5yxrWBrI6pJHcYOupjtPo4=;
        b=ZgGA5hw6hP05C4dCFfUPKfWk/pE6daz8UyI6lPn3wYNoEWhe9TtQCoKpItWkpK7KsO
         MTmkaHE1SWWP2lv9DvTqiwGydrKNo7q5VOj+3/1xZHifr9+3Gg3WV97+MrCEZMMy+Xis
         o0YjsstcrY+yXmWXOhCWRaTo1v1RNj52slI8Iefba1xWKRlzAq9P/kf6A0mBqkYURl89
         sdeq2Vv0nVffYBb/q65E95650z30iBUE17nf6plD6Lqc7XCaroi8rajPzoAAbHYkIjDP
         B76Ia3vNOMnD6UYMoGexKCwZFl3ggqew1Cr2d3i8yaRDBtc5b7uxKmQuvhqMctrBbGdr
         C+UA==
X-Gm-Message-State: AJIora+/A9FLxauXMZ4CXIaOkolW/fzj+wxUpbatze3b3kvNdQ1134Jc
        ysvLgSx9WNObmQprTxLTaOs=
X-Google-Smtp-Source: AGRyM1vuYPX5hitOcVs/BNIF689RE2MBV6dKRuHCESVPpj1szSstwqVRdXV9yxIhDOr14FbPk4yYtA==
X-Received: by 2002:a9d:798e:0:b0:61c:9eb4:be3f with SMTP id h14-20020a9d798e000000b0061c9eb4be3fmr10123238otm.380.1659019895641;
        Thu, 28 Jul 2022 07:51:35 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id cg4-20020a056830630400b0061c7e5d270bsm347711otb.48.2022.07.28.07.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:51:35 -0700 (PDT)
Message-ID: <30ce6782-cbb5-e2dd-c845-13e67ec5a571@gmail.com>
Date:   Thu, 28 Jul 2022 08:51:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 2/3] netdevsim: fib: Add debugfs knob to simulate
 route deletion failure
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com
References: <20220728114535.3318119-1-idosch@nvidia.com>
 <20220728114535.3318119-3-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220728114535.3318119-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 5:45 AM, Ido Schimmel wrote:
> The previous patch ("netdevsim: fib: Fix reference count leak on route
> deletion failure") fixed a reference count leak that happens on route
> deletion failure.
> 
> Such failures can only be simulated by injecting slab allocation
> failures, which cannot be surgically injected.

One option is CONFIG_FAULT_INJECTION, labeling functions with
ALLOW_ERROR_INJECTION and writing tests to set the fail_function. Been
very convenient for testing cleanup paths.

That said, I am not against this option.
> 
> In order to be able to specifically test this scenario, add a debugfs
> knob that allows user space to fail route deletion requests when
> enabled.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  drivers/net/netdevsim/fib.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

