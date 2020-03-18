Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC1418A896
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgCRWt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:49:59 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54174 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRWt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 18:49:57 -0400
Received: by mail-pj1-f67.google.com with SMTP id l36so86183pjb.3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 15:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Od0623i0mOnU6GdQVJb7G33/cJXn+fiCsgtOaGr94Sc=;
        b=bcKJVTdDT1JYpAewJcI4hblrF5mrr8fLrj0Q+zYBD5Uw46ZRSS1eSuIvn1zGGCJX8j
         SOV0kiOl5ftcdJSag/uKO0OCTOGF63UpwInY0LkztaIvEL5frUqdESp7Ad3hNw2smQ06
         DIWQct2GSiEHpZDBNxisWVtOZlxXfvdS/Kmps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Od0623i0mOnU6GdQVJb7G33/cJXn+fiCsgtOaGr94Sc=;
        b=anCb9b5+86dGcKS+Hv6T0zghbpUTO4LTm8VRD7GdeoZv+PBmNWJfrYSD4G1b5YdZB0
         1JyeuRE4wKTvLiPEJNRR0t5rBmCJj+DpF5OfWGz/p7VOUx2QN/0L4wUHYqK3okzFUAtT
         gYpcf40QHhrWvm7ChLUS86p+A3o+xsyS5nzn6GkOeR/p4Qq7E0m8UTxU7ISd2Jyid/cr
         gsBJ99QjVFpSwkeIje5PCIozr8GwcOqQbIhU/fHPS079i5yFnhKFIjnaKtBMbNTS8qwh
         zfTdMpMaStZ72rWnppZRk6r9cVGFfH8LM3NczcVYIh+AhtJ1vvx8Vv2G76EvJEh26VKZ
         2UXg==
X-Gm-Message-State: ANhLgQ1eWAupTQF04SzAgyP11t1EYictJy969Ygn3xwlGLBmVSr+OAPA
        iUZanwirOwJ2gqtj8xXIIb88Ig==
X-Google-Smtp-Source: ADFU+vtadZ73ag69PyW66TRpU3y2R+cMnQ1BUGAlWtlcfWsNxCHY1Q0/k9GwNr37EIwluqLR26yKtg==
X-Received: by 2002:a17:90a:cf86:: with SMTP id i6mr511077pju.158.1584571795086;
        Wed, 18 Mar 2020 15:49:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e14sm71844pfn.196.2020.03.18.15.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 15:49:54 -0700 (PDT)
Date:   Wed, 18 Mar 2020 15:49:53 -0700
From:   Kees Cook <keescook@chromium.org>
To:     shuah@kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com
Subject: Re: [PATCH v5 0/5] kselftest: add fixture parameters
Message-ID: <202003181548.930237FD6@keescook>
References: <20200318010153.40797-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318010153.40797-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 06:01:48PM -0700, Jakub Kicinski wrote:
> Shuah please consider applying to the kselftest tree.

Just to confirm: yes please. Shuah, I'd love to see this land.

-Kees

> 
> This set is an attempt to make running tests for different
> sets of data easier. The direct motivation is the tls
> test which we'd like to run for TLS 1.2 and TLS 1.3,
> but currently there is no easy way to invoke the same
> tests with different parameters.
> 
> Tested all users of kselftest_harness.h.
> 
> v2:
>  - don't run tests by fixture
>  - don't pass params as an explicit argument
> 
> v3:
>  - go back to the orginal implementation with an extra
>    parameter, and running by fixture (Kees);
>  - add LIST_APPEND helper (Kees);
>  - add a dot between fixture and param name (Kees);
>  - rename the params to variants (Tim);
> 
> v4:
>  - whitespace fixes.
> 
> v5 (Kees):
>  - move a comment;
>  - remove a temporary variable;
>  - reword the commit message on patch 4.
> 
> v1: https://lore.kernel.org/netdev/20200313031752.2332565-1-kuba@kernel.org/
> v2: https://lore.kernel.org/netdev/20200314005501.2446494-1-kuba@kernel.org/
> v3: https://lore.kernel.org/netdev/20200316225647.3129354-1-kuba@kernel.org/
> v4: https://lore.kernel.org/netdev/20200317010419.3268916-1-kuba@kernel.org/
> 
> Jakub Kicinski (5):
>   kselftest: factor out list manipulation to a helper
>   kselftest: create fixture objects
>   kselftest: run tests by fixture
>   kselftest: add fixture variants
>   selftests: tls: run all tests for TLS 1.2 and TLS 1.3
> 
>  Documentation/dev-tools/kselftest.rst       |   3 +-
>  tools/testing/selftests/kselftest_harness.h | 234 +++++++++++++++-----
>  tools/testing/selftests/net/tls.c           |  93 ++------
>  3 files changed, 202 insertions(+), 128 deletions(-)
> 
> -- 
> 2.25.1
> 

-- 
Kees Cook
