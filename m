Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99D5CBF99
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbfJDPos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:44:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34673 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389669AbfJDPor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:44:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id k7so3323287pll.1;
        Fri, 04 Oct 2019 08:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GFFmq53ZA+vEvLH+L12DZotI8ZROy3ndHmBfHrJMHss=;
        b=ei/Yx9eFGr127yukJnQzL+G9T8OPFW+B1biEqAV+G5FAYoZeLKyg0Tx44MGMotsI1D
         gXv+eZTIViulRT4kAK8vNaxjuxjh1uWrhPC0IqjnZosRxM9p0GEDuCRSVpHJfHX/b5+X
         SHGIcSbkklnQjOZUww37yJvNvpO6Q2fmz5ADdlJmT3eGyZQeivuTDwBU7deQDlTPaNhd
         3EA18EpxJFxSFRw1JfWEZUZ62wfnZ+3AU0bhQBR7QZH2KOKmkb7pLfiogvxZMOlpdSVC
         YH5RydmJ/pUVQXHHeufXfaVvIPshDY+moUMy+5nm206IKc+8pbkO0Bji8oElJHk0f2N0
         Ay0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GFFmq53ZA+vEvLH+L12DZotI8ZROy3ndHmBfHrJMHss=;
        b=SxcUYgks0A5mTUU7bvdWQwrXb4geBJcrDTx1A94DSaxVcv8zVigHVOOzafRX0waDAU
         JvSvqgC3nU3L0+gLDD/qspl9O1EfusXlTJvMhIgS5lhhCIV95VCAYI46NlgVB49x6Qva
         5FhyLiIDPfrUcPWSpgCzf2eHcg8fL0sLARU64nRxYJgDoPoTdbOwzbEtL85Nt503Mi4X
         rvbg8g8+46lV9DnTCDh8OTgEa4vWD4uCieWCl3AE+pX53C6l9CfChigdTvUw5lpCyWfB
         Vb+GbByRVKkA1fM/PDK8ostkY9LfrOIlHgzovpWnXllbwXq+j33hWRy+2AjlISPPvhUa
         RQrA==
X-Gm-Message-State: APjAAAWiP4Z82D7y2LGtSrola/xxlaI28wldCHOw3LQjKn0DWgx0I7oF
        VuxwbtVo8GgE9EDs5/DND0U=
X-Google-Smtp-Source: APXvYqwvXzjxXxPm7KLjY8weQp9I7QVoefcVhwta9o1JsCBL3oCdpHE64Gz1900QlFs5HykdhrTd6w==
X-Received: by 2002:a17:902:8d81:: with SMTP id v1mr15928819plo.124.1570203887112;
        Fri, 04 Oct 2019 08:44:47 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id n66sm7289911pfn.90.2019.10.04.08.44.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 08:44:46 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
 <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
 <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
Date:   Fri, 4 Oct 2019 09:44:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/19 9:27 AM, Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 7:47 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 10/3/19 3:28 PM, Andrii Nakryiko wrote:
>>> Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
>>> they are installed along the other libbpf headers. Also, adjust
>>> selftests and samples include path to include libbpf now.
>>
>> There are side effects to bringing bpf_helpers.h into libbpf if this
>> gets propagated to the github sync.
>>
>> bpf_helpers.h references BPF_FUNC_* which are defined in the
>> uapi/linux/bpf.h header. That is a kernel version dependent api file
>> which means attempts to use newer libbpf with older kernel headers is
>> going to throw errors when compiling bpf programs -- bpf_helpers.h will
>> contain undefined BPF_FUNC references.
> 
> That's true, but I'm wondering if maintaining a copy of that enum in
> bpf_helpers.h itself is a good answer here?
> 
> bpf_helpers.h will be most probably used with BPF CO-RE and
> auto-generated vmlinux.h with all the enums and types. In that case,
> you'll probably want to use vmlinux.h for one of the latest kernels
> anyways.

I'm not following you; my interpretation of your comment seems like you
are making huge assumptions.

I build bpf programs for specific kernel versions using the devel
packages for the specific kernel of interest.

> 
> Nevertheless, it is a problem and thanks for bringing it up! I'd say
> for now we should still go ahead with this move and try to solve with
> issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> for someone, it's no worse than it is today when users don't have
> bpf_helpers.h at all.
> 

If this syncs to the github libbpf, it will be worse than today in the
sense of compile failures if someone's header file ordering picks
libbpf's bpf_helpers.h over whatever they are using today.
