Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D37509497
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 03:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383602AbiDUBSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 21:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiDUBSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 21:18:49 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6966712AF0
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 18:16:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k29so3291890pgm.12
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 18:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+I9N4jIKIfkX9P2x9psVpYzNUmL0G2RB/oOphV/ZpCc=;
        b=g4zkej6zOwFRFRa1LQeAWTe14tM2fi4Mnw6vLL/rjL5jiDrkopkz+Cx74nboH/6DV5
         diWL063nsGSr9zbjYZ9cknKeX1QIc7Bu4tgGiKWh5RFt+QQG5jnZtDhNe9uAhF/ytKyL
         3rKJMGpKm4Q2EEbCFWoCECct62oRPWlSsRZpW3mhPLN894tQio39Oqn7iTuUzxohUH+D
         msvdDgYk03dYA7muojIJpw6JqSP0If+KuLumhL6c0luYjHgv8EFWK4dmTamKlMDgPn0Q
         FgJlEiougcJr5NSOXcb+6NLFja1Fm8tYCYyZvmbKGSUTU/BnNg1Hg5KXC1Owdn0/oiZd
         uD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+I9N4jIKIfkX9P2x9psVpYzNUmL0G2RB/oOphV/ZpCc=;
        b=bP8/Z5abW2Kag4W7v4kYIXiQEKGDhxR54XspXHi4Sm4JQT1Jz1aHRhOwzrEEzrLIpr
         BqSS1MBMzJgrBbfejLl/+U4gWqlD4KClbm6sC3953Op2a2ZpypCf+Ct2HtBh6d5ybnLv
         geI9viBbA0BkMWRJPwQed1J2DQvd92vPymGgqP5ug2rotXCZb63/EeyDESrJ+pQYwOel
         drlOyu7A7pU01PhnkAnKoO0zUaNTgFtnuNbvmucm7JXuNnSjCajOYbj5XbKgfXNbk7g0
         BlEWMdjVxs5akBMG+CTIMIuZWJbKTt2uSK2Rvj5bC+Fp8RW/PqQ/p8inyP/t4xVLpu99
         ZpVg==
X-Gm-Message-State: AOAM533BElPBRiMgikbdmEmQPVJ/aowQb6TDS6y+eXotGk4uVH6C+/EP
        XNk/1qRQs0QmzuF76ggXMWlS6aN9IvY=
X-Google-Smtp-Source: ABdhPJwzbXQq+x11JaadtOF20Qyb+UNu39UkQ9rKzidcTt5UzyzyiTgAGNOk8ChsebU1dsLAn6sGXQ==
X-Received: by 2002:a05:6a00:124f:b0:50a:72ed:c924 with SMTP id u15-20020a056a00124f00b0050a72edc924mr19913554pfi.31.1650503760841;
        Wed, 20 Apr 2022 18:16:00 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm22197404pfh.83.2022.04.20.18.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 18:16:00 -0700 (PDT)
Message-ID: <d1db8978-a866-9552-50e6-34507bfcd62d@gmail.com>
Date:   Wed, 20 Apr 2022 18:15:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] Revert "rtnetlink: return EINVAL when request
 cannot succeed"
Content-Language: en-US
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Brian Baboch <brian.baboch@wifirst.fr>
References: <Yl6iFqPFrdvD1wam@zx2c4.com>
 <20220419125151.15589-1-florent.fourcot@wifirst.fr>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220419125151.15589-1-florent.fourcot@wifirst.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/19/22 05:51, Florent Fourcot wrote:
> This reverts commit b6177d3240a4
>
> ip-link command is testing kernel capability by sending a RTM_NEWLINK
> request, without any argument. It accepts everything in reply, except
> EOPNOTSUPP and EINVAL (functions iplink_have_newlink / accept_msg)
>
> So we must keep compatiblity here, invalid empty message should not
> return EINVAL
>
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>


Reviewed-by: Eric Dumazet <edumazet@google.com>


Thanks for fixing this issue.


