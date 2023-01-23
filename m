Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A810678A19
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjAWWB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjAWWBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:01:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FFA59CA
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:01:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so12262383pjb.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMUkSW4Z4PcnohOPsROX16mh4NjMEy32MddaWz1jAtE=;
        b=obuUsLwREPM6WthLUntxfNEzD6RczQVUlfKXcLSoUH2vL3FBjm7tL7XSnPzFTxIkqH
         gDADj8+jhugh58Zm0Pi4SGe/UyrpUcu5dlkp6yRGtepnWjnRQNErst82EDz/TR7D+Lw0
         UfI9o4KPwnkGVJvHjvCrF3gSIj9hstLMGaTBBffRcAF2BytKEdD0lRuR1FrdoKAf+yLe
         +bl9EbkHgXAxMrU01Df84updA8uGIbRukND73/fjc2xzcy0R5yvnk/HxTiDgOYh94/vP
         y81iVlLtrxTcA4cxt8F0kpvRjh7SK3bJh72rhfr2qt69+R8HAa7Zoiz3xbqoaCJLR1uQ
         573Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMUkSW4Z4PcnohOPsROX16mh4NjMEy32MddaWz1jAtE=;
        b=lf/P81u6XVK0/ZRpwmzBuJ759cKvfIFwahcz4CBTNakE/Nj032wwLNRz/C712xg7R1
         WChWR6eOvCX6C6PaoNGZzFxVQyVwSY/+bAS6VTG6cxurTW4L2vu4mfc5U0l4xuz7wY5W
         Ozv63ffcnxXQR/4MWn6fK19mKsF0FgEum+8EF1mRi8DsDlLLGw0pkZnos96mcqyWzMmz
         BOZ2DKod13ooRdV0EQPw0QygxRj70sW2FbqzLrfDGJz0m7d8D/u8tlEapzP46C6Qnq/a
         IprinRdTAlf/pKYv588ys0pWzoTVgS574lAbDh2hmkMhU6mO4azngSWQFI/1JXeCAZYG
         APRw==
X-Gm-Message-State: AFqh2kqM3TsPgYy77OP2Vlq7LUkE7ztJ1f+a3CNOZKL3j2IHRoN1QiI/
        qZIjGZnzGOg3eGoNZN9luYFcSAft3KI=
X-Google-Smtp-Source: AMrXdXsFOhs50VYNwiHfSsnNzWZ+oVRwTa1eQ6eZIVkL4r1yD5iV1DWoU8YccHxv7YR3VOX5ORSksw==
X-Received: by 2002:a05:6a20:94cd:b0:ad:67fa:8e50 with SMTP id ht13-20020a056a2094cd00b000ad67fa8e50mr23534464pzb.57.1674511284298;
        Mon, 23 Jan 2023 14:01:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o6-20020a639206000000b004468cb97c01sm28294pgd.56.2023.01.23.14.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 14:01:23 -0800 (PST)
Message-ID: <20554c4c-bafa-569a-bdec-fc55445531f7@gmail.com>
Date:   Mon, 23 Jan 2023 14:01:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH ethtool v2 0/3] Build fixes for older kernel headers and
 musl
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230114163411.3290201-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230114163411.3290201-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 1/14/23 08:34, Florian Fainelli wrote:
> Hi Michal,
> 
> These 3 patches fix build issues encountered in the 6.1 release with
> either older kernel headers (pre v4.11) or with musl-libc.
> 
> In case you want to add a prebuilt toolchain with your release procedure
> you can use those binaries:
> 
> https://github.com/Broadcom/stbgcc-8.3/releases/tag/stbgcc-8.3-0.4
> 
> Changes in v2:
> 
> - reworked the first commit to bring in if.h, this is a more invasive
>    change but it allows us to drop the ALTIFNAMSIZ override and it might
>    be easier to maintain moving forward
> 
> - reworked the third commit to avoid using non standard integer types

Any feedback on whether you prefer this version versus the v1?
-- 
Florian

