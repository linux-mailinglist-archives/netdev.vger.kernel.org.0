Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19958F537
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiHKA0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 20:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHKA03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 20:26:29 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00A874367;
        Wed, 10 Aug 2022 17:26:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x64so13569441iof.1;
        Wed, 10 Aug 2022 17:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=52hp91B4o6nctmi+AsMxs5+KDTzl/WmhmAFz8/MIyO8=;
        b=dDGa+Qwz8mCmY2TmXJMA83qpGLhEMolwQKzllwhArJrLqKH758YGEe2g5eSvz+6Y3h
         ih63pohWsDK1LVUKnPqz+AMx3QhNpBaigoweKA8EqRcwrV4UqIkWfRn9BLz3JhODisjh
         U3u0Vv1zEHCtGpxJUKyA/visum/Z2/MxEd+fSAIKYDkMrhac2whVsh8P5d4REL+mjiPj
         Qjhq04zgQtu7AifOY3ATpFwdZnmGRkP+L7p3QTQviT80ipeUb4+4tSqHHR9wMtUgDZCn
         vJcVRyA16bKMlXnuXyuCHndQr53PHvI2hALBixnAvZ1mX8FijtCMn3Mq8zRzI8TIYk2D
         6tvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=52hp91B4o6nctmi+AsMxs5+KDTzl/WmhmAFz8/MIyO8=;
        b=m8VeFLVen4GpmsHgcbt1fZ/RIoF3MXJHzq/SYuMql3r/zjoZnYlYe7dF2A+cj21vEg
         bSUgTvMW7y2SKz4MK4fKw7rmsErpdT74FNf9Chk5GSIvNQcz+MrvLjy7oZhreLJcGeSS
         yU4qHsyzjJAq3iIGtdhVzAZib5bOBCmbC6qB7Ap309GSKhm8P9nOd3khaPWKZVweG8v3
         LslQHTZWwKxhMy9m8uzU7hnMLsjeuipNFkzFGO+oRwPFpwW1nONb/gqHrAPvIGbg3IyI
         smP3sx6U60Kko3Eh8geu5oKcyxDCY1d4EBnJB6h/l/kNKLclkYUQ4jlnHcwFXzwL1GIb
         whHA==
X-Gm-Message-State: ACgBeo17moqMnEZPe0OtxGpNnIZESwY9zItTHkV+8OLWRdM0dEPMHvo1
        XovE7q00kE/JvL2Q/BWlhcdVyh6rJTAYCU+gp6s=
X-Google-Smtp-Source: AA6agR6DsMDCdJeapz0WBl/syPB6ijuEbr1lhiarDGdRh9X+4I+zvtKXZdBqrPsy9smZ+wdvIrvRbGCzFhCsYNKz5AA=
X-Received: by 2002:a05:6638:238b:b0:343:ff4:a62 with SMTP id
 q11-20020a056638238b00b003430ff40a62mr7319334jat.124.1660177588008; Wed, 10
 Aug 2022 17:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1660173222.git.dxu@dxuuu.xyz>
In-Reply-To: <cover.1660173222.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Thu, 11 Aug 2022 02:25:51 +0200
Message-ID: <CAP01T74aWUW-iyPCV_VfASO6YqfAZmnkYQMN2B4L8ngMMgnAcw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/3] Add more bpf_*_ct_lookup() selftests
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, fw@strlen.de,
        "toke@redhat.com" <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 at 01:16, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> This patchset adds more bpf_*_ct_lookup() selftests. The goal is to test
> interaction with netfilter subsystem as well as reading from `struct
> nf_conn`. The first is important when migrating legacy systems towards
> bpf. The latter is important in general to take full advantage of
> connection tracking.
>

Thank you for contributing these tests. Feel free to add:
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

People often look at selftests for usage examples these days, so it's
great to have coverage + examples for more use cases.

> I'll follow this patchset up with support for writing to `struct nf_conn`.
>

Please also cc netfilter-devel, netdev, Pablo, and Florian when you send it.

I think we can directly enable stores to ct->mark, since that is what
ctnetlink is doing too, so adding another helper for this would be
unnecessary overhead.


> Past discussion:
> - v2: https://lore.kernel.org/bpf/cover.1660062725.git.dxu@dxuuu.xyz/
> - v1: https://lore.kernel.org/bpf/cover.1659209738.git.dxu@dxuuu.xyz/
>
> Changes since v2:
> - Add bpf-ci kconfig changes
>
> Changes since v1:
> - Reword commit message / cover letter to not mention connmark writing
>
>
> Daniel Xu (3):
>   selftests/bpf: Add existing connection bpf_*_ct_lookup() test
>   selftests/bpf: Add connmark read test
>   selftests/bpf: Update CI kconfig
>
>  tools/testing/selftests/bpf/config            |  2 +
>  .../testing/selftests/bpf/prog_tests/bpf_nf.c | 60 +++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_bpf_nf.c | 21 +++++++
>  3 files changed, 83 insertions(+)
>
> --
> 2.37.1
>
