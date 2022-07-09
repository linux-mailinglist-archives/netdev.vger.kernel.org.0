Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32F856C731
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 06:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiGIE6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 00:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGIE6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 00:58:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A81D3F328
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 21:58:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y8so687925eda.3
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 21:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NxdqlDR1KlI4EtAPuQyvzTscyD2gFnPQL9fvtT7tI1M=;
        b=19Tu+/l8OKE7bc7WDDnzMwsw6V9ROqjHB1V7jePYwxeBqqCsBlsZZ2S3uqCsngWRVq
         qCLA0gDnaAXo9BUL/eAkVtuiMAP4gs/T80BKtIgV2hQm5P1rVRcBSyA8PxVXOtdgmhL+
         yPFlgxEHtNWBgKwsTfIo8MXQDeeF3L0BAoYUVUDwqixTSEMatHOCqqoIiheQ8RFeK6lR
         Zv76MSqAm0MI3sycgP7SS5Z9uvccLb+roFTqmkfBhlHVx0lBx8n9kdEfPBG3wPG9V4WE
         atI04TNpZCkYbdY5FQKb6I0RzJpfJZsdJvAH68bzO2o6EjDRTwPUxZf8AVPlasWEfKYW
         YMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NxdqlDR1KlI4EtAPuQyvzTscyD2gFnPQL9fvtT7tI1M=;
        b=5RqeyrwRlA8xP1SEhuB2i7ABu5A76ZFKcimCWWNZV0nfRO2s1GArHiC9OWBhmB7lCs
         LuljQ6U2NaO5mZ9UJ3QRvrqPtG6Vv/HLYVoen5yNBywPFpcSmdn+/kib2fPuxcokSJNb
         ty15be+zv1xBjj8nI5iFaPWYReoQZc02Na2+DF2vdaQ1QU9I3+a7mgMl5VUBJcTLnZVr
         iLjxrnydyhOSfLqunTn7lIppEMBDamgLxkYV7SMf0UjVAHyo17lGUiGd4MR26q7iCSbw
         wf0Y/2QEwTouyC63Yajl7RpbEy3QG0TEzs4+fw/76tcjnl5+gT14UvyYa+XGsiIG7VLy
         Y2RQ==
X-Gm-Message-State: AJIora/AHpMBTUa0XkY4n6OaXl9A/1iXaWxZLZ89VzYc8O2Bat+uzZvX
        N9Uigi0soAUaSTwZsR2PqXBiSg==
X-Google-Smtp-Source: AGRyM1tETDH4EGlzBNU/kLTDJp2hq3tUoBI36teo6Wv7URsZkjfxQdz0qpVaDr0cphqKOtEeF9nWYg==
X-Received: by 2002:a05:6402:12d8:b0:43a:6a70:9039 with SMTP id k24-20020a05640212d800b0043a6a709039mr9243093edx.379.1657342724162;
        Fri, 08 Jul 2022 21:58:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y26-20020a056402135a00b00435a742e350sm347580edw.75.2022.07.08.21.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:58:43 -0700 (PDT)
Date:   Sat, 9 Jul 2022 06:58:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v3 0/3] net: devlink: devl_* cosmetic fixes
Message-ID: <YskLAocOeYsZVQCJ@nanopsycho>
References: <20220708074808.2191479-1-jiri@resnulli.us>
 <20220708151717.4fe3487d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708151717.4fe3487d@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 09, 2022 at 12:17:17AM CEST, kuba@kernel.org wrote:
>On Fri,  8 Jul 2022 09:48:02 +0200 Jiri Pirko wrote:
>> Hi. This patches just fixes some small cosmetic issues of devl_* related
>> functions which I found on the way.
>
>This version does not apply but lgtm:

Okay, will check, fix, repost.

>
>Acked-by: Jakub Kicinski <kuba@kernel.org>

thx!
