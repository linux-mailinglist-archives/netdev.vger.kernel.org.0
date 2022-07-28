Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC7C584260
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiG1Ozs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiG1Ozb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:55:31 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75446E891
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:54:07 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-10e4449327aso2624437fac.4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 07:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LUiprayIKKrpsOsnRIOA6ZWU6xNcXRLWidArFTNKulQ=;
        b=L+vdvoOWJwh8J5dSZPHQWF6qmD/rIz8Gg/hvF/GSP9WGQ8yGF0j1RHbYwKmgI4nz1s
         FNWFpyPVMIU6glP3L+jI9S3Krzmka9KKcySVK/pHteAxS3+D8SNAhFVjaowteMG8P4M2
         nAaQhsGJwG7Jm5TMOXMhykXeHR9879SC87FlsqxovpPdw0rusKJXtepptMzmhnG8SpdA
         39xwbLUW5R2rHock9bgfBUSTwT2trt1UqImBZGLdY4Ak//InBWEuu2HK3ZGxrbji8/6R
         9P16EfpwPMEGyw/iHJwi9nBurArcdX3ekbFQg2nfBuFZXj5Hi/xIjI5SxG92pgfFN+/Y
         z7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LUiprayIKKrpsOsnRIOA6ZWU6xNcXRLWidArFTNKulQ=;
        b=e3EOqV8MM/V6/3NcU9J9L+nF4BJsjXP8VG76rVnIGh0oYQV75KhaCHKuCjULHKPpvY
         2ZypmEXdclYAXeZzeve45wuNFz0xhosk2afLZFUT2kiR0WZsFMyLS3mPds+gjMuqGUax
         W1coC+Zsk5X+Sm3jdBktl0r1qP1iuuNybWPiA0GNSKlnF+mCwHKyFT4NEj1c5VWlek06
         +UyLLAOppitcUgAp4qCsgmzRy9alVpelIa4qtM9HFf8kuEqmyOio3ZWQbopFJl2H04GP
         Qhkn+yL7uEfTk5qkb9svnHS07z+Yvttsy1LKEY9kthALVkKJVZuWzaUotEZVDz/ZVdfJ
         I2Jg==
X-Gm-Message-State: AJIora+GUqunWOA3gZQ2siU9DNnPNgw/DTDRh4q1wUJmgnSdfXMkeYIS
        Ae6KV5H5lseXnboV8iBX4qt7ud7OnaA=
X-Google-Smtp-Source: AGRyM1u5i59EwI0/+lsMrSjMl/uyZtv6VQyGueoon/psJh2tdu38AhGIXoXBwk/bxbtl9OeC1dU6rg==
X-Received: by 2002:a05:6870:c150:b0:10d:ad75:741d with SMTP id g16-20020a056870c15000b0010dad75741dmr5187348oad.228.1659020040905;
        Thu, 28 Jul 2022 07:54:00 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id r15-20020a056870414f00b000fb2aa6eef2sm446820oad.32.2022.07.28.07.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:54:00 -0700 (PDT)
Message-ID: <f1a52282-fab6-7b71-dd89-fe647c7eec6b@gmail.com>
Date:   Thu, 28 Jul 2022 08:53:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net 3/3] selftests: netdevsim: Add test cases for route
 deletion failure
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, amcohen@nvidia.com
References: <20220728114535.3318119-1-idosch@nvidia.com>
 <20220728114535.3318119-4-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220728114535.3318119-4-idosch@nvidia.com>
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
> Add IPv4 and IPv6 test cases that ensure that we are not leaking a
> reference on the nexthop device when we are unable to delete its
> associated route.
> 
> Without the fix in a previous patch ("netdevsim: fib: Fix reference
> count leak on route deletion failure") both test cases get stuck,
> waiting for the reference to be released from the dummy device [1][2].
> 
...

> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  .../selftests/drivers/net/netdevsim/fib.sh    | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
