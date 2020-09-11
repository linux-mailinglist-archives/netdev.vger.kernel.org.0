Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC06B266949
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgIKT7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgIKT7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 15:59:10 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC54C061573;
        Fri, 11 Sep 2020 12:59:09 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id n13so11283959edo.10;
        Fri, 11 Sep 2020 12:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2fvDataPFDcqtRjmyzwIGz+W24egsQT7RsA21OM+aw=;
        b=HUNvSNOCsAYMaMX6zn28qYgInmlDzu+yDJ7owLavD6xitvNjd6zk8e4l9dv0y3dMK4
         t5cBve4IXwgxailATJEBiqKerVMOGOvTBwH4Eu0y4D5JGUA12kVENN/Rm0bZbVi4PzBf
         /sLSP9NqN6Vr673cNVgytfCc5OePhjFxDZ1JQlTcPh/mjMU8fKpdS/2oYkQUdGW3oQQI
         prbGOOURjVSRMQXivNb/plEk4P5GZ/XXLHTDj/OkZzx5Be8z473wsDRJzopin+MnicXI
         oxv7Nm8BUBDBU3NYUbnJ6qUSxCjSGai+I1olA1qqRQ5C7jTzIjiJ36/tlGp6irXjbj33
         XF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B2fvDataPFDcqtRjmyzwIGz+W24egsQT7RsA21OM+aw=;
        b=r/ED/9HowdS640Svys1CtaCGY3CnJoItLI3kOUTUsjWHIeGG3b1UTiHIsk30egBZWL
         JyChLqRSaJZIVOgWD66466ZqQTe99JFb7c0TKDq/qOI0XYqMXOtZKw+5KcL+e9Qff8r6
         9Vd2uorUZHui7sjbRy8yNiQVVlk0MbQpj3QauCUTcajD+4fM4HuqM9U79veBM+SSkLNC
         v8FCW/stj4VmmfLAUeSsNpf4erAuRRE9206P5sQ6rfRAYUyKKPwQsSVVwYjZsK4JURHk
         NYbC7dwSUqg8LioOFg6teHZvlOhomYmvz/HgOpGhGjm3cphRFemjt4K7jOBNhy5OHmLU
         B+fw==
X-Gm-Message-State: AOAM531TQaQe/BvD+VQK7732iK0SwTgVFDerYJKxyu006w0doXZlVnuA
        24IWYFtyD/dH6Ngx98pnkEDmCz0I3+hQW69CCgguXTPu
X-Google-Smtp-Source: ABdhPJwTXXgJ/g+/XHWAyZTrQ3F0tE6i12N0C82M8zOxAL/IjsufylXhuRysYAjE1y/YpRKS8qx2oJQIPMSpawJWxJI=
X-Received: by 2002:a50:9355:: with SMTP id n21mr4015157eda.237.1599854348113;
 Fri, 11 Sep 2020 12:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200719021654.25922-1-jcmvbkbc@gmail.com> <202009111229.4A853F0@keescook>
In-Reply-To: <202009111229.4A853F0@keescook>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Fri, 11 Sep 2020 12:58:56 -0700
Message-ID: <CAMo8Bf+r3YvWewdHzg=Y4mFspYLA3GrJ04rry90deYsWN_gZRA@mail.gmail.com>
Subject: Re: [PATCH 0/3] xtensa: add seccomp support
To:     Kees Cook <keescook@chromium.org>
Cc:     "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, Chris Zankel <chris@zankel.net>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:38 PM Kees Cook <keescook@chromium.org> wrote:
> On Sat, Jul 18, 2020 at 07:16:51PM -0700, Max Filippov wrote:
> > Hello,
> >
> > this series adds support for seccomp filter on xtensa and updates
> > selftests/seccomp.
>
> Hi!
>
> Firstly, thanks for adding seccomp support! :) I would, however, ask
> that you CC maintainers on these kinds of changes for feedback. I was
> surprised to find the changes in the seccomp selftests today in Linus's
> tree. I didn't seem to get CCed on this series, even though
> get_maintainers shows this:
>
> $ ./scripts/get_maintainer.pl 0001-selftests-seccomp-add-xtensa-support.mbox
> Kees Cook <keescook@chromium.org> (supporter:SECURE COMPUTING)
> Andy Lutomirski <luto@amacapital.net> (reviewer:SECURE COMPUTING)
> Will Drewry <wad@chromium.org> (reviewer:SECURE COMPUTING)
> Shuah Khan <shuah@kernel.org> (maintainer:KERNEL SELFTEST FRAMEWORK)
> ...

Sorry about that. Looks like I've filtered out too much of the cc: list.
I'll fix my workflow.

> Regardless, I'm still glad to have more arch support! :) I'll send a
> follow-up patch to refactor a bit of the selftest.

-- 
Thanks.
-- Max
