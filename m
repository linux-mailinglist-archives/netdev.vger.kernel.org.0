Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9849CB0A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiAZNlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiAZNlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:41:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E54C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:41:18 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c23so10184895wrb.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+N71zg3iuUOoYIsjVL8hKct1j2esLviVDD9dzeBwNo=;
        b=7J7paDx2alOxVr9gUMdlMUbgAQcRfEaNJXFEJjMinn2FV0q0DYev6UJ40OO7W5biW0
         nEFZsciaOZRWDrB3MxCMt9ib/e6hoFmWgl8phYRMsNVPqGK8fprUv86k8FEofjUyj5rH
         cUV99sUmkXcZ7sUmW8JgN5Mu8TItB36HBjeTsFjaussT3ZmI4MGb/6EHZ1pIR/DBkFuR
         f3YtseGZZHTvP9IEOXkSUnJjzwlWGrZBvbc2KYUF6zy4bGRmYhZi0flbXmDUwHdM9QsU
         Yw6/YmTOe61eOs+2nvawCbnW+pjchF9HN3NabZ8Vb+QEgkqLdC25ecvO3B6CmDu0KGbe
         syVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+N71zg3iuUOoYIsjVL8hKct1j2esLviVDD9dzeBwNo=;
        b=1kXVZVjaJ0lL3Yd+OiskZPqb7FjPNa3tQvRRFYO4dHRNg1tflfxBIVJBY1v+3a/kHr
         /Z9+oq8bYUmwlWZmE56vDa3J9MW3VwCna9EpXbxBGdlRzGKNFecNij06ESt9cwLAW8aG
         ikCwTufvFFXYieTE4DQqMaUnfMshT1GqR6z5NrcZ0FQHqbJr6ciWI6MhfSctaTP/rm1a
         0f8Y3q0eySJgVgT+MEUDTl40LFt6HmFWhx9SF2JwtTSSC4fHXkIjjhiOtcQL4ycliXQy
         oevWPgOvYpmKNN1y0gOUuYR12UGRPfIP17iYswpJITBb2geRQeZ0X3Vy4MIQZfptedX1
         Mgsw==
X-Gm-Message-State: AOAM532x+ozX8qmaFbYQWS1aWf/fK/mfiuzBLclh1OhRFvbDA8gQNa5O
        Hr5YI3SZieNVG1CnSDmaeMqIx/ckBoo+zLiKLOtgOowt8CllTeazVSE=
X-Google-Smtp-Source: ABdhPJxPgl7c+i1X0PaOqzq1D5Bor+SophR6piOsgz90JeRMQchwcKKQ2qC1vgW+4wibvPn3pM9ndthtSsrnk9BP4Uo=
X-Received: by 2002:adf:edcf:: with SMTP id v15mr22536921wro.501.1643204477360;
 Wed, 26 Jan 2022 05:41:17 -0800 (PST)
MIME-Version: 1.0
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Wed, 26 Jan 2022 10:41:06 -0300
Message-ID: <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng <baowen.zheng@corigine.com> wrote:
>
> Add skip_hw and skip_sw flags for user to control whether
> offload action to hardware.
>
> Also we add hw_count to show how many hardwares accept to offload
> the action.
>
> Change man page to describe the usage of skip_sw and skip_hw flag.
>
> An example to add and query action as below.
>
> $ tc actions add action police rate 1mbit burst 100k index 100 skip_sw
>
> $ tc -s -d actions list action police
> total acts 1
>     action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
>     ref 1 bind 0  installed 2 sec used 2 sec
>     Action statistics:
>     Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>     backlog 0b 0p requeues 0
>     skip_sw in_hw in_hw_count 1
>     used_hw_stats delayed
>
> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

I applied this version, tested it and can confirm the breakage in tdc is gone.
Tested-by: Victor Nogueira <victor@mojatatu.com>
