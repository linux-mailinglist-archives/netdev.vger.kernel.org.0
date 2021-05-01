Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B0D370443
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 01:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhD3Xw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 19:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbhD3Xwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 19:52:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B46C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 16:52:06 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j10so19460266lfb.12
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 16:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=MzrZHB7/Z0FGIX3rIKLeCfsFRHC66+BZJEEMuHanHfE=;
        b=OTMnKYmG84eP8CNNv5WoN5mLgrxjDMxD26BN/DVJifYDm1wfVD/XQ/Tj7Se8hZdKCS
         srEGMbmnCFWEVYP64f8Rd9y8NuJa8QpXuza/PxPKTonudOGh66/lHUpWDBWX79FBWRo7
         tI5hgi91oK7DlwtxenS9VqVAWlaYcBALGKJeGx5y3NbhUzi91HC+/QK+XAlNs3gTkri6
         lWsqVIDkSzJDifHhrgbK/S5+cmDElLVe3OvjS84acobLlihpw+O2B9bM4xEsqi5HyqnO
         6L7ZTXkLHG9zYtRmG7zp5b0boNUKiEKwTDNp5Pqg2sHw39HACAuMoXGdvs3OH3k5p864
         /QQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=MzrZHB7/Z0FGIX3rIKLeCfsFRHC66+BZJEEMuHanHfE=;
        b=AO3wcw7n2oeQt77L5ya9MVmhC5kZb8S//pSKa+2WzTHBSzvY9Xdt0qS+UmGK6gmnMe
         yIXobnYsuSw7pQ3xduz+vz1+uNVdZI+twaCnhtxoFdbAs0j7ERNYgkEmLvKFI3qzB0KB
         oiCJBP3ulLH0+vs2LoaS6dhu3O9RoILQMj/5fvQ/vctLH4IW+2oSH69rYj3j1FABZw4g
         w4gi/7D66ME+RRpLIizw2PL4G8cQdoxcgS6RSHvQXI3QsE0GjLpQCilymj0qCZEvqDaV
         B9rGGeOetkuQKx28QOnv7qJNBWjogGAS6z27NwUfYtoZHhbeLvJRZK6Zm1MW4TAI44FL
         cP1A==
X-Gm-Message-State: AOAM530AflF5crhLfIHuHKqYLR7n3UAsukpZA26nLA4fYIoqdxzzrPrl
        dRzZaXtAWK8+FH6q71aa7v4=
X-Google-Smtp-Source: ABdhPJznODGJe6J6kX0jHRjp0v55+jAUXFO+XzWgzZQIa6M3A+0flObBv/uP+8wgOjDn8+sAWuWfPA==
X-Received: by 2002:ac2:5109:: with SMTP id q9mr4946928lfb.88.1619826724741;
        Fri, 30 Apr 2021 16:52:04 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id a27sm426964lfo.190.2021.04.30.16.52.03
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 30 Apr 2021 16:52:03 -0700 (PDT)
Message-ID: <608C9A57.5010102@gmail.com>
Date:   Sat, 01 May 2021 03:01:27 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
References: <608BF122.7050307@gmail.com>                 (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>        <608C3B2C.8040005@gmail.com> (sfid-20210430_190603_013225_96A76113) <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net>
In-Reply-To: <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

30.04.2021 22:02, Johannes Berg:
[...]
> The more reasonable thing is probably to just rework the locking here,
> but that's a touchy subject I guess.
>
> How about this?
>
> https://p.sipsolutions.net/5adbe659fb061f06.txt

Is it supposed to work correctly for unmodified 5.12 kernel? Because it 
applies cleanly, but the resulting kernel never finishes booting. No 
panic happens, it just kind of gets stuck forever. Likely somewhere 
within this ip config steps. The carrier timeout countdown does not show 
up, but console scrollback magic still does work, so it is not a 
complete crash.


Thank you,

Regards,
Nikolai

> johannes
>
>

