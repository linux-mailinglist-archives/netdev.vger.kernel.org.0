Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB5E28E63
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 02:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731692AbfEXAkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 20:40:39 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:34512 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbfEXAki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 20:40:38 -0400
Received: by mail-it1-f193.google.com with SMTP id g23so9612513iti.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 17:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+OWj9mDOvKZpZvD/0cO4IJ9ScOtv54mzTwoPrWSLVk=;
        b=b/bGmFPWYGP4UvuZ1E48HFMgo07QCrEyQbZPDBklpam9Sc7WKh1yhbfeHaYCmBT+77
         AbBMxvDdCsRxqIcETVTjgG+Trh1qDZecl/z+FFbJHj9IWEoBUHubTR93I75I+dzc9GTd
         ZoYE1KEUjO7UBHPQZrj+JvUXjxhQuVzkWI3h0qTJLlN8hg9NmIHtt8LO6X/Goly6eTTF
         rp+yFz7lZGvwYaJPFdqeFbhvpozSjFUxxjqMgLKPIddYiDU6uIadezQYoPUtt+ZizDR2
         La889zKaXRU0BczmNUEtgxHYjMcGnhRiWmHP7hcinmr6hj+sBZsieSJlVYWqjCdssJGb
         3kyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+OWj9mDOvKZpZvD/0cO4IJ9ScOtv54mzTwoPrWSLVk=;
        b=Nrie1HenSN1IRk67WidkjNyjWFBOqybKHwFbfM8MJ5VhDhVPkDkuWaBMqUtFLf8/rX
         GRBjI6tX5f8sPDHhHPbZ7lsBPty3q/HVl4Ed5z5P24+DiCwZE6wvMvs2Sul5JJ9JqrXD
         hseQGiqCNJaL0eoaPvwWBh3Yzxhz9uIAXwZnwNKFKX5b4OgyGwWGop1dcSrBKv1FEwTp
         /TknL8M8ap5SyyeNYOQFu4sey72GC6S09pjW/13IBr87S5aVGezdDkUUGRF1zWxoOCli
         hMRI0k0rE6/ai+iw21qU5MQKA2rxpG8haSnBFegavBzJMCiTq2UatSFI8jEiS5wB0+nM
         ricw==
X-Gm-Message-State: APjAAAUEqRvW65Dgiy4mJGUbRJ9088Qy6PRpMIK2dbz9m2Jx0snbJqVj
        EDd3pJtOmwM9vZFyc/I37p94VOeT/XKz3pGhDOg=
X-Google-Smtp-Source: APXvYqxLNJE0AsurMjJjqDIzTcAcLF/IGPFrLCrwFmkHk9shhXoT+7TRwgF+HJs0qri3YmVKBqjBcIZO9V4g218onjs=
X-Received: by 2002:a24:7bcc:: with SMTP id q195mr15075045itc.73.1558658437961;
 Thu, 23 May 2019 17:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190523072448.25269-1-danieltimlee@gmail.com>
In-Reply-To: <20190523072448.25269-1-danieltimlee@gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 23 May 2019 17:40:01 -0700
Message-ID: <CAH3MdRXSJiZN_3xnoag0CfYFXgnw4_h+Fay9u7LQ99b8_0aEKg@mail.gmail.com>
Subject: Re: [PATCH v2] samples: bpf: fix style in bpf_load
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 12:26 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit fixes style problem in samples/bpf/bpf_load.c
>
> Styles that have been changed are:
>  - Magic string use of 'DEBUGFS'
>  - Useless zero initialization of a global variable
>  - Minor style fix with whitespace
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
