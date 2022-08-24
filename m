Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AFA59F5B7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 10:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiHXIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 04:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiHXIuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 04:50:04 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E612D38
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:50:02 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id d21so12839086eje.3
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=FDpJLbhtdM6md9URR7jQMHftgDkYUcyDJfIkSPdq9mE=;
        b=d5gjz0v7aY6n5P5wGwQzbx782BgVowpoiBI5RgxrkLj6L/g9lrMQ9AhE+71G9MATE+
         uJvRTdqJgNnGYEBtvJYVNdu5LwI8M1/2HpyGb6FBOXwcdwjYmJ8KgVVvxdDzGera6dv4
         3q5W131hSoF3uJaaisLS9DNjImSjaU4Ho+vizuvcY4PlodU//twPn0m3eGNsaUI1lCQU
         7LFWOtzlKvEj5iih8O/NNqP4vrSGLN0gl84ik6Ht/bmgELPR+5uSGVxjRO56VFFt0/R6
         +G1V0DgTNlJoWqP+S21Jnv+oEMUkFU+UU3Q3Ndo5tH45AyOQALCinWCfNaxY2zMiIWE8
         J1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FDpJLbhtdM6md9URR7jQMHftgDkYUcyDJfIkSPdq9mE=;
        b=DSY7krdrtTHgV2jwrUSZPm8aznv8KVG+55/qKvno062CU8FeJh3QtDJ5n8Q8CzRCbv
         5PlcPnH7Qirn50vorRwEZR5gVcXD3Tg17/s4I79OGgiQcjdzHyBVKsXD5c/tvh/EzoAH
         XQVHRkW6ZlY3sWy6B1EiIvB+iLC/8ka+tFrdf4Wv9UNnCkmAFJknvyOHf/qUbSD9wWqq
         m1eIHeP9JeRxexWJSGUAZ6VJ+jXvL9BDQdL2BMG6nMEsGIgTRrMnNaLvgKHTgpl7nYQ7
         UinCPtZVmNRpPCUXMQGepq14BT6/Hu8LYwu3iaCeDgMUcqXh0aPS0wi6rD9PHbT4LJbh
         Hy9A==
X-Gm-Message-State: ACgBeo3mcdjMSx4BNFKKnO+DFuBF7vhCm7ksnKWHvTE5wf10DOjgfWcc
        7TXqcS4FA6/3Y519WlLvAVSCwA==
X-Google-Smtp-Source: AA6agR6FrtussK6V/gTbUUbQSnJf2+9atkG0rsJrKQ2CxcMaGsn4HRP5PmBr7KSSkdVi+OzjFQkoPQ==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr2272467ejb.426.1661331000613;
        Wed, 24 Aug 2022 01:50:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id p21-20020a170906a01500b0072b33e91f96sm825642ejy.190.2022.08.24.01.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 01:49:59 -0700 (PDT)
Date:   Wed, 24 Aug 2022 10:49:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <YwXmNqxEYDk+An2A@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-5-jiri@resnulli.us>
 <20220822200116.76f1d11b@kernel.org>
 <YwR1URDk56l5VLDZ@nanopsycho>
 <20220823123121.0ae00393@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823123121.0ae00393@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 23, 2022 at 09:31:21PM CEST, kuba@kernel.org wrote:
>On Tue, 23 Aug 2022 08:36:01 +0200 Jiri Pirko wrote:
>> Tue, Aug 23, 2022 at 05:01:16AM CEST, kuba@kernel.org wrote:
>> >I don't think we should add API without a clear use, let's drop this 
>> >as well.  
>> 
>> What do you mean? This just simply lists components that are possible to
>> use with devlink dev flash. What is not clear? I don't follow.
>
>Dumping random internal bits of the kernel is not how we create uAPIs.
>
>Again, what is the scenario in which user space needs to know 
>the flashable component today ?

Well, I thought it would be polite to let the user know what component
he can pass to the kernel. Now, it is try-fail/success game. But if you
think it is okay to let the user in the doubts, no problem. I will drop
the patch.

