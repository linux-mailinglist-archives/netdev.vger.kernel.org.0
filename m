Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899E259D15F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiHWGgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbiHWGgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:36:08 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B7861123
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:36:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id d21so6131832eje.3
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 23:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=a1qxDDVjFY05Wu7MGJo6Y/dCYtG8XAWVSuQC3w1MsKo=;
        b=QcaXWu5JXiNWao3V5ufnpbjG2kS/8r0HY8nzXk6gFrAqSboM/DP1V9Mlf09zhNg3tj
         HVUH7h9vpzMjl9gKRbGtWOFubUGnEQs5EdxCrAnwBXGcEmh2dJT31MNH3dtcjW2wKo8a
         t2IvjQMphnMBzNVgRy5f4ms1mvdMDXNKFghQB934EaIM1c5VaZTHo8nJrZt5vq3XIZ6W
         BM7nkzgIxqWeW4B13duO0xIEEDs3Pb5dtr9b8iOjK5pmocMi+li9pnuq5XOkbnQonEJd
         uoxR632oyKqsfmW9WA3AKt2hcSun7im9+Hby/dcJQlFivp+DPxnXUgV9VGIg72feV3iU
         ttEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=a1qxDDVjFY05Wu7MGJo6Y/dCYtG8XAWVSuQC3w1MsKo=;
        b=m7Xp1FcmokAjleC7K12Rh/LjGVTrH9QcJyPGAENcdDIwWjuQjsHxdrXllyU81GXx/3
         1OixrWa0JQLE0n3BlnLeWQ3auU7wuN8je9cqxkfoP7Ej8c7HLn36nZmgl5nwhNOnbwPN
         GQA6356WddwHoEv8vWE04zoLvxDFAsPaoETW0vMO7QiXDjIiNeqAEfH5+G/rU81Fv/F1
         BlqN3QOL7QZwGjfO4mXE+eVkYzR9CWcLJUo8Uv7jgb0U3dsrZlV6RYujIsJdZSxRbpTu
         wXBPw6LY9UoWXRA3+HL+I1CLO/TeZ6i5fGqYs8ssecLR29hCOrvyPfw3Yer1B4geFQGg
         TapQ==
X-Gm-Message-State: ACgBeo3faXNmNoD9/UhVymgTXhV+yL6Be10AkSBji6CLQuSA8PGgae59
        7q+r193Y3b7yTPvANfai2Kc0lQ==
X-Google-Smtp-Source: AA6agR7MC9Y/yvHPTS3de7HugKF4v6dgt8mJShMw+PZl+YAHzpOoY7XJDC2eedSuSAZTpZY3Q//YrQ==
X-Received: by 2002:a17:906:c154:b0:733:197:a8c with SMTP id dp20-20020a170906c15400b0073301970a8cmr15535479ejc.483.1661236563073;
        Mon, 22 Aug 2022 23:36:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kx9-20020a170907774900b0073d5489fff2sm5237914ejc.120.2022.08.22.23.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 23:36:02 -0700 (PDT)
Date:   Tue, 23 Aug 2022 08:36:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Message-ID: <YwR1URDk56l5VLDZ@nanopsycho>
References: <20220822170247.974743-1-jiri@resnulli.us>
 <20220822170247.974743-5-jiri@resnulli.us>
 <20220822200116.76f1d11b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822200116.76f1d11b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 23, 2022 at 05:01:16AM CEST, kuba@kernel.org wrote:
>On Mon, 22 Aug 2022 19:02:47 +0200 Jiri Pirko wrote:
>> If certain version exposed by a driver is marked to be representing a
>> component, expose this info to the user.
>> 
>> Example:
>> $ devlink dev info
>> netdevsim/netdevsim10:
>>   driver netdevsim
>>   versions:
>>       running:
>>         fw.mgmt 10.20.30
>>       flash_components:
>>         fw.mgmt
>
>I don't think we should add API without a clear use, let's drop this 
>as well.

What do you mean? This just simply lists components that are possible to
use with devlink dev flash. What is not clear? I don't follow.

