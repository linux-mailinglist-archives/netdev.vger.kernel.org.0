Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD416A6BF5
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 12:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCALzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 06:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCALzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 06:55:38 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970C33B875
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 03:55:33 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id x12so34585ybt.7
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 03:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1677671733;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j6mSiJh/AyCpPx2g2QCE9NQtVI4mousajRdjDpx0b/0=;
        b=tC3WfsOgHeKuMxS5JkwPBaS48nuuRwFlXDALyUWPm489Gpe4xprIhtu0utFckUXY0A
         nQk+Kt09PhiyF8H4p4lea0jpJQxQfQepNVqDI0J9d+nMq5RWVDT11D88MVBk5iyO3iWn
         ueqnEDaxppKK66mulFto4u/BPF5ZsZ3NM7rRomV3XzKvMv6s5PrN6NyG14IzHjjzAnow
         h5I3sb68oBCWbh6IKTvUAk2Wk8jQ8h1COQcVgKVYjQd/LW36FV5F0dElbgzUUi2mayfD
         XZfQAW5cfW9RjhOpeRh+4NqxDjAlLJ0FbysP8y41QneaoiRmHgn2/9ftyMtRbiCy3QKA
         ywoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677671733;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j6mSiJh/AyCpPx2g2QCE9NQtVI4mousajRdjDpx0b/0=;
        b=crWMmL21lhTGwp/GLJWqrZLe/4BoDobDY/SkewDLOd9Nt18TPRRcPXNQyKFvJxUfCb
         zqS8T/zpO9ZvenDJwlDHP17F6GlcguAyr5V6frJDjmzqUlc3QO/vGI5Y4+HJxRwQG4Hx
         4d2b/tK33yNim/z9a3B3oJURJ0K31EClibmZ+SjR24SOP4MT+LSJz9nsuacwDXrHZLoI
         0fyu22uCa+f794S3NQUTlCkMQNhTAHja1R/1HbqEfJMQue6awy5ACJ79CpcAkopHsH+c
         nN6wNxdw8L2pH6JSVY+jMbcur3wMpciStKd3brfAoMWGANqIGBGsBj91Vj+rgFBPbM+j
         TQvg==
X-Gm-Message-State: AO0yUKXgyDBle1QzTxFSbPwDqIHfZIGV/k6jhb5FC8lT6Cx9ZRUYNK/F
        8MpO2MFSF7Xw7sZgVGcw1KhmtJomLXFROM0PzJhPX/y74++5SA==
X-Google-Smtp-Source: AK7set/09BBl3DuL44vI86hqCWhaCWpTVtHw4zG5yht17aQ0z4h5AmVD5nLbRso6VaZK8wZV9xv5CGT2lvD2m85VhSU=
X-Received: by 2002:a5b:54b:0:b0:9f2:a1ba:6908 with SMTP id
 r11-20020a5b054b000000b009f2a1ba6908mr2685912ybp.12.1677671732738; Wed, 01
 Mar 2023 03:55:32 -0800 (PST)
MIME-Version: 1.0
References: <20230228034955.1215122-1-liuhangbin@gmail.com>
 <CAM0EoM=-sSuZbgjEH_KH8WTqTXYSagN0E6JLF+MKBFDSG_z9Hw@mail.gmail.com> <Y/7CIiBcHabfFaD6@Laptop-X1>
In-Reply-To: <Y/7CIiBcHabfFaD6@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 1 Mar 2023 06:55:21 -0500
Message-ID: <CAM0EoMmNUB0jD1LqrAqX90jC+U03RtUCUb9GHxrNWNGweQCgYA@mail.gmail.com>
Subject: Re: [PATCH iproute2] u32: fix TC_U32_TERMINAL printing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 10:10 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Feb 28, 2023 at 05:55:30AM -0500, Jamal Hadi Salim wrote:
> > Hangbin,
> > Can you please run tdc tests on all tc (both for iproute2 and kernel)
> > changes you make and preferably show them in the commit log? If you
> > introduce something new then add a new tdc test case to cover it.
>
> OK, the patch fixed an issue I found when run tdc u32 test.
>
> 1..11
> not ok 1 afa9 - Add u32 with source match
>         Could not match regex pattern. Verify command output:
> filter protocol ip pref 1 u32 chain 0
> filter protocol ip pref 1 u32 chain 0 fh 800: ht divisor 1
> filter protocol ip pref 1 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 *flowid 1:1 not_in_hw
>   match 7f000001/ffffffff at 12
>         action order 1: gact action pass
>          random type none pass val 0
>          index 1 ref 1 bind 1
>
> After the fix, the u32.json test passed
>
> All test results:
>
> 1..11
> ok 1 afa9 - Add u32 with source match
> ok 2 6aa7 - Add/Replace u32 with source match and invalid indev
> ok 3 bc4d - Replace valid u32 with source match and invalid indev
> ok 4 648b - Add u32 with custom hash table
> ok 5 6658 - Add/Replace u32 with custom hash table and invalid handle
> ok 6 9d0a - Replace valid u32 with custom hash table and invalid handle
> ok 7 1644 - Add u32 filter that links to a custom hash table
> ok 8 74c2 - Add/Replace u32 filter with invalid hash table id
> ok 9 1fe6 - Replace valid u32 filter with invalid hash table id
> ok 10 0692 - Test u32 sample option, divisor 256
> ok 11 2478 - Test u32 sample option, divisor 16
>
>
> When I post the patch, I though this issue is a clear logic one, so I didn't
>  paste the test result.
>

I think we should make it a rule to run tdc going forward. Your last
submission's issue that Pedro fixed would have been trivially found
with tdc. My suggestion is to repost the patch including the tdc test
in the commit message.

cheers,
jamal

> Thanks
> Hangbin
