Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AE528AB97
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgJLCIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgJLCIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:08:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4E5C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:08:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o9so9951684ilo.0
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H03qBKsscBeXpz6bYBgjhyN7Mc/3xUrd+ba59zX0ak8=;
        b=izCW822eWhYBXAGHcqMU9XeDR62k2ohH99rleUnRXfeuqoAx8vv4jihzqF0E8Xnsum
         5ZFoGNlEXZs5F+9JtpJlecIuUBYfey4xp1Pz7rEe8jKedUlbZs8IS1Da3tr0PHBygGQf
         inAyO/SnuduE3Jl+/QTooJpDPXrTp1hGWRP10/y9Yej/62wr7Yj8v6rP8OA+ncXVY0f+
         vWCUZckl111Jvogk6Ef60lEqqe8PXwBkptYLhULa+7DZTl+irV0unczSXAZJD6Lp3kGv
         +NtvNo7xKChvy/jvxXNCP9jXytiR4JpaK93f1Kmw4tbI+esI0Ohnz0PSKrP8tiFl5Xx2
         wNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H03qBKsscBeXpz6bYBgjhyN7Mc/3xUrd+ba59zX0ak8=;
        b=Oz8YJl7SbgueKWRen3Zppt0n+2s+Tf+XBwqmvYuLsa2fblD7r6cNfxyS1wLIDwYOJm
         RNETam7OflEwE4l9h8vNhCKqK7szLw7AXSgxX7weNTKX12k0SoK6pJTUCd0aAC6UoEiO
         4vF2IXCozX4xYh1SPC8u/i0Abgn7QxLeoHrJygnsYXBuIrGXlqA1o4sP+6iWOakiZj4N
         2oEqUJlK6wpcQCf539YP1+GPQrYBGEDjHhbbf1kTRqC8uigFx+0YV5NkUMgZu3/6/E8I
         WUbQgfm1/BOP7k5Z7DSKpcbGFGSta6+wWK9rGv39blnQW8IkCfQ8ZuOWtJvS9cHrJ/71
         94vw==
X-Gm-Message-State: AOAM530nkXcLscviAXXBMdXpFMwF7FhlLlmJaOnejRJGd7wB3NkeKtMh
        ogtFUh6H1XPY5cEF0MV09XI=
X-Google-Smtp-Source: ABdhPJwkSCRO4pBJ7IuOZ0uezz2I4SBLbhXA1Vzb0Snkh/P0OuLH8uuh9CeNksA2a/RZt7DhmprIpA==
X-Received: by 2002:a92:360d:: with SMTP id d13mr15149441ila.99.1602468501427;
        Sun, 11 Oct 2020 19:08:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id m7sm6712157iop.13.2020.10.11.19.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 19:08:20 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/6] bridge: mdb: add support for
 IGMPv3/MLDv2 attributes
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20201008135024.1515468-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05f5cd5c-6dd8-a153-64ed-03b1d850d5d5@gmail.com>
Date:   Sun, 11 Oct 2020 20:08:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 6:50 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds support for IGMPv3/MLDv2 attributes, they're mostly
> read-only at the moment. The only new "set" option is the source address
> for S,G entries. It is added in patch 01 (see the patch commit message for
> an example). Patch 02 shows a missing flag (fast_leave) for
> completeness, then patch 03 shows the new IGMPv3/MLDv2 flags:
> added_by_star_ex and blocked. Patches 04-06 show the new extra
> information about the entry's state when IGMPv3/MLDv2 are enabled. That
> includes its filter mode (include/exclude), source list with timers and
> origin protocol (currently only static/kernel), in order to show the new
> information the user must use "-d"/show_details.
> Here's the output of a few IGMPv3 entries:
>  dev bridge port ens12 grp 239.0.0.1 src 20.21.22.23 temp filter_mode include proto kernel  blocked    0.00
>  dev bridge port ens12 grp 239.0.0.1 src 8.9.10.11 temp filter_mode include proto kernel  blocked    0.00
>  dev bridge port ens12 grp 239.0.0.1 src 1.2.3.1 temp filter_mode include proto kernel  blocked    0.00
>  dev bridge port ens12 grp 239.0.0.1 temp filter_mode exclude source_list 20.21.22.23/0.00,8.9.10.11/0.00,1.2.3.1/0.00 proto kernel    26.65
> 

applied to iproute2-next. Thanks, Nik
