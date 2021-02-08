Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34367313875
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhBHPtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhBHPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:48:16 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E615C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 07:47:36 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id 100so7882243otg.3
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 07:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3llYK6EyDFfA8kZNSs7OOJWlhZ6s/Qb8HKdqwTedgO8=;
        b=ESFfJiaCFL4eY4q4WvyNRsh85mck1lW9jTsqET8Sww67i70I3ikh0tET7wS72CAelm
         wflntjM+If6R9YjZ9kKO1hFBjTpcvlpt2LVHiOxwQOg+uSedpp+JneKk87dtR2yk2sca
         KoKVvKqmUrsYlyZ8Q5dcwZVMMd6U6hv6xEvIAFq+aY/lQCUXL1vepaZIR9tsKIa1xEvI
         IyJIPTD0CnjcBWUOjDYMZdbjeiWRBSWpsGHQtcTrVjB215kYrl8BNZ/vqQycG+EgGm8u
         uHaGpzyll1gfnRH2i6iPU7tdQg59cjlcEK5IxiUPmJsl/jfd1FhhxMuYA8fkwVG5xoks
         nwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3llYK6EyDFfA8kZNSs7OOJWlhZ6s/Qb8HKdqwTedgO8=;
        b=XpBp5lFdtMlZpe3L8DIEowdUj6SVMXnFfy3BTeixtu1CxD8/1Ee80uUhwUY1DifL53
         gQIpkn3u3OjBDm6NP52VsPZMFDbzKYuHMRBe/rl2qlOXklA/9Dqog/5dhrpgWBrDQjJl
         RqfPp00WnWSESdvhyH1eLWGeFS9heRZf5d2IQQn+9K4bGn50r2TJLs3X284KzMe+diww
         QdiuIDU3XEptReIo2K7VCNvhqz2pYNtlcK3lVgcdyS8g7FdzpT6fOXFMx9qYIjCCYT0R
         KlsWFrU2V81fmwc1N089YGaULXbCwOpwrngkIXpwEP9zF188kRCF/jXh/DAatF0dpH6i
         fyVQ==
X-Gm-Message-State: AOAM530HVCVmzjZai+kHAoQj8+GKxCgullvXsSw4ZFioV622E5tHMtcU
        /ky6WciO0hGf2ce/D9oIgMuwW7c06cM=
X-Google-Smtp-Source: ABdhPJy2GUhGzsWbeFPXb0qDuygljGJyPkEu5FAA1xJ95adlTJe/TOS9MSdXg50puyxW9sEzjdlLkQ==
X-Received: by 2002:a05:6830:4b1:: with SMTP id l17mr12544140otd.119.1612799255732;
        Mon, 08 Feb 2021 07:47:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id j68sm3712233otc.6.2021.02.08.07.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:47:34 -0800 (PST)
Subject: Re: [PATCH iproute2-next v4 1/5] Add kernel headers
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, mst@redhat.com, jasowang@redhat.com
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210205181029.365461-1-parav@nvidia.com>
 <20210205181029.365461-2-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e3aaccc1-4a73-9438-2b76-e73cefc3383f@gmail.com>
Date:   Mon, 8 Feb 2021 08:47:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205181029.365461-2-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/21 11:10 AM, Parav Pandit wrote:
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> new file mode 100644
> index 00000000..66a41e4e
> --- /dev/null
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/*
> + * vdpa device management interface
> + * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
> + */
> +
> +#ifndef _UAPI_LINUX_VDPA_H_
> +#define _UAPI_LINUX_VDPA_H_
> +

you should grab this header after a 'make headers_install' which cleans
up the _UAPI prefix.

