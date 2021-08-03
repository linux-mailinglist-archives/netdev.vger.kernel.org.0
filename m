Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603993DF3A5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbhHCRLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbhHCRLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:11:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E649C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 10:11:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mt6so30531224pjb.1
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aih7+/cM7TQV1ZnxWK5dJhJ8s3jYxCsjmRJVslTNvNg=;
        b=jhA6wwHOtweuFGWFuJ+1zGrhxlyb3rT2i48C0KSECtENlhBh9BCCCQjnjjj6p2XOV0
         hYvWJ3b0W++D1aNVtgwwtG7FajHesQa5i+CC2PENKn7CFIWeV7n4QyTDAKgW10SgdlaA
         MQ6/b6tSRBUneOlN/LJd+y7uE8nEvQMKDVHatSMK9bf8psQLp88A2OJFm7X+oXvXbXwl
         Sty99cvJ3i9e+Fc8WNnh6VN7KBpILCH8Jd+72b60EWkaifO8d3zT52m00UiK/S2Ru4v7
         OGUun1ugyY1sI+hhZUHjJxLBwyX/5iYf5CjYrDEOj4BEzH+jKdOZ8DM/NQu/7bB6Qmbg
         VDDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aih7+/cM7TQV1ZnxWK5dJhJ8s3jYxCsjmRJVslTNvNg=;
        b=FoKJbsc5e33K0tPhl6Aqc3rCNwMf/37cvBt1JJRa5fD6O156OFMkOyfkanWJpR5STt
         Yz8gLf5QsoV1PnAL1P7pB7/vc8VMNqJEemFK0UIUCWWMriEQf54mu4lhLYeYb5NYmdYj
         wFEYkVPz+cWthgRFVgo7ooDXyviMcA3ccNYItGVg9mpcR0vQRebLTrkA3IDMO14bgt00
         MVWP9bl6bWD57RCWAQusj3Hq/Obr9wjQFjbm4P9qqzEU6batsTbptd/12mVWup4FY3ss
         NZDrKyV3kVEueT1ZRnYL9wBhm5xixSLG48BEdACjpFGt400hTloPRN52GdxwPjPv2eOw
         QHqg==
X-Gm-Message-State: AOAM53017qELUASgUyaLJPb8nb9iHl+27kWK7rabov0XYzt169xDCy81
        3STggoY8ZA58ccCZo6+WON4SHBH7Xj8B0LWo4YA=
X-Google-Smtp-Source: ABdhPJx1IUtbmU3Ob6MVnZHzeh6SJMgKnw02CGbZaN+hswkgPuSFPtw00ujKwpBgHqqkuThcoaMLK4FM6smdFg9pQ/Y=
X-Received: by 2002:a62:ea1a:0:b029:329:a95a:fab with SMTP id
 t26-20020a62ea1a0000b0290329a95a0fabmr23717535pfh.31.1628010684976; Tue, 03
 Aug 2021 10:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210803123921.2374485-1-kuba@kernel.org>
In-Reply-To: <20210803123921.2374485-1-kuba@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 3 Aug 2021 10:11:13 -0700
Message-ID: <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> This reverts commit d4861fc6be581561d6964700110a4dede54da6a6.
>
> netdevsim is for enabling upstream tests, two weeks in
> and there's no sign of upstream test using the "mutli-queue"
> option.

Since when netdevsim is *only* for upstream tests? Even if so,
where is this documented? And why not just point it out when
reviewing it instead of silently waiting for weeks?

>
> We can add this option back when such test materializes.
> Right now it's dead code.

It is clearly not dead. We internally used it for testing sch_mq,
this is clearly stated in the git log. How did you draw such a
conclusion without talking to authors?

But this does remind me of using netdevsim for tc-testing.

Thanks.
