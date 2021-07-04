Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180CD3BAECD
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhGDU2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 16:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhGDU2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 16:28:50 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458DDC061762
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 13:26:13 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t17so28702563lfq.0
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 13:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sharpeleven-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wlUnqqhwGO2ss5CdIs4O+XCoeOXjYNdtyzXcVD3xri0=;
        b=XgKgDo6l95RCCdzJlIBW/z4zT5vKBNadDp8QG5dOQjynV0boSEhPF0UrBcurESS5Wq
         /X3IB2crM3pzM5qfh/JLt+LNIAQNGZOMOC1Od+DhnZkYZ3wkdAeL57Miz81y/A7ou/wE
         8MyBDCwpg0p25eCclaO0UhbvyN9T1LkQkUyBhVPYJUt5hoirEt8SS237XRHjNCoH4Szp
         Hon7C3jCttNWS6nbQZLsGHQYqLs5odKq/iJYB7y4q+gSWHqsjMSN5xzTktuJ7EVEmOHn
         aDJJDUpRAk9siQDdYqLCtQoa2OMuBs1VVvZORi0nEdwEZSOnVWEqmgJpLjiDjnWyB5yP
         XyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wlUnqqhwGO2ss5CdIs4O+XCoeOXjYNdtyzXcVD3xri0=;
        b=lk1WJRqIJ97cFmruzIp1oIKc2cITRY7ukIJaihxdR7H6fxSztvjMmkGmjMvmjEK15E
         VQ1f2PlqI8rIQJ1Em+hz/JQfeChR0IbhXIJLX72/KH1hc/+Td4DdV2z2hceeLsoy2GrF
         XjF5xGNbKzNdSL4v7vy/gjVduDJXk/7+3cWuytIZzX/iAWWJfz5vps42Q69quUxbazkR
         t4AYwImLQcp6i6Ids5x8M7mgMN/XZorfPfoW6FSHi0wIkYw4ue9Qku3iXbfzCsLAF3Xc
         eK5jqBopP5yIXqL6ujPn7NJ6fNYSykdQUHfDhDela91lM3NdrcinuM2FzGMznc1qbm+J
         J67Q==
X-Gm-Message-State: AOAM530auLIpxeM0V1eAMTpjXH+olx9AIA/dHe7uvvI9pfk0LUmnC9XX
        F8FHWxEICJ84/1Zgk9wfSe/xVj6owFGZ1yMmTURiXQ==
X-Google-Smtp-Source: ABdhPJzT4kCTCfR+J5F2nu+OMI1Ah16dq9+EEowoXNfH4FF0nxjuR02KGz8ayP4IUw9c584xVK5UlyqW6aRMgEVaF1E=
X-Received: by 2002:ac2:55a7:: with SMTP id y7mr7943415lfg.179.1625430371579;
 Sun, 04 Jul 2021 13:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210702050543.2693141-1-mcgrof@kernel.org> <20210702050543.2693141-2-mcgrof@kernel.org>
 <YN6iSKCetBrk2y8V@kroah.com> <20210702190230.r46bck4vib7u3qo6@garbanzo>
 <YN/rtmZbd6velB1L@kroah.com> <20210703155203.uvxcolrddswecco6@garbanzo>
In-Reply-To: <20210703155203.uvxcolrddswecco6@garbanzo>
From:   Richard Fontana <fontana@sharpeleven.org>
Date:   Sun, 4 Jul 2021 16:26:00 -0400
Message-ID: <CAGT84B1fdypvndxk97wS59=5VgQ80LhWxxs_Yx33169P9WvKZg@mail.gmail.com>
Subject: Re: [PATCH 1/4] selftests: add tests_sysfs module
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, tj@kernel.org,
        shuah@kernel.org, akpm@linux-foundation.org, rafael@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 On Sat, Jul 3, 2021 at 11:52 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> We don't have spdx license tag yet for copyleft-next,

https://spdx.org/licenses/copyleft-next-0.3.0.html
https://spdx.org/licenses/copyleft-next-0.3.1.html

Richard
