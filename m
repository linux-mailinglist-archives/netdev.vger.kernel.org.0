Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB7277A19
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIXUWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXUWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:22:13 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF34CC0613CE;
        Thu, 24 Sep 2020 13:22:13 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k18so388128ybh.1;
        Thu, 24 Sep 2020 13:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wJrUIfsuskPuQFMQCCUj+xN+JyZhp2lIK2HyGhVyUY=;
        b=dL/WIYLVJbUe/52KTyIKBkxLfKuTK/dUBW7KhstJPiocpZChxzuXbG/u7tIkQDBJcW
         C3iviQXnJsuDGCTUA9EemXVRGc0K+Ub1/tEFS15lPRzaB1vNdNWtJXs38b3AuM3FUjG5
         G9hPV49h8IOjnYvlLZemLUNgsKJBbO39d9hD66mQqxd1nv8h0or/Aaok4g87Z1IYEc8x
         X6WgHLu2V5z7Z3H6MXn6flw2PWn4CPd1SOP1MJNNuxH7FjMPn8RGGm95mRvNnn/tBcap
         8P2wl/RYAAOFoTWytnhaHhSqXkZJDAy6f7NwU98fzlPVYodkzq8+TAfR0e/sIXGWmn9b
         8t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wJrUIfsuskPuQFMQCCUj+xN+JyZhp2lIK2HyGhVyUY=;
        b=GXFLLP3OM9WSJTwTwsDdotj9taoI8rw/iZZVp8c/PXsxZYh70+Zen839FfWVj7MsUV
         d3TeuG/OgTbC4CtJSr9TEW5UuPQMVn36n6loSrApakGrT38LWbmOy6yrGDuctSIa9YSa
         k1kbSgZva4Mln7EhcYfr8M9Kj9NGy5V3mJaD5Q2gv3eANclWojEiSmEHrDc1Q++yh8/6
         /9EfYkrydrNOxZVBzhfJursh357ah2aueTvSXJOF+p8rox+m/GT3rUgX841PVUncAXlk
         SlJmQkafyKHyV7kLfaT29XwdxPVMk2SWApTgWU6ZlO+0x8rHAKSs83Pxz3bhck1Rq9Rl
         NusQ==
X-Gm-Message-State: AOAM530fkUgdBA6MQLC+/akUxNNLb4okfRBRqn1PvB2RWOFKuDKOAs/B
        mHmT6cYgEDbHAMyW0/fWu2WufNXqf6jAzhsXTiI=
X-Google-Smtp-Source: ABdhPJzrRdstStRLbaQ3WwbDyUTv8ro9BBlbdrsbXuv+M0vI0C0SXjWqUG9IToHW1KjbCjx7DKZRxtfjeWqyJndhfTg=
X-Received: by 2002:a25:2687:: with SMTP id m129mr698485ybm.425.1600978932997;
 Thu, 24 Sep 2020 13:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200924022557.16561-1-bimmy.pujari@intel.com> <20200924022557.16561-2-bimmy.pujari@intel.com>
In-Reply-To: <20200924022557.16561-2-bimmy.pujari@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:22:02 -0700
Message-ID: <CAEf4BzZ7Srd2k5a_t6JKW9_=cUQVqvxXhd+4rvbpMHKRJAQbiw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: Verifying real time helper function
To:     "Pujari, Bimmy" <bimmy.pujari@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        mchehab@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 7:26 PM <bimmy.pujari@intel.com> wrote:
>
> From: Bimmy Pujari <bimmy.pujari@intel.com>
>
> Test xdping measures RTT from xdp using monotonic time helper.
> Extending xdping test to use real time helper function in order
> to verify this helper function.
>
> Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
> ---

This is exactly the use of REALTIME clock that I was arguing against,
and yet you are actually creating an example of how to use it for such
case. CLOCK_REALTIME should not be used to measuring time elapsed (not
within the same machine, at least), there are strictly better
alternatives.

So if you want to write a test for a new helper (assuming everyone
else thinks it's a good idea), then do just that - write a separate
minimal test that tests just your new functionality. Don't couple it
with a massive XDP program. And also don't create unnecessarily almost
400 lines of code churn.

>  .../testing/selftests/bpf/progs/xdping_kern.c | 183 +----------------
>  .../testing/selftests/bpf/progs/xdping_kern.h | 193 ++++++++++++++++++
>  .../bpf/progs/xdping_realtime_kern.c          |   4 +
>  tools/testing/selftests/bpf/test_xdping.sh    |  44 +++-
>  4 files changed, 235 insertions(+), 189 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xdping_kern.h
>  create mode 100644 tools/testing/selftests/bpf/progs/xdping_realtime_kern.c
>

[...]
