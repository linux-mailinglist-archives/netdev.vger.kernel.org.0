Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56A6865BD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjBAMLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjBAMLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:11:04 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575B423329
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:11:03 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id m2so50331424ejb.8
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 04:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WM6sw6argP43wfgX2IID30n7Lw0TYAsS4KPi7DLrG+A=;
        b=nIkchgn/s5HQP5xq4Ebs86HtLsUnH1O6aysEmShWF00ylYzbvTfOi8+jVI5QX39gb9
         BZRxQKeOASHvOrXyZVFYUjzhaAyRIWzl9ytAWCzefDyOtve0HnhH9xxgZ0qeYklhBhP0
         rnRLvYz4r4WB8D6tk/DYhQD9qzjAUpIDmKXBpT81VO30OUCNlzZ0GQk8UwOziulPOO+W
         bEZ5PdXIHhrDcnmhWZyEZdhtQdrl/YUcirzMXLAYq1KBvWWxWZ+c2wOqtGI6UQI8dsP9
         IbZdMfAyJ34ODFX9GEP7S4yUswVFY4fjEWkNzBy9szjKP2BeteK++Lv46x5MLSRuEtLf
         LOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WM6sw6argP43wfgX2IID30n7Lw0TYAsS4KPi7DLrG+A=;
        b=fare4e85PT7GTOj6TyUT7KvCbxCCunQVxkM1UZu0Pr10Sl2X2865f/Bf2sKcOGfCBF
         F4dKiiZNIwjLGXEqgondZj8EKS7+IBpNMh5STnJ7bFRu95nqTsVq+NNWtsna8nzKjQBc
         OnhNs+Ql/K7guIaP6CS/TLDiaDi2Kdlje5yMSmDt3Yr9Zh8ZqdUqalb42jIB3usVPL0R
         oopVzo5jzOZwf13IBK6cVgOa2BaLjbdLYl+ADUh9QonuEjdnUSXZ1JIqUeRJXs+FCXHK
         o2Y8QO/EDHUmkUWZvVpMcznutc8dLsdZFaexxR42nwYT4xTzZJGQyH9ZDjqqixOq345v
         OyHw==
X-Gm-Message-State: AO0yUKVmkT1vE9ocdxAdOjupUmpHiXsCbz2QG5I11OhL+AAmJD8SvmiR
        R1IoV6wcg9TvAuk7BQog/m4rFgYYEbehM1NOWeA=
X-Google-Smtp-Source: AK7set9+lhCrxbX9owq9IWNKk2hczCaRY+ktLdjTgLnv5xkvkEv9ux1gabWDUsIQacbJSSwUOpyIIw==
X-Received: by 2002:a17:906:4b09:b0:883:4ce3:99c2 with SMTP id y9-20020a1709064b0900b008834ce399c2mr2041265eju.34.1675253461831;
        Wed, 01 Feb 2023 04:11:01 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g12-20020a170906868c00b00887f0f8294esm5004199ejx.200.2023.02.01.04.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:11:00 -0800 (PST)
Date:   Wed, 1 Feb 2023 13:10:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 0/3] devlink: trivial names cleanup
Message-ID: <Y9pW0ZKQKXJAvZh/@nanopsycho>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131211813.61210f75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131211813.61210f75@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 06:18:13AM CET, kuba@kernel.org wrote:
>On Tue, 31 Jan 2023 10:06:10 +0100 Jiri Pirko wrote:
>> This is a follow-up to Jakub's devlink code split and dump iteration
>> helper patchset. No functional changes, just couple of renames to makes
>> things consistent and perhaps easier to follow.
>
>What's the weakest form of ack?
>
>Seen-by: Jakub Kicinski <kuba@kernel.org> 

Thanks for looking :D
