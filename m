Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F5957384A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiGMODX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiGMODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:03:22 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BCE2D1CB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:03:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l23so20034749ejr.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DHixGE+cr+K21WVSLKuNnxetOA0/CHewD38dOxNk2Vo=;
        b=uvdwYiasqC8LljyPpgNSvvOamtKs7faaTvV+aXGpUR6OP/GjJpRCeqU10kdXkF1PzJ
         U6j9h5r++qqjFixuKfUyoYOYjyAOaJ678qIxvUvPFCqwXI1w7zva69npnel1M9/2P+ad
         ngzXL9pS+yyagD1tMq7xl9Ht9Fb8cKXXwIIsitsgdfHTbg7L7mak71FWuoEzVtXWqy7E
         bNUwgfLuibBihRWxTYSP0sq1eYTJH5+xpldxAMQ3oGTAYD2paYHi2awZqpUMYmCvyRlu
         Kvnj745jAPul8VCOfQXlDqu8xBK3P67BOl3HlsPYgmUiZVVexTEoUYVMxrz7zrR1k1d9
         PkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DHixGE+cr+K21WVSLKuNnxetOA0/CHewD38dOxNk2Vo=;
        b=wlb2uKy4uM+H9Ltdkk710c/ukfec4cwmv1IpWrzholsp8FvF4j+LKAeJoyuQV/mv2z
         XnfzPHz47yRRNEHcxO2hjxjUij1hymD8LD4ZIvpzBQndu1aA08RHmr7d/tSMt26fl+Iv
         4TfI2u2EmtY7UEo17HmlQKYqvirm1J44cPeOIxIKE10RYhGGFZ/1Gosh7mM1jfwG9NQ3
         bt+cu4MdMRe1s/O1aNeB5GtghB1ryc6hSMDlnZDfNU+uinAWTsKLY5iUIjnFYLGH1ryN
         7xVJcSfY8mKjwLVzhlig4KTeRvjJT/eR5LPU7gEpJU17zV8jIOiNzgUlo04tm3MTF+c0
         uiCw==
X-Gm-Message-State: AJIora8bqlUFO+ugfMsHoCdfsLvwM+W6WO5IBn6qQL1hKoaXkiUEUgvs
        NBPcvIwI5dH9JNZg0SJy/BopIjr/Fvbw73meucI=
X-Google-Smtp-Source: AGRyM1vbA7azS4D/mdcqzbsEJ8h5mfaH4dCarOntsFGzIYEXBKzqk8LERQLreR/J0/EPUa3de8ks9w==
X-Received: by 2002:a17:907:7dac:b0:722:3352:ac05 with SMTP id oz44-20020a1709077dac00b007223352ac05mr3699271ejc.421.1657720999535;
        Wed, 13 Jul 2022 07:03:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g25-20020a056402321900b0043aa17dc199sm7889793eda.90.2022.07.13.07.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:03:18 -0700 (PDT)
Date:   Wed, 13 Jul 2022 16:03:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 0/3] net: devlink: couple of trivial fixes
Message-ID: <Ys7QpWEVIh7NfrAx@nanopsycho>
References: <20220712104853.2831646-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712104853.2831646-1-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guys, this is incorrectly marked as "Changes Requested" in patchwork,
however I got ack from Jakub and no changes were requested.
Could you apply, or should I re-send?

Thanks!


Tue, Jul 12, 2022 at 12:48:50PM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>Just a couple of trivial fixes I found on the way.
>
>Jiri Pirko (3):
>  net: devlink: make devlink_dpipe_headers_register() return void
>  net: devlink: fix a typo in function name devlink_port_new_notifiy()
>  net: devlink: fix return statement in devlink_port_new_notify()
>
> .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c |  6 ++----
> include/net/devlink.h                            |  2 +-
> net/core/devlink.c                               | 16 +++++++---------
> 3 files changed, 10 insertions(+), 14 deletions(-)
>
>-- 
>2.35.3
>
